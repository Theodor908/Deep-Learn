import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../data/datasources/gemini_photo_datasource.dart';
import '../../../domain/entities/exercise.dart';
import '../../providers/photo_validation_provider.dart';

enum _PhotoState { idle, preview, validating, correct, incorrect, error }

class PhotoExerciseWidget extends ConsumerStatefulWidget {
  final Exercise exercise;
  final bool locked;
  final VoidCallback? onCorrect;

  const PhotoExerciseWidget({
    super.key,
    required this.exercise,
    this.locked = false,
    this.onCorrect,
  });

  @override
  ConsumerState<PhotoExerciseWidget> createState() =>
      _PhotoExerciseWidgetState();
}

class _PhotoExerciseWidgetState extends ConsumerState<PhotoExerciseWidget> {
  static const _privacyPrefKey = 'hasSeenPhotoPrivacyNotice';

  final ImagePicker _picker = ImagePicker();

  _PhotoState _state = _PhotoState.idle;
  Uint8List? _imageBytes;
  String _mimeType = 'image/jpeg';
  Timer? _cooldownTimer;
  int _cooldownRemaining = 0;
  String? _errorMessage;
  String? _identifiedName;
  bool _showPrivacyNotice = false;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _checkPrivacyNotice();
    _checkConnectivity();
  }

  Future<void> _checkPrivacyNotice() async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool(_privacyPrefKey) ?? false)) {
      if (mounted) setState(() => _showPrivacyNotice = true);
    }
  }

  Future<void> _dismissPrivacyNotice() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_privacyPrefKey, true);
    if (mounted) setState(() => _showPrivacyNotice = false);
  }

  Future<void> _checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (mounted) setState(() => _isOffline = result.isEmpty);
    } on SocketException {
      if (mounted) setState(() => _isOffline = true);
    }
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }

  Future<void> _capturePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (photo == null) return;

      final bytes = await photo.readAsBytes();
      final mime = photo.mimeType ?? 'image/jpeg';

      if (!mounted) return;
      setState(() {
        _imageBytes = bytes;
        _mimeType = mime;
        _state = _PhotoState.preview;
        _errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _state = _PhotoState.error;
        _errorMessage =
            'Could not access camera. Please check your permissions in Settings.';
      });
    }
  }

  Future<void> _submitPhoto() async {
    if (_imageBytes == null) return;

    setState(() => _state = _PhotoState.validating);

    try {
      final repository = ref.read(photoValidationRepositoryProvider);
      final result = await repository.validatePhoto(
        imageBytes: _imageBytes!,
        mimeType: _mimeType,
        photoPrompt: widget.exercise.photoPrompt ?? widget.exercise.question,
        correctAnswer: widget.exercise.correctAnswer,
      );

      if (!mounted) return;

      // Extract species name if Gemini returned "CORRECT: Rose" format
      String? species;
      if (result.isCorrect && result.rawResponse.contains(':')) {
        species = result.rawResponse
            .substring(result.rawResponse.indexOf(':') + 1)
            .trim();
        if (species.isEmpty) species = null;
      }

      setState(() {
        _state =
            result.isCorrect ? _PhotoState.correct : _PhotoState.incorrect;
        _identifiedName = species;
      });

      if (result.isCorrect) widget.onCorrect?.call();

      if (!result.isCorrect) {
        _startCooldown();
      }
    } on PhotoValidationException catch (e) {
      if (!mounted) return;
      setState(() {
        _state = _PhotoState.error;
        _errorMessage = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _state = _PhotoState.error;
        _errorMessage = 'Validation failed. Check your connection and try again.';
      });
    }
  }

  void _startCooldown() {
    _cooldownRemaining = widget.exercise.retryCooldownSeconds;
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _cooldownRemaining--;
        if (_cooldownRemaining <= 0) {
          timer.cancel();
          _state = _PhotoState.idle;
          _imageBytes = null;
        }
      });
    });
  }

  void _retryFromError() {
    setState(() {
      _state = _PhotoState.idle;
      _imageBytes = null;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.locked) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          children: [
            PhosphorIcon(
              PhosphorIcons.lock(),
              size: 32,
              color: AppColors.textHint,
            ),
            const SizedBox(height: 10),
            Text(
              'Arrive at the destination first',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: Text(
            widget.exercise.question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ),
        if (_showPrivacyNotice) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: AppColors.info.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Your photo will be sent to Google\'s AI service for analysis. Photos are not stored.',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _dismissPrivacyNotice,
                  icon: PhosphorIcon(PhosphorIcons.x(), size: 16),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
        _buildStateContent(),
      ],
    );
  }

  Widget _buildStateContent() {
    return switch (_state) {
      _PhotoState.idle => _buildIdleState(),
      _PhotoState.preview => _buildPreviewState(),
      _PhotoState.validating => _buildValidatingState(),
      _PhotoState.correct => _buildCorrectState(),
      _PhotoState.incorrect => _buildIncorrectState(),
      _PhotoState.error => _buildErrorState(),
    };
  }

  Widget _buildIdleState() {
    if (_isOffline) {
      return Center(
        child: Column(
          children: [
            PhosphorIcon(
              PhosphorIcons.wifiSlash(),
              size: 40,
              color: AppColors.textHint,
            ),
            const SizedBox(height: 12),
            Text(
              'Requires internet connection',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textHint,
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _checkConnectivity,
              child: const Text('Check again'),
            ),
          ],
        ),
      );
    }

    return Center(
      child: ElevatedButton.icon(
        onPressed: _capturePhoto,
        icon: PhosphorIcon(PhosphorIcons.camera(), size: 20),
        label: const Text('Take Photo'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewState() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(
            _imageBytes!,
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _capturePhoto,
                icon: PhosphorIcon(PhosphorIcons.arrowCounterClockwise(),
                    size: 18),
                label: const Text('Retake'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: const BorderSide(color: AppColors.divider),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _submitPhoto,
                icon: PhosphorIcon(PhosphorIcons.paperPlaneRight(), size: 18),
                label: const Text('Submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildValidatingState() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.memory(
                _imageBytes!,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                color: Colors.black26,
                colorBlendMode: BlendMode.darken,
              ),
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Analyzing photo...',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildCorrectState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          PhosphorIcon(
            PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
            color: AppColors.success,
            size: 48,
          ),
          const SizedBox(height: 12),
          const Text(
            'Correct!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.success,
            ),
          ),
          if (_identifiedName != null) ...[
            const SizedBox(height: 8),
            Text(
              'That looks like: $_identifiedName',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildIncorrectState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          PhosphorIcon(
            PhosphorIcons.xCircle(PhosphorIconsStyle.fill),
            color: AppColors.error,
            size: 48,
          ),
          const SizedBox(height: 12),
          const Text(
            'Incorrect',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.error,
            ),
          ),
          if (_cooldownRemaining > 0) ...[
            const SizedBox(height: 12),
            Text(
              'Retry in $_cooldownRemaining seconds',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          PhosphorIcon(
            PhosphorIcons.warning(PhosphorIconsStyle.fill),
            color: AppColors.warning,
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            _errorMessage ?? 'Something went wrong.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _retryFromError,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
