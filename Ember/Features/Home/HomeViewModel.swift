import Foundation

@Observable
@MainActor
final class HomeViewModel {
    let now: Date

    init(now: Date = .now) {
        self.now = now
    }

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: now)
        switch hour {
        case 5..<12: return "Good morning."
        case 12..<17: return "Good afternoon."
        case 17..<22: return "Good evening."
        default: return "It's late."
        }
    }

    var prompt: String {
        DailyPrompts.prompt(for: now)
    }

    func streak(from dates: [Date]) -> Int {
        Streaks.current(from: dates, now: now)
    }

    func wroteToday(from dates: [Date]) -> Bool {
        Streaks.hasEntry(on: now, in: dates)
    }
}
