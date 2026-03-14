import SwiftUI

struct UpcomingMatchRow: View {
    let match: Match

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(match.league)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.orange)

                Text("\(match.home.name) vs \(match.away.name)")
                    .font(.headline)
                    .foregroundStyle(.white)

                Text(match.headline)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.68))
                    .lineLimit(2)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 8) {
                Text(match.minute)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Text(match.venue)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.6))
                    .multilineTextAlignment(.trailing)
            }
        }
        .padding(18)
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}
