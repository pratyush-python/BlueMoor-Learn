(() => {
  const STORE_KEY = "bluemoor_progress_v2";
  const $ = (sel, el = document) => el.querySelector(sel);
  const app = $("#app");

  const defaultProgress = () => ({
    totalXp: 0,
    currentStreak: 0,
    longestStreak: 0,
    lastStreakDay: null,
    completedDepths: {},
    bestQuizScores: {},
    favorites: [],
    hasOnboarded: false,
    preferredDepth: "STANDARD",
  });

  function loadProgress() {
    try {
      const raw = JSON.parse(localStorage.getItem(STORE_KEY) || localStorage.getItem("bluemoor_progress_v1") || "{}");
      return { ...defaultProgress(), ...raw, favorites: raw.favorites || [] };
    } catch {
      return defaultProgress();
    }
  }

  function saveProgress(p) {
    localStorage.setItem(STORE_KEY, JSON.stringify(p));
  }

  function levelOf(xp) {
    return Math.max(1, Math.floor(Math.sqrt(xp / 80)) + 1);
  }

  function progressToNext(xp) {
    const level = levelOf(xp);
    const cur = level * level * 80;
    const next = (level + 1) * (level + 1) * 80;
    const need = Math.max(1, next - cur);
    return Math.min(1, Math.max(0, (xp - cur) / need));
  }

  function xpToNext(xp) {
    const level = levelOf(xp);
    const next = (level + 1) * (level + 1) * 80;
    return next - xp;
  }

  function todayISO() {
    return new Date().toISOString().slice(0, 10);
  }

  function yesterdayISO() {
    const d = new Date();
    d.setDate(d.getDate() - 1);
    return d.toISOString().slice(0, 10);
  }

  function greeting() {
    const h = new Date().getHours();
    if (h >= 5 && h < 12) return "Good morning.";
    if (h >= 12 && h < 17) return "Good afternoon.";
    return "Good evening.";
  }

  function dayOfYear() {
    const now = new Date();
    const start = new Date(now.getFullYear(), 0, 0);
    return Math.floor((now - start) / 86400000);
  }

  function dailyFact() {
    const facts = window.BM_DAILY_FACTS || [];
    if (!facts.length) return null;
    return facts[dayOfYear() % facts.length];
  }

  function contentFor(lesson, depth) {
    if (depth === "OVERVIEW") return lesson.overview;
    if (depth === "DEEP") return lesson.deep;
    return lesson.standard;
  }

  function recommended(p) {
    const incomplete = window.BM_LESSONS.find((l) => {
      const done = p.completedDepths[l.id] || [];
      return !done.includes(p.preferredDepth);
    });
    if (incomplete) return incomplete;
    // Prefer history for discovery if all complete
    return window.BM_LESSONS.find((l) => l.category === "history") || window.BM_LESSONS[0];
  }

  function isFav(id) {
    return (state.progress.favorites || []).includes(id);
  }

  function toggleFav(id) {
    const set = new Set(state.progress.favorites || []);
    if (set.has(id)) set.delete(id);
    else set.add(id);
    state.progress = { ...state.progress, favorites: [...set] };
    saveProgress(state.progress);
    toast(set.has(id) ? "Saved to favorites" : "Removed from favorites");
  }

  function filterLessons(category) {
    let list = window.BM_LESSONS.filter((l) => l.category === category);
    if (state.era && state.era !== "All") {
      list = list.filter((l) => (l.era || "") === state.era);
    }
    const q = (state.search || "").trim().toLowerCase();
    if (q) {
      list = list.filter((l) => {
        const blob = [l.title, l.subtitle, l.eraOrTopic, l.region, l.era, l.overview]
          .join(" ")
          .toLowerCase();
        return blob.includes(q);
      });
    }
    return list;
  }

  const state = {
    progress: loadProgress(),
    tab: "today",
    lessonId: null,
    showQuiz: false,
    depth: null,
    quizIndex: 0,
    selected: null,
    correctCount: 0,
    finished: false,
    toast: null,
    search: "",
    era: "All",
  };

  function setSecure(on) {
    document.body.dataset.quiz = on ? "1" : "0";
  }

  function toast(msg) {
    state.toast = msg;
    render();
    setTimeout(() => {
      state.toast = null;
      render();
    }, 1600);
  }

  function completeDepth(lessonId, depth) {
    const p = state.progress;
    const meta = window.BM_DEPTHS[depth];
    const depths = { ...p.completedDepths };
    const set = new Set(depths[lessonId] || []);
    set.add(depth);
    depths[lessonId] = [...set];

    let streak = p.currentStreak;
    let longest = p.longestStreak;
    const today = todayISO();
    if (!p.lastStreakDay) streak = 1;
    else if (p.lastStreakDay === today) {
      /* same day */
    } else if (p.lastStreakDay === yesterdayISO()) streak += 1;
    else streak = 1;
    if (streak > longest) longest = streak;

    state.progress = {
      ...p,
      totalXp: p.totalXp + meta.xp,
      currentStreak: streak,
      longestStreak: longest,
      lastStreakDay: today,
      completedDepths: depths,
    };
    saveProgress(state.progress);
    toast(`+${meta.xp} XP earned`);
  }

  function recordQuiz(lessonId, score) {
    const p = state.progress;
    const scores = { ...p.bestQuizScores };
    scores[lessonId] = Math.max(scores[lessonId] || 0, score);
    let bonus = 0;
    if (score >= 0.8) bonus = Math.floor(15 * score);
    state.progress = {
      ...p,
      totalXp: p.totalXp + bonus,
      bestQuizScores: scores,
    };
    saveProgress(state.progress);
  }

  function esc(s) {
    return String(s)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;");
  }

  function lessonCard(lesson, extra = "") {
    const cat = lesson.category === "history" ? "history" : "cosmos";
    const label = cat === "history" ? "HISTORY" : "COSMOS";
    const fav = isFav(lesson.id) ? "★" : "☆";
    const tags = [lesson.era, lesson.region].filter(Boolean).join(" · ");
    return `
      <div class="card clickable" data-open="${esc(lesson.id)}">
        <div class="card-hero ${cat}">
          <span>${label}</span>
          <button type="button" class="fav-btn" data-fav="${esc(lesson.id)}" aria-label="Favorite">${fav}</button>
        </div>
        <div style="font-weight:650;font-size:17px">${esc(lesson.title)}</div>
        <div class="muted" style="font-size:13px;margin-top:2px">${esc(lesson.eraOrTopic)}</div>
        ${tags ? `<div class="tag-row"><span class="tag">${esc(tags)}</span></div>` : ""}
        <div class="dim" style="margin-top:6px">${esc(lesson.subtitle)}</div>
        ${extra ? `<div class="cyan" style="font-size:12px;margin-top:8px">${esc(extra)}</div>` : ""}
      </div>`;
  }

  function navBar() {
    const items = [
      ["today", "⌂", "Today"],
      ["history", "📜", "History"],
      ["cosmos", "✦", "Cosmos"],
      ["saved", "★", "Saved"],
      ["progress", "▣", "Progress"],
    ];
    return `
      <nav class="bottom-nav">
        ${items
          .map(
            ([id, ico, label]) => `
          <button type="button" data-tab="${id}" class="${state.tab === id ? "active" : ""}">
            <span class="ico">${ico}</span>${label}
          </button>`,
          )
          .join("")}
      </nav>`;
  }

  function searchAndEraBar(showEra) {
    const eras = window.BM_ERAS || ["All"];
    return `
      <div class="search-wrap">
        <input type="search" id="search" placeholder="Search lessons…" value="${esc(state.search)}" />
      </div>
      ${
        showEra
          ? `<div class="era-row">
        ${eras
          .map(
            (e) =>
              `<button type="button" class="btn-chip ${state.era === e ? "active" : ""}" data-era="${esc(e)}">${esc(e)}</button>`,
          )
          .join("")}
      </div>`
          : ""
      }`;
  }

  function renderOnboarding() {
    const depths = Object.values(window.BM_DEPTHS);
    const sel = state.progress.preferredDepth;
    app.innerHTML = `
      <div class="screen full-pad onboard">
        <div class="brand">Blue Moor - Learn</div>
        <div class="h1">History. Cosmos. Mastery.</div>
        <p class="muted">Pick a default lesson depth. You can change it anytime in a lesson.</p>
        <div class="mt24 row wrap gap8">
          ${depths
            .map(
              (d) => `
            <button type="button" class="btn-chip ${sel === d.key ? "active" : ""}" data-depth="${d.key}">
              ${d.label} · ${d.minutes} min · ${d.xp} XP
            </button>`,
            )
            .join("")}
        </div>
        <button type="button" class="btn-primary mt24" id="start-btn">Start learning</button>
        <p class="disclaimer">Educational content only. Blue Moor is not SEBI-registered.</p>
      </div>`;

    app.querySelectorAll("[data-depth]").forEach((b) =>
      b.addEventListener("click", () => {
        state.progress.preferredDepth = b.dataset.depth;
        render();
      }),
    );
    $("#start-btn").addEventListener("click", () => {
      state.progress.hasOnboarded = true;
      saveProgress(state.progress);
      render();
    });
  }

  function renderToday() {
    const p = state.progress;
    const rec = recommended(p);
    const lvl = levelOf(p.totalXp);
    const pct = Math.round(progressToNext(p.totalXp) * 100);
    const fact = dailyFact();
    const histCount = window.BM_LESSONS.filter((l) => l.category === "history").length;
    const picks = window.BM_LESSONS.filter((l) => l.category === "history")
      .sort(() => 0.5 - Math.random())
      .slice(0, 2);

    app.innerHTML = `
      <div class="screen">
        <div class="brand">Blue Moor - Learn</div>
        <div class="h1">${esc(greeting())}</div>
        <p class="muted">${histCount} history lessons · search, save, and go deep.</p>
        <div class="card mt16">
          <div class="row">
            <div class="stat-circle">
              <strong>${p.currentStreak}</strong>
              <span>day streak</span>
            </div>
            <div class="grow">
              <div style="font-weight:650;font-size:18px">Level ${lvl}</div>
              <div class="cyan" style="font-size:14px">${p.totalXp} XP</div>
              <div class="progress-bar mt12"><i style="width:${pct}%"></i></div>
              <div class="dim mt8">${xpToNext(p.totalXp)} XP to Level ${lvl + 1}</div>
            </div>
          </div>
        </div>
        ${
          fact
            ? `<div class="card fact-card mt12">
          <div class="fact-label">Today in curiosity</div>
          <div class="fact-title">${esc(fact.title)}</div>
          <div class="muted" style="font-size:14px;margin-top:6px">${esc(fact.text)}</div>
        </div>`
            : ""
        }
        <div class="h2">Recommended for you</div>
        ${lessonCard(rec, "Tap to open")}
        <div class="h2">History picks</div>
        ${picks.map((l) => lessonCard(l)).join("")}
        <p class="disclaimer">Tip: Share → Add to Home Screen for an app icon.</p>
      </div>
      ${navBar()}`;
    wireNavAndCards();
  }

  function renderLibrary(category) {
    const lessons = filterLessons(category);
    const title = category === "history" ? "History" : "Cosmos";
    app.innerHTML = `
      <div class="screen">
        <div class="h1">${title}</div>
        <p class="muted">${lessons.length} lesson${lessons.length === 1 ? "" : "s"}</p>
        ${searchAndEraBar(category === "history")}
        ${
          lessons.length
            ? lessons
                .map((l) => {
                  const n = (state.progress.completedDepths[l.id] || []).length;
                  return lessonCard(l, n ? `${n} depth(s) done` : "");
                })
                .join("")
            : `<div class="card"><p class="muted">No lessons match your search.</p></div>`
        }
      </div>
      ${navBar()}`;
    wireNavAndCards();
    wireSearch(category === "history");
  }

  function renderSaved() {
    const favs = (state.progress.favorites || [])
      .map((id) => window.BM_LESSONS.find((l) => l.id === id))
      .filter(Boolean);
    app.innerHTML = `
      <div class="screen">
        <div class="h1">Saved</div>
        <p class="muted">${favs.length ? "Your bookmarked lessons." : "Tap ☆ on any lesson card to save it here."}</p>
        ${favs.length ? favs.map((l) => lessonCard(l, "Favorite")).join("") : `<div class="card"><p class="muted mb0">No favorites yet — explore History.</p></div>`}
      </div>
      ${navBar()}`;
    wireNavAndCards();
  }

  function renderProgress() {
    const p = state.progress;
    const pref = window.BM_DEPTHS[p.preferredDepth]?.label || p.preferredDepth;
    const completedLessons = Object.keys(p.completedDepths || {}).length;
    app.innerHTML = `
      <div class="screen">
        <div class="h1">Progress</div>
        <div class="card"><div class="muted" style="font-size:13px">Total XP</div><div class="gold" style="font-size:26px;font-weight:700">${p.totalXp}</div></div>
        <div class="card"><div class="muted" style="font-size:13px">Level</div><div class="cyan" style="font-size:26px;font-weight:700">${levelOf(p.totalXp)}</div></div>
        <div class="card"><div class="muted" style="font-size:13px">Current streak</div><div class="gold" style="font-size:26px;font-weight:700">${p.currentStreak} days</div></div>
        <div class="card"><div class="muted" style="font-size:13px">Lessons touched</div><div class="cyan" style="font-size:26px;font-weight:700">${completedLessons}</div></div>
        <div class="card mb0"><div class="muted" style="font-size:13px">Favorites</div><div class="gold" style="font-size:26px;font-weight:700">${(p.favorites || []).length}</div></div>
        <p class="muted mt16">Preferred depth: ${esc(pref)}</p>
      </div>
      ${navBar()}`;
    wireNavAndCards();
  }

  function renderLesson() {
    const lesson = window.BM_LESSONS.find((l) => l.id === state.lessonId);
    if (!lesson) {
      state.lessonId = null;
      return render();
    }
    const depth = state.depth || state.progress.preferredDepth;
    state.depth = depth;
    const done = state.progress.completedDepths[lesson.id] || [];
    const fav = isFav(lesson.id) ? "★ Saved" : "☆ Save";
    app.innerHTML = `
      <div class="screen full-pad">
        <div class="topbar">
          <button type="button" class="back" id="back">‹</button>
          <h1>${esc(lesson.title)}</h1>
          <button type="button" class="btn-chip" id="fav-inline">${fav}</button>
        </div>
        <div class="muted">${esc(lesson.eraOrTopic)}</div>
        <div class="tag-row mt8">
          ${lesson.era ? `<span class="tag">${esc(lesson.era)}</span>` : ""}
          ${lesson.region ? `<span class="tag">${esc(lesson.region)}</span>` : ""}
        </div>
        <div class="dim mt8">${esc(lesson.subtitle)}</div>
        <div class="row wrap gap8 mt16">
          ${Object.values(window.BM_DEPTHS)
            .map(
              (d) => `
            <button type="button" class="btn-chip ${depth === d.key ? "active" : ""}" data-set-depth="${d.key}">${d.label}</button>`,
            )
            .join("")}
        </div>
        <div class="lesson-body mt16">${esc(contentFor(lesson, depth))}</div>
        <div class="h2 cyan">Timeline</div>
        ${lesson.timeline
          .map(
            (t) => `
          <div class="timeline-item">
            <div class="y">${esc(t.year)} — ${esc(t.title)}</div>
            <div class="d">${esc(t.description)}</div>
          </div>`,
          )
          .join("")}
        <div class="h2 cyan">Key figures</div>
        ${lesson.figures
          .map(
            (f) => `
          <div class="mt12">
            <div style="font-weight:650">${esc(f.name)}</div>
            <div class="muted" style="font-size:13px">${esc(f.role)} · ${esc(f.bio)}</div>
          </div>`,
          )
          .join("")}
        <button type="button" class="btn-primary mt24" id="complete">
          ${done.includes(depth) ? `Mark ${window.BM_DEPTHS[depth].label} again (+${window.BM_DEPTHS[depth].xp} XP)` : `Complete ${window.BM_DEPTHS[depth].label} (+${window.BM_DEPTHS[depth].xp} XP)`}
        </button>
        <button type="button" class="btn-secondary mt12" id="quiz">Take quiz</button>
      </div>`;
    $("#back").onclick = () => {
      state.lessonId = null;
      state.showQuiz = false;
      render();
    };
    $("#fav-inline").onclick = () => {
      toggleFav(lesson.id);
      render();
    };
    app.querySelectorAll("[data-set-depth]").forEach((b) => {
      b.onclick = () => {
        state.depth = b.dataset.setDepth;
        render();
      };
    });
    $("#complete").onclick = () => {
      completeDepth(lesson.id, depth);
      render();
    };
    $("#quiz").onclick = () => {
      state.showQuiz = true;
      state.quizIndex = 0;
      state.selected = null;
      state.correctCount = 0;
      state.finished = false;
      render();
    };
  }

  function renderQuiz() {
    setSecure(true);
    const lesson = window.BM_LESSONS.find((l) => l.id === state.lessonId);
    if (!lesson) {
      state.showQuiz = false;
      return render();
    }
    const qs = lesson.quiz || [];
    const q = qs[state.quizIndex];

    if (state.finished || !q) {
      const score = qs.length ? state.correctCount / qs.length : 0;
      app.innerHTML = `
        <div class="screen full-pad">
          <div class="topbar">
            <button type="button" class="back" id="back">‹</button>
            <h1>Quiz · ${esc(lesson.title)}</h1>
          </div>
          <div class="h1">Quiz complete</div>
          <p class="muted mt12" style="font-size:18px;color:${score >= 0.8 ? "var(--warn)" : "var(--success)"}">
            Score: ${Math.round(score * 100)}% (${state.correctCount} / ${qs.length})
          </p>
          <button type="button" class="btn-primary mt24" id="done">Done</button>
        </div>`;
      $("#back").onclick = $("#done").onclick = () => {
        recordQuiz(lesson.id, score);
        state.showQuiz = false;
        setSecure(false);
        render();
      };
      return;
    }

    app.innerHTML = `
      <div class="screen full-pad">
        <div class="topbar">
          <button type="button" class="back" id="back">‹</button>
          <h1>Quiz · ${esc(lesson.title)}</h1>
        </div>
        <div class="muted">Question ${state.quizIndex + 1} of ${qs.length}</div>
        <div class="h2" style="margin-top:12px">${esc(q.q)}</div>
        ${q.options
          .map((opt, i) => {
            let cls = "quiz-opt";
            if (state.selected !== null) {
              cls += " disabled";
              if (i === q.answer) cls += " correct";
              else if (i === state.selected) cls += " wrong";
            }
            return `<div class="${cls}" data-opt="${i}">${esc(opt)}${state.selected !== null && i === q.answer ? " ✓" : ""}</div>`;
          })
          .join("")}
        ${
          state.selected !== null
            ? `<p class="muted mt12">${esc(q.explain)}</p>
               <button type="button" class="btn-primary mt16" id="next">${state.quizIndex >= qs.length - 1 ? "See results" : "Next"}</button>`
            : ""
        }
      </div>`;
    $("#back").onclick = () => {
      state.showQuiz = false;
      setSecure(false);
      render();
    };
    app.querySelectorAll("[data-opt]").forEach((el) => {
      el.onclick = () => {
        if (state.selected !== null) return;
        state.selected = Number(el.dataset.opt);
        if (state.selected === q.answer) state.correctCount += 1;
        render();
      };
    });
    const next = $("#next");
    if (next) {
      next.onclick = () => {
        if (state.quizIndex >= qs.length - 1) state.finished = true;
        else {
          state.quizIndex += 1;
          state.selected = null;
        }
        render();
      };
    }
  }

  function wireSearch(withEra) {
    const input = $("#search");
    if (input) {
      input.addEventListener("input", () => {
        state.search = input.value;
        // re-render library only
        if (state.tab === "history") renderLibrary("history");
        else if (state.tab === "cosmos") renderLibrary("cosmos");
        // restore focus/caret
        const again = $("#search");
        if (again) {
          again.focus();
          const len = again.value.length;
          again.setSelectionRange(len, len);
        }
      });
    }
    if (withEra) {
      app.querySelectorAll("[data-era]").forEach((b) => {
        b.onclick = () => {
          state.era = b.dataset.era;
          renderLibrary("history");
        };
      });
    }
  }

  function wireNavAndCards() {
    app.querySelectorAll("[data-tab]").forEach((b) => {
      b.onclick = () => {
        state.tab = b.dataset.tab;
        state.lessonId = null;
        state.showQuiz = false;
        state.search = "";
        setSecure(false);
        render();
      };
    });
    app.querySelectorAll("[data-fav]").forEach((btn) => {
      btn.onclick = (e) => {
        e.stopPropagation();
        toggleFav(btn.dataset.fav);
        render();
      };
    });
    app.querySelectorAll("[data-open]").forEach((c) => {
      c.onclick = () => {
        state.lessonId = c.dataset.open;
        state.depth = state.progress.preferredDepth;
        state.showQuiz = false;
        render();
      };
    });
  }

  function render() {
    if (!state.progress.hasOnboarded) {
      renderOnboarding();
    } else if (state.showQuiz && state.lessonId) {
      renderQuiz();
    } else if (state.lessonId) {
      setSecure(false);
      renderLesson();
    } else {
      setSecure(false);
      if (state.tab === "history") renderLibrary("history");
      else if (state.tab === "cosmos") renderLibrary("cosmos");
      else if (state.tab === "saved") renderSaved();
      else if (state.tab === "progress") renderProgress();
      else renderToday();
    }
    if (state.toast) {
      const t = document.createElement("div");
      t.className = "toast";
      t.textContent = state.toast;
      app.appendChild(t);
    }
  }

  render();
})();
