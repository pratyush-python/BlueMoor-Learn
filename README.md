# Aether

**History. Cosmos. Mastery.**

A native **macOS** learning app (SwiftUI + SwiftData) that gamifies journeys through human history and the cosmos — with a dark, contemplative aesthetic, streaks/XP, adaptive lesson depth, and quizzes.

## Requirements

- macOS 14+
- Xcode 16+ (Swift 5 / SwiftData)

## Open & run

1. Open `Aether.xcodeproj` in Xcode  
2. Scheme: **Aether** · Destination: **My Mac**  
3. Press **⌘R**

Or from the terminal:

```bash
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
cd /path/to/Aether
xcodebuild -project Aether.xcodeproj -scheme Aether -destination 'platform=macOS' build
open build/... # or just Run from Xcode
```

## Project layout

```
Aether/
├── AetherApp.swift          # @main + MainTabView (sidebar navigation)
├── Models/                  # Lesson content + SwiftData (UserProfile, LessonProgress)
├── Views/                   # Today, History, Cosmos, Lesson, Quiz, Onboarding, Settings, …
├── Services/                # ContentService, ProgressService
├── ViewModels/              # Reserved for future expansion
├── Resources/               # Future JSON content / assets expansion
└── Assets.xcassets          # App icon + accent color placeholders
```

## What’s in v1

- SwiftUI `NavigationSplitView` shell (Today / History / Cosmos / Explore / Progress)
- SwiftData persistence for profile, streaks, XP, lesson progress
- Four sample lessons (History + Cosmos) with Overview / Standard / Deep content
- Quizzes with scoring + XP
- Onboarding for interests + preferred depth
- Dark-mode-first theme

## License

Personal / educational project. Add a license of your choice if you open-source further.
