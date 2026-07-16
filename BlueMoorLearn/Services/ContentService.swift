import Foundation

/// Service responsible for loading lesson content.
/// Currently returns curated sample lessons. Designed to easily support
/// JSON files in Resources/Content/ in the future.
final class ContentService {
    static let shared = ContentService()
    
    private init() {}
    
    /// All available lessons (loaded from JSON or code for v1)
    var allLessons: [Lesson] {
        // For the starter we hardcode beautiful samples.
        // Later this can scan the bundle for .json files.
        return [
            .sampleHistoryRoman,
            Lesson(
                title: "Ancient Egypt: The Old Kingdom",
                category: .history,
                subtitle: "Pyramids, Pharaohs, and the Dawn of Civilization",
                eraOrTopic: "Old Kingdom • c. 2686–2181 BC",
                estimatedMinutes: 8,
                tags: [.ancientCivilizations],
                overviewContent: "The Old Kingdom represents the golden age of pyramid building and the consolidation of pharaonic power in Egypt.",
                standardContent: "During the Old Kingdom, Egypt saw the construction of the Great Pyramids of Giza under pharaohs Khufu, Khafre, and Menkaure. The period established many of the cultural and religious foundations that would define ancient Egypt for millennia.",
                deepContent: "The Old Kingdom's centralized administration, sophisticated bureaucracy, and religious ideology centered on the pharaoh as a living god allowed for monumental construction projects on a scale never before seen. The transition to the First Intermediate Period after Pepi II's long reign showed the fragility of even the most powerful states.",
                timeline: [
                    TimelineEvent(year: "c. 2686 BC", title: "Old Kingdom Begins", description: "Third Dynasty starts under Djoser. Imhotep designs the Step Pyramid at Saqqara."),
                    TimelineEvent(year: "c. 2580–2560 BC", title: "Great Pyramid of Giza", description: "Khufu constructs the largest pyramid ever built."),
                    TimelineEvent(year: "c. 2530 BC", title: "Sphinx & Khafre Pyramid", description: "Khafre's complex includes the Great Sphinx."),
                    TimelineEvent(year: "c. 2181 BC", title: "Old Kingdom Ends", description: "Central authority collapses, beginning the First Intermediate Period.")
                ],
                keyFigures: [
                    KeyFigure(name: "Djoser", role: "Pharaoh", shortBio: "Commissioned the first pyramid complex.", significance: "His Step Pyramid marked the beginning of monumental stone architecture."),
                    KeyFigure(name: "Imhotep", role: "Architect & Vizier", shortBio: "Designed the Step Pyramid and was later deified.", significance: "One of the first named architects and polymaths in history."),
                    KeyFigure(name: "Khufu", role: "Builder of the Great Pyramid", shortBio: "Second pharaoh of the Fourth Dynasty.", significance: "His pyramid remains one of the Seven Wonders of the Ancient World.")
                ],
                quiz: [
                    QuizQuestion(
                        type: .multipleChoice,
                        question: "Which pharaoh commissioned the Great Pyramid of Giza?",
                        options: ["Djoser", "Khufu", "Khafre", "Pepi II"],
                        correctAnswerIndex: 1,
                        explanation: "Khufu (also known as Cheops) built the Great Pyramid, the largest of the Giza pyramids."
                    )
                ],
                heroImageName: "egypt_hero"
            ),
            .sampleCosmosSolar,
            Lesson(
                title: "Black Holes: Gravity's Ultimate Triumph",
                category: .cosmos,
                subtitle: "Where spacetime ends and our understanding begins",
                eraOrTopic: "Black Holes • General Relativity to Event Horizon Telescope",
                estimatedMinutes: 11,
                tags: [.cosmology, .astronomy],
                overviewContent: "Black holes are regions of spacetime where gravity is so strong that nothing, not even light, can escape. They represent the most extreme predictions of Einstein's general relativity.",
                standardContent: "Stellar-mass black holes form when massive stars collapse at the end of their lives. Supermassive black holes, millions to billions of times the mass of the Sun, sit at the centers of most galaxies, including our own Milky Way.",
                deepContent: "The Event Horizon Telescope captured the first image of a black hole's shadow in 2019 (M87*) and later Sagittarius A* in our own galaxy. These images confirmed predictions about the photon sphere and the size of the event horizon. Hawking radiation, information paradoxes, and the nature of singularities remain active frontiers of theoretical physics.",
                timeline: [
                    TimelineEvent(year: "1915", title: "Einstein's General Relativity", description: "Publishes the field equations that predict black holes as mathematical solutions."),
                    TimelineEvent(year: "1916", title: "Schwarzschild Solution", description: "Karl Schwarzschild finds the first exact solution describing a non-rotating black hole."),
                    TimelineEvent(year: "1963", title: "Kerr Solution", description: "Roy Kerr solves for rotating black holes — the type that actually exist in nature."),
                    TimelineEvent(year: "2019", title: "First Image of a Black Hole", description: "Event Horizon Telescope reveals the shadow of M87*'s supermassive black hole."),
                    TimelineEvent(year: "2022", title: "Sagittarius A* Imaged", description: "The black hole at the center of our Milky Way is photographed.")
                ],
                keyFigures: [
                    KeyFigure(name: "Albert Einstein", role: "Father of Relativity", shortBio: "His theory predicted black holes existed, though he was skeptical they would form in nature.", significance: "Completely changed our understanding of gravity, space, and time."),
                    KeyFigure(name: "Stephen Hawking", role: "Black Hole Thermodynamics", shortBio: "Showed that black holes emit radiation and have entropy.", significance: "Bridged quantum mechanics and gravity in profound ways."),
                    KeyFigure(name: "Andrea Ghez & Reinhard Genzel", role: "Galactic Center Pioneers", shortBio: "Used stellar orbits to prove a supermassive black hole exists at the Milky Way's center.", significance: "Provided the strongest evidence yet for Sagittarius A*.")
                ],
                quiz: [
                    QuizQuestion(
                        type: .trueFalse,
                        question: "Nothing can escape a black hole once it crosses the event horizon, including light.",
                        options: ["True", "False"],
                        correctAnswerIndex: 0,
                        explanation: "By definition, the event horizon is the point of no return. Even light cannot escape."
                    ),
                    QuizQuestion(
                        type: .multipleChoice,
                        question: "What major breakthrough happened in 2019 regarding black holes?",
                        options: ["First theoretical prediction", "First image of a black hole's shadow", "Discovery of Hawking radiation", "First detection of gravitational waves from a black hole merger"],
                        correctAnswerIndex: 1,
                        explanation: "The Event Horizon Telescope collaboration released the first-ever image of a black hole (M87*) in April 2019."
                    )
                ],
                heroImageName: "black_hole_hero"
            )
        ]
    }
    
    func lessons(for category: LessonCategory) -> [Lesson] {
        allLessons.filter { $0.category == category }
    }
    
    func lesson(with id: UUID) -> Lesson? {
        allLessons.first { $0.id == id }
    }
    
    /// Future: Load from bundled JSON files
    private func loadLessonsFromBundle() -> [Lesson] {
        // Placeholder for expansion:
        // Scan Resources/Content/*.json and decode.
        return []
    }
}
