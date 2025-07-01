provider "proxmox" {
  pm_api_url          = local.proxmox_api_url
  pm_tls_insecure     = var.proxmox_tls_insecure
  pm_user             = var.proxmox_api_user
  pm_password         = var.proxmox_api_password
  pm_api_token_id     = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_parallel         = var.proxmox_parallel
  pm_debug            = var.proxmox_debug
  pm_log_enable       = var.proxmox_log_enable
  pm_log_file         = var.proxmox_log_file
  pm_timeout          = var.proxmox_timeout
  pm_proxy_server     = var.proxmox_proxy_server
  pm_otp              = var.proxmox_otp
}