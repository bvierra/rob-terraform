proxmox_api_server            = "s1.lab.vierra.host"
proxmox_tls_insecure          = true
proxmox_ssh_user              = "root"
proxmox_ssh_private_key_path  = "/home/bvierra/.ssh/id_ed25519"
proxmox_snippets_storage_pool = "proxmox-nfs"

project_name                  = "kubespray"
domain_name                   = "lab.vierra.host"
ansible_user                  = "ansible"
ansible_password              = "$6$6t2K4h8Wo6CPCYRx$ER4TcrY5.s70YrMp4sejjIlQYza7PGr1QPlURu5Lxwc/dJX9GxXxyP9uEjwsbSFsnIDRJlo7Khj6e7pjsfXIe."

vm_k8s_control_instances = [
  {
    name        = "k8s-control-1"
    target_node = "s2"
    ip          = "10.10.130.101"
    ip_defs     = [
      "ip=10.10.130.101/24,gw=10.10.130.1",
      "ip=10.10.140.101/24"
    ]
  },
  {
    name        = "k8s-control-2"
    target_node = "s2"
    ip          = "10.10.130.102"
    ip_defs     = [
      "ip=10.10.130.102/24,gw=10.10.130.1",
      "ip=10.10.140.102/24"
    ]
  },
  {
    name        = "k8s-control-3"
    target_node = "s3"
    ip          = "10.10.130.103"
    ip_defs     = [
      "ip=10.10.130.103/24,gw=10.10.130.1",
      "ip=10.10.140.103/24"
    ]
  }
]

vm_k8s_control_networks = [
    {
      id        = 0
      model     = "virtio"
      bridge    = "vmbr0"
      firewall  = false
      link_down = false
      tag       = 130
    },
    {
      id        = 1
      model     = "virtio"
      bridge    = "vmbr1"
      firewall  = false
      link_down = false
      tag       = 0
    }
  ]

vm_k8s_worker_instances = [
  {
    name        = "k8s-worker-1"
    target_node = "s3"
    ip          = "10.10.130.111"
    ip_defs     = [
      "ip=10.10.130.111/24,gw=10.10.130.1",
      "ip=10.10.140.111/24"
    ]
  },
  {
    name        = "k8s-worker-2"
    target_node = "s2"
    ip          = "10.10.130.112"
    ip_defs     = [
      "ip=10.10.130.112/24,gw=10.10.130.1",
      "ip=10.10.140.112/24"
    ]
  },
  {
    name        = "k8s-worker-3"
    target_node = "s3"
    ip          = "10.10.130.113"
    ip_defs     = [
      "ip=10.10.130.113/24,gw=10.10.130.1",
      "ip=10.10.140.113/24"
    ]
  },
  {
    name        = "k8s-worker-4"
    target_node = "s4"
    ip          = "10.10.130.114"
    ip_defs     = [
      "ip=10.10.130.114/24,gw=10.10.130.1",
      "ip=10.10.140.114/24"
    ]
  }
]

vm_k8s_worker_networks = [
    {
      id        = 0
      model     = "virtio"
      bridge    = "vmbr0"
      firewall  = false
      link_down = false
      tag       = 130
    },
    {
      id        = 1
      model     = "virtio"
      bridge    = "vmbr1"
      firewall  = false
      link_down = false
      tag       = 0
    }
  ]
