variable "wp_ssh_keys" {
  type = "string"

  default = <<EOF
username: ssh-rsa xxxx
EOF
}

variable "region" {
  default = "us-east1"
}

variable "region_zone" {
  default = "us-east1-b"
}

variable "userNumber" {
  default = "0000000"
}

variable "project" {
  default = "handson-project"
}
