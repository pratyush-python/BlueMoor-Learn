import Foundation
import SwiftData

@Model
final class LessonProgress {
    var id: UUID
    var lessonId: UUID
    /// Shared JSON content key (e.g. `roman-republic`) — survives catalog reloads.
    var contentId: String = ""
    var lessonTitle: String
    var category: LessonCategory
    
    var completedDepths: [LessonDepth] = []
    var bestQuizScore: Double?
    var totalXPEarned: Int = 0
    var lastStudied: Date = Date()
    var timesCompleted: Int = 0
    
    init(lesson: Lesson) {
        self.id = UUID()
        self.lessonId = lesson.id
        self.contentId = lesson.contentId
        self.lessonTitle = lesson.title
        self.category = lesson.category
        self.completedDepths = []
        self.bestQuizScore = nil
        self.totalXPEarned = 0
        self.lastStudied = Date()
        self.timesCompleted = 0
    }
    
    /// Returns true if this depth was newly completed (XP should be awarded).
    @discardableResult
    func markDepthCompleted(_ depth: LessonDepth, xpEarned: Int) -> Bool {
        let isNew = !completedDepths.contains(depth)
        if isNew {
            completedDepths.append(depth)
            totalXPEarned += xpEarned
            timesCompleted += 1
        }
        lastStudied = Date()
        return isNew
    }
    
    func updateQuizScore(_ score: Double) {
        if let currentBest = bestQuizScore {
            bestQuizScore = max(currentBest, score)
        } else {
            bestQuizScore = score
        }
        lastStudied = Date()
    }
    
    var masteryLevel: Double {
        // Simple mastery based on depths completed + quiz performance
        let depthProgress = Double(completedDepths.count) / Double(LessonDepth.allCases.count)
        let quizBonus = (bestQuizScore ?? 0) * 0.3
        return min(1.0, depthProgress + quizBonus)
    }
}
