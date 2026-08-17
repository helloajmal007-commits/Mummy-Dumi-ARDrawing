import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
}

android {
    namespace = "com.artsketch.trace2sketch.ar.drawing"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.artsketch.trace2sketch.ar.drawing"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = (keystoreProperties["keyAlias"] as? String) ?: ""
            keyPassword = (keystoreProperties["keyPassword"] as? String) ?: ""
            storeFile = file("upload-keystore.jks")
            storePassword = (keystoreProperties["storePassword"] as? String) ?: ""
        }
    }

    buildTypes {
        debug {
            // ---- Ad unit IDs: DEBUG (Google public test IDs) ----
            // Safe to keep in source control — these are Google's shared
            // test ad units and never affect real revenue or policy
            // standing. Read from Dart via the "sketch_flow/ad_config"
            // MethodChannel -> BuildConfig fields.
            buildConfigField("String", "APP_OPEN_AD_UNIT_ID", "\"ca-app-pub-3940256099942544/9257395921\"")
            buildConfigField("String", "BANNER_AD_UNIT_ID", "\"ca-app-pub-3940256099942544/6300978111\"")
            buildConfigField("String", "NATIVE_AD_UNIT_ID", "\"ca-app-pub-3940256099942544/2247696110\"")
            buildConfigField("String", "INTERSTITIAL_AD_UNIT_ID", "\"ca-app-pub-3940256099942544/1033173712\"")

            // ---- AdMob App ID ----
            // Google's public sample App ID, so debug builds never crash
            // from a missing/invalid App ID during development.
            manifestPlaceholders["admobAppId"] = "ca-app-pub-3940256099942544~3347511713"
        }

        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true

            // ---- Ad unit IDs: RELEASE (your real AdMob ad units) ----
            // Replace every REPLACE_ME below with the real ad unit IDs
            // from your AdMob console before shipping. Because this is
            // set per build type (not in defaultConfig), it is
            // structurally impossible for a debug build to request real
            // ads, or a release build to accidentally serve test ads.
            buildConfigField("String", "APP_OPEN_AD_UNIT_ID", "\"ca-app-pub-REPLACE_ME/APP_OPEN\"")
            buildConfigField("String", "BANNER_AD_UNIT_ID", "\"ca-app-pub-REPLACE_ME/BANNER\"")
            buildConfigField("String", "NATIVE_AD_UNIT_ID", "\"ca-app-pub-REPLACE_ME/NATIVE\"")
            buildConfigField("String", "INTERSTITIAL_AD_UNIT_ID", "\"ca-app-pub-REPLACE_ME/INTERSTITIAL\"")

            // ---- AdMob App ID ----
            // TODO: replace with your real AdMob App ID before shipping.
            manifestPlaceholders["admobAppId"] = "ca-app-pub-2940059973343828~1823201176"
        }
    }

    buildFeatures {
        // Required for BuildConfig.APP_OPEN_AD_UNIT_ID / BANNER_AD_UNIT_ID
        // / NATIVE_AD_UNIT_ID / INTERSTITIAL_AD_UNIT_ID to be generated at
        // all. Without this, MainActivity.kt fails to compile (this is
        // almost certainly the cause of the 27 errors you're seeing).
        buildConfig = true
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Import the Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:33.1.2"))

    // TODO: Add the dependencies for Firebase products you want to use
    // When using the BoM, don't specify versions in Firebase dependencies
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-crashlytics")
    implementation("com.google.firebase:firebase-config") // Remote Config

    // Add the dependencies for any other desired Firebase products
    // https://firebase.google.com/docs/android/setup#available-libraries

    implementation("com.google.android.gms:play-services-ads:23.6.0")
}