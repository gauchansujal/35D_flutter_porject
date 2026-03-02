import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/sensors/sensors_riverpod_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SensorWrapper extends ConsumerWidget {
  final Widget child;
  const SensorWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sensor = ref.watch(sensorProvider);

    return Stack(
      children: [
        // Your actual app
        child,

        // Proximity lock overlay
        if (sensor.isNear)
          Positioned.fill(
            child: Container(
              color: Colors.black,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sensors, color: Colors.white, size: 60),
                    SizedBox(height: 16),
                    Text(
                      'Screen Locked',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Move away from sensor to unlock',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Battery warning banner
        if (sensor.showBatteryWarning && !sensor.isNear)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.red[700],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.battery_alert, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'Low Battery: ${sensor.batteryLevel}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        // ✅ fixed
                        ref
                            .read(sensorProvider.notifier)
                            .dismissBatteryWarning();
                      },
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
