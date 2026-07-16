import Foundation

/// Curated lesson catalog for the Xcode / macOS (and future iOS) app.
/// Keep in sync with `web/content.js` and Android `ContentRepository.kt`.
final class ContentService {
    static let shared = ContentService()

    private var cachedLessons: [Lesson]?

    private init() {}

    /// Stable list — UUIDs do not change across launches (progress stays valid).
    var allLessons: [Lesson] {
        if let cachedLessons { return cachedLessons }
        let built = Self.buildCatalog()
        cachedLessons = built
        return built
    }

    func lessons(for category: LessonCategory) -> [Lesson] {
        allLessons.filter { $0.category == category }
    }

    func lesson(with id: UUID) -> Lesson? {
        allLessons.first { $0.id == id }
    }

    // MARK: - Catalog

    private static func buildCatalog() -> [Lesson] {
        [
            Lesson.sampleHistoryRoman,
            egypt,
            indusValley,
            ashokaMaurya,
            silkRoad,
            mansaMusa,
            fallConstantinople,
            mughalFounding,
            frenchRevolution,
            partition1947,
            printingPress,
            Lesson.sampleCosmosSolar,
            blackHoles,
        ]
    }

    // MARK: Lessons

    private static var egypt: Lesson {
        Lesson(
            id: Lesson.stableId("ancient-egypt-old-kingdom"),
            title: "Ancient Egypt: The Old Kingdom",
            category: .history,
            subtitle: "Pyramids, Pharaohs, and the Dawn of Civilization",
            eraOrTopic: "Old Kingdom • c. 2686–2181 BC",
            estimatedMinutes: 8,
            tags: [.ancientCivilizations],
            overviewContent: "The Old Kingdom represents the golden age of pyramid building and the consolidation of pharaonic power in Egypt.",
            standardContent: "During the Old Kingdom, Egypt saw the construction of the Great Pyramids of Giza under pharaohs Khufu, Khafre, and Menkaure. The period established cultural and religious foundations that defined ancient Egypt for millennia.",
            deepContent: "Centralized administration, bureaucracy, and religious ideology of the pharaoh as living god enabled monumental construction. Collapse after Pepi II's long reign led into the First Intermediate Period.",
            timeline: [
                TimelineEvent(year: "c. 2686 BC", title: "Old Kingdom Begins", description: "Third Dynasty under Djoser; Step Pyramid at Saqqara."),
                TimelineEvent(year: "c. 2580 BC", title: "Great Pyramid", description: "Khufu builds the largest pyramid."),
                TimelineEvent(year: "c. 2181 BC", title: "Old Kingdom Ends", description: "Central authority collapses."),
            ],
            keyFigures: [
                KeyFigure(name: "Djoser", role: "Pharaoh", shortBio: "Commissioned the first pyramid complex.", significance: "Monumental stone architecture begins."),
                KeyFigure(name: "Imhotep", role: "Architect & Vizier", shortBio: "Designed the Step Pyramid.", significance: "Later deified polymath."),
                KeyFigure(name: "Khufu", role: "Builder of the Great Pyramid", shortBio: "Fourth Dynasty pharaoh.", significance: "Great Pyramid remains an ancient Wonder."),
            ],
            quiz: [
                QuizQuestion(type: .multipleChoice, question: "Which pharaoh commissioned the Great Pyramid of Giza?", options: ["Djoser", "Khufu", "Khafre", "Pepi II"], correctAnswerIndex: 1, explanation: "Khufu (Cheops) built the Great Pyramid."),
            ],
            heroImageName: "egypt_hero"
        )
    }

