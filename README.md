# Aetherius

**History. Cosmos. Mastery.**

A native **macOS** learning app (SwiftUI + SwiftData) that gamifies journeys through human history and the cosmos — with a dark, contemplative aesthetic, streaks/XP, adaptive lesson depth, and quizzes.

## Requirements

- macOS 14+
- Xcode 16+ (Swift 5 / SwiftData)

## Open & run

1. Open `Aetherius.xcodeproj` in Xcode  
2. Scheme: **Aetherius** · Destination: **My Mac**  
3. Press **⌘R**

```bash
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
cd /path/to/Aetherius
xcodebuild -project Aetherius.xcodeproj -scheme Aetherius -destination 'platform=macOS' build
```

## Project layout

```
Aetherius/
├── AetheriusApp.swift       # @main + MainTabView
├── Models/
├── Views/
├── Services/
├── ViewModels/
├── Resources/
└── Assets.xcassets
```

## v1 features

- SwiftUI `NavigationSplitView` (Today / History / Cosmos / Explore / Progress)
- SwiftData: profile, streaks, XP, lesson progress
- Sample History + Cosmos lessons (Overview / Standard / Deep)
- Quizzes, onboarding, dark-mode-first theme

## License

Personal / educational project.
