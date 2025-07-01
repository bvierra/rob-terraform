resource "ansible_group" "k8s-cluster" {
  name = "k8s_cluster"
  children             = ["kube_control_plane", "kube_node"]
}
