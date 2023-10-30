package fr.fabrique.social.gouv.pass_emploi_app

import android.content.pm.PackageManager
import android.graphics.drawable.Drawable
import android.os.Build
import android.widget.ImageView
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        val cvmRepository = CvmRepository(this, this)
        MethodChannelHandler(flutterEngine, cvmRepository)


    }
}
