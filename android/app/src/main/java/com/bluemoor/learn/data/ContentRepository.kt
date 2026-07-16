package com.bluemoor.learn.data

object ContentRepository {

    val allLessons: List<Lesson> by lazy {
        listOf(
            romanRepublic,
            ancientEgypt,
            indusValley,
            ashokaMaurya,
            silkRoad,
            mansaMusa,
            fallConstantinople,
            mughalFounding,
            frenchRevolution,
            partition1947,
            printingPress,
            solarSystem,
            blackHoles,
        )
    }

    fun lessons(category: LessonCategory): List<Lesson> =
        allLessons.filter { it.category == category }

    fun lesson(id: String): Lesson? = allLessons.find { it.id == id }

    fun recommended(progress: UserProgress): Lesson {
        val incomplete = allLessons.firstOrNull { lesson ->
            val done = progress.completedDepths[lesson.id].orEmpty()
            !done.contains(progress.preferredDepth.name)
        }
        return incomplete ?: allLessons.first()
    }

    private val romanRepublic = Lesson(
        id = "roman-republic",
        title = "The Roman Republic",
        category = LessonCategory.HISTORY,
        subtitle = "From Kingdom to Republic — The Birth of Roman Liberty",
        eraOrTopic = "Roman Republic • 509–27 BC",
        estimatedMinutes = 9,
        overviewContent = "In 509 BC, the Roman people overthrew their last king and established a republic. This new system of government would shape Western civilization for centuries.\n\nThe Republic was built on the principle that power should be shared and checked, not concentrated in one ruler.",
        standardContent = "The Roman Republic was founded after the overthrow of King Tarquinius Superbus. It introduced a complex system of elected magistrates, most notably two consuls who shared executive power and could veto each other.\n\nThe Senate, composed of Rome's wealthiest and most influential citizens, advised the consuls and controlled state finances. Over 400+ years, Rome expanded from a small city-state to the dominant Mediterranean power.",
        deepContent = "The Roman Republic's constitution was never written in a single document. It evolved through tradition (mos maiorum), conflict between patricians and plebeians, and pragmatic responses to crises.\n\nKey institutions included the Centuriate Assembly, Tribal Assembly, Plebeian Council, and temporary dictators. The system's checks and balances became a weakness as ambitious generals accumulated power the old institutions could no longer contain.",
        timeline = listOf(
            TimelineEvent("509 BC", "Republic Founded", "Tarquin the Proud is expelled; first consuls take office."),
            TimelineEvent("494 BC", "First Secession of the Plebs", "Creation of the Tribune of the Plebs."),
            TimelineEvent("450 BC", "Twelve Tables", "Rome's first written law code."),
            TimelineEvent("264–146 BC", "Punic Wars", "Rome defeats Carthage and dominates the west Mediterranean."),
            TimelineEvent("49 BC", "Caesar Crosses the Rubicon", "Civil war that ends the Republic."),
            TimelineEvent("27 BC", "Augustus", "Empire begins."),
        ),
        keyFigures = listOf(
            KeyFigure("Lucius Junius Brutus", "Founder & First Consul", "Led the revolt against Tarquin.", "Symbol of republican virtue."),
            KeyFigure("Cincinnatus", "Model Dictator", "Saved Rome then returned to his farm.", "Ideal of civic duty."),
            KeyFigure("Julius Caesar", "The Man Who Ended It", "Crossed the Rubicon.", "Dictatorship ends the Republic."),
        ),
        quiz = listOf(
            QuizQuestion(
                "multipleChoice",
                "In what year was the Roman Republic traditionally founded?",
                listOf("753 BC", "509 BC", "27 BC", "44 BC"),
                1,
                "509 BC marks the traditional founding of the Republic.",
            ),
            QuizQuestion(
                "trueFalse",
                "The Roman Republic had a single written constitution like the United States.",
                listOf("True", "False"),
                1,
                "Rome never had one written constitution; it evolved through custom and struggle.",
            ),
        ),
    )

