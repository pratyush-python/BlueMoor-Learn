#!/usr/bin/env python3
"""Sync content/lessons.json to Xcode Resources, web/content.js, Android assets."""
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CONTENT = ROOT / "content"
RES = ROOT / "BlueMoorLearn" / "Resources"
WEB = ROOT / "web"
ANDROID_ASSETS = ROOT / "android" / "app" / "src" / "main" / "assets"


def main() -> None:
    lessons_path = CONTENT / "lessons.json"
    if not lessons_path.exists():
        raise SystemExit(f"Missing {lessons_path}")

    catalog = json.loads(lessons_path.read_text(encoding="utf-8"))
    facts_path = CONTENT / "daily_facts.json"
    facts = (
        json.loads(facts_path.read_text(encoding="utf-8")).get("facts", [])
        if facts_path.exists()
        else []
    )

    RES.mkdir(parents=True, exist_ok=True)
    (RES / "lessons.json").write_text(
        json.dumps(catalog, indent=2, ensure_ascii=False) + "\n", encoding="utf-8"
    )
    if facts_path.exists():
        (RES / "daily_facts.json").write_bytes(facts_path.read_bytes())

    web_lessons = []
    for l in catalog["lessons"]:
        web_lessons.append(
            {
                "id": l["id"],
                "title": l["title"],
                "category": l["category"],
                "era": l.get("era") or "Science",
                "region": l.get("region")
                or ("Space" if l["category"] == "cosmos" else "Global"),
                "subtitle": l["subtitle"],
                "eraOrTopic": l["eraOrTopic"],
                "estimatedMinutes": l["estimatedMinutes"],
                "overview": l["overview"],
                "standard": l["standard"],
                "deep": l["deep"],
                "timeline": l["timeline"],
                "figures": [
                    {
                        "name": f["name"],
                        "role": f["role"],
                        "bio": f.get("shortBio") or f.get("bio") or "",
                    }
                    for f in l.get("figures", [])
                ],
                "quiz": [
                    {
                        "q": q.get("question") or q.get("q"),
                        "options": q["options"],
                        "answer": q.get("correctAnswerIndex", q.get("answer")),
                        "explain": q.get("explanation") or q.get("explain"),
                    }
                    for q in l.get("quiz", [])
                ],
            }
        )

    eras = ["All", "Ancient", "Classical", "Medieval", "Early Modern", "Modern", "Science"]
    depths = {
        "OVERVIEW": {"key": "OVERVIEW", "label": "Overview", "minutes": 4, "xp": 25},
        "STANDARD": {"key": "STANDARD", "label": "Standard", "minutes": 8, "xp": 60},
        "DEEP": {"key": "DEEP", "label": "Deep Dive", "minutes": 14, "xp": 120},
    }

    WEB.mkdir(parents=True, exist_ok=True)
    js = (
        "/* AUTO-GENERATED from content/lessons.json — run scripts/sync-content.sh */\n"
        f"window.BM_LESSONS = {json.dumps(web_lessons, indent=2, ensure_ascii=False)};\n\n"
        f"window.BM_DAILY_FACTS = {json.dumps(facts, indent=2, ensure_ascii=False)};\n\n"
        f"window.BM_DEPTHS = {json.dumps(depths, indent=2)};\n\n"
        f"window.BM_ERAS = {json.dumps(eras)};\n"
    )
    (WEB / "content.js").write_text(js, encoding="utf-8")

    if (ROOT / "android" / "app" / "src" / "main").exists():
        ANDROID_ASSETS.mkdir(parents=True, exist_ok=True)
        (ANDROID_ASSETS / "lessons.json").write_text(
            json.dumps(catalog, indent=2, ensure_ascii=False) + "\n", encoding="utf-8"
        )
        print(f"Wrote {ANDROID_ASSETS / 'lessons.json'}")
        if facts_path.exists():
            (ANDROID_ASSETS / "daily_facts.json").write_bytes(facts_path.read_bytes())
            print(f"Wrote {ANDROID_ASSETS / 'daily_facts.json'}")

    n = len(catalog["lessons"])
    print(f"Synced {n} lessons → Resources + web/content.js + Android assets")


if __name__ == "__main__":
    main()
