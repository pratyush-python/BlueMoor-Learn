import SwiftUI
import SwiftData

struct SettingsView: View {
    @Query private var profiles: [UserProfile]
    @Environment(\.modelContext) private var modelContext
    
    private var profile: UserProfile {
        profiles.first ?? UserProfile()
    }
    
    var body: some View {
        Form {
            Section("Personalization") {
                Picker("Preferred Depth", selection: Binding(
                    get: { profile.preferredDepth },
                    set: { profile.preferredDepth = $0; try? modelContext.save() }
                )) {
                    ForEach(LessonDepth.allCases) { depth in
                        Text(depth.rawValue).tag(depth)
                    }
                }
                
                // Interests could be editable here too
                Text("Your interests influence daily recommendations.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Section("Gamification") {
                Toggle("Daily Streak Reminders", isOn: .constant(true))
                Toggle("XP Notifications", isOn: .constant(true))
            }
            
            Section("Data") {
                Button("Reset All Progress", role: .destructive) {
                    // Clear SwiftData models
                }
                .foregroundStyle(.red)
                
                Text("This will permanently delete your streaks, XP, and lesson progress.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Section {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0 (MVP Starter)")
                        .foregroundStyle(.secondary)
                }
                
                Link("Send Feedback", destination: URL(string: "https://example.com")!)
            } header: {
                Text("About Blue Moor - Learn")
            }
        }
        .formStyle(.grouped)
        .frame(width: 480, height: 420)
        .navigationTitle("Settings")
    }
}
