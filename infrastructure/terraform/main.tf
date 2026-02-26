# 최상위 루트

# 네트워크 모듈 인스턴스화
module "network" {
  source = "./modules/network"
}

# 컴퓨트 모듈 인스턴스화 및 변수 전달
module "compute" {
  source = "./modules/compute"

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

output "vm_ip" {
  value = module.compute.vm_public_ip
}