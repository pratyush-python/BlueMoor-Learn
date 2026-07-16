# Blue Moor - Learn — iOS / iPadOS roadmap

**Branch:** `platform/ios`  
**Product name:** Blue Moor - Learn  
**Status:** Planned (not implemented on this branch yet)

## Goal

Ship **Blue Moor - Learn** on iPhone and iPad with the same learning loop as macOS:

- Today (streak, recommended lesson)
- History & Cosmos libraries
- Lesson reader (Overview / Standard / Deep)
- Quizzes + XP / streaks
- Onboarding + settings
- Progress dashboard

## Recommended stack

| Layer | Choice | Notes |
|-------|--------|--------|
| UI | **SwiftUI** | Share models/services patterns with macOS |
| Persistence | **SwiftData** (or Core Data) | Align with macOS `UserProfile` / `LessonProgress` |
| Min OS | **iOS 17+** (TBD) | SwiftData-friendly |
| Project | Multiplatform Xcode target or separate iOS target | Prefer shared `Models` + `Services` modules |

## Phases

### Phase 0 — Scaffold
- [ ] Add iOS app target (or multiplatform) to Xcode project
- [ ] Share `Models/`, `Services/`, lesson content
- [ ] iOS entry: `BlueMoorLearnApp` + root `TabView` or `NavigationStack`
- [ ] Dark-mode-first theme (`BlueMoorTheme`)

### Phase 1 — Core loop
- [ ] Today, History, Cosmos, Progress tabs (thumb-friendly layout)
- [ ] Lesson + Quiz flows full screen / sheets
- [ ] Onboarding
- [ ] Local persistence (streaks, XP, completions)

### Phase 2 — iOS polish
- [ ] Dynamic Type, VoiceOver, Reduce Motion
- [ ] Widgets (streak / daily lesson) — optional
- [ ] iPad multi-column layouts
- [ ] App Store assets, privacy nutrition labels

### Phase 3 — Later
- [ ] iCloud sync (SwiftData + CloudKit)
- [ ] Push: daily streak reminder (opt-in)
- [ ] Spotlight / Siri suggestions for “continue lesson”

## Explicit non-goals (initially)

- Battle Mode AI opponent
- Real-time multiplayer
- Full feature parity with every future macOS experiment on day one

## Open questions

1. Single multiplatform target vs separate iOS app target?
2. Minimum iOS version (17 vs 18)?
3. Phone-first vs iPad-class navigation?

## Working agreement

- Keep experimental iOS UI on this branch.
- Shared lesson JSON / models: design for reuse before duplicating.
- When ready, open a PR describing the scaffold and any `main` shared-code extractions.
