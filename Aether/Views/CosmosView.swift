import SwiftUI

struct CosmosView: View {
    @Binding var selectedLesson: Lesson?
    private let lessons = ContentService.shared.lessons(for: .cosmos)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 320), spacing: 20)], spacing: 20) {
                ForEach(lessons) { lesson in
                    Button {
                        selectedLesson = lesson
                    } label: {
                        LessonCard(lesson: lesson)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(40)
        }
        .background(AetherTheme.background)
        .navigationTitle("Cosmos")
    }
}
