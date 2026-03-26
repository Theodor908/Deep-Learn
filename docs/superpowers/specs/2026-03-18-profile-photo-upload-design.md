# Profile Photo Upload — Design Spec

**Date:** 2026-03-18
**Status:** Approved

## Overview

Allow users to upload a profile photo from their gallery or camera, or remove an existing one. Photos are stored in Firebase Storage, with the download URL persisted in Firestore. The profile screen already displays `photoUrl` with an initials fallback — this feature wires up the existing edit button to a photo picker flow.

## Architecture

### What Already Exists
- `AppUser` entity has a nullable `photoUrl` field
- `AuthRepository.updateProfile(photoUrl:)` writes to Firestore `/users/{uid}`
- `image_picker` package is installed and used in photo exercise widget
- Profile screen displays `photoUrl` with `CachedNetworkImage` and initials fallback
- Firebase project has a storage bucket configured: `elearning-caf76.firebasestorage.app`

### What Needs to Be Added

#### 1. New Package
- `firebase_storage` in `pubspec.yaml`

#### 2. Data Layer — Firebase Storage Datasource
**File:** `lib/features/auth/data/datasources/firebase_storage_datasource.dart`

Responsibilities:
- `Future<String> uploadProfilePhoto(String uid, Uint8List bytes)` — Uploads to `profile_photos/{uid}.jpg` with `contentType: 'image/jpeg'`, returns download URL
- `Future<void> deleteProfilePhoto(String uid)` — Deletes the file at `profile_photos/{uid}.jpg`

Exposed via a Riverpod provider: `firebaseStorageDatasourceProvider`.

Note: MIME type is always `image/jpeg` because `image_picker` is configured with `requestFullMetadata: false` and the constraints force JPEG output.

#### 3. Domain Layer — ProfilePhotoRepository Interface
**File:** `lib/features/auth/domain/repositories/profile_photo_repository.dart`

Abstract interface (presentation layer depends on this, not on the datasource):
- `Future<String> uploadPhoto(String uid, Uint8List bytes)` — returns download URL
- `Future<void> deletePhoto(String uid)`

#### 4. Data Layer — ProfilePhotoRepository Implementation
**File:** `lib/features/auth/data/repositories/profile_photo_repository_impl.dart`

Implements the domain interface by delegating to `FirebaseStorageDatasource`. Exposed via a Riverpod provider that the presentation layer consumes.

#### 5. Modification — AuthRepository.updateProfile
**File:** `lib/features/auth/domain/repositories/auth_repository.dart`
**File:** `lib/features/auth/data/repositories/auth_repository_impl.dart`

Add a `bool clearPhoto = false` parameter to `updateProfile`. When `true`, sets `photoUrl` to `null` in Firestore (distinguishes "no change" from "explicitly remove").

#### 6. Presentation Layer — ProfilePhotoNotifier
**File:** `lib/features/auth/presentation/providers/profile_photo_provider.dart`

State: `AsyncValue<void>` (idle / loading / error).

Methods:
- `Future<void> uploadPhoto(ImageSource source)`:
  1. Launch `ImagePicker` with `maxWidth: 512, maxHeight: 512, imageQuality: 80`
  2. If user cancels, return (no-op)
  3. Read bytes from picked file; reject if > 2 MB
  4. Upload via `ProfilePhotoRepository.uploadPhoto(uid, bytes)`
  5. Call `AuthRepository.updateProfile(photoUrl: downloadUrl)`
  6. Invalidate `authNotifierProvider` to refresh UI (this provider fetches from Firestore, so it picks up the new `photoUrl`)
- `Future<void> removePhoto()`:
  1. Delete via `ProfilePhotoRepository.deletePhoto(uid)`; swallow "not found" errors
  2. Call `AuthRepository.updateProfile(clearPhoto: true)`
  3. Invalidate `authNotifierProvider`

