




sudo docker pull quay.io/prometheus/prometheus:${PROMETHEUS_VERSION}
sudo docker save quay.io/prometheus/prometheus:${PROMETHEUS_VERSION} > prometheus-prometheus_${PROMETHEUS_VERSION}.tar
sudo docker pull quay.io/coreos/prometheus-operator:${PROMETHEUS_OPERATOR_VERSION}
sudo docker save quay.io/coreos/prometheus-operator:${PROMETHEUS_OPERATOR_VERSION} > prometheus-operator_${PROMETHEUS_OPERATOR_VERSION}.tar
sudo docker pull quay.io/prometheus/node-exporter:${NODE_EXPORTER_VERSION}
sudo docker save quay.io/prometheus/node-exporter:${NODE_EXPORTER_VERSION} > node-exporter_${NODE_EXPORTER_VERSION}.tar
sudo docker pull quay.io/coreos/kube-state-metrics:${KUBE_STATE_METRICS_VERSION}
sudo docker save quay.io/coreos/kube-state-metrics:${KUBE_STATE_METRICS_VERSION} > kube-state-metrics_${KUBE_STATE_METRICS_VERSION}.tar
sudo docker pull quay.io/coreos/prometheus-config-reloader:${CONFIGMAP_RELOADER_VERSION}
sudo docker save quay.io/coreos/prometheus-config-reloader:${CONFIGMAP_RELOADER_VERSION} > config-reloader_${CONFIGMAP_RELOADER_VERSION}.tar
sudo docker pull quay.io/coreos/configmap-reload:${CONFIGMAP_RELOAD_VERSION}
sudo docker save quay.io/coreos/configmap-reload:${CONFIGMAP_RELOAD_VERSION} > config-reload_${CONFIGMAP_RELOAD_VERSION}.tar
sudo docker pull quay.io/coreos/kube-rbac-proxy:${KUBE_RBAC_PROXY_VERSION}
sudo docker save quay.io/coreos/kube-rbac-proxy:${KUBE_RBAC_PROXY_VERSION} > kube-rbac-proxy_${KUBE_RBAC_PROXY_VERSION}.tar
sudo docker pull quay.io/coreos/k8s-prometheus-adapter-amd64:${PROMETHEUS_ADAPTER_VERSION}
sudo docker save quay.io/coreos/k8s-prometheus-adapter-amd64:${PROMETHEUS_ADAPTER_VERSION} > prometheus-adapter_${PROMETHEUS_ADAPTER_VERSION}.tar
sudo docker pull quay.io/prometheus/alertmanager:${ALERTMANAGER_VERSION}
sudo docker save quay.io/prometheus/alertmanager:${ALERTMANAGER_VERSION} > alertmanager_${ALERTMANAGER_VERSION}.tar




sudo docker load < prometheus-prometheus_${PROMETHEUS_VERSION}.tar
sudo docker load < prometheus-operator_${PROMETHEUS_OPERATOR_VERSION}.tar
sudo docker load < node-exporter_${NODE_EXPORTER_VERSION}.tar
sudo docker load < kube-state-metrics_${KUBE_STATE_METRICS_VERSION}.tar
sudo docker load < config-reloader_${CONFIGMAP_RELOADER_VERSION}.tar
sudo docker load < config-reload_${CONFIGMAP_RELOAD_VERSION}.tar
sudo docker load < kube-rbac-proxy_${KUBE_RBAC_PROXY_VERSION}.tar
sudo docker load < prometheus-adapter_${PROMETHEUS_ADAPTER_VERSION}.tar
sudo docker load < alertmanager_${ALERTMANAGER_VERSION}.tar

sudo docker tag quay.io/prometheus/prometheus:${PROMETHEUS_VERSION} ${REGISTRY}/prometheus/prometheus:${PROMETHEUS_VERSION}
sudo docker tag quay.io/coreos/prometheus-operator:${PROMETHEUS_OPERATOR_VERSION} ${REGISTRY}/coreos/prometheus-operator:${PROMETHEUS_OPERATOR_VERSION}
sudo docker tag quay.io/prometheus/node-exporter:${NODE_EXPORTER_VERSION} ${REGISTRY}/prometheus/node-exporter:${NODE_EXPORTER_VERSION}
sudo docker tag quay.io/coreos/kube-state-metrics:${KUBE_STATE_METRICS_VERSION} ${REGISTRY}/coreos/kube-state-metrics:${KUBE_STATE_METRICS_VERSION}
sudo docker tag quay.io/coreos/prometheus-config-reloader:${CONFIGMAP_RELOADER_VERSION} ${REGISTRY}/coreos/prometheus-config-reloader:${CONFIGMAP_RELOADER_VERSION}
sudo docker tag quay.io/coreos/configmap-reload:${CONFIGMAP_RELOAD_VERSION} ${REGISTRY}/coreos/configmap-reload:${CONFIGMAP_RELOAD_VERSION}
sudo docker tag quay.io/coreos/kube-rbac-proxy:${KUBE_RBAC_PROXY_VERSION} ${REGISTRY}/coreos/kube-rbac-proxy:${KUBE_RBAC_PROXY_VERSION}
sudo docker tag quay.io/coreos/k8s-prometheus-adapter-amd64:${PROMETHEUS_ADAPTER_VERSION} ${REGISTRY}/coreos/k8s-prometheus-adapter-amd64:${PROMETHEUS_ADAPTER_VERSION}
sudo docker tag quay.io/prometheus/alertmanager:${ALERTMANAGER_VERSION} ${REGISTRY}/prometheus/alertmanager:${ALERTMANAGER_VERSION}

sudo docker push ${REGISTRY}/prometheus/prometheus:${PROMETHEUS_VERSION}
sudo docker push ${REGISTRY}/coreos/prometheus-operator:${PROMETHEUS_OPERATOR_VERSION}
sudo docker push ${REGISTRY}/prometheus/node-exporter:${NODE_EXPORTER_VERSION}
sudo docker push ${REGISTRY}/coreos/kube-state-metrics:${KUBE_STATE_METRICS_VERSION}
sudo docker push ${REGISTRY}/coreos/prometheus-config-reloader:${CONFIGMAP_RELOADER_VERSION}
sudo docker push ${REGISTRY}/coreos/configmap-reload:${CONFIGMAP_RELOAD_VERSION}
sudo docker push ${REGISTRY}/coreos/kube-rbac-proxy:${KUBE_RBAC_PROXY_VERSION}
sudo docker push ${REGISTRY}/coreos/k8s-prometheus-adapter-amd64:${PROMETHEUS_ADAPTER_VERSION}
sudo docker push ${REGISTRY}/prometheus/alertmanager:${ALERTMANAGER_VERSION}

cd manifest

sed -i 's/{ALERTMANAGER_VERSION}/'${ALERTMANAGER_VERSION}'/g' alertmanager-alertmanager.yaml
sed -i 's/{KUBE_RBAC_PROXY_VERSION}/'${KUBE_RBAC_PROXY_VERSION}'/g' kube-state-metrics-deployment.yaml
sed -i 's/{KUBE_STATE_METRICS_VERSION}/'${KUBE_STATE_METRICS_VERSION}'/g' kube-state-metrics-deployment.yaml
sed -i 's/{NODE_EXPORTER_VERSION}/'${NODE_EXPORTER_VERSION}'/g' node-exporter-daemonset.yaml
sed -i 's/{KUBE_RBAC_PROXY_VERSION}/'${KUBE_RBAC_PROXY_VERSION}'/g' node-exporter-daemonset.yaml
sed -i 's/{PROMETHEUS_ADAPTER_VERSION}/'${PROMETHEUS_ADAPTER_VERSION}'/g' prometheus-adapter-deployment.yaml
sed -i 's/{PROMETHEUS_VERSION}/'${PROMETHEUS_VERSION}'/g' prometheus-prometheus.yaml

sed -i "s/quay.io\/prometheus\/alertmanager/${REGISTRY}\/prometheus\/alertmanager/g" alertmanager-alertmanager.yaml
sed -i "s/quay.io\/coreos\/kube-rbac-proxy/${REGISTRY}\/coreos\/kube-rbac-proxy/g" kube-state-metrics-deployment.yaml
sed -i "s/quay.io\/coreos\/kube-state-metrics/${REGISTRY}\/coreos\/kube-state-metrics/g" kube-state-metrics-deployment.yaml
sed -i "s/quay.io\/prometheus\/node-exporter/${REGISTRY}\/prometheus\/node-exporter/g" node-exporter-daemonset.yaml
sed -i "s/quay.io\/coreos\/kube-rbac-proxy/${REGISTRY}\/coreos\/kube-rbac-proxy/g" node-exporter-daemonset.yaml
sed -i "s/quay.io\/coreos\/k8s-prometheus-adapter-amd64/${REGISTRY}\/coreos\/k8s-prometheus-adapter-amd64/g" prometheus-adapter-deployment.yaml
sed -i "s/quay.io\/prometheus\/prometheus/${REGISTRY}\/prometheus\/prometheus/g" prometheus-prometheus.yaml

cd ..

cd setup

sed -i 's/{PROMETHEUS_OPERATOR_VERSION}/'${PROMETHEUS_OPERATOR_VERSION}'/g' prometheus-operator-deployment.yaml
sed -i 's/{CONFIGMAP_RELOADER_VERSION}/'${CONFIGMAP_RELOADER_VERSION}'/g' prometheus-operator-deployment.yaml
sed -i 's/{CONFIGMAP_RELOAD_VERSION}/'${CONFIGMAP_RELOAD_VERSION}'/g' prometheus-operator-deployment.yaml

sed -i "s/quay.io\/coreos\/configmap-reload/${REGISTRY}\/coreos\/configmap-reload/g" prometheus-operator-deployment.yaml
sed -i "s/quay.io\/coreos\/prometheus-config-reloader/${REGISTRY}\/coreos\/prometheus-config-reloader/g" prometheus-operator-deployment.yaml
sed -i "s/quay.io\/coreos\/prometheus-operator/${REGISTRY}\/coreos\/prometheus-operator/g" prometheus-operator-deployment.yaml
		 
cd ..

if ! command -v yq 2>/dev/null ; then
  wget https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 -O /usr/bin/yq &&\
  chmod +x /usr/bin/yq
fi

kubectl get pod `kubectl get pod -n kube-system -o jsonpath='{.items[?(@.metadata.labels.component == "kube-scheduler")].metadata.name}'` -n kube-system -o yaml > kube-scheduler.yaml
yq e '.metadata.labels.k8s-app = "kube-scheduler"' -i ./kube-scheduler.yaml
kubectl apply -f kube-scheduler.yaml
kubectl get pod `kubectl get pod -n kube-system -o jsonpath='{.items[?(@.metadata.labels.component == "kube-controller-manager")].metadata.name}'` -n kube-system -o yaml > kube-controller-manager.yaml
yq e '.metadata.labels.k8s-app = "kube-controller-manager"' -i ./kube-controller-manager.yaml
kubectl apply -f kube-controller-manager.yaml

kubectl create -f setup/
kubectl create -f manifest/
