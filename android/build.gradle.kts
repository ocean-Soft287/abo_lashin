allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
// Some Flutter plugins (connectivity_plus 5.x, fluttertoast 8.x, flutter_native_splash 2.4.x)
// hardcode an old compileSdk, which fails checkReleaseAarMetadata against current AndroidX.
// Raise only library modules below the app's compileSdk (Flutter's compileSdkVersion = 36).
// finalizeDsl runs after the plugin's own build.gradle, so the value is not overwritten.
val pluginMinCompileSdk = 36
subprojects {
    plugins.withId("com.android.library") {
        extensions.configure<com.android.build.api.variant.LibraryAndroidComponentsExtension> {
            finalizeDsl { android ->
                if ((android.compileSdk ?: 0) < pluginMinCompileSdk) {
                    android.compileSdk = pluginMinCompileSdk
                }
            }
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

