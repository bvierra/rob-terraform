# Packer Template to create an Ubuntu Server on Proxmox
packer {
  required_plugins {
    proxmox = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

# Variable Definitions
variable "proxmox_host" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
  #default = env("PROXMOX_API_TOKEN_ID")
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
  default   = env("PKR_VAR_PROXMOX_PACKER_TOKEN")

  validation {
    condition     = length(var.proxmox_api_token_secret) > 0
    error_message = "The Packer Token for authenticating API calls in Proxmox is required."
  }
}

variable "proxmox_node" {
  type    = string
  default = "s2"
}

variable "vm_id" {
  type    = number
  default = null
}

variable "vm_name" {
  type    = string
  default = "ubuntu-server-25.04-template"
}

variable "iso_storage_pool" {
  type    = string
  default = "local"
}

variable "iso_file" {
  type    = string
  default = "ubuntu-25.04-live-server-amd64.iso"
}
variable "iso_checksum" {
  type    = string
  default = "file:http://releases.ubuntu.com/25.04/SHA256SUMS"
}

variable "vm_scsi_controller" {
  description = "The SCSI controller model to emulate. Can be lsi, lsi53c810, virtio-scsi-pci, virtio-scsi-single, megasas, or pvscsi."
  type        = string
  default     = "lsi"
}

variable "vm_disk_size" {
  type    = string
  default = "80G"
}

variable "vm_disk_io_thread" {
  description = "Create one I/O thread per storage controller, rather than a single thread for all I/O. Requires vm_scsi_controller = virtio-scsi-single and a vm_disk_type = scsi or virtio."
  type        = bool
  default     = false
}

variable "vm_disk_storage_pool" {
  type    = string
  default = "local-lvm"

}

variable "vm_disk_type" {
  description = "The type of disk. Can be scsi, sata, virtio or ide."
  type        = string
  default     = "scsi"
}

variable "vm_disk_format" {
  description = "The format of the file backing the disk. Can be raw, cow, qcow, qed, qcow2, vmdk or cloop."
  type        = string
  default     = "raw"
}

variable "vm_hostname" {
  description = "The hostname of the VM"
  type        = string
  default     = "ubuntu-server-2504"
}

variable "vm_cpu_cores" {
  type    = number
  default = 2
}

variable "vm_memory" {
  type    = number
  default = 2048
}

variable "vm_network_model" {
  type    = string
  default = "virtio"
}

variable "vm_network_bridge" {
  type    = string
  default = "vmbr0"
}

variable "vm_network_firewall" {
  type    = bool
  default = false
}

variable "vm_cloud_init_storage_pool" {
  type    = string
  default = "local-lvm"
}

variable "vm_ssh_username" {
  type    = string
  default = "root"
}

variable "vm_ssh_password_enc" {
  description = "The encrypted password to use for the user that is created on the image"
  type        = string
}


variable "vm_ssh_password" {
  description = "The password to use for SSH authentication. If not set, Packer will use the default SSH agent. Set this to null to use key files"
  type        = string
  default     = null
}

variable "vm_ssh_private_key_file" {
  description = "The existing private key to use for SSH authentication. If not set, Packer will use the default SSH agent."
  type        = string
  default     = null
}

variable "vm_ssh_public_key_file" {
  description = "The existing public key to use for SSH authentication."
  type        = string
  default     = null
}

variable "http_ip" {
  description = "The IP address that Packer will use to serve the HTTP files. By default this is set to null which uses all IP's on the host"
  type        = string
  default     = null
}

variable "packer_bind_address" {
  description = "The address that Packer will use to serve the HTTP files. By default this is set to null which uses all IP's on the host"
  type        = string
  default     = null
}

variable "packer_bind_port" {
  description = "The port that Packer will use to serve the HTTP files. By default this is set to 8000"
  type        = number
  default     = 8000
}

variable "packer_ssh_timeout" {
  description = "The timeout for SSH connections. By default this is set to 20m"
  type        = string
  default     = "20m"
}

locals {
  build_ts             = timestamp()
  iso_path             = "${var.iso_storage_pool}:iso/${var.iso_file}"
  template_description = "Ubuntu Server Plucky Puffin - Built on ${local.build_ts}"
  iso_url              = "https://releases.ubuntu.com/25.04/${var.iso_file}"

}

# Resource Definiation for the VM Template
source "proxmox-iso" "ubuntu-2504" {
  # Proxmox Connection Settings
  proxmox_url = "https://${var.proxmox_host}/api2/json"
  username    = "${var.proxmox_api_token_id}"
  token       = "${var.proxmox_api_token_secret}"
  # (Optional) Skip TLS Verification
  insecure_skip_tls_verify = true

  # VM General Settings
  node                 = "${var.proxmox_node}"
  vm_id                = "${var.vm_id}"
  vm_name              = "${var.vm_name}"
  template_description = "${local.template_description}"

  # VM ISO Settings
  boot_iso {
    #type             = "scsi"
    iso_url          = local.iso_url
    iso_checksum     = "${var.iso_checksum}"
    iso_storage_pool = "${var.iso_storage_pool}"
    unmount          = true
  }

  # VM Hard Disk Settings
  scsi_controller = "${var.vm_scsi_controller}"

  disks {
    disk_size    = "${var.vm_disk_size}"
    storage_pool = "${var.vm_disk_storage_pool}"
    type         = "${var.vm_disk_type}"
    format       = "${var.vm_disk_format}"
  }

  # VM CPU Settings
  cores = "${var.vm_cpu_cores}"

  # VM Memory Settings
  memory = "${var.vm_memory}"

  # VM Network Settings
  network_adapters {
    model    = "${var.vm_network_model}"
    bridge   = "${var.vm_network_bridge}"
    firewall = "${var.vm_network_firewall}"
  }

  serials = ["socket"]

  # VM Cloud-Init Settings
  cloud_init = false


  boot_command = ["e<wait><down><down><down><end> autoinstall 'ds=nocloud;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/'<F10>"]
  boot_wait    = "10s"

  # PACKER Autoinstall Settings
  #http_directory = "${path.root}/http"
  http_content = {
    "/user-data" = templatefile("http/user-data.pkrtpl",
      {
        hostname = var.vm_hostname,
        username = var.vm_ssh_username,
        password = var.vm_ssh_password_enc,
        ssh_key  = file(var.vm_ssh_public_key_file)
      }
    )
    "/meta-data" = ""
  }
  # This creates a webserver on all IP's of the computer RUNNING packer to serve
  # the cloud-init files for autoinstall
  http_bind_address = "10.10.10.254"
  http_port_min = "${var.packer_bind_port}"
  http_port_max = "${var.packer_bind_port}"

  ssh_username         = "${var.vm_ssh_username}"
  ssh_private_key_file = "${var.vm_ssh_private_key_file}"
  ssh_timeout          = "${var.packer_ssh_timeout}"
}

# Build Definition to create the VM Template
build {

  name    = "ubuntu-server-plucky"
  sources = ["source.proxmox-iso.ubuntu-2504"]

  # Wait for cloud-init to finish
  # clean up the instance
  # reset the machine-id
  # remove the SSH host keys
  # sync all disk writes
  # disable the ubuntu user created for provisioning.
  provisioner "shell" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
      "sudo cloud-init clean",
      "sudo rm /etc/ssh/ssh_host_*",
      "sudo truncate -s 0 /etc/machine-id",
      "sudo sync",
      "sudo passwd -d ubuntu"
    ]
  }

  # Copy the cloud-init pve config file to the vm's /tmp
  # (we are ssh as a normal user and not root,
  # so we can't write to /etc/cloud/cloud.cfg.d/99-pve.cfg directly)
  provisioner "file" {
    source      = "${path.root}/files/99-pve.cfg"
    destination = "/tmp/99-pve.cfg"
  }

  # Move the cloud-init pve config file to the vm's /etc/cloud/cloud.cfg.d/99-pve.cfg
  provisioner "shell" {
    inline = ["sudo mv /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg"]
  }
}