    private static var indusValley: Lesson {
        Lesson(
            id: Lesson.stableId("indus-valley"),
            title: "The Indus Valley Civilization",
            category: .history,
            subtitle: "Planned cities, seals, and a script we still cannot fully read",
            eraOrTopic: "Harappan Civilization • c. 3300–1300 BC",
            estimatedMinutes: 10,
            tags: [.ancientCivilizations],
            overviewContent: "Along the Indus and its tributaries rose one of the world's earliest urban civilizations — contemporary with Egypt and Mesopotamia, yet distinct in its orderly cities and almost invisible kings.",
            standardContent: "Major sites include Harappa and Mohenjo-daro: grid streets, baked-brick houses, covered drains, and the Great Bath. Trade stretched to Mesopotamia. Thousands of steatite seals show animals and a still-undeciphered script.\n\nUnlike Egypt's pharaohs, Indus society left few clear royal monuments — leading scholars to debate how power was organized.",
            deepContent: "Urban planning suggests strong civic norms: standardized brick ratios, water management, and craft specialization. The civilization declined after c. 1900 BC — climate shifts, river course changes, and trade disruption are leading theories.\n\nThe undeciphered script remains one of archaeology's great puzzles.",
            timeline: [
                TimelineEvent(year: "c. 3300 BC", title: "Early Harappan", description: "Village networks densify toward urbanism."),
                TimelineEvent(year: "c. 2600 BC", title: "Mature Harappan", description: "Great cities at peak organization and trade."),
                TimelineEvent(year: "c. 1900 BC", title: "Transformation", description: "Urban centers fade; regional cultures emerge."),
                TimelineEvent(year: "1920s", title: "Modern Discovery", description: "Excavations reveal Harappa and Mohenjo-daro."),
            ],
            keyFigures: [
                KeyFigure(name: "John Marshall", role: "Archaeologist", shortBio: "Announced the civilization publicly in the 1920s.", significance: "Public recognition of the Indus culture."),
                KeyFigure(name: "R. D. Banerji", role: "Excavator", shortBio: "Early work at Mohenjo-daro.", significance: "Helped identify the culture."),
                KeyFigure(name: "Dayaram Sahni", role: "Excavator", shortBio: "Key early excavations at Harappa.", significance: "Foundational fieldwork."),
            ],
            quiz: [
                QuizQuestion(type: .multipleChoice, question: "Which feature is most associated with Mature Harappan cities?", options: ["Pyramid tombs", "Grid planning and drains", "Marble amphitheaters", "Great Wall fortifications"], correctAnswerIndex: 1, explanation: "Harappan cities are famous for planned streets and sophisticated drainage."),
                QuizQuestion(type: .trueFalse, question: "The Indus script has been fully deciphered like Egyptian hieroglyphs.", options: ["True", "False"], correctAnswerIndex: 1, explanation: "The Indus script remains undeciphered."),
            ]
        )
    }

