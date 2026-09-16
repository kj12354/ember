import SwiftUI

/// Stored as an Int on `JournalEntry` in the range -2…+2.
enum Mood: Int, Codable, CaseIterable, Identifiable {
    case veryLow = -2
    case low = -1
    case steady = 0
    case good = 1
    case bright = 2

    var id: Int { rawValue }

    var symbolName: String {
        switch self {
        case .veryLow: "cloud.fill"
        case .low: "cloud.sun.fill"
        case .steady: "circle.lefthalf.filled"
        case .good: "sun.min.fill"
        case .bright: "sun.max.fill"
        }
    }

    var label: String {
        switch self {
        case .veryLow: "Heavy"
        case .low: "Low"
        case .steady: "Steady"
        case .good: "Light"
        case .bright: "Bright"
        }
    }
}
