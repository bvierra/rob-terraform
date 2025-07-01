#####################################
# Provider Proxmox Variables        #
#####################################
variable "proxmox_api_server" {
  description = "Hostname or IP of the Proxmox API server"
  type = string
  default = "proxmox-server01.example.com"
}

variable "proxmox_api_port" {
  description = "Port of the Proxmox API server"
  type = number
  default = 8006
}

variable "proxmox_tls_insecure" {
  description = "Whether to skip TLS verification for the Proxmox API server"
  type = bool
  default = true
}

variable "proxmox_api_token_id" {
  description = "Proxmox API token ID (can also use env var PM_API_TOKEN_ID)"
  type = string
  default = null
}

variable "proxmox_api_token_secret" {
  description = "Proxmox API token secret (can also use env var PM_API_TOKEN_SECRET)"
  type = string
  default = null
}

variable "proxmox_api_user" {
  description = "Proxmox API user (can also use env var PM_API_USER)"
  type = string
  default = null
}

variable "proxmox_api_password" {
  description = "Proxmox API password (can also use env var PM_API_PASSWORD)"
  type = string
  default = null
}

variable "proxmox_parallel" {
  description = "The number of parallel tasks to run"
  type = number
  default = 4
}

variable "proxmox_debug" {
  description = "Enable verbose output to STDOUT for the Proxmox provider"
  type = bool
  default = false
}

variable "proxmox_log_enable" {
  description = "Enable debug logging for the Proxmox provider"
  type = bool
  default = false
}

variable "proxmox_log_file" {
  description = "The file to log debug output to when proxmox_log_enable is true"
  type = string
  default = "terraform-plugin-proxmox.log"
}

variable "proxmox_timeout" {
  description = "The timeout for the Proxmox provider"
  type = number
  default = "300"
}

variable "proxmox_proxy_server" {
  description = "Send provider api call to a proxy server"
  type = string
  default = null
}

variable "proxmox_otp" {
  description = "One-time password for two-factor authentication"
  type = string
  default = null
}

variable "proxmox_ssh_user" {
  description = "The SSH user to use for uploading cloud-init files to the Proxmox server"
  type = string
  default = "root"
}

variable "proxmox_ssh_private_key_path" {
  description = "The path to the SSH private key used to upload cloud-init files to the Proxmox server"
  type = string
  default = null
}

variable "proxmox_snippets_storage_pool" {
  description = "The storage pool to store the cloud-init snippets"
  type = string
  default = "local"
}


#####################################
# Locals                            #
#####################################

locals {
  proxmox_api_url = "https://${var.proxmox_api_server}:${var.proxmox_api_port}/api2/json"

}

#####################################
# Variables                         #
#####################################
variable "ansible_user" {}
variable "ansible_password" {}
variable "domain_name" {}

variable "project_name" {
  description = "The name of the project"
  type = string
}

variable "templates_folder" {
  description = "The location of the templates folder"
  type = string
  default = "./templates"
}

variable "generated_folder" {
  description = "The location of the folder that will hold generated files"
  type = string
  default = "./generated"
}

variable "vm_k8s_control_instances" {
  type = list(object({
    name = string
    target_node = string
    ip = string
    ip_defs = list(string)
  }))
}

variable "vm_k8s_control_networks" {
  type = list(object({
    id        = number
    bridge    = string
    firewall  = bool
    link_down = bool
    model     = string
    tag       = number
  }))
}

variable "vm_k8s_worker_instances" {
  type = list(object({
    name = string
    target_node = string
    ip = string
    ip_defs = list(string)
  }))
}

variable "vm_k8s_worker_networks" {
  type = list(object({
    id        = number
    bridge    = string
    firewall  = bool
    link_down = bool
    model     = string
    tag       = number
  }))
}
