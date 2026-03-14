import Foundation

struct SportMonksLiveScoreService: LiveScoreService {
    private let session: URLSession
    private let token: String
    private let decoder: JSONDecoder

    init(token: String, session: URLSession = .shared) {
        self.token = token
        self.session = session

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Self.dateFormatter)
        self.decoder = decoder
    }

    func fetchDashboard() async throws -> LiveScoreSnapshot {
        async let liveFixtures: [SportMonksFixture] = fetchList(
            path: "livescores",
            queryItems: [URLQueryItem(name: "include", value: "participants;scores;statistics.type;league;venue;state")]
        )

        let date = Self.apiDateFormatter.string(from: .now)
        async let todayFixtures: [SportMonksFixture] = fetchList(
            path: "fixtures/date/\(date)",
            queryItems: [URLQueryItem(name: "include", value: "participants;scores;statistics.type;league;venue;state")]
        )

        let live = try await liveFixtures.map { $0.asMatch() }
        let today = try await todayFixtures.map { $0.asMatch() }

        let liveIDs = Set(live.map(\.id))
        let upcoming = today
            .filter { $0.state != .live && !liveIDs.contains($0.id) }
            .sorted { ($0.kickoff ?? .distantFuture) < ($1.kickoff ?? .distantFuture) }

        let leagueCards = makeLeagueSpotlights(from: live + upcoming)

        return LiveScoreSnapshot(
            liveMatches: live,
            upcomingMatches: Array(upcoming.prefix(12)),
            leagues: Array(leagueCards.prefix(6))
        )
    }

    private func fetchList<T: Decodable>(path: String, queryItems: [URLQueryItem]) async throws -> [T] {
        var components = URLComponents(string: "https://api.sportmonks.com/v3/football/\(path)")
        components?.queryItems = queryItems + [URLQueryItem(name: "api_token", value: token)]

        guard let url = components?.url else {
            throw LiveScoreServiceError.invalidResponse
        }

        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, 200 ..< 300 ~= httpResponse.statusCode else {
            throw LiveScoreServiceError.invalidResponse
        }

        let payload = try decoder.decode(SportMonksListResponse<T>.self, from: data)
        return payload.data
    }

    private func makeLeagueSpotlights(from matches: [Match]) -> [LeagueSpotlight] {
        Dictionary(grouping: matches, by: \.league)
            .map { league, fixtures in
                let sortedFixtures = fixtures.sorted { ($0.kickoff ?? .distantFuture) < ($1.kickoff ?? .distantFuture) }
                let featured = sortedFixtures.first ?? fixtures[0]
                let summary = fixtures.contains(where: { $0.state == .live })
                    ? "Live updates are flowing for this competition right now."
                    : "Upcoming fixtures are loaded from the live feed for today."

                return LeagueSpotlight(
                    id: league,
                    name: league,
                    season: "Live feed",
                    featuredMatch: featured,
                    standings: [],
                    update: summary
                )
            }
            .sorted { lhs, rhs in
                let lhsHasLive = lhs.featuredMatch.state == .live
                let rhsHasLive = rhs.featuredMatch.state == .live
                if lhsHasLive != rhsHasLive {
                    return lhsHasLive && !rhsHasLive
                }
                return lhs.name < rhs.name
            }
    }

    private static let apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}

private struct SportMonksListResponse<T: Decodable>: Decodable {
    let data: [T]
}

