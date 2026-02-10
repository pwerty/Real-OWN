#!/bin/bash

################################################################################
# Post-Pull Runner
# 
# GitHub Actions가 코드를 동기화한 후 Jenkins에서 자동으로 실행되는 스크립트
# 여기에 원하는 작업을 추가하면 됩니다.
################################################################################

set -e  # 에러 발생 시 즉시 중단
set -o pipefail

# 색상 코드
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "========================================"
echo -e "${BLUE}🚀 Post-Pull Tasks Starting...${NC}"
echo "========================================"
echo ""

# Real-OWN 저장소 위치
# Kubernetes Pod에서는 /mnt/Real-OWN에 마운트됨
REPO_PATH="${REPO_PATH:-/mnt/Real-OWN}"
TOOLS_PATH="${REPO_PATH}/infrastructure/jenkins/tools"

# 디렉토리 존재 확인
if [ ! -d "${TOOLS_PATH}" ]; then
    echo -e "${RED}❌ Error: Tools directory not found at ${TOOLS_PATH}${NC}"
    echo "Repository path: ${REPO_PATH}"
    exit 1
fi

cd "${TOOLS_PATH}"

# ========================================
# 작업 1: Hello 스크립트 실행
# ========================================
echo -e "${GREEN}📋 Task 1: Running hello.sh${NC}"
chmod +x hello.sh
./hello.sh
echo ""

# ========================================
# 작업 2: 추가 작업 (필요시 주석 해제)
# ========================================
# echo -e "${GREEN}📋 Task 2: Running deploy.sh${NC}"
# chmod +x deploy.sh
# ./deploy.sh
# echo ""

# ========================================
# 작업 3: 또 다른 작업
# ========================================
# echo -e "${GREEN}📋 Task 3: Running backup.sh${NC}"
# chmod +x backup.sh
# ./backup.sh
# echo ""

echo "========================================"
echo -e "${GREEN}✅ All Post-Pull Tasks Completed!${NC}"
echo "========================================"

exit 0
