terraform {

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  backend "gcs" {
    bucket = "tf-state-sample"
    prefix = "terraform/state"
  }

}


provider "google" {
  project = "project-fe6e3124-4492-4fae-92c" # (주의: 프로젝트 '이름'이 아니라 영문/숫자로 된 'ID'입니다)
  region  = "us-west1"
  zone    = "us-west1-a"
}