# Sharing Blue Moor - Learn with iPhone testers

## Quick answer

| Method | WhatsApp? | Needs $99 Apple account? | Ready now? |
|--------|-----------|---------------------------|------------|
| **Mobile web app** (`web/`) | **Yes — send a link** | No | **Yes** |
| Native TestFlight IPA | Send **invite link**, not a file | **Yes** | After you enroll |
| AirDrop / email `.ipa` | Usually **no** (unsigned / untrusted) | Yes + device UDIDs (Ad Hoc) | Not practical for casual testing |

**You cannot simply copy an iPhone app file from Desktop → WhatsApp → Install** the way you did with `BlueMoorLearn.apk`.

---

## Option A — Web app (use this for friends today)

1. Open the GitHub Pages URL (see repo after deploy) **or** host `web/`.
2. WhatsApp the **https link**.
3. Tester opens in Safari → learns → optional “Add to Home Screen”.

Same 4 lessons, quizzes, XP/streaks as the Android test build.

---

## Option B — Real native app via TestFlight

When you want a true App Store-style install:

1. Enroll in [Apple Developer Program](https://developer.apple.com/programs/) ($99/year).
2. In Xcode: open `BlueMoorLearn.xcodeproj` → set Team → enable **iOS** destination.
3. Product → Archive → Distribute App → **App Store Connect**.
4. In App Store Connect → TestFlight → add internal/external testers by email.
5. Testers install the **TestFlight** app, then install Blue Moor - Learn from the invite.

### Requirements we still need on this machine

- Apple ID signed into Xcode with a **paid** team (currently: **0 signing identities**).
- iOS target (current Xcode project is **macOS-first** with AppKit menus; multiplatform conversion is next).

---

## Option C — Your own iPhone only (free, temporary)

With a free Apple ID you can plug **your** iPhone into this Mac, sign with “Personal Team”, and run from Xcode for ~7 days.  
That does **not** let random friends install via WhatsApp.
