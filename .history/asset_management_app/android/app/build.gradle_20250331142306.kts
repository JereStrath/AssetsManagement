// Ensure that the plugins are applied in the correct order: 
// 1. Android Gradle Plugin
// 2. Kotlin Gradle Plugin
// 3. Flutter Gradle Plugin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Must be applied after the above plugins
    namespace = "com.yourcompany.asset_management_app"

android {
    namespace = "com.example.asset_management_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.asset_management_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Configure signing for the release build.
            // Replace the following example with your own signing configuration.
            // For more details, see: https://developer.android.com/studio/publish/app-signing
            signingConfig = signingConfigs.create("release") {
                storeFile = file("path/to/keystore.jks")
                storePassword = "your-keystore-password"
                keyAlias = "your-key-alias"
                keyPassword = "your-key-password"
            }
    }
}

flutter {
    source = "../.."
}

plugins {
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
}