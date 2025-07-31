buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Use a recent Android Gradle Plugin version compatible with compileSdk 35
        classpath("com.android.tools.build:gradle:7.4.2")

        // Kotlin Gradle plugin (match the kotlin version you use in app/build.gradle.kts)
        classpath(kotlin("gradle-plugin", version = "1.8.10"))
    }
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
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