    private static var ashokaMaurya: Lesson {
        Lesson(
            id: Lesson.stableId("ashoka-maurya"),
            title: "Ashoka and the Mauryan Empire",
            category: .history,
            subtitle: "From bloody conquest to dhamma on stone",
            eraOrTopic: "Mauryan Empire • 322–185 BC",
            estimatedMinutes: 11,
            tags: [.ancientCivilizations, .empiresAndRepublics],
            overviewContent: "The Mauryan Empire was the first to unite most of the Indian subcontinent under one power. Emperor Ashoka's reign became legendary — not only for scale, but for a public turn toward ethics after war.",
            standardContent: "Chandragupta Maurya founded the empire with help of Chanakya (Kautilya). Ashoka's conquest of Kalinga (c. 261 BC) was devastating. Afterward, Ashoka promoted dhamma — moral conduct, religious tolerance, and welfare — through rock and pillar edicts across the realm.",
            deepContent: "These edicts are among the earliest extensive royal inscriptions in India. Ashoka's Buddhism was personal and public, but dhamma was broader than a single sect. After Ashoka, the empire weakened; the last Mauryan was overthrown c. 185 BC. Modern India revived Ashoka as a symbol of ethical power (Lion Capital of Sarnath).",
            timeline: [
                TimelineEvent(year: "c. 322 BC", title: "Empire Founded", description: "Chandragupta establishes Mauryan power."),
                TimelineEvent(year: "c. 261 BC", title: "Kalinga War", description: "Ashoka's costly victory; turning point in royal ideology."),
                TimelineEvent(year: "c. 250s BC", title: "Edicts", description: "Dhamma messages carved on rocks and pillars."),
                TimelineEvent(year: "c. 185 BC", title: "Mauryan Fall", description: "Pushyamitra Shunga ends the dynasty."),
            ],
            keyFigures: [
                KeyFigure(name: "Chandragupta Maurya", role: "Founder", shortBio: "Built the empire Ashoka would inherit.", significance: "First major subcontinental empire-builder."),
                KeyFigure(name: "Chanakya (Kautilya)", role: "Strategist", shortBio: "Advisor associated with Arthashastra statecraft.", significance: "Legend of Mauryan rise."),
                KeyFigure(name: "Ashoka", role: "Emperor", shortBio: "Expanded then redefined imperial purpose through dhamma.", significance: "Edicts remain primary sources."),
            ],
            quiz: [
                QuizQuestion(type: .multipleChoice, question: "What major event is said to have transformed Ashoka's outlook?", options: ["Building Sanchi", "The Kalinga War", "Alexander's invasion", "Gupta coronation"], correctAnswerIndex: 1, explanation: "Tradition and edicts link Ashoka's turn to the Kalinga conflict."),
                QuizQuestion(type: .trueFalse, question: "Ashoka's edicts are useful because they are primary written sources from his reign.", options: ["True", "False"], correctAnswerIndex: 0, explanation: "The rock and pillar edicts are key contemporary inscriptions."),
            ]
        )
    }

    private static var silkRoad: Lesson {
        Lesson(
            id: Lesson.stableId("silk-road"),
            title: "The Silk Roads",
            category: .history,
            subtitle: "Not one road — a web of trade, ideas, and risk",
            eraOrTopic: "Silk Roads • c. 2nd century BC – 15th century AD",
            estimatedMinutes: 10,
            tags: [.empiresAndRepublics, .ancientCivilizations],
            overviewContent: "The Silk Roads were overlapping land and sea routes linking China, Central Asia, India, Persia, and the Mediterranean. Silk was famous — but religions, technologies, diseases, and stories traveled too.",
            standardContent: "Han China and empires to the west incentivized long-distance exchange. Caravanserais, oasis cities (Samarkand, Kashgar), and maritime routes via the Indian Ocean formed a network, not a highway.\n\nBuddhism spread into Central and East Asia along these corridors. Later, Islam, paper-making knowledge, and countless goods moved in both directions.",
            deepContent: "The term 'Silk Road' is modern (19th century). Historians prefer 'Silk Roads' to stress plurality. Political stability under empires often boosted traffic; fragmentation raised costs. The Black Death's westward movement shows the dark side of connectivity.",
            timeline: [
                TimelineEvent(year: "2nd c. BC", title: "Han Expansion West", description: "Chinese engagement with Central Asia intensifies exchange."),
                TimelineEvent(year: "1st–3rd c. AD", title: "Kushan Hub", description: "Central Asian power bridges India, China, and Iran."),
                TimelineEvent(year: "13th c.", title: "Pax Mongolica", description: "Mongol peace lowers barriers for merchants and missionaries."),
            ],
            keyFigures: [
                KeyFigure(name: "Zhang Qian", role: "Han Envoy", shortBio: "Missions westward opened Chinese knowledge of Central Asia.", significance: "Diplomatic pioneer of western corridors."),
                KeyFigure(name: "Xuanzang", role: "Buddhist Pilgrim", shortBio: "7th-century journey to India.", significance: "Classic of travel and faith."),
                KeyFigure(name: "Ibn Battuta", role: "Traveler", shortBio: "14th-century journeys mapped a connected Afro-Eurasian world.", significance: "Extraordinary itinerary."),
            ],
            quiz: [
                QuizQuestion(type: .trueFalse, question: "The Silk Roads carried only silk and luxury goods.", options: ["True", "False"], correctAnswerIndex: 1, explanation: "Ideas, religions, technologies, crops, and diseases also moved along the network."),
                QuizQuestion(type: .multipleChoice, question: "Who is commonly credited with coining a modern name for these routes?", options: ["Marco Polo", "Ferdinand von Richthofen", "Ashoka", "Zheng He"], correctAnswerIndex: 1, explanation: "German geographer Ferdinand von Richthofen popularized 'Seidenstraße'."),
            ]
        )
    }

