#!/bin/bash

################################################################################
# Hello World Example Script
# 
# 이 스크립트는 Jenkinsfile-custom-script 테스트용 예제입니다.
################################################################################

set -e  # 에러 발생 시 즉시 중단

echo "========================================"
echo "👋 Hello from Custom Script!"
echo "========================================"
echo ""
echo "📍 Current Directory: $(pwd)"
echo "📅 Current Time: $(date)"
echo "🖥️  Hostname: $(hostname)"
echo "👤 User: $(whoami)"
echo ""

# 인자가 전달되었는지 확인
if [ $# -gt 0 ]; then
    echo "📦 Received Arguments:"
    for i in "$@"; do
        echo "  - $i"
    done
    echo ""
fi

# 환경변수 출력 (예제)
echo "🔧 Environment Variables:"
echo "  - HOME: ${HOME}"
echo "  - WORKSPACE: ${WORKSPACE:-'Not set'}"
echo "  - BUILD_NUMBER: ${BUILD_NUMBER:-'Not set'}"
echo ""

# Git 정보 확인 (Real-OWN 저장소에서)
if [ -d ".git" ]; then
    echo "📚 Git Information:"
    echo "  - Branch: $(git branch --show-current)"
    echo "  - Latest Commit: $(git log -1 --oneline)"
    echo ""
fi

# 작업 디렉토리 구조 확인
echo "📂 Repository Structure:"
ls -lh
echo ""

echo "========================================"
echo "✅ Script completed successfully!"
echo "========================================"

exit 0
