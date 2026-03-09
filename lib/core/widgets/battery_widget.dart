import 'dart:async';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/sensors/sensor_service.dart';

class BatteryWidget extends StatefulWidget {
  const BatteryWidget({super.key});

  @override
  State<BatteryWidget> createState() => _BatteryWidgetState();
}

class _BatteryWidgetState extends State<BatteryWidget> {
  final SensorService _sensorService = SensorService();
  int _batteryLevel = 0;
  BatteryState _batteryState = BatteryState.unknown;
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _sensorService.getBatteryLevel().then((v) {
      if (mounted) setState(() => _batteryLevel = v);
    });
    _sub = _sensorService.getBatteryState().listen((v) {
      if (mounted) setState(() => _batteryState = v);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  String get _stateText {
    switch (_batteryState) {
      case BatteryState.charging:
        return 'Charging ⚡';
      case BatteryState.discharging:
        return 'Discharging';
      case BatteryState.full:
        return 'Full ✅';
      default:
        return 'Unknown';
    }
  }

  Color get _batteryColor {
    if (_batteryLevel > 50) return Colors.green;
    if (_batteryLevel > 20) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.battery_full, size: 40, color: _batteryColor),
            const SizedBox(height: 8),
            Text(
              '$_batteryLevel%',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: _batteryLevel / 100,
                backgroundColor: Colors.grey[300],
                color: _batteryColor,
                minHeight: 10,
              ),
            ),
            const SizedBox(height: 8),
            Text(_stateText, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
