resource "nutanix_karbon_cluster" "mycluster" {
  name       = "mycluster"
  version    = "1.25.6-0"
  storage_class_config {
    reclaim_policy = "Retain"
    volumes_config {
      file_system                = "ext4"
      flash_mode                 = true
      password                   = var.nutanix_password
      prism_element_cluster_uuid = "myuuid"
      storage_container          = "NutanixKubernetesEngine"
      username                   = var.nutanix_user
    }
  }
  cni_config {
    node_cidr_mask_size = 24
    pod_ipv4_cidr       = "172.20.0.0/16"
    service_ipv4_cidr   = "172.19.0.0/16"
  }
  worker_node_pool {
    node_os_version = "ntnx-1.5"
    num_instances   = 1
    ahv_config {
      cpu = 10
      memory_mib = 16384
      network_uuid               = nutanix_subnet.kubernetes.id
      prism_element_cluster_uuid = "myuuid"
    }
  }

  etcd_node_pool {
    node_os_version = "ntnx-1.5"
    num_instances   = 1
    ahv_config {
      cpu = 4
      memory_mib = 8192
      network_uuid               =  nutanix_subnet.kubernetes.id
      prism_element_cluster_uuid = "myuuid"
    }
  }
  master_node_pool {
    node_os_version = "ntnx-1.5"
    num_instances   = 1
    ahv_config {
      cpu = 4
      memory_mib = 4096
      network_uuid               =  nutanix_subnet.kubernetes.id
      prism_element_cluster_uuid = "myuuid"
    }
  }
  private_registry {
    registry_name = nutanix_karbon_private_registry.registry.name
  }
}

resource "nutanix_karbon_worker_nodepool" "mynodepool" {
  cluster_name = nutanix_karbon_cluster.mycluster.name
  name = "mynodepool"
  num_instances = 1
  node_os_version = "ntnx-1.5"
  
  ahv_config {
    cpu = 2
    memory_mib = 8192
    network_uuid               = nutanix_subnet.kubernetes.id
    prism_element_cluster_uuid = "myuuid"
  }