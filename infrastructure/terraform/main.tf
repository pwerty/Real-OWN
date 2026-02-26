# 최상위 루트: main.tf

# 1. 네트워크 모듈 인스턴스화
module "network" {
  source = "./modules/network"
}

# 2. 컴퓨트 모듈 인스턴스화 및 변수 전달
module "compute" {
  source       = "./modules/compute"
  
  # 루트가 외부(터미널)로부터 받은 토큰을 compute 모듈의 매개변수로 넘겨줌(Pass)
  github_token = var.github_token  
}

moved {
  from = google_compute_firewall.allow_http
  to   = module.network.google_compute_firewall.allow_http
}

moved {
  from = google_compute_instance.free_tier_vm
  to   = module.compute.google_compute_instance.free_tier_vm
}