    private val ancientEgypt = Lesson(
        id = "ancient-egypt-old-kingdom",
        title = "Ancient Egypt: The Old Kingdom",
        category = LessonCategory.HISTORY,
        subtitle = "Pyramids, Pharaohs, and the Dawn of Civilization",
        eraOrTopic = "Old Kingdom • c. 2686–2181 BC",
        estimatedMinutes = 8,
        overviewContent = "The Old Kingdom represents the golden age of pyramid building and the consolidation of pharaonic power in Egypt.",
        standardContent = "During the Old Kingdom, Egypt saw the construction of the Great Pyramids of Giza under pharaohs Khufu, Khafre, and Menkaure. The period established cultural and religious foundations that defined ancient Egypt for millennia.",
        deepContent = "Centralized administration, bureaucracy, and religious ideology of the pharaoh as living god enabled monumental construction. Collapse after Pepi II's long reign led into the First Intermediate Period.",
        timeline = listOf(
            TimelineEvent("c. 2686 BC", "Old Kingdom Begins", "Third Dynasty under Djoser; Step Pyramid at Saqqara."),
            TimelineEvent("c. 2580 BC", "Great Pyramid", "Khufu builds the largest pyramid."),
            TimelineEvent("c. 2181 BC", "Old Kingdom Ends", "Central authority collapses."),
        ),
        keyFigures = listOf(
            KeyFigure("Djoser", "Pharaoh", "Commissioned the first pyramid complex.", "Monumental stone architecture begins."),
            KeyFigure("Imhotep", "Architect & Vizier", "Designed the Step Pyramid.", "Later deified polymath."),
            KeyFigure("Khufu", "Builder of the Great Pyramid", "Fourth Dynasty pharaoh.", "Great Pyramid remains an ancient Wonder."),
        ),
        quiz = listOf(
            QuizQuestion(
                "multipleChoice",
                "Which pharaoh commissioned the Great Pyramid of Giza?",
                listOf("Djoser", "Khufu", "Khafre", "Pepi II"),
                1,
                "Khufu (Cheops) built the Great Pyramid.",
            ),
        ),
    )

    private val solarSystem = Lesson(
        id = "solar-system",
        title = "Our Solar System",
        category = LessonCategory.COSMOS,
        subtitle = "Eight Worlds, One Star, Countless Stories",
        eraOrTopic = "Solar System • Formation & Exploration",
        estimatedMinutes = 7,
        overviewContent = "Our solar system formed about 4.6 billion years ago from a collapsing cloud of gas and dust. At its center burns the Sun — holding everything in its gravitational embrace.",
        standardContent = "Inner terrestrial planets (Mercury, Venus, Earth, Mars) and outer gas/ice giants (Jupiter, Saturn, Uranus, Neptune). The asteroid belt lies between Mars and Jupiter; beyond Neptune, the Kuiper Belt and Oort Cloud.",
        deepContent = "Formed from a protoplanetary disk. Close to the Sun only rock and metal condensed; farther out, ices and gases formed giants. Processes: accretion, differentiation, Late Heavy Bombardment, giant planet migration (Nice model).",
        timeline = listOf(
            TimelineEvent("~4.6 bya", "Solar System Forms", "Molecular cloud collapses into Sun + disk."),
            TimelineEvent("1969", "Apollo 11", "Humans walk on the Moon."),
            TimelineEvent("1977", "Voyager Launches", "Grand tour of the outer planets begins."),
            TimelineEvent("2015", "New Horizons at Pluto", "First close-ups of Pluto."),
        ),
        keyFigures = listOf(
            KeyFigure("Copernicus", "Heliocentric Revolution", "Sun at the center.", "Changed humanity's place in the cosmos."),
            KeyFigure("Galileo", "Jupiter's Moons", "Telescope discoveries.", "Evidence against pure geocentrism."),
            KeyFigure("Carl Sagan", "Cosmic Communicator", "Popularized planetary science.", "Made wonder accessible."),
        ),
        quiz = listOf(
            QuizQuestion(
                "multipleChoice",
                "Which planet is the most massive in our solar system?",
                listOf("Saturn", "Neptune", "Jupiter", "Earth"),
                2,
                "Jupiter is by far the most massive planet.",
            ),
            QuizQuestion(
                "trueFalse",
                "Pluto is still classified as one of the eight major planets.",
                listOf("True", "False"),
                1,
                "In 2006 the IAU reclassified Pluto as a dwarf planet.",
            ),
        ),
    )

