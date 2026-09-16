import Foundation

enum Streaks {
    static func current(from dates: [Date], now: Date = .now, calendar: Calendar = .current) -> Int {
        let days = Set(dates.map { calendar.startOfDay(for: $0) })
        guard !days.isEmpty else { return 0 }

        var cursor = calendar.startOfDay(for: now)
        if !days.contains(cursor) {
            guard let yesterday = calendar.date(byAdding: .day, value: -1, to: cursor) else { return 0 }
            cursor = yesterday
            if !days.contains(cursor) { return 0 }
        }

        var count = 0
        while days.contains(cursor) {
            count += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: cursor) else { break }
            cursor = previous
        }
        return count
    }

    static func hasEntry(on date: Date, in dates: [Date], calendar: Calendar = .current) -> Bool {
        let day = calendar.startOfDay(for: date)
        return dates.contains { calendar.startOfDay(for: $0) == day }
    }
}
