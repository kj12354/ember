# Ember

A voice-first journaling iOS app. The product is not just storing entries — it is reflecting a person's growth back at them.

Speak → it transcribes → it gives a short, warm reflection → it is saved to a timeline.

Ember is a placeholder name.

## What it does

- **Core loop:** record a spoken journal entry, read a mock transcript you can edit, then save a warm reflection to a local timeline.
- **Growth callbacks:** resurface a past entry with an encouraging frame ("A year ago you were dreaming of where you are right now.").
- **Weekly check-in:** a phone-call-style screen that speaks a templated recap of recent consistency, streak, and themes.

The feel is calm, cozy, and premium — warm dark backgrounds, literary serif body text, generous space, and soft motion.

## Requirements

- Xcode 15+
- iOS 17+ (SwiftUI + SwiftData)
- No backend, accounts, API keys, or network calls

v1 mocks transcription and reflections. Voice recording, local persistence, notifications, and the call screen are real. AI sits behind protocols so a real service can drop in later.

## Run

1. Open `Ember.xcodeproj` in Xcode.
2. Select an iOS 17+ simulator or device.
3. Press **Cmd-R**.

On first launch the app seeds about 50 sample entries across the past 12 months so the timeline, streaks, callbacks, and weekly call have something to show.

## Architecture

| Folder | Role |
| --- | --- |
| `Ember/App/` | Entry point, root navigation, theme injection |
| `Ember/Theme/` | Colors, typography, spacing, view modifiers |
| `Ember/Models/` | SwiftData models |
| `Ember/Services/` | Protocols + mock implementations (the swap point) |
| `Ember/Features/` | One folder per screen (View + ViewModel) |
| `Ember/Support/` | Audio, notifications, haptics, seed data |

## Status

Scaffold, design system, and data model are in place. Next milestones: core loop with mocks, timeline + playback, seed data, growth callbacks, weekly call, polish.
