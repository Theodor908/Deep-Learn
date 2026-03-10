import 'package:flutter_test/flutter_test.dart';
import 'package:deep_learn/core/utils/validators.dart';

void main() {
  group('email', () {
    test('should return null for valid email', () {
      expect(Validators.email('user@example.com'), isNull);
    });

    test('should return null for email with subdomain', () {
      expect(Validators.email('user@mail.example.com'), isNull);
    });

    test('should return null for email with plus addressing', () {
      expect(Validators.email('user+tag@example.com'), isNull);
    });

    test('should return error for null', () {
      expect(Validators.email(null), 'Email is required');
    });

    test('should return error for empty string', () {
      expect(Validators.email(''), 'Email is required');
    });

    test('should return error for whitespace only', () {
      expect(Validators.email('   '), 'Email is required');
    });

    test('should return error for email without @', () {
      expect(Validators.email('userexample.com'), 'Enter a valid email');
    });

    test('should return error for email without domain', () {
      expect(Validators.email('user@'), 'Enter a valid email');
    });

    test('should return error for email without TLD', () {
      expect(Validators.email('user@example'), 'Enter a valid email');
    });

    test('should return error for email with single-char TLD', () {
      expect(Validators.email('user@example.c'), 'Enter a valid email');
    });
  });

  group('password', () {
    test('should return null for valid password (8+ chars)', () {
      expect(Validators.password('abcd1234'), isNull);
    });

    test('should return null for long password', () {
      expect(Validators.password('a' * 50), isNull);
    });

    test('should return error for null', () {
      expect(Validators.password(null), 'Password is required');
    });

    test('should return error for empty string', () {
      expect(Validators.password(''), 'Password is required');
    });

    test('should return error for short password (7 chars)', () {
      expect(Validators.password('abcdefg'),
          'Password must be at least 8 characters');
    });

    test('should return error for very short password', () {
      expect(
          Validators.password('ab'), 'Password must be at least 8 characters');
    });

    test('should accept exactly 8 characters', () {
      expect(Validators.password('12345678'), isNull);
    });
  });

  group('confirmPassword', () {
    test('should return null when passwords match', () {
      expect(Validators.confirmPassword('secret123', 'secret123'), isNull);
    });

    test('should return error for null confirmation', () {
      expect(Validators.confirmPassword(null, 'secret123'),
          'Please confirm your password');
    });

    test('should return error for empty confirmation', () {
      expect(Validators.confirmPassword('', 'secret123'),
          'Please confirm your password');
    });

    test('should return error when passwords do not match', () {
      expect(Validators.confirmPassword('secret123', 'secret456'),
          'Passwords do not match');
    });

    test('should be case-sensitive', () {
      expect(Validators.confirmPassword('Secret123', 'secret123'),
          'Passwords do not match');
    });
  });

  group('username', () {
    test('should return null for valid username', () {
      expect(Validators.username('john_doe'), isNull);
    });

    test('should return null for alphanumeric username', () {
      expect(Validators.username('user123'), isNull);
    });

    test('should return null for underscore-only username (3+ chars)', () {
      expect(Validators.username('___'), isNull);
    });

    test('should return error for null', () {
      expect(Validators.username(null), 'Username is required');
    });

    test('should return error for empty string', () {
      expect(Validators.username(''), 'Username is required');
    });

    test('should return error for whitespace only', () {
      expect(Validators.username('   '), 'Username is required');
    });

    test('should return error for username shorter than 3 chars', () {
      expect(Validators.username('ab'),
          'Username must be at least 3 characters');
    });

    test('should return error for username with spaces', () {
      expect(Validators.username('john doe'),
          'Only letters, numbers, and underscores');
    });

    test('should return error for username with special chars', () {
      expect(Validators.username('john@doe'),
          'Only letters, numbers, and underscores');
    });

    test('should return error for username with hyphens', () {
      expect(Validators.username('john-doe'),
          'Only letters, numbers, and underscores');
    });

    test('should accept exactly 3 characters', () {
      expect(Validators.username('abc'), isNull);
    });
  });

  group('required', () {
    test('should return null for non-empty value', () {
      expect(Validators.required('hello'), isNull);
    });

    test('should return error for null with default field name', () {
      expect(Validators.required(null), 'This field is required');
    });

    test('should return error for empty string with custom field name', () {
      expect(Validators.required('', 'Name'), 'Name is required');
    });

    test('should return error for whitespace only', () {
      expect(Validators.required('   '), 'This field is required');
    });
  });
}
