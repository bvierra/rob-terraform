terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.2-rc01"
    }
    ansible = {
      source = "ansible/ansible"
      version = "1.3.0"
    }
  }
}
