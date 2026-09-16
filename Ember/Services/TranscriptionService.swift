import Foundation

protocol TranscriptionService {
    func transcribe(audioFileURL: URL) async throws -> String
}
