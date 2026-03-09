import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/sensors/sensor_service.dart';

class LightWidget extends StatefulWidget {
  const LightWidget({super.key});

  @override
  State<LightWidget> createState() => _LightWidgetState();
}

class _LightWidgetState extends State<LightWidget> {
  final SensorService _sensorService = SensorService();
  double _lux = 0.0; // ✅ changed int → double
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _sub = _sensorService.getLightStream().listen((double v) {
      // ✅ double
      if (mounted) setState(() => _lux = v);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  String get _lightLabel {
    if (_lux < 10) return 'Very Dark 🌑';
    if (_lux < 100) return 'Dim 🌘';
    if (_lux < 500) return 'Indoor 💡';
    if (_lux < 1000) return 'Bright 🌤';
    return 'Sunlight ☀️';
  }

  Color get _lightColor {
    if (_lux < 10) return Colors.grey[800]!;
    if (_lux < 100) return Colors.blueGrey;
    if (_lux < 500) return Colors.orange;
    if (_lux < 1000) return Colors.amber;
    return Colors.yellow[700]!;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: _lightColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.wb_sunny, size: 40, color: _lightColor),
            const SizedBox(height: 8),
            Text(
              '${_lux.toStringAsFixed(1)} lux', // ✅ toStringAsFixed for double
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(_lightLabel, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
