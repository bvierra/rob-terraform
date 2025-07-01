module "vm_k8s_worker" {
  source                            = "./modules/vm"
  for_each                          = { for inst in var.vm_k8s_worker_instances : inst.name => inst }
  project_name                      = var.project_name
  vm_name                           = each.value.name
  vm_target_node                    = each.value.target_node
  vm_nameserver                     = "10.10.130.1"
  vm_description                    = "Kubernetes Worker Node"

  vm_clone                          = "ubuntu-server-24.04-template"
  vm_memory_minimum                 = 4096
  vm_memory_maximum                 = 1024 * 32
  vm_numa                           = true
  vm_cores                          = 4
  vm_sockets                        = 4
  vm_cpu                            = "host"
  vm_hotplug                        = "network,disk,usb,cpu,memory"
  vm_scsi_controller                = "virtio-scsi-pci"
  vm_disk_type                      = "virtio"
  #vm_disk_storage                   = "iscsi"
  vm_disk_storage                   = "proxmox-nfs"
  vm_disk_size                      = 200
  vm_disk_format                    = "qcow2"
  vm_serial_id                      = 0
  vm_serial_type                    = "socket"

  vm_ipconfig                       = each.value.ip_defs
  vm_networks                       = var.vm_k8s_worker_networks

  vm_cloudinit_cdrom_storage        = "proxmox-nfs"
  vm_proxmox_ssh_private_key_path   = "/home/bvierra/.ssh/id_ed25519"
  vm_ssh_public_key_path            = "/home/bvierra/.ssh/id_ed25519.pub"

  vm_ssh_private_key_path           = "/home/bvierra/.ssh/id_ed25519"

  vm_proxmox_ssh_user               = var.proxmox_ssh_user
  vm_proxmox_snippets_storage_pool  = var.proxmox_snippets_storage_pool
  vm_proxmox_ssh_server             = var.proxmox_api_server
  ansible_user                      = var.ansible_user
  ansible_password                  = var.ansible_password

  templates_folder                  = var.templates_folder
  generated_folder                  = var.generated_folder
  vm_tags                           = "k8s-worker"

}

resource "ansible_host" "k8s_worker" {
  for_each  = { for inst in var.vm_k8s_worker_instances : inst.name => inst }
  name      = each.value.name
  groups    = ["kube_node"]
  variables = {
    ansible_user = var.ansible_user
    ansible_ssh_private_key_file = "/home/bvierra/.ssh/id_ed25519"
    ansible_ssh_common_args = "-o StrictHostKeyChecking=no"
    ansible_host = each.value.ip
    ansible_become = true
    ansible_become_user = "root"
  }
}

output "info_worker" {
    value = {
      for vm in var.vm_k8s_worker_instances: vm.name => vm.ip
    }
}

# vim: set ft=jinja-properties softtabstop=2 shiftwidth=2 tabstop=2 expandtab