private struct SportMonksFixture: Decodable {
    let id: Int
    let name: String?
    let startingAt: Date?
    let resultInfo: String?
    let participants: [SportMonksParticipant]?
    let scores: [SportMonksScore]?
    let statistics: [SportMonksStatistic]?
    let league: SportMonksLeague?
    let venue: SportMonksVenue?
    let state: SportMonksState?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case startingAt = "starting_at"
        case resultInfo = "result_info"
        case participants
        case scores
        case statistics
        case league
        case venue
        case state
    }

    func asMatch() throws -> Match {
        let home = participants?.first(where: { $0.meta?.location == "home" })
        let away = participants?.first(where: { $0.meta?.location == "away" })

        let homeTeam = Team(
            id: String(home?.id ?? 0),
            name: home?.name ?? "Home",
            shortName: home?.shortCode ?? String((home?.name ?? "HOME").prefix(3)).uppercased(),
            record: participantRecord(for: home),
            accent: "orange"
        )

        let awayTeam = Team(
            id: String(away?.id ?? 0),
            name: away?.name ?? "Away",
            shortName: away?.shortCode ?? String((away?.name ?? "AWAY").prefix(3)).uppercased(),
            record: participantRecord(for: away),
            accent: "blue"
        )

        return Match(
            id: String(id),
            league: league?.name ?? "Football",
            venue: venue?.name ?? "Venue TBA",
            minute: minuteText,
            state: matchState,
            home: homeTeam,
            away: awayTeam,
            homeScore: goals(for: "home"),
            awayScore: goals(for: "away"),
            headline: resultInfo ?? name ?? "\(homeTeam.name) vs \(awayTeam.name)",
            kickoff: startingAt,
            stats: topStats
        )
    }

    private func goals(for location: String) -> Int {
        let rankedDescriptions = ["CURRENT", "FT", "2ND_HALF_ONLY", "1ST_HALF_ONLY", "ET", "PENALTY_SHOOTOUT"]

        for description in rankedDescriptions {
            if let match = scores?.first(where: { $0.score?.participant == location && $0.description == description }) {
                return match.score?.goals ?? 0
            }
        }

        return scores?.first(where: { $0.score?.participant == location })?.score?.goals ?? 0
    }

    private var topStats: [MatchStat] {
        let grouped = Dictionary(grouping: statistics ?? [], by: \.type?.name)

        return grouped.compactMap { label, values in
            guard let label else {
                return nil
            }

            let home = values.first(where: { $0.location == "home" })?.displayValue ?? "-"
            let away = values.first(where: { $0.location == "away" })?.displayValue ?? "-"

            return MatchStat(
                id: label,
                label: label,
                homeValue: home,
                awayValue: away
            )
        }
        .sorted { $0.label < $1.label }
        .prefix(3)
        .map { $0 }
    }

    private var minuteText: String {
        if let shortName = state?.shortName, !shortName.isEmpty {
            return shortName
        }

        guard let startingAt else {
            return "TBD"
        }

        return startingAt.formatted(date: .omitted, time: .shortened)
    }

    private var matchState: MatchState {
        let stateName = state?.name?.lowercased() ?? ""
        let stateShort = state?.shortName?.lowercased() ?? ""

        if stateName.contains("live") || stateName.contains("inplay") || stateShort.contains("'") || stateShort == "ht" {
            return .live
        }

        if stateName.contains("finished") || stateName.contains("full time") || stateName.contains("ended") {
            return .finished
        }

        return .upcoming
    }

    private func participantRecord(for participant: SportMonksParticipant?) -> String {
        if let position = participant?.meta?.position {
            return "Table position \(position)"
        }

        return "Live team data"
    }
}

private struct SportMonksParticipant: Decodable {
    let id: Int
    let name: String
    let shortCode: String?
    let meta: SportMonksParticipantMeta?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case shortCode = "short_code"
        case meta
    }
}

private struct SportMonksParticipantMeta: Decodable {
    let location: String?
    let winner: Bool?
    let position: Int?
}

private struct SportMonksScore: Decodable {
    let description: String?
    let score: SportMonksScoreValue?
}

private struct SportMonksScoreValue: Decodable {
    let goals: Int?
    let participant: String?
}

private struct SportMonksStatistic: Decodable {
    let location: String?
    let data: SportMonksStatisticValue?
    let type: SportMonksStatisticType?

    var displayValue: String {
        if let value = data?.value {
            if value == floor(value) {
                return String(Int(value))
            }
            return String(format: "%.1f", value)
        }

        return "-"
    }
}

private struct SportMonksStatisticValue: Decodable {
    let value: Double?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let number = try? container.decode(Double.self, forKey: .value) {
            value = number
        } else if let string = try? container.decode(String.self, forKey: .value) {
            value = Double(string)
        } else if let intValue = try? container.decode(Int.self, forKey: .value) {
            value = Double(intValue)
        } else {
            value = nil
        }
    }

    private enum CodingKeys: String, CodingKey {
        case value
    }
}

private struct SportMonksStatisticType: Decodable {
    let name: String?
}

private struct SportMonksLeague: Decodable {
    let name: String?
}

private struct SportMonksVenue: Decodable {
    let name: String?
}

private struct SportMonksState: Decodable {
    let name: String?
    let shortName: String?

    enum CodingKeys: String, CodingKey {
        case name
        case shortName = "short_name"
    }
}
