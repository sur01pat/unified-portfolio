android {
    namespace = "com.unifiedportfolio.portfolio"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.unifiedportfolio.portfolio"
        minSdk = flutter.minSdkVersion
        targetSdk = 35
        versionCode = 20
        versionName = "1.0.19"
    }

    signingConfigs {
        create("release") {
            val props = java.util.Properties()
            val file = rootProject.file("key.properties")
            props.load(file.inputStream())

            storeFile = rootProject.file(props["storeFile"] as String)
            storePassword = props["storePassword"] as String
            keyAlias = props["keyAlias"] as String
            keyPassword = props["keyPassword"] as String
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}
