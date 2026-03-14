import Foundation

enum AppConfiguration {
    static var sportMonksToken: String? {
        let environmentValue = ProcessInfo.processInfo.environment["SPORTMONKS_API_TOKEN"]?.trimmingCharacters(in: .whitespacesAndNewlines)
        if let environmentValue, !environmentValue.isEmpty {
            return environmentValue
        }

        let infoValue = Bundle.main.object(forInfoDictionaryKey: "SPORTMONKS_API_TOKEN") as? String
        if let infoValue, !infoValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return infoValue
        }

        return nil
    }
}
