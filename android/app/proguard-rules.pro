## Auto-generated missing class rules (from missing_rules.txt)
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication

## Flutter-specific rules
# Keep Flutter engine entry points
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }
-dontwarn io.flutter.embedding.**

# Keep our MainActivity
-keep class com.stockswipe.stockswipe.MainActivity { *; }

## Kotlin / coroutines
-keep class kotlin.** { *; }
-keep class kotlinx.coroutines.** { *; }
-dontwarn kotlinx.coroutines.**

## AndroidX / Jetpack
-keep class androidx.** { *; }
-dontwarn androidx.**

## Google Play Services (used by flutter_local_notifications, in_app_review, etc.)
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

## Drift / SQLite
-keep class ** extends com.squareup.sqldelight.** { *; }
-dontwarn com.squareup.**

## OkHttp / Dio networking
-dontwarn okio.**
-dontwarn okhttp3.**
-keep class okhttp3.** { *; }

## General reflection safety
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses
