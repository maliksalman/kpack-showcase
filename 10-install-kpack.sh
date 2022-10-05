#!/bin/bash

KPACK_YAML_URL=$1

if [[ -z $KPACK_YAML_URL ]]; then
  KPACK_YAML_URL=$(curl -s https://api.github.com/repos/pivotal/kpack/releases/latest | jq .assets[].browser_download_url -r | grep yaml)
fi

echo
echo ">>> Installing KPACK from: $KPACK_YAML_URL ... ***"
echo
kubectl apply -f $KPACK_YAML_URL

echo
echo ">>> Installation will happen in the background. Watching for KPACK pods to be available ..."
echo ">>> Press CTRL+C when pods are available. Run 'kubectl get pods --namespace kpack' to make sure ... "
echo
kubectl get pods --namespace kpack --watch
