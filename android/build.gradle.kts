// Define las versiones de las dependencias clave aquí
buildscript {
    repositories {
        google()
        mavenCentral() // Corrected: lowercase 'c'
    }
    dependencies {
        // Asegúrate de que esta sea una versión compatible con tu Flutter 3.32.4
        // Por ejemplo, 7.3.0, 7.4.x, 8.1.x, etc. Aquí usaremos 8.1.4 como ejemplo reciente.
        classpath("com.android.tools.build:gradle:8.1.4")
        // ¡Esta línea es CRUCIAL! Asegura la versión del plugin de Google Services.
        // Utiliza la última versión estable (4.4.1 es muy común y compatible)
        classpath("com.google.gms:google-services:4.4.1")
    }
}

// Define kotlin_version a nivel de rootProject para que sea accesible globalmente
// Esta es la forma preferida en muchos proyectos Kotlin DSL para variables globales.
rootProject.ext.set("kotlin_version", "1.9.0") // O "1.8.0" si 1.9.0 causa problemas

allprojects {
    repositories {
        google()
        mavenCentral() // Corrected: lowercase 'c'
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