/**
 * Seed script for Deep Learn – populates Firestore with sample data.
 *
 * Usage:
 *   1. cd scripts
 *   2. npm install
 *   3. Set GOOGLE_APPLICATION_CREDENTIALS to your service account key JSON path:
 *        export GOOGLE_APPLICATION_CREDENTIALS="../service-account-key.json"
 *      OR run from a machine with Application Default Credentials (e.g. Cloud Shell).
 *   4. node seed_firestore.mjs
 *
 * This uses Firebase Admin SDK which bypasses security rules.
 */

import { initializeApp, cert, applicationDefault } from "firebase-admin/app";
import { getFirestore, Timestamp, FieldValue } from "firebase-admin/firestore";

// Initialize with Application Default Credentials or service account
try {
  initializeApp({ credential: applicationDefault() });
} catch {
  console.error(
    "Failed to initialize. Make sure GOOGLE_APPLICATION_CREDENTIALS is set\n" +
    "or run: gcloud auth application-default login"
  );
  process.exit(1);
}

const db = getFirestore();
const now = Timestamp.now();

// ─── Categories ──────────────────────────────────────────────────────────────

const categories = [
  { id: "science",     name: "Science",     courseCount: 2 },
  { id: "languages",   name: "Languages",   courseCount: 2 },
  { id: "engineering", name: "Engineering", courseCount: 1 },
  { id: "history",     name: "History",     courseCount: 1 },
  { id: "arts",        name: "Arts",        courseCount: 1 },
  { id: "technology",  name: "Technology",  courseCount: 2 },
];

// ─── Courses ─────────────────────────────────────────────────────────────────

