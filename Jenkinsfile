pipeline {
    agent any

    environment {
        FLUTTER_HOME = "/home/sujay/flutter"
        JAVA_HOME = "/usr/lib/jvm/java-21-openjdk-amd64"
        ANDROID_SDK_ROOT = "/home/sujay/android-sdk"
        PATH = "${FLUTTER_HOME}/bin:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${JAVA_HOME}/bin:${env.PATH}"
        GRADLE_OPTS = "-Dorg.gradle.daemon=false -Dorg.gradle.jvmargs=-Xmx2048m"
    }


    options {
        timeout(time: 20, unit: 'MINUTES')
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    def gitRepoUrl = 'https://github.com/SujayGangan/my-notes-app-flutter.git'
                    checkout([$class: 'GitSCM',
                        branches: [[name: '*/main']],
                        userRemoteConfigs: [[url: gitRepoUrl]],
                        extensions: [[$class: 'CleanBeforeCheckout']]
                    ])
                }
            }
        }

        stage('Flutter Version Check') {
            steps {
                sh '''
                echo "🔍 Checking Flutter version..."
                flutter --version || { echo "❌ Flutter not found!"; exit 1; }
                '''
            }
        }

        stage('Accept Android Licenses') {
            steps {
                sh '''
                echo "📄 Accepting Android SDK Licenses..."
                yes | sdkmanager --licenses || { echo "❌ Failed to accept licenses!"; exit 1; }
                '''
            }
        }

        stage('Get Dependencies') {
            steps {
                sh '''
                echo "📦 Getting Flutter dependencies..."
                flutter pub get || { echo "❌ Failed to get dependencies!"; exit 1; }
                '''
            }
        }

        stage('Analyze Code') {
            steps {
                sh '''
                echo "🧐 Running Flutter analyze..."
                flutter analyze || { echo "❌ Code analysis failed!"; exit 1; }
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                echo "🧪 Running Flutter tests..."
                flutter test || { echo "❌ Tests failed!"; exit 1; }
                '''
            }
        }

        stage('Build APK') {
            steps {
                sh '''
                echo "📦 Building Flutter APK..."
                export ORG_GRADLE_PROJECT_flutterBuildMode=release
                flutter build apk --release -v || { echo "❌ APK build failed!"; exit 1; }
                '''
            }
        }

        stage('Deploy / Output') {
            steps {
                //        sh 'echo "ENV VAR: $MY_ENV_VAR"'
                sh '''
                echo "🚀 Build complete! Checking output..."
                ls -lah build/app/outputs/flutter-apk/ || { echo "❌ APK output not found!"; exit 1; }
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Flutter build pipeline completed successfully!'
        }
        failure {
            echo '❌ Flutter build pipeline failed!'
        }
    }
}