    private val blackHoles = Lesson(
        id = "black-holes",
        title = "Black Holes: Gravity's Ultimate Triumph",
        category = LessonCategory.COSMOS,
        subtitle = "Where spacetime ends and our understanding begins",
        eraOrTopic = "Black Holes • Relativity to EHT",
        estimatedMinutes = 11,
        overviewContent = "Black holes are regions of spacetime where gravity is so strong that nothing, not even light, can escape — extreme predictions of Einstein's general relativity.",
        standardContent = "Stellar-mass black holes form when massive stars collapse. Supermassive black holes sit at the centers of most galaxies, including the Milky Way.",
        deepContent = "The Event Horizon Telescope imaged M87* (2019) and Sagittarius A* (2022). Hawking radiation, the information paradox, and singularities remain active frontiers.",
        timeline = listOf(
            TimelineEvent("1915", "General Relativity", "Einstein's field equations."),
            TimelineEvent("1916", "Schwarzschild Solution", "Non-rotating black hole solution."),
            TimelineEvent("1963", "Kerr Solution", "Rotating black holes."),
            TimelineEvent("2019", "First Image", "EHT images M87*'s shadow."),
        ),
        keyFigures = listOf(
            KeyFigure("Einstein", "Relativity", "Predicted black holes mathematically.", "Reshaped gravity."),
            KeyFigure("Stephen Hawking", "Thermodynamics", "Black hole radiation & entropy.", "Bridged quantum and gravity."),
            KeyFigure("Ghez & Genzel", "Galactic Center", "Stellar orbits prove Sgr A*.", "Evidence for our SMBH."),
        ),
        quiz = listOf(
            QuizQuestion(
                "trueFalse",
                "Nothing can escape a black hole once past the event horizon, including light.",
                listOf("True", "False"),
                0,
                "The event horizon is the point of no return.",
            ),
            QuizQuestion(
                "multipleChoice",
                "What major breakthrough happened in 2019 regarding black holes?",
                listOf(
                    "First theoretical prediction",
                    "First image of a black hole's shadow",
                    "Discovery of Hawking radiation",
                    "First gravitational-wave detection",
                ),
                1,
                "EHT released the first image of a black hole shadow (M87*).",
            ),
        ),
    )

    private val indusValley = Lesson(
        id = "indus-valley",
        title = "The Indus Valley Civilization",
        category = LessonCategory.HISTORY,
        subtitle = "Planned cities, seals, and a script we still cannot fully read",
        eraOrTopic = "Harappan Civilization • c. 3300–1300 BC",
        estimatedMinutes = 10,
        overviewContent = "Along the Indus rose one of the world's earliest urban civilizations — contemporary with Egypt and Mesopotamia, famous for orderly cities.",
        standardContent = "Harappa and Mohenjo-daro: grid streets, baked-brick houses, drains, and the Great Bath. Trade reached Mesopotamia. Seals show a still-undeciphered script.",
        deepContent = "Standardized bricks and water management suggest strong civic norms. Decline after c. 1900 BC may involve climate and river shifts. The undeciphered script remains a major puzzle.",
        timeline = listOf(
            TimelineEvent("c. 3300 BC", "Early Harappan", "Village networks densify toward urbanism."),
            TimelineEvent("c. 2600 BC", "Mature Harappan", "Great cities at peak organization."),
            TimelineEvent("c. 1900 BC", "Transformation", "Urban centers fade; regional cultures emerge."),
            TimelineEvent("1920s", "Modern Discovery", "Harappa and Mohenjo-daro excavated."),
        ),
        keyFigures = listOf(
            KeyFigure("John Marshall", "Archaeologist", "Announced the civilization in the 1920s.", "Public recognition of the Indus culture."),
            KeyFigure("R. D. Banerji", "Excavator", "Early work at Mohenjo-daro.", "Helped identify the culture."),
            KeyFigure("Dayaram Sahni", "Excavator", "Key excavations at Harappa.", "Foundational fieldwork."),
        ),
        quiz = listOf(
            QuizQuestion("multipleChoice", "Which feature is most associated with Mature Harappan cities?", listOf("Pyramid tombs", "Grid planning and drains", "Marble amphitheaters", "Great Wall fortifications"), 1, "Harappan cities are famous for planned streets and drainage."),
            QuizQuestion("trueFalse", "The Indus script has been fully deciphered.", listOf("True", "False"), 1, "It remains undeciphered."),
        ),
    )

