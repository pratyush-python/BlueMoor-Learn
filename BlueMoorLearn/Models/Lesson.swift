import Foundation

// MARK: - Timeline Event (for lessons)

struct TimelineEvent: Codable, Identifiable, Hashable {
    let id: UUID
    let year: String          // e.g. "509 BC" or "2022"
    let title: String
    let description: String
    
    init(year: String, title: String, description: String) {
        self.id = UUID()
        self.year = year
        self.title = title
        self.description = description
    }
}

// MARK: - Key Figure

struct KeyFigure: Codable, Identifiable, Hashable {
    let id: UUID
    let name: String
    let role: String
    let shortBio: String
    let significance: String
    
    init(name: String, role: String, shortBio: String, significance: String) {
        self.id = UUID()
        self.name = name
        self.role = role
        self.shortBio = shortBio
        self.significance = significance
    }
}

// MARK: - Quiz Question

struct QuizQuestion: Codable, Identifiable, Hashable {
    let id: UUID
    let type: QuizQuestionType
    let question: String
    let options: [String]           // For MCQ; for True/False use ["True", "False"]
    let correctAnswerIndex: Int
    let explanation: String         // Shown after answering
    
    init(type: QuizQuestionType, question: String, options: [String], correctAnswerIndex: Int, explanation: String) {
        self.id = UUID()
        self.type = type
        self.question = question
        self.options = options
        self.correctAnswerIndex = correctAnswerIndex
        self.explanation = explanation
    }
}

// MARK: - Main Lesson Model (loaded from JSON)

struct Lesson: Codable, Identifiable, Hashable {
    let id: UUID
    let title: String
    let category: LessonCategory
    let subtitle: String            // Short tagline
    let eraOrTopic: String          // e.g. "Roman Republic • 509–27 BC" or "Stellar Evolution"
    let estimatedMinutes: Int       // Base time for Standard
    let tags: [InterestTag]
    
    // Three depth levels of content
    let overviewContent: String
    let standardContent: String
    let deepContent: String
    
    let timeline: [TimelineEvent]
    let keyFigures: [KeyFigure]
    let quiz: [QuizQuestion]
    
    // Asset name for hero image (optional for v1 - we use beautiful SF Symbol + gradient instead)
    let heroImageName: String?
    
    // Computed
    var totalXPReward: Int {
        LessonDepth.allCases.reduce(0) { $0 + $1.xpReward }
    }

    // Identity-based equality so sheets/selection stay stable.
    static func == (lhs: Lesson, rhs: Lesson) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(
        title: String,
        category: LessonCategory,
        subtitle: String,
        eraOrTopic: String,
        estimatedMinutes: Int,
        tags: [InterestTag],
        overviewContent: String,
        standardContent: String,
        deepContent: String,
        timeline: [TimelineEvent],
        keyFigures: [KeyFigure],
        quiz: [QuizQuestion],
        heroImageName: String? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.category = category
        self.subtitle = subtitle
        self.eraOrTopic = eraOrTopic
        self.estimatedMinutes = estimatedMinutes
        self.tags = tags
        self.overviewContent = overviewContent
        self.standardContent = standardContent
        self.deepContent = deepContent
        self.timeline = timeline
        self.keyFigures = keyFigures
        self.quiz = quiz
        self.heroImageName = heroImageName
    }
}

// MARK: - Sample Data Loader Helper (for Previews & Testing)

