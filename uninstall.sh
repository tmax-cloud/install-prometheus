#!/bin/bash
  
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MANIFEST_HOME=$SCRIPTDIR/yaml/manifests
SETUP_HOME=$SCRIPTDIR/yaml/setup

kubectl delete -f $MANIFEST_HOME
#sleep 30s
kubectl delete -f $SETUP_HOME
