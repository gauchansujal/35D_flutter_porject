import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/widgets/battery_widget.dart';
import 'package:flutter_application_1/core/widgets/light_sensor_widget.dart';
import 'package:flutter_application_1/core/widgets/proximity_sensor_widget.dart';

class SensorDashboardPage extends StatelessWidget {
  const SensorDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Sensors'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Device Sensors',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Real-time sensor data from your device',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            const BatteryWidget(),
            const SizedBox(height: 16),
            const LightWidget(),
            const SizedBox(height: 16),
            const ProximityWidget(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ); 
  }
}
