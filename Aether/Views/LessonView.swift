import SwiftUI
import SwiftData

struct LessonView: View {
    let lesson: Lesson
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentDepth: LessonDepth = .standard
    @State private var showQuiz = false
    @State private var hasCompletedCurrentDepth = false
    @Query private var profiles: [UserProfile]
    @State private var progressService: ProgressService?
    
    private var profile: UserProfile {
        profiles.first ?? UserProfile()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom Navigation Bar
            HStack {
                Button {
                    dismiss()
                } label: {
                    Label("Back", systemImage: "chevron.left")
                }
                .buttonStyle(.borderless)
                
                Spacer()
                
                // Depth Selector (beautiful segmented control)
                Picker("Depth", selection: $currentDepth) {
                    ForEach(LessonDepth.allCases) { depth in
                        Label(depth.rawValue, systemImage: depth.systemImage)
                            .tag(depth)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 380)
                .onChange(of: currentDepth) { _, newValue in
                    checkIfDepthCompleted(newValue)
                }
                
                Spacer()
                
                Button {
                    showQuiz = true
                } label: {
                    Label("Take Quiz", systemImage: "questionmark.circle")
                }
                .buttonStyle(.borderedProminent)
                .tint(lesson.category.accentColor)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(.ultraThinMaterial)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    // Hero Header
                    heroHeader
                    
                    // Content
                    contentSection
                    
                    // Timeline
                    if !lesson.timeline.isEmpty {
                        timelineSection
                    }
                    
                    // Key Figures
                    if !lesson.keyFigures.isEmpty {
                        keyFiguresSection
                    }
                    
                    // Completion CTA
                    completionSection
                }
                .padding(.horizontal, 48)
                .padding(.vertical, 32)
            }
        }
        .background(AetherTheme.background)
        .sheet(isPresented: $showQuiz) {
            QuizView(lesson: lesson) { score in
                // Record quiz result
                if let service = progressService {
                    service.recordQuizResult(score: score, for: lesson, profile: profile)
                }
            }
        }
        .onAppear(perform: setup)
        .navigationTitle(lesson.title)
    }
    
    private var heroHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Label(lesson.category.rawValue, systemImage: lesson.category.icon)
                    .font(.subheadline.weight(.medium))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(lesson.category.accentColor.opacity(0.15))
                    .foregroundStyle(lesson.category.accentColor)
                    .clipShape(Capsule())
                
                Text(lesson.eraOrTopic)
                    .font(.subheadline)
                    .foregroundStyle(AetherTheme.textSecondary)
            }
            
            Text(lesson.title)
                .font(.system(size: 36, weight: .bold, design: .serif))
                .foregroundStyle(.white)
            
            Text(lesson.subtitle)
                .font(.title3)
                .foregroundStyle(AetherTheme.textSecondary)
        }
    }
    
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text(currentDepth.rawValue)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(lesson.category.accentColor)
                
                Spacer()
                
                Label("\(currentDepth.estimatedMinutes) min", systemImage: "clock")
                    .font(.caption)
                    .foregroundStyle(AetherTheme.textTertiary)
            }
            
            Text(currentContent)
                .font(.body)
                .lineSpacing(8)
                .foregroundStyle(AetherTheme.textPrimary)
                .textSelection(.enabled)
            
            // "Go Deeper" prompt
            if currentDepth != .deep {
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        currentDepth = LessonDepth.allCases.first { $0 == currentDepth } ?? .standard
                        // Advance to next depth
                        if let currentIndex = LessonDepth.allCases.firstIndex(of: currentDepth),
                           currentIndex < LessonDepth.allCases.count - 1 {
                            currentDepth = LessonDepth.allCases[currentIndex + 1]
                        }
                    }
                } label: {
                    Label("Go Deeper →", systemImage: "arrow.down.circle.fill")
                        .font(.headline)
                        .foregroundStyle(lesson.category.accentColor)
                }
                .buttonStyle(.plain)
                .padding(.top, 8)
            }
        }
        .padding(28)
        .background(AetherTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: AetherTheme.cardCornerRadius))
    }
    
    private var currentContent: String {
        switch currentDepth {
        case .overview: return lesson.overviewContent
        case .standard: return lesson.standardContent
        case .deep: return lesson.deepContent
        }
    }
    
    private var timelineSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Timeline")
                .font(.title2.weight(.semibold))
            
            ForEach(lesson.timeline) { event in
                HStack(alignment: .top, spacing: 20) {
                    Text(event.year)
                        .font(.headline.monospacedDigit())
                        .foregroundStyle(lesson.category.accentColor)
                        .frame(width: 110, alignment: .trailing)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(event.title)
                            .font(.headline)
                        Text(event.description)
                            .font(.callout)
                            .foregroundStyle(AetherTheme.textSecondary)
                    }
                    Spacer()
                }
                .padding(.vertical, 8)
            }
        }
        .padding(28)
        .background(AetherTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: AetherTheme.cardCornerRadius))
    }
    
    private var keyFiguresSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Key Figures")
                .font(.title2.weight(.semibold))
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 280), spacing: 16)], spacing: 16) {
                ForEach(lesson.keyFigures) { figure in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(figure.name)
                            .font(.headline)
                            .foregroundStyle(.white)
                        Text(figure.role)
                            .font(.subheadline)
                            .foregroundStyle(lesson.category.accentColor)
                        Text(figure.shortBio)
                            .font(.callout)
                            .foregroundStyle(AetherTheme.textSecondary)
                            .lineLimit(3)
                        
                        Text(figure.significance)
                            .font(.caption)
                            .foregroundStyle(AetherTheme.textTertiary)
                            .padding(.top, 4)
                    }
                    .padding(18)
                    .background(AetherTheme.surfaceElevated)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }
    
    private var completionSection: some View {
        VStack(spacing: 12) {
            if hasCompletedCurrentDepth {
                Label("Depth Completed • +\(currentDepth.xpReward) XP", systemImage: "checkmark.circle.fill")
                    .foregroundStyle(AetherTheme.success)
                    .font(.headline)
            } else {
                Button {
                    completeCurrentDepth()
                } label: {
                    Text("Mark as Completed & Earn \(currentDepth.xpReward) XP")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(lesson.category.accentColor)
                .controlSize(.large)
            }
            
            Text("Complete all depths and the quiz to fully master this lesson.")
                .font(.caption)
                .foregroundStyle(AetherTheme.textTertiary)
        }
        .padding(.top, 20)
    }
    
    private func setup() {
        progressService = ProgressService(modelContext: modelContext)
        currentDepth = profile.preferredDepth
        checkIfDepthCompleted(currentDepth)
    }
    
    private func checkIfDepthCompleted(_ depth: LessonDepth) {
        // In a real implementation we would query LessonProgress
        // For starter we keep simple state
        hasCompletedCurrentDepth = false // Would check persisted state
    }
    
    private func completeCurrentDepth() {
        guard let service = progressService else { return }
        
        let xp = service.completeDepth(currentDepth, for: lesson, profile: profile)
        hasCompletedCurrentDepth = true
        
        // Nice haptic/animation feedback could go here
        withAnimation {
            // Could show a toast "+\(xp) XP"
        }
    }
}
