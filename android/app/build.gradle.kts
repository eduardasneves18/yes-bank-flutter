plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // O Flutter Gradle Plugin deve ser aplicado após os plugins Android e Kotlin.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.yes_bank"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973" // Definindo manualmente a versão do NDK

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.yes_bank"
        minSdkVersion(23)
        targetSdkVersion(33)
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Adicione sua própria configuração de assinatura para a compilação de release.
            // Usando as chaves de depuração por enquanto, então `flutter run --release` funciona.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.." // Ajuste o caminho para o diretório do Flutter
}
