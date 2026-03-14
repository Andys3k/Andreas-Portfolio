import Foundation

@MainActor
@Observable
final class ScoreboardViewModel {
    var liveMatches = MockSportsData.liveMatches
    var upcomingMatches = MockSportsData.upcomingMatches
    var leagues = MockSportsData.leagues
    var stories = MockSportsData.stories
    var isLoading = false
    var errorMessage: String?
    var lastUpdated: Date?

    private let service: LiveScoreService?

    init(service: LiveScoreService? = nil) {
        self.service = service ?? Self.makeDefaultService()
        Task {
            await refresh()
        }
    }

    var featuredMatch: Match {
        liveMatches.first ?? upcomingMatches.first ?? MockSportsData.liveMatches[0]
    }

    var trendingLeagues: [LeagueSpotlight] {
        leagues
    }

    var hasLiveProvider: Bool {
        service != nil
    }

    var providerLabel: String {
        hasLiveProvider ? "SportMonks live feed" : "Mock feed"
    }

    var allMatchesByLeague: [(league: String, matches: [Match])] {
        Dictionary(grouping: liveMatches + upcomingMatches, by: \.league)
            .map { league, matches in
                let sortedMatches = matches.sorted { lhs, rhs in
                    if lhs.state != rhs.state {
                        return lhs.state == .live
                    }
                    return (lhs.kickoff ?? .distantFuture) < (rhs.kickoff ?? .distantFuture)
                }
                return (league: league, matches: sortedMatches)
            }
            .sorted { $0.league < $1.league }
    }

    func refresh() async {
        guard let service else {
            errorMessage = "Set `SPORTMONKS_API_TOKEN` in your Xcode scheme or Info settings to enable real live football tracking."
            lastUpdated = Date()
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let snapshot = try await service.fetchDashboard()
            liveMatches = snapshot.liveMatches.isEmpty ? MockSportsData.liveMatches : snapshot.liveMatches
            upcomingMatches = snapshot.upcomingMatches.isEmpty ? MockSportsData.upcomingMatches : snapshot.upcomingMatches
            leagues = snapshot.leagues.isEmpty ? MockSportsData.leagues : snapshot.leagues
            lastUpdated = Date()
        } catch {
            errorMessage = error.localizedDescription
            lastUpdated = Date()
        }

        isLoading = false
    }

    nonisolated private static func makeDefaultService() -> LiveScoreService? {
        guard let token = AppConfiguration.sportMonksToken else {
            return nil
        }

        return SportMonksLiveScoreService(token: token)
    }
}
