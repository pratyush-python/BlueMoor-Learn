# Blue Moor - Learn

**History. Cosmos. Mastery.**

A native **macOS** learning app (SwiftUI + SwiftData) from **Blue Moor** that gamifies journeys through human history and the cosmos — dark-mode-first UI, streaks/XP, adaptive lesson depth, and quizzes.

> **Blue Moor - Learn** is a research/education product. Blue Moor is not SEBI-registered; this app is not financial advice.

## Requirements

- macOS 14+
- Xcode 16+

## Open & run

1. Open `BlueMoorLearn.xcodeproj` in Xcode  
2. Scheme: **BlueMoorLearn** · Destination: **My Mac**  
3. Press **⌘R**

```bash
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
cd /path/to/BlueMoorLearn
xcodebuild -project BlueMoorLearn.xcodeproj -scheme BlueMoorLearn -destination 'platform=macOS' build
```

## Layout

```
BlueMoorLearn/
├── BlueMoorLearnApp.swift
├── Models/
├── Views/
├── Services/
├── ViewModels/
├── Resources/
└── Assets.xcassets
```

## v1

- NavigationSplitView: Today / History / Cosmos / Explore / Progress
- SwiftData profile, streaks, XP, lesson progress
- Sample History + Cosmos lessons (Overview / Standard / Deep)
- Quizzes + onboarding
