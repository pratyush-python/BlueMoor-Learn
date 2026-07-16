import Foundation

/// Loads the shared lesson catalog from `lessons.json` (single source of truth).
/// Same file lives in `content/lessons.json` at repo root and is bundled as a resource.
final class ContentService {
    static let shared = ContentService()

    private var cachedLessons: [Lesson]?
    private var cachedFacts: [DailyFact]?

    private init() {}

    var allLessons: [Lesson] {
        if let cachedLessons { return cachedLessons }
        let loaded = Self.loadLessonsFromBundle()
        cachedLessons = loaded
        return loaded
    }

    var dailyFacts: [DailyFact] {
        if let cachedFacts { return cachedFacts }
        let loaded = Self.loadDailyFactsFromBundle()
        cachedFacts = loaded
        return loaded
    }

    func lessons(for category: LessonCategory) -> [Lesson] {
        allLessons.filter { $0.category == category }
    }

    func lesson(with id: UUID) -> Lesson? {
        allLessons.first { $0.id == id }
    }

    func lesson(contentId: String) -> Lesson? {
        allLessons.first { $0.contentId == contentId }
    }

    /// Fact of the day (stable for a calendar day).
    func todaysFact() -> DailyFact? {
        let facts = dailyFacts
        guard !facts.isEmpty else { return nil }
        let day = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return facts[(day - 1) % facts.count]
    }

    // MARK: - Bundle loading

    private static func loadLessonsFromBundle() -> [Lesson] {
        guard let url = locateJSON(named: "lessons") else {
            assertionFailure("lessons.json missing from bundle — check Xcode Resources")
            return fallbackLessons()
        }
        do {
            let data = try Data(contentsOf: url)
            let file = try JSONDecoder().decode(LessonCatalogFile.self, from: data)
            let lessons = file.lessons.map { $0.toLesson() }
            #if DEBUG
            print("[ContentService] Loaded \(lessons.count) lessons from JSON")
            #endif
            return lessons
        } catch {
            assertionFailure("Failed to decode lessons.json: \(error)")
            return fallbackLessons()
        }
    }

    private static func loadDailyFactsFromBundle() -> [DailyFact] {
        guard let url = locateJSON(named: "daily_facts") else { return [] }
        do {
            let data = try Data(contentsOf: url)
            let file = try JSONDecoder().decode(DailyFactsFile.self, from: data)
            return file.facts
        } catch {
            return []
        }
    }

    private static func locateJSON(named name: String) -> URL? {
        if let url = Bundle.main.url(forResource: name, withExtension: "json") {
            return url
        }
        // Fallback when running tests / previews without full bundle copy
        let candidates = [
            URL(fileURLWithPath: #file)
                .deletingLastPathComponent() // Services
                .deletingLastPathComponent() // BlueMoorLearn
                .appendingPathComponent("Resources/\(name).json"),
            URL(fileURLWithPath: #file)
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .appendingPathComponent("content/\(name).json"),
        ]
        return candidates.first { FileManager.default.fileExists(atPath: $0.path) }
    }

    private static func fallbackLessons() -> [Lesson] {
        [Lesson.sampleHistoryRoman, Lesson.sampleCosmosSolar]
    }
}

// MARK: - JSON DTOs (shared schema with web/Android)

struct LessonCatalogFile: Codable {
    let version: Int
    let lessons: [LessonDTO]
}

struct DailyFactsFile: Codable {
    let version: Int
    let facts: [DailyFact]
}

struct DailyFact: Codable, Identifiable, Hashable {
    var id: String { title }
    let title: String
    let text: String
}

struct LessonDTO: Codable {
    let id: String
    let title: String
    let category: String
    let era: String?
    let region: String?
    let subtitle: String
    let eraOrTopic: String
    let estimatedMinutes: Int
    let tags: [String]?
    let overview: String
    let standard: String
    let deep: String
    let timeline: [TimelineDTO]
    let figures: [FigureDTO]
    let quiz: [QuizDTO]
    let heroImageName: String?

    func toLesson() -> Lesson {
        Lesson(
            id: Lesson.stableId(id),
            contentId: id,
            title: title,
            category: category == "cosmos" ? .cosmos : .history,
            subtitle: subtitle,
            eraOrTopic: eraOrTopic,
            estimatedMinutes: estimatedMinutes,
            tags: (tags ?? []).compactMap(InterestTag.fromJSON),
            overviewContent: overview,
            standardContent: standard,
            deepContent: deep,
            timeline: timeline.map {
                TimelineEvent(year: $0.year, title: $0.title, description: $0.description)
            },
            keyFigures: figures.map {
                KeyFigure(
                    name: $0.name,
                    role: $0.role,
                    shortBio: $0.shortBio,
                    significance: $0.significance ?? $0.shortBio
                )
            },
            quiz: quiz.map {
                QuizQuestion(
                    type: $0.type == "trueFalse" ? .trueFalse : .multipleChoice,
                    question: $0.question,
                    options: $0.options,
                    correctAnswerIndex: $0.correctAnswerIndex,
                    explanation: $0.explanation
                )
            },
            heroImageName: heroImageName
        )
    }
}

struct TimelineDTO: Codable {
    let year: String
    let title: String
    let description: String
}

struct FigureDTO: Codable {
    let name: String
    let role: String
    let shortBio: String
    let significance: String?
}

struct QuizDTO: Codable {
    let type: String
    let question: String
    let options: [String]
    let correctAnswerIndex: Int
    let explanation: String
}

extension InterestTag {
    static func fromJSON(_ raw: String) -> InterestTag? {
        switch raw {
        case "ancientCivilizations", "Ancient Civilizations": return .ancientCivilizations
        case "empiresAndRepublics", "Empires & Republics": return .empiresAndRepublics
        case "spaceExploration", "Space Exploration": return .spaceExploration
        case "cosmology", "Cosmology & Physics": return .cosmology
        case "astronomy", "Astronomy": return .astronomy
        default: return InterestTag(rawValue: raw)
        }
    }
}
