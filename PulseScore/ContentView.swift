import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            ScoreboardView()
                .tabItem {
                    Label("Scores", systemImage: "sportscourt.fill")
                }

            LeagueHubView()
                .tabItem {
                    Label("Leagues", systemImage: "list.bullet.rectangle.portrait.fill")
                }
        }
        .tint(.orange)
    }
}

#Preview {
    ContentView()
        .environment(ScoreboardViewModel())
}
