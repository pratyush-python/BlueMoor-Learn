# Aether

**History. Cosmos. Mastery.**

A beautiful, native macOS learning app that gamifies the journey through human history and the cosmos. Inspired by Duolingo's engagement loops and the reflective depth of Aurelius, but with a premium, contemplative aesthetic that feels at home on Apple Silicon Macs.

> **Project Status**: High-quality MVP starter foundation. Production-ready architecture, beautiful UI shell, full persistence, 4 rich sample lessons, working quizzes, streak/XP system, and onboarding. Designed for easy iteration and content expansion.

---

## Why "Aether"?

- **Aether** (from Greek Αἰθήρ) was the pure upper sky, the realm of the stars and gods in classical cosmology — the perfect conceptual bridge between ancient civilizations and modern space exploration.
- Short, elegant, memorable, and brandable.
- Alternative considered: **Aetherius** (more unique but longer).

We strongly recommend **Aether**.

---

## Improved Prompt Decisions & Scope

### Original Prompt Issues Addressed
- Too broad for a "starter" (Battle Mode AI, complex graph visualization, full personalization ML, real-time RSS would make initial delivery slow and buggy).
- Unclear MVP boundaries.
- Needed stronger emphasis on data-driven content (JSON) for long-term maintainability.
- macOS-native patterns and SwiftData best practices needed more specificity.

### Final Scope for This Starter (v1)

**In Scope (Fully Implemented)**
- Native macOS SwiftUI architecture using `NavigationSplitView`, toolbars, sheets, and modern patterns.
- SwiftData for all user progress, streaks, XP, preferences, and lesson completion state.
- 4 high-quality sample lessons (2 History + 2 Cosmos) with **Overview / Standard / Deep** adaptive depth.
- Elegant lesson reader with smooth depth switching, timelines, key figures, and expandable sections.
- Multiple-choice quizzes with scoring, immediate feedback, and XP rewards.
- **Today** tab: Streak visualization, smart daily recommendation, quick stats.
- **History** & **Cosmos** library views with beautiful cards.
- **Progress** dashboard with XP, level, streak history, and mastery overview.
- Onboarding flow for interests (History / Cosmos preference) and default depth.
- Personalization: Simple but effective rule-based recommendations + stored preferences.
- Dark-mode-first elegant theme blending marble/scroll (history) with nebula/cosmic (space) aesthetics.
- Full keyboard shortcuts and menu commands.
- Excellent accessibility and SwiftUI previews for every major view.
- Placeholder "Today in Space" news feed (easy to wire to real API later).
- Settings view.

**Explicitly Out of Scope for v1 (Clear Extension Points)**
- Battle Mode (full UI shell present as placeholder; AI opponent logic later).
- Explore graph / "rabbit hole" visualization (search + related topics list for now).
- Real Space News API or complex networking (mock data + `NewsService` protocol ready).
- Advanced on-device ML personalization or complex adaptive difficulty.
- Cloud sync / iCloud (easy to add with SwiftData CloudKit later).
- Achievements system beyond core streak/XP (simple milestone tracking possible).

This scope delivers a **runnable, delightful, production-quality foundation** that feels complete while remaining highly modular.

---

## Architecture Overview

```
Aether/
├── AetherApp.swift                 # @main + WindowGroup + Settings scene
├── Models/
│   ├── Lesson.swift                # Codable struct from JSON (immutable content)
│   ├── UserProfile.swift           # @Model
│   ├── LessonProgress.swift        # @Model
│   ├── QuizQuestion.swift
│   └── Enums.swift                 # Category, Depth, InterestTag, etc.
├── Services/
│   ├── ContentService.swift        # Loads & caches bundled JSON lessons
│   ├── ProgressService.swift       # Handles streaks, XP, completions (protocol + impl)
│   ├── RecommendationEngine.swift  # Simple but smart daily picks
│   └── MockNewsService.swift
├── ViewModels/
│   └── (Lightweight @Observable objects where needed)
├── Views/
│   ├── Components/                 # Reusable: LessonCard, DepthSelector, QuizView, StreakRing, etc.
│   ├── TodayView.swift
│   ├── HistoryView.swift
│   ├── CosmosView.swift
│   ├── LessonView.swift            # The heart of the experience
│   ├── ProgressView.swift
│   ├── OnboardingView.swift
│   ├── SettingsView.swift
│   └── ExploreView.swift           # Shell for future graph
├── Resources/
│   ├── Content/
│   │   ├── history_roman_republic.json
│   │   ├── history_ancient_egypt.json
│   │   ├── cosmos_solar_system.json
│   │   └── cosmos_black_holes.json
│   └── Assets.xcassets/            # Colors, symbols, hero placeholders (user creates in Xcode)
└── README.md
```

