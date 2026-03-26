import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_ai/firebase_ai.dart';

enum PhotoValidationErrorType { network, rateLimit, server }

class PhotoValidationException implements Exception {
  final PhotoValidationErrorType type;
  final String message;
  PhotoValidationException(this.type, this.message);
}

class GeminiPhotoDatasource {
  final GenerativeModel _model;

  GeminiPhotoDatasource()
      : _model = FirebaseAI.googleAI().generativeModel(
            model: 'gemini-2.5-flash',
          );

  Future<String> validate({
    required Uint8List imageBytes,
    required String mimeType,
    required String photoPrompt,
    required List<String> correctAnswer,
  }) async {
    final prompt = TextPart(
      'You are an exercise validator for a horticulture learning app.\n'
      'Task: $photoPrompt\n'
      'Criteria: The image should show: ${correctAnswer.join(", ")}\n'
      'Respond with ONLY the word "CORRECT" or "INCORRECT". Nothing else.',
    );
    final imagePart = InlineDataPart(mimeType, imageBytes);

    try {
      final response = await _model.generateContent([
        Content.multi([prompt, imagePart]),
      ]);
      return response.text ?? '';
    } on SocketException {
      throw PhotoValidationException(
        PhotoValidationErrorType.network,
        'No internet connection. Please check your network and try again.',
      );
    } on HttpException catch (e) {
      if (e.message.contains('429')) {
        throw PhotoValidationException(
          PhotoValidationErrorType.rateLimit,
          'Too many requests. Please wait a moment and try again.',
        );
      }
      throw PhotoValidationException(
        PhotoValidationErrorType.server,
        'Server error. Please try again.',
      );
    } catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('socketexception') ||
          msg.contains('network') ||
          msg.contains('connection')) {
        throw PhotoValidationException(
          PhotoValidationErrorType.network,
          'No internet connection. Please check your network and try again.',
        );
      }
      if (msg.contains('429') || msg.contains('rate') || msg.contains('quota')) {
        throw PhotoValidationException(
          PhotoValidationErrorType.rateLimit,
          'Too many requests. Please wait a moment and try again.',
        );
      }
      if (msg.contains('500') || msg.contains('503') || msg.contains('unavailable')) {
        throw PhotoValidationException(
          PhotoValidationErrorType.server,
          'Server error. Please try again.',
        );
      }
      rethrow;
    }
  }
}
