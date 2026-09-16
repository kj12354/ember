# Build "Ember" — a voice-first AI journaling app (SwiftUI, iOS)

> Paste this whole file into Claude Code as your opening prompt (or save it as `CLAUDE.md` at the project root). "Ember" is a placeholder name — rename freely.

## What we're building

A voice-first journaling iOS app whose real product is **reflecting a person's growth back at them**, not just storing entries. The core loop is: speak → it transcribes → it gives a short, warm reflection → it's saved to a timeline. On top of that sit two differentiators:

1. **Growth callbacks** — notifications that surface a past entry with an encouraging frame ("A year ago you were dreaming of where you are right now. Don't quit.").
2. **Weekly check-in call** — a scheduled, phone-call-style screen where a warm AI voice tells the person how consistent/strong they've been lately, referencing their actual entries.

The feel: calm, cozy, premium — the ambience of Apple Journal. Warm dark background, generous space, literary typography, soft motion. This is a portfolio-quality build; polish matters as much as function.

## Hard constraints (read before writing any code)

- **Platform:** Native **SwiftUI**, iOS **17+** (we need SwiftData). Single app target, no backend, no accounts, no cloud sync.
- **Everything is real EXCEPT the AI.** Voice recording, local persistence, notifications, the call screen, animations, haptics — all real. **Transcription and reflections are mocked** for v1 (canned/templated content). No API keys, no network calls, zero cost to run.
- **Put the AI behind protocols** so swapping in real services later is a one-file change (see Services below). This is important — don't hardcode mock strings into views.
- **Seed ~50 sample entries across the past 12 months on first launch** so the timeline, streaks, growth callbacks, and weekly call all have real material to demo immediately. Without this the killer features look empty.
- Demoed in the Xcode simulator and on a physical iPhone. Keep it runnable with Cmd-R at every milestone.

## Design system — get this right, it's the point

Do NOT produce a generic pure-black Material-style UI. Aim for warm, dim, intimate.

- **Palette:** deep warm base, not pure black. Background around `#17130F` / `#1B1512` (warm espresso-ink). Card surfaces one step lighter and slightly warmer. A single accent — warm amber/ember glow, roughly `#E8A15C` → `#D98247`, used sparingly (record button, active states, the "call" accent). Muted, low-saturation text: soft cream `#EDE6DC` for primary, dimmed for secondary. Define all of this in one `Theme`/`Color+Ember` file with semantic names (`.emberBackground`, `.emberSurface`, `.emberAccent`, `.emberTextPrimary`, `.emberTextSecondary`).
- **Typography:** UI in SF Pro (system). **Entry/reflection body text in a serif** — use the New York system serif (`.font(.system(.body, design: .serif))`) for a literary, diary feel. Generous line spacing on body text.
- **Layout:** lots of negative space, wide margins, one focal element per screen. Rounded corners ~20pt on cards. Soft, low-opacity shadows only.
- **Motion:** gentle spring animations on transitions and the record button. Subtle haptics (`.sensoryFeedback` / `UIImpactFeedbackGenerator`) on record start/stop, save, and streak increments. A soft radial "ember glow" behind the record button that breathes slowly when idle and pulses with the mic input level when recording.
- **Optional flourish (nice-to-have):** a barely-there film-grain/noise overlay on the background for warmth.

## Feature spec

### Core loop
- **Home:** warm greeting appropriate to time of day, today's gentle prompt (rotate from a small local list), a prominent record button, and a peek at the current streak. If today already has an entry, reflect that softly.
- **Record screen:** live waveform / level meter, elapsed timer, stop button. Record real audio to a file via AVFoundation (`AVAudioRecorder`). Handle mic permission gracefully.
- **After stopping:** show the (mocked) transcript in an editable text field — let the user correct/replace it, since transcription is fake. Then show a **reflection card**: three short parts — a one-line summary, an insight ("something you might not see from inside"), and a gentle next step. Serif body. Save to timeline.
- **Timeline:** reverse-chronological list of entries grouped by month, each showing date, mood glyph, and a short transcript excerpt. Tapping opens a detail view with full transcript, the reflection, mood, and a play button for the audio.
- **Streaks & light stats:** current streak, longest streak, entries this month. Keep it calm, not gamified/loud.

### Differentiator 1 — Growth callbacks
- Schedule local notifications (`UNUserNotificationCenter`) that resurface a meaningful past entry with an encouraging frame. Templates that fill from real entry data, e.g. "A year ago today you wrote about [theme]. Look how far you've come — don't quit now." Because we seed a year of data, "a year ago" resolves to a real entry on day one.
- Provide an in-app "Looking back" surface too (not only notifications) so it's demoable without waiting: a card on Home like "On this day, [n] months ago…" that opens the old entry.