const courses = [
  {
    id: "intro_physics",
    title: "Introduction to Physics",
    titleLower: "introduction to physics",
    description: "Explore the fundamental laws of nature — from motion and forces to energy and waves. This beginner-friendly course breaks down complex concepts into digestible lessons with hands-on exercises.",
    imageUrl: "https://images.unsplash.com/photo-1636466497217-26a8cbeaf0aa?w=800",
    categoryIds: ["science"],
    totalSections: 3,
    enrollmentCount: 0,
    sections: [
      {
        id: "phys_s1", title: "Newton's Laws of Motion", order: 1, isFreePreview: true,
        summary: "Understand the three laws that govern how objects move.",
        content: "# Newton's Laws of Motion\n\nSir Isaac Newton formulated three laws that form the foundation of classical mechanics.\n\n## First Law (Inertia)\nAn object at rest stays at rest, and an object in motion stays in motion unless acted upon by an external force.\n\n## Second Law (F = ma)\nThe acceleration of an object is directly proportional to the net force and inversely proportional to its mass.\n\n## Third Law\nFor every action, there is an equal and opposite reaction.",
        exercises: [
          { id: "phys_s1_e1", type: "mcq", question: "What does Newton's First Law describe?", options: ["Inertia", "Gravity", "Friction", "Momentum"], correctAnswer: ["Inertia"], order: 1, explanation: "Newton's First Law is the law of inertia — objects resist changes to their state of motion." },
          { id: "phys_s1_e2", type: "trueFalse", question: "F = ma is Newton's Third Law.", options: ["True", "False"], correctAnswer: ["False"], order: 2, explanation: "F = ma is Newton's Second Law." },
          { id: "phys_s1_e3", type: "fillBlank", question: "For every action, there is an equal and opposite ___.", options: [], correctAnswer: ["reaction"], order: 3, explanation: "This is Newton's Third Law of Motion." },
          { id: "phys_s1_e4", type: "openEnded", question: "Explain how Newton's First Law applies to a car suddenly braking.", options: [], correctAnswer: ["inertia", "motion", "forward", "seatbelt", "force"], order: 4, explanation: "Passengers lurch forward due to inertia — their bodies want to continue moving forward even as the car decelerates." },
        ],
      },
      {
        id: "phys_s2", title: "Energy and Work", order: 2, isFreePreview: false,
        summary: "Learn about kinetic energy, potential energy, and the work-energy theorem.",
        content: "# Energy and Work\n\n## Kinetic Energy\nThe energy of motion: KE = ½mv²\n\n## Potential Energy\nStored energy due to position: PE = mgh\n\n## Work-Energy Theorem\nThe net work done on an object equals the change in its kinetic energy.\n\n## Conservation of Energy\nEnergy cannot be created or destroyed, only transformed from one form to another.",
        exercises: [
          { id: "phys_s2_e1", type: "mcq", question: "What is the formula for kinetic energy?", options: ["KE = mv", "KE = ½mv²", "KE = mgh", "KE = Fd"], correctAnswer: ["KE = ½mv²"], order: 1 },
          { id: "phys_s2_e2", type: "fillBlank", question: "Potential energy due to height is calculated as PE = ___.", options: [], correctAnswer: ["mgh"], order: 2 },
          { id: "phys_s2_e3", type: "trueFalse", question: "Energy can be created from nothing.", options: ["True", "False"], correctAnswer: ["False"], order: 3, explanation: "The law of conservation of energy states energy cannot be created or destroyed." },
          { id: "phys_s2_e4", type: "matching", question: "Match the energy type with its example.", options: ["Kinetic Energy", "Potential Energy", "Thermal Energy"], correctAnswer: ["Kinetic Energy:A moving car", "Potential Energy:A book on a shelf", "Thermal Energy:Boiling water"], order: 4 },
        ],
      },
      {
        id: "phys_s3", title: "Waves and Sound", order: 3, isFreePreview: false,
        summary: "Discover the properties of waves — frequency, wavelength, and amplitude.",
        content: "# Waves and Sound\n\n## Types of Waves\n- **Transverse**: oscillation perpendicular to direction (e.g. light)\n- **Longitudinal**: oscillation parallel to direction (e.g. sound)\n\n## Properties\n- **Wavelength (λ)**: distance between wave peaks\n- **Frequency (f)**: number of waves per second (Hz)\n- **Amplitude**: maximum displacement\n\n## Speed of Sound\nv = fλ — approximately 343 m/s in air at room temperature.",
        exercises: [
          { id: "phys_s3_e1", type: "mcq", question: "Sound is an example of what type of wave?", options: ["Transverse", "Longitudinal", "Electromagnetic", "Standing"], correctAnswer: ["Longitudinal"], order: 1 },
          { id: "phys_s3_e2", type: "fillBlank", question: "The speed of sound in air is approximately ___ m/s.", options: [], correctAnswer: ["343"], order: 2 },
          { id: "phys_s3_e3", type: "trueFalse", question: "Light waves are longitudinal waves.", options: ["True", "False"], correctAnswer: ["False"], order: 3, explanation: "Light waves are transverse electromagnetic waves." },
        ],
      },
    ],
  },
  {
    id: "cell_biology",
    title: "Cell Biology Essentials",
    titleLower: "cell biology essentials",
    description: "Dive into the microscopic world of cells — the building blocks of life. Learn about cell structure, organelles, and the processes that keep organisms alive.",
    imageUrl: "https://images.unsplash.com/photo-1530026405186-ed1f139313f8?w=800",
    categoryIds: ["science"],
    totalSections: 3,
    enrollmentCount: 0,
    sections: [
      {
        id: "bio_s1", title: "Cell Structure", order: 1, isFreePreview: true,
        summary: "Explore the basic components of animal and plant cells.",
        content: "# Cell Structure\n\n## Cell Membrane\nA phospholipid bilayer that controls what enters and exits the cell.\n\n## Nucleus\nThe control center containing DNA.\n\n## Cytoplasm\nJelly-like substance where organelles float.\n\n## Key Organelles\n- **Mitochondria**: powerhouse of the cell (ATP production)\n- **Ribosomes**: protein synthesis\n- **Endoplasmic Reticulum**: transport network\n- **Golgi Apparatus**: packaging and shipping",
        exercises: [
          { id: "bio_s1_e1", type: "mcq", question: "Which organelle is known as the 'powerhouse of the cell'?", options: ["Nucleus", "Ribosome", "Mitochondria", "Golgi Apparatus"], correctAnswer: ["Mitochondria"], order: 1 },
          { id: "bio_s1_e2", type: "matching", question: "Match each organelle to its function.", options: ["Nucleus", "Ribosome", "Mitochondria"], correctAnswer: ["Nucleus:Contains DNA", "Ribosome:Protein synthesis", "Mitochondria:ATP production"], order: 2 },
          { id: "bio_s1_e3", type: "fillBlank", question: "The cell membrane is made of a phospholipid ___.", options: [], correctAnswer: ["bilayer"], order: 3 },
        ],
      },
      {
        id: "bio_s2", title: "Cell Division", order: 2, isFreePreview: false,
        summary: "Understand mitosis and meiosis — how cells reproduce.",
        content: "# Cell Division\n\n## Mitosis\nProduces two identical daughter cells. Used for growth and repair.\nPhases: Prophase → Metaphase → Anaphase → Telophase\n\n## Meiosis\nProduces four unique haploid cells (gametes). Used for sexual reproduction.\nInvolves two rounds of division: Meiosis I and Meiosis II.\n\n## Key Difference\nMitosis = 2 identical cells. Meiosis = 4 unique cells.",
        exercises: [
          { id: "bio_s2_e1", type: "mcq", question: "How many cells does mitosis produce?", options: ["1", "2", "4", "8"], correctAnswer: ["2"], order: 1 },
          { id: "bio_s2_e2", type: "trueFalse", question: "Meiosis produces identical cells.", options: ["True", "False"], correctAnswer: ["False"], order: 2, explanation: "Meiosis produces genetically unique cells through crossing over and independent assortment." },
          { id: "bio_s2_e3", type: "openEnded", question: "Explain the main difference between mitosis and meiosis.", options: [], correctAnswer: ["mitosis", "meiosis", "two", "four", "identical", "unique", "gametes", "haploid"], order: 3 },
        ],
      },
      {
        id: "bio_s3", title: "Photosynthesis & Respiration", order: 3, isFreePreview: false,
        summary: "Learn how cells convert energy from sunlight and food.",
        content: "# Photosynthesis & Cellular Respiration\n\n## Photosynthesis\n6CO₂ + 6H₂O + light → C₆H₁₂O₆ + 6O₂\nOccurs in chloroplasts. Converts sunlight to glucose.\n\n## Cellular Respiration\nC₆H₁₂O₆ + 6O₂ → 6CO₂ + 6H₂O + ATP\nOccurs in mitochondria. Converts glucose to usable energy (ATP).\n\n## Connection\nThey are opposite processes — the products of one are the reactants of the other.",
        exercises: [
          { id: "bio_s3_e1", type: "mcq", question: "Where does photosynthesis occur?", options: ["Mitochondria", "Chloroplasts", "Nucleus", "Ribosome"], correctAnswer: ["Chloroplasts"], order: 1 },
          { id: "bio_s3_e2", type: "fillBlank", question: "Cellular respiration converts glucose into ___.", options: [], correctAnswer: ["ATP"], order: 2 },
          { id: "bio_s3_e3", type: "trueFalse", question: "Photosynthesis and cellular respiration are opposite processes.", options: ["True", "False"], correctAnswer: ["True"], order: 3 },
        ],
      },
    ],
  },
  {
    id: "spanish_beginners",
    title: "Spanish for Beginners",
    titleLower: "spanish for beginners",
    description: "Start your Spanish journey with essential vocabulary, grammar, and conversational phrases. Perfect for absolute beginners wanting practical communication skills.",
    imageUrl: "https://images.unsplash.com/photo-1551279880-03af86d8ba8d?w=800",
    categoryIds: ["languages"],
    totalSections: 3,
    enrollmentCount: 0,
    sections: [
      {
        id: "span_s1", title: "Greetings & Introductions", order: 1, isFreePreview: true,
        summary: "Learn basic Spanish greetings and how to introduce yourself.",
        content: "# Greetings & Introductions\n\n## Basic Greetings\n- **Hola** — Hello\n- **Buenos días** — Good morning\n- **Buenas tardes** — Good afternoon\n- **Buenas noches** — Good evening/night\n\n## Introductions\n- **Me llamo...** — My name is...\n- **¿Cómo te llamas?** — What's your name?\n- **Mucho gusto** — Nice to meet you\n- **¿Cómo estás?** — How are you?\n- **Estoy bien, gracias** — I'm fine, thank you",
        exercises: [
          { id: "span_s1_e1", type: "mcq", question: "How do you say 'Good morning' in Spanish?", options: ["Buenas noches", "Buenos días", "Buenas tardes", "Hola"], correctAnswer: ["Buenos días"], order: 1 },
          { id: "span_s1_e2", type: "fillBlank", question: "Me ___ María. (My name is María.)", options: [], correctAnswer: ["llamo"], order: 2 },
          { id: "span_s1_e3", type: "matching", question: "Match the Spanish phrase to its English meaning.", options: ["Hola", "Mucho gusto", "¿Cómo estás?"], correctAnswer: ["Hola:Hello", "Mucho gusto:Nice to meet you", "¿Cómo estás?:How are you?"], order: 3 },
          { id: "span_s1_e4", type: "trueFalse", question: "'Buenas noches' means 'Good morning'.", options: ["True", "False"], correctAnswer: ["False"], order: 4, explanation: "'Buenas noches' means 'Good evening/night'. 'Buenos días' means 'Good morning'." },
        ],
      },
      {
        id: "span_s2", title: "Numbers & Colors", order: 2, isFreePreview: false,
        summary: "Master Spanish numbers 1-20 and common colors.",
        content: "# Numbers & Colors\n\n## Numbers 1-10\nuno, dos, tres, cuatro, cinco, seis, siete, ocho, nueve, diez\n\n## Numbers 11-20\nonce, doce, trece, catorce, quince, dieciséis, diecisiete, dieciocho, diecinueve, veinte\n\n## Colors\n- **rojo** — red\n- **azul** — blue\n- **verde** — green\n- **amarillo** — yellow\n- **negro** — black\n- **blanco** — white",
        exercises: [
          { id: "span_s2_e1", type: "fillBlank", question: "The Spanish word for 'five' is ___.", options: [], correctAnswer: ["cinco"], order: 1 },
          { id: "span_s2_e2", type: "mcq", question: "What color is 'azul' in English?", options: ["Red", "Green", "Blue", "Yellow"], correctAnswer: ["Blue"], order: 2 },
          { id: "span_s2_e3", type: "matching", question: "Match the number to its Spanish word.", options: ["3", "7", "10"], correctAnswer: ["3:tres", "7:siete", "10:diez"], order: 3 },
        ],
      },
      {
        id: "span_s3", title: "Common Verbs", order: 3, isFreePreview: false,
        summary: "Learn essential Spanish verbs and their conjugations.",
        content: "# Common Verbs\n\n## Ser (to be - permanent)\n- Yo soy — I am\n- Tú eres — You are\n- Él/Ella es — He/She is\n\n## Estar (to be - temporary/location)\n- Yo estoy — I am\n- Tú estás — You are\n- Él/Ella está — He/She is\n\n## Tener (to have)\n- Yo tengo — I have\n- Tú tienes — You have\n- Él/Ella tiene — He/She has",
        exercises: [
          { id: "span_s3_e1", type: "mcq", question: "Which verb means 'to have' in Spanish?", options: ["Ser", "Estar", "Tener", "Haber"], correctAnswer: ["Tener"], order: 1 },
          { id: "span_s3_e2", type: "fillBlank", question: "Yo ___ estudiante. (I am a student.) — Use 'ser'.", options: [], correctAnswer: ["soy"], order: 2 },
          { id: "span_s3_e3", type: "trueFalse", question: "'Ser' and 'Estar' both mean 'to be' but are used in different contexts.", options: ["True", "False"], correctAnswer: ["True"], order: 3 },
        ],
      },
    ],
  },
  {
    id: "japanese_basics",
    title: "Japanese: Hiragana & Basics",
    titleLower: "japanese: hiragana & basics",
    description: "Begin your Japanese learning adventure with hiragana characters, basic grammar patterns, and essential everyday phrases.",
    imageUrl: "https://images.unsplash.com/photo-1528164344885-47b1492d932a?w=800",
    categoryIds: ["languages"],
    totalSections: 3,
    enrollmentCount: 0,
    sections: [
      {
        id: "jpn_s1", title: "Hiragana: Vowels & K-row", order: 1, isFreePreview: true,
        summary: "Learn the first 10 hiragana characters.",
        content: "# Hiragana: Vowels & K-row\n\n## The 5 Vowels\n- あ (a) — like 'ah'\n- い (i) — like 'ee'\n- う (u) — like 'oo'\n- え (e) — like 'eh'\n- お (o) — like 'oh'\n\n## K-row\n- か (ka), き (ki), く (ku), け (ke), こ (ko)\n\nPractice writing each character 10 times to build muscle memory!",
        exercises: [
          { id: "jpn_s1_e1", type: "mcq", question: "Which hiragana represents the sound 'ka'?", options: ["あ", "か", "き", "く"], correctAnswer: ["か"], order: 1 },
          { id: "jpn_s1_e2", type: "matching", question: "Match the hiragana to its romaji.", options: ["あ", "い", "う"], correctAnswer: ["あ:a", "い:i", "う:u"], order: 2 },
          { id: "jpn_s1_e3", type: "fillBlank", question: "The hiragana character え is pronounced ___.", options: [], correctAnswer: ["e"], order: 3 },
        ],
      },
      {
        id: "jpn_s2", title: "Basic Phrases", order: 2, isFreePreview: false,
        summary: "Essential Japanese phrases for daily conversation.",
        content: "# Basic Phrases\n\n## Greetings\n- こんにちは (konnichiwa) — Hello\n- おはようございます (ohayou gozaimasu) — Good morning\n- こんばんは (konbanwa) — Good evening\n\n## Useful Phrases\n- ありがとうございます (arigatou gozaimasu) — Thank you\n- すみません (sumimasen) — Excuse me / Sorry\n- はい (hai) — Yes\n- いいえ (iie) — No",
        exercises: [
          { id: "jpn_s2_e1", type: "mcq", question: "What does 'ありがとうございます' mean?", options: ["Hello", "Goodbye", "Thank you", "Sorry"], correctAnswer: ["Thank you"], order: 1 },
          { id: "jpn_s2_e2", type: "trueFalse", question: "'こんばんは' is used as a greeting in the morning.", options: ["True", "False"], correctAnswer: ["False"], order: 2, explanation: "'こんばんは' (konbanwa) means 'Good evening'. Morning greeting is 'おはようございます'." },
          { id: "jpn_s2_e3", type: "fillBlank", question: "The Japanese word for 'yes' is ___.", options: [], correctAnswer: ["hai"], order: 3 },
        ],
      },
      {
        id: "jpn_s3", title: "Self-Introduction", order: 3, isFreePreview: false,
        summary: "Learn to introduce yourself in Japanese using basic sentence patterns.",
        content: "# Self-Introduction (自己紹介)\n\n## Pattern\nはじめまして。[Name]です。よろしくおねがいします。\n(Hajimemashite. [Name] desu. Yoroshiku onegaishimasu.)\n'Nice to meet you. I am [Name]. Please treat me well.'\n\n## Key Grammar\n- **です (desu)**: polite 'is/am/are'\n- **の (no)**: possessive particle\n- **は (wa)**: topic marker",
        exercises: [
          { id: "jpn_s3_e1", type: "mcq", question: "What does 'です' (desu) mean?", options: ["have", "is/am/are", "want", "go"], correctAnswer: ["is/am/are"], order: 1 },
          { id: "jpn_s3_e2", type: "fillBlank", question: "はじめまして。たなか___。(Nice to meet you. I am Tanaka.)", options: [], correctAnswer: ["desu", "です"], order: 2 },
          { id: "jpn_s3_e3", type: "openEnded", question: "Write a simple self-introduction in romaji using the pattern learned.", options: [], correctAnswer: ["hajimemashite", "desu", "yoroshiku", "onegaishimasu"], order: 3 },
        ],
      },
    ],
  },
  {
    id: "intro_programming",
    title: "Introduction to Programming",
    titleLower: "introduction to programming",
    description: "Learn the fundamentals of programming with Python. Covers variables, control flow, functions, and basic data structures — no prior experience needed.",
    imageUrl: "https://images.unsplash.com/photo-1515879218367-8466d910auj7?w=800",
    categoryIds: ["technology"],
    totalSections: 4,
    enrollmentCount: 0,
    sections: [
      {
        id: "prog_s1", title: "Variables & Data Types", order: 1, isFreePreview: true,
        summary: "Understand how to store and manipulate data in Python.",
        content: "# Variables & Data Types\n\n## What is a Variable?\nA variable is a named container for storing data.\n\n```python\nname = \"Alice\"  # string\nage = 25         # integer\nheight = 5.6     # float\nis_student = True # boolean\n```\n\n## Data Types\n- **str**: text (\"hello\")\n- **int**: whole numbers (42)\n- **float**: decimal numbers (3.14)\n- **bool**: True or False",
        exercises: [
          { id: "prog_s1_e1", type: "mcq", question: "What data type is the value 3.14?", options: ["str", "int", "float", "bool"], correctAnswer: ["float"], order: 1 },
          { id: "prog_s1_e2", type: "trueFalse", question: "In Python, variable names are case-sensitive.", options: ["True", "False"], correctAnswer: ["True"], order: 2 },
          { id: "prog_s1_e3", type: "fillBlank", question: "A variable that stores True or False is of type ___.", options: [], correctAnswer: ["bool"], order: 3 },
        ],
      },
      {
        id: "prog_s2", title: "Control Flow", order: 2, isFreePreview: false,
        summary: "Learn if/else statements, loops, and conditional logic.",
        content: "# Control Flow\n\n## If/Else\n```python\nif age >= 18:\n    print(\"Adult\")\nelse:\n    print(\"Minor\")\n```\n\n## For Loop\n```python\nfor i in range(5):\n    print(i)  # 0, 1, 2, 3, 4\n```\n\n## While Loop\n```python\ncount = 0\nwhile count < 3:\n    print(count)\n    count += 1\n```",
        exercises: [
          { id: "prog_s2_e1", type: "mcq", question: "What does range(5) generate?", options: ["1 to 5", "0 to 5", "0 to 4", "1 to 4"], correctAnswer: ["0 to 4"], order: 1 },
          { id: "prog_s2_e2", type: "fillBlank", question: "A ___ loop runs as long as its condition is True.", options: [], correctAnswer: ["while"], order: 2 },
          { id: "prog_s2_e3", type: "trueFalse", question: "An 'else' block runs when the 'if' condition is True.", options: ["True", "False"], correctAnswer: ["False"], order: 3 },
        ],
      },
      {
        id: "prog_s3", title: "Functions", order: 3, isFreePreview: false,
        summary: "Define reusable blocks of code with functions.",
        content: "# Functions\n\n## Defining a Function\n```python\ndef greet(name):\n    return f\"Hello, {name}!\"\n```\n\n## Calling a Function\n```python\nmessage = greet(\"Alice\")\nprint(message)  # Hello, Alice!\n```\n\n## Parameters vs Arguments\n- **Parameter**: variable in function definition\n- **Argument**: actual value passed when calling",
        exercises: [
          { id: "prog_s3_e1", type: "mcq", question: "Which keyword is used to define a function in Python?", options: ["function", "func", "def", "define"], correctAnswer: ["def"], order: 1 },
          { id: "prog_s3_e2", type: "fillBlank", question: "A function uses the ___ keyword to send back a value.", options: [], correctAnswer: ["return"], order: 2 },
          { id: "prog_s3_e3", type: "openEnded", question: "Explain the difference between a parameter and an argument.", options: [], correctAnswer: ["parameter", "definition", "argument", "value", "passed", "calling"], order: 3 },
        ],
      },
      {
        id: "prog_s4", title: "Lists & Dictionaries", order: 4, isFreePreview: false,
        summary: "Store collections of data with Python's built-in data structures.",
        content: "# Lists & Dictionaries\n\n## Lists\nOrdered, mutable collections:\n```python\nfruits = [\"apple\", \"banana\", \"cherry\"]\nfruits.append(\"date\")\nprint(fruits[0])  # apple\n```\n\n## Dictionaries\nKey-value pairs:\n```python\nperson = {\"name\": \"Alice\", \"age\": 25}\nprint(person[\"name\"])  # Alice\n```",
        exercises: [
          { id: "prog_s4_e1", type: "mcq", question: "How do you access the first element of a list?", options: ["list[1]", "list[0]", "list.first()", "list[-1]"], correctAnswer: ["list[0]"], order: 1 },
          { id: "prog_s4_e2", type: "trueFalse", question: "Dictionaries store data as key-value pairs.", options: ["True", "False"], correctAnswer: ["True"], order: 2 },
          { id: "prog_s4_e3", type: "fillBlank", question: "To add an item to a list, use the ___ method.", options: [], correctAnswer: ["append"], order: 3 },
        ],
      },
    ],
  },
  {
    id: "web_development",
    title: "Web Development Fundamentals",
    titleLower: "web development fundamentals",
    description: "Build your first website from scratch. Learn HTML structure, CSS styling, and JavaScript interactivity in this comprehensive beginner course.",
    imageUrl: "https://images.unsplash.com/photo-1547658719-da2b51169166?w=800",
    categoryIds: ["technology"],
    totalSections: 3,
    enrollmentCount: 0,
    sections: [
      {
        id: "web_s1", title: "HTML Basics", order: 1, isFreePreview: true,
        summary: "Structure web pages with HTML elements and tags.",
        content: "# HTML Basics\n\n## What is HTML?\nHyperText Markup Language — the skeleton of every web page.\n\n## Essential Tags\n```html\n<h1>Heading</h1>\n<p>Paragraph</p>\n<a href=\"url\">Link</a>\n<img src=\"image.jpg\" alt=\"description\">\n<ul><li>List item</li></ul>\n```\n\n## Document Structure\n```html\n<!DOCTYPE html>\n<html>\n<head><title>My Page</title></head>\n<body>Content here</body>\n</html>\n```",
        exercises: [
          { id: "web_s1_e1", type: "mcq", question: "What does HTML stand for?", options: ["Hyper Tool Markup Language", "HyperText Markup Language", "Home Text Markup Language", "HyperText Making Language"], correctAnswer: ["HyperText Markup Language"], order: 1 },
          { id: "web_s1_e2", type: "fillBlank", question: "The ___ tag is used for the largest heading.", options: [], correctAnswer: ["h1"], order: 2 },
          { id: "web_s1_e3", type: "trueFalse", question: "The <body> tag contains the visible content of a web page.", options: ["True", "False"], correctAnswer: ["True"], order: 3 },
        ],
      },
      {
        id: "web_s2", title: "CSS Styling", order: 2, isFreePreview: false,
        summary: "Add colors, layouts, and visual design to your HTML pages.",
        content: "# CSS Styling\n\n## Selectors\n```css\nh1 { color: blue; }        /* element */\n.class { font-size: 16px; } /* class */\n#id { margin: 10px; }       /* id */\n```\n\n## Box Model\nEvery element is a box: content → padding → border → margin\n\n## Flexbox\n```css\n.container {\n  display: flex;\n  justify-content: center;\n  align-items: center;\n}\n```",
        exercises: [
          { id: "web_s2_e1", type: "mcq", question: "Which CSS property changes text color?", options: ["font-color", "text-color", "color", "text-style"], correctAnswer: ["color"], order: 1 },
          { id: "web_s2_e2", type: "matching", question: "Match the CSS selector to its type.", options: ["h1 { }", ".card { }", "#main { }"], correctAnswer: ["h1 { }:Element selector", ".card { }:Class selector", "#main { }:ID selector"], order: 2 },
          { id: "web_s2_e3", type: "fillBlank", question: "The CSS Box Model order from inside out is: content, padding, border, ___.", options: [], correctAnswer: ["margin"], order: 3 },
        ],
      },
      {
        id: "web_s3", title: "JavaScript Basics", order: 3, isFreePreview: false,
        summary: "Make your web pages interactive with JavaScript.",
        content: "# JavaScript Basics\n\n## Variables\n```javascript\nlet name = \"Alice\";\nconst PI = 3.14;\n```\n\n## Functions\n```javascript\nfunction greet(name) {\n  return `Hello, ${name}!`;\n}\n```\n\n## DOM Manipulation\n```javascript\ndocument.getElementById(\"btn\")\n  .addEventListener(\"click\", () => {\n    alert(\"Clicked!\");\n  });\n```",
        exercises: [
          { id: "web_s3_e1", type: "mcq", question: "Which keyword declares a constant in JavaScript?", options: ["let", "var", "const", "static"], correctAnswer: ["const"], order: 1 },
          { id: "web_s3_e2", type: "trueFalse", question: "'let' and 'const' are both block-scoped.", options: ["True", "False"], correctAnswer: ["True"], order: 2 },
          { id: "web_s3_e3", type: "fillBlank", question: "To select an element by its ID, use document.___('myId').", options: [], correctAnswer: ["getElementById"], order: 3 },
        ],
      },
    ],
  },
  {
    id: "mechanical_eng",
    title: "Mechanical Engineering Principles",
    titleLower: "mechanical engineering principles",
    description: "Understand the core concepts of mechanical engineering — stress, strain, thermodynamics, and fluid mechanics explained through clear examples.",
    imageUrl: "https://images.unsplash.com/photo-1581092160562-40aa08e78837?w=800",
    categoryIds: ["engineering"],
    totalSections: 3,
    enrollmentCount: 0,
    sections: [
      {
        id: "mech_s1", title: "Stress and Strain", order: 1, isFreePreview: true,
        summary: "Learn how materials respond to forces.",
        content: "# Stress and Strain\n\n## Stress (σ)\nForce per unit area: σ = F/A\nUnits: Pascals (Pa) or N/m²\n\n## Strain (ε)\nDeformation relative to original length: ε = ΔL/L\nDimensionless (no units)\n\n## Young's Modulus (E)\nE = σ/ε — measures material stiffness\nSteel: ~200 GPa, Rubber: ~0.01 GPa",
        exercises: [
          { id: "mech_s1_e1", type: "mcq", question: "What is the formula for stress?", options: ["F × A", "F/A", "F + A", "A/F"], correctAnswer: ["F/A"], order: 1 },
          { id: "mech_s1_e2", type: "trueFalse", question: "Strain has units of Pascals.", options: ["True", "False"], correctAnswer: ["False"], order: 2, explanation: "Strain is dimensionless — it's a ratio of lengths." },
          { id: "mech_s1_e3", type: "fillBlank", question: "Young's Modulus measures material ___.", options: [], correctAnswer: ["stiffness"], order: 3 },
        ],
      },
      {
        id: "mech_s2", title: "Thermodynamics Basics", order: 2, isFreePreview: false,
        summary: "Explore heat, work, and the laws of thermodynamics.",
        content: "# Thermodynamics Basics\n\n## First Law\nEnergy is conserved: ΔU = Q - W\n(Change in internal energy = heat added - work done)\n\n## Second Law\nEntropy of an isolated system always increases.\nHeat flows spontaneously from hot to cold.\n\n## Heat Transfer\n- **Conduction**: through solid material\n- **Convection**: through fluid movement\n- **Radiation**: through electromagnetic waves",
        exercises: [
          { id: "mech_s2_e1", type: "matching", question: "Match the heat transfer method to its medium.", options: ["Conduction", "Convection", "Radiation"], correctAnswer: ["Conduction:Solid material", "Convection:Fluid movement", "Radiation:Electromagnetic waves"], order: 1 },
          { id: "mech_s2_e2", type: "mcq", question: "According to the Second Law, entropy in an isolated system:", options: ["Decreases", "Stays constant", "Increases", "Oscillates"], correctAnswer: ["Increases"], order: 2 },
          { id: "mech_s2_e3", type: "fillBlank", question: "The First Law of Thermodynamics states: ΔU = Q - ___.", options: [], correctAnswer: ["W"], order: 3 },
        ],
      },
      {
        id: "mech_s3", title: "Fluid Mechanics", order: 3, isFreePreview: false,
        summary: "Understand pressure, buoyancy, and fluid flow.",
        content: "# Fluid Mechanics\n\n## Pressure\nP = F/A — force per unit area in a fluid\n\n## Pascal's Law\nPressure applied to a confined fluid is transmitted equally in all directions.\n\n## Archimedes' Principle\nBuoyant force = weight of displaced fluid\nObjects float when buoyant force ≥ weight\n\n## Bernoulli's Principle\nFaster fluid = lower pressure (explains airplane lift)",
        exercises: [
          { id: "mech_s3_e1", type: "mcq", question: "According to Bernoulli's Principle, faster-moving fluid has:", options: ["Higher pressure", "Lower pressure", "Same pressure", "No pressure"], correctAnswer: ["Lower pressure"], order: 1 },
          { id: "mech_s3_e2", type: "trueFalse", question: "An object sinks when the buoyant force is greater than its weight.", options: ["True", "False"], correctAnswer: ["False"], order: 2, explanation: "An object sinks when its weight exceeds the buoyant force." },
          { id: "mech_s3_e3", type: "openEnded", question: "Explain Pascal's Law and give a real-world application.", options: [], correctAnswer: ["pressure", "confined", "fluid", "transmitted", "equally", "hydraulic"], order: 3 },
        ],
      },
    ],
  },
  {
    id: "world_history",
    title: "World History: Key Turning Points",
    titleLower: "world history: key turning points",
    description: "Journey through the pivotal moments that shaped our world — from ancient civilizations to the modern era. Understand how history connects to the present.",
    imageUrl: "https://images.unsplash.com/photo-1461360370896-922624d12a74?w=800",
    categoryIds: ["history"],
    totalSections: 3,
    enrollmentCount: 0,
    sections: [
      {
        id: "hist_s1", title: "Ancient Civilizations", order: 1, isFreePreview: true,
        summary: "Explore Mesopotamia, Egypt, Greece, and Rome.",
        content: "# Ancient Civilizations\n\n## Mesopotamia (3500 BCE)\nThe 'Cradle of Civilization' — first writing (cuneiform), first cities, first laws (Code of Hammurabi).\n\n## Ancient Egypt (3100 BCE)\nPharaohs, pyramids, hieroglyphics. Nile River enabled agriculture.\n\n## Ancient Greece (800 BCE)\nDemocracy, philosophy (Socrates, Plato, Aristotle), Olympic Games.\n\n## Roman Empire (27 BCE - 476 CE)\nRepublic → Empire. Roads, aqueducts, law, Latin language.",
        exercises: [
          { id: "hist_s1_e1", type: "mcq", question: "Which civilization is known as the 'Cradle of Civilization'?", options: ["Egypt", "Greece", "Mesopotamia", "Rome"], correctAnswer: ["Mesopotamia"], order: 1 },
          { id: "hist_s1_e2", type: "matching", question: "Match the civilization to its achievement.", options: ["Mesopotamia", "Greece", "Rome"], correctAnswer: ["Mesopotamia:Cuneiform writing", "Greece:Democracy", "Rome:Aqueducts"], order: 2 },
          { id: "hist_s1_e3", type: "fillBlank", question: "The first known written legal code was the Code of ___.", options: [], correctAnswer: ["Hammurabi"], order: 3 },
        ],
      },
      {
        id: "hist_s2", title: "The Renaissance & Enlightenment", order: 2, isFreePreview: false,
        summary: "A rebirth of art, science, and rational thinking.",
        content: "# Renaissance & Enlightenment\n\n## Renaissance (14th-17th century)\nRebirth of classical learning in Europe.\n- Art: Leonardo da Vinci, Michelangelo\n- Science: Copernicus, Galileo\n- Literature: Shakespeare, Dante\n\n## Enlightenment (17th-18th century)\nAge of Reason — emphasis on logic, science, individual rights.\n- Philosophers: Locke, Voltaire, Rousseau\n- Led to: American & French Revolutions",
        exercises: [
          { id: "hist_s2_e1", type: "mcq", question: "The Renaissance began in which century?", options: ["12th", "14th", "16th", "18th"], correctAnswer: ["14th"], order: 1 },
          { id: "hist_s2_e2", type: "trueFalse", question: "The Enlightenment emphasized faith over reason.", options: ["True", "False"], correctAnswer: ["False"], order: 2, explanation: "The Enlightenment emphasized reason, science, and individual rights." },
          { id: "hist_s2_e3", type: "openEnded", question: "How did the Enlightenment influence the American Revolution?", options: [], correctAnswer: ["reason", "rights", "individual", "liberty", "Locke", "government", "consent"], order: 3 },
        ],
      },
      {
        id: "hist_s3", title: "The Industrial Revolution", order: 3, isFreePreview: false,
        summary: "How machines transformed society, economy, and daily life.",
        content: "# The Industrial Revolution\n\n## When & Where\nBegan in Britain, late 18th century. Spread globally by 19th century.\n\n## Key Inventions\n- Steam engine (James Watt)\n- Spinning jenny (textile industry)\n- Railways & steamships\n\n## Impact\n- Urbanization: people moved to cities\n- Factory system replaced cottage industry\n- New social classes: industrial capitalists & working class\n- Environmental impact: pollution, deforestation",
        exercises: [
          { id: "hist_s3_e1", type: "mcq", question: "Where did the Industrial Revolution begin?", options: ["France", "Germany", "Britain", "USA"], correctAnswer: ["Britain"], order: 1 },
          { id: "hist_s3_e2", type: "fillBlank", question: "James Watt is famous for improving the ___ engine.", options: [], correctAnswer: ["steam"], order: 2 },
          { id: "hist_s3_e3", type: "trueFalse", question: "The Industrial Revolution led to decreased urbanization.", options: ["True", "False"], correctAnswer: ["False"], order: 3, explanation: "The Industrial Revolution caused massive urbanization as people moved from rural areas to cities for factory work." },
        ],
      },
    ],
  },
  {
    id: "art_appreciation",
    title: "Art Appreciation: Styles & Movements",
    titleLower: "art appreciation: styles & movements",
    description: "Develop your eye for art by exploring major movements from classical to contemporary. Learn to analyze, interpret, and appreciate visual art.",
    imageUrl: "https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=800",
    categoryIds: ["arts"],
    totalSections: 3,
    enrollmentCount: 0,
    sections: [
      {
        id: "art_s1", title: "Classical & Renaissance Art", order: 1, isFreePreview: true,
        summary: "From Greek sculptures to da Vinci's masterpieces.",
        content: "# Classical & Renaissance Art\n\n## Classical Art (500 BCE - 500 CE)\n- Focus on ideal beauty, proportion, and harmony\n- Greek sculptures: Discobolus, Venus de Milo\n- Roman mosaics and frescoes\n\n## Renaissance Art (1400-1600)\n- Revival of classical techniques\n- Linear perspective, chiaroscuro (light/shadow)\n- Masters: Leonardo da Vinci, Michelangelo, Raphael\n- Key works: Mona Lisa, Sistine Chapel, School of Athens",
        exercises: [
          { id: "art_s1_e1", type: "mcq", question: "Who painted the Mona Lisa?", options: ["Michelangelo", "Raphael", "Leonardo da Vinci", "Botticelli"], correctAnswer: ["Leonardo da Vinci"], order: 1 },
          { id: "art_s1_e2", type: "fillBlank", question: "The technique of using light and shadow contrast is called ___.", options: [], correctAnswer: ["chiaroscuro"], order: 2 },
          { id: "art_s1_e3", type: "trueFalse", question: "Renaissance art rejected classical Greek and Roman influences.", options: ["True", "False"], correctAnswer: ["False"], order: 3, explanation: "Renaissance means 'rebirth' — it was a revival of classical art and learning." },
        ],
      },
      {
        id: "art_s2", title: "Impressionism & Post-Impressionism", order: 2, isFreePreview: false,
        summary: "How artists broke away from tradition to capture light and emotion.",
        content: "# Impressionism & Post-Impressionism\n\n## Impressionism (1860s-1880s)\n- Capturing light and atmosphere, not precise details\n- Outdoor painting (en plein air)\n- Artists: Monet, Renoir, Degas\n- Characteristic: visible brushstrokes, vibrant colors\n\n## Post-Impressionism (1880s-1900s)\n- Built on Impressionism but added structure and emotion\n- Artists: Van Gogh, Cézanne, Gauguin, Seurat\n- Van Gogh: expressive, swirling brushwork (Starry Night)",
        exercises: [
          { id: "art_s2_e1", type: "mcq", question: "Which artist painted 'Starry Night'?", options: ["Monet", "Van Gogh", "Renoir", "Cézanne"], correctAnswer: ["Van Gogh"], order: 1 },
          { id: "art_s2_e2", type: "matching", question: "Match the artist to their movement.", options: ["Monet", "Van Gogh", "Cézanne"], correctAnswer: ["Monet:Impressionism", "Van Gogh:Post-Impressionism", "Cézanne:Post-Impressionism"], order: 2 },
          { id: "art_s2_e3", type: "fillBlank", question: "Impressionists often painted outdoors, a practice called en plein ___.", options: [], correctAnswer: ["air"], order: 3 },
        ],
      },
      {
        id: "art_s3", title: "Modern & Contemporary Art", order: 3, isFreePreview: false,
        summary: "From abstraction to pop art to today's digital expressions.",
        content: "# Modern & Contemporary Art\n\n## Abstract Art (early 1900s)\n- Non-representational, pure form and color\n- Kandinsky, Mondrian, Malevich\n\n## Surrealism (1920s)\n- Dream-like, subconscious imagery\n- Dalí (melting clocks), Magritte (pipe that 'is not a pipe')\n\n## Pop Art (1950s-60s)\n- Mass culture as art: advertising, comics, consumer products\n- Andy Warhol (Campbell's Soup), Roy Lichtenstein\n\n## Contemporary\n- Installation art, digital art, street art (Banksy)",
        exercises: [
          { id: "art_s3_e1", type: "mcq", question: "Which artist is famous for Campbell's Soup can paintings?", options: ["Dalí", "Banksy", "Warhol", "Mondrian"], correctAnswer: ["Warhol"], order: 1 },
          { id: "art_s3_e2", type: "trueFalse", question: "Surrealism was inspired by dreams and the subconscious mind.", options: ["True", "False"], correctAnswer: ["True"], order: 2 },
          { id: "art_s3_e3", type: "openEnded", question: "What makes Pop Art different from traditional art movements?", options: [], correctAnswer: ["mass", "culture", "consumer", "advertising", "popular", "everyday", "commercial"], order: 3 },
        ],
      },
    ],
  },
  {
    id: "data_science",
    title: "Data Science with Python",
    titleLower: "data science with python",
    description: "Transform raw data into insights. Learn data analysis, visualization, and basic machine learning using Python's powerful libraries.",
    imageUrl: "https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800",
    categoryIds: ["technology", "science"],
    totalSections: 3,
    enrollmentCount: 0,
    sections: [
      {
        id: "ds_s1", title: "Data Analysis with Pandas", order: 1, isFreePreview: true,
        summary: "Load, explore, and manipulate data using DataFrames.",
        content: "# Data Analysis with Pandas\n\n## What is Pandas?\nPython library for data manipulation and analysis.\n\n## DataFrames\n```python\nimport pandas as pd\ndf = pd.read_csv('data.csv')\ndf.head()          # first 5 rows\ndf.describe()      # statistics\ndf['column'].mean() # average\n```\n\n## Key Operations\n- **Filtering**: df[df['age'] > 25]\n- **Grouping**: df.groupby('city').mean()\n- **Sorting**: df.sort_values('score', ascending=False)",
        exercises: [
          { id: "ds_s1_e1", type: "mcq", question: "Which method shows the first 5 rows of a DataFrame?", options: ["df.first()", "df.head()", "df.top()", "df.show()"], correctAnswer: ["df.head()"], order: 1 },
          { id: "ds_s1_e2", type: "fillBlank", question: "To read a CSV file, use pd.read___(filename).", options: [], correctAnswer: ["csv"], order: 2 },
          { id: "ds_s1_e3", type: "trueFalse", question: "Pandas DataFrames can only store numeric data.", options: ["True", "False"], correctAnswer: ["False"], order: 3, explanation: "DataFrames can store any data type including text, dates, and mixed types." },
        ],
      },
      {
        id: "ds_s2", title: "Data Visualization", order: 2, isFreePreview: false,
        summary: "Create charts and plots with Matplotlib and Seaborn.",
        content: "# Data Visualization\n\n## Matplotlib\n```python\nimport matplotlib.pyplot as plt\nplt.plot(x, y)\nplt.xlabel('X axis')\nplt.ylabel('Y axis')\nplt.title('My Chart')\nplt.show()\n```\n\n## Chart Types\n- **Line plot**: trends over time\n- **Bar chart**: comparing categories\n- **Scatter plot**: relationship between variables\n- **Histogram**: distribution of values\n\n## Seaborn\nHigher-level, more beautiful defaults:\n```python\nimport seaborn as sns\nsns.heatmap(df.corr())\n```",
        exercises: [
          { id: "ds_s2_e1", type: "mcq", question: "Which chart type is best for showing trends over time?", options: ["Bar chart", "Pie chart", "Line plot", "Scatter plot"], correctAnswer: ["Line plot"], order: 1 },
          { id: "ds_s2_e2", type: "matching", question: "Match the chart type to its best use.", options: ["Bar chart", "Scatter plot", "Histogram"], correctAnswer: ["Bar chart:Comparing categories", "Scatter plot:Relationship between variables", "Histogram:Distribution of values"], order: 2 },
          { id: "ds_s2_e3", type: "fillBlank", question: "Seaborn is built on top of ___.", options: [], correctAnswer: ["matplotlib"], order: 3 },
        ],
      },
      {
        id: "ds_s3", title: "Intro to Machine Learning", order: 3, isFreePreview: false,
        summary: "Understand supervised learning, classification, and regression.",
        content: "# Intro to Machine Learning\n\n## What is ML?\nAlgorithms that learn patterns from data to make predictions.\n\n## Types\n- **Supervised**: labeled data (classification, regression)\n- **Unsupervised**: unlabeled data (clustering)\n\n## Scikit-learn Example\n```python\nfrom sklearn.model_selection import train_test_split\nfrom sklearn.linear_model import LinearRegression\n\nX_train, X_test, y_train, y_test = train_test_split(X, y)\nmodel = LinearRegression()\nmodel.fit(X_train, y_train)\nscore = model.score(X_test, y_test)\n```",
        exercises: [
          { id: "ds_s3_e1", type: "mcq", question: "Which type of ML uses labeled data?", options: ["Unsupervised", "Supervised", "Reinforcement", "Semi-supervised"], correctAnswer: ["Supervised"], order: 1 },
          { id: "ds_s3_e2", type: "trueFalse", question: "Clustering is a type of supervised learning.", options: ["True", "False"], correctAnswer: ["False"], order: 2, explanation: "Clustering is unsupervised learning — it finds patterns in unlabeled data." },
          { id: "ds_s3_e3", type: "fillBlank", question: "The function train_test_split divides data into ___ and test sets.", options: [], correctAnswer: ["training", "train"], order: 3 },
        ],
      },
    ],
  },
];

