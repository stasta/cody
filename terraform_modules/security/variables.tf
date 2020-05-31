variable "vpc_id" {
  type = "string"
}

variable "whitelisted_ssh_ips" {
  type = "list"
}

variable "keypair_path" {
  type    = "string"
  default = "~./ssh/" //TODO
}

variable "keypair_public_key_file" {
  type    = "string"
  default = "/Users/gustavofernandes/.ssh/cody_rsa.pub" //TODO
}