    private val ashokaMaurya = Lesson(
        id = "ashoka-maurya",
        title = "Ashoka and the Mauryan Empire",
        category = LessonCategory.HISTORY,
        subtitle = "From bloody conquest to dhamma on stone",
        eraOrTopic = "Mauryan Empire • 322–185 BC",
        estimatedMinutes = 11,
        overviewContent = "The Mauryas first united much of the subcontinent. Ashoka's reign is remembered for scale and a public ethical turn after war.",
        standardContent = "Chandragupta founded the empire with Chanakya. Ashoka's Kalinga war was devastating; afterward he promoted dhamma through rock and pillar edicts.",
        deepContent = "Edicts are key primary sources. Dhamma was broader than one sect. After Ashoka the empire weakened and fell c. 185 BC. Modern India revived Ashoka's symbols (Lion Capital).",
        timeline = listOf(
            TimelineEvent("c. 322 BC", "Empire Founded", "Chandragupta establishes Mauryan power."),
            TimelineEvent("c. 261 BC", "Kalinga War", "Ashoka's costly victory and ideological turn."),
            TimelineEvent("c. 250s BC", "Edicts", "Dhamma messages on rocks and pillars."),
            TimelineEvent("c. 185 BC", "Mauryan Fall", "Pushyamitra Shunga ends the dynasty."),
        ),
        keyFigures = listOf(
            KeyFigure("Chandragupta Maurya", "Founder", "Built the empire Ashoka inherited.", "First subcontinental empire-builder."),
            KeyFigure("Chanakya", "Strategist", "Associated with Arthashastra statecraft.", "Advisor-legend of Mauryan rise."),
            KeyFigure("Ashoka", "Emperor", "Expanded then redefined imperial purpose.", "Edicts and dhamma."),
        ),
        quiz = listOf(
            QuizQuestion("multipleChoice", "What event is linked to Ashoka's change of outlook?", listOf("Building Sanchi", "The Kalinga War", "Alexander's invasion", "Gupta coronation"), 1, "Kalinga is the traditional turning point."),
            QuizQuestion("trueFalse", "Ashoka's edicts are primary written sources from his reign.", listOf("True", "False"), 0, "Rock and pillar edicts are contemporary inscriptions."),
        ),
    )

    private val silkRoad = Lesson(
        id = "silk-road",
        title = "The Silk Roads",
        category = LessonCategory.HISTORY,
        subtitle = "Not one road — a web of trade, ideas, and risk",
        eraOrTopic = "Silk Roads • c. 2nd century BC – 15th century AD",
        estimatedMinutes = 10,
        overviewContent = "Overlapping land and sea routes linked China, Central Asia, India, Persia, and the Mediterranean — carrying silk, religions, tech, and disease.",
        standardContent = "A network of oases and ports, not a single highway. Buddhism, later Islam, paper-making knowledge, and goods moved both ways.",
        deepContent = "'Silk Road' is a modern term; historians prefer plural. Empires boosted traffic; the Black Death shows connectivity's dangers. Maritime routes later rivaled overland ones.",
        timeline = listOf(
            TimelineEvent("2nd c. BC", "Han Expansion West", "Chinese engagement with Central Asia intensifies."),
            TimelineEvent("1st–3rd c. AD", "Kushan Hub", "Bridges India, China, and Iran."),
            TimelineEvent("13th c.", "Pax Mongolica", "Lower barriers for merchants and missionaries."),
        ),
        keyFigures = listOf(
            KeyFigure("Zhang Qian", "Han Envoy", "Opened Chinese knowledge of Central Asia.", "Diplomatic pioneer."),
            KeyFigure("Xuanzang", "Buddhist Pilgrim", "7th-century journey to India.", "Classic of travel and faith."),
            KeyFigure("Ibn Battuta", "Traveler", "Mapped a connected Afro-Eurasian world.", "Extraordinary itinerary."),
        ),
        quiz = listOf(
            QuizQuestion("trueFalse", "The Silk Roads carried only luxury goods.", listOf("True", "False"), 1, "Ideas, religions, technologies, and diseases moved too."),
            QuizQuestion("multipleChoice", "Who is commonly credited with coining 'Silk Road'?", listOf("Marco Polo", "Ferdinand von Richthofen", "Ashoka", "Zheng He"), 1, "Von Richthofen popularized Seidenstraße."),
        ),
    )