// ─── Seed Functions ──────────────────────────────────────────────────────────

async function seedCategories() {
  console.log("Seeding categories...");
  const batch = db.batch();
  for (const cat of categories) {
    const ref = db.collection("categories").doc(cat.id);
    batch.set(ref, {
      name: cat.name,
      iconUrl: null,
      courseCount: cat.courseCount,
    });
  }
  await batch.commit();
  console.log(`  ✓ ${categories.length} categories created`);
}

async function seedCourses() {
  console.log("Seeding courses...");
  for (const course of courses) {
    const courseRef = db.collection("courses").doc(course.id);

    // Write course document
    await courseRef.set({
      title: course.title,
      titleLower: course.titleLower,
      description: course.description,
      imageUrl: course.imageUrl,
      categoryIds: course.categoryIds,
      totalSections: course.totalSections,
      enrollmentCount: course.enrollmentCount,
      createdAt: now,
      updatedAt: now,
    });
    console.log(`  ✓ Course: ${course.title}`);

    // Write sections and exercises
    for (const section of course.sections) {
      const sectionRef = courseRef.collection("sections").doc(section.id);
      await sectionRef.set({
        courseId: course.id,
        title: section.title,
        summary: section.summary,
        order: section.order,
        content: section.content,
        imageUrls: [],
        isFreePreview: section.isFreePreview,
      });

      // Write exercises for this section
      const exerciseBatch = db.batch();
      for (const ex of section.exercises) {
        const exRef = sectionRef.collection("exercises").doc(ex.id);
        exerciseBatch.set(exRef, {
          sectionId: section.id,
          type: ex.type,
          question: ex.question,
          options: ex.options,
          correctAnswer: ex.correctAnswer,
          order: ex.order,
          explanation: ex.explanation || null,
        });
      }
      await exerciseBatch.commit();
      console.log(`    ✓ Section: ${section.title} (${section.exercises.length} exercises)`);
    }
  }
  console.log(`  ✓ ${courses.length} courses with sections and exercises created`);
}

async function seedEnrollmentPairs() {
  console.log("Seeding enrollment pairs (for recommendations)...");
  // Create a few sample co-enrollment pairs
  const pairs = [
    { ids: ["cell_biology", "intro_physics"], count: 12 },
    { ids: ["intro_programming", "web_development"], count: 25 },
    { ids: ["intro_programming", "data_science"], count: 18 },
    { ids: ["spanish_beginners", "japanese_basics"], count: 8 },
    { ids: ["intro_physics", "mechanical_eng"], count: 15 },
    { ids: ["intro_physics", "data_science"], count: 10 },
    { ids: ["world_history", "art_appreciation"], count: 14 },
    { ids: ["web_development", "data_science"], count: 20 },
  ];

  const batch = db.batch();
  for (const pair of pairs) {
    const sorted = [...pair.ids].sort();
    const docId = sorted.join("_");
    const ref = db.collection("enrollmentPairs").doc(docId);
    batch.set(ref, {
      courseIds: sorted,
      coEnrollmentCount: pair.count,
    });
  }
  await batch.commit();
  console.log(`  ✓ ${pairs.length} enrollment pairs created`);
}

// ─── Main ────────────────────────────────────────────────────────────────────

async function main() {
  console.log("🌱 Deep Learn — Seeding Firestore\n");
  try {
    await seedCategories();
    await seedCourses();
    await seedEnrollmentPairs();
    console.log("\n✅ Seed complete! All data populated.");
  } catch (error) {
    console.error("\n❌ Seed failed:", error.message);
    console.error(error);
    process.exit(1);
  }
}

main();
