# Blue Moor - Learn — release R8 / ProGuard rules

# Keep app entry points
-keep class com.bluemoor.learn.BlueMoorApp { *; }
-keep class com.bluemoor.learn.MainActivity { *; }

# Encrypted SharedPreferences / Tink (security-crypto)
-dontwarn com.google.crypto.tink.**
-keep class com.google.crypto.tink.** { *; }
-keepclassmembers class * extends com.google.crypto.tink.shaded.protobuf.GeneratedMessageLite {
    <fields>;
}

# Compose
-dontwarn androidx.compose.**

# Strip verbose logs in release (if any Log calls are added later)
-assumenosideeffects class android.util.Log {
    public static int v(...);
    public static int d(...);
    public static int i(...);
}
