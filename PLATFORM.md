# Blue Moor - Learn — Windows roadmap

**Branch:** `platform/windows`  
**Product name:** Blue Moor - Learn  
**Status:** Planned (not implemented on this branch yet)

## Goal

Deliver **Blue Moor - Learn** on Windows desktops/laptops with a native-feeling desktop UX:

- Sidebar or nav rail (Today / History / Cosmos / Explore / Progress)
- Lesson reader with depth levels
- Quizzes, streaks, XP
- Onboarding + settings
- Local progress persistence

## Recommended stack (pick one direction)

### Option A — .NET MAUI / WinUI (recommended default)
| Layer | Choice |
|-------|--------|
| UI | **WinUI 3** or **.NET MAUI** (Windows-focused) |
| Language | **C#** |
| Persistence | **SQLite** + lightweight repositories |
| Packaging | **MSIX** / Microsoft Store |

### Option B — Cross-platform later
| Layer | Choice |
|-------|--------|
| UI | Flutter or Uno Platform |
| Rationale | Share more with Android; more abstraction cost |

**Default for this branch:** Option A (WinUI 3 or MAUI) unless product decides on Flutter/Uno.

## Phases

### Phase 0 — Scaffold
- [ ] Visual Studio solution under e.g. `windows/`
- [ ] App identity: display name **Blue Moor - Learn**
- [ ] Dark theme tokens (aligned with macOS palette)
- [ ] Shell navigation mirroring macOS information architecture

### Phase 1 — Core loop
- [ ] Port domain models (Lesson, progress, streak/XP rules)
- [ ] Bundle sample lesson content
- [ ] Today + libraries + lesson + quiz
- [ ] Local SQLite progress store

### Phase 2 — Windows polish
- [ ] Keyboard shortcuts, snap layouts, high DPI
- [ ] Accessibility (Narrator, contrast)
- [ ] Settings (depth preference, interests)
- [ ] Store packaging + privacy disclosure

### Phase 3 — Later
- [ ] Optional cloud sync (if product prioritizes)
- [ ] Toast notifications for streak (opt-in)
- [ ] ARM64 Windows support validation

## Explicit non-goals (initially)

- Full Win32 legacy UI
- Xbox / UWP-only dead ends without Store strategy
- Parity with every experimental macOS feature on day one

## Open questions

1. WinUI 3 vs .NET MAUI?
2. Microsoft Store only vs sideload MSIX + Store?
3. Any need to share C# domain with other platforms via libraries?

## Working agreement

- Windows project lives on this branch under `windows/` (or similar).
- Do not modify macOS `main` build for Windows-only experiments.
- First PR should lock stack choice (WinUI vs MAUI) and folder layout.
