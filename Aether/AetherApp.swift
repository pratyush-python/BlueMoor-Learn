import SwiftUI
import SwiftData
import AppKit

@main
struct AetherApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserProfile.self,
            LessonProgress.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @State private var showOnboarding = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .modelContainer(sharedModelContainer)
                .preferredColorScheme(.dark) // Dark mode first, always
                .onAppear {
                    if !hasCompletedOnboarding {
                        // Slight delay so the main UI can render first
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            showOnboarding = true
                        }
                    }
                }
                .sheet(isPresented: $showOnboarding) {
                    OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                        .interactiveDismissDisabled(true)
                }
        }
        .windowStyle(.hiddenTitleBar) // Cleaner modern macOS look
        .windowToolbarStyle(.unified)
        .commands {
            // File Menu
            CommandGroup(replacing: .newItem) {
                Button("New Lesson Window") {
                    // Future: support multiple lesson windows
                }
                .keyboardShortcut("n", modifiers: [.command, .shift])
            }
            
            // View Menu - Navigation Shortcuts
            CommandMenu("Navigate") {
                Button("Today") {
                    // Handled via @Environment or notification in real implementation
                }
                .keyboardShortcut("1", modifiers: .command)
                
                Button("History") {
                }
                .keyboardShortcut("2", modifiers: .command)
                
                Button("Cosmos") {
                }
                .keyboardShortcut("3", modifiers: .command)
                
                Button("Progress") {
                }
                .keyboardShortcut("4", modifiers: .command)
                
                Divider()
                
                Button("Toggle Sidebar") {
                    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
                }
                .keyboardShortcut("s", modifiers: [.command, .control])
            }
            
            // Help
            CommandGroup(replacing: .help) {
                Button("Aether Help") {
                    // Open help or about
                }
            }
        }
        
        // macOS 14+ Settings Scene (beautiful native settings)
        Settings {
            SettingsView()
                .modelContainer(sharedModelContainer)
        }
    }
}

// MARK: - Main Navigation (Sidebar + Detail)

struct MainTabView: View {
    @State private var selectedTab: Tab = .today
    @State private var selectedLesson: Lesson?
    
    enum Tab: String, CaseIterable, Identifiable {
        case today = "Today"
        case history = "History"
        case cosmos = "Cosmos"
        case explore = "Explore"
        case progress = "Progress"
        
        var id: String { rawValue }
        
        var icon: String {
            switch self {
            case .today: return "sun.max.fill"
            case .history: return "scroll.fill"
            case .cosmos: return "sparkles"
            case .explore: return "magnifyingglass"
            case .progress: return "chart.bar.fill"
            }
        }
    }
    
    var body: some View {
        NavigationSplitView {
            // Sidebar
            List(selection: $selectedTab) {
                ForEach(Tab.allCases) { tab in
                    Label(tab.rawValue, systemImage: tab.icon)
                        .tag(tab)
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("Aether")
            .frame(minWidth: 220)
        } detail: {
            // Detail content based on selection
            Group {
                switch selectedTab {
                case .today:
                    TodayView(selectedLesson: $selectedLesson)
                case .history:
                    HistoryView(selectedLesson: $selectedLesson)
                case .cosmos:
                    CosmosView(selectedLesson: $selectedLesson)
                case .explore:
                    ExploreView()
                case .progress:
                    ProgressDashboardView()
                }
            }
            .navigationTitle(selectedTab.rawValue)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    if selectedTab == .today || selectedTab == .history || selectedTab == .cosmos {
                        Button {
                            // Could trigger "Start Recommended" or search
                        } label: {
                            Label("Search Lessons", systemImage: "magnifyingglass")
                        }
                        .help("Search all lessons (⌘F)")
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        // Future: open Battle Mode
                    } label: {
                        Label("Battle Mode", systemImage: "bolt.fill")
                    }
                    .help("Challenge the AI in trivia battle")
                }
            }
        }
        .sheet(item: $selectedLesson) { lesson in
            LessonView(lesson: lesson)
                .frame(minWidth: 820, minHeight: 620)
        }
    }
}