    private static var mansaMusa: Lesson {
        Lesson(
            id: Lesson.stableId("mansa-musa"),
            title: "Mansa Musa and the Mali Empire",
            category: .history,
            subtitle: "Gold, scholarship, and the most famous pilgrimage in medieval Africa",
            eraOrTopic: "Mali Empire • 13th–16th centuries",
            estimatedMinutes: 9,
            tags: [.empiresAndRepublics],
            overviewContent: "In the 14th century, Mansa Musa of Mali made a pilgrimage to Mecca so lavish that chroniclers said it disrupted gold prices in Cairo. Behind the legend stood a powerful West African empire built on trade and learning.",
            standardContent: "Mali controlled key trans-Saharan routes in gold and salt. Cities like Timbuktu and Djenné became centers of commerce and Islamic scholarship. Musa's hajj (c. 1324) put Mali firmly on Mediterranean mental maps.",
            deepContent: "Arabic sources and oral traditions (epics of Sundiata) help reconstruct this world — each with strengths and biases. Manuscript cultures of Timbuktu show sophisticated law, astronomy, and theology. Modern historians stress African agency — Mali was a center in its own networks.",
            timeline: [
                TimelineEvent(year: "c. 1235", title: "Sundiata", description: "Foundations of Mali after victory at Kirina (tradition)."),
                TimelineEvent(year: "c. 1324", title: "Hajj", description: "Mansa Musa's pilgrimage becomes a pan-Mediterranean story."),
                TimelineEvent(year: "15th–16th c.", title: "Shift", description: "Songhai and changing trade routes reshape the region."),
            ],
            keyFigures: [
                KeyFigure(name: "Sundiata Keita", role: "Founder (epic tradition)", shortBio: "Hero of the Epic of Sundiata.", significance: "Associated with Mali's rise."),
                KeyFigure(name: "Mansa Musa", role: "Emperor", shortBio: "Famous for pilgrimage, patronage, and imperial wealth.", significance: "Global medieval fame."),
                KeyFigure(name: "Ibn Khaldun", role: "Historian", shortBio: "Referenced Western Sudanese states.", significance: "Major North African scholar."),
            ],
            quiz: [
                QuizQuestion(type: .multipleChoice, question: "Mansa Musa's fame in outside sources is most tied to which journey?", options: ["Voyage to China", "Hajj to Mecca", "Conquest of Rome", "Silk Road caravan to Samarkand"], correctAnswerIndex: 1, explanation: "His pilgrimage to Mecca was widely reported in Arabic chronicles."),
                QuizQuestion(type: .trueFalse, question: "Timbuktu was known as a center of Islamic learning as well as trade.", options: ["True", "False"], correctAnswerIndex: 0, explanation: "It became renowned for scholars, libraries, and manuscript culture."),
            ]
        )
    }

