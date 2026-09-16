import Foundation
import SwiftData

@Model
final class JournalEntry {
    var id: UUID
    var createdAt: Date
    var audioFileName: String?
    var transcript: String
    var moodRaw: Int
    var reflectionSummary: String
    var reflectionInsight: String
    var reflectionNextStep: String
    var tags: [String]

    var mood: Mood {
        get { Mood(rawValue: moodRaw) ?? .steady }
        set { moodRaw = newValue.rawValue }
    }

    var reflection: Reflection {
        get {
            Reflection(
                summary: reflectionSummary,
                insight: reflectionInsight,
                nextStep: reflectionNextStep
            )
        }
        set {
            reflectionSummary = newValue.summary
            reflectionInsight = newValue.insight
            reflectionNextStep = newValue.nextStep
        }
    }

    init(
        id: UUID = UUID(),
        createdAt: Date = .now,
        audioFileName: String? = nil,
        transcript: String,
        mood: Mood = .steady,
        reflection: Reflection = Reflection(summary: "", insight: "", nextStep: ""),
        tags: [String] = []
    ) {
        self.id = id
        self.createdAt = createdAt
        self.audioFileName = audioFileName
        self.transcript = transcript
        self.moodRaw = mood.rawValue
        self.reflectionSummary = reflection.summary
        self.reflectionInsight = reflection.insight
        self.reflectionNextStep = reflection.nextStep
        self.tags = tags
    }
}
