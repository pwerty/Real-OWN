# Real OWN with Kubernetes : 유니티 원격 빌드 인프라 시스템
* 어떤 유니티 프로젝트든 소스 주소만 넣으면 즉시 빌드 가능한 범용성
* 로컬 PC의 환경에 의존하지 않는 표준화된 빌드 환경 제공
* [별도 기록 블로그](https://hyeonistic.tistory.com/category/%EA%B5%AC%ED%98%84%ED%95%98%EA%B8%B0/Home%20Lab)

## 프로젝트 개요
찍먹보다 더 딥다이브하고, 온전한 내 것을 만들기 위한 Lab


## 현재 진행
### 완료된 기능
* **기본 CI/CD 파이프라인 구현**
  - Jenkins + Kubernetes 기반 빌드 환경 구축
  - Unity CI/CD용 컨테이너 이미지 활용
  
* **고급 Unity 빌드 자동화**
  - GitHub SCM 연동 (Shallow Clone)
  - Unity 6 Linux Server 빌드 자동화
  - 동적 빌드 스크립트 주입
  - 파라미터화된 빌드 (클린 빌드 옵션)
  - 빌드 시간 측정 및 아티팩트 보관

* **Docker 이미지 자동화**
  - Kaniko를 사용한 Docker 빌드/푸시 (Docker daemon 불필요)
  - Docker Hub 자동 배포
  - 버전 태깅 (BUILD_NUMBER, latest)

* **Kubernetes 배포**
  - ArgoCD 네임스페이스 배포 설정
  - Deployment manifest 작성

* **확장 기능**
  - ChatGPT API 통합 파이프라인
  - 커스텀 스크립트 실행 파이프라인

### 진행 예정
[마일스톤 목록은 별도 추가 예정]

## 기술 스택
* Kubernetes
* Jenkins
* Docker
* Unity 6 (6000.2.7f2)
* 언어 : C#, Groovy (Jenkins Pipeline), Bash, YAML

## 개발 환경
* 홈 랩 환경
```
CPU : Xeon E5 2678v3 (10C, 20T)
RAM : DDR3 32GB (16GB * 2)
M/B : X99
SSD : Micron SATA 1TB
OS. : Ubuntu 24.04 LTS with CLI
```
