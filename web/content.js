/* Shared lesson content (mirrors Android ContentRepository) */
window.BM_LESSONS = [
  {
    id: "roman-republic",
    title: "The Roman Republic",
    category: "history",
    subtitle: "From Kingdom to Republic — The Birth of Roman Liberty",
    eraOrTopic: "Roman Republic • 509–27 BC",
    estimatedMinutes: 9,
    overview:
      "In 509 BC, the Roman people overthrew their last king and established a republic. This new system of government would shape Western civilization for centuries.\n\nThe Republic was built on the principle that power should be shared and checked, not concentrated in one ruler.",
    standard:
      "The Roman Republic was founded after the overthrow of King Tarquinius Superbus. It introduced a complex system of elected magistrates, most notably two consuls who shared executive power and could veto each other.\n\nThe Senate, composed of Rome's wealthiest and most influential citizens, advised the consuls and controlled state finances. Over 400+ years, Rome expanded from a small city-state to the dominant Mediterranean power.",
    deep:
      "The Roman Republic's constitution was never written in a single document. It evolved through tradition (mos maiorum), conflict between patricians and plebeians, and pragmatic responses to crises.\n\nKey institutions included the Centuriate Assembly, Tribal Assembly, Plebeian Council, and temporary dictators. The system's checks and balances became a weakness as ambitious generals accumulated power the old institutions could no longer contain.",
    timeline: [
      { year: "509 BC", title: "Republic Founded", description: "Tarquin the Proud is expelled; first consuls take office." },
      { year: "494 BC", title: "First Secession of the Plebs", description: "Creation of the Tribune of the Plebs." },
      { year: "450 BC", title: "Twelve Tables", description: "Rome's first written law code." },
      { year: "264–146 BC", title: "Punic Wars", description: "Rome defeats Carthage and dominates the west Mediterranean." },
      { year: "49 BC", title: "Caesar Crosses the Rubicon", description: "Civil war that ends the Republic." },
      { year: "27 BC", title: "Augustus", description: "Empire begins." },
    ],
    figures: [
      { name: "Lucius Junius Brutus", role: "Founder & First Consul", bio: "Led the revolt against Tarquin. Symbol of republican virtue." },
      { name: "Cincinnatus", role: "Model Dictator", bio: "Saved Rome then returned to his farm — ideal of civic duty." },
      { name: "Julius Caesar", role: "The Man Who Ended It", bio: "Crossed the Rubicon. Dictatorship ends the Republic." },
    ],
    quiz: [
      {
        q: "In what year was the Roman Republic traditionally founded?",
        options: ["753 BC", "509 BC", "27 BC", "44 BC"],
        answer: 1,
        explain: "509 BC marks the traditional founding of the Republic.",
      },
      {
        q: "The Roman Republic had a single written constitution like the United States.",
        options: ["True", "False"],
        answer: 1,
        explain: "Rome never had one written constitution; it evolved through custom and struggle.",
      },
    ],
  },
  {
    id: "ancient-egypt-old-kingdom",
    title: "Ancient Egypt: The Old Kingdom",
    category: "history",
    subtitle: "Pyramids, Pharaohs, and the Dawn of Civilization",
    eraOrTopic: "Old Kingdom • c. 2686–2181 BC",
    estimatedMinutes: 8,
    overview: "The Old Kingdom represents the golden age of pyramid building and the consolidation of pharaonic power in Egypt.",
    standard:
      "During the Old Kingdom, Egypt saw the construction of the Great Pyramids of Giza under pharaohs Khufu, Khafre, and Menkaure. The period established cultural and religious foundations that defined ancient Egypt for millennia.",
    deep:
      "Centralized administration, bureaucracy, and religious ideology of the pharaoh as living god enabled monumental construction. Collapse after Pepi II's long reign led into the First Intermediate Period.",
    timeline: [
      { year: "c. 2686 BC", title: "Old Kingdom Begins", description: "Third Dynasty under Djoser; Step Pyramid at Saqqara." },
      { year: "c. 2580 BC", title: "Great Pyramid", description: "Khufu builds the largest pyramid." },
      { year: "c. 2181 BC", title: "Old Kingdom Ends", description: "Central authority collapses." },
    ],
    figures: [
      { name: "Djoser", role: "Pharaoh", bio: "Commissioned the first pyramid complex." },
      { name: "Imhotep", role: "Architect & Vizier", bio: "Designed the Step Pyramid; later deified." },
      { name: "Khufu", role: "Builder of the Great Pyramid", bio: "Fourth Dynasty pharaoh." },
    ],
    quiz: [
      {
        q: "Which pharaoh commissioned the Great Pyramid of Giza?",
        options: ["Djoser", "Khufu", "Khafre", "Pepi II"],
        answer: 1,
        explain: "Khufu (Cheops) built the Great Pyramid.",
      },
    ],
  },
  {
    id: "solar-system",
    title: "Our Solar System",
    category: "cosmos",
    subtitle: "Eight Worlds, One Star, Countless Stories",
    eraOrTopic: "Solar System • Formation & Exploration",
    estimatedMinutes: 7,
    overview:
      "Our solar system formed about 4.6 billion years ago from a collapsing cloud of gas and dust. At its center burns the Sun — holding everything in its gravitational embrace.",
    standard:
      "Inner terrestrial planets (Mercury, Venus, Earth, Mars) and outer gas/ice giants (Jupiter, Saturn, Uranus, Neptune). The asteroid belt lies between Mars and Jupiter; beyond Neptune, the Kuiper Belt and Oort Cloud.",
    deep:
      "Formed from a protoplanetary disk. Close to the Sun only rock and metal condensed; farther out, ices and gases formed giants. Processes: accretion, differentiation, Late Heavy Bombardment, giant planet migration (Nice model).",
    timeline: [
      { year: "~4.6 bya", title: "Solar System Forms", description: "Molecular cloud collapses into Sun + disk." },
      { year: "1969", title: "Apollo 11", description: "Humans walk on the Moon." },
      { year: "1977", title: "Voyager Launches", description: "Grand tour of the outer planets begins." },
      { year: "2015", title: "New Horizons at Pluto", description: "First close-ups of Pluto." },
    ],
    figures: [
      { name: "Copernicus", role: "Heliocentric Revolution", bio: "Put the Sun at the center." },
      { name: "Galileo", role: "Jupiter's Moons", bio: "Telescope discoveries challenged geocentrism." },
      { name: "Carl Sagan", role: "Cosmic Communicator", bio: "Made planetary science wonder accessible." },
    ],
    quiz: [
      {
        q: "Which planet is the most massive in our solar system?",
        options: ["Saturn", "Neptune", "Jupiter", "Earth"],
        answer: 2,
        explain: "Jupiter is by far the most massive planet.",
      },
      {
        q: "Pluto is still classified as one of the eight major planets.",
        options: ["True", "False"],
        answer: 1,
        explain: "In 2006 the IAU reclassified Pluto as a dwarf planet.",
      },
    ],
  },
  {
    id: "black-holes",
    title: "Black Holes: Gravity's Ultimate Triumph",
    category: "cosmos",
    subtitle: "Where spacetime ends and our understanding begins",
    eraOrTopic: "Black Holes • Relativity to EHT",
    estimatedMinutes: 11,
    overview:
      "Black holes are regions of spacetime where gravity is so strong that nothing, not even light, can escape — extreme predictions of Einstein's general relativity.",
    standard:
      "Stellar-mass black holes form when massive stars collapse. Supermassive black holes sit at the centers of most galaxies, including the Milky Way.",
    deep:
      "The Event Horizon Telescope imaged M87* (2019) and Sagittarius A* (2022). Hawking radiation, the information paradox, and singularities remain active frontiers.",
    timeline: [
      { year: "1915", title: "General Relativity", description: "Einstein's field equations." },
      { year: "1916", title: "Schwarzschild Solution", description: "Non-rotating black hole solution." },
      { year: "1963", title: "Kerr Solution", description: "Rotating black holes." },
      { year: "2019", title: "First Image", description: "EHT images M87*'s shadow." },
    ],
    figures: [
      { name: "Einstein", role: "Relativity", bio: "Predicted black holes mathematically." },
      { name: "Stephen Hawking", role: "Thermodynamics", bio: "Black hole radiation & entropy." },
      { name: "Ghez & Genzel", role: "Galactic Center", bio: "Stellar orbits prove Sgr A*." },
    ],
    quiz: [
      {
        q: "Nothing can escape a black hole once past the event horizon, including light.",
        options: ["True", "False"],
        answer: 0,
        explain: "The event horizon is the point of no return.",
      },
      {
        q: "What major breakthrough happened in 2019 regarding black holes?",
        options: [
          "First theoretical prediction",
          "First image of a black hole's shadow",
          "Discovery of Hawking radiation",
          "First gravitational-wave detection",
        ],
        answer: 1,
        explain: "EHT released the first image of a black hole shadow (M87*).",
      },
    ],
  },
];

window.BM_DEPTHS = {
  OVERVIEW: { key: "OVERVIEW", label: "Overview", minutes: 4, xp: 25 },
  STANDARD: { key: "STANDARD", label: "Standard", minutes: 8, xp: 60 },
  DEEP: { key: "DEEP", label: "Deep Dive", minutes: 14, xp: 120 },
};
