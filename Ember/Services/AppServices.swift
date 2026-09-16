import SwiftUI

/// Swap mock implementations here later — views never talk to mocks directly.
@MainActor
final class AppServices {
    let transcription: any TranscriptionService
    let reflection: any ReflectionService

    init(
        transcription: any TranscriptionService,
        reflection: any ReflectionService
    ) {
        self.transcription = transcription
        self.reflection = reflection
    }

    static let live = AppServices(
        transcription: UnimplementedTranscriptionService(),
        reflection: UnimplementedReflectionService()
    )
}

private struct AppServicesKey: EnvironmentKey {
    static let defaultValue: AppServices = .live
}

extension EnvironmentValues {
    var appServices: AppServices {
        get { self[AppServicesKey.self] }
        set { self[AppServicesKey.self] = newValue }
    }
}

/// Milestone 1 placeholders. Real mocks land in the core-loop milestone.
private struct UnimplementedTranscriptionService: TranscriptionService {
    func transcribe(audioFileURL: URL) async throws -> String {
        throw UnimplementedServiceError.transcription
    }
}

private struct UnimplementedReflectionService: ReflectionService {
    func reflect(on transcript: String, history: [JournalEntry]) async throws -> Reflection {
        throw UnimplementedServiceError.reflection
    }

    func weeklyCallScript(from entries: [JournalEntry]) -> String {
        ""
    }
}

private enum UnimplementedServiceError: Error {
    case transcription
    case reflection
}
