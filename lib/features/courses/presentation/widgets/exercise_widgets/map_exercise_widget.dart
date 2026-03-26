import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../data/datasources/location_datasource.dart';
import '../../../domain/entities/exercise.dart';

enum _MapState { loading, navigating, arrived, denied, unsupported }

class MapExerciseWidget extends StatefulWidget {
  final Exercise exercise;
  final VoidCallback onArrived;

  const MapExerciseWidget({
    super.key,
    required this.exercise,
    required this.onArrived,
  });

  @override
  State<MapExerciseWidget> createState() => _MapExerciseWidgetState();
}

class _MapExerciseWidgetState extends State<MapExerciseWidget> {
  final LocationDatasource _location = LocationDatasource();

  _MapState _state = _MapState.loading;
  StreamSubscription<Position>? _positionSub;
  Position? _currentPosition;
  double? _distanceMeters;
  GoogleMapController? _mapController;

  LatLng get _destination => LatLng(
        widget.exercise.destinationLat ?? 0,
        widget.exercise.destinationLng ?? 0,
      );

  @override
  void initState() {
    super.initState();
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      _state = _MapState.unsupported;
    } else {
      _initLocation();
    }
  }

  Future<void> _initLocation() async {
    final permission = await _location.checkAndRequestPermission();

    if (!mounted) return;

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() => _state = _MapState.denied);
      return;
    }

    setState(() => _state = _MapState.navigating);
    _startTracking();
  }

  void _startTracking() {
    _positionSub = _location.getPositionStream().listen(
      (position) {
        if (!mounted) return;

        final distance = _location.distanceTo(
          position.latitude,
          position.longitude,
          _destination.latitude,
          _destination.longitude,
        );

        setState(() {
          _currentPosition = position;
          _distanceMeters = distance;
        });

        if (distance <= widget.exercise.geofenceRadiusMeters) {
          _arrive();
        }
      },
      onError: (_) {
        if (mounted) setState(() => _state = _MapState.denied);
      },
    );
  }

  void _arrive() {
    if (_state == _MapState.arrived) return;
    _positionSub?.cancel();
    setState(() => _state = _MapState.arrived);
    widget.onArrived();
  }

  void _continueAnyway() {
    _positionSub?.cancel();
    setState(() => _state = _MapState.arrived);
    widget.onArrived();
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question / destination name
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
        const SizedBox(height: 16),
        _buildStateContent(),
      ],
    );
  }

  Widget _buildStateContent() {
    return switch (_state) {
      _MapState.loading => const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
      _MapState.navigating => _buildNavigatingState(),
      _MapState.arrived => _buildArrivedState(),
      _MapState.denied => _buildDeniedState(),
      _MapState.unsupported => _buildUnsupportedState(),
    };
  }

  Widget _buildNavigatingState() {
    return Column(
      children: [
        // Google Map
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 250,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _destination,
                zoom: 15,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              markers: {
                Marker(
                  markerId: const MarkerId('destination'),
                  position: _destination,
                  infoWindow: InfoWindow(title: widget.exercise.question),
                ),
              },
              onMapCreated: (controller) {
                _mapController = controller;
                // If we already have position, fit bounds
                if (_currentPosition != null) {
                  _fitBounds();
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Distance info
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              PhosphorIcon(
                PhosphorIcons.mapPin(PhosphorIconsStyle.fill),
                color: AppColors.primary,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.exercise.question,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    if (_distanceMeters != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        _formatDistance(_distanceMeters!),
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Continue anyway
        Center(
          child: TextButton(
            onPressed: _continueAnyway,
            child: Text(
              'Continue anyway',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textHint,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildArrivedState() {
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
            "You've arrived!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Scroll down to start the flower scavenger hunt.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeniedState() {
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
            'Location access needed',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enable location in your device settings to navigate to the destination.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: () => _location.openAppSettings(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Open Settings'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _continueAnyway,
            child: Text(
              'Continue anyway',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textHint,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnsupportedState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          PhosphorIcon(
            PhosphorIcons.mapPin(),
            color: AppColors.info,
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            'Map exercises are only available on mobile devices.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: _continueAnyway,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Continue anyway'),
          ),
        ],
      ),
    );
  }

  void _fitBounds() {
    if (_currentPosition == null || _mapController == null) return;
    final bounds = LatLngBounds(
      southwest: LatLng(
        _currentPosition!.latitude < _destination.latitude
            ? _currentPosition!.latitude
            : _destination.latitude,
        _currentPosition!.longitude < _destination.longitude
            ? _currentPosition!.longitude
            : _destination.longitude,
      ),
      northeast: LatLng(
        _currentPosition!.latitude > _destination.latitude
            ? _currentPosition!.latitude
            : _destination.latitude,
        _currentPosition!.longitude > _destination.longitude
            ? _currentPosition!.longitude
            : _destination.longitude,
      ),
    );
    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
  }

  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()} m away';
    }
    return '${(meters / 1000).toStringAsFixed(1)} km away';
  }
}
