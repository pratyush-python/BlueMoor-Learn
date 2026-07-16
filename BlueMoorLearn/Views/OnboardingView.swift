import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    
    @State private var selectedInterests: Set<InterestTag> = []
    @State private var preferredDepth: LessonDepth = .standard
    
    private var profile: UserProfile {
        profiles.first ?? UserProfile()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 12) {
                Image(systemName: "sparkles")
                    .font(.system(size: 48))
                    .foregroundStyle(BlueMoorTheme.cosmosCyan)
                
                Text("Welcome to Blue Moor - Learn")
                    .font(.system(size: 36, weight: .bold, design: .serif))
                
                Text("A beautiful journey through human history and the cosmos.")
                    .font(.title3)
                    .foregroundStyle(BlueMoorTheme.textSecondary)
            }
            .padding(.top, 60)
            .padding(.bottom, 40)
            
            // Interests
            VStack(alignment: .leading, spacing: 16) {
                Text("What interests you most?")
                    .font(.headline)
                
                Text("We'll personalize recommendations based on your choices.")
                    .font(.subheadline)
                    .foregroundStyle(BlueMoorTheme.textTertiary)
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 12) {
                    ForEach(InterestTag.allCases) { tag in
                        interestButton(tag: tag)
                    }
                }
            }
            .padding(.horizontal, 60)
            
            Spacer()
            
            // Depth preference
            VStack(alignment: .leading, spacing: 16) {
                Text("How deep do you like to go?")
                    .font(.headline)
                
                Picker("Preferred Depth", selection: $preferredDepth) {
                    ForEach(LessonDepth.allCases) { depth in
                        Text(depth.rawValue).tag(depth)
                    }
                }
                .pickerStyle(.segmented)
                .frame(maxWidth: 420)
            }
            .padding(.horizontal, 60)
            
            Spacer()
            
            Button {
                completeOnboarding()
            } label: {
                Text("Start Learning")
                    .font(.headline)
                    .frame(maxWidth: 320)
            }
            .buttonStyle(.borderedProminent)
            .tint(BlueMoorTheme.cosmosCyan)
            .controlSize(.large)
            .disabled(selectedInterests.isEmpty)
            .padding(.bottom, 60)
        }
        .frame(width: 720, height: 620)
        .background(BlueMoorTheme.background)
    }
    
    private func interestButton(tag: InterestTag) -> some View {
        Button {
            if selectedInterests.contains(tag) {
                selectedInterests.remove(tag)
            } else {
                selectedInterests.insert(tag)
            }
        } label: {
            Text(tag.rawValue)
                .font(.callout.weight(.medium))
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity)
                .background(selectedInterests.contains(tag) ? BlueMoorTheme.cosmosCyan.opacity(0.2) : BlueMoorTheme.surface)
                .foregroundStyle(selectedInterests.contains(tag) ? BlueMoorTheme.cosmosCyan : .white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(selectedInterests.contains(tag) ? BlueMoorTheme.cosmosCyan : Color.clear, lineWidth: 1.5)
                )
        }
        .buttonStyle(.plain)
    }
    
    private func completeOnboarding() {
        let profileToUpdate = profile
        profileToUpdate.interestTags = Array(selectedInterests)
        profileToUpdate.preferredDepth = preferredDepth
        profileToUpdate.hasCompletedOnboarding = true
        
        hasCompletedOnboarding = true
        
        try? modelContext.save()
    }
}
