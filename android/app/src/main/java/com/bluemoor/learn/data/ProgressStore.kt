package com.bluemoor.learn.data

import android.content.Context
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.intPreferencesKey
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import org.json.JSONObject
import java.time.LocalDate
import java.time.format.DateTimeFormatter

private val Context.dataStore by preferencesDataStore("bluemoor_progress")

class ProgressStore(private val context: Context) {

    private val xpKey = intPreferencesKey("total_xp")
    private val streakKey = intPreferencesKey("current_streak")
    private val longestKey = intPreferencesKey("longest_streak")
    private val lastDayKey = stringPreferencesKey("last_streak_day")
    private val depthsKey = stringPreferencesKey("completed_depths_json")
    private val quizKey = stringPreferencesKey("quiz_scores_json")
    private val onboardedKey = booleanPreferencesKey("has_onboarded")
    private val depthPrefKey = stringPreferencesKey("preferred_depth")

    val progressFlow: Flow<UserProgress> = context.dataStore.data.map { prefs ->
        val depthsJson = prefs[depthsKey] ?: "{}"
        val quizJson = prefs[quizKey] ?: "{}"
        UserProgress(
            totalXp = prefs[xpKey] ?: 0,
            currentStreak = prefs[streakKey] ?: 0,
            longestStreak = prefs[longestKey] ?: 0,
            lastStreakDay = prefs[lastDayKey],
            completedDepths = parseDepths(depthsJson),
            bestQuizScores = parseQuiz(quizJson),
            hasOnboarded = prefs[onboardedKey] ?: false,
            preferredDepth = runCatching {
                LessonDepth.valueOf(prefs[depthPrefKey] ?: LessonDepth.STANDARD.name)
            }.getOrDefault(LessonDepth.STANDARD),
        )
    }

    suspend fun completeOnboarding(preferred: LessonDepth) {
        context.dataStore.edit { prefs ->
            prefs[onboardedKey] = true
            prefs[depthPrefKey] = preferred.name
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

        context.dataStore.edit { prefs ->
            prefs[xpKey] = current.totalXp + xp
            prefs[streakKey] = streak
            prefs[longestKey] = longest
            prefs[lastDayKey] = today
            prefs[depthsKey] = depthsToJson(depths)
        }
        return xp
    }

    suspend fun recordQuiz(lessonId: String, score: Float, current: UserProgress) {
        val scores = current.bestQuizScores.toMutableMap()
        val prev = scores[lessonId] ?: 0f
        scores[lessonId] = maxOf(prev, score)
        var bonus = 0
        if (score >= 0.8f) bonus = (15 * score).toInt()
        context.dataStore.edit { prefs ->
            prefs[quizKey] = quizToJson(scores)
            if (bonus > 0) prefs[xpKey] = current.totalXp + bonus
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
        map.forEach { (k, v) ->
            obj.put(k, org.json.JSONArray(v.toList()))
        }
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
}
