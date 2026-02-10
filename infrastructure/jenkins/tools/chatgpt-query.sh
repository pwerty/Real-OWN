#!/bin/bash

###############################################################################
# ChatGPT API Query Script
# 
# Description:
#   This script sends a question to ChatGPT API and prints the response.
#
# Usage:
#   ./chatgpt-query.sh "Your question here"
#
# Requirements:
#   - OpenAI API Key must be stored in: /home/dabi/.chatgpt_api_key
#   - curl and jq must be installed
###############################################################################

set -e

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# API 키 파일 경로
API_KEY_FILE="/home/dabi/.chatgpt_api_key"

# 인자 확인
if [ $# -eq 0 ]; then
    echo -e "${RED}❌ ERROR: No question provided${NC}"
    echo -e "${YELLOW}Usage: $0 \"Your question here\"${NC}"
    exit 1
fi

QUESTION="$1"

# API 키 파일 존재 확인
if [ ! -f "$API_KEY_FILE" ]; then
    echo -e "${RED}❌ ERROR: API key file not found at $API_KEY_FILE${NC}"
    echo -e "${YELLOW}Please create the file with your OpenAI API key:${NC}"
    echo -e "${BLUE}echo 'your-api-key-here' > $API_KEY_FILE${NC}"
    echo -e "${BLUE}chmod 600 $API_KEY_FILE${NC}"
    exit 1
fi

# API 키 읽기
API_KEY=$(cat "$API_KEY_FILE" | tr -d '[:space:]')

if [ -z "$API_KEY" ]; then
    echo -e "${RED}❌ ERROR: API key file is empty${NC}"
    exit 1
fi

# jq 설치 확인
if ! command -v jq &> /dev/null; then
    echo -e "${RED}❌ ERROR: jq is not installed${NC}"
    echo -e "${YELLOW}Please install jq:${NC}"
    echo -e "${BLUE}  Ubuntu/Debian: sudo apt-get install jq${NC}"
    echo -e "${BLUE}  macOS: brew install jq${NC}"
    exit 1
fi

echo -e "${BLUE}================================================${NC}"
echo -e "${GREEN}🤖 ChatGPT Query${NC}"
echo -e "${BLUE}================================================${NC}"
echo -e "${YELLOW}Question:${NC} $QUESTION"
echo -e "${BLUE}================================================${NC}"
echo ""

# API 요청
RESPONSE=$(curl -s https://api.openai.com/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d "{
    \"model\": \"gpt-4\",
    \"messages\": [
      {
        \"role\": \"user\",
        \"content\": \"$QUESTION\"
      }
    ],
    \"temperature\": 0.7
  }")

# 에러 체크
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
    ERROR_MSG=$(echo "$RESPONSE" | jq -r '.error.message')
    echo -e "${RED}❌ API Error: $ERROR_MSG${NC}"
    exit 1
fi

# 답변 추출 및 출력
ANSWER=$(echo "$RESPONSE" | jq -r '.choices[0].message.content')

if [ -z "$ANSWER" ] || [ "$ANSWER" = "null" ]; then
    echo -e "${RED}❌ ERROR: Failed to get response from ChatGPT${NC}"
    echo -e "${YELLOW}Raw Response:${NC}"
    echo "$RESPONSE" | jq '.'
    exit 1
fi

echo -e "${GREEN}📝 Answer:${NC}"
echo "================================================"
echo "$ANSWER"
echo "================================================"
echo ""

# 토큰 사용량 출력
TOKENS_USED=$(echo "$RESPONSE" | jq -r '.usage.total_tokens')
echo -e "${BLUE}ℹ️  Tokens used: $TOKENS_USED${NC}"
