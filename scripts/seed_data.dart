/// Seed data script for Deep Learn.
///
/// Usage:
///   1. Make sure you are authenticated with Firebase CLI: `firebase login`
///   2. Run: `dart run scripts/seed_data.dart`
///
/// This populates Firestore with categories, courses, sections, and exercises.
/// It uses the cloud_firestore package directly (client SDK) and requires
/// the app's Firebase configuration.
library;

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

import 'package:deep_learn/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final firestore = FirebaseFirestore.instance;

  print('Seeding categories...');
  await _seedCategories(firestore);

  print('Seeding courses...');
  await _seedCourses(firestore);

  print('Seeding users...');
  await _seedUsers(firestore);

  print('Seeding enrollments, ratings, and reviews...');
  await _seedEnrollmentsAndReviews(firestore);

  print('\nSet up admin account...');
  await _setupAdmin(firestore);

  print('\nSeed complete!');
}

// ─── Categories ──────────────────────────────────────────────

Future<void> _seedCategories(FirebaseFirestore db) async {
  final categories = [
    {'name': 'Science', 'iconUrl': null, 'courseCount': 2},
    {'name': 'Languages', 'iconUrl': null, 'courseCount': 2},
    {'name': 'Engineering', 'iconUrl': null, 'courseCount': 1},
    {'name': 'History', 'iconUrl': null, 'courseCount': 1},
    {'name': 'Arts', 'iconUrl': null, 'courseCount': 1},
    {'name': 'Technology', 'iconUrl': null, 'courseCount': 2},
  ];

  final batch = db.batch();
  for (final cat in categories) {
    final id = (cat['name'] as String).toLowerCase().replaceAll(' ', '_');
    batch.set(db.collection('categories').doc(id), cat);
  }
  await batch.commit();
  print('  Created ${categories.length} categories');
}

// ─── Courses ─────────────────────────────────────────────────