**Key Principles**
- **Content is data**: Lessons live in JSON → easy for non-devs to expand or for future CMS.
- **User state is SwiftData**: Progress, preferences, streaks.
- **MVVM-light**: Many views use `@Query` + computed properties directly. ViewModels only where complex state or testable logic exists.
- **Theme-driven**: Single source of truth for colors, spacing, and typography.
- **Modular services**: Easy to mock or replace (e.g., real NASA API).

---

## How to Use This Starter in Xcode

1. **Create New Project**
   - Open Xcode → New Project → macOS → App
   - Name: **Aether**
   - Interface: **SwiftUI**
   - Language: **Swift**
   - **Check "Use SwiftData"** (important)
   - Target: macOS 14.0 or later (recommended)

2. **Replace Default Files**
   - Delete the generated `ContentView.swift` and `Item.swift` (if present).
   - Copy all folders from this `Aetherius/` template into your project root (Models, Views, Services, Resources, etc.).
   - Add the `.swift` files at root level (`AetherApp.swift` etc.).

3. **Assets**
   - In Xcode, create `Assets.xcassets` if needed (or merge).
   - Add a color set named `AccentColor` (use a beautiful cosmic gold or deep indigo).
   - Add placeholder images for lesson heroes if desired (or rely heavily on SF Symbols + overlays for v1).

4. **Run**
   - Build & run on Apple Silicon Mac (or Rosetta if needed, but native is best).
   - On first launch you will see the beautiful onboarding.

5. **Adding New Lessons (Easy!)**
   - Create a new `.json` file in `Resources/Content/` following the schema in existing files.
   - The `ContentService` will automatically pick it up (no code changes needed).

---

## Design Language

- **Dark-first**: Deep space navy (`#0A0E1A`) + subtle nebula gradients.
- **History accent**: Warm parchment gold (`#C9A26B`), soft marble whites.
- **Cosmos accent**: Electric cyan (`#5CE1E6`), violet (`#7B68EE`).
- **Typography**: SF Pro (system) with generous leading and refined hierarchy. Use `.font(.title)` etc. with custom modifiers for elegance.
- **Motion**: Spring-based animations, subtle parallax on cards, smooth depth transitions.
- **Premium feel**: Generous padding, rounded corners (12-16pt), frosted materials where appropriate, excellent hover states.

---

## Next Steps & Iteration Plan (After You Test)

Typical feedback loop:
1. Test onboarding + Today flow.
2. Complete a full lesson + quiz.
3. Check streak/XP persistence after quitting.
4. Suggest visual or UX tweaks.
5. Then we can add: Battle Mode, better Explore, real news feed, more lessons, iCloud sync, etc.

---

## Technical Notes

- **SwiftData** models use `@Model` and proper relationships.
- **Concurrency**: Modern Swift 6-ready patterns where possible (sendable where needed).
- **Previews**: Every major view has rich `#Preview` with sample data.
- **Accessibility**: Full VoiceOver support, dynamic type, high-contrast considerations.
- **Keyboard**: `Cmd+1` Today, `Cmd+2` History, `Cmd+3` Cosmos, `Cmd+4` Progress, `Cmd+,` Settings.

This foundation is designed to feel like a premium shipped app from day one while being trivial to extend.

Welcome to Aether. Let's make learning feel like exploring the stars.

---

*Built with care for macOS and the curious mind.*
