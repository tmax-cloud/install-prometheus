#!/bin/bash
  
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MANIFEST_HOME=$SCRIPTDIR/yaml/manifests
SETUP_HOME=$SCRIPTDIR/yaml/setup

source $SCRIPTDIR/version.conf


sudo sed -i 's/{ALERTMANAGER_VERSION}/'${ALERTMANAGER_VERSION}'/g' $MANIFEST_HOME/alertmanager-alertmanager.yaml
sudo sed -i 's/{KUBE_RBAC_PROXY_VERSION}/'${KUBE_RBAC_PROXY_VERSION}'/g' $MANIFEST_HOME/kube-state-metrics-deployment.yaml
sudo sed -i 's/{KUBE_STATE_METRICS_VERSION}/'${KUBE_STATE_METRICS_VERSION}'/g' $MANIFEST_HOME/kube-state-metrics-deployment.yaml
sudo sed -i 's/{NODE_EXPORTER_VERSION}/'${NODE_EXPORTER_VERSION}'/g' $MANIFEST_HOME/node-exporter-daemonset.yaml
sudo sed -i 's/{KUBE_RBAC_PROXY_VERSION}/'${KUBE_RBAC_PROXY_VERSION}'/g' $MANIFEST_HOME/node-exporter-daemonset.yaml
sudo sed -i 's/{PROMETHEUS_ADAPTER_VERSION}/'${PROMETHEUS_ADAPTER_VERSION}'/g' $MANIFEST_HOME/prometheus-adapter-deployment.yaml
sudo sed -i 's/{PROMETHEUS_VERSION}/'${PROMETHEUS_VERSION}'/g' $MANIFEST_HOME/prometheus-prometheus.yaml

if [ $REGISTRY != "{REGISTRY}" ]; then
	sudo sed -i "s/quay.io\/prometheus\/alertmanager/${REGISTRY}\/prometheus\/alertmanager/g" $MANIFEST_HOME/alertmanager-alertmanager.yaml
	sudo sed -i "s/quay.io\/coreos\/kube-rbac-proxy/${REGISTRY}\/coreos\/kube-rbac-proxy/g" $MANIFEST_HOME/kube-state-metrics-deployment.yaml
	sudo sed -i "s/quay.io\/coreos\/kube-state-metrics/${REGISTRY}\/coreos\/kube-state-metrics/g" $MANIFEST_HOME/kube-state-metrics-deployment.yaml
	sudo sed -i "s/quay.io\/prometheus\/node-exporter/${REGISTRY}\/prometheus\/node-exporter/g" $MANIFEST_HOME/node-exporter-daemonset.yaml
	sudo sed -i "s/quay.io\/coreos\/kube-rbac-proxy/${REGISTRY}\/coreos\/kube-rbac-proxy/g" $MANIFEST_HOME/node-exporter-daemonset.yaml
	sudo sed -i "s/quay.io\/coreos\/k8s-prometheus-adapter-amd64/${REGISTRY}\/coreos\/k8s-prometheus-adapter-amd64/g" $MANIFEST_HOME/prometheus-adapter-deployment.yaml
	sudo sed -i "s/quay.io\/prometheus\/prometheus/${REGISTRY}\/prometheus\/prometheus/g" $MANIFEST_HOME/prometheus-prometheus.yaml
fi

if [ $REGISTRY != "{REGISTRY}" ]; then
	sudo sed -i "s/quay.io\/coreos\/configmap-reload/${REGISTRY}\/coreos\/configmap-reload/g" $SETUP_HOME/prometheus-operator-deployment.yaml
	sudo sed -i "s/quay.io\/coreos\/prometheus-config-reloader/${REGISTRY}\/coreos\/prometheus-config-reloader/g" $SETUP_HOME/prometheus-operator-deployment.yaml
	sudo sed -i "s/quay.io\/coreos\/prometheus-operator/${REGISTRY}\/coreos\/prometheus-operator/g" $SETUP_HOME/prometheus-operator-deployment.yaml
		 
fi

sudo sed -i 's/{PROMETHEUS_OPERATOR_VERSION}/'${PROMETHEUS_OPERATOR_VERSION}'/g' $SETUP_HOME/prometheus-operator-deployment.yaml
sudo sed -i 's/{CONFIGMAP_RELOADER_VERSION}/'${CONFIGMAP_RELOADER_VERSION}'/g' $SETUP_HOME/prometheus-operator-deployment.yaml
sudo sed -i 's/{CONFIGMAP_RELOAD_VERSION}/'${CONFIGMAP_RELOAD_VERSION}'/g' $SETUP_HOME/prometheus-operator-deployment.yaml

if ! command -v yq 2>/dev/null ; then
  sudo wget https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 -O /usr/bin/yq &&\
  chmod +x /usr/bin/yq
fi


kubectl get pod `kubectl get pod -n kube-system -o jsonpath='{.items[?(@.metadata.labels.component == "kube-scheduler")].metadata.name}'` -n kube-system -o yaml > $SCRIPTDIR/kube-scheduler.yaml
sudo yq e '.metadata.labels.k8s-app = "kube-scheduler"' -i $SCRIPTDIR/kube-scheduler.yaml
sudo mv $SCRIPTDIR/kube-scheduler.yaml /etc/kubernetes/manifests/

kubectl get pod `kubectl get pod -n kube-system -o jsonpath='{.items[?(@.metadata.labels.component == "kube-controller-manager")].metadata.name}'` -n kube-system -o yaml > $SCRIPTDIR/kube-controller-manager.yaml
sudo yq e '.metadata.labels.k8s-app = "kube-controller-manager"' -i $SCRIPTDIR/kube-controller-manager.yaml
sudo mv $SCRIPTDIR/kube-controller-manager.yaml /etc/kubernetes/manifests/

kubectl create -f $SETUP_HOME
kubectl create -f $MANIFEST_HOME
