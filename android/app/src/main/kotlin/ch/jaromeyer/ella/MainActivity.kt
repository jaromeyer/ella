package ch.jaromeyer.ella

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import  io.flutter.embedding.android.TransparencyMode
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.content.Context
import android.content.ContextWrapper
import android.app.AlarmManager


class MainActivity : FlutterActivity() {

    private val CHANNEL = "samples.flutter.dev/nextAlarm"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // This method is invoked on the main thread.
            call, result ->
            if (call.method == "getNextAlarm") {
            val nextAlarm = getNextAlarm()
                result.success(nextAlarm)
            } else {
            result.notImplemented()
            }
        }
    
    }


    private fun getNextAlarm(): Long {
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        if(alarmManager.nextAlarmClock == null)
            return -1
        return alarmManager.nextAlarmClock.triggerTime
    }

    override fun getTransparencyMode(): TransparencyMode {
        return TransparencyMode.transparent
    }
}
