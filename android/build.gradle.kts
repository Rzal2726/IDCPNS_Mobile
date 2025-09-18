buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.3.2")
        classpath("com.google.gms:google-services:4.4.2")
    }
}

extra.apply {
    set("compileSdkVersion", 35)
    set("targetSdkVersion", 35)
    set("minSdkVersion", 21)
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    // force apply compileSdk ke semua subproject (library termasuk)
    afterEvaluate {
        if (plugins.hasPlugin("com.android.library") || plugins.hasPlugin("com.android.application")) {
            extensions.configure<com.android.build.gradle.BaseExtension> {
                compileSdkVersion(rootProject.extra["compileSdkVersion"] as Int)
                defaultConfig {
                    minSdk = rootProject.extra["minSdkVersion"] as Int
                    targetSdk = rootProject.extra["targetSdkVersion"] as Int
                }
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
