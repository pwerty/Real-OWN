variable "github_token" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true # 콘솔 출력 시 값을 숨김 처리
}