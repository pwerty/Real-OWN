// Example: How to call shell script from Jenkins Pipeline
pipeline {
    agent { label 'unity-builder' }
    
    environment {
        HOME = "${WORKSPACE}"
        PROJECT_PATH = 'unity/elysianforest'
        TOOLS_DIR = 'infrastructure/jenkins/tools'
    }

    stages {
        stage('Hello World') {
            steps {
                // 방법 1: sh 스크립트를 직접 실행
                sh '''
                    chmod +x infrastructure/jenkins/tools/hello.sh
                    ./infrastructure/jenkins/tools/hello.sh
                '''
                
                // 방법 2: 환경 변수를 사용하여 실행
                sh """
                    chmod +x \${TOOLS_DIR}/hello.sh
                    \${TOOLS_DIR}/hello.sh
                """
            }
        }
        
        stage('Main Build Process') {
            steps {
                // 여기서 실제 빌드 스크립트를 호출할 수 있습니다
                script {
                    echo "Main build logic would go here"
                    // sh "${TOOLS_DIR}/build.sh"
                }
            }
        }
    }
    
    post {
        success {
            echo "Build completed successfully!"
        }
        failure {
            echo "Build failed!"
        }
    }
}

// ============================================================
// 참고: Groovy에서 쉘 스크립트를 호출하는 여러 방법
// ============================================================

// 1. 단일 명령어 실행
// sh 'echo "Hello"'

// 2. 여러 줄 실행 (싱글 쿼트 - 변수 치환 없음)
// sh '''
//     echo "Line 1"
//     echo "Line 2"
// '''

// 3. 여러 줄 실행 (더블 쿼트 - 변수 치환 있음)
// sh """
//     echo "Project: ${PROJECT_PATH}"
//     echo "Workspace: ${WORKSPACE}"
// """

// 4. 반환값 캡처
// def result = sh(script: 'echo "output"', returnStdout: true).trim()

// 5. 종료 코드 캡처
// def exitCode = sh(script: 'exit 0', returnStatus: true)

// 6. script 블록 내에서 Groovy 로직과 혼합
// script {
//     def files = sh(script: 'ls -la', returnStdout: true)
//     echo "Files: ${files}"
// }