extension Lesson {
    static var sampleHistoryRoman: Lesson {
        Lesson(
            title: "The Roman Republic",
            category: .history,
            subtitle: "From Kingdom to Republic — The Birth of Roman Liberty",
            eraOrTopic: "Roman Republic • 509–27 BC",
            estimatedMinutes: 9,
            tags: [.ancientCivilizations, .empiresAndRepublics],
            overviewContent: """
            In 509 BC, the Roman people overthrew their last king and established a republic. This new system of government would shape Western civilization for centuries.

            The Republic was built on the principle that power should be shared and checked, not concentrated in one ruler.
            """,
            standardContent: """
            The Roman Republic was founded after the overthrow of King Tarquinius Superbus. It introduced a complex system of elected magistrates, most notably two consuls who shared executive power and could veto each other.

            The Senate, composed of Rome's wealthiest and most influential citizens, advised the consuls and controlled state finances. This created a delicate balance between aristocratic and popular interests.

            Over the next 400+ years, Rome expanded from a small city-state to the dominant power in the Mediterranean through a combination of military genius, diplomatic cunning, and relentless ambition.
            """,
            deepContent: """
            The Roman Republic's constitution was never written down in a single document. It evolved through centuries of tradition (mos maiorum), conflict between patricians and plebeians, and pragmatic responses to crises.

            Key institutions included:
            • The Centuriate Assembly (elected consuls and declared war)
            • The Tribal Assembly (passed laws)
            • The Plebeian Council (after the Conflict of the Orders)
            • Dictators (temporary emergency powers, limited to 6 months)

            The Republic's greatest strength — its system of checks and balances — also became its fatal weakness as ambitious generals like Marius, Sulla, Pompey, and eventually Caesar accumulated power that the old institutions could no longer contain.
            """,
            timeline: [
                TimelineEvent(year: "509 BC", title: "Republic Founded", description: "Tarquin the Proud is expelled. Lucius Junius Brutus and Lucius Tarquinius Collatinus become the first consuls."),
                TimelineEvent(year: "494 BC", title: "First Secession of the Plebs", description: "Plebeians withdraw from Rome to demand political rights, leading to the creation of the Tribune of the Plebs."),
                TimelineEvent(year: "450 BC", title: "Twelve Tables", description: "Rome's first written law code is published, a major victory for plebeian rights."),
                TimelineEvent(year: "264–146 BC", title: "Punic Wars", description: "Three brutal wars against Carthage. Rome emerges as the unchallenged master of the western Mediterranean."),
                TimelineEvent(year: "133 BC", title: "Tiberius Gracchus", description: "Elected tribune and attempts sweeping land reform. Assassinated by senators — the beginning of the Republic's violent end."),
                TimelineEvent(year: "49 BC", title: "Caesar Crosses the Rubicon", description: "Julius Caesar defies the Senate and marches on Rome, starting a civil war that ends the Republic."),
                TimelineEvent(year: "27 BC", title: "Augustus Takes Power", description: "Octavian is granted the title 'Augustus' by the Senate. The Roman Empire is born.")
            ],
            keyFigures: [
                KeyFigure(name: "Lucius Junius Brutus", role: "Founder & First Consul", shortBio: "Led the revolt against Tarquin the Proud.", significance: "Symbol of republican virtue and resistance to tyranny for centuries."),
                KeyFigure(name: "Cincinnatus", role: "Model Dictator", shortBio: "Called from his farm to save Rome, then immediately returned to private life.", significance: "The ideal of civic duty over personal ambition."),
                KeyFigure(name: "Scipio Africanus", role: "Military Genius", shortBio: "Defeated Hannibal at Zama in 202 BC.", significance: "Expanded Rome's power and became a political giant."),
                KeyFigure(name: "Julius Caesar", role: "The Man Who Ended It", shortBio: "Brilliant general and politician who crossed the Rubicon.", significance: "His dictatorship marked the death of the Republic and birth of Empire.")
            ],
            quiz: [
                QuizQuestion(
                    type: .multipleChoice,
                    question: "In what year was the Roman Republic traditionally founded?",
                    options: ["753 BC", "509 BC", "27 BC", "44 BC"],
                    correctAnswerIndex: 1,
                    explanation: "509 BC marks the traditional date when the last king was overthrown and the Republic established."
                ),
                QuizQuestion(
                    type: .trueFalse,
                    question: "The Roman Republic had a written constitution similar to the United States.",
                    options: ["True", "False"],
                    correctAnswerIndex: 1,
                    explanation: "Rome never had a single written constitution. Its government evolved through tradition, custom, and political struggle over centuries."
                ),
                QuizQuestion(
                    type: .multipleChoice,
                    question: "What was the primary role of the Roman Senate during the Republic?",
                    options: ["Command armies in the field", "Advise magistrates and control finances", "Elect the consuls directly", "Represent only the plebeian class"],
                    correctAnswerIndex: 1,
                    explanation: "The Senate advised consuls, controlled the treasury, and directed foreign policy, though it had no formal legislative power in the early Republic."
                )
            ],
            heroImageName: "roman_republic_hero"
        )
    }
    
