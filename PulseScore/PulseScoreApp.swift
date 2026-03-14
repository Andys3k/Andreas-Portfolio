import SwiftUI

@main
struct PulseScoreApp: App {
    @State private var viewModel = ScoreboardViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
        }
    }
}