### Differentiator 2 — Weekly check-in call
- A "call" screen styled like an incoming phone call (full-screen, accent glow, accept/decline). Trigger it from a scheduled weekly local notification AND expose a manual "Start check-in" button for demoing on command.
- On accept: a warm, spoken monologue delivered via `AVSpeechSynthesizer` (free, on-device, no cost) that references the person's real recent stats — how many entries this week, their streak, a recurring theme, and genuine encouragement. Script is templated from actual data (see MockReflectionService). Show the words on screen as they're spoken.
- Keep the tone careful and human. Build one guardrail now: if recent entries skew clearly negative (simple heuristic on seeded mood values), the call should soften — acknowledge a hard stretch and show up gently rather than cheering. (This is the "don't congratulate someone at their lowest" failure mode — handle it even in the mock.)

## Architecture

- `App/` — entry point, root tab/nav, theme injection.
- `Theme/` — colors, typography, spacing, reusable view modifiers (card style, glow).
- `Models/` — SwiftData models.
- `Services/` — protocols + mock implementations (the swap point).
- `Features/Home`, `Features/Record`, `Features/Timeline`, `Features/EntryDetail`, `Features/Call`, `Features/Insights` — one folder per screen with its View + ViewModel.
- `Support/` — audio recorder wrapper, notification scheduler, haptics, seed-data generator.

### Data model (SwiftData)
`JournalEntry`: `id`, `createdAt`, `audioFileName` (optional), `transcript`, `mood` (enum or -2…+2 int), `reflectionSummary`, `reflectionInsight`, `reflectionNextStep`, `tags: [String]`.
Derive streaks and stats from entries; don't store them separately unless needed.

### Services (the mock/real seam) — define as protocols
```swift
protocol TranscriptionService {
    func transcribe(audioFileURL: URL) async throws -> String
}
protocol ReflectionService {
    func reflect(on transcript: String, history: [JournalEntry]) async throws -> Reflection // summary/insight/nextStep
    func weeklyCallScript(from entries: [JournalEntry]) -> String
}
```
- `MockTranscriptionService`: returns a canned realistic transcript (or, better, just surfaces the editable field so the user types) — with a short fake "transcribing…" delay for realism.
- `MockReflectionService`: templated but responsive — do light keyword/sentiment heuristics on the transcript so the reflection feels like it read the entry, and build the weekly script from real counts/streak/themes. Vary phrasing so it's not obviously canned.
- Inject services so a future `WhisperTranscriptionService` / `LLMReflectionService` drops in without touching views.

### Seed data
On first launch (guard with a flag), generate ~50 `JournalEntry` records spread believably across the last 12 months — varied lengths, moods, and recurring themes (work, a relationship, a fitness goal, a move) so growth callbacks and the weekly call have a real arc to draw on. Include an "aha, a year ago" entry dated ~365 days back. Make transcripts read like a real person talking, not lorem ipsum.

## Build order — do these as separate, runnable milestones, and pause after each

1. **Scaffold + design system + data model.** Xcode project, theme files, SwiftData `JournalEntry`, an empty themed Home. Runnable.
2. **Core loop with mocks.** Record → editable transcript → reflection card → save → appears in a basic Timeline.
3. **Timeline + entry detail + audio playback + streaks.**
4. **Seed data generator** wired to first launch; verify timeline/streaks populate.
5. **Growth callbacks:** notification scheduling + the in-app "Looking back" card.
6. **Weekly call:** incoming-call screen, manual trigger, AVSpeechSynthesizer monologue from real stats, negative-week softening.
7. **Polish pass:** haptics, spring transitions, ember glow behind record button, empty/permission states, app icon + launch screen in the warm palette.

## Scope guards — do NOT

- No backend, auth, accounts, sign-in, or cloud sync.
- No real API keys or network calls anywhere in v1.
- No third-party UI frameworks; SwiftUI-first (drop to UIKit only if strictly required, e.g. fine-grained audio metering).
- Don't gold-plate settings/onboarding — a minimal permission-priming screen is enough.
- Ask me before adding any dependency.

## How to run / demo

- Open the project in Xcode, pick a simulator, Cmd-R.
- On a physical iPhone: set your signing Team in Signing & Capabilities, plug in, select the device, Cmd-R, then trust the developer profile in Settings the first time.
- The weekly call and growth callback both have manual triggers so I can demo them instantly without waiting for a schedule.

Start with milestone 1 and show me the result before moving on.
