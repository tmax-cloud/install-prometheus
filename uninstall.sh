#!/bin/bash


  
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MANIFEST_HOME=$SCRIPTDIR/yaml/manifests
SETUP_HOME=$SCRIPTDIR/yaml/setup
source $SCRIPTDIR/version.conf


sudo cp /etc/kubernetes/manifests/kube-scheduler.yaml .
sudo yq eval 'del(.metadata.labels.k8s-app)' -i kube-scheduler.yaml
sudo yq e '.spec.containers[0].command += "--port=0"' -i ./kube-scheduler.yaml
sudo mv -f ./kube-scheduler.yaml /etc/kubernetes/manifests/kube-scheduler.yaml

sudo cp /etc/kubernetes/manifests/kube-controller-manager.yaml .
sudo yq eval 'del(.metadata.labels.k8s-app)' -i kube-controller-manager.yaml
sudo yq e '.spec.containers[0].command += "--port=0"' -i ./kube-controller-manager.yaml
sudo mv -f ./kube-controller-manager.yaml /etc/kubernetes/manifests/kube-controller-manager.yaml


sudo cp /etc/kubernetes/manifests/etcd.yaml .
sudo yq eval 'del(.metadata.labels.k8s-app)' -i etcd.yaml
sudo yq eval '(.spec.containers[0].command[] | select(. == "--listen-metrics-urls*")) = "--listen-metrics-urls=http://127.0.0.1:2381"' -i etcd.yaml
sudo mv -f ./etcd.yaml /etc/kubernetes/manifests/etcd.yaml

for master in  "${SUB_MASTER_IP[@]}"
do
  
  if [ $master == $MAIN_MASTER_IP ]; then
    continue
  fi
  i=$((i+1))
  sudo sshpass -p "${MASTER_NODE_ROOT_PASSWORD[i]}" ssh -o StrictHostKeyChecking=no ${MASTER_NODE_ROOT_USER[i]}@"$master" yum install yq
  sudo sshpass -p "${MASTER_NODE_ROOT_PASSWORD[i]}" ssh -o StrictHostKeyChecking=no ${MASTER_NODE_ROOT_USER[i]}@"$master" sudo cp /etc/kubernetes/manifests/etcd.yaml .
  sudo sshpass -p "${MASTER_NODE_ROOT_PASSWORD[i]}" ssh -o StrictHostKeyChecking=no ${MASTER_NODE_ROOT_USER[i]}@"$master" 'sudo yq e '"'"'del(.metadata.labels.k8s-app)'"'"' -i etcd.yaml'
  sudo sshpass -p "${MASTER_NODE_ROOT_PASSWORD[i]}" ssh -o StrictHostKeyChecking=no ${MASTER_NODE_ROOT_USER[i]}@"$master" 'sudo yq eval '"'"'(.spec.containers[0].command[] | select(. == "--listen-metrics-urls*")) = "--listen-metrics-urls=http://127.0.0.1:2381"'"'"' -i etcd.yaml'
  sudo sshpass -p "${MASTER_NODE_ROOT_PASSWORD[i]}" ssh -o StrictHostKeyChecking=no ${MASTER_NODE_ROOT_USER[i]}@"$master" sudo mv -f ./etcd.yaml /etc/kubernetes/manifests/etcd.yaml
  
  sudo sshpass -p "${MASTER_NODE_ROOT_PASSWORD[i]}" ssh -o StrictHostKeyChecking=no ${MASTER_NODE_ROOT_USER[i]}@"$master" sudo cp /etc/kubernetes/manifests/kube-scheduler.yaml .
  sudo sshpass -p "${MASTER_NODE_ROOT_PASSWORD[i]}" ssh -o StrictHostKeyChecking=no ${MASTER_NODE_ROOT_USER[i]}@"$master" 'sudo yq e '"'"'del(.metadata.labels.k8s-app)'"'"' -i kube-scheduler.yaml'
  sudo sshpass -p "${MASTER_NODE_ROOT_PASSWORD[i]}" ssh -o StrictHostKeyChecking=no ${MASTER_NODE_ROOT_USER[i]}@"$master" 'sudo yq eval '"'"'.spec.containers[0].command += "--port=0"'"'"' -i kube-scheduler.yaml'
  sudo sshpass -p "${MASTER_NODE_ROOT_PASSWORD[i]}" ssh -o StrictHostKeyChecking=no ${MASTER_NODE_ROOT_USER[i]}@"$master" sudo mv -f ./kube-scheduler.yaml /etc/kubernetes/manifests/kube-scheduler.yaml


  sudo sshpass -p "${MASTER_NODE_ROOT_PASSWORD[i]}" ssh -o StrictHostKeyChecking=no ${MASTER_NODE_ROOT_USER[i]}@"$master" sudo cp /etc/kubernetes/manifests/kube-controller-manager.yaml .
  sudo sshpass -p "${MASTER_NODE_ROOT_PASSWORD[i]}" ssh -o StrictHostKeyChecking=no ${MASTER_NODE_ROOT_USER[i]}@"$master" 'sudo yq e '"'"'del(.metadata.labels.k8s-app)'"'"' -i kube-controller-manager.yaml'
  sudo sshpass -p "${MASTER_NODE_ROOT_PASSWORD[i]}" ssh -o StrictHostKeyChecking=no ${MASTER_NODE_ROOT_USER[i]}@"$master" 'sudo yq eval '"'"'.spec.containers[0].command += "--port=0"'"'"' -i kube-controller-manager.yaml'
  sudo sshpass -p "${MASTER_NODE_ROOT_PASSWORD[i]}" ssh -o StrictHostKeyChecking=no ${MASTER_NODE_ROOT_USER[i]}@"$master" sudo mv -f ./kube-controller-manager.yaml /etc/kubernetes/manifests/kube-controller-manager.yaml


done

kubectl delete -f $MANIFEST_HOME
#sleep 30s
kubectl delete -f $SETUP_HOME
