import 'package:cloud_firestore/cloud_firestore.dart';

abstract final class FirebaseErrorMapper {
  static String mapToUserMessage(Object error) {
    if (error is FirebaseException) {
      return switch (error.code) {
        'permission-denied' =>
          'You don\'t have permission to access this content. Please sign in.',
        'unavailable' =>
          'The service is temporarily unavailable. Please try again later.',
        'not-found' => 'The requested content could not be found.',
        'already-exists' => 'This item already exists.',
        'resource-exhausted' =>
          'Too many requests. Please wait a moment and try again.',
        'cancelled' => 'The operation was cancelled.',
        'deadline-exceeded' =>
          'The request took too long. Please check your connection.',
        'unauthenticated' => 'Please sign in to continue.',
        _ => 'Something went wrong. Please try again.',
      };
    }

    final message = error.toString().toLowerCase();
    if (message.contains('permission') || message.contains('denied')) {
      return 'You don\'t have permission to access this content. Please sign in.';
    }
    if (message.contains('network') || message.contains('connection')) {
      return 'Network error. Please check your connection.';
    }
    if (message.contains('not found') || message.contains('404')) {
      return 'The requested content could not be found.';
    }

    return 'Something went wrong. Please try again.';
  }
}
