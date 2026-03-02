import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/sensors/sensor_service.dart';

class ProximityWidget extends StatefulWidget {
  const ProximityWidget({super.key});

  @override
  State<ProximityWidget> createState() => _ProximityWidgetState();
}

class _ProximityWidgetState extends State<ProximityWidget> {
  final SensorService _sensorService = SensorService();
  bool _isNear = false;
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _sub = _sensorService.getProximityStream().listen((v) {
      if (mounted) setState(() => _isNear = v);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: _isNear ? Colors.red[50] : Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              _isNear ? Icons.sensors : Icons.sensors_off,
              size: 40,
              color: _isNear ? Colors.red : Colors.green,
            ),
            const SizedBox(height: 8),
            Text(
              _isNear ? 'Near' : 'Far',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: _isNear ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _isNear ? 'Object detected!' : 'Nothing nearby',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}