    static var sampleCosmosSolar: Lesson {
        Lesson(
            title: "Our Solar System",
            category: .cosmos,
            subtitle: "Eight Worlds, One Star, Countless Stories",
            eraOrTopic: "Solar System • Formation & Exploration",
            estimatedMinutes: 7,
            tags: [.spaceExploration, .astronomy],
            overviewContent: """
            Our solar system formed about 4.6 billion years ago from a collapsing cloud of gas and dust. At its center burns the Sun — a star that holds everything in its gravitational embrace.

            Eight planets, dozens of moons, and countless smaller bodies orbit in a delicate cosmic dance.
            """,
            standardContent: """
            The solar system is divided into the inner terrestrial planets (Mercury, Venus, Earth, Mars) and the outer gas and ice giants (Jupiter, Saturn, Uranus, Neptune).

            Between Mars and Jupiter lies the asteroid belt. Beyond Neptune is the Kuiper Belt and the distant Oort Cloud, home to icy bodies and long-period comets.

            Every planet in our system has been visited by spacecraft. We have rovers on Mars, orbiters around Jupiter and Saturn, and have even flown by all four gas giants.
            """,
            deepContent: """
            The solar system formed from a protoplanetary disk. Close to the young Sun, only rock and metal could condense — creating the terrestrial planets. Farther out, ices and gases formed the giant planets.

            Key processes that shaped the planets:
            • Accretion of planetesimals
            • Differentiation (heavy materials sinking to cores)
            • Late Heavy Bombardment (~4.1–3.8 billion years ago)
            • Migration of the giant planets (Nice model)

            The Sun contains 99.86% of the solar system's mass. Jupiter contains most of the remaining mass. This hierarchy is typical of planetary systems we observe around other stars.
            """,
            timeline: [
                TimelineEvent(year: "~4.6 billion years ago", title: "Solar System Forms", description: "A molecular cloud collapses, forming the Sun and protoplanetary disk."),
                TimelineEvent(year: "4.5 billion years ago", title: "Earth & Moon Form", description: "Giant impact with Theia creates the Moon and gives Earth its tilt."),
                TimelineEvent(year: "1969", title: "Apollo 11", description: "Humans walk on the Moon for the first time."),
                TimelineEvent(year: "1977", title: "Voyager Launches", description: "Two spacecraft begin their grand tour of the outer solar system."),
                TimelineEvent(year: "2015", title: "New Horizons at Pluto", description: "First close-up images of Pluto and its moons are returned."),
                TimelineEvent(year: "2021–", title: "James Webb Space Telescope", description: "Revolutionary infrared observatory begins revealing exoplanets and distant solar system objects.")
            ],
            keyFigures: [
                KeyFigure(name: "Nicolaus Copernicus", role: "Heliocentric Revolution", shortBio: "Proposed that the Sun, not Earth, is at the center of the solar system.", significance: "Fundamentally changed humanity's place in the cosmos."),
                KeyFigure(name: "Galileo Galilei", role: "First to See Jupiter's Moons", shortBio: "Used early telescope to discover four large moons orbiting Jupiter.", significance: "Provided strong evidence against geocentric model."),
                KeyFigure(name: "Carl Sagan", role: "Cosmic Communicator", shortBio: "Popularized planetary science and advocated for space exploration.", significance: "Made the wonder of the cosmos accessible to millions."),
                KeyFigure(name: "Carolyn Porco", role: "Ring Master", shortBio: "Led imaging team for Cassini mission to Saturn.", significance: "Revealed the breathtaking beauty and complexity of Saturn's rings and moons.")
            ],
            quiz: [
                QuizQuestion(
                    type: .multipleChoice,
                    question: "Which planet is the most massive in our solar system?",
                    options: ["Saturn", "Neptune", "Jupiter", "Earth"],
                    correctAnswerIndex: 2,
                    explanation: "Jupiter is by far the most massive planet — more than twice the mass of all other planets combined."
                ),
                QuizQuestion(
                    type: .trueFalse,
                    question: "Pluto is still classified as one of the eight major planets.",
                    options: ["True", "False"],
                    correctAnswerIndex: 1,
                    explanation: "In 2006, the IAU reclassified Pluto as a dwarf planet. There are currently eight recognized planets in our solar system."
                )
            ],
            heroImageName: "solar_system_hero"
        )
    }
}
