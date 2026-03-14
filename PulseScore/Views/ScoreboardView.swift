import SwiftUI

struct ScoreboardView: View {
    @Environment(ScoreboardViewModel.self) private var viewModel

    var body: some View {
        NavigationStack {
            List {
                if let errorMessage = viewModel.errorMessage {
                    Section {
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }

                ForEach(viewModel.allMatchesByLeague, id: \.league) { section in
                    Section(section.league) {
                        ForEach(section.matches) { match in
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(match.minute)
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundStyle(match.state == .live ? .red : .secondary)
                                        Text(match.venue)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }

                                    Spacer()

                                    Text(match.state.rawValue)
                                        .font(.caption2)
                                        .fontWeight(.black)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(match.state == .live ? Color.red.opacity(0.15) : Color.secondary.opacity(0.12))
                                        .clipShape(Capsule())
                                }

                                HStack {
                                    teamLine(match.home.shortName, score: match.homeScore)
                                    Spacer()
                                    teamLine(match.away.shortName, score: match.awayScore)
                                }

                                Text(match.headline)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)

                                if !match.stats.isEmpty {
                                    HStack(spacing: 12) {
                                        ForEach(match.stats) { stat in
                                            VStack(spacing: 4) {
                                                Text("\(stat.homeValue)-\(stat.awayValue)")
                                                    .font(.caption)
                                                    .fontWeight(.bold)
                                                Text(stat.label)
                                                    .font(.caption2)
                                                    .foregroundStyle(.secondary)
                                            }
                                            .frame(maxWidth: .infinity)
                                        }
                                    }
                                    .padding(.top, 4)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("Scores")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Button("Refresh") {
                            Task {
                                await viewModel.refresh()
                            }
                        }
                    }
                }
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
    }

    private func teamLine(_ name: String, score: Int) -> some View {
        HStack(spacing: 10) {
            Text(name)
                .font(.headline)
            Text("\(score)")
                .font(.title3)
                .fontWeight(.bold)
        }
    }
}

#Preview {
    ScoreboardView()
        .environment(ScoreboardViewModel())
}
