import SwiftUI
import SwiftData
import AppKit

struct TodayView: View {
    @Binding var selectedLesson: Lesson?
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    @State private var progressService: ProgressService?
    @State private var recommendedLesson: Lesson?
    
    private var profile: UserProfile {
        profiles.first ?? UserProfile()
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                // Header
                header
                
                // Streak + Level Card
                streakAndLevelCard
                
                // Recommended Lesson
                if let lesson = recommendedLesson {
                    recommendedSection(lesson: lesson)
                }
                
                // Quick Stats + Today in Space
                HStack(alignment: .top, spacing: 24) {
                    quickStats
                    todayInSpace
                }
            }
            .padding(40)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(BlueMoorTheme.background)
        .onAppear(perform: setup)
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(greeting)
                .font(.system(size: 42, weight: .semibold, design: .serif))
                .foregroundStyle(.white)
            
            Text("Continue your journey through history and the cosmos.")
                .font(.title3)
                .foregroundStyle(BlueMoorTheme.textSecondary)
        }
    }
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning."
        case 12..<17: return "Good afternoon."
        default: return "Good evening."
        }
    }
    
    private var streakAndLevelCard: some View {
        HStack(spacing: 20) {
            // Streak Ring
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .stroke(BlueMoorTheme.surfaceElevated, lineWidth: 12)
                        .frame(width: 110, height: 110)
                    
                    Circle()
                        .trim(from: 0, to: min(CGFloat(profile.currentStreak) / 30.0, 1.0))
                        .stroke(BlueMoorTheme.historyGold, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                        .frame(width: 110, height: 110)
                        .rotationEffect(.degrees(-90))
                    
                    VStack(spacing: 2) {
                        Text("\(profile.currentStreak)")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        Text("day streak")
                            .font(.caption)
                            .foregroundStyle(BlueMoorTheme.textSecondary)
                    }
                }
                
                Text("Longest: \(profile.longestStreak) days")
                    .font(.caption)
                    .foregroundStyle(BlueMoorTheme.textTertiary)
            }
            
            // Level & XP
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Level \(profile.level)")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Text("\(profile.totalXP) XP")
                        .font(.headline.monospacedDigit())
                        .foregroundStyle(BlueMoorTheme.cosmosCyan)
                }
                
                ProgressView(value: profile.progressToNextLevel)
                    .tint(BlueMoorTheme.cosmosCyan)
                    .frame(height: 8)
                    .background(BlueMoorTheme.surfaceElevated)
                    .clipShape(Capsule())
                
                Text("\(profile.xpForNextLevel) XP to Level \(profile.level + 1)")
                    .font(.caption)
                    .foregroundStyle(BlueMoorTheme.textTertiary)
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(28)
        .background(BlueMoorTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: BlueMoorTheme.cardCornerRadius, style: .continuous))
    }
    
    private func recommendedSection(lesson: Lesson) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recommended for You")
                    .font(.title2.weight(.semibold))
                Spacer()
                Button("See All") {
                    // Could navigate to library
                }
                .buttonStyle(.borderless)
                .foregroundStyle(BlueMoorTheme.cosmosCyan)
            }
            
            Button {
                selectedLesson = lesson
            } label: {
                LessonCard(lesson: lesson, showCategory: true)
            }
            .buttonStyle(.plain)
        }
    }
    
    private var quickStats: some View {
        let stats = progressService?.weekStats()
        return VStack(alignment: .leading, spacing: 16) {
            Text("Your progress")
                .font(.headline)
                .foregroundStyle(BlueMoorTheme.textSecondary)

            VStack(alignment: .leading, spacing: 12) {
                statRow(label: "Lessons started", value: "\(stats?.lessonsStarted ?? 0)")
                statRow(label: "Depths completed", value: "\(stats?.depthsCompleted ?? 0)")
                statRow(
                    label: "Quiz accuracy",
                    value: stats?.quizAccuracyPercent.map { "\($0)%" } ?? "—"
                )
            }
        }
        .padding(24)
        .frame(maxWidth: 280, alignment: .leading)
        .background(BlueMoorTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: BlueMoorTheme.cardCornerRadius))
    }
    
    private func statRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(BlueMoorTheme.textSecondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
        }
    }
    
    private var todayInSpace: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "sparkles")
                Text("Today in curiosity")
                    .font(.headline)
            }
            .foregroundStyle(BlueMoorTheme.historyGold)

            if let fact = ContentService.shared.todaysFact() {
                VStack(alignment: .leading, spacing: 8) {
                    Text(fact.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                    Text(fact.text)
                        .font(.callout)
                        .foregroundStyle(BlueMoorTheme.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            } else {
                Text("Open a history lesson to continue your streak.")
                    .font(.callout)
                    .foregroundStyle(BlueMoorTheme.textSecondary)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(BlueMoorTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: BlueMoorTheme.cardCornerRadius))
    }
    
    private func setup() {
        let service = ProgressService(modelContext: modelContext)
        progressService = service
        
        let profile = service.fetchOrCreateProfile()
        
        // Update streak on launch
        profile.updateStreak()
        try? modelContext.save()
        
        recommendedLesson = service.recommendedLesson(for: profile)
    }
}

// Beautiful reusable card
/// Loads a lesson hero from Resources/images/<name>.jpg
struct LessonHeroImage: View {
    let name: String

    var body: some View {
        if let nsImage = Self.load(name: name) {
            Image(nsImage: nsImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }

    static func load(name: String) -> NSImage? {
        let candidates = [
            Bundle.main.url(forResource: name, withExtension: "jpg", subdirectory: "images"),
            Bundle.main.url(forResource: name, withExtension: "jpg"),
        ].compactMap { $0 }
        for url in candidates {
            if let img = NSImage(contentsOf: url) { return img }
        }
        return nil
    }
}

struct LessonCard: View {
    let lesson: Lesson
    var showCategory: Bool = false
    var completedDepths: Int = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                if let hero = LessonHeroImage.load(name: lesson.heroImageName ?? lesson.contentId) {
                    Image(nsImage: hero)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 140)
                        .clipped()
                } else {
                    LinearGradient(
                        colors: lesson.category == .history
                            ? [Color(hex: "#3D2B1F"), BlueMoorTheme.background]
                            : [Color(hex: "#1A2A4A"), BlueMoorTheme.background],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 140)
                }

                LinearGradient(
                    colors: [.clear, BlueMoorTheme.background.opacity(0.75)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 140)

                HStack {
                    if showCategory {
                        Label(lesson.category.rawValue, systemImage: lesson.category.icon)
                            .font(.caption.weight(.medium))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                    }
                    Spacer()
                    if completedDepths > 0 {
                        Text("\(completedDepths)/3 depths")
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(BlueMoorTheme.success.opacity(0.2))
                            .foregroundStyle(BlueMoorTheme.success)
                            .clipShape(Capsule())
                    }
                }
                .padding(16)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(lesson.title)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.white)
                    .lineLimit(2)

                Text(lesson.eraOrTopic)
                    .font(.subheadline)
                    .foregroundStyle(BlueMoorTheme.textSecondary)

                Text(lesson.subtitle)
                    .font(.callout)
                    .foregroundStyle(BlueMoorTheme.textTertiary)
                    .lineLimit(2)
                    .padding(.top, 4)
            }
            .padding(20)
            .background(BlueMoorTheme.surfaceElevated)
        }
        .clipShape(RoundedRectangle(cornerRadius: BlueMoorTheme.cardCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: BlueMoorTheme.cardCornerRadius)
                .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
}