    private val mansaMusa = Lesson(
        id = "mansa-musa",
        title = "Mansa Musa and the Mali Empire",
        category = LessonCategory.HISTORY,
        subtitle = "Gold, scholarship, and a famous medieval pilgrimage",
        eraOrTopic = "Mali Empire • 13th–16th centuries",
        estimatedMinutes = 9,
        overviewContent = "Mansa Musa's lavish hajj made Mali famous far beyond West Africa — behind the legend stood gold-salt trade and centers of learning.",
        standardContent = "Mali controlled trans-Saharan routes. Timbuktu and Djenné thrived. Musa's c. 1324 pilgrimage entered Mediterranean chronicles.",
        deepContent = "Arabic sources and oral epics (Sundiata) reconstruct this world with different biases. Manuscript cultures show advanced scholarship. Mali was a center, not a periphery.",
        timeline = listOf(
            TimelineEvent("c. 1235", "Sundiata", "Foundations of Mali (epic tradition)."),
            TimelineEvent("c. 1324", "Hajj", "Mansa Musa's pilgrimage becomes famous."),
            TimelineEvent("15th–16th c.", "Shift", "Songhai and changing routes reshape the region."),
        ),
        keyFigures = listOf(
            KeyFigure("Sundiata Keita", "Founder (tradition)", "Hero of the Epic of Sundiata.", "Associated with Mali's rise."),
            KeyFigure("Mansa Musa", "Emperor", "Pilgrimage, patronage, imperial wealth.", "Global medieval fame."),
            KeyFigure("Ibn Khaldun", "Historian", "Referenced Western Sudanese states.", "Major North African scholar."),
        ),
        quiz = listOf(
            QuizQuestion("multipleChoice", "Mansa Musa's outside fame is most tied to…", listOf("Voyage to China", "Hajj to Mecca", "Conquest of Rome", "Silk Road caravan"), 1, "His Mecca pilgrimage was widely reported."),
            QuizQuestion("trueFalse", "Timbuktu was a center of Islamic learning and trade.", listOf("True", "False"), 0, "Known for scholars and manuscripts."),
        ),
    )

    private val fallConstantinople = Lesson(
        id = "fall-constantinople",
        title = "1453: Fall of Constantinople",
        category = LessonCategory.HISTORY,
        subtitle = "Cannons, walls, and the end of a thousand-year empire",
        eraOrTopic = "Ottoman Conquest • 29 May 1453",
        estimatedMinutes = 10,
        overviewContent = "Mehmed II's capture of Constantinople ended Byzantium and made the city the Ottoman capital — a hinge between medieval and early modern eras.",
        standardContent = "Massive cannons, fleet maneuvers, and engineering overcame legendary walls. Hagia Sophia became a mosque; the city was rebuilt as imperial center.",
        deepContent = "Byzantium had been shrinking for generations. 1453 was climax, not bolt from blue. Avoid single-date myths: print, Atlantic voyages, and gunpowder empires remade the age together.",
        timeline = listOf(
            TimelineEvent("1204", "Fourth Crusade", "Latins sack the city; Byzantium weakened."),
            TimelineEvent("1453", "Siege & Fall", "Ottomans take Constantinople."),
            TimelineEvent("1453+", "New Capital", "City remade as Ottoman center."),
        ),
        keyFigures = listOf(
            KeyFigure("Mehmed II", "Ottoman Sultan", "Conqueror who made the city capital.", "Imperial founder-figure."),
            KeyFigure("Constantine XI", "Last Byzantine Emperor", "Died defending the city.", "End of Roman imperial line in the east."),
            KeyFigure("Orban", "Cannon Founder", "Associated with giant bombards.", "Gunpowder siege technology."),
        ),
        quiz = listOf(
            QuizQuestion("multipleChoice", "Constantinople fell to the Ottomans in…", listOf("1204", "1453", "1492", "1526"), 1, "29 May 1453."),
            QuizQuestion("trueFalse", "The Theodosian Walls had protected the city for centuries.", listOf("True", "False"), 0, "Legendary land fortifications."),
        ),
    )

