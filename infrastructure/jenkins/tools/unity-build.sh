#!/bin/bash
set -e

# 1. 라이선스 파일 복원
echo "${LICENSE_DATA}" | base64 -d > unity_license.ulf

# 2. 라이선스 활성화
echo "--- Activating License ---"
xvfb-run --auto-servernum --server-args='-screen 0 1024x768x24' \
unity-editor \
    -batchmode \
    -nographics \
    -manualLicenseFile unity_license.ulf \
    -quit \
    -logFile /dev/stdout

# 3. manifest.json 수정 (테스트 프레임워크 제거)
if [ -f "${PROJECT_PATH}/Packages/manifest.json" ]; then
    sed -i '/com.unity.test-framework/d' "${PROJECT_PATH}/Packages/manifest.json"
fi

# 4. 빌드 스크립트 생성
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

# 5. 실제 빌드 실행
echo "--- Starting Actual Build ---"
xvfb-run --auto-servernum --server-args='-screen 0 1024x768x24' \
unity-editor \
    -batchmode \
    -nographics \
    -projectPath "${PROJECT_PATH}" \
    -executeMethod BuildScript.BuildLinuxServer \
    -quit \
    -logFile /dev/stdout

# 마무리: 라이선스 파일 삭제
rm unity_license.ulf