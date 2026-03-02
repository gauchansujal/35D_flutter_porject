import 'dart:async';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_application_1/core/sensors/sensor_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:screen_brightness/screen_brightness.dart';

// ─── State ───────────────────────────────────────────────
class SensorState {
  final int batteryLevel;
  final BatteryState batteryState;
  final double luxValue;
  final bool isNear;
  final bool showBatteryWarning;

  const SensorState({
    this.batteryLevel = 0,
    this.batteryState = BatteryState.unknown,
    this.luxValue = 0.0,
    this.isNear = false,
    this.showBatteryWarning = false,
  });

  SensorState copyWith({
    int? batteryLevel,
    BatteryState? batteryState,
    double? luxValue,
    bool? isNear,
    bool? showBatteryWarning,
  }) {
    return SensorState(
      batteryLevel: batteryLevel ?? this.batteryLevel,
      batteryState: batteryState ?? this.batteryState,
      luxValue: luxValue ?? this.luxValue,
      isNear: isNear ?? this.isNear,
      showBatteryWarning: showBatteryWarning ?? this.showBatteryWarning,
    );
  }
}

// ─── Notifier ────────────────────────────────────────────
class SensorNotifier extends StateNotifier<SensorState> {
  final SensorService _sensorService = SensorService();
  final List<StreamSubscription> _subs = [];

  SensorNotifier() : super(const SensorState()) {
    _initAll();
  }

  void _initAll() {
    _sensorService.getBatteryLevel().then((v) {
      state = state.copyWith(batteryLevel: v, showBatteryWarning: v <= 20);
    });

    _subs.add(
      _sensorService.getBatteryState().listen((v) {
        state = state.copyWith(batteryState: v);
      }),
    );

    _subs.add(
      _sensorService.getLightStream().listen((double lux) async {
        state = state.copyWith(luxValue: lux);
        await _adjustBrightness(lux);
      }),
    );

    _subs.add(
      _sensorService.getProximityStream().listen((bool near) {
        state = state.copyWith(isNear: near);
      }),
    );
  }

  void dismissBatteryWarning() {
    state = state.copyWith(showBatteryWarning: false);
  }

  Future<void> _adjustBrightness(double lux) async {
    try {
      double brightness;
      if (lux < 10) {
        brightness = 0.1;
      } else if (lux < 100) {
        brightness = 0.3;
      } else if (lux < 500) {
        brightness = 0.6;
      } else {
        brightness = 1.0;
      }
      await ScreenBrightness().setScreenBrightness(brightness);
    } catch (_) {}
  }

  @override
  void dispose() {
    for (var s in _subs) {
      s.cancel();
    }
    SensorService().dispose();
    super.dispose();
  }
}

// ─── Provider ────────────────────────────────────────────
final sensorProvider = StateNotifierProvider<SensorNotifier, SensorState>((
  ref,
) {
  final notifier = SensorNotifier();
  ref.onDispose(() => notifier.dispose());
  return notifier;
});
