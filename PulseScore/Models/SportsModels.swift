import Foundation

struct Team: Identifiable, Hashable {
    let id: String
    let name: String
    let shortName: String
    let record: String
    let accent: String
}

enum MatchState: String, CaseIterable {
    case live = "LIVE"
    case upcoming = "UP NEXT"
    case finished = "FINAL"
}

struct Match: Identifiable, Hashable {
    let id: String
    let league: String
    let venue: String
    let minute: String
    let state: MatchState
    let home: Team
    let away: Team
    let homeScore: Int
    let awayScore: Int
    let headline: String
    let kickoff: Date?
    let stats: [MatchStat]
}

struct StandingRow: Identifiable, Hashable {
    let id: String
    let position: Int
    let team: String
    let played: Int
    let wins: Int
    let form: String
    let points: Int
}

struct LeagueSpotlight: Identifiable, Hashable {
    let id: String
    let name: String
    let season: String
    let featuredMatch: Match
    let standings: [StandingRow]
    let update: String
}

struct NewsStory: Identifiable, Hashable {
    let id: String
    let title: String
    let category: String
    let summary: String
}

struct MatchStat: Identifiable, Hashable {
    let id: String
    let label: String
    let homeValue: String
    let awayValue: String
}
