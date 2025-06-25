// android/app/build.gradle.kts
plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android") // Este es el plugin Kotlin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.todo_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        // Accede a kotlin_version desde rootProject.extra
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.example.todo_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

// **AGREGAR ESTO AL FINAL DEL ARCHIVO app/build.gradle.kts**
// Asegura que el plugin de Kotlin usa la versión definida globalmente.
dependencies {
    // Si tu proyecto usa Kotlin de alguna forma, necesitarás esta línea.
    // Aunque el plugin se aplica arriba, a veces la dependencia de la librería base
    // es necesaria para que las herramientas de IDE funcionen correctamente o para compatibilidad.
    implementation(platform("org.jetbrains.kotlin:kotlin-bom:${rootProject.extra["kotlin_version"]}"))
    // Otras dependencias aquí si las tienes, por ejemplo:
    // implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")
}

flutter {
    source = "../.."
}