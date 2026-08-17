pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.11.1" apply false
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
}

include(":app")

// --- Needed for google_mobile_ads NativeAdFactory ---
val flutterProjectRoot = rootDir.parentFile.toPath()
val depsFile = File(flutterProjectRoot.toFile(), ".flutter-plugins-dependencies")
if (depsFile.exists()) {
    val json = groovy.json.JsonSlurper().parseText(depsFile.readText()) as Map<*, *>
    val pluginsMap = json["plugins"] as Map<*, *>
    val androidPlugins = pluginsMap["android"] as List<Map<*, *>>
    androidPlugins.forEach { plugin ->
        val name = plugin["name"] as String
        val path = plugin["path"] as String
        val pluginDirectory = File(path, "android")
        include(":$name")
        project(":$name").projectDir = pluginDirectory
    }
}