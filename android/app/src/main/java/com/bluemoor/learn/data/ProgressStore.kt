package com.bluemoor.learn.data

import android.content.Context
import android.content.SharedPreferences
import com.bluemoor.learn.security.SecureStorage
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.withContext
import org.json.JSONArray
import org.json.JSONObject
import java.time.LocalDate
import java.time.format.DateTimeFormatter

/**
 * Progress persisted only via [SecureStorage] (Keystore-backed AES-256).
 * No network I/O — all data stays on-device.
 */
class ProgressStore(context: Context) {

    private val appContext = context.applicationContext
    private val prefs: SharedPreferences = SecureStorage.encryptedPreferences(appContext)

    private val _progress = MutableStateFlow(load())
    val progressFlow: StateFlow<UserProgress> = _progress.asStateFlow()

    init {
        SecureStorage.wipeLegacyPlainStores(appContext)
    }

    suspend fun completeOnboarding(preferred: LessonDepth) {
        write {
            putBoolean(KEY_ONBOARDED, true)
            putString(KEY_DEPTH_PREF, preferred.name)
        }
    }

    suspend fun completeDepth(lessonId: String, depth: LessonDepth, current: UserProgress): Int {
        val xp = depth.xp
        val depths = current.completedDepths.toMutableMap()
        val set = depths[lessonId]?.toMutableSet() ?: mutableSetOf()
        set.add(depth.name)
        depths[lessonId] = set

        val today = LocalDate.now().format(DateTimeFormatter.ISO_LOCAL_DATE)
        var streak = current.currentStreak
        var longest = current.longestStreak
        val last = current.lastStreakDay
        when {
            last == null -> streak = 1
            last == today -> { /* same day */ }
            last == LocalDate.now().minusDays(1).format(DateTimeFormatter.ISO_LOCAL_DATE) -> streak += 1
            else -> streak = 1
        }
        if (streak > longest) longest = streak

        write {
            putInt(KEY_XP, current.totalXp + xp)
            putInt(KEY_STREAK, streak)
            putInt(KEY_LONGEST, longest)
            putString(KEY_LAST_DAY, today)
            putString(KEY_DEPTHS, depthsToJson(depths))
        }
        return xp
    }

    suspend fun recordQuiz(lessonId: String, score: Float, current: UserProgress) {
        val scores = current.bestQuizScores.toMutableMap()
        val prev = scores[lessonId] ?: 0f
        scores[lessonId] = maxOf(prev, score)
        val bonus = if (score >= 0.8f) (15 * score).toInt() else 0
        write {
            putString(KEY_QUIZ, quizToJson(scores))
            if (bonus > 0) putInt(KEY_XP, current.totalXp + bonus)
        }
    }

    private suspend fun write(block: SharedPreferences.Editor.() -> Unit) {
        withContext(Dispatchers.IO) {
            val editor = prefs.edit()
            editor.block()
            // commit() is synchronous so UI state matches encrypted disk state
            if (editor.commit()) {
                _progress.value = load()
            }
        }
    }

    private fun load(): UserProgress {
        return try {
            val depthsJson = prefs.getString(KEY_DEPTHS, "{}") ?: "{}"
            val quizJson = prefs.getString(KEY_QUIZ, "{}") ?: "{}"
            UserProgress(
                totalXp = prefs.getInt(KEY_XP, 0),
                currentStreak = prefs.getInt(KEY_STREAK, 0),
                longestStreak = prefs.getInt(KEY_LONGEST, 0),
                lastStreakDay = prefs.getString(KEY_LAST_DAY, null),
                completedDepths = parseDepths(depthsJson),
                bestQuizScores = parseQuiz(quizJson),
                hasOnboarded = prefs.getBoolean(KEY_ONBOARDED, false),
                preferredDepth = runCatching {
                    LessonDepth.valueOf(
                        prefs.getString(KEY_DEPTH_PREF, LessonDepth.STANDARD.name)
                            ?: LessonDepth.STANDARD.name,
                    )
                }.getOrDefault(LessonDepth.STANDARD),
            )
        } catch (_: Exception) {
            // Corrupted ciphertext or Keystore unavailable
            UserProgress()
        }
    }

    private fun parseDepths(json: String): Map<String, Set<String>> {
        return try {
            val obj = JSONObject(json)
            obj.keys().asSequence().associateWith { key ->
                val arr = obj.getJSONArray(key)
                (0 until arr.length()).map { arr.getString(it) }.toSet()
            }
        } catch (_: Exception) {
            emptyMap()
        }
    }

    private fun depthsToJson(map: Map<String, Set<String>>): String {
        val obj = JSONObject()
        map.forEach { (k, v) -> obj.put(k, JSONArray(v.toList())) }
        return obj.toString()
    }

    private fun parseQuiz(json: String): Map<String, Float> {
        return try {
            val obj = JSONObject(json)
            obj.keys().asSequence().associateWith { obj.getDouble(it).toFloat() }
        } catch (_: Exception) {
            emptyMap()
        }
    }

    private fun quizToJson(map: Map<String, Float>): String {
        val obj = JSONObject()
        map.forEach { (k, v) -> obj.put(k, v.toDouble()) }
        return obj.toString()
    }

    companion object {
        private const val KEY_XP = "total_xp"
        private const val KEY_STREAK = "current_streak"
        private const val KEY_LONGEST = "longest_streak"
        private const val KEY_LAST_DAY = "last_streak_day"
        private const val KEY_DEPTHS = "completed_depths_json"
        private const val KEY_QUIZ = "quiz_scores_json"
        private const val KEY_ONBOARDED = "has_onboarded"
        private const val KEY_DEPTH_PREF = "preferred_depth"
    }
}
