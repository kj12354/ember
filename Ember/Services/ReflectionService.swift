import Foundation

protocol ReflectionService {
    func reflect(on transcript: String, history: [JournalEntry]) async throws -> Reflection
    func weeklyCallScript(from entries: [JournalEntry]) -> String
}
