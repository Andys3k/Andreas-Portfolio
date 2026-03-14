import SwiftUI

struct HomeView: View {
    @Environment(ScoreboardViewModel.self) private var viewModel

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    topBanner
                    feedStatus
                    liveNowSection
                    upcomingSection
                    storiesSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 28)
            }
            .background(backgroundGradient)
            .navigationTitle("PulseScore")
            .refreshable {
                await viewModel.refresh()
            }
        }
    }

    private var topBanner: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Live pulse")
                .font(.caption)
                .fontWeight(.semibold)
                .textCase(.uppercase)
                .foregroundStyle(.white.opacity(0.75))

            LiveMatchCard(match: viewModel.featuredMatch, emphasizesHeadline: true)

            HStack(spacing: 12) {
                statPill(title: "Live", value: "\(viewModel.liveMatches.count)")
                statPill(title: "Upcoming", value: "\(viewModel.upcomingMatches.count)")
                statPill(title: "Source", value: viewModel.hasLiveProvider ? "API" : "Demo")
            }
        }
    }

    private var feedStatus: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(viewModel.providerLabel)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)

                Spacer()

                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(0.9)
                } else if let lastUpdated = viewModel.lastUpdated {
                    Text(lastUpdated.formatted(date: .omitted, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.65))
                }
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.72))
            } else if viewModel.hasLiveProvider {
                Text("Pull to refresh for the latest live football matches and top stats.")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.72))
            }
        }
        .padding(16)
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private var liveNowSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Live now", subtitle: "Fast-glance score tracking")

            if viewModel.liveMatches.isEmpty {
                emptyState("No live matches right now.")
            } else {
                ForEach(viewModel.liveMatches) { match in
                    LiveMatchCard(match: match, emphasizesHeadline: false)
                }
            }
        }
    }

    private var upcomingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Watchlist", subtitle: "Big fixtures coming up")

            if viewModel.upcomingMatches.isEmpty {
                emptyState("No upcoming matches were returned for today.")
            } else {
                ForEach(viewModel.upcomingMatches) { match in
                    UpcomingMatchRow(match: match)
                }
            }
        }
    }

    private var storiesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Stories", subtitle: "Quick reads across sports")

            ForEach(viewModel.stories) { story in
                VStack(alignment: .leading, spacing: 8) {
                    Text(story.category)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.orange)

                    Text(story.title)
                        .font(.headline)
                        .foregroundStyle(.white)

                    Text(story.summary)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.72))
                }
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(.white.opacity(0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .stroke(.white.opacity(0.06), lineWidth: 1)
                        )
                )
            }
        }
    }

    private func statPill(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            Text(title)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.72))
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private func emptyState(_ text: String) -> some View {
        Text(text)
            .font(.subheadline)
            .foregroundStyle(.white.opacity(0.72))
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(red: 0.08, green: 0.09, blue: 0.16),
                Color(red: 0.13, green: 0.08, blue: 0.06),
                Color.black
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

#Preview {
    HomeView()
        .environment(ScoreboardViewModel())
}
