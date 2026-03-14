import Foundation

protocol LiveScoreService {
    func fetchDashboard() async throws -> LiveScoreSnapshot
}

struct LiveScoreSnapshot {
    let liveMatches: [Match]
    let upcomingMatches: [Match]
    let leagues: [LeagueSpotlight]
}

enum LiveScoreServiceError: LocalizedError {
    case missingToken
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .missingToken:
            return "Add a SportMonks API token to start live tracking."
        case .invalidResponse:
            return "The live sports provider returned an unexpected response."
        }
    }
}
