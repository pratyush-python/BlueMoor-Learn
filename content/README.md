# Shared content (source of truth)

Edit **`lessons.json`** and **`daily_facts.json`** here. Do **not** hand-edit generated client copies for catalog data.

## After editing

```bash
./scripts/sync-content.sh
```

This updates:

| Target | Path |
|--------|------|
| Xcode bundle | `BlueMoorLearn/Resources/lessons.json` |
| Web app | `web/content.js` (generated) |
| Android assets | `android/app/src/main/assets/lessons.json` |

Then rebuild the client you care about (⌘R in Xcode, web deploy, Android APK).

## Lesson schema (each item in `lessons`)

```json
{
  "id": "roman-republic",
  "title": "…",
  "category": "history",
  "era": "Ancient",
  "region": "Mediterranean",
  "subtitle": "…",
  "eraOrTopic": "…",
  "estimatedMinutes": 9,
  "tags": ["ancientCivilizations", "empiresAndRepublics"],
  "overview": "…",
  "standard": "…",
  "deep": "…",
  "timeline": [{ "year": "…", "title": "…", "description": "…" }],
  "figures": [{ "name": "…", "role": "…", "shortBio": "…", "significance": "…" }],
  "quiz": [{
    "type": "multipleChoice",
    "question": "…",
    "options": ["…"],
    "correctAnswerIndex": 0,
    "explanation": "…"
  }],
  "heroImageName": null
}
```

`id` must be unique and stable forever (progress keys depend on it).
