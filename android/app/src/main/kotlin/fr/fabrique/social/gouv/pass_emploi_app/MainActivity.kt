package fr.fabrique.social.gouv.pass_emploi_app

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        val cvmRepository = CvmRepository(this, this)
        val eventChannelHandler = EventChannelHandler(flutterEngine, cvmRepository)
        val roomsChannelHandler = RoomsChannelHandler(flutterEngine, cvmRepository)
        eventChannelHandler.initialize()
        roomsChannelHandler.initialize()
        MethodChannelHandler(flutterEngine, cvmRepository)

    }
}