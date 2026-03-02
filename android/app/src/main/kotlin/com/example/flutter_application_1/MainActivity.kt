package com.example.flutter_application_1

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity : FlutterActivity(), SensorEventListener {

    private lateinit var sensorManager: SensorManager
    private var proximitySensor: Sensor? = null
    private var lightSensor: Sensor? = null

    private var proximityEventSink: EventChannel.EventSink? = null
    private var lightEventSink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        proximitySensor = sensorManager.getDefaultSensor(Sensor.TYPE_PROXIMITY)
        lightSensor = sensorManager.getDefaultSensor(Sensor.TYPE_LIGHT)

        // ─── Proximity Channel ───────────────────────────────
        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "proximity_sensor_events"
        ).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                proximityEventSink = events
                proximitySensor?.let {
                    sensorManager.registerListener(
                        this@MainActivity,
                        it,
                        SensorManager.SENSOR_DELAY_NORMAL
                    )
                }
            }
            override fun onCancel(arguments: Any?) {
                proximityEventSink = null
            }
        })

        // ─── Light Channel ───────────────────────────────────
        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "light_sensor_events"
        ).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                lightEventSink = events
                lightSensor?.let {
                    sensorManager.registerListener(
                        this@MainActivity,
                        it,
                        SensorManager.SENSOR_DELAY_NORMAL
                    )
                }
            }
            override fun onCancel(arguments: Any?) {
                lightEventSink = null
            }
        })
    }

    override fun onSensorChanged(event: SensorEvent?) {
        event?.let {
            when (it.sensor.type) {
                Sensor.TYPE_PROXIMITY -> proximityEventSink?.success(it.values[0])
                Sensor.TYPE_LIGHT -> lightEventSink?.success(it.values[0])
            }
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        // Not needed
    }

    override fun onDestroy() {
        super.onDestroy()
        sensorManager.unregisterListener(this)
    }
}