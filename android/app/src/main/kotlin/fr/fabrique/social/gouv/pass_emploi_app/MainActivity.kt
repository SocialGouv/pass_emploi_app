package fr.fabrique.social.gouv.pass_emploi_app

import android.content.pm.PackageManager
import android.graphics.drawable.Drawable
import android.os.Build
import android.widget.ImageView
import androidx.annotation.NonNull
import io.flutter.embedding.android.DrawableSplashScreen
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.SplashScreen
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }

    override fun provideSplashScreen(): SplashScreen? {
        return DrawableSplashScreen(
                getSplashScreenFromManifest(),
                ImageView.ScaleType.FIT_XY,
                0 // Remove default fade in duration to better animate following loader screen
        );
    }

    // Copied from FlutterActivity since it's private
    private fun getSplashScreenFromManifest(): Drawable {
        val activityInfo = packageManager.getActivityInfo(componentName, PackageManager.GET_META_DATA)
        val metadata = activityInfo.metaData
        val splashScreenId = metadata.getInt("io.flutter.embedding.android.SplashScreenDrawable")
        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.LOLLIPOP) {
            return resources.getDrawable(splashScreenId, theme)
        } else {
            @Suppress("DEPRECATION")
            return resources.getDrawable(splashScreenId)
        }
    }
}
