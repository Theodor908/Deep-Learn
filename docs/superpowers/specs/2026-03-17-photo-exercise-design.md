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
- `correctAnswer` — keywords/criteria passed to Gemini as validation criteria. Note: for photo type, these are NOT user-facing answers but Gemini prompt keywords (e.g., `["succulent", "thick fleshy leaves", "rosette shape"]`). This dual meaning is documented here and in the entity's code comments.
- `options` — unused (empty list) for photo type

### New Entity: PhotoValidationResult

Uses `@freezed` for consistency with all other domain entities:

```dart
@freezed
class PhotoValidationResult with _$PhotoValidationResult {
  const factory PhotoValidationResult({
    required bool isCorrect,
    required String rawResponse,  // Gemini's full text (for debugging)
  }) = _PhotoValidationResult;
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
2. **Compresses image** before sending: resize to max 1024px on longest side, JPEG quality 80%. This keeps requests well under the 20 MB limit regardless of device camera resolution.
3. Sends `Content.multi([TextPart(prompt), InlineDataPart(mimeType, imageBytes)])`
4. Parses response for `"CORRECT"` or `"INCORRECT"`
5. Returns `PhotoValidationResult`

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

- Max request size: 20 MB (mitigated by client-side compression)
- Supported formats: JPEG, PNG, WebP
- Fallback: any non-"CORRECT" response is treated as incorrect (safe default)

### Error Handling

| Scenario | User Experience |
|----------|---------------|
| Network error / timeout | Show "Validation failed. Check your connection and try again." with an immediate retry button (no cooldown). |
| Gemini rate limit (429) | Show "Too many requests. Please wait a moment and try again." with immediate retry. |
| Gemini service error (500) | Same as network error — generic failure message with retry. |
| Non-parseable response | Treated as incorrect (safe fallback). |

**Key distinction:** API/network failures show an **error state** with immediate retry. Only a definitive "INCORRECT" response triggers the 60-second cooldown. This prevents punishing users for infrastructure issues.

## Section Integration: Mixed Exercise Handling

### The Problem

The existing `ExerciseScreen` uses a collective submit model: all exercises must be answered before a single "Submit Answers" button is enabled. Photo exercises are standalone and don't write to the answer map, which would break the submit gate.

### The Solution

Photo exercises are **excluded from the section's submit gate and scoring denominator:**

1. `ExerciseScreen` filters photo exercises out when calculating:
   - Progress bar total (denominator)
   - "Submit Answers" enabled condition (`_answers.length == nonPhotoExercises.length`)
   - Score calculation in `ExerciseScorer`
2. Photo exercises render inline in the exercise list but manage their own completion state independently
3. `ExerciseScorer.score()` handles the new `photo` case by returning `0.0` (it will never be called for photo exercises due to the filtering above, but this prevents the exhaustive switch compile error)

This means a section with 3 MCQs and 1 photo exercise has a scoring denominator of 3. The photo exercise is a bonus/standalone activity within the section.

## UI Flow

### PhotoExerciseWidget States

1. **Idle** — Shows question + camera button
2. **Permission Denied** — Shows message explaining camera access is required + button to open app settings
3. **Capturing** — `image_picker` opens device camera (`ImageSource.camera`)
4. **Preview** — Shows captured photo + "Submit" / "Retake" buttons
5. **Validating** — Photo with loading spinner overlay
6. **Result: Correct** — Green checkmark, "Correct!" message
7. **Result: Incorrect** — Red X, "Incorrect" message, disabled retry button with countdown timer
8. **Error** — "Validation failed" message with immediate retry button (no cooldown)
9. **Cooldown expired** — Retry button re-enables
10. **Offline** — Camera button disabled with "Requires internet connection" message

### Flow Diagram

```
Idle → [tap camera] → (permission check)
  → [denied] → Permission Denied → [open settings] → Idle
  → [granted] → Capturing → [photo taken] → Preview

Preview → [tap submit] → Validating
  → [success: CORRECT] → Result: Correct
  → [success: INCORRECT] → Result: Incorrect → [wait 60s] → Idle (retry)
  → [API/network failure] → Error → [tap retry] → Idle (immediate)

Preview → [tap retake] → Capturing
Result: Correct → [auto-advance or manual continue to next exercise in list]
```

### Key Decisions

- Photo kept in memory as `Uint8List`, never persisted to storage
- Cooldown enforced client-side only (low stakes, no server enforcement needed). Users can bypass by force-closing the app — this is an accepted tradeoff.
- Widget is standalone — does not write to the section answer map
- **Offline detection:** Check connectivity before enabling camera button. If offline, show disabled state.

### Privacy Notice

On first use of a photo exercise, show a one-time dismissible notice: "Your photo will be sent to Google's AI service for analysis. Photos are not stored." This is tracked via a local shared preference flag (`hasSeenPhotoPrivacyNotice`).

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
| Domain | `features/courses/domain/entities/photo_validation_result.dart` | New freezed entity |
| Domain | `features/courses/domain/repositories/photo_validation_repository.dart` | New abstract class |
| Data | `features/courses/data/models/exercise_model.dart` | Update DTO fields, `toEntity()`, `fromEntity()`, and `fromJson`/`toJson` for new fields |
| Data | `features/courses/data/datasources/gemini_photo_datasource.dart` | New — wraps `firebase_ai` with image compression |
| Data | `features/courses/data/repositories/photo_validation_repository_impl.dart` | New — implements abstract repo with error handling |
| Presentation | `features/courses/presentation/widgets/exercise_widgets/photo_exercise_widget.dart` | New — full UI flow with all states |
| Presentation | `features/courses/presentation/providers/photo_validation_provider.dart` | New — Riverpod AsyncNotifier provider |
| Presentation | `features/courses/presentation/screens/exercise_screen.dart` | Add `case ExerciseType.photo`, filter photo exercises from submit gate and scoring denominator |
| Core | `core/utils/exercise_scorer.dart` | Add `ExerciseType.photo` case returning `0.0` (prevents exhaustive switch compile error) |
| Config | `android/app/src/main/AndroidManifest.xml` | Camera permission |
| Config | `ios/Runner/Info.plist` | Camera usage description |
| Config | `pubspec.yaml` | Add `firebase_ai`, `image_picker` |

**Post-edit step:** Run `dart run build_runner build` to regenerate `.freezed.dart` and `.g.dart` files after model changes.

## What's NOT Changing

- Practice/SM-2 system — no integration
- Enrollment tracking — unaffected
- Navigation/GoRouter — no new routes needed
- Admin dashboard — out of scope (exercises assumed seeded in Firestore)

## Trust Boundaries

- `photoPrompt` is admin-configured via Firestore. Admins are trusted. If Firestore write access is compromised, prompt injection is possible but the blast radius is limited to incorrect validation results (not data exfiltration).

## Sources

- [Firebase AI Logic Docs](https://firebase.google.com/docs/ai-logic)
- [Analyze Images with Firebase AI Logic](https://firebase.google.com/docs/ai-logic/analyze-images)
- [firebase_ai package (v3.9.0)](https://pub.dev/packages/firebase_ai)
- [image_picker package](https://pub.dev/packages/image_picker)
- [Gemini API Pricing](https://ai.google.dev/gemini-api/docs/pricing)