    private val mughalFounding = Lesson(
        id = "mughal-founding",
        title = "Babur and the Mughal Founding",
        category = LessonCategory.HISTORY,
        subtitle = "A Timurid prince, gunpowder, and a new imperial age",
        eraOrTopic = "Mughal Empire • from 1526",
        estimatedMinutes = 10,
        overviewContent = "Babur's 1526 victory at Panipat founded the Mughal Empire — later one of the great early modern states of South Asia.",
        standardContent = "Timurid tactics and gunpowder mattered. The Baburnama is a frank royal memoir. Akbar later consolidated administration and alliances.",
        deepContent = "Longevity required bureaucracy and negotiation with local elites, not only conquest. Persianate court culture met South Asian society in complex synthesis.",
        timeline = listOf(
            TimelineEvent("1526", "First Panipat", "Babur defeats Ibrahim Lodi."),
            TimelineEvent("1556–1605", "Akbar", "Expansion and consolidation."),
            TimelineEvent("1632–1653", "Taj Mahal", "Shah Jahan's iconic mausoleum."),
        ),
        keyFigures = listOf(
            KeyFigure("Babur", "Founder", "Timurid prince and memoirist.", "Opened the Mughal era."),
            KeyFigure("Humayun", "Emperor", "Lost then recovered the throne.", "Bridge to Akbar."),
            KeyFigure("Akbar", "Consolidator", "Built high-Mughal political foundations.", "Alliances and administration."),
        ),
        quiz = listOf(
            QuizQuestion("multipleChoice", "Babur's 1526 victory is the First Battle of…", listOf("Plassey", "Panipat", "Talikota", "Haldighati"), 1, "First Panipat founded Mughal power."),
            QuizQuestion("trueFalse", "The Baburnama is a first-person royal memoir.", listOf("True", "False"), 0, "Major primary source."),
        ),
    )

    private val frenchRevolution = Lesson(
        id = "french-revolution",
        title = "The French Revolution",
        category = LessonCategory.HISTORY,
        subtitle = "Rights, terror, and the remaking of politics",
        eraOrTopic = "France • 1789–1799",
        estimatedMinutes = 12,
        overviewContent = "France moved from monarchy toward republic and empire, inventing a language of rights that still shapes global politics.",
        standardContent = "1789: Estates-General, Bastille, Rights of Man. Radical years brought republic, war, and Terror. Napoleon rose in 1799.",
        deepContent = "Experiences differed for women, colonists, and peasants. The Haitian Revolution forced questions about universal rights and slavery.",
        timeline = listOf(
            TimelineEvent("1789", "Revolution begins", "Estates-General and Bastille."),
            TimelineEvent("1792–94", "Republic & Terror", "Radical politics peak."),
            TimelineEvent("1799", "Brumaire", "Napoleon seizes power."),
        ),
        keyFigures = listOf(
            KeyFigure("Louis XVI", "King", "Authority collapsed; executed 1793.", "End of old regime."),
            KeyFigure("Robespierre", "Jacobin Leader", "Symbol of virtue and Terror.", "Revolutionary radicalism."),
            KeyFigure("Olympe de Gouges", "Writer", "Demanded women's rights.", "Executed during the Terror."),
        ),
        quiz = listOf(
            QuizQuestion("multipleChoice", "The Declaration of the Rights of Man is mainly from…", listOf("1776", "1789", "1815", "1848"), 1, "Adopted in 1789."),
            QuizQuestion("trueFalse", "The Revolution had no colonial consequences.", listOf("True", "False"), 1, "Haiti and empire were deeply connected."),
        ),
    )

