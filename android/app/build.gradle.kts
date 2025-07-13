import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // Firebase plugin
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // يجب أن يكون آخر واحد
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("../android/app/key.properties") // ✅ تم تصحيح المسار هنا
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.abolashine.theOne.abolashin"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.abolashine.theOne.abolashin"
        minSdk = 23
        targetSdk = 35
        versionCode = 4
        versionName = "1.0.4"
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties['storeFile'] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}
dependencies {
    implementation("com.google.android.material:material:1.11.0")
}