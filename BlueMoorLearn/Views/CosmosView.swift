import SwiftUI
import SwiftData

struct CosmosView: View {
    @Binding var selectedLesson: Lesson?
    @Query private var allProgress: [LessonProgress]
    private let lessons = ContentService.shared.lessons(for: .cosmos)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 320), spacing: 20)], spacing: 20) {
                ForEach(lessons) { lesson in
                    Button {
                        selectedLesson = lesson
                    } label: {
                        LessonCard(
                            lesson: lesson,
                            completedDepths: depthCount(for: lesson)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(40)
        }
        .background(BlueMoorTheme.background)
        .navigationTitle("Cosmos")
    }

    private func depthCount(for lesson: Lesson) -> Int {
        allProgress.first { $0.contentId == lesson.contentId || $0.lessonId == lesson.id }?
            .completedDepths.count ?? 0
    }
}