Future<void> _seedCourses(FirebaseFirestore db) async {
  final now = DateTime.now();

  final courses = [
    _buildCourse(
      id: 'intro_to_physics',
      title: 'Introduction to Physics',
      description:
          'Explore the fundamental laws of nature — from Newtonian mechanics to energy conservation. Build intuition through real-world examples and hands-on problem solving.',
      imageUrl: 'https://images.unsplash.com/photo-1636466497217-26a8cbeaf0aa?w=800',
      categoryIds: ['science'],
      sections: [
        _section('Newton\'s Laws of Motion', 'Understand the three laws that govern how objects move.',
            'Sir Isaac Newton formulated three laws of motion in 1687.\n\n**First Law (Inertia):** An object at rest stays at rest, and an object in motion stays in motion unless acted upon by a net external force.\n\n**Second Law (F=ma):** The acceleration of an object is directly proportional to the net force acting on it and inversely proportional to its mass.\n\n**Third Law:** For every action, there is an equal and opposite reaction.\n\nThese laws form the foundation of classical mechanics and are used to analyze everything from car collisions to planetary orbits.',
            exercises: [
              _mcq('What does Newton\'s First Law describe?', ['Inertia', 'Gravity', 'Friction', 'Energy'], ['Inertia'], 'The first law is also known as the law of inertia.'),
              _trueFalse('Newton\'s Second Law is expressed as F = ma.', ['true'], 'Force equals mass times acceleration.'),
              _fillBlank('For every action, there is an equal and opposite _____.', ['reaction'], 'This is Newton\'s Third Law.'),
              _mcq('Which law explains why a book stays on a table?', ['First Law', 'Second Law', 'Third Law', 'None'], ['First Law'], 'An object at rest stays at rest unless a force acts on it.'),
            ]),
        _section('Energy and Work', 'Learn about kinetic energy, potential energy, and the work-energy theorem.',
            'Energy is the capacity to do work. In physics, work is defined as force applied over a distance: W = F × d × cos(θ).\n\n**Kinetic Energy (KE):** The energy of motion. KE = ½mv²\n\n**Potential Energy (PE):** Stored energy due to position. Gravitational PE = mgh\n\n**Conservation of Energy:** Energy cannot be created or destroyed, only transformed from one form to another.\n\nThe work-energy theorem states that the net work done on an object equals the change in its kinetic energy.',
            exercises: [
              _fillBlank('Kinetic energy equals one-half times mass times velocity _____.', ['squared'], 'KE = ½mv²'),
              _mcq('What type of energy does a ball at the top of a hill have?', ['Kinetic', 'Potential', 'Thermal', 'Nuclear'], ['Potential'], 'Gravitational potential energy depends on height.'),
              _trueFalse('Energy can be created from nothing.', ['false'], 'Energy is conserved — it can only be transformed.'),
              _openEnded('Explain how a roller coaster demonstrates energy conservation.', ['potential energy converts to kinetic energy'], 'At the top, energy is potential; as it descends, it converts to kinetic.'),
            ]),
        _section('Waves and Sound', 'Understand wave properties, sound propagation, and the Doppler effect.',
            'A wave is a disturbance that transfers energy through matter or space.\n\n**Transverse waves:** Particles move perpendicular to the direction of wave travel (e.g., light).\n**Longitudinal waves:** Particles move parallel to the direction of wave travel (e.g., sound).\n\n**Key properties:**\n- Wavelength (λ): Distance between consecutive peaks\n- Frequency (f): Number of cycles per second (Hz)\n- Amplitude: Maximum displacement from rest\n- Speed: v = fλ\n\n**The Doppler Effect:** The apparent change in frequency of a wave when the source or observer is moving.',
            exercises: [
              _mcq('Sound is what type of wave?', ['Transverse', 'Longitudinal', 'Electromagnetic', 'Standing'], ['Longitudinal'], 'Sound waves compress and expand air molecules along the direction of travel.'),
              _fillBlank('Wave speed equals frequency times _____.', ['wavelength'], 'v = fλ'),
              _trueFalse('The Doppler effect only applies to sound waves.', ['false'], 'It applies to all waves, including light (redshift/blueshift).'),
              _matching('Match the wave property to its definition.', ['Wavelength:Distance between peaks', 'Frequency:Cycles per second', 'Amplitude:Maximum displacement'], 'These are the three fundamental wave properties.'),
            ]),
      ],
      now: now,
    ),
    _buildCourse(
      id: 'intro_to_biology',
      title: 'Introduction to Biology',
      description:
          'Discover the building blocks of life — from cells to ecosystems. Understand DNA, evolution, and how living organisms interact with their environment.',
      imageUrl: 'https://images.unsplash.com/photo-1530026405186-ed1f139313f8?w=800',
      categoryIds: ['science'],
      sections: [
        _section('Cell Biology', 'Learn about the structure and function of cells.',
            'The cell is the basic unit of life. All living organisms are made up of one or more cells.\n\n**Two main types:**\n- **Prokaryotic cells:** No nucleus, simpler structure (bacteria)\n- **Eukaryotic cells:** Have a nucleus and membrane-bound organelles (plants, animals, fungi)\n\n**Key organelles:**\n- Nucleus: Contains DNA, controls cell activities\n- Mitochondria: Powerhouse of the cell, produces ATP\n- Ribosomes: Synthesize proteins\n- Cell membrane: Controls what enters and exits\n- Endoplasmic reticulum: Protein and lipid synthesis',
            exercises: [
              _mcq('Which organelle is known as the powerhouse of the cell?', ['Nucleus', 'Mitochondria', 'Ribosome', 'Golgi apparatus'], ['Mitochondria'], 'Mitochondria produce ATP through cellular respiration.'),
              _trueFalse('Prokaryotic cells have a nucleus.', ['false'], 'Prokaryotes lack a membrane-bound nucleus.'),
              _fillBlank('The _____ controls what enters and exits the cell.', ['cell membrane'], 'It is a selectively permeable barrier.'),
              _mcq('Which type of cell is more complex?', ['Prokaryotic', 'Eukaryotic', 'Both equally', 'Neither'], ['Eukaryotic'], 'Eukaryotic cells have membrane-bound organelles.'),
            ]),
        _section('DNA and Genetics', 'Understand heredity and the molecular basis of life.',
            'DNA (deoxyribonucleic acid) is the molecule that carries genetic instructions for all living organisms.\n\n**Structure:** Double helix made of nucleotides, each containing a sugar, phosphate group, and nitrogenous base (A, T, C, G).\n\n**Base pairing rules:** A pairs with T, C pairs with G.\n\n**Gene expression:** DNA → RNA → Protein (the Central Dogma).\n\n**Mendel\'s Laws:**\n1. Law of Segregation: Each organism has two alleles for each trait\n2. Law of Independent Assortment: Genes for different traits are inherited independently',
            exercises: [
              _fillBlank('Adenine pairs with _____ in DNA.', ['thymine'], 'A-T and C-G are the base pairing rules.'),
              _mcq('What is the Central Dogma of molecular biology?', ['DNA → RNA → Protein', 'RNA → DNA → Protein', 'Protein → RNA → DNA', 'DNA → Protein → RNA'], ['DNA → RNA → Protein'], 'Information flows from DNA to RNA to Protein.'),
              _trueFalse('Gregor Mendel is considered the father of genetics.', ['true'], 'Mendel\'s pea plant experiments established the laws of inheritance.'),
              _openEnded('Why is DNA replication important for cell division?', ['each new cell needs a complete copy of DNA'], 'Without replication, daughter cells would not have genetic instructions.'),
            ]),
        _section('Evolution and Natural Selection', 'Explore how species change over time.',
            'Evolution is the change in inherited characteristics of biological populations over successive generations.\n\n**Charles Darwin\'s Theory of Natural Selection:**\n1. Variation exists within populations\n2. More offspring are produced than can survive\n3. Individuals with favorable traits are more likely to survive and reproduce\n4. Favorable traits are passed to offspring\n\n**Evidence for evolution:**\n- Fossil record\n- Comparative anatomy (homologous structures)\n- DNA/molecular evidence\n- Direct observation (antibiotic resistance)',
            exercises: [
              _mcq('Who proposed the theory of natural selection?', ['Mendel', 'Darwin', 'Lamarck', 'Watson'], ['Darwin'], 'Charles Darwin published On the Origin of Species in 1859.'),
              _trueFalse('Natural selection acts on individuals, not populations.', ['false'], 'Natural selection acts on populations over generations.'),
              _fillBlank('Structures with a common evolutionary origin are called _____ structures.', ['homologous'], 'Human arms and whale flippers are homologous structures.'),
            ]),
      ],
      now: now,
    ),
    _buildCourse(
      id: 'spanish_basics',
      title: 'Spanish for Beginners',
      description:
          'Learn conversational Spanish from scratch. Master greetings, basic grammar, numbers, and everyday vocabulary through interactive exercises.',
      imageUrl: 'https://images.unsplash.com/photo-1551279880-03af85c387a8?w=800',
      categoryIds: ['languages'],
      sections: [
        _section('Greetings and Introductions', 'Learn to say hello and introduce yourself in Spanish.',
            '**Basic greetings:**\n- Hola — Hello\n- Buenos días — Good morning\n- Buenas tardes — Good afternoon\n- Buenas noches — Good evening/night\n\n**Introductions:**\n- Me llamo... — My name is...\n- ¿Cómo te llamas? — What is your name?\n- Mucho gusto — Nice to meet you\n- ¿Cómo estás? — How are you?\n- Estoy bien, gracias — I\'m fine, thanks\n\n**Farewells:**\n- Adiós — Goodbye\n- Hasta luego — See you later\n- Hasta mañana — See you tomorrow',
            exercises: [
              _mcq('How do you say "Good morning" in Spanish?', ['Buenos días', 'Buenas tardes', 'Buenas noches', 'Hola'], ['Buenos días'], 'Días means days/morning.'),
              _fillBlank('Me _____ María. (My name is María)', ['llamo'], 'Llamarse is a reflexive verb meaning to call oneself.'),
              _trueFalse('"Hasta luego" means "See you later".', ['true'], 'Hasta = until, luego = later.'),
              _matching('Match the Spanish greeting to its English translation.', ['Hola:Hello', 'Adiós:Goodbye', 'Mucho gusto:Nice to meet you'], 'These are the most common greetings.'),
            ]),
        _section('Numbers and Colors', 'Count from 1-100 and learn the Spanish color words.',
            '**Numbers 1-10:** uno, dos, tres, cuatro, cinco, seis, siete, ocho, nueve, diez\n\n**Numbers 11-20:** once, doce, trece, catorce, quince, dieciséis, diecisiete, dieciocho, diecinueve, veinte\n\n**Tens:** treinta (30), cuarenta (40), cincuenta (50), sesenta (60), setenta (70), ochenta (80), noventa (90), cien (100)\n\n**Colors:**\n- Rojo — Red\n- Azul — Blue\n- Verde — Green\n- Amarillo — Yellow\n- Blanco — White\n- Negro — Black\n- Naranja — Orange\n- Morado — Purple',
            exercises: [
              _fillBlank('The number 5 in Spanish is _____.', ['cinco'], 'Uno, dos, tres, cuatro, cinco.'),
              _mcq('What color is "verde"?', ['Red', 'Green', 'Blue', 'Yellow'], ['Green'], 'Verde means green in Spanish.'),
              _trueFalse('"Cien" means 100 in Spanish.', ['true'], 'Cien is used for exactly 100.'),
              _mcq('What is "quince" in English?', ['14', '15', '16', '50'], ['15'], 'Quince = 15.'),
            ]),
        _section('Basic Sentence Structure', 'Form simple sentences using subject-verb-object patterns.',
            '**Spanish sentence structure** is similar to English: Subject + Verb + Object.\n\n**Subject pronouns:**\n- Yo — I\n- Tú — You (informal)\n- Él/Ella — He/She\n- Nosotros — We\n- Ellos/Ellas — They\n\n**Present tense of "ser" (to be):**\n- Yo soy\n- Tú eres\n- Él/Ella es\n- Nosotros somos\n- Ellos son\n\n**Example sentences:**\n- Yo soy estudiante. (I am a student.)\n- Ella es profesora. (She is a teacher.)\n- Nosotros somos amigos. (We are friends.)',
            exercises: [
              _fillBlank('Yo _____ estudiante. (I am a student.)', ['soy'], '"Ser" conjugated for "yo" is "soy".'),
              _mcq('What does "Tú eres" mean?', ['I am', 'You are', 'He is', 'We are'], ['You are'], 'Tú = you, eres = are (informal).'),
              _trueFalse('"Nosotros somos" means "We are".', ['true'], 'Somos is the nosotros form of ser.'),
              _openEnded('Write a sentence introducing yourself in Spanish.', ['me llamo'], 'Use "Me llamo [name]" or "Yo soy [name]".'),
            ]),
      ],
      now: now,
    ),
    _buildCourse(
      id: 'japanese_basics',
      title: 'Japanese for Beginners',
      description:
          'Start learning Japanese with hiragana, basic phrases, and essential grammar. Perfect for absolute beginners who want to read and speak Japanese.',
      imageUrl: 'https://images.unsplash.com/photo-1528164344705-47542687000d?w=800',
      categoryIds: ['languages'],
      sections: [
        _section('Hiragana Basics', 'Learn the first 15 hiragana characters and how to read them.',
            '**Hiragana** is one of three Japanese writing systems. It has 46 basic characters.\n\n**Vowels:** あ (a), い (i), う (u), え (e), お (o)\n\n**K-row:** か (ka), き (ki), く (ku), け (ke), こ (ko)\n\n**S-row:** さ (sa), し (shi), す (su), せ (se), そ (so)\n\nEach character represents one syllable. Japanese is written without spaces between words.\n\n**Practice tip:** Write each character 10 times while saying the sound out loud.',
            exercises: [
              _mcq('What sound does あ make?', ['a', 'i', 'u', 'ka'], ['a'], 'あ is the first vowel in hiragana.'),
              _fillBlank('The character き is pronounced _____.', ['ki'], 'き is in the K-row: ka, ki, ku, ke, ko.'),
              _trueFalse('Hiragana has 46 basic characters.', ['true'], 'These 46 characters cover all basic sounds.'),
              _matching('Match the hiragana to its sound.', ['あ:a', 'か:ka', 'さ:sa'], 'These are the first characters of the vowel, K, and S rows.'),
            ]),
        _section('Self-Introduction in Japanese', 'Learn to introduce yourself using polite Japanese.',
            '**Key phrases:**\n- はじめまして (Hajimemashite) — Nice to meet you\n- わたし は [name] です (Watashi wa [name] desu) — I am [name]\n- よろしくおねがいします (Yoroshiku onegaishimasu) — Please take care of me\n\n**Structure:** Topic は [information] です\n\nThe particle は (wa) marks the topic of the sentence. です (desu) is the polite copula (similar to "is/am/are").\n\n**Example:**\n- わたし は がくせい です。(Watashi wa gakusei desu.) — I am a student.',
            exercises: [
              _fillBlank('わたし は _____ です means "I am a student".', ['がくせい'], 'がくせい (gakusei) means student.'),
              _trueFalse('"です" is the polite form of "to be" in Japanese.', ['true'], 'です (desu) is the polite copula.'),
              _mcq('What does "はじめまして" mean?', ['Goodbye', 'Nice to meet you', 'Thank you', 'Excuse me'], ['Nice to meet you'], 'Said when meeting someone for the first time.'),
            ]),
        _section('Numbers 1-10 in Japanese', 'Count from one to ten in Japanese.',
            '**Japanese numbers 1-10:**\n1. いち (ichi)\n2. に (ni)\n3. さん (san)\n4. し/よん (shi/yon)\n5. ご (go)\n6. ろく (roku)\n7. しち/なな (shichi/nana)\n8. はち (hachi)\n9. きゅう/く (kyuu/ku)\n10. じゅう (juu)\n\n**Note:** Numbers 4, 7, and 9 have two readings. The alternate readings (よん, なな, きゅう) are more commonly used because し sounds like the word for death (死).',
            exercises: [
              _mcq('What is the number 3 in Japanese?', ['に', 'さん', 'し', 'ご'], ['さん'], 'さん (san) = 3.'),
              _fillBlank('The number 10 in Japanese is _____.', ['じゅう'], 'じゅう (juu) = 10.'),
              _trueFalse('The number 4 has two readings because し sounds like death.', ['true'], 'し (shi) = death, so よん (yon) is preferred.'),
            ]),
      ],
      now: now,
    ),
    _buildCourse(
      id: 'web_development',
      title: 'Web Development Fundamentals',
      description:
          'Master the core technologies of the web — HTML for structure, CSS for styling, and JavaScript for interactivity. Build your first website from scratch.',
      imageUrl: 'https://images.unsplash.com/photo-1627398242454-45a1465c2479?w=800',
      categoryIds: ['technology', 'engineering'],
      sections: [
        _section('HTML Essentials', 'Learn the building blocks of web pages.',
            '**HTML (HyperText Markup Language)** is the standard language for creating web pages.\n\n**Basic structure:**\n```html\n<!DOCTYPE html>\n<html>\n  <head>\n    <title>My Page</title>\n  </head>\n  <body>\n    <h1>Hello World</h1>\n    <p>This is a paragraph.</p>\n  </body>\n</html>\n```\n\n**Common elements:**\n- `<h1>` to `<h6>`: Headings\n- `<p>`: Paragraph\n- `<a href="...">`: Hyperlink\n- `<img src="...">`: Image\n- `<ul>/<ol>`: Unordered/ordered list\n- `<div>`: Division/container',
            exercises: [
              _mcq('What does HTML stand for?', ['HyperText Markup Language', 'High Tech Modern Language', 'Home Tool Markup Language', 'Hyper Transfer Markup Language'], ['HyperText Markup Language'], 'HTML = HyperText Markup Language.'),
              _fillBlank('The element used for paragraphs in HTML is <_____>.', ['p'], 'The <p> tag creates a paragraph.'),
              _trueFalse('HTML is a programming language.', ['false'], 'HTML is a markup language, not a programming language.'),
              _mcq('Which tag creates the largest heading?', ['<h6>', '<h1>', '<head>', '<header>'], ['<h1>'], '<h1> is the largest heading, <h6> is the smallest.'),
            ]),
        _section('CSS Styling', 'Style your web pages with colors, layouts, and typography.',
            '**CSS (Cascading Style Sheets)** controls the presentation of HTML elements.\n\n**Three ways to add CSS:**\n1. Inline: `<p style="color: red;">`\n2. Internal: `<style>` tag in `<head>`\n3. External: separate `.css` file (recommended)\n\n**CSS syntax:**\n```css\nselector {\n  property: value;\n}\n```\n\n**Common properties:**\n- `color`: Text color\n- `background-color`: Background color\n- `font-size`: Text size\n- `margin`: Space outside element\n- `padding`: Space inside element\n- `display`: flex, grid, block, inline',
            exercises: [
              _fillBlank('CSS stands for Cascading _____ Sheets.', ['Style'], 'CSS = Cascading Style Sheets.'),
              _mcq('Which is the recommended way to add CSS?', ['Inline', 'Internal', 'External file', 'JavaScript'], ['External file'], 'External CSS files keep style separate from structure.'),
              _trueFalse('The "margin" property controls space inside an element.', ['false'], 'Margin is outside; padding is inside.'),
              _matching('Match the CSS property to what it controls.', ['color:Text color', 'padding:Space inside element', 'font-size:Text size'], 'These are fundamental CSS properties.'),
            ]),
        _section('JavaScript Basics', 'Add interactivity to web pages with JavaScript.',
            '**JavaScript** is the programming language of the web.\n\n**Variables:**\n```js\nlet name = "Alice";\nconst age = 25;\n```\n\n**Functions:**\n```js\nfunction greet(name) {\n  return "Hello, " + name;\n}\n```\n\n**DOM Manipulation:**\n```js\ndocument.getElementById("myElement").textContent = "New text";\n```\n\n**Events:**\n```js\nbutton.addEventListener("click", function() {\n  alert("Button clicked!");\n});\n```\n\nJavaScript can modify HTML, respond to user actions, validate forms, fetch data from servers, and much more.',
            exercises: [
              _mcq('Which keyword declares a constant variable?', ['let', 'var', 'const', 'function'], ['const'], 'const creates a variable that cannot be reassigned.'),
              _fillBlank('To select an element by ID, use document._____(\"id\").', ['getElementById'], 'getElementById returns the element with the matching ID.'),
              _trueFalse('JavaScript can only run in web browsers.', ['false'], 'JavaScript also runs on servers via Node.js.'),
              _openEnded('What is the difference between let and const?', ['let can be reassigned', 'const cannot be reassigned'], 'let allows reassignment, const does not.'),
            ]),
      ],
      now: now,
    ),
    _buildCourse(
      id: 'data_science_python',
      title: 'Data Science with Python',
      description:
          'Learn to analyze data, create visualizations, and build predictive models using Python, pandas, and scikit-learn.',
      imageUrl: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800',
      categoryIds: ['technology'],
      sections: [
        _section('Python Data Types', 'Master lists, dictionaries, tuples, and sets in Python.',
            '**Python\'s core data structures:**\n\n**Lists** — ordered, mutable collections:\n```python\nfruits = ["apple", "banana", "cherry"]\nfruits.append("date")\n```\n\n**Dictionaries** — key-value pairs:\n```python\nstudent = {"name": "Alice", "age": 20}\nstudent["grade"] = "A"\n```\n\n**Tuples** — ordered, immutable:\n```python\ncoords = (10, 20)\n```\n\n**Sets** — unordered, unique elements:\n```python\nunique = {1, 2, 3, 2, 1}  # {1, 2, 3}\n```',
            exercises: [
              _mcq('Which Python data type is immutable?', ['List', 'Dictionary', 'Tuple', 'Set'], ['Tuple'], 'Tuples cannot be modified after creation.'),
              _trueFalse('A Python dictionary stores key-value pairs.', ['true'], 'Dictionaries use keys to access values.'),
              _fillBlank('To add an element to a list, use the _____ method.', ['append'], 'list.append(item) adds to the end.'),
              _mcq('What makes sets unique?', ['They are ordered', 'They allow duplicates', 'They only contain unique elements', 'They are immutable'], ['They only contain unique elements'], 'Sets automatically remove duplicates.'),
            ]),
        _section('Pandas DataFrames', 'Load, manipulate, and analyze tabular data with pandas.',
            '**Pandas** is the essential library for data manipulation in Python.\n\n**Creating a DataFrame:**\n```python\nimport pandas as pd\ndf = pd.read_csv("data.csv")\n```\n\n**Key operations:**\n```python\ndf.head()           # First 5 rows\ndf.describe()       # Statistical summary\ndf["column"]        # Select a column\ndf[df["age"] > 25]  # Filter rows\ndf.groupby("city").mean()  # Group by\n```\n\n**Handling missing data:**\n```python\ndf.dropna()    # Remove rows with NaN\ndf.fillna(0)   # Replace NaN with 0\n```',
            exercises: [
              _fillBlank('To read a CSV file, use pd._____(\"file.csv\").', ['read_csv'], 'pd.read_csv() loads tabular data from a CSV file.'),
              _mcq('What does df.head() return?', ['All rows', 'First 5 rows', 'Last 5 rows', 'Column names'], ['First 5 rows'], 'head() returns the first 5 rows by default.'),
              _trueFalse('df.dropna() removes rows containing missing values.', ['true'], 'dropna() drops rows with any NaN values.'),
              _openEnded('How would you filter a DataFrame to show only rows where age > 30?', ['df[df[\"age\"] > 30]', 'df[df.age > 30]'], 'Use boolean indexing with the condition.'),
            ]),
        _section('Data Visualization', 'Create charts and plots with matplotlib and seaborn.',
            '**Matplotlib** is Python\'s foundational plotting library.\n\n```python\nimport matplotlib.pyplot as plt\n\nplt.plot([1, 2, 3], [4, 5, 6])\nplt.xlabel("X axis")\nplt.ylabel("Y axis")\nplt.title("My Plot")\nplt.show()\n```\n\n**Seaborn** builds on matplotlib with statistical visualizations:\n```python\nimport seaborn as sns\nsns.histplot(data=df, x="age")\nsns.scatterplot(data=df, x="height", y="weight")\nsns.boxplot(data=df, x="category", y="value")\n```\n\n**Chart types and when to use them:**\n- Line chart: trends over time\n- Bar chart: comparing categories\n- Scatter plot: relationship between two variables\n- Histogram: distribution of a single variable',
            exercises: [
              _mcq('Which chart type is best for showing trends over time?', ['Bar chart', 'Line chart', 'Pie chart', 'Scatter plot'], ['Line chart'], 'Line charts connect data points chronologically.'),
              _fillBlank('To display a matplotlib plot, call plt._____.', ['show'], 'plt.show() renders the plot on screen.'),
              _trueFalse('Seaborn is built on top of matplotlib.', ['true'], 'Seaborn provides a high-level interface to matplotlib.'),
              _matching('Match chart type to use case.', ['Scatter plot:Relationship between variables', 'Histogram:Distribution of values', 'Bar chart:Comparing categories'], 'Choosing the right chart type is key to effective visualization.'),
            ]),
      ],
      now: now,
    ),
    _buildCourse(
      id: 'world_history_ancient',
      title: 'Ancient World History',
      description:
          'Journey through ancient civilizations — from Mesopotamia and Egypt to Greece and Rome. Understand how early societies shaped the modern world.',
      imageUrl: 'https://images.unsplash.com/photo-1564399580075-5dfe19c205f3?w=800',
      categoryIds: ['history'],
      sections: [
        _section('Mesopotamia: Cradle of Civilization', 'Explore the world\'s first cities and writing systems.',
            '**Mesopotamia** ("land between rivers") refers to the area between the Tigris and Euphrates rivers in modern-day Iraq.\n\n**Key achievements:**\n- **Writing:** Cuneiform, one of the earliest writing systems (c. 3400 BCE)\n- **Code of Hammurabi:** One of the first written legal codes (c. 1754 BCE)\n- **Agriculture:** Irrigation systems enabled farming in arid regions\n- **Mathematics:** Base-60 number system (why we have 60 minutes/hour)\n- **The Wheel:** Invented c. 3500 BCE\n\n**Major civilizations:** Sumerians, Akkadians, Babylonians, Assyrians',
            exercises: [
              _mcq('What writing system did Mesopotamians use?', ['Hieroglyphics', 'Cuneiform', 'Latin', 'Sanskrit'], ['Cuneiform'], 'Cuneiform was pressed into clay tablets with a stylus.'),
              _trueFalse('The Code of Hammurabi was one of the first written legal codes.', ['true'], 'Created by Babylonian king Hammurabi around 1754 BCE.'),
              _fillBlank('Mesopotamia means "land between _____".', ['rivers'], 'The Tigris and Euphrates rivers.'),
              _mcq('Which number system did Mesopotamians use?', ['Base-10', 'Base-2', 'Base-60', 'Base-16'], ['Base-60'], 'This is why we have 60 seconds in a minute.'),
            ]),
        _section('Ancient Egypt', 'Understand the pharaohs, pyramids, and the Nile civilization.',
            '**Ancient Egypt** flourished along the Nile River for over 3,000 years.\n\n**Key features:**\n- **The Nile:** Annual flooding provided fertile soil for agriculture\n- **Pharaohs:** God-kings who ruled with absolute power\n- **Pyramids:** Monumental tombs built for pharaohs (Great Pyramid c. 2560 BCE)\n- **Hieroglyphics:** Pictographic writing system with over 700 symbols\n- **Mummification:** Preservation of bodies for the afterlife\n\n**Notable pharaohs:**\n- Khufu: Built the Great Pyramid of Giza\n- Hatshepsut: One of the few female pharaohs\n- Tutankhamun: Famous for his intact tomb discovered in 1922\n- Cleopatra VII: Last active ruler of the Ptolemaic Kingdom',
            exercises: [
              _fillBlank('The Great Pyramid was built for Pharaoh _____.', ['Khufu'], 'Khufu (also known as Cheops) commissioned the Great Pyramid.'),
              _mcq('What was the Nile\'s annual flooding important for?', ['Defense', 'Transportation only', 'Fertile soil for agriculture', 'Gold mining'], ['Fertile soil for agriculture'], 'The flooding deposited nutrient-rich silt on farmland.'),
              _trueFalse('Hieroglyphics used over 700 symbols.', ['true'], 'The system included both phonetic and logographic elements.'),
              _openEnded('Why was mummification important to ancient Egyptians?', ['preservation for the afterlife', 'believed the body was needed in the afterlife'], 'Egyptians believed the preserved body would be used in the afterlife.'),
            ]),
        _section('Classical Greece', 'Discover democracy, philosophy, and the legacy of ancient Greece.',
            '**Ancient Greece** (c. 800-31 BCE) laid the foundations for Western civilization.\n\n**Key contributions:**\n- **Democracy:** Athens developed the first direct democracy (c. 508 BCE)\n- **Philosophy:** Socrates, Plato, Aristotle shaped Western thought\n- **Olympics:** First held in 776 BCE at Olympia\n- **Theater:** Tragedy and comedy originated in Greek festivals\n- **Architecture:** The Parthenon, Doric/Ionic/Corinthian columns\n\n**Major conflicts:**\n- Persian Wars (490-479 BCE): Greek city-states vs. Persian Empire\n- Peloponnesian War (431-404 BCE): Athens vs. Sparta\n\n**Alexander the Great** (356-323 BCE) conquered from Greece to India, spreading Hellenistic culture.',
            exercises: [
              _mcq('Which city-state developed the first democracy?', ['Sparta', 'Athens', 'Thebes', 'Corinth'], ['Athens'], 'Athenian democracy was established around 508 BCE.'),
              _fillBlank('The three great Greek philosophers were Socrates, Plato, and _____.', ['Aristotle'], 'Aristotle was Plato\'s student and tutored Alexander the Great.'),
              _trueFalse('The first Olympic Games were held in 776 BCE.', ['true'], 'The games were held at Olympia in honor of Zeus.'),
              _matching('Match the philosopher to their contribution.', ['Socrates:Socratic method of questioning', 'Plato:Theory of Forms', 'Aristotle:Logic and empiricism'], 'Each built on their teacher\'s work.'),
            ]),
      ],
      now: now,
    ),
    _buildCourse(
      id: 'digital_art_basics',
      title: 'Digital Art Fundamentals',
      description:
          'Learn the principles of digital art — from color theory and composition to working with layers and brushes. No prior art experience required.',
      imageUrl: 'https://images.unsplash.com/photo-1561998338-13ad7883b20f?w=800',
      categoryIds: ['arts'],
      sections: [
        _section('Color Theory', 'Understand the color wheel, harmonies, and how colors work together.',
            '**Color theory** is the science and art of using color effectively.\n\n**The Color Wheel:**\n- **Primary colors:** Red, Blue, Yellow (cannot be mixed from other colors)\n- **Secondary colors:** Green, Orange, Purple (mixing two primaries)\n- **Tertiary colors:** Red-Orange, Blue-Green, etc. (mixing primary + secondary)\n\n**Color Harmonies:**\n- **Complementary:** Opposite on the wheel (red/green) — high contrast\n- **Analogous:** Adjacent on the wheel (blue/blue-green/green) — harmonious\n- **Triadic:** Evenly spaced (red/yellow/blue) — vibrant\n\n**Color Properties:**\n- Hue: The color itself\n- Saturation: Intensity/purity of color\n- Value: Lightness or darkness',
            exercises: [
              _mcq('Which are the three primary colors?', ['Red, Green, Blue', 'Red, Blue, Yellow', 'Cyan, Magenta, Yellow', 'Red, Orange, Purple'], ['Red, Blue, Yellow'], 'In traditional color theory, primaries are red, blue, and yellow.'),
              _fillBlank('Colors opposite each other on the color wheel are called _____ colors.', ['complementary'], 'Complementary colors create high contrast.'),
              _trueFalse('Saturation refers to how light or dark a color is.', ['false'], 'Saturation is intensity; value is lightness/darkness.'),
              _matching('Match the color property to its definition.', ['Hue:The color itself', 'Saturation:Intensity of color', 'Value:Lightness or darkness'], 'These three properties define any color.'),
            ]),
        _section('Composition Basics', 'Learn to arrange visual elements for impact.',
            '**Composition** is the arrangement of elements within an artwork.\n\n**Rule of Thirds:** Divide the frame into a 3x3 grid. Place key elements along the lines or at intersections for a balanced, dynamic composition.\n\n**Leading Lines:** Use lines (roads, rivers, edges) to guide the viewer\'s eye through the image.\n\n**Balance:**\n- **Symmetrical:** Equal weight on both sides — formal, stable\n- **Asymmetrical:** Unequal but balanced — dynamic, interesting\n\n**Negative Space:** The empty area around subjects. More negative space creates emphasis and breathing room.\n\n**Focal Point:** Every good composition has a clear focal point that draws the eye first.',
            exercises: [
              _mcq('What does the Rule of Thirds involve?', ['Dividing the frame into 3 equal parts', 'Using 3 colors only', 'A 3x3 grid placement', 'Three focal points'], ['A 3x3 grid placement'], 'Place subjects at grid intersections for dynamic composition.'),
              _fillBlank('The empty space around a subject is called _____ space.', ['negative'], 'Negative space gives the subject room to breathe.'),
              _trueFalse('Symmetrical balance creates a more dynamic composition than asymmetrical.', ['false'], 'Asymmetrical balance is more dynamic and visually interesting.'),
            ]),
        _section('Working with Layers', 'Master digital layers for non-destructive editing.',
            '**Layers** are one of the most powerful tools in digital art.\n\n**What are layers?**\nThink of layers as transparent sheets stacked on top of each other. Each layer can contain different elements, and you can edit one layer without affecting others.\n\n**Key concepts:**\n- **Layer order:** Top layers cover bottom layers\n- **Opacity:** Transparency of a layer (0% invisible, 100% fully visible)\n- **Blending modes:** How layers interact (Multiply, Screen, Overlay, etc.)\n- **Layer groups:** Organize related layers into folders\n- **Clipping masks:** Restrict painting to the content of the layer below\n\n**Best practices:**\n- Keep separate layers for sketch, line art, colors, shadows, highlights\n- Name your layers\n- Use adjustment layers for non-destructive edits',
            exercises: [
              _trueFalse('Layers in digital art are like transparent sheets stacked together.', ['true'], 'Each layer can be edited independently.'),
              _fillBlank('Layer _____ controls how transparent a layer is.', ['opacity'], 'Opacity ranges from 0% (invisible) to 100% (fully visible).'),
              _mcq('What do blending modes control?', ['Layer size', 'How layers interact visually', 'Layer name', 'Layer position'], ['How layers interact visually'], 'Blending modes determine how pixels on different layers combine.'),
              _openEnded('Why is it good practice to keep separate layers for different elements?', ['non-destructive editing', 'can edit one element without affecting others'], 'Separate layers allow independent editing of each element.'),
            ]),
      ],
      now: now,
    ),
    _buildCourse(
      id: 'flutter_mobile_dev',
      title: 'Flutter Mobile Development',
      description:
          'Build beautiful cross-platform mobile apps with Flutter and Dart. Learn widgets, state management, and Firebase integration from the ground up.',
      imageUrl: 'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=800',
      categoryIds: ['technology', 'engineering'],
      sections: [
        _section('Dart Language Basics', 'Learn the fundamentals of Dart, Flutter\'s programming language.',
            '**Dart** is a modern, object-oriented language developed by Google.\n\n**Variables:**\n```dart\nString name = "Alice";\nint age = 25;\ndouble height = 5.6;\nbool isStudent = true;\nvar autoType = "inferred"; // Type inferred\nfinal constant = "can\'t change";\n```\n\n**Functions:**\n```dart\nint add(int a, int b) {\n  return a + b;\n}\n\n// Arrow syntax for one-liners\nint multiply(int a, int b) => a * b;\n```\n\n**Null safety:** Dart uses `?` for nullable types:\n```dart\nString? nullableName; // Can be null\nString nonNullable = "always has value";\n```',
            exercises: [
              _mcq('Which keyword creates an immutable variable in Dart?', ['var', 'let', 'final', 'mutable'], ['final'], 'final variables can only be set once.'),
              _fillBlank('In Dart, a nullable String is declared as String_____.', ['?'], 'The ? suffix indicates the value can be null.'),
              _trueFalse('Dart is developed by Google.', ['true'], 'Dart was created by Google and is used by Flutter.'),
              _mcq('What does the => syntax do in Dart?', ['Creates a class', 'Shorthand for single-expression functions', 'Declares a variable', 'Imports a library'], ['Shorthand for single-expression functions'], 'Arrow functions are concise for one-liners.'),
            ]),
        _section('Flutter Widgets', 'Understand the widget tree and build UIs with Flutter.',
            '**Everything in Flutter is a widget.** Widgets describe what the UI should look like.\n\n**Two types:**\n- **StatelessWidget:** Immutable, no internal state\n- **StatefulWidget:** Mutable, can rebuild when state changes\n\n**Common widgets:**\n```dart\nText("Hello")\nContainer(color: Colors.blue, child: Text("Box"))\nColumn(children: [Text("A"), Text("B")])\nRow(children: [Icon(Icons.star), Text("Star")])\nListView.builder(itemBuilder: (ctx, i) => Text("Item \$i"))\n```\n\n**Layout widgets:** Column (vertical), Row (horizontal), Stack (overlapping), Padding, Center, Expanded, SizedBox.\n\n**Key principle:** Build complex UIs by composing simple widgets.',
            exercises: [
              _trueFalse('Everything in Flutter is a widget.', ['true'], 'Widgets are the building blocks of Flutter UIs.'),
              _mcq('When should you use StatefulWidget?', ['Always', 'When the widget has mutable state', 'Only for buttons', 'Never'], ['When the widget has mutable state'], 'Use StatefulWidget when the UI needs to change dynamically.'),
              _fillBlank('A _____ arranges children vertically in Flutter.', ['Column'], 'Column is the vertical layout widget; Row is horizontal.'),
              _matching('Match the widget to its purpose.', ['Text:Display text', 'Container:Box with styling', 'ListView:Scrollable list'], 'These are fundamental Flutter widgets.'),
            ]),
        _section('State Management with Riverpod', 'Manage app state reactively using Riverpod.',
            '**Riverpod** is a reactive state management solution for Flutter.\n\n**Setup:** Wrap your app with ProviderScope:\n```dart\nvoid main() {\n  runApp(ProviderScope(child: MyApp()));\n}\n```\n\n**Creating providers:**\n```dart\n@riverpod\nString greeting(GreetingRef ref) {\n  return "Hello, World!";\n}\n```\n\n**Consuming providers:**\n```dart\nclass MyWidget extends ConsumerWidget {\n  Widget build(BuildContext context, WidgetRef ref) {\n    final greeting = ref.watch(greetingProvider);\n    return Text(greeting);\n  }\n}\n```\n\n**Key concepts:**\n- `ref.watch()`: Rebuilds when the provider changes\n- `ref.read()`: One-time read (use in callbacks)\n- `AsyncNotifier`: For async state with loading/error handling',
            exercises: [
              _fillBlank('To make providers available, wrap your app with _____.', ['ProviderScope'], 'ProviderScope initializes Riverpod for the widget tree.'),
              _mcq('What does ref.watch() do?', ['Reads once', 'Rebuilds widget when provider changes', 'Deletes the provider', 'Creates a new provider'], ['Rebuilds widget when provider changes'], 'watch() subscribes to changes and triggers rebuilds.'),
              _trueFalse('ref.read() should be used in build methods.', ['false'], 'Use ref.watch() in build; ref.read() in callbacks/event handlers.'),
              _openEnded('What is the difference between ref.watch() and ref.read()?', ['watch rebuilds on changes', 'read is for one-time access'], 'watch() subscribes to changes; read() is for one-shot access.'),
            ]),
        _section('Firebase Integration', 'Connect your Flutter app to Firebase for auth and data.',
            '**Firebase** provides backend services for mobile apps.\n\n**Setup:**\n1. Create a Firebase project at console.firebase.google.com\n2. Run `flutterfire configure` to generate config\n3. Initialize in main.dart:\n```dart\nawait Firebase.initializeApp(\n  options: DefaultFirebaseOptions.currentPlatform,\n);\n```\n\n**Firestore (database):**\n```dart\n// Write\nawait FirebaseFirestore.instance.collection("users").add({"name": "Alice"});\n\n// Read\nfinal snapshot = await FirebaseFirestore.instance.collection("users").get();\n\n// Real-time\nFirebaseFirestore.instance.collection("users").snapshots().listen((s) { });\n```\n\n**Firebase Auth:**\n```dart\nawait FirebaseAuth.instance.signInWithEmailAndPassword(\n  email: email, password: password,\n);\n```',
            exercises: [
              _mcq('What command generates Firebase config for Flutter?', ['firebase init', 'flutterfire configure', 'dart firebase setup', 'flutter create firebase'], ['flutterfire configure'], 'flutterfire configure generates platform-specific config files.'),
              _fillBlank('To listen to real-time Firestore changes, use the _____ method.', ['snapshots'], 'snapshots() returns a Stream of query snapshots.'),
              _trueFalse('Firebase Auth only supports email/password login.', ['false'], 'Firebase Auth supports Google, Apple, phone, and many other providers.'),
            ]),
      ],
      now: now,
    ),
    _buildCourse(
      id: 'intro_to_algorithms',
      title: 'Introduction to Algorithms',
      description:
          'Understand essential algorithms and data structures — sorting, searching, trees, and graphs. Learn to analyze time complexity with Big-O notation.',
      imageUrl: 'https://images.unsplash.com/photo-1509228468518-180dd4864904?w=800',
      categoryIds: ['technology', 'engineering'],
      sections: [
        _section('Big-O Notation', 'Learn to analyze algorithm efficiency with Big-O.',
            '**Big-O notation** describes the upper bound of an algorithm\'s time complexity.\n\n**Common complexities (best to worst):**\n- O(1) — Constant: array access by index\n- O(log n) — Logarithmic: binary search\n- O(n) — Linear: iterate through an array\n- O(n log n) — Linearithmic: merge sort, quick sort\n- O(n²) — Quadratic: nested loops, bubble sort\n- O(2ⁿ) — Exponential: recursive Fibonacci\n\n**Rules:**\n1. Drop constants: O(2n) → O(n)\n2. Drop lower-order terms: O(n² + n) → O(n²)\n3. Consider worst case by default\n\n**Why it matters:** An O(n²) algorithm on 1 million items takes ~1 trillion operations vs ~20 million for O(n log n).',
            exercises: [
              _mcq('What is the Big-O of accessing an array element by index?', ['O(n)', 'O(1)', 'O(log n)', 'O(n²)'], ['O(1)'], 'Array access by index is constant time.'),
              _fillBlank('Binary search has a time complexity of O(_____ n).', ['log'], 'Binary search halves the search space each step.'),
              _trueFalse('O(n²) is more efficient than O(n log n).', ['false'], 'n² grows much faster than n log n.'),
              _mcq('What complexity does bubble sort have?', ['O(n)', 'O(n log n)', 'O(n²)', 'O(1)'], ['O(n²)'], 'Bubble sort uses nested loops to compare adjacent elements.'),
            ]),
        _section('Sorting Algorithms', 'Compare bubble sort, merge sort, and quick sort.',
            '**Sorting** is arranging elements in a specific order.\n\n**Bubble Sort — O(n²):**\nRepeatedly swap adjacent elements if they are in wrong order.\nSimple but slow for large datasets.\n\n**Merge Sort — O(n log n):**\nDivide and conquer:\n1. Split array in half recursively\n2. Sort each half\n3. Merge sorted halves back together\nConsistent performance, but uses extra memory.\n\n**Quick Sort — O(n log n) average:**\n1. Choose a pivot element\n2. Partition: elements < pivot go left, elements > pivot go right\n3. Recursively sort left and right partitions\nFast in practice, but worst case is O(n²) with poor pivot choices.',
            exercises: [
              _mcq('Which sorting algorithm uses divide and conquer?', ['Bubble Sort', 'Selection Sort', 'Merge Sort', 'Insertion Sort'], ['Merge Sort'], 'Merge sort splits, sorts halves, then merges.'),
              _trueFalse('Quick sort has a worst-case time complexity of O(n²).', ['true'], 'Poor pivot choices can degrade to O(n²).'),
              _fillBlank('Merge sort has a time complexity of O(n _____ n).', ['log'], 'O(n log n) for all cases.'),
              _openEnded('Why might you choose merge sort over quick sort?', ['guaranteed O(n log n)', 'consistent performance', 'stable sort'], 'Merge sort guarantees O(n log n) in all cases, while quick sort can degrade.'),
            ]),
        _section('Searching Algorithms', 'Master linear search and binary search with trade-offs.',
            '**Linear Search — O(n):**\nCheck each element one by one until the target is found.\n```\n[4, 2, 7, 1, 9] → find 7 → check 4, 2, 7 ✓ (3 comparisons)\n```\nWorks on any list (sorted or unsorted).\n\n**Binary Search — O(log n):**\nRequires a sorted array. Repeatedly divide the search space in half.\n```\n[1, 2, 4, 7, 9] → find 7\nMiddle = 4, 7 > 4 → search right half [7, 9]\nMiddle = 7 ✓ (2 comparisons)\n```\n\n**Trade-offs:**\n- Linear search: Simple, works on unsorted data, O(n)\n- Binary search: Faster, but requires sorted data, O(log n)\n- For small datasets, linear search can be faster due to simplicity\n- Sorting first + binary search is worth it for repeated searches',
            exercises: [
              _mcq('What is required for binary search to work?', ['Unsorted array', 'Sorted array', 'Linked list', 'Hash table'], ['Sorted array'], 'Binary search needs elements in order to halve the search space.'),
              _fillBlank('Linear search checks each element _____ by one.', ['one'], 'It sequentially scans until finding the target.'),
              _trueFalse('Binary search is always faster than linear search.', ['false'], 'For very small datasets, linear search can be faster due to simplicity.'),
              _matching('Match the search to its complexity.', ['Linear search:O(n)', 'Binary search:O(log n)'], 'Binary search is exponentially faster for large datasets.'),
            ]),
      ],
      now: now,
    ),
  ];

  for (final course in courses) {
    final courseId = course['id'] as String;
    final sections = course['sections'] as List<Map<String, dynamic>>;
    final courseData = Map<String, dynamic>.from(course);
    courseData.remove('sections');
    courseData.remove('id');

    await db.collection('courses').doc(courseId).set(courseData);
    print('  Created course: ${course['title']}');

    for (var i = 0; i < sections.length; i++) {
      final section = sections[i];
      final exercises = section['exercises'] as List<Map<String, dynamic>>;
      final sectionData = Map<String, dynamic>.from(section);
      sectionData.remove('exercises');
      sectionData['order'] = i + 1;
      sectionData['isFreePreview'] = i == 0;

      final sectionRef = db
          .collection('courses')
          .doc(courseId)
          .collection('sections')
          .doc('section_${i + 1}');

      await sectionRef.set(sectionData);

      for (var j = 0; j < exercises.length; j++) {
        final exercise = Map<String, dynamic>.from(exercises[j]);
        exercise['order'] = j + 1;
        await sectionRef
            .collection('exercises')
            .doc('exercise_${j + 1}')
            .set(exercise);
      }
    }
  }

  print('  Created ${courses.length} courses with sections and exercises');
}

