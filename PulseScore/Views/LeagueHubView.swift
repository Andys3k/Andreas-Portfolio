import SwiftUI

struct LeagueHubView: View {
    @Environment(ScoreboardViewModel.self) private var viewModel

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    ForEach(viewModel.trendingLeagues) { league in
                        LeagueStripCard(league: league)
                    }
                }
                .padding(20)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("Leagues")
            .refreshable {
                await viewModel.refresh()
            }
        }
    }
}

#Preview {
    LeagueHubView()
        .environment(ScoreboardViewModel())
}
