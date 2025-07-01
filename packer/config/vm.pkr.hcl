proxmox_node = "s2"

vm_scsi_controller = "virtio-scsi-pci"
vm_disk_io_thread = false
vm_disk_storage_pool = "proxmox-nfs"
vm_disk_type = "virtio"
vm_disk_size = "10G"

vm_cpu_cores = 2
vm_memory = 2048

vm_network_model = "virtio"
vm_network_bridge = "vmbr0"
vm_network_firewall = false

iso_storage_pool = "proxmox-nfs"

packer_bind_address = null
packer_bind_port = 8800
packer_ssh_timeout = "30m"

http_ip = "10.10.10.254"