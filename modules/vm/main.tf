# use Telmate/proxmox 3.0.1-rc1 provider
terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.2-rc01"
    }
  }
}

# Load the file from var.vm_ssh_private_key_path and var.vm_ssh_public_key_path as local sensitive files to keep the contents from being displayed in the plan output
data "local_sensitive_file" "ssh_private_key" {
  filename      = var.vm_ssh_private_key_path
}
data "local_sensitive_file" "ssh_public_key" {
  filename      = var.vm_ssh_public_key_path
}

# Create the cloud-init file from template and store into the generated folder
resource "local_sensitive_file" "cloud_init" {
  content   = templatefile(local.template_ci_userdata_filename, {
    hostname            = var.vm_name,
    fqdn                = "${var.vm_name}.${var.vm_domain_name}",
    ansible_user        = var.ansible_user,
    ansible_password    = var.ansible_password,
    ansible_public_key  = data.local_sensitive_file.ssh_public_key.content,
    serial_added        = local.serial_added
  })
  filename  = "${var.generated_folder}/cloud-init/${var.project_name}-${var.vm_name}-cloud_init.yml"
  file_permission = "0644"
}

# Transfer the cloud-init file from the generated folder to the Proxmox server
# This only triggers if the sha1 from the cloud_init creation changes
resource "null_resource" "cloud_init" {
  connection {
    type        = "ssh"
    user        = var.vm_proxmox_ssh_user
    private_key = file(var.vm_proxmox_ssh_private_key_path)
    host        = var.vm_proxmox_ssh_server
  }

  provisioner "file" {
    source       = local_sensitive_file.cloud_init.filename
    destination  = "/mnt/pve/${var.vm_proxmox_snippets_storage_pool}/snippets/${var.project_name}-${var.vm_name}-cloud_init.yml"
  }

  triggers = {
    cloud_init_sh1 = resource.local_sensitive_file.cloud_init.content_sha1
  }
}


resource "proxmox_vm_qemu" "vm" {
  depends_on = [
    null_resource.cloud_init
   ]
  name          = var.vm_name
  target_node   = var.vm_target_node
  clone         = var.vm_clone
  full_clone    = var.vm_full_clone
  hastate       = var.vm_hastate
  hagroup       = var.vm_hagroup
  agent         = var.vm_agent
  desc          = var.vm_description
  qemu_os       = var.vm_qemu_os
  balloon       = var.vm_memory_minimum
  memory        = var.vm_memory_maximum
  
  
  #vcpus         = var.vm_cpu
  hotplug       = var.vm_hotplug
  scsihw        = var.vm_scsi_controller
  pool          = var.vm_pool


  cpu {
    cores         = var.vm_cores
    numa          = var.vm_numa
    sockets       = var.vm_sockets
    type          = "host"

  }

  disks {
    virtio {
      virtio0 {
        disk {
          storage          = var.vm_disk_storage
          size             = var.vm_disk_size
          format           = var.vm_disk_format
          iothread         = var.vm_scsi_controller == "virtio-scsi-single" ? true : false
          cache            = var.vm_disk_cache
        }
      }
    }
    ide {
      ide3 {
        cloudinit {
          storage = var.vm_cloudinit_cdrom_storage
        }
      }
    }
  }

  serial {
    id          = var.vm_serial_id
    type        = var.vm_serial_type
  }

  os_type                 = "cloud-init"
  nameserver              = var.vm_nameserver
  cicustom                = "user=${var.vm_proxmox_snippets_storage_pool}:snippets/${var.project_name}-${var.vm_name}-cloud_init.yml"


  ipconfig0               = length(var.vm_ipconfig) >= 1 ? var.vm_ipconfig[0] : null
  ipconfig1               = length(var.vm_ipconfig) >= 2 ? var.vm_ipconfig[1] : null
  ipconfig2               = length(var.vm_ipconfig) >= 3 ? var.vm_ipconfig[2] : null
  ipconfig3               = length(var.vm_ipconfig) >= 4 ? var.vm_ipconfig[3] : null
  ipconfig4               = length(var.vm_ipconfig) >= 5 ? var.vm_ipconfig[4] : null
  ipconfig5               = length(var.vm_ipconfig) >= 6 ? var.vm_ipconfig[5] : null
  ipconfig6               = length(var.vm_ipconfig) >= 7 ? var.vm_ipconfig[6] : null
  ipconfig7               = length(var.vm_ipconfig) >= 8 ? var.vm_ipconfig[7] : null
  ipconfig8               = length(var.vm_ipconfig) >= 9 ? var.vm_ipconfig[8] : null


  dynamic "network" {
    for_each = var.vm_networks
    iterator = network
    content {
      id        = network.value["id"]
      model     = network.value["model"]
      bridge    = network.value["bridge"]
      tag       = network.value["tag"]
      firewall  = network.value["firewall"]
      link_down = network.value["link_down"]
    }
  }

  force_recreate_on_change_of = resource.local_sensitive_file.cloud_init.content_sha1
  #tags	= var.vm_tags

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = var.ansible_user
      host        = self.ssh_host
      private_key = data.local_sensitive_file.ssh_private_key.content
    }
    on_failure = continue
    inline = [
      "cloud-init status --wait"
    ]
  }  
}

