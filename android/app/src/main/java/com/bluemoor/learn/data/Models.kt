package com.bluemoor.learn.data

enum class LessonCategory(val label: String) {
    HISTORY("History"),
    COSMOS("Cosmos"),
}

enum class LessonDepth(val label: String, val minutes: Int, val xp: Int) {
    OVERVIEW("Overview", 4, 25),
    STANDARD("Standard", 8, 60),
    DEEP("Deep Dive", 14, 120),
}

data class TimelineEvent(
    val year: String,
    val title: String,
    val description: String,
)

data class KeyFigure(
    val name: String,
    val role: String,
    val shortBio: String,
    val significance: String,
)

data class QuizQuestion(
    val type: String, // multipleChoice | trueFalse
    val question: String,
    val options: List<String>,
    val correctAnswerIndex: Int,
    val explanation: String,
)

data class Lesson(
    val id: String,
    val title: String,
    val category: LessonCategory,
    val subtitle: String,
    val eraOrTopic: String,
    val estimatedMinutes: Int,
    val overviewContent: String,
    val standardContent: String,
    val deepContent: String,
    val timeline: List<TimelineEvent>,
    val keyFigures: List<KeyFigure>,
    val quiz: List<QuizQuestion>,
    val era: String? = null,
    val region: String? = null,
    /** Asset path under assets/, e.g. images/roman-republic.jpg */
    val heroImage: String? = null,
) {
    fun contentFor(depth: LessonDepth): String = when (depth) {
        LessonDepth.OVERVIEW -> overviewContent
        LessonDepth.STANDARD -> standardContent
        LessonDepth.DEEP -> deepContent
    }
}

data class UserProgress(
    val totalXp: Int = 0,
    val currentStreak: Int = 0,
    val longestStreak: Int = 0,
    val lastStreakDay: String? = null, // yyyy-MM-dd
    val completedDepths: Map<String, Set<String>> = emptyMap(), // lessonId -> depth names
    val bestQuizScores: Map<String, Float> = emptyMap(),
    val hasOnboarded: Boolean = false,
    val preferredDepth: LessonDepth = LessonDepth.STANDARD,
) {
    val level: Int
        get() = maxOf(1, kotlin.math.sqrt(totalXp / 80.0).toInt() + 1)

    fun xpToNextLevel(): Int {
        val next = level + 1
        return (next * next * 80) - totalXp
    }

    fun progressToNextLevel(): Float {
        val currentLevelXp = level * level * 80
        val nextLevelXp = (level + 1) * (level + 1) * 80
        val inLevel = totalXp - currentLevelXp
        val need = (nextLevelXp - currentLevelXp).coerceAtLeast(1)
        return (inLevel.toFloat() / need).coerceIn(0f, 1f)
    }
}
