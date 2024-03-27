-keep class com.poleemploi.matrixlib.** { *; }
-keep class fr.fabrique.social.gouv.pass_emploi_app.** { *; }
-keep class io.flutter.plugin.common.** { *; }

# OkHttp platform used only on JVM and when Conscrypt and other security providers are available.
-dontwarn org.conscrypt.**
-dontwarn org.bouncycastle.**
-dontwarn org.openjsse.**