    private static var fallConstantinople: Lesson {
        Lesson(
            id: Lesson.stableId("fall-constantinople"),
            title: "1453: Fall of Constantinople",
            category: .history,
            subtitle: "Cannons, walls, and the end of a thousand-year empire",
            eraOrTopic: "Ottoman Conquest • 29 May 1453",
            estimatedMinutes: 10,
            tags: [.empiresAndRepublics],
            overviewContent: "When Ottoman forces under Mehmed II took Constantinople, the Byzantine Empire ended. The event shocked Christendom, thrilled the Ottoman world, and became a hinge between medieval and early modern eras.",
            standardContent: "Constantinople's Theodosian Walls had defied attackers for centuries. Mehmed II brought massive cannons, a large army and fleet, and relentless engineering — including hauling ships overland into the Golden Horn. After the fall, the city became the Ottoman capital.",
            deepContent: "Byzantium had been shrinking for generations; 1453 was climax, not bolt from the blue. Historians caution against single-date myths: printing, Atlantic voyages, and gunpowder empires all reshaped the 15th–16th centuries together.",
            timeline: [
                TimelineEvent(year: "1204", title: "Fourth Crusade", description: "Latins sack Constantinople; Byzantium fatally weakened."),
                TimelineEvent(year: "1453", title: "Siege & Fall", description: "Ottomans take the city on 29 May."),
                TimelineEvent(year: "1453+", title: "New Capital", description: "Ottomans remake the city as imperial center."),
            ],
            keyFigures: [
                KeyFigure(name: "Mehmed II", role: "Ottoman Sultan", shortBio: "Conqueror who made the city his capital.", significance: "Imperial founder-figure of a new era."),
                KeyFigure(name: "Constantine XI", role: "Last Byzantine Emperor", shortBio: "Died in the final defense of the city.", significance: "End of the eastern Roman imperial line."),
                KeyFigure(name: "Orban", role: "Cannon Founder", shortBio: "Associated with giant bombards used in the siege.", significance: "Gunpowder siege technology."),
            ],
            quiz: [
                QuizQuestion(type: .multipleChoice, question: "In which year did Constantinople fall to the Ottomans?", options: ["1204", "1453", "1492", "1526"], correctAnswerIndex: 1, explanation: "The city fell on 29 May 1453."),
                QuizQuestion(type: .trueFalse, question: "The Theodosian Walls had protected the city for centuries before 1453.", options: ["True", "False"], correctAnswerIndex: 0, explanation: "Those massive land walls were legendary defensive works."),
            ]
        )
    }

    private static var mughalFounding: Lesson {
        Lesson(
            id: Lesson.stableId("mughal-founding"),
            title: "Babur and the Mughal Founding",
            category: .history,
            subtitle: "A Timurid prince, gunpowder, and a new imperial age in India",
            eraOrTopic: "Mughal Empire • from 1526",
            estimatedMinutes: 10,
            tags: [.empiresAndRepublics],
            overviewContent: "In 1526, Babur defeated Ibrahim Lodi at Panipat and founded the Mughal Empire. What began as a conquest state became one of the world's great early modern empires.",
            standardContent: "Babur, a Timurid descendant from Central Asia, used cavalry tactics and gunpowder field fortifications. His memoir, the Baburnama, is a vivid primary source. Humayun lost and regained the throne; Akbar later consolidated a durable imperial system.",
            deepContent: "Calling the Mughals simply 'foreign invaders' oversimplifies centuries of Indianization, alliance-building, and cultural synthesis. Longevity required bureaucracy, legitimacy, and negotiation with local elites (e.g. Rajput alliances under Akbar).",
            timeline: [
                TimelineEvent(year: "1526", title: "First Panipat", description: "Babur defeats the Lodi sultan; Mughal rule begins."),
                TimelineEvent(year: "1556–1605", title: "Akbar", description: "Expansion and administrative consolidation."),
                TimelineEvent(year: "1632–1653", title: "Taj Mahal", description: "Shah Jahan's mausoleum becomes a global icon."),
            ],
            keyFigures: [
                KeyFigure(name: "Babur", role: "Founder", shortBio: "Timurid prince; memoirist and conqueror.", significance: "Opened the Mughal era."),
                KeyFigure(name: "Humayun", role: "Emperor", shortBio: "Lost then recovered the empire.", significance: "Bridge to Akbar's consolidation."),
                KeyFigure(name: "Akbar", role: "Consolidator", shortBio: "Built administrative foundations of high Mughal power.", significance: "Alliances and statecraft."),
            ],
            quiz: [
                QuizQuestion(type: .multipleChoice, question: "Babur's decisive 1526 victory is known as the First Battle of…", options: ["Plassey", "Panipat", "Talikota", "Haldighati"], correctAnswerIndex: 1, explanation: "The First Battle of Panipat (1526) founded Mughal power in India."),
                QuizQuestion(type: .trueFalse, question: "The Baburnama is valuable as a first-person royal memoir.", options: ["True", "False"], correctAnswerIndex: 0, explanation: "Babur's autobiography is a major primary source for the period."),
            ]
        )
    }

