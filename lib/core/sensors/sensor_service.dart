import 'dart:async';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/services.dart';

class SensorService {
  // Singleton
  static final SensorService _instance = SensorService._internal();
  factory SensorService() => _instance;
  SensorService._internal();

  final Battery _battery = Battery();

  // ❌ REMOVED: Light? _light;
  // ❌ REMOVED: import 'package:light/light.dart'
  // ✅ Light now comes from native Android channel below

  static const EventChannel _proximityChannel =
      EventChannel('proximity_sensor_events');
  static const EventChannel _lightChannel =
      EventChannel('light_sensor_events'); // ✅ NEW

  final _lightController = StreamController<double>.broadcast(); // ✅ double not int
  final _proximityController = StreamController<bool>.broadcast();

  StreamSubscription? _lightSub;
  StreamSubscription? _proximitySub;

  bool _isLightInitialized = false;
  bool _isProximityInitialized = false;

  // ─────────────────────────────────────────
  //               BATTERY
  // ─────────────────────────────────────────

  Future<int> getBatteryLevel() async {
    try {
      return await _battery.batteryLevel;
    } catch (e) {
      throw Exception('Failed to get battery level: $e');
    }
  }

  Stream<BatteryState> getBatteryState() {
    return _battery.onBatteryStateChanged;
  }

  // ─────────────────────────────────────────
  //               LIGHT (Native Channel)
  // ─────────────────────────────────────────

  Stream<double> getLightStream() {
    if (!_isLightInitialized) _initLightSensor();
    return _lightController.stream;
  }

  void _initLightSensor() {
    try {
      _lightSub = _lightChannel.receiveBroadcastStream().listen(
        (dynamic value) {
          if (!_lightController.isClosed) {
            _lightController.add(value as double);
          }
        },
        onError: (error) {
          if (!_lightController.isClosed) {
            _lightController.addError(error);
          }
        },
      );
      _isLightInitialized = true;
    } catch (e) {
      _lightController.addError('Light sensor not available: $e');
    }
  }

  // ─────────────────────────────────────────
  //               PROXIMITY (Native Channel)
  // ─────────────────────────────────────────

  Stream<bool> getProximityStream() {
    if (!_isProximityInitialized) _initProximitySensor();
    return _proximityController.stream;
  }

  void _initProximitySensor() {
    try {
      _proximitySub = _proximityChannel.receiveBroadcastStream().listen(
        (dynamic value) {
          if (!_proximityController.isClosed) {
            _proximityController.add((value as double) < 5.0);
          }
        },
        onError: (error) {
          if (!_proximityController.isClosed) {
            _proximityController.addError(error);
          }
        },
      );
      _isProximityInitialized = true;
    } catch (e) {
      _proximityController.addError('Proximity sensor not available: $e');
    }
  }

  // ─────────────────────────────────────────
  //               DISPOSE
  // ─────────────────────────────────────────

  void dispose() {
    _lightSub?.cancel();
    _proximitySub?.cancel();
    if (!_lightController.isClosed) _lightController.close();
    if (!_proximityController.isClosed) _proximityController.close();
    _isLightInitialized = false;
    _isProximityInitialized = false;
  }
}