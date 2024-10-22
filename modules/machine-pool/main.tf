resource "rhcs_hcp_machine_pool" "machine_pool" {
  cluster                      = var.cluster_id
  name                         = var.name
  replicas                     = var.replicas
  autoscaling                  = var.autoscaling
  labels                       = var.labels
  taints                       = var.taints
  subnet_id                    = var.subnet_id
  aws_node_pool                = local.aws_node_pool
  auto_repair                  = var.auto_repair
  version                      = var.openshift_version
  upgrade_acknowledgements_for = var.upgrade_acknowledgements_for
  tuning_configs               = var.tuning_configs
  kubelet_configs              = var.kubelet_configs

  lifecycle {
    ignore_changes = [
      cluster,
      name,
    ]
  }

  depends_on = [ local.aws_node_pool ]
}

locals {
  aws_node_pool = {
    instance_type = var.aws_node_pool.instance_type
    
    # HACK intentioanlly omitted the `tags` key here; otherwise I'll get an error like this:
    # │ Error: Attribute value cannot be changed
    # │ 
    # │   with module.rosa-hcp.module.rhcs_hcp_machine_pool["pool2"].rhcs_hcp_machine_pool.machine_pool,
    # │   on .terraform/modules/rosa-hcp/modules/machine-pool/main.tf line 1, in resource "rhcs_hcp_machine_pool" "machine_pool":
    # │    1: resource "rhcs_hcp_machine_pool" "machine_pool" {
    # │ 
    # │ Attribute aws_node_pool.tags, cannot be changed from <null> to {"Cafe":"Espresso"}
  }
}
