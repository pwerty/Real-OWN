# 3. 서버 구축 및 스크립트 투하 작전
resource "google_compute_instance" "free_tier_vm" {
  name         = "comrade-cs2map-server"
  machine_type = "e2-micro"

  tags = ["web-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
      # 공인 IP 발급
    }
  }
  
  service_account {
    # 인스턴스가 GCP의 API(로깅 등)를 호출할 수 있도록 권한 범위(Scope)를 지정합니다.
    # "cloud-platform"은 모든 GCP 서비스에 대한 접근을 허용하는 포괄적 권한으로, 초기 구축 시 유용합니다.
    scopes = ["cloud-platform"]
  }

metadata_startup_script = <<-EOF
    #!/bin/bash
    # 1. 기본 패키지 및 Nginx, Git 설치
    apt-get update
    apt-get install -y nginx git curl

    # 2. Node.js 설치 (최신 20.x 버전 기준)
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt-get install -y nodejs

    # 3. GitHub PAT를 이용한 Private Repo 클론
    cd /tmp
    # 토큰을 URL에 포함하여 클론 (var.github_token 변수가 치환됨)
    git clone https://${var.github_token}@github.com/pwerty/cs2-mapper.git

    # 4. 패키지 설치 및 빌드
    cd cs2-mapper
    npm install
    npm run build

    # 5. Nginx 웹 루트로 배포 (Vite는 dist, CRA는 build, Next.js(export)는 out 폴더입니다. 본인 환경에 맞게 폴더명을 수정하세요)
    rm -rf /var/www/html/*
    cp -r dist/* /var/www/html/ 

    # 6. 권한 설정 및 Nginx 재시작
    chown -R www-data:www-data /var/www/html/
    systemctl restart nginx
  EOF
}