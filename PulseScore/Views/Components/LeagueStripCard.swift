import SwiftUI

struct LeagueStripCard: View {
    let league: LeagueSpotlight

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(league.name)
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(league.season)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text("TRENDING")
                    .font(.caption2)
                    .fontWeight(.black)
                    .foregroundStyle(.orange)
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Featured")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)

                HStack {
                    Text("\(league.featuredMatch.home.shortName) vs \(league.featuredMatch.away.shortName)")
                        .font(.headline)
                    Spacer()
                    Text(league.featuredMatch.minute)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                }

                Text(league.update)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if league.standings.isEmpty {
                Text("Standings are not loaded for this live provider yet.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                VStack(spacing: 10) {
                    ForEach(league.standings) { row in
                        HStack {
                            Text("\(row.position)")
                                .frame(width: 24, alignment: .leading)
                                .foregroundStyle(.secondary)
                            Text(row.team)
                                .fontWeight(.semibold)
                            Spacer()
                            Text(row.form)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("\(row.points) pts")
                                .fontWeight(.bold)
                        }
                        .font(.subheadline)
                    }
                }
            }
        }
        .padding(20)
        .background(.background, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.orange.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 20, y: 8)
    }
}