#### 7. Presentation Layer — PhotoPickerBottomSheet Widget
**File:** `lib/features/profile/presentation/widgets/photo_picker_bottom_sheet.dart`

Extracted widget for the modal bottom sheet:
- "Take Photo" — camera icon
- "Choose from Gallery" — image icon
- "Remove Photo" — trash icon, only visible when `photoUrl != null`
- Returns the user's selection (enum) so the caller invokes the notifier

#### 8. Presentation Layer — Profile Screen Changes
**File:** `lib/features/profile/presentation/screens/profile_screen.dart`

- Avatar edit button tap → shows `PhotoPickerBottomSheet`
- Watches `profilePhotoNotifierProvider` for loading state
- While uploading, overlays a `CircularProgressIndicator` on the avatar
- Listens for errors and shows a snackbar

## Image Constraints
- Max dimensions: 512x512 pixels
- JPEG quality: 80%
- Max file size: 2 MB (guard before upload)
- Storage path: `profile_photos/{uid}.jpg` (one file per user, overwrites on re-upload)
- Output is always JPEG — `image_picker` compresses to JPEG when `imageQuality` is set

## Error Handling
- User cancels picker → no-op (state stays idle)
- File exceeds 2 MB after compression → snackbar: "Image is too large. Please try a different photo."
- Upload fails (network, permissions) → snackbar with error message, state resets to idle
- Delete fails on non-existent file → swallow error gracefully, still clear Firestore URL

## Platform Permissions
- Android: `AndroidManifest.xml` — camera permission (gallery doesn't need one on modern Android)
- iOS: `Info.plist` — `NSCameraUsageDescription` and `NSPhotoLibraryUsageDescription`
- These may already be configured from the photo exercise feature; verify and add if missing

## Provider Data Flow
1. User picks image → `ProfilePhotoNotifier.uploadPhoto()`
2. Bytes uploaded to Firebase Storage via `ProfilePhotoRepository` → returns download URL
3. Download URL written to Firestore `/users/{uid}` via `AuthRepository.updateProfile(photoUrl:)`
4. `authNotifierProvider` is invalidated → re-fetches `AppUser` from Firestore → picks up new `photoUrl`
5. Profile screen rebuilds via `ref.watch(authNotifierProvider)` → avatar shows new image

## Testing
Test files mirror source structure per CLAUDE.md conventions:
- `test/features/auth/data/datasources/firebase_storage_datasource_test.dart` — mock `FirebaseStorage`, verify upload path/metadata and delete calls
- `test/features/auth/data/repositories/profile_photo_repository_impl_test.dart` — mock datasource, verify delegation
- `test/features/auth/presentation/providers/profile_photo_provider_test.dart` — mock repositories, test upload flow (happy path, cancel, size rejection, error), test remove flow

Use `mocktail` for mocking. Arrange-Act-Assert pattern.

## Files Changed (Summary)
| File | Change |
|------|--------|
| `pubspec.yaml` | Add `firebase_storage` |
| `auth/data/datasources/firebase_storage_datasource.dart` | **New** — upload/delete to Storage |
| `auth/domain/repositories/profile_photo_repository.dart` | **New** — abstract interface |
| `auth/data/repositories/profile_photo_repository_impl.dart` | **New** — implements interface |
| `auth/domain/repositories/auth_repository.dart` | Add `clearPhoto` param |
| `auth/data/repositories/auth_repository_impl.dart` | Implement `clearPhoto` logic |
| `auth/presentation/providers/profile_photo_provider.dart` | **New** — pick/upload/remove notifier |
| `profile/presentation/widgets/photo_picker_bottom_sheet.dart` | **New** — bottom sheet widget |
| `profile/presentation/screens/profile_screen.dart` | Wire edit button to bottom sheet + loading state |
| `android/app/src/main/AndroidManifest.xml` | Verify camera permission |
| `ios/Runner/Info.plist` | Verify camera/photo library descriptions |
