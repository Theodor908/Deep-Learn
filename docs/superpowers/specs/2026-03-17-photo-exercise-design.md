# Photo Exercise Feature — Design Spec

## Overview

Add a new "photo" exercise type to the Deep Learn app where users photograph real-world objects (starting with horticulture) and Gemini AI validates whether the photo matches the exercise criteria. Binary pass/fail with a 1-minute retry cooldown.

## Requirements

- **Exercise type:** `photo` added to existing `ExerciseType` enum
- **Validation:** Binary correct/incorrect via Gemini (Firebase AI Logic)
- **Retry policy:** Unlimited retries with 60-second cooldown on incorrect answers
- **Scoring:** Standalone — does not contribute to section score or SM-2 scheduling
- **Placement:** Listed alongside other exercises within a course section
- **Architecture:** Client-side direct (Approach A) — Flutter calls Gemini via `firebase_ai` SDK, no Cloud Functions

## Data Model Changes

### ExerciseType Enum

Add `photo` to the existing enum:

```dart
enum ExerciseType {
  mcq,
  fillBlank,
  trueFalse,
  matching,
  openEnded,
  photo,        // NEW
}
```

### Exercise Entity — New Fields

| Field | Type | Description |
|-------|------|-------------|
| `photoPrompt` | `String?` | Detailed Gemini instruction (admin-configurable, invisible to user). Null for non-photo types. |
| `retryCooldownSeconds` | `int?` | Cooldown between retries. Defaults to 60 if null. Only used for photo type. |

Existing fields reused:
- `question` — user-facing instruction ("Take a photo of a succulent plant")
- `correctAnswer` — keywords/criteria Gemini uses for validation (e.g., `["succulent", "thick fleshy leaves", "rosette shape"]`)
- `options` — unused (empty list) for photo type

### New Entity: PhotoValidationResult

```dart
class PhotoValidationResult {
  final bool isCorrect;
  final String rawResponse;  // Gemini's full text (for debugging)
}
```

## Gemini Integration

### Domain Layer

```dart
abstract class PhotoValidationRepository {
  Future<PhotoValidationResult> validatePhoto({
    required Uint8List imageBytes,
    required String mimeType,
    required String photoPrompt,
    required List<String> correctAnswer,
  });
}
```

### Data Layer Implementation

Wraps `firebase_ai` SDK:

1. Builds a structured prompt combining `photoPrompt` + `correctAnswer` keywords
2. Sends `Content.multi([TextPart(prompt), InlineDataPart(mimeType, imageBytes)])`
3. Parses response for `"CORRECT"` or `"INCORRECT"`
4. Returns `PhotoValidationResult`

### Prompt Template

```
You are an exercise validator for a horticulture learning app.
Task: {photoPrompt}
Criteria: The image should show: {correctAnswer joined by ", "}
Respond with ONLY the word "CORRECT" or "INCORRECT". Nothing else.
```

### Model Selection

Use `gemini-2.5-flash` (free tier: ~15 RPM, 1000 req/day). Sufficient for a learning app.

### Constraints

- Max request size: 20 MB
- Supported formats: JPEG, PNG, WebP
- Fallback: any non-"CORRECT" response is treated as incorrect (safe default)

## UI Flow

### PhotoExerciseWidget States

1. **Idle** — Shows question + camera button
2. **Capturing** — `image_picker` opens device camera (`ImageSource.camera`)
3. **Preview** — Shows captured photo + "Submit" / "Retake" buttons
4. **Validating** — Photo with loading spinner overlay
5. **Result: Correct** — Green checkmark, "Correct!" message, continue button
6. **Result: Incorrect** — Red X, "Incorrect" message, disabled retry button with countdown timer
7. **Cooldown expired** — Retry button re-enables

### Flow Diagram

```
Idle → [tap camera] → Capturing → [photo taken] → Preview
Preview → [tap submit] → Validating → Result
Preview → [tap retake] → Capturing

Result (incorrect) → [wait 60s] → Idle (retry)
Result (correct) → [tap continue] → next exercise or back to section
```

### Key Decisions

- Photo kept in memory as `Uint8List`, never persisted to storage
- Cooldown enforced client-side only (low stakes, no server enforcement needed)
- Widget is standalone — does not write to the section answer map

## Package Changes

| Package | Version | Purpose |
|---------|---------|---------|
| `firebase_ai` | ^3.9.0 | Gemini API via Firebase AI Logic |
| `image_picker` | ^1.0.7 | Camera photo capture |

## Platform Configuration

- **Android:** `<uses-permission android:name="android.permission.CAMERA"/>` in AndroidManifest.xml
- **iOS:** `NSCameraUsageDescription` in Info.plist
- **Firebase Console:** Enable Firebase AI Logic (toggle, no billing change for free tier)

## File Changes

| Layer | File | Change |
|-------|------|--------|
| Domain | `features/courses/domain/entities/exercise.dart` | Add `photo` to enum, add `photoPrompt` and `retryCooldownSeconds` fields |
| Domain | `features/courses/domain/entities/photo_validation_result.dart` | New entity |
| Domain | `features/courses/domain/repositories/photo_validation_repository.dart` | New abstract class |
| Data | `features/courses/data/models/exercise_model.dart` | Update DTO for new fields |
| Data | `features/courses/data/datasources/gemini_photo_datasource.dart` | New — wraps `firebase_ai` |
| Data | `features/courses/data/repositories/photo_validation_repository_impl.dart` | New — implements abstract repo |
| Presentation | `features/courses/presentation/widgets/exercise_widgets/photo_exercise_widget.dart` | New — full UI flow |
| Presentation | `features/courses/presentation/providers/photo_validation_provider.dart` | New — Riverpod provider |
| Presentation | `features/courses/presentation/screens/exercise_screen.dart` | Add `case ExerciseType.photo` |
| Config | `android/app/src/main/AndroidManifest.xml` | Camera permission |
| Config | `ios/Runner/Info.plist` | Camera usage description |
| Config | `pubspec.yaml` | Add `firebase_ai`, `image_picker` |

## What's NOT Changing

- `exercise_scorer.dart` — photo exercises are standalone
- Practice/SM-2 system — no integration
- Enrollment tracking — unaffected
- Navigation/GoRouter — no new routes needed
- Admin dashboard — out of scope (exercises assumed seeded in Firestore)

## Sources

- [Firebase AI Logic Docs](https://firebase.google.com/docs/ai-logic)
- [Analyze Images with Firebase AI Logic](https://firebase.google.com/docs/ai-logic/analyze-images)
- [firebase_ai package (v3.9.0)](https://pub.dev/packages/firebase_ai)
- [image_picker package](https://pub.dev/packages/image_picker)
- [Gemini API Pricing](https://ai.google.dev/gemini-api/docs/pricing)
