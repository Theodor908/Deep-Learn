# Deep Learn

A Flutter mobile app for discovering, enrolling in, and practicing courses. Built with Firebase as the backend and featuring spaced repetition for long-term retention.

<img width="1920" height="1080" alt="1" src="https://github.com/user-attachments/assets/20354689-8bbb-4901-881e-1ae17f2535a1" />

<img width="1920" height="1080" alt="2" src="https://github.com/user-attachments/assets/ce3a5044-90f7-4904-97e9-86df29a52b3d" />

<img width="1920" height="1080" alt="3" src="https://github.com/user-attachments/assets/cba2d777-4b38-48b3-9226-4e30a8ba701f" />

<img width="1920" height="1080" alt="4" src="https://github.com/user-attachments/assets/bbe585ac-0210-44c7-ac16-76cfbdbbfdff" />


## Features

- Browse and search courses by category
- Enroll in courses and track progress through sections
- Multiple exercise types: MCQ, true/false, fill-in-the-blank, matching, open-ended, photo (AI-validated), and map-based
- Spaced repetition (SM-2 algorithm) for review scheduling
- Push notifications for review reminders
- Course recommendations via collaborative filtering
- Google Sign-In and email/password authentication
- Profile management with photo upload
- Admin dashboard for managing courses, sections, and exercises
- Course ratings and reviews

## Tech Stack

- **Flutter** (Dart SDK ^3.11.0)
- **Firebase** — Firestore, Auth, Storage, Messaging, Gemini AI
- **Riverpod** — state management (with code generation)
- **GoRouter** — navigation with bottom nav shell
- **Freezed** + **json_serializable** — immutable models
- **Google Maps** + **Geolocator** — map exercises

## Prerequisites

- Flutter SDK 3.11+
- A Firebase project with Firestore, Auth, Storage, and Messaging enabled
- Android Studio / Xcode for platform-specific builds
- A Google Maps API key (for map exercises)

## Getting Started

1. **Clone the repo**
   ```bash
   git clone <repo-url>
   cd "Deep Learn"
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase setup**

   The project uses FlutterFire CLI. If you need to reconfigure:
   ```bash
   flutterfire configure
   ```
   This generates `lib/firebase_options.dart` with your project's config.

4. **Run code generation** (for freezed models and riverpod providers)
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
  core/
    constants/        # App-wide constants and enums
    errors/           # Failure classes
    extensions/       # Dart/Flutter extensions
    services/         # NotificationService (FCM + local)
    theme/            # Colors, typography, theme data
    utils/            # SM-2 algorithm, exercise scorer, validators
    widgets/          # Shared widgets (CourseCard, CategoryChipBar, etc.)
  features/
    admin/            # Admin dashboard, course/section/exercise editors
    auth/             # Login, register, Google sign-in, profile photos
    courses/          # Course browsing, enrollment, exercises, reviews
    home/             # Home feed, enrolled courses, CTA banner
    practice/         # Spaced repetition review screen
    profile/          # User profile, settings, notification preferences
    search/           # Course and section search
  app.dart            # GoRouter config, bottom nav shell, MaterialApp
  main.dart           # Entry point (Firebase init, notifications, ProviderScope)

test/
  core/               # Unit tests for utils, algorithms
  features/           # Feature-level tests
```

Each feature follows **clean architecture** with three layers:
- `data/` — Firestore datasources, models (DTOs), repository implementations
- `domain/` — Entities, repository interfaces
- `presentation/` — Screens, widgets, Riverpod providers

## Running Tests

```bash
flutter test
```

## License

MIT License. See [LICENSE](LICENSE) for details.
