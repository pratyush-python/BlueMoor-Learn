import Foundation
import SwiftData

@Model
final class LessonProgress {
    var id: UUID
    var lessonId: UUID
    var lessonTitle: String
    var category: LessonCategory
    
    var completedDepths: [LessonDepth]   // Which depths user has finished
    var bestQuizScore: Double?           // Percentage 0-1
    var totalXPEarned: Int
    var lastStudied: Date
    var timesCompleted: Int
    
    init(lesson: Lesson) {
        self.id = UUID()
        self.lessonId = lesson.id
        self.lessonTitle = lesson.title
        self.category = lesson.category
        self.completedDepths = []
        self.bestQuizScore = nil
        self.totalXPEarned = 0
        self.lastStudied = Date()
        self.timesCompleted = 0
    }
    
    func markDepthCompleted(_ depth: LessonDepth, xpEarned: Int) {
        if !completedDepths.contains(depth) {
            completedDepths.append(depth)
        }
        totalXPEarned += xpEarned
        lastStudied = Date()
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
