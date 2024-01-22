# mytwitterbot

1. install kubectl, helm, terraform, azure cli

2. configured terraform to deploy a shelf instance of kafka


`$ az login`

https://github.com/dpkp/kafka-python


```````````````````````````````````````````````````````````````````````````````````````````````````
https://github.com/bitnami/charts/tree/main/bitnami/kafka
readme of this project uses service.controller which is wrong, in its examples


When terraform Helm gets into error state

1. Reset helm
az account set --subscription aea93a2f-faec-4927-9199-1da1dd4b3c7b
az aks get-credentials --resource-group my_aks_rg --name my_aks_cluster --overwrite-existing
helm uninstall kafka
2. Comment out helm block in terraform
3. terraform apply


``````````````````````````````````````````````````````````````````````````````````````````````````
# Connect but can't send to topic

set {
  name = "externalAccess.broker.service.ports.external"
  value = 9094
}
set {
  name = "externalAccess.controller.service.containerPorts.external"
  value = 9094
}
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

`````````````````````````````````````````````````````````````````````````````````````````````````````
helm install kafka bitnami/kafka \
    --set replicaCount=3 \
	--set listeners=PLAINTEXT://0.0.0.0:9094 \
	--set advertisedListeners=PLAINTEXT://:9094 \
	--set listenerSecurityProtocolMap=PLAINTEXT:PLAINTEXT \
	--set interBrokerListenerName="PLAINTEXT" \
	--set serviceAccount.create=true \
	--set rbac.create=true

helm install kafka bitnami/kafka \
    --set controller.replicaCount=3 \
    --set externalAccess.enabled=true \
    --set externalAccess.controller.service.type=LoadBalancer \
    --set externalAccess.broker.service.type=LoadBalancer \
    --set-json='externalAccess.broker.service.loadBalancerNames=["EXTERNAL","EXTERNAL"]'


	--set listeners=PLAINTEXT://0.0.0.0:9094 \
	--set advertisedListeners=PLAINTEXT://:9094 \
	--set listenerSecurityProtocolMap=PLAINTEXT:PLAINTEXT \
	--set interBrokerListenerName="PLAINTEXT" \
	--set serviceAccount.create=true \
	--set rbac.create=true
