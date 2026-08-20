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
            buildConfigField("String", "APP_OPEN_AD_UNIT_ID", "\"ca-app-pub-3940256099942544/9257395921\"")
            buildConfigField("String", "APP_RESUME_OPEN_AD_UNIT_ID", "\"ca-app-pub-3940256099942544/9257395921\"")

            buildConfigField("String", "COLLAPSIBLE_BANNER_HOME_BOTTOM_AD_UNIT_ID", "\"ca-app-pub-3940256099942544/6300978111\"")
            buildConfigField("String", "NATIVE_LEARN_AD_UNIT_ID", "\"ca-app-pub-3940256099942544/2247696110\"")

            buildConfigField("String", "NATIVE_CATEGORIES_GRID_AD_UNIT_ID", "\"ca-app-pub-3940256099942544/2247696110\"")
            buildConfigField("String", "NATIVE_CATEGORY_IMAGELIST_AD_UNIT_ID", "\"ca-app-pub-3940256099942544/2247696110\"")
            buildConfigField("String", "COLLAPSIBLE_BANNER_CATEGORIES_BOTTOM_AD_UNIT_ID", "\"ca-app-pub-3940256099942544/6300978111\"")

            buildConfigField("String", "BANNER_SKETCH_SCREEN_AD_UNIT_ID", "\"ca-app-pub-3940256099942544/6300978111\"")
            buildConfigField("String", "INTERSTITIAL_SKETCH_PLUS_BUTTON_AD_UNIT_ID", "\"ca-app-pub-3940256099942544/1033173712\"")
            buildConfigField("String", "COLLAPSIBLE_BANNER_CANVAS_BOTTOM_AD_UNIT_ID", "\"ca-app-pub-3940256099942544/6300978111\"")

            buildConfigField("String", "BANNER_SETTINGS_TOP_AD_UNIT_ID", "\"ca-app-pub-3940256099942544/6300978111\"")
            buildConfigField("String", "APP_CLICK_INTERSTITIAL_AD_UNIT_ID", "\"ca-app-pub-3940256099942544/1033173712\"")

            buildConfigField("String", "WELCOME_SCREEN_INTERSTITIAL_AD_UNIT_ID", "\"ca-app-pub-3940256099942544/1033173712\"")

            buildConfigField("String", "AR_LANGUAGE_SCREEN_NATIVE_AD_UNIT_ID", "\"ca-app-pub-3940256099942544/2247696110\"")
            buildConfigField("String", "AR_LANGUAGE_SCREEN_2ND_NATIVE_AD_UNIT_ID", "\"ca-app-pub-3940256099942544/2247696110\"")
            buildConfigField("String", "AR_LANGUAGE_SCREEN_3RD_NATIVE_AD_UNIT_ID", "\"ca-app-pub-3940256099942544/2247696110\"")
            buildConfigField("String", "FULL_NATIVE_ONBOARDING_SLIDE_1TO2_AD_UNIT_ID", "\"ca-app-pub-3940256099942544/2247696110\"")
            buildConfigField("String", "FULL_NATIVE_ONBOARDING_SLIDE_2TO3_AD_UNIT_ID", "\"ca-app-pub-3940256099942544/2247696110\"")
            buildConfigField("String", "NATIVE_ONBOARDING_SCREEN2_NATIVE_AD_UNIT_ID", "\"ca-app-pub-3940256099942544/2247696110\"")

            manifestPlaceholders["admobAppId"] = "ca-app-pub-3940256099942544~3347511713"
        }

        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true

            buildConfigField("String", "APP_OPEN_AD_UNIT_ID", "\"ca-app-pub-2940059973343828/4089894566\"")
            buildConfigField("String", "APP_RESUME_OPEN_AD_UNIT_ID", "\"ca-app-pub-2940059973343828/4089894566\"")

            buildConfigField("String", "COLLAPSIBLE_BANNER_HOME_BOTTOM_AD_UNIT_ID", "\"ca-app-pub-2940059973343828/2060140364\"")
            buildConfigField("String", "NATIVE_LEARN_AD_UNIT_ID", "\"ca-app-pub-2940059973343828/5319215758\"")

            buildConfigField("String", "NATIVE_CATEGORIES_GRID_AD_UNIT_ID", "\"ca-app-pub-2940059973343828/9747058699\"")
            buildConfigField("String", "NATIVE_CATEGORY_IMAGELIST_AD_UNIT_ID", "\"ca-app-pub-2940059973343828/8266456066\"")
            buildConfigField("String", "COLLAPSIBLE_BANNER_CATEGORIES_BOTTOM_AD_UNIT_ID", "\"ca-app-pub-2940059973343828/4988827087\"")

            buildConfigField("String", "BANNER_SKETCH_SCREEN_AD_UNIT_ID", "\"ca-app-pub-2940059973343828/9858010387\"")
            buildConfigField("String", "INTERSTITIAL_SKETCH_PLUS_BUTTON_AD_UNIT_ID", "\"ca-app-pub-2940059973343828/2988565883\"")
            buildConfigField("String", "COLLAPSIBLE_BANNER_CANVAS_BOTTOM_AD_UNIT_ID", "\"ca-app-pub-2940059973343828/7945379090\"")

            buildConfigField("String", "BANNER_SETTINGS_TOP_AD_UNIT_ID", "\"ca-app-pub-2940059973343828/4054235544\"")
            buildConfigField("String", "APP_CLICK_INTERSTITIAL_AD_UNIT_ID", "\"ca-app-pub-2940059973343828/7220238753\"")

            buildConfigField("String", "WELCOME_SCREEN_INTERSTITIAL_AD_UNIT_ID", "\"ca-app-pub-2940059973343828/1080587840\"")

            buildConfigField("String", "AR_LANGUAGE_SCREEN_NATIVE_AD_UNIT_ID", "\"ca-app-pub-2940059973343828/2649604203\"")
            buildConfigField("String", "AR_LANGUAGE_SCREEN_2ND_NATIVE_AD_UNIT_ID", "\"ca-app-pub-2940059973343828/1321773762\"")
            buildConfigField("String", "AR_LANGUAGE_SCREEN_3RD_NATIVE_AD_UNIT_ID", "\"ca-app-pub-2940059973343828/5155564228\"")
            buildConfigField("String", "FULL_NATIVE_ONBOARDING_SLIDE_1TO2_AD_UNIT_ID", "\"ca-app-pub-2940059973343828/8959077866\"")
            buildConfigField("String", "FULL_NATIVE_ONBOARDING_SLIDE_2TO3_AD_UNIT_ID", "\"ca-app-pub-2940059973343828/4138779843\"")
            buildConfigField("String", "NATIVE_ONBOARDING_SCREEN2_NATIVE_AD_UNIT_ID", "\"ca-app-pub-2940059973343828/5180398773\"")

            manifestPlaceholders["admobAppId"] = "ca-app-pub-2940059973343828~1823201176"
        }
    }

    buildFeatures {
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