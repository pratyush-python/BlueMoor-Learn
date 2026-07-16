package com.bluemoor.learn.data

object ContentRepository {

    val allLessons: List<Lesson> by lazy {
        listOf(romanRepublic, ancientEgypt, solarSystem, blackHoles)
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
}
