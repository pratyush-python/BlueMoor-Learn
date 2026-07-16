import SwiftUI

struct ExploreView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "sparkles.rectangle.stack")
                .font(.system(size: 64))
                .foregroundStyle(BlueMoorTheme.textTertiary)
            
            Text("Explore Mode")
                .font(.largeTitle.weight(.semibold))
            
            Text("Discover connections between history and the cosmos.\nRabbit hole visualizations and advanced search coming soon.")
                .multilineTextAlignment(.center)
                .foregroundStyle(BlueMoorTheme.textSecondary)
            
            Button("Browse All Lessons") {
                // Could switch tab or present sheet
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BlueMoorTheme.background)
    }
}