// ─── Users ──────────────────────────────────────────────

Future<void> _seedUsers(FirebaseFirestore db) async {
  final now = Timestamp.now();

  final users = [
    {'uid': 'user_01', 'displayName': 'Alex Johnson', 'email': 'alex.johnson@example.com'},
    {'uid': 'user_02', 'displayName': 'Maria Garcia', 'email': 'maria.garcia@example.com'},
    {'uid': 'user_03', 'displayName': 'James Chen', 'email': 'james.chen@example.com'},
    {'uid': 'user_04', 'displayName': 'Sofia Müller', 'email': 'sofia.muller@example.com'},
    {'uid': 'user_05', 'displayName': "Liam O'Brien", 'email': 'liam.obrien@example.com'},
    {'uid': 'user_06', 'displayName': 'Yuki Tanaka', 'email': 'yuki.tanaka@example.com'},
    {'uid': 'user_07', 'displayName': 'Priya Patel', 'email': 'priya.patel@example.com'},
    {'uid': 'user_08', 'displayName': 'Noah Williams', 'email': 'noah.williams@example.com'},
    {'uid': 'user_09', 'displayName': 'Emma Davis', 'email': 'emma.davis@example.com'},
    {'uid': 'user_10', 'displayName': 'Lucas Martin', 'email': 'lucas.martin@example.com'},
    {'uid': 'user_11', 'displayName': 'Aisha Khan', 'email': 'aisha.khan@example.com'},
    {'uid': 'user_12', 'displayName': 'Daniel Kim', 'email': 'daniel.kim@example.com'},
    {'uid': 'user_13', 'displayName': 'Olivia Brown', 'email': 'olivia.brown@example.com'},
    {'uid': 'user_14', 'displayName': 'Ethan Lee', 'email': 'ethan.lee@example.com'},
    {'uid': 'user_15', 'displayName': 'Fatima Ali', 'email': 'fatima.ali@example.com'},
  ];

  final batch = db.batch();
  for (final user in users) {
    batch.set(db.collection('users').doc(user['uid'] as String), {
      'username': (user['displayName'] as String).toLowerCase().replaceAll(' ', '_'),
      'email': user['email'],
      'displayName': user['displayName'],
      'photoUrl': null,
      'createdAt': now,
      'role': 'user',
    });
  }
  await batch.commit();
  print('  Created ${users.length} users');
}

