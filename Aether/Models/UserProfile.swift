import Foundation
import SwiftData

@Model
final class UserProfile {
    var id: UUID
    var createdAt: Date
    var lastActiveDate: Date
    
    // Personalization
    var preferredDepth: LessonDepth
    var interestTags: [InterestTag]          // Stored as raw values or we can use a transform
    
    // Gamification
    var totalXP: Int
    var currentStreak: Int
    var longestStreak: Int
    var lastStreakDate: Date?
    
    // Onboarding
    var hasCompletedOnboarding: Bool
    
    init(
        preferredDepth: LessonDepth = .standard,
        interestTags: [InterestTag] = [],
        hasCompletedOnboarding: Bool = false
    ) {
        self.id = UUID()
        self.createdAt = Date()
        self.lastActiveDate = Date()
        self.preferredDepth = preferredDepth
        self.interestTags = interestTags
        self.totalXP = 0
        self.currentStreak = 0
        self.longestStreak = 0
        self.hasCompletedOnboarding = hasCompletedOnboarding
    }
    
    // Computed
    var level: Int {
        // Simple level formula: every ~400 XP = 1 level
        max(1, Int(sqrt(Double(totalXP) / 80)) + 1)
    }
    
    var xpForNextLevel: Int {
        let nextLevel = level + 1
        return (nextLevel * nextLevel * 80) - totalXP
    }
    
    var progressToNextLevel: Double {
        let currentLevelXP = (level * level * 80)
        let nextLevelXP = ((level + 1) * (level + 1) * 80)
        let xpInCurrentLevel = totalXP - currentLevelXP
        let xpNeededForLevel = nextLevelXP - currentLevelXP
        return min(1.0, max(0.0, Double(xpInCurrentLevel) / Double(xpNeededForLevel)))
    }
    
    // Update streak logic
    func updateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        guard let lastDate = lastStreakDate else {
            // First time
            currentStreak = 1
            lastStreakDate = today
            if currentStreak > longestStreak {
                longestStreak = currentStreak
            }
            return
        }
        
        let lastStreakDay = calendar.startOfDay(for: lastDate)
        let daysSince = calendar.dateComponents([.day], from: lastStreakDay, to: today).day ?? 0
        
        if daysSince == 0 {
            // Same day, do nothing
            return
        } else if daysSince == 1 {
            // Consecutive day
            currentStreak += 1
            lastStreakDate = today
        } else {
            // Streak broken
            currentStreak = 1
            lastStreakDate = today
        }
        
        if currentStreak > longestStreak {
            longestStreak = currentStreak
        }
    }
    
    func addXP(_ amount: Int) {
        totalXP += amount
        lastActiveDate = Date()
    }
    
    // Convenience for interest matching
    var primaryInterest: LessonCategory? {
        let historyCount = interestTags.filter { 
            $0 == .ancientCivilizations || $0 == .empiresAndRepublics 
        }.count
        let cosmosCount = interestTags.filter { 
            $0 == .spaceExploration || $0 == .cosmology || $0 == .astronomy 
        }.count
        
        if historyCount > cosmosCount { return .history }
        if cosmosCount > historyCount { return .cosmos }
        return nil
    }
}
