import Foundation

enum DailyPrompts {
    static let all: [String] = [
        "What's been sitting with you today?",
        "What felt quietly true this afternoon?",
        "If today had a weather, what would it be?",
        "What did you almost say out loud?",
        "Where did your attention linger?",
        "What are you carrying that isn't yours?",
        "What small thing went better than you noticed?",
        "Who were you kind to — including yourself?",
        "What do you wish tomorrow already knew?",
        "What felt heavy, and what felt light?",
        "If this week is a chapter, what's the sentence you're on?",
        "What would you tell yourself from a year ago?"
    ]

    static func prompt(for date: Date = .now) -> String {
        let day = Calendar.current.ordinality(of: .day, in: .year, for: date) ?? 0
        return all[day % all.count]
    }
}
