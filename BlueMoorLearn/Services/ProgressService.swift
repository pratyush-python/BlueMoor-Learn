import Foundation
import SwiftData

/// Handles all business logic around user progress, streaks, and XP.
final class ProgressService {
    private let modelContext: ModelContext
    private let contentService: ContentService

    init(modelContext: ModelContext, contentService: ContentService = .shared) {
        self.modelContext = modelContext
        self.contentService = contentService
    }

    // MARK: - Profile

    func fetchOrCreateProfile() -> UserProfile {
        let descriptor = FetchDescriptor<UserProfile>()
        if let existing = try? modelContext.fetch(descriptor).first {
            return existing
        }
        let newProfile = UserProfile()
        modelContext.insert(newProfile)
        try? modelContext.save()
        return newProfile
    }

    // MARK: - Lesson completion

    /// Records completion of a depth. Awards XP only the first time that depth is finished.
    @discardableResult
    func completeDepth(_ depth: LessonDepth, for lesson: Lesson, profile: UserProfile) -> Int {
        let progress = fetchOrCreateProgress(for: lesson)
        let isNew = progress.markDepthCompleted(depth, xpEarned: depth.xpReward)
        let xpEarned = isNew ? depth.xpReward : 0
        if isNew {
            profile.addXP(xpEarned)
            profile.updateStreak()
        } else {
            // Still counts as studying today for lastActive, but no streak double-count abuse
            profile.lastActiveDate = Date()
        }
        try? modelContext.save()
        return xpEarned
    }

    func recordQuizResult(score: Double, for lesson: Lesson, profile: UserProfile) {
        let progress = fetchOrCreateProgress(for: lesson)
        let previous = progress.bestQuizScore
        progress.updateQuizScore(score)

        // Bonus only when beating previous best (or first quiz)
        let isImprovement = previous == nil || score > (previous ?? 0)
        if isImprovement && score >= 0.8 {
            let bonus = Int(15 * score)
            profile.addXP(bonus)
        }
        try? modelContext.save()
    }

    func progress(for lesson: Lesson) -> LessonProgress? {
        progress(lessonId: lesson.id, contentId: lesson.contentId)
    }

    func isDepthCompleted(_ depth: LessonDepth, for lesson: Lesson) -> Bool {
        progress(for: lesson)?.completedDepths.contains(depth) ?? false
    }

    func fetchOrCreateProgress(for lesson: Lesson) -> LessonProgress {
        if let existing = progress(for: lesson) {
            // Keep title/id in sync if catalog refreshed
            existing.lessonTitle = lesson.title
            existing.lessonId = lesson.id
            if existing.contentId.isEmpty {
                existing.contentId = lesson.contentId
            }
            return existing
        }
        let created = LessonProgress(lesson: lesson)
        modelContext.insert(created)
        return created
    }

    private func progress(lessonId: UUID, contentId: String) -> LessonProgress? {
        // Prefer stable contentId when present
        if !contentId.isEmpty {
            let key = contentId
            let byContent = FetchDescriptor<LessonProgress>(
                predicate: #Predicate { $0.contentId == key }
            )
            if let hit = try? modelContext.fetch(byContent).first {
                return hit
            }
        }
        let id = lessonId
        let byUUID = FetchDescriptor<LessonProgress>(
            predicate: #Predicate { $0.lessonId == id }
        )
        return try? modelContext.fetch(byUUID).first
    }

    // MARK: - Stats

    struct WeekStats {
        var lessonsStarted: Int
        var depthsCompleted: Int
        var quizAccuracyPercent: Int?
    }

    func weekStats() -> WeekStats {
        let all = (try? modelContext.fetch(FetchDescriptor<LessonProgress>())) ?? []
        let depths = all.reduce(0) { $0 + $1.completedDepths.count }
        let started = all.filter { !$0.completedDepths.isEmpty || $0.bestQuizScore != nil }.count
        let quizScores = all.compactMap(\.bestQuizScore)
        let accuracy: Int? = quizScores.isEmpty
            ? nil
            : Int((quizScores.reduce(0, +) / Double(quizScores.count)) * 100)
        return WeekStats(
            lessonsStarted: started,
            depthsCompleted: depths,
            quizAccuracyPercent: accuracy
        )
    }

    // MARK: - Recommendations

    func recommendedLesson(for profile: UserProfile) -> Lesson? {
        let all = contentService.allLessons
        guard !all.isEmpty else { return nil }

        let preferred = profile.preferredDepth
        let primary = profile.primaryInterest

        // 1) Incomplete at preferred depth in primary interest
        if let primary {
            if let hit = all.first(where: { lesson in
                lesson.category == primary
                    && !(progress(for: lesson)?.completedDepths.contains(preferred) ?? false)
            }) {
                return hit
            }
        }

        // 2) Any incomplete at preferred depth
        if let hit = all.first(where: { lesson in
            !(progress(for: lesson)?.completedDepths.contains(preferred) ?? false)
        }) {
            return hit
        }

        // 3) Least recently studied
        return all.min { lhs, rhs in
            let l = progress(for: lhs)?.lastStudied ?? .distantPast
            let r = progress(for: rhs)?.lastStudied ?? .distantPast
            return l < r
        }
    }
}
