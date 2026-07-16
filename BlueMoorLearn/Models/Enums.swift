import Foundation
import SwiftUI

// MARK: - Core Enums

enum LessonCategory: String, Codable, CaseIterable, Identifiable {
    case history = "History"
    case cosmos = "Cosmos"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .history: return "scroll.fill"
        case .cosmos: return "sparkles"
        }
    }
    
    var accentColor: Color {
        switch self {
        case .history: return Color(hex: "#C9A26B") // Warm parchment gold
        case .cosmos: return Color(hex: "#5CE1E6") // Electric cyan
        }
    }
}

enum LessonDepth: String, Codable, CaseIterable, Identifiable {
    case overview = "Overview"
    case standard = "Standard"
    case deep = "Deep Dive"
    
    var id: String { rawValue }
    
    var systemImage: String {
        switch self {
        case .overview: return "binoculars.fill"
        case .standard: return "book.fill"
        case .deep: return "text.book.closed.fill"
        }
    }
    
    var estimatedMinutes: Int {
        switch self {
        case .overview: return 4
        case .standard: return 8
        case .deep: return 14
        }
    }
    
    var xpReward: Int {
        switch self {
        case .overview: return 25
        case .standard: return 60
        case .deep: return 120
        }
    }
}

enum InterestTag: String, Codable, CaseIterable, Identifiable {
    case ancientCivilizations = "Ancient Civilizations"
    case empiresAndRepublics = "Empires & Republics"
    case spaceExploration = "Space Exploration"
    case cosmology = "Cosmology & Physics"
    case astronomy = "Astronomy"
    
    var id: String { rawValue }
}

enum QuizQuestionType: String, Codable {
    case multipleChoice
    case trueFalse
}

// MARK: - Color Hex Extension (for design system)

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Design System Colors

struct BlueMoorTheme {
    static let background = Color(hex: "#0A0E1A")          // Deep space navy
    static let surface = Color(hex: "#121826")             // Slightly lighter card surface
    static let surfaceElevated = Color(hex: "#1A2233")
    
    static let historyGold = Color(hex: "#C9A26B")
    static let cosmosCyan = Color(hex: "#5CE1E6")
    static let accentViolet = Color(hex: "#7B68EE")
    
    static let textPrimary = Color.white
    static let textSecondary = Color(hex: "#A0AEC0")
    static let textTertiary = Color(hex: "#64748B")
    
    static let success = Color(hex: "#34D399")
    static let warning = Color(hex: "#FBBF24")
    
    static let cardCornerRadius: CGFloat = 16
    static let buttonCornerRadius: CGFloat = 12
}
