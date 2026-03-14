import SwiftUI

struct LiveMatchCard: View {
    let match: Match
    let emphasizesHeadline: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Label(match.league, systemImage: "dot.radiowaves.left.and.right")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white.opacity(0.82))

                Spacer()

                Text(match.minute)
                    .font(.caption)
                    .fontWeight(.black)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(match.state == .live ? Color.red.opacity(0.85) : Color.white.opacity(0.18))
                    .clipShape(Capsule())
            }

            HStack(alignment: .top) {
                teamScoreBlock(team: match.home, score: match.homeScore)
                Spacer(minLength: 16)
                teamScoreBlock(team: match.away, score: match.awayScore)
            }

            Text(match.headline)
                .font(emphasizesHeadline ? .headline : .subheadline)
                .foregroundStyle(.white.opacity(emphasizesHeadline ? 0.92 : 0.72))

            Text(match.venue)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.56))

            if !match.stats.isEmpty {
                HStack(spacing: 10) {
                    ForEach(match.stats) { stat in
                        VStack(spacing: 6) {
                            Text("\(stat.homeValue)-\(stat.awayValue)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            Text(stat.label)
                                .font(.caption2)
                                .foregroundStyle(.white.opacity(0.6))
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.14),
                            Color.white.opacity(0.06)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(.white.opacity(0.08), lineWidth: 1)
                )
        )
    }

    private func teamScoreBlock(team: Team, score: Int) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(team.shortName)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.white.opacity(0.72))

            Text(team.name)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .lineLimit(2)

            Text("\(score)")
                .font(.system(size: 40, weight: .black, design: .rounded))
                .foregroundStyle(.white)

            Text(team.record)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.6))
        }
    }
}
