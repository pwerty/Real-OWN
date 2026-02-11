pipeline {
    agent {
        label 'unity-builder'
}
        parameters {
        booleanParam(name: 'CLEAN_LIBRARY', defaultValue: false, description: '체크하면 Library 폴더를 완전히 삭제하고 클린 빌드를 수행합니다.')
    }
    

    environment {
        // Jenkins 워크스페이스를 유니티 홈 디렉토리로 설정 (권한 및 경로 에러 방지)
        HOME = "${WORKSPACE}"
        // 실제 유니티 프로젝트가 위치한 상대 경로
        PROJECT_PATH = 'unity/elysianforest'
    }

    stages {
stage('1. Lightweight Checkout') {
            steps {
                // [확장] PVC에 남은 데이터를 기반으로 변경된 페이지만 빠르게 가져옵니다.
                checkout([$class: 'GitSCM', 
                    branches: [[name: 'main']],
                    extensions: [[$class: 'CloneOption', depth: 1, shallow: true]],
                    userRemoteConfigs: [[url: 'https://github.com/pwerty/Real-OWN.git']]
                ])
            }
        }

stage('2. Unity Build') {
            steps {
                script {
                    def startTime = System.currentTimeMillis()
                    container('unity') {
                        withCredentials([string(credentialsId: 'UNITY_LICENSE', variable: 'LICENSE_DATA')]) {
                            sh """#!/bin/bash
                            set -e
                            
                            # [핵심] 인자값에 따라 Library 폴더 삭제 여부 결정
                            if [ "${params.CLEAN_LIBRARY}" == "true" ]; then
                                echo "--- [Option] CLEAN_LIBRARY is true. Deleting Library folder... ---"
                                rm -rf "${PROJECT_PATH}/Library"
                            else
                                echo "--- [Option] CLEAN_LIBRARY is false. Using existing Library cache... ---"
                            fi

                            # -------------------------------------------------------
                            # 1. 라이선스 복원 및 활성화
                            # [의도] 컨테이너는 휘발성이므로 실행 시마다 라이선스를 새로 주입해야 함
                            # -------------------------------------------------------
                            echo "${LICENSE_DATA}" | base64 -d > unity_license.ulf

                            echo "--- Activating Unity License ---"
                            # xvfb-run: 가상 모니터를 생성하여 유니티가 그래픽 장치를 찾지 못해 죽는 현상 방지
                            xvfb-run --auto-servernum --server-args='-screen 0 1024x768x24' \
                            unity-editor \
                                -batchmode \
                                -nographics \
                                -manualLicenseFile unity_license.ulf \
                                -quit \
                                -logFile /dev/stdout

                            # -------------------------------------------------------
                            # 2. 의존성 클린업
                            # [의도] CI 환경에서 컴파일 에러를 유발하는 테스트 프레임워크 등을 강제 제거
                            # -------------------------------------------------------
                            echo "--- Cleaning Manifest ---"
                            if [ -f "${PROJECT_PATH}/Packages/manifest.json" ]; then
                                sed -i '/com.unity.test-framework/d' "${PROJECT_PATH}/Packages/manifest.json"
                            fi

                            # -------------------------------------------------------
                            # 3. 빌드 스크립트 동적 생성
                            # [의도] 프로젝트 소스에 빌드 코드를 포함시키지 않고, 빌드 시점에 주입하여 유연성 확보
                            # -------------------------------------------------------
                            mkdir -p "${PROJECT_PATH}/Assets/Editor"
                            cat <<EOF > "${PROJECT_PATH}/Assets/Editor/BuildScript.cs"
using UnityEditor;
public class BuildScript {
    public static void BuildLinuxServer() {
        BuildPlayerOptions options = new BuildPlayerOptions();
        options.scenes = new[] { "Assets/Scenes/SampleScene.unity" }; 
        options.locationPathName = "Builds/Linux/ElysianForest.x86_64";
        options.target = BuildTarget.StandaloneLinux64;
        BuildPipeline.BuildPlayer(options);
    }
}
EOF

                            # -------------------------------------------------------
                            # 4. 실제 빌드 실행
                            # [의도] 배포 가능한 리눅스 실행 파일(.x86_64) 생성
                            # -------------------------------------------------------
                            echo "--- Starting Actual Unity Build ---"
                            xvfb-run --auto-servernum --server-args='-screen 0 1024x768x24' \
                            unity-editor \
                                -batchmode \
                                -nographics \
                                -projectPath "${PROJECT_PATH}" \
                                -executeMethod BuildScript.BuildLinuxServer \
                                -quit \
                                -logFile /dev/stdout

                            # 보안을 위해 사용한 라이선스 파일 삭제
                            rm unity_license.ulf
                            """
                        }
                    }

                    // [의도] 빌드 소요 시간 계산 및 로그 출력
                    def endTime = System.currentTimeMillis()
                    def duration = (endTime - startTime) / 1000
                    echo "-------------------------------------------------------"
                    echo "✅ BUILD SUCCESSFUL"
                    echo "⏱️ Total Pipeline Duration: ${duration} seconds"
                    echo "-------------------------------------------------------"
                }
            }
            
            post {
                success {
                    // [의도] 생성된 빌드 결과물을 Jenkins 서버로 보관 (추후 배포 단계에서 사용)
                    archiveArtifacts artifacts: "${PROJECT_PATH}/Builds/Linux/**", fingerprint: true
                }
            }
        }
    }
}