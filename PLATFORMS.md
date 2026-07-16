# Blue Moor - Learn — platforms

**Current production target:** **macOS** (`main`)

## Active platform branches

| Branch | Target | Status |
|--------|--------|--------|
| `main` | macOS (SwiftUI + SwiftData) | **Active / shipping foundation** |
| `platform/ios` | iOS / iPadOS | Planned — see branch `PLATFORM.md` |
| `platform/android` | Android | Planned — see branch `PLATFORM.md` |
| `platform/windows` | Windows | Planned — see branch `PLATFORM.md` |

## How we use branches

- **`main`** stays the stable macOS app.
- Each `platform/*` branch holds that platform’s roadmap and, later, implementation work.
- Prefer small PRs back into `main` only for **shared** design/docs; keep platform-native code on its branch until architecture is agreed.

## Product name

**Blue Moor - Learn**  
Blue Moor is not SEBI-registered; learning content is educational, not financial advice.