// ─── Enrollments, Ratings, Reviews ──────────────────────

Future<void> _seedEnrollmentsAndReviews(FirebaseFirestore db) async {
  final sectionCounts = <String, int>{
    'intro_to_physics': 3, 'intro_to_biology': 3, 'spanish_basics': 3,
    'japanese_basics': 3, 'web_development': 3, 'data_science_python': 3,
    'world_history_ancient': 3, 'digital_art_basics': 3,
    'flutter_mobile_dev': 3, 'intro_to_algorithms': 3,
  };

  final enrollments = <Map<String, dynamic>>[
    {'userId': 'user_01', 'courseId': 'intro_to_physics', 'completed': [1, 2, 3], 'rating': 5},
    {'userId': 'user_01', 'courseId': 'web_development', 'completed': [1, 2], 'rating': 4},
    {'userId': 'user_01', 'courseId': 'intro_to_algorithms', 'completed': [1], 'rating': 0},
    {'userId': 'user_02', 'courseId': 'spanish_basics', 'completed': [1, 2, 3], 'rating': 5},
    {'userId': 'user_02', 'courseId': 'intro_to_biology', 'completed': [1, 2], 'rating': 4},
    {'userId': 'user_02', 'courseId': 'japanese_basics', 'completed': [1], 'rating': 3},
    {'userId': 'user_03', 'courseId': 'data_science_python', 'completed': [1, 2, 3], 'rating': 5},
    {'userId': 'user_03', 'courseId': 'flutter_mobile_dev', 'completed': [1, 2], 'rating': 4},
    {'userId': 'user_03', 'courseId': 'intro_to_algorithms', 'completed': [1, 2, 3], 'rating': 5},
    {'userId': 'user_04', 'courseId': 'digital_art_basics', 'completed': [1, 2, 3], 'rating': 5},
    {'userId': 'user_04', 'courseId': 'world_history_ancient', 'completed': [1], 'rating': 3},
    {'userId': 'user_04', 'courseId': 'spanish_basics', 'completed': [1, 2], 'rating': 4},
    {'userId': 'user_05', 'courseId': 'intro_to_physics', 'completed': [1, 2], 'rating': 4},
    {'userId': 'user_05', 'courseId': 'intro_to_biology', 'completed': [1, 2, 3], 'rating': 5},
    {'userId': 'user_05', 'courseId': 'web_development', 'completed': [1, 2, 3], 'rating': 5},
    {'userId': 'user_06', 'courseId': 'japanese_basics', 'completed': [1, 2, 3], 'rating': 5},
    {'userId': 'user_06', 'courseId': 'flutter_mobile_dev', 'completed': [1], 'rating': 3},
    {'userId': 'user_06', 'courseId': 'data_science_python', 'completed': [1, 2], 'rating': 4},
    {'userId': 'user_07', 'courseId': 'intro_to_algorithms', 'completed': [1, 2], 'rating': 4},
    {'userId': 'user_07', 'courseId': 'intro_to_physics', 'completed': [1], 'rating': 3},
    {'userId': 'user_07', 'courseId': 'world_history_ancient', 'completed': [1, 2, 3], 'rating': 4},
    {'userId': 'user_08', 'courseId': 'web_development', 'completed': [1, 2, 3], 'rating': 4},
    {'userId': 'user_08', 'courseId': 'flutter_mobile_dev', 'completed': [1, 2, 3], 'rating': 5},
    {'userId': 'user_08', 'courseId': 'digital_art_basics', 'completed': [1], 'rating': 0},
    {'userId': 'user_09', 'courseId': 'spanish_basics', 'completed': [1, 2], 'rating': 4},
    {'userId': 'user_09', 'courseId': 'intro_to_biology', 'completed': [1], 'rating': 3},
    {'userId': 'user_09', 'courseId': 'data_science_python', 'completed': [1, 2, 3], 'rating': 5},
    {'userId': 'user_10', 'courseId': 'world_history_ancient', 'completed': [1, 2], 'rating': 4},
    {'userId': 'user_10', 'courseId': 'japanese_basics', 'completed': [1, 2], 'rating': 4},
    {'userId': 'user_10', 'courseId': 'intro_to_physics', 'completed': [1, 2, 3], 'rating': 4},
    {'userId': 'user_11', 'courseId': 'digital_art_basics', 'completed': [1, 2], 'rating': 5},
    {'userId': 'user_11', 'courseId': 'flutter_mobile_dev', 'completed': [1, 2], 'rating': 4},
    {'userId': 'user_11', 'courseId': 'spanish_basics', 'completed': [1], 'rating': 0},
    {'userId': 'user_12', 'courseId': 'intro_to_algorithms', 'completed': [1, 2, 3], 'rating': 4},
    {'userId': 'user_12', 'courseId': 'intro_to_physics', 'completed': [1], 'rating': 3},
    {'userId': 'user_12', 'courseId': 'data_science_python', 'completed': [1], 'rating': 0},
    {'userId': 'user_13', 'courseId': 'intro_to_biology', 'completed': [1, 2, 3], 'rating': 5},
    {'userId': 'user_13', 'courseId': 'web_development', 'completed': [1], 'rating': 3},
    {'userId': 'user_13', 'courseId': 'world_history_ancient', 'completed': [1, 2], 'rating': 4},
    {'userId': 'user_14', 'courseId': 'japanese_basics', 'completed': [1, 2, 3], 'rating': 4},
    {'userId': 'user_14', 'courseId': 'flutter_mobile_dev', 'completed': [1, 2, 3], 'rating': 5},
    {'userId': 'user_14', 'courseId': 'digital_art_basics', 'completed': [1, 2, 3], 'rating': 4},
    {'userId': 'user_15', 'courseId': 'web_development', 'completed': [1, 2], 'rating': 4},
    {'userId': 'user_15', 'courseId': 'intro_to_biology', 'completed': [1, 2], 'rating': 4},
    {'userId': 'user_15', 'courseId': 'intro_to_algorithms', 'completed': [1], 'rating': 3},
  ];

  final userNames = <String, String>{
    'user_01': 'Alex Johnson', 'user_02': 'Maria Garcia', 'user_03': 'James Chen',
    'user_04': 'Sofia Müller', 'user_05': "Liam O'Brien", 'user_06': 'Yuki Tanaka',
    'user_07': 'Priya Patel', 'user_08': 'Noah Williams', 'user_09': 'Emma Davis',
    'user_10': 'Lucas Martin', 'user_11': 'Aisha Khan', 'user_12': 'Daniel Kim',
    'user_13': 'Olivia Brown', 'user_14': 'Ethan Lee', 'user_15': 'Fatima Ali',
  };

  final reviewTexts = [
    'Great course! Very clear explanations and helpful exercises.',
    'Excellent content, learned a lot in a short time.',
    'Good material but could use more practice exercises.',
    'Well structured and easy to follow. Highly recommend!',
    'The examples are very practical and relevant.',
    'Solid introduction to the topic. Looking forward to advanced content.',
    'Really enjoyed the interactive exercises. Made learning fun!',
    'Content is good but some sections feel a bit rushed.',
    'Perfect for beginners. Covers all the fundamentals.',
    "One of the best courses I've taken on this platform.",
    'Clear, concise, and well-organized. Great job!',
    'The explanations are easy to understand. Very helpful.',
    'Good course overall. A few more examples would be nice.',
    'Loved the hands-on approach. Very engaging content.',
    'Comprehensive coverage of the basics. Well done!',
  ];

  final now = DateTime.now();
  int enrollmentCount = 0;
  int reviewCount = 0;

  final courseRatings = <String, List<int>>{};

  for (final e in enrollments) {
    final userId = e['userId'] as String;
    final courseId = e['courseId'] as String;
    final completed = e['completed'] as List<int>;
    final rating = e['rating'] as int;
    final total = sectionCounts[courseId] ?? 3;
    final percentage = completed.length / total;
    final docId = '${userId}_$courseId';

    final enrolledAt = now.subtract(Duration(days: 30 + enrollmentCount * 2));
    await db.collection('enrollments').doc(docId).set({
      'userId': userId,
      'courseId': courseId,
      'enrolledAt': Timestamp.fromDate(enrolledAt),
      'lastAccessedAt': Timestamp.fromDate(now.subtract(Duration(days: enrollmentCount % 7))),
      'currentSectionOrder': completed.length < total ? completed.length + 1 : total,
      'completedSections': completed,
      'completionPercentage': percentage,
      'rating': rating,
    });
    enrollmentCount++;

    if (rating > 0) {
      courseRatings.putIfAbsent(courseId, () => []);
      courseRatings[courseId]!.add(rating);
    }

    // Add review for ~70% of rated enrollments
    if (rating > 0 && (enrollmentCount % 10 != 3 && enrollmentCount % 10 != 7)) {
      final reviewText = reviewTexts[(enrollmentCount * 7 + rating) % reviewTexts.length];
      final reviewDate = enrolledAt.add(const Duration(days: 5));
      await db
          .collection('courses')
          .doc(courseId)
          .collection('reviews')
          .doc(docId)
          .set({
        'userId': userId,
        'courseId': courseId,
        'displayName': userNames[userId],
        'rating': rating,
        'text': reviewText,
        'createdAt': Timestamp.fromDate(reviewDate),
        'updatedAt': Timestamp.fromDate(reviewDate),
      });
      reviewCount++;
    }
  }

  // Update course enrollment counts and average ratings
  final courseEnrollmentCounts = <String, int>{};
  for (final e in enrollments) {
    final courseId = e['courseId'] as String;
    courseEnrollmentCounts[courseId] = (courseEnrollmentCounts[courseId] ?? 0) + 1;
  }

  for (final courseId in courseEnrollmentCounts.keys) {
    final ratings = courseRatings[courseId] ?? [];
    final avgRating = ratings.isNotEmpty
        ? ratings.reduce((a, b) => a + b) / ratings.length
        : 0.0;
    await db.collection('courses').doc(courseId).update({
      'enrollmentCount': courseEnrollmentCounts[courseId],
      'averageRating': avgRating,
      'ratingCount': ratings.length,
    });
  }

  print('  Created $enrollmentCount enrollments and $reviewCount reviews');
}

