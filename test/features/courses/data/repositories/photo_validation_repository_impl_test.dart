import 'dart:typed_data';

import 'package:deep_learn/features/courses/data/datasources/gemini_photo_datasource.dart';
import 'package:deep_learn/features/courses/data/repositories/photo_validation_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGeminiPhotoDatasource extends Mock implements GeminiPhotoDatasource {}

void main() {
  late PhotoValidationRepositoryImpl repository;
  late MockGeminiPhotoDatasource mockDatasource;

  setUpAll(() {
    registerFallbackValue(Uint8List(0));
  });

  setUp(() {
    mockDatasource = MockGeminiPhotoDatasource();
    repository = PhotoValidationRepositoryImpl(mockDatasource);
  });

  final testBytes = Uint8List.fromList([1, 2, 3]);

  group('validatePhoto', () {
    test('should return isCorrect true when Gemini responds CORRECT', () async {
      when(() => mockDatasource.validate(
            imageBytes: any(named: 'imageBytes'),
            mimeType: any(named: 'mimeType'),
            photoPrompt: any(named: 'photoPrompt'),
            correctAnswer: any(named: 'correctAnswer'),
          )).thenAnswer((_) async => 'CORRECT');

      final result = await repository.validatePhoto(
        imageBytes: testBytes,
        mimeType: 'image/jpeg',
        photoPrompt: 'Is this a succulent?',
        correctAnswer: ['succulent'],
      );

      expect(result.isCorrect, true);
      expect(result.rawResponse, 'CORRECT');
    });

    test('should return isCorrect true when response has leading/trailing whitespace', () async {
      when(() => mockDatasource.validate(
            imageBytes: any(named: 'imageBytes'),
            mimeType: any(named: 'mimeType'),
            photoPrompt: any(named: 'photoPrompt'),
            correctAnswer: any(named: 'correctAnswer'),
          )).thenAnswer((_) async => '  correct  ');

      final result = await repository.validatePhoto(
        imageBytes: testBytes,
        mimeType: 'image/jpeg',
        photoPrompt: 'Is this a succulent?',
        correctAnswer: ['succulent'],
      );

      expect(result.isCorrect, true);
    });

    test('should return isCorrect false when Gemini responds INCORRECT', () async {
      when(() => mockDatasource.validate(
            imageBytes: any(named: 'imageBytes'),
            mimeType: any(named: 'mimeType'),
            photoPrompt: any(named: 'photoPrompt'),
            correctAnswer: any(named: 'correctAnswer'),
          )).thenAnswer((_) async => 'INCORRECT');

      final result = await repository.validatePhoto(
        imageBytes: testBytes,
        mimeType: 'image/jpeg',
        photoPrompt: 'Is this a succulent?',
        correctAnswer: ['succulent'],
      );

      expect(result.isCorrect, false);
      expect(result.rawResponse, 'INCORRECT');
    });

    test('should return isCorrect false for unexpected response', () async {
      when(() => mockDatasource.validate(
            imageBytes: any(named: 'imageBytes'),
            mimeType: any(named: 'mimeType'),
            photoPrompt: any(named: 'photoPrompt'),
            correctAnswer: any(named: 'correctAnswer'),
          )).thenAnswer((_) async => 'I think this might be a plant...');

      final result = await repository.validatePhoto(
        imageBytes: testBytes,
        mimeType: 'image/jpeg',
        photoPrompt: 'Is this a succulent?',
        correctAnswer: ['succulent'],
      );

      expect(result.isCorrect, false);
    });

    test('should return isCorrect false for empty response', () async {
      when(() => mockDatasource.validate(
            imageBytes: any(named: 'imageBytes'),
            mimeType: any(named: 'mimeType'),
            photoPrompt: any(named: 'photoPrompt'),
            correctAnswer: any(named: 'correctAnswer'),
          )).thenAnswer((_) async => '');

      final result = await repository.validatePhoto(
        imageBytes: testBytes,
        mimeType: 'image/jpeg',
        photoPrompt: 'Is this a succulent?',
        correctAnswer: ['succulent'],
      );

      expect(result.isCorrect, false);
      expect(result.rawResponse, '');
    });

    test('should rethrow exceptions from datasource', () async {
      when(() => mockDatasource.validate(
            imageBytes: any(named: 'imageBytes'),
            mimeType: any(named: 'mimeType'),
            photoPrompt: any(named: 'photoPrompt'),
            correctAnswer: any(named: 'correctAnswer'),
          )).thenThrow(Exception('Network error'));

      expect(
        () => repository.validatePhoto(
          imageBytes: testBytes,
          mimeType: 'image/jpeg',
          photoPrompt: 'Is this a succulent?',
          correctAnswer: ['succulent'],
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
