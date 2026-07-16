import Foundation
import SwiftData

/// Handles all business logic around user progress, streaks, and XP.
/// Keeps ViewModels and Views clean.
final class ProgressService {
    private let modelContext: ModelContext
    private let contentService: ContentService
    
    init(modelContext: ModelContext, contentService: ContentService = .shared) {
        self.modelContext = modelContext
        self.contentService = contentService
    }
    
    // MARK: - Profile Access
    
    func fetchOrCreateProfile() -> UserProfile {
        let descriptor = FetchDescriptor<UserProfile>()
        
        if let existing = try? modelContext.fetch(descriptor).first {
            return existing
        } else {
            let newProfile = UserProfile()
            modelContext.insert(newProfile)
            try? modelContext.save()
            return newProfile
        }
    }
    
    // MARK: - Lesson Completion & XP
    
    /// Records that a user completed a specific depth of a lesson.
    /// Awards XP and updates streak.
    @discardableResult
    func completeDepth(_ depth: LessonDepth, for lesson: Lesson, profile: UserProfile) -> Int {
        let xpEarned = depth.xpReward
        
        // Find or create progress record
        let progress = fetchOrCreateProgress(for: lesson, profile: profile)
        progress.markDepthCompleted(depth, xpEarned: xpEarned)
        
        // Award XP to profile
        profile.addXP(xpEarned)
        profile.updateStreak()
        
        try? modelContext.save()
        
        return xpEarned
    }
    
    /// Records quiz performance
    func recordQuizResult(score: Double, for lesson: Lesson, profile: UserProfile) {
        let progress = fetchOrCreateProgress(for: lesson, profile: profile)
        progress.updateQuizScore(score)
        
        // Bonus XP for good performance
        if score >= 0.8 {
            let bonus = Int(15 * score)
            profile.addXP(bonus)
        }
        
        try? modelContext.save()
    }
    
    private func fetchOrCreateProgress(for lesson: Lesson, profile: UserProfile) -> LessonProgress {
        let descriptor = FetchDescriptor<LessonProgress>(
            predicate: #Predicate { $0.lessonId == lesson.id }
        )
        
        if let existing = try? modelContext.fetch(descriptor).first {
            return existing
        } else {
            let newProgress = LessonProgress(lesson: lesson)
            modelContext.insert(newProgress)
            return newProgress
        }
    }
    
    // MARK: - Recommendations
    
    func recommendedLesson(for profile: UserProfile) -> Lesson? {
        let all = contentService.allLessons
        
        // Simple smart recommendation:
        // 1. Prefer user's primary interest category
        // 2. Prefer lessons not fully completed at their preferred depth
        // 3. Fall back to unstarted lessons
        
        let primaryCategory = profile.primaryInterest
        
        let sorted = all.sorted { lhs, rhs in
            let lhsProgress = progress(for: lhs)
            let rhsProgress = progress(for: rhs)
            
            // Prioritize primary interest
            if let primary = primaryCategory {
                if lhs.category == primary && rhs.category != primary { return true }
                if rhs.category == primary && lhs.category != primary { return false }
            }
            
            // Then prefer incomplete at preferred depth
            let lhsCompletedPreferred = lhsProgress?.completedDepths.contains(profile.preferredDepth) ?? false
            let rhsCompletedPreferred = rhsProgress?.completedDepths.contains(profile.preferredDepth) ?? false
            
            if !lhsCompletedPreferred && rhsCompletedPreferred { return true }
            if lhsCompletedPreferred && !rhsCompletedPreferred { return false }
            
            // Finally, sort by least recently studied
            return (lhsProgress?.lastStudied ?? .distantPast) < (rhsProgress?.lastStudied ?? .distantPast)
        }
        
        return sorted.first
    }
    
    private func progress(for lesson: Lesson) -> LessonProgress? {
        let descriptor = FetchDescriptor<LessonProgress>(
            predicate: #Predicate { $0.lessonId == lesson.id }
        )
        return try? modelContext.fetch(descriptor).first
    }
}