    private static var frenchRevolution: Lesson {
        Lesson(
            id: Lesson.stableId("french-revolution"),
            title: "The French Revolution",
            category: .history,
            subtitle: "Rights, terror, and the remaking of politics",
            eraOrTopic: "France • 1789–1799",
            estimatedMinutes: 12,
            tags: [.empiresAndRepublics],
            overviewContent: "In a decade, France went from absolute monarchy toward republic, empire, and a language of rights that still shapes global politics. The Revolution was inspiring and terrifying — often at the same time.",
            standardContent: "Fiscal crisis, Enlightenment ideas, and social inequality set the stage. 1789 brought the Estates-General, Bastille, and Declaration of the Rights of Man. Radicalization produced republic, war, and the Terror. The Directory gave way to Napoleon (1799).",
            deepContent: "Historians debate causes and character. Women, enslaved people in the colonies, and peasants experienced the Revolution differently than Parisian politicians. The Haitian Revolution intertwined with French events — forcing questions about universal rights and slavery.",
            timeline: [
                TimelineEvent(year: "1789", title: "Estates-General & Bastille", description: "Crisis becomes revolution."),
                TimelineEvent(year: "1792–94", title: "Republic & Terror", description: "War and radical politics peak."),
                TimelineEvent(year: "1799", title: "Brumaire", description: "Napoleon seizes power."),
            ],
            keyFigures: [
                KeyFigure(name: "Louis XVI", role: "King", shortBio: "Monarch whose authority collapsed; executed 1793.", significance: "End of the old regime."),
                KeyFigure(name: "Maximilien Robespierre", role: "Jacobin Leader", shortBio: "Symbol of revolutionary virtue and the Terror.", significance: "Radical phase of the Revolution."),
                KeyFigure(name: "Olympe de Gouges", role: "Writer", shortBio: "Demanded women's rights; executed during the Terror.", significance: "Expanded the language of rights."),
            ],
            quiz: [
                QuizQuestion(type: .multipleChoice, question: "The Declaration of the Rights of Man and of the Citizen belongs mainly to which year?", options: ["1776", "1789", "1815", "1848"], correctAnswerIndex: 1, explanation: "It was adopted in 1789."),
                QuizQuestion(type: .trueFalse, question: "The French Revolution affected only France and had no colonial consequences.", options: ["True", "False"], correctAnswerIndex: 1, explanation: "Colonial revolutions, especially in Haiti, were deeply connected."),
            ]
        )
    }