// ─── Admin Setup ────────────────────────────────────────

Future<void> _setupAdmin(FirebaseFirestore db) async {
  stdout.write('Enter your Firebase Auth UID to set as admin (or press Enter to skip): ');
  final uid = stdin.readLineSync()?.trim();

  if (uid == null || uid.isEmpty) {
    print('  Skipped admin setup.');
    return;
  }

  final doc = await db.collection('users').doc(uid).get();
  if (doc.exists) {
    await db.collection('users').doc(uid).update({'role': 'admin'});
    print('  Updated existing user $uid to admin role.');
  } else {
    await db.collection('users').doc(uid).set({
      'username': 'admin',
      'email': 'admin@deeplearn.app',
      'displayName': 'Admin',
      'photoUrl': null,
      'createdAt': Timestamp.now(),
      'role': 'admin',
    });
    print('  Created admin user $uid.');
  }
}

// ─── Helpers ─────────────────────────────────────────────────

Map<String, dynamic> _buildCourse({
  required String id,
  required String title,
  required String description,
  required String imageUrl,
  required List<String> categoryIds,
  required List<Map<String, dynamic>> sections,
  required DateTime now,
}) {
  return {
    'id': id,
    'title': title,
    'titleLower': title.toLowerCase(),
    'description': description,
    'imageUrl': imageUrl,
    'categoryIds': categoryIds,
    'totalSections': sections.length,
    'createdAt': Timestamp.fromDate(now.subtract(Duration(days: sections.length))),
    'updatedAt': Timestamp.fromDate(now),
    'enrollmentCount': 0,
    'sections': sections,
  };
}

