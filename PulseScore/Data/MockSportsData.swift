import Foundation

enum MockSportsData {
    static let liveMatches: [Match] = [
        Match(
            id: "ucl-rma-mci",
            league: "Champions League",
            venue: "Santiago Bernabeu",
            minute: "67'",
            state: .live,
            home: Team(id: "rma", name: "Real Madrid", shortName: "RMA", record: "3rd in LaLiga", accent: "gold"),
            away: Team(id: "mci", name: "Manchester City", shortName: "MCI", record: "2nd in Premier League", accent: "sky"),
            homeScore: 2,
            awayScore: 2,
            headline: "End-to-end football with both midfields stretched.",
            kickoff: nil,
            stats: [
                MatchStat(id: "possession", label: "Possession", homeValue: "54", awayValue: "46"),
                MatchStat(id: "shots", label: "Shots", homeValue: "12", awayValue: "10"),
                MatchStat(id: "corners", label: "Corners", homeValue: "6", awayValue: "4")
            ]
        ),
        Match(
            id: "nba-gsw-lal",
            league: "NBA",
            venue: "Chase Center",
            minute: "Q4 05:12",
            state: .live,
            home: Team(id: "gsw", name: "Warriors", shortName: "GSW", record: "39-25", accent: "blue"),
            away: Team(id: "lal", name: "Lakers", shortName: "LAL", record: "36-28", accent: "yellow"),
            homeScore: 108,
            awayScore: 104,
            headline: "Golden State is closing with a small-ball lineup.",
            kickoff: nil,
            stats: [
                MatchStat(id: "rebounds", label: "Rebounds", homeValue: "42", awayValue: "39"),
                MatchStat(id: "threes", label: "3PT", homeValue: "16", awayValue: "13"),
                MatchStat(id: "turnovers", label: "Turnovers", homeValue: "9", awayValue: "12")
            ]
        )
    ]

    static let upcomingMatches: [Match] = [
        Match(
            id: "epl-liv-ars",
            league: "Premier League",
            venue: "Anfield",
            minute: "Tomorrow 20:00",
            state: .upcoming,
            home: Team(id: "liv", name: "Liverpool", shortName: "LIV", record: "1st", accent: "red"),
            away: Team(id: "ars", name: "Arsenal", shortName: "ARS", record: "4th", accent: "red"),
            homeScore: 0,
            awayScore: 0,
            headline: "A title-race meeting with huge pressure at both ends.",
            kickoff: nil,
            stats: []
        ),
        Match(
            id: "f1-ver-lec",
            league: "Formula 1",
            venue: "Albert Park",
            minute: "Sunday 06:00",
            state: .upcoming,
            home: Team(id: "ver", name: "Verstappen", shortName: "VER", record: "Pole favorite", accent: "navy"),
            away: Team(id: "lec", name: "Leclerc", shortName: "LEC", record: "Front row threat", accent: "red"),
            homeScore: 0,
            awayScore: 0,
            headline: "Qualifying pace is expected to decide the weekend.",
            kickoff: nil,
            stats: []
        ),
        Match(
            id: "nhl-nyr-bos",
            league: "NHL",
            venue: "Madison Square Garden",
            minute: "Tonight 19:30",
            state: .upcoming,
            home: Team(id: "nyr", name: "Rangers", shortName: "NYR", record: "42-19", accent: "blue"),
            away: Team(id: "bos", name: "Bruins", shortName: "BOS", record: "40-21", accent: "yellow"),
            homeScore: 0,
            awayScore: 0,
            headline: "Two physical teams meeting in a playoff-style atmosphere.",
            kickoff: nil,
            stats: []
        )
    ]

    static let leagues: [LeagueSpotlight] = [
        LeagueSpotlight(
            id: "premier-league",
            name: "Premier League",
            season: "2025/26",
            featuredMatch: Match(
                id: "epl-mci-che",
                league: "Premier League",
                venue: "Etihad Stadium",
                minute: "Sunday 16:30",
                state: .upcoming,
                home: Team(id: "mci", name: "Manchester City", shortName: "MCI", record: "2nd", accent: "sky"),
                away: Team(id: "che", name: "Chelsea", shortName: "CHE", record: "6th", accent: "blue"),
                homeScore: 0,
                awayScore: 0,
                headline: "City's possession structure meets Chelsea's transition threat.",
                kickoff: nil,
                stats: []
            ),
            standings: [
                StandingRow(id: "liverpool", position: 1, team: "Liverpool", played: 28, wins: 20, form: "WWDWW", points: 63),
                StandingRow(id: "man-city", position: 2, team: "Manchester City", played: 28, wins: 18, form: "WDWWW", points: 59),
                StandingRow(id: "tottenham", position: 3, team: "Tottenham", played: 28, wins: 17, form: "WLWWW", points: 56),
                StandingRow(id: "arsenal", position: 4, team: "Arsenal", played: 28, wins: 16, form: "DWWLW", points: 54)
            ],
            update: "The top four are separated by nine points with one matchday swing looming."
        ),
        LeagueSpotlight(
            id: "nba",
            name: "NBA",
            season: "2025/26",
            featuredMatch: Match(
                id: "nba-bos-mil",
                league: "NBA",
                venue: "TD Garden",
                minute: "Tonight 22:00",
                state: .upcoming,
                home: Team(id: "bos", name: "Celtics", shortName: "BOS", record: "48-14", accent: "green"),
                away: Team(id: "mil", name: "Bucks", shortName: "MIL", record: "41-22", accent: "green"),
                homeScore: 0,
                awayScore: 0,
                headline: "A likely playoff preview between two elite half-court teams.",
                kickoff: nil,
                stats: []
            ),
            standings: [
                StandingRow(id: "celtics", position: 1, team: "Celtics", played: 62, wins: 48, form: "WWWWW", points: 48),
                StandingRow(id: "cavaliers", position: 2, team: "Cavaliers", played: 63, wins: 45, form: "LWWWW", points: 45),
                StandingRow(id: "bucks", position: 3, team: "Bucks", played: 63, wins: 41, form: "WLWLW", points: 41),
                StandingRow(id: "knicks", position: 4, team: "Knicks", played: 63, wins: 40, form: "WWLWW", points: 40)
            ],
            update: "Boston keeps stacking wins while the race for home court stays wide open behind them."
        )
    ]

    static let stories: [NewsStory] = [
        NewsStory(
            id: "story-ucl-rotations",
            title: "Why wide rotations are shaping the Champions League quarterfinal picture",
            category: "Analysis",
            summary: "Top clubs are leaning on deeper benches to preserve tempo and defend transitions late in matches."
        ),
        NewsStory(
            id: "story-nba-offense",
            title: "Three NBA offenses peaking before the postseason",
            category: "Trends",
            summary: "Spacing, early-clock threes, and secondary playmaking are defining the most dangerous lineups."
        ),
        NewsStory(
            id: "story-f1-cooling",
            title: "F1 teams chase cooling gains ahead of a hot-weather weekend",
            category: "Pit Wall",
            summary: "Small thermal advantages could unlock race pace over long stints and change strategy windows."
        )
    ]
}
