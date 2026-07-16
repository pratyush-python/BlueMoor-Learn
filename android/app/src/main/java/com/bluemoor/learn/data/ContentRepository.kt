package com.bluemoor.learn.data

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject
import java.util.concurrent.atomic.AtomicReference

/**
 * Loads lessons from the shared catalog asset `lessons.json`
 * (synced from repo `content/lessons.json` via `scripts/sync-content.sh`).
 */
object ContentRepository {

    private val lessonsRef = AtomicReference<List<Lesson>>(emptyList())
    private val factsRef = AtomicReference<List<DailyFact>>(emptyList())
    @Volatile private var initialized = false

    data class DailyFact(val title: String, val text: String)

    /** Call once from Application.onCreate. Safe to call again. */
    fun init(context: Context) {
        if (initialized && lessonsRef.get().isNotEmpty()) return
        synchronized(this) {
            if (initialized && lessonsRef.get().isNotEmpty()) return
            val app = context.applicationContext
            lessonsRef.set(loadLessons(app))
            factsRef.set(loadDailyFacts(app))
            initialized = true
        }
    }

    val allLessons: List<Lesson>
        get() {
            ensureReady()
            return lessonsRef.get()
        }

    val dailyFacts: List<DailyFact>
        get() {
            ensureReady()
            return factsRef.get()
        }

    fun lessons(category: LessonCategory): List<Lesson> =
        allLessons.filter { it.category == category }

    fun lesson(id: String): Lesson? = allLessons.find { it.id == id }

    fun recommended(progress: UserProgress): Lesson {
        val list = allLessons
        require(list.isNotEmpty()) { "No lessons loaded — check assets/lessons.json" }
        val incomplete = list.firstOrNull { lesson ->
            val done = progress.completedDepths[lesson.id].orEmpty()
            !done.contains(progress.preferredDepth.name)
        }
        return incomplete
            ?: list.firstOrNull { it.category == LessonCategory.HISTORY }
            ?: list.first()
    }

    fun todaysFact(): DailyFact? {
        val facts = dailyFacts
        if (facts.isEmpty()) return null
        val day = java.util.Calendar.getInstance().get(java.util.Calendar.DAY_OF_YEAR)
        return facts[(day - 1).mod(facts.size)]
    }

    private fun ensureReady() {
        check(initialized) {
            "ContentRepository.init(context) must be called before use (see BlueMoorApp)"
        }
    }

    private fun loadLessons(context: Context): List<Lesson> {
        return try {
            val json = context.assets.open("lessons.json").bufferedReader().use { it.readText() }
            val root = JSONObject(json)
            val arr = root.getJSONArray("lessons")
            buildList {
                for (i in 0 until arr.length()) {
                    add(parseLesson(arr.getJSONObject(i)))
                }
            }
        } catch (e: Exception) {
            // Keep app usable if asset missing during early scaffold
            emptyList()
        }
    }

    private fun loadDailyFacts(context: Context): List<DailyFact> {
        return try {
            val json = context.assets.open("daily_facts.json").bufferedReader().use { it.readText() }
            val root = JSONObject(json)
            val arr = root.optJSONArray("facts") ?: return emptyList()
            buildList {
                for (i in 0 until arr.length()) {
                    val o = arr.getJSONObject(i)
                    add(DailyFact(title = o.getString("title"), text = o.getString("text")))
                }
            }
        } catch (_: Exception) {
            emptyList()
        }
    }

    private fun parseLesson(o: JSONObject): Lesson {
        val category = when (o.optString("category", "history").lowercase()) {
            "cosmos" -> LessonCategory.COSMOS
            else -> LessonCategory.HISTORY
        }
        return Lesson(
            id = o.getString("id"),
            title = o.getString("title"),
            category = category,
            subtitle = o.optString("subtitle", ""),
            eraOrTopic = o.optString("eraOrTopic", ""),
            estimatedMinutes = o.optInt("estimatedMinutes", 8),
            overviewContent = o.optString("overview", ""),
            standardContent = o.optString("standard", ""),
            deepContent = o.optString("deep", ""),
            timeline = parseTimeline(o.optJSONArray("timeline")),
            keyFigures = parseFigures(o.optJSONArray("figures")),
            quiz = parseQuiz(o.optJSONArray("quiz")),
            era = o.optString("era").ifBlank { null },
            region = o.optString("region").ifBlank { null },
        )
    }

    private fun parseTimeline(arr: JSONArray?): List<TimelineEvent> {
        if (arr == null) return emptyList()
        return buildList {
            for (i in 0 until arr.length()) {
                val o = arr.getJSONObject(i)
                add(
                    TimelineEvent(
                        year = o.optString("year", ""),
                        title = o.optString("title", ""),
                        description = o.optString("description", ""),
                    ),
                )
            }
        }
    }

    private fun parseFigures(arr: JSONArray?): List<KeyFigure> {
        if (arr == null) return emptyList()
        return buildList {
            for (i in 0 until arr.length()) {
                val o = arr.getJSONObject(i)
                val bio = o.optString("shortBio").ifBlank { o.optString("bio", "") }
                add(
                    KeyFigure(
                        name = o.optString("name", ""),
                        role = o.optString("role", ""),
                        shortBio = bio,
                        significance = o.optString("significance").ifBlank { bio },
                    ),
                )
            }
        }
    }

    private fun parseQuiz(arr: JSONArray?): List<QuizQuestion> {
        if (arr == null) return emptyList()
        return buildList {
            for (i in 0 until arr.length()) {
                val o = arr.getJSONObject(i)
                val optionsArr = o.optJSONArray("options") ?: JSONArray()
                val options = buildList {
                    for (j in 0 until optionsArr.length()) add(optionsArr.getString(j))
                }
                val type = o.optString("type").ifBlank {
                    if (options.size == 2 && options.firstOrNull() == "True") "trueFalse" else "multipleChoice"
                }
                add(
                    QuizQuestion(
                        type = type,
                        question = o.optString("question").ifBlank { o.optString("q", "") },
                        options = options,
                        correctAnswerIndex = o.optInt(
                            "correctAnswerIndex",
                            o.optInt("answer", 0),
                        ),
                        explanation = o.optString("explanation").ifBlank { o.optString("explain", "") },
                    ),
                )
            }
        }
    }
}