    private val partition1947 = Lesson(
        id = "partition-1947",
        title = "Partition of India, 1947",
        category = LessonCategory.HISTORY,
        subtitle = "Independence, borders, and human catastrophe",
        eraOrTopic = "South Asia • 1947",
        estimatedMinutes = 11,
        overviewContent = "British India was partitioned into India and Pakistan. Freedom arrived with mass migration and violence that still shapes the region.",
        standardContent = "Failed negotiations and accelerated transfer produced the Radcliffe Line. Millions moved; Kashmir and other issues endured.",
        deepContent = "Multiple causes: communal politics, colonial exit, local breakdowns. Study with care — center evidence and human experience, avoid propaganda.",
        timeline = listOf(
            TimelineEvent("1940", "Lahore Resolution", "Demand for Muslim-majority states articulated."),
            TimelineEvent("15 Aug 1947", "Independence & Partition", "Two dominions; migration and violence."),
            TimelineEvent("1947–48", "Kashmir War", "First India-Pakistan war."),
        ),
        keyFigures = listOf(
            KeyFigure("Jawaharlal Nehru", "First PM of India", "Led Congress into government.", "Independence leadership."),
            KeyFigure("Muhammad Ali Jinnah", "Pakistan movement leader", "First Governor-General of Pakistan.", "Two-nation politics."),
            KeyFigure("Mahatma Gandhi", "Nationalist leader", "Opposed communal division.", "Assassinated 1948."),
        ),
        quiz = listOf(
            QuizQuestion("multipleChoice", "Partition and independence primarily occurred in…", listOf("1935", "1942", "1947", "1950"), 2, "August 1947."),
            QuizQuestion("trueFalse", "The Radcliffe Line concerned Punjab and Bengal borders.", listOf("True", "False"), 0, "Radcliffe chaired those commissions."),
        ),
    )

    private val printingPress = Lesson(
        id = "printing-press",
        title = "How Print Changed the World",
        category = LessonCategory.HISTORY,
        subtitle = "Moveable type, pamphlets, and the explosion of ideas",
        eraOrTopic = "Information Revolution • from c. 1450",
        estimatedMinutes = 9,
        overviewContent = "When print scaled, ideas could multiply faster than censors — remaking religion, science, and politics over centuries.",
        standardContent = "East Asia had earlier printing; Europe's mid-15th-century boom still transformed scale. Reformation pamphlets and scientific diagrams spread widely.",
        deepContent = "Print did not automatically create modernity. Compare Eurasian trajectories to avoid Eurocentrism; states used print for control as dissidents used it for resistance.",
        timeline = listOf(
            TimelineEvent("Before 800", "East Asian Print", "Woodblock traditions thrive."),
            TimelineEvent("c. 1455", "Gutenberg Bible", "Icon of European moveable type."),
            TimelineEvent("1517+", "Reformation Media", "Pamphlets spread rapidly."),
        ),
        keyFigures = listOf(
            KeyFigure("Johannes Gutenberg", "Printer", "European moveable-type breakthrough.", "Symbol of print revolution."),
            KeyFigure("Martin Luther", "Reformer", "Used print to spread religious challenge.", "Media-savvy theologian."),
            KeyFigure("Goryeo Korea", "Innovation center", "Early metal type (e.g. Jikji, 1377).", "Often overlooked precedent."),
        ),
        quiz = listOf(
            QuizQuestion("trueFalse", "Moveable type appeared only in Europe.", listOf("True", "False"), 1, "East Asia had earlier traditions including Korean metal type."),
            QuizQuestion("trueFalse", "Pamphlets mattered to the Protestant Reformation.", listOf("True", "False"), 0, "Cheap print carried ideas far beyond pulpits."),
        ),
    )
}
