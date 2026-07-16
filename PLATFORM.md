# Blue Moor - Learn — Android roadmap

**Branch:** `platform/android`  
**Product name:** Blue Moor - Learn  
**Status:** Planned (not implemented on this branch yet)

## Goal

Bring the **Blue Moor - Learn** learning experience to Android phones and tablets:

- Daily streak + recommended lesson
- History & Cosmos catalogs
- Adaptive depth lessons + quizzes
- Progress (XP, level, streaks)
- Onboarding + settings

## Recommended stack

| Layer | Choice | Notes |
|-------|--------|--------|
| UI | **Jetpack Compose** | Modern Android UI |
| Architecture | **MVVM** + repository pattern | Mirror service boundaries from macOS |
| Persistence | **Room** (or DataStore for prefs) | Map `UserProfile` / `LessonProgress` |
| Min SDK | **API 26+** or **API 29+** (TBD) | Balance reach vs APIs |
| Language | **Kotlin** | First-class Compose support |
| Module layout | `:app` + `:core:domain` + `:core:data` | Keep domain models shareable in spirit with iOS/macOS |

## Phases

### Phase 0 — Scaffold
- [ ] Android Studio project under e.g. `android/`
- [ ] Application ID, e.g. `com.bluemoor.learn`
- [ ] Theme (dark-first, history gold / cosmos cyan tokens)
- [ ] Navigation (bottom nav or navigation rail on tablet)

### Phase 1 — Core loop
- [ ] Content loader (port sample lessons; later JSON assets)
- [ ] Today / History / Cosmos / Progress screens
- [ ] Lesson reader + quiz
- [ ] Local DB for progress and streaks

### Phase 2 — Android polish
- [ ] Material 3 dynamic color (optional; keep brand accents)
- [ ] Accessibility (TalkBack, font scale)
- [ ] Tablet / foldable layouts
- [ ] Play Store listing assets, Data safety form

### Phase 3 — Later
- [ ] Optional Firebase (analytics only if privacy-reviewed)
- [ ] WorkManager streak reminders (opt-in)
- [ ] Backup / restore (Auto Backup or Drive)

## Explicit non-goals (initially)

- Kotlin Multiplatform shared with iOS on day one (revisit after Android MVP)
- Wear OS / Auto
- Full offline CDN content system

## Open questions

1. Pure native Compose vs Flutter/KMP for cross-platform later?
2. Single APK vs play feature modules?
3. How strictly to match iOS/macOS information architecture?

## Working agreement

- All Android sources live on this branch under a clear root (e.g. `android/`).
- Do not break `main` macOS build.
- Document package naming and min SDK in the first scaffold PR.
