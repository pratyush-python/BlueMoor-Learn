# How to add more features & history content

## Single source of truth (preferred)

1. Edit **`content/lessons.json`** (and optionally `content/daily_facts.json`).
2. Run **`./scripts/sync-content.sh`**
3. Rebuild Xcode (⌘R), redeploy web if needed, rebuild Android if needed.

See `content/README.md` for the schema.

---

Blue Moor - Learn is designed so **content and features can grow without a rewrite**.

## 1. Add a history (or cosmos) lesson — fastest win

### Web / iPhone app (`web/content.js`)

1. Open `web/content.js`.
2. Copy an existing lesson object in `window.BM_LESSONS`.
3. Give it a **unique** `id` (e.g. `"gupta-empire"`).
4. Fill: `title`, `category` (`"history"` | `"cosmos"`), `era`, `region`, `subtitle`, `eraOrTopic`, depths (`overview` / `standard` / `deep`), `timeline`, `figures`, `quiz`.
5. Rebuild the single-file page and redeploy (see below).

```js
{
  id: "my-new-lesson",
  title: "…",
  category: "history",
  era: "Medieval",       // used by era filter chips
  region: "South Asia",  // shown as a tag
  subtitle: "…",
  eraOrTopic: "…",
  estimatedMinutes: 10,
  overview: "…",
  standard: "…",
  deep: "…",
  timeline: [{ year: "…", title: "…", description: "…" }],
  figures: [{ name: "…", role: "…", bio: "…" }],
  quiz: [{ q: "…", options: ["…"], answer: 0, explain: "…" }],
}
```

### Android (`android/.../ContentRepository.kt`)

Mirror the same lesson as a `Lesson(...)` entry in `allLessons` so Android testers get parity.

### Daily curiosity card

Add a line to `window.BM_DAILY_FACTS` in `content.js`. One fact is shown each day on **Today**.

---

## 2. Features already in the web app

| Feature | Where |
|--------|--------|
| Depths (Overview / Standard / Deep) | Lesson screen |
| Quizzes + XP | Lesson → Take quiz |
| Streaks & levels | Today / Progress |
| **Search** | History & Cosmos tabs |
| **Era filters** | History tab chips |
| **Favorites / Saved** | ☆ on cards + **Saved** tab |
| **Daily curiosity** | Today tab |

---

## 3. Ideas for future features (pick when ready)

- **Map view** of lesson regions  
- **Audio narration** of Overview  
- **Spaced repetition** for quiz misses  
- **Collections** (“Empires”, “Revolutions”)  
- **Native iOS** via TestFlight ($99 Apple program)  
- **Accounts / sync** (only with privacy-first backend)

---

## 4. Deploy web updates (iPhone link)

```bash
cd web
# rebuild single-file index if you use the inliner, then:
# push contents of web/ (or single index.html) to gh-pages
```

Live URL (lowercase): **https://pratyush-python.github.io/bluemoor-learn/**

---

## 5. Editorial tips for history content

- Prefer **primary-source hooks** (edicts, memoirs, maps).  
- Flag **debates** (“historians disagree…”) in Deep Dive.  
- Avoid communal or nationalist propaganda; keep multi-perspective tone.  
- Always include a short quiz so the learning loop stays active.
