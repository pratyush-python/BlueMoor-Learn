# Blue Moor - Learn — iOS / iPhone testing

**Branch:** `platform/ios`  
**Product name:** Blue Moor - Learn

## Shareable iPhone testing (now)

iOS does **not** allow WhatsApp / AirDrop of a random `.ipa` install the way Android allows APK sideloading.

### Option A — Mobile web app (recommended for friends)

Open in **Safari on any iPhone** (no App Store, no developer account):

- Source: `web/` in this repo  
- Hosted via GitHub Pages (see `web/README.md`)  
- Progress saved in the browser on that device  
- “Add to Home Screen” for an app-like icon

### Option B — Native app via TestFlight (later)

Requires:

1. Apple Developer Program (**$99/year**)  
2. Xcode signed archive of the iOS target  
3. App Store Connect + TestFlight invite email  

See `IOS_SHARE.md` for the full checklist.

## Native iOS roadmap

| Layer | Choice |
|-------|--------|
| UI | SwiftUI (shared patterns with macOS) |
| Persistence | SwiftData / AppStorage |
| Min OS | iOS 17+ |

### Phases

- [x] Mobile web shareable build (`web/`)
- [ ] Multiplatform iOS target (drop AppKit-only APIs)
- [ ] TestFlight internal testing
- [ ] App Store submission
