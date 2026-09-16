# Ember — voice-first AI journaling (SwiftUI, iOS 17+)

A voice-first journaling iOS app whose real product is **reflecting a person's growth back at them**, not just storing entries. The core loop is: speak → it transcribes → it gives a short, warm reflection → it's saved to a timeline.

"Ember" is a placeholder name.

## Hard constraints

- Native SwiftUI, iOS 17+ (SwiftData). Single app target, no backend, no accounts, no cloud sync.
- Everything is real EXCEPT the AI. Transcription and reflections are mocked for v1. No API keys, no network calls.
- Put the AI behind protocols so swapping in real services later is a one-file change.
- Seed ~50 sample entries across the past 12 months on first launch.
- Keep it runnable with Cmd-R at every milestone.

## Design system

Warm, dim, intimate — not generic pure-black Material UI.

- Palette lives in `Theme/Color+Ember.swift` with semantic names.
- UI in SF Pro. Entry/reflection body in New York serif (`.font(.system(.body, design: .serif))`).
- Rounded corners ~20pt on cards. Generous space. Soft motion.
- Accent used sparingly: record button, active states, the call screen.

## Architecture

- `App/` — entry point, root nav, theme injection.
- `Theme/` — colors, typography, spacing, reusable view modifiers.
- `Models/` — SwiftData models.
- `Services/` — protocols + mock implementations (the swap point).
- `Features/` — one folder per screen with View + ViewModel.
- `Support/` — audio, notifications, haptics, seed data.

## Services seam

```swift
protocol TranscriptionService {
    func transcribe(audioFileURL: URL) async throws -> String
}
protocol ReflectionService {
    func reflect(on transcript: String, history: [JournalEntry]) async throws -> Reflection
    func weeklyCallScript(from entries: [JournalEntry]) -> String
}
```

## Build order

1. Scaffold + design system + data model. ← current
2. Core loop with mocks.
3. Timeline + entry detail + audio playback + streaks.
4. Seed data generator.
5. Growth callbacks.
6. Weekly call.
7. Polish pass.

## Scope guards

- No backend, auth, accounts, or cloud sync.
- No real API keys or network calls in v1.
- No third-party UI frameworks.
- Ask before adding any dependency.
