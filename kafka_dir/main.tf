terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.88.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.12.1"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "aks_rg" {
  name     = "my_aks_rg"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "my_aks_cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "myakscluster"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2ps_v2"

    temporary_name_for_rotation = "temp"
  }

  identity {
    type = "SystemAssigned"
  }
}

provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config.0.cluster_ca_certificate)
  }
}

resource "helm_release" "kafka_helm_chart" {
  name       = "kafka"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "kafka"
  timeout    = 600

  set {
    name = "controller.replicaCount"
    value = 1
  }
  set {
    name  = "externalAccess.enabled"
    value = true
  }


### SERVICE TYPE
  set {
    name = "externalAccess.controller.service.type"
    value = "LoadBalancer"
  }
  set {
    name = "externalAccess.broker.service.type"
    value = "LoadBalancer"
  }


### CONFIGS
  set {
    name = "listeners.advertisedListeners"
    value = "PLAINTEXT://20.241.238.196:9094"
  }

#### LOAD BALANCER
##### PORT
# set {
#   name = "externalAccess.broker.service.ports.external"
#   value = 9094
# }
# set {
#   name = "externalAccess.controller.service.containerPorts.external"
#   value = 9094
# }
#### IP
# set_list {
#   name = "externalAccess.controller.service.loadBalancerIPs"
#   value = [
#     "10.224.0.4"
#     ]
# }
# set_list {
#   name = "externalAccess.broker.service.loadBalancerIPs"
#   value = [
#     "10.224.0.4"
#     ]
# }
set_list {
  name = "externalAccess.broker.service.loadBalancerNames"
  value = [
    "qwerty"
  ]
}
set_list {
  name = "externalAccess.controller.service.loadBalancerNames"
  value = [
    "qwerty"
  ]
}

  # set_list {
  #   name = "externalAccess.controller.service.nodePorts"
  #   value = ["node-port-1"]
  # }
  # set_list {
  #   name = "externalAccess.controller.service.externalIPs"
  #   value = ["20.231.237.43"]
  # }
  # set_list {
  #   name = "externalAccess.controller.service.domain"
  #   value = ["20.231.237.43"]
  # }


### AUTO DISCOVERY
  # set {
  #   name = "externalAccess.autoDiscovery.enabled"
  #   value = false
  # }
  # set {
  #   name = "serviceAccount.create"
  #   value = false
  # }
  # set {
  #   name = "rbac.create"
  #   value = false
  # }
}
