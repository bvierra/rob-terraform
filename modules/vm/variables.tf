variable "project_name" {
  description = "The name of the project"
  type = string
}
variable "vm_name" {
  description = "The name of the VM"
  type = string
}

variable "vm_target_node" {
  description = "The name of the Proxmox node to create the VM on"
  type = string
}

variable "vm_clone" {
  description = "The name of the template to clone"
  type = string
}

variable "vm_full_clone" {
  description = "Whether to do a full clone or not"
  type = bool
  default = true
}

variable "vm_hastate" {
  description = "The HA state of the VM"
  type = string
  default = null
}

variable "vm_hagroup" {
  description = "The HA group of the VM"
  type = string
  default = null
}

variable "vm_agent" {
  description = "If qemu-guest agent is running on the VM"
  type = number
  default = 1
}

variable "vm_description" {
  description = "The description to set for the VM"
  type = string
  default = " "
}

variable "vm_qemu_os" {
  description = "The OS of the VM"
  type = string
  default = "l26"
}

variable "vm_memory_minimum" {
  description = "The minimum amount of memory to allocate to the VM (in MB). If set to 0 then ballooning is disabled"
  type = number
  default = 512
}

variable "vm_memory_maximum" {
  description = "The maximum amount of memory to allocate to the VM (in MB). If vm_memory_minimum is set to 0 (ballooning disabled) then this is the static amount"
  type = number
  default = 1024
}

variable "vm_numa" {
  description = "Enable NUMA on the VM (if enabled vm_cores should be set to the number of nodes in the NUMA topology)"
  type = bool
  default = false
}

variable "vm_sockets" {
  description = "The number of sockets to allocate to the VM"
  type = number
  default = 1
}

variable "vm_cores" {
  description = "The number of cores to allocate to the VM"
  type = number
  default = 1
}

variable "vm_cpu" {
  description = "The CPU type to allocate to the VM"
  type = string
  default = "host"
}

variable "vm_hotplug" {
  description = "Hotplug features to enable on the VM. Valid values are network,disk,usb,cpu,memory (cpu,memory both require vm_numa to be set to true)"
  type = string
  default = "network,disk,usb"
}

variable "vm_scsi_controller" {
  description = "The SCSI controller model to emulate. Can be lsi, lsi53c810, virtio-scsi-pci, virtio-scsi-single, megasas, or pvscsi."
  type = string
  default = "lsi"
}

variable "vm_pool" {
  description = "The storage pool to create the VM in"
  type = string
  default = null
}

variable "vm_os_type" {
  description = "The OS type of the VM"
  type = string
  default = "ubuntu"
}

variable "vm_disk_type" {
  description = "The disk type of the hdd in the VM. Options: ide, sata, scsi, virtio."
  type = string
  default = "scsi"
}

variable "vm_disk_storage" {
  description = "The storage pool to ciscsireate the VM disk in"
  type = string
  default = "local"
}

variable "vm_disk_size" {
  description = "The size of the VM disk"
  type = number
  default = "20"
}

variable "vm_disk_format" {
  description = "The format of the VM disk"
  type = string
  default = "raw"
}

variable "vm_disk_ssd" {
  description = "Whether the VM disk is an SSD or not"
  type = number
  default = 0
}

variable "vm_disk_iothread" {
    description = "Create one I/O thread per storage controller, rather than a single thread for all I/O. Requires vm_scsi_controller = virtio-scsi-single and a vm_disk_type = scsi or virtio."
    type = number
    default = 1
}

variable "vm_disk_cache" {
  description = "The cache mode of the VM disk. Options: directsync, none, unsafe, writeback, writethrough"
  type = string
  default = "none"
}

variable "vm_networks" {
  description = "The network configuration for the VM"
  type = list(object({
    id        = number
    bridge    = string
    firewall  = bool
    link_down = bool
    model     = string
    tag       = number
  }))
  default = [
    {
      id        = 0
      bridge    = "vmbr0"
      firewall  = false
      link_down = false
      model     = "virtio"
      tag       = -1
    }
  ]
}

variable "vm_serial_id" {
  description = "The ID of the serial device for the VM. Must be unique, and between 0-3 or null to not create a serial device"
  type = number
  default = null
}

variable "vm_serial_type" {
  description = "The type of the serial device for the VM. Can be socket or a dev on the host (e.g. /dev/ttyS0), if you do this you cannot migrate the VM"
  type = string
  default = null
}

variable "vm_cloudinit_cdrom_storage" {
  description = "The storage pool to create the cloud-init cdrom in"
  type = string
  default = "local"
}

variable "vm_ssh_user" {
  description = "The SSH user to use to connect to the VM"
  type = string
  default = "root"
}

variable "vm_ssh_private_key_path" {
  description = "The path the the ssh private key to connect to the VM with"
  type = string
  default = null
}

variable "vm_ssh_public_key_path" {
  description = "The path the the ssh public key to connect to provision with"
  type = string
  default = null
}

variable "vm_domain_name" {
  description = "The domain for the VM"
  type = string
  default = "localdomain"
}

variable "vm_ipconfig" {
  description = "The static IP configuration for the VM, should be 'ip=dhcp' if using DHCP. Format: ip=10.10.120.254/24,gw=10.10.120.1"
  type = list(string)
  default = ["ip=dhcp"]
}

variable "vm_nameserver" {
  description = "The nameserver to use for the VM (only required if not using dhcp)"
  type = string
  default = null
}

variable "vm_proxmox_ssh_server" {
  description = "The IP/Hostname of the server to upload cloud-init files to"
  type = string
}

variable "vm_proxmox_ssh_user" {
  description = "The SSH user to use to connect to the Proxmox server with. This is used to upload the cloud-init file. This user must have write access to the snippets directory on the datastore used"
  type = string
  default = "root"
}

variable "vm_proxmox_ssh_private_key_path" {
  description = "The path the the ssh private key to connect to the Proxmox server with"
  type = string
}

variable "vm_proxmox_snippets_storage_pool" {
  description = "The storage pool to create the cloud-init snippets in"
  type = string
  default = "local"
}

variable "ansible_user" {
  description = "The user to use for Ansible"
  type = string
  default = "ansible"
}

variable "ansible_password" {
  description = "The hashed password to use for Ansible"
  type = string
  default = null
}

variable "ansible_public_key" {
  description = "value of the public key to use for Ansible"
  type = string
  default = null
}

variable "vm_tags" {
  description = "The tags to apply to the VM"
  type = string
  default = null
}

variable "templates_folder" {
  description = "The location of the templates folder (default should be fine)"
  type = string
  default = "./shared/templates"
}

variable "generated_folder" {
  description = "The location of the folder that will hold generated files"
  type = string
  default = "./generated"
}

locals {
  template_ci_userdata_filename = "${var.templates_folder}/cloud-init/user-data.tftpl"
  serial_added        = var.vm_serial_id >= 0 ? true : false
}