    private static var partition1947: Lesson {
        Lesson(
            id: Lesson.stableId("partition-1947"),
            title: "Partition of India, 1947",
            category: .history,
            subtitle: "Independence, borders, and human catastrophe",
            eraOrTopic: "South Asia • 1947",
            estimatedMinutes: 11,
            tags: [.empiresAndRepublics],
            overviewContent: "In August 1947, British India was partitioned into India and Pakistan. Freedom arrived with mass migration, communal violence, and unresolved questions that still shape the subcontinent.",
            standardContent: "Long-term communal politics, colonial policies, wartime strains, and failed negotiations preceded Partition. The Mountbatten Plan accelerated transfer of power. The Radcliffe Line drew borders through Punjab and Bengal with devastating speed. Millions crossed new frontiers.",
            deepContent: "No single cause explains Partition. Historians examine the two-nation theory, Congress–Muslim League rivalry, British exit strategies, and local breakdowns of order. Studying 1947 requires care: center evidence, multiple perspectives, and human experience — avoid propaganda.",
            timeline: [
                TimelineEvent(year: "1940", title: "Lahore Resolution", description: "Muslim League articulates demand for Muslim-majority states."),
                TimelineEvent(year: "15 Aug 1947", title: "Independence & Partition", description: "Two dominions born; violence and migration surge."),
                TimelineEvent(year: "1947–48", title: "Kashmir War", description: "First India–Pakistan war over Kashmir."),
            ],
            keyFigures: [
                KeyFigure(name: "Jawaharlal Nehru", role: "First PM of India", shortBio: "Led Congress into independence government.", significance: "Independence leadership."),
                KeyFigure(name: "Muhammad Ali Jinnah", role: "Leader of Pakistan movement", shortBio: "First Governor-General of Pakistan.", significance: "Two-nation politics."),
                KeyFigure(name: "Mahatma Gandhi", role: "Nationalist leader", shortBio: "Opposed communal division; assassinated 1948.", significance: "Moral voice of the independence era."),
            ],
            quiz: [
                QuizQuestion(type: .multipleChoice, question: "In which year did Partition and independence primarily occur?", options: ["1935", "1942", "1947", "1950"], correctAnswerIndex: 2, explanation: "August 1947 marks independence and Partition."),
                QuizQuestion(type: .trueFalse, question: "The Radcliffe Line concerned borders in Punjab and Bengal.", options: ["True", "False"], correctAnswerIndex: 0, explanation: "Cyril Radcliffe chaired commissions drawing those boundaries."),
            ]
        )
    }

    private static var printingPress: Lesson {
        Lesson(
            id: Lesson.stableId("printing-press"),
            title: "How Print Changed the World",
            category: .history,
            subtitle: "Moveable type, pamphlets, and the explosion of ideas",
            eraOrTopic: "Information Revolution • from c. 1450",
            estimatedMinutes: 9,
            tags: [.ancientCivilizations, .empiresAndRepublics],
            overviewContent: "When moveable-type printing scaled in Europe after Gutenberg, books became faster and cheaper to multiply. Ideas could outrun censors — and start arguments that remade religion, science, and politics.",
            standardContent: "Woodblock printing existed earlier in East Asia; Korea developed moveable metal type before Gutenberg. Europe's mid-15th-century print boom still transformed scale: Bibles, maps, and later newspapers. The Reformation spread through pamphlets.",
            deepContent: "Print did not automatically create modernity — readers, markets, states, and religions shaped its use. Comparing Eurasian printing histories avoids Eurocentrism: China, Korea, and the Islamic world's manuscript cultures had different trajectories.",
            timeline: [
                TimelineEvent(year: "Before 800", title: "East Asian Print", description: "Woodblock printing thrives in China and beyond."),
                TimelineEvent(year: "c. 1455", title: "Gutenberg Bible", description: "Icon of European moveable-type printing."),
                TimelineEvent(year: "1517+", title: "Reformation Media", description: "Pamphlets and vernacular Bibles spread rapidly."),
            ],
            keyFigures: [
                KeyFigure(name: "Johannes Gutenberg", role: "Printer", shortBio: "Associated with the European moveable-type breakthrough.", significance: "Symbol of the print revolution."),
                KeyFigure(name: "Martin Luther", role: "Reformer", shortBio: "Used print masterfully to spread religious challenge.", significance: "Media-savvy theologian."),
                KeyFigure(name: "Goryeo Korea", role: "Innovation center", shortBio: "Early moveable metal type tradition (e.g. Jikji, 1377).", significance: "Often overlooked precedent."),
            ],
            quiz: [
                QuizQuestion(type: .trueFalse, question: "Moveable-type printing appeared only in Europe and nowhere else earlier.", options: ["True", "False"], correctAnswerIndex: 1, explanation: "East Asia had earlier printing traditions, including Korean metal type."),
                QuizQuestion(type: .trueFalse, question: "Pamphlets were important to the spread of the Protestant Reformation.", options: ["True", "False"], correctAnswerIndex: 0, explanation: "Cheap print helped ideas travel far beyond pulpits."),
            ]
        )
    }

    private static var blackHoles: Lesson {
        Lesson(
            id: Lesson.stableId("black-holes"),
            title: "Black Holes: Gravity's Ultimate Triumph",
            category: .cosmos,
            subtitle: "Where spacetime ends and our understanding begins",
            eraOrTopic: "Black Holes • General Relativity to Event Horizon Telescope",
            estimatedMinutes: 11,
            tags: [.cosmology, .astronomy],
            overviewContent: "Black holes are regions of spacetime where gravity is so strong that nothing, not even light, can escape. They represent the most extreme predictions of Einstein's general relativity.",
            standardContent: "Stellar-mass black holes form when massive stars collapse at the end of their lives. Supermassive black holes, millions to billions of times the mass of the Sun, sit at the centers of most galaxies, including our own Milky Way.",
            deepContent: "The Event Horizon Telescope captured the first image of a black hole's shadow in 2019 (M87*) and later Sagittarius A*. Hawking radiation, information paradoxes, and the nature of singularities remain active frontiers of theoretical physics.",
            timeline: [
                TimelineEvent(year: "1915", title: "Einstein's General Relativity", description: "Publishes the field equations that predict black holes as mathematical solutions."),
                TimelineEvent(year: "1916", title: "Schwarzschild Solution", description: "Karl Schwarzschild finds the first exact solution describing a non-rotating black hole."),
                TimelineEvent(year: "1963", title: "Kerr Solution", description: "Roy Kerr solves for rotating black holes."),
                TimelineEvent(year: "2019", title: "First Image of a Black Hole", description: "Event Horizon Telescope reveals the shadow of M87*."),
                TimelineEvent(year: "2022", title: "Sagittarius A* Imaged", description: "The black hole at the center of our Milky Way is photographed."),
            ],
            keyFigures: [
                KeyFigure(name: "Albert Einstein", role: "Father of Relativity", shortBio: "His theory predicted black holes mathematically.", significance: "Changed our understanding of gravity, space, and time."),
                KeyFigure(name: "Stephen Hawking", role: "Black Hole Thermodynamics", shortBio: "Showed that black holes emit radiation and have entropy.", significance: "Bridged quantum mechanics and gravity."),
                KeyFigure(name: "Andrea Ghez & Reinhard Genzel", role: "Galactic Center Pioneers", shortBio: "Used stellar orbits to prove a supermassive black hole at the Milky Way's center.", significance: "Strongest evidence for Sagittarius A*."),
            ],
            quiz: [
                QuizQuestion(type: .trueFalse, question: "Nothing can escape a black hole once it crosses the event horizon, including light.", options: ["True", "False"], correctAnswerIndex: 0, explanation: "The event horizon is the point of no return."),
                QuizQuestion(type: .multipleChoice, question: "What major breakthrough happened in 2019 regarding black holes?", options: ["First theoretical prediction", "First image of a black hole's shadow", "Discovery of Hawking radiation", "First detection of gravitational waves from a black hole merger"], correctAnswerIndex: 1, explanation: "EHT released the first image of a black hole (M87*) in April 2019."),
            ],
            heroImageName: "black_hole_hero"
        )
    }
}
