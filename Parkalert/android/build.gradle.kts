buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Use recent Android Gradle Plugin compatible with Gradle 8.12
        classpath("com.android.tools.build:gradle:8.1.2")
        // Update Kotlin to 1.9.10
        classpath(kotlin("gradle-plugin", version = "1.9.10"))
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
