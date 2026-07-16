import SwiftUI
import SwiftData

struct ProgressDashboardView: View {
    @Query private var profiles: [UserProfile]
    @Query private var allProgress: [LessonProgress]
    
    private var profile: UserProfile {
        profiles.first ?? UserProfile()
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 40) {
                Text("Your Journey")
                    .font(.largeTitle.weight(.semibold))
                
                // Big stats
                HStack(spacing: 24) {
                    statCard(title: "Total XP", value: "\(profile.totalXP)", icon: "star.fill", color: AetherTheme.warning)
                    statCard(title: "Current Level", value: "\(profile.level)", icon: "medal.fill", color: AetherTheme.cosmosCyan)
                    statCard(title: "Longest Streak", value: "\(profile.longestStreak)", icon: "flame.fill", color: AetherTheme.historyGold)
                }
                
                // Mastery section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Lesson Mastery")
                        .font(.title2.weight(.semibold))
                    
                    if allProgress.isEmpty {
                        Text("Complete lessons to see your mastery heatmap and progress here.")
                            .foregroundStyle(AetherTheme.textSecondary)
                    } else {
                        ForEach(allProgress) { progress in
                            HStack {
                                Text(progress.lessonTitle)
                                Spacer()
                                ProgressView(value: progress.masteryLevel)
                                    .frame(width: 200)
                                Text("\(Int(progress.masteryLevel * 100))%")
                                    .font(.caption.monospacedDigit())
                            }
                        }
                    }
                }
                .padding(24)
                .background(AetherTheme.surface)
                .clipShape(RoundedRectangle(cornerRadius: AetherTheme.cardCornerRadius))
            }
            .padding(40)
        }
        .background(AetherTheme.background)
    }
    
    private func statCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: icon)
                .font(.subheadline)
                .foregroundStyle(color)
            
            Text(value)
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AetherTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: AetherTheme.cardCornerRadius))
    }
}
