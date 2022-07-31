package ch.jaromeyer.ella.ella

import io.flutter.embedding.android.FlutterActivity
import  io.flutter.embedding.android.TransparencyMode


class MainActivity : FlutterActivity() {
    override fun getTransparencyMode(): TransparencyMode {
        return TransparencyMode.transparent
    }
}