Map<String, dynamic> _section(
  String title,
  String summary,
  String content, {
  required List<Map<String, dynamic>> exercises,
}) {
  return {
    'title': title,
    'summary': summary,
    'content': content,
    'imageUrls': <String>[],
    'exercises': exercises,
  };
}

Map<String, dynamic> _mcq(
    String question, List<String> options, List<String> correct, String explanation) {
  return {
    'type': 'mcq',
    'question': question,
    'options': options,
    'correctAnswer': correct,
    'explanation': explanation,
  };
}

Map<String, dynamic> _trueFalse(
    String question, List<String> correct, String explanation) {
  return {
    'type': 'trueFalse',
    'question': question,
    'options': ['true', 'false'],
    'correctAnswer': correct,
    'explanation': explanation,
  };
}

Map<String, dynamic> _fillBlank(
    String question, List<String> correct, String explanation) {
  return {
    'type': 'fillBlank',
    'question': question,
    'options': <String>[],
    'correctAnswer': correct,
    'explanation': explanation,
  };
}

Map<String, dynamic> _matching(
    String question, List<String> pairs, String explanation) {
  return {
    'type': 'matching',
    'question': question,
    'options': pairs,
    'correctAnswer': pairs,
    'explanation': explanation,
  };
}

Map<String, dynamic> _openEnded(
    String question, List<String> acceptableAnswers, String explanation) {
  return {
    'type': 'openEnded',
    'question': question,
    'options': <String>[],
    'correctAnswer': acceptableAnswers,
    'explanation': explanation,
  };
}
