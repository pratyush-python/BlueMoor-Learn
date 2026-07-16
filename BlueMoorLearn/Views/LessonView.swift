import SwiftUI
import SwiftData

struct LessonView: View {
    let lesson: Lesson

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var currentDepth: LessonDepth = .standard
    @State private var showQuiz = false
    @State private var lastXPAward: Int?
    @State private var toastMessage: String?
    @Query private var profiles: [UserProfile]
    @Query private var allProgress: [LessonProgress]
    @State private var progressService: ProgressService?

    private var profile: UserProfile {
        profiles.first ?? UserProfile()
    }

    private var lessonProgress: LessonProgress? {
        allProgress.first { $0.contentId == lesson.contentId || $0.lessonId == lesson.id }
    }

    private var hasCompletedCurrentDepth: Bool {
        lessonProgress?.completedDepths.contains(currentDepth) ?? false
    }

    private var completedDepthCount: Int {
        lessonProgress?.completedDepths.count ?? 0
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Label("Back", systemImage: "chevron.left")
                }
                .buttonStyle(.borderless)

                Spacer()

                Picker("Depth", selection: $currentDepth) {
                    ForEach(LessonDepth.allCases) { depth in
                        Label(depth.rawValue, systemImage: depth.systemImage)
                            .tag(depth)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 380)

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
                    heroHeader
                    progressStrip
                    contentSection
                    if !lesson.timeline.isEmpty {
                        timelineSection
                    }
                    if !lesson.keyFigures.isEmpty {
                        keyFiguresSection
                    }
                    completionSection
                }
                .padding(.horizontal, 48)
                .padding(.vertical, 32)
            }
        }
        .background(BlueMoorTheme.background)
        .overlay(alignment: .bottom) {
            if let toastMessage {
                Text(toastMessage)
                    .font(.headline)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(BlueMoorTheme.surfaceElevated)
                    .foregroundStyle(BlueMoorTheme.success)
                    .clipShape(Capsule())
                    .padding(.bottom, 28)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .sheet(isPresented: $showQuiz) {
            QuizView(lesson: lesson) { score in
                if let service = progressService {
                    service.recordQuizResult(score: score, for: lesson, profile: profile)
                    let pct = Int(score * 100)
                    showToast("Quiz saved · \(pct)%")
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
                    .foregroundStyle(BlueMoorTheme.textSecondary)
            }

            Text(lesson.title)
                .font(.system(size: 36, weight: .bold, design: .serif))
                .foregroundStyle(.white)

            Text(lesson.subtitle)
                .font(.title3)
                .foregroundStyle(BlueMoorTheme.textSecondary)
        }
    }

    private var progressStrip: some View {
        HStack(spacing: 16) {
            ForEach(LessonDepth.allCases) { depth in
                let done = lessonProgress?.completedDepths.contains(depth) ?? false
                HStack(spacing: 6) {
                    Image(systemName: done ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(done ? BlueMoorTheme.success : BlueMoorTheme.textTertiary)
                    Text(depth.rawValue)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(done ? .white : BlueMoorTheme.textSecondary)
                }
            }
            Spacer()
            Text("\(completedDepthCount)/\(LessonDepth.allCases.count) depths")
                .font(.caption)
                .foregroundStyle(BlueMoorTheme.textTertiary)
            if let quiz = lessonProgress?.bestQuizScore {
                Text("Quiz best \(Int(quiz * 100))%")
                    .font(.caption)
                    .foregroundStyle(BlueMoorTheme.cosmosCyan)
            }
        }
        .padding(16)
        .background(BlueMoorTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text(currentDepth.rawValue)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(lesson.category.accentColor)

                if hasCompletedCurrentDepth {
                    Label("Done", systemImage: "checkmark.seal.fill")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(BlueMoorTheme.success)
                }

                Spacer()

                Label("\(currentDepth.estimatedMinutes) min", systemImage: "clock")
                    .font(.caption)
                    .foregroundStyle(BlueMoorTheme.textTertiary)
            }

            Text(currentContent)
                .font(.body)
                .lineSpacing(8)
                .foregroundStyle(BlueMoorTheme.textPrimary)
                .textSelection(.enabled)

            if currentDepth != .deep {
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
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
        .background(BlueMoorTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: BlueMoorTheme.cardCornerRadius))
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
                            .foregroundStyle(BlueMoorTheme.textSecondary)
                    }
                    Spacer()
                }
                .padding(.vertical, 8)
            }
        }
        .padding(28)
        .background(BlueMoorTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: BlueMoorTheme.cardCornerRadius))
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
                            .foregroundStyle(BlueMoorTheme.textSecondary)
                            .lineLimit(3)

                        Text(figure.significance)
                            .font(.caption)
                            .foregroundStyle(BlueMoorTheme.textTertiary)
                            .padding(.top, 4)
                    }
                    .padding(18)
                    .background(BlueMoorTheme.surfaceElevated)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }

    private var completionSection: some View {
        VStack(spacing: 12) {
            if hasCompletedCurrentDepth {
                Label(
                    "Depth completed · +\(currentDepth.xpReward) XP earned",
                    systemImage: "checkmark.circle.fill"
                )
                .foregroundStyle(BlueMoorTheme.success)
                .font(.headline)

                Button {
                    showQuiz = true
                } label: {
                    Text("Take quiz for this lesson")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            } else {
                Button {
                    completeCurrentDepth()
                } label: {
                    Text("Mark \(currentDepth.rawValue) complete · +\(currentDepth.xpReward) XP")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(lesson.category.accentColor)
                .controlSize(.large)
            }

            Text("Progress is saved on this Mac. Complete all depths and the quiz to master the lesson.")
                .font(.caption)
                .foregroundStyle(BlueMoorTheme.textTertiary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }

    private func setup() {
        let service = ProgressService(modelContext: modelContext)
        progressService = service
        // Ensure profile exists in store (not a detached instance)
        _ = service.fetchOrCreateProfile()
        currentDepth = profile.preferredDepth
    }

    private func completeCurrentDepth() {
        guard let service = progressService else { return }
        // Use profile from store
        let liveProfile = service.fetchOrCreateProfile()
        let xp = service.completeDepth(currentDepth, for: lesson, profile: liveProfile)
        if xp > 0 {
            showToast("+\(xp) XP · \(currentDepth.rawValue) complete")
        } else {
            showToast("Already completed")
        }
    }

    private func showToast(_ message: String) {
        withAnimation {
            toastMessage = message
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                toastMessage = nil
            }
        }
    }
}
