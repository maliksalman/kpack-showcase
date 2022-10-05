#!/bin/bash

REG_HOST=gcr.io
REG_USERNAME=_json_key
REG_PASSWORD_FILE=creds/gcr-key.json

# create the image-push-creds secret
echo "apiVersion: v1
kind: Secret
metadata:
  name: image-push-creds
  annotations:
    kpack.io/docker: $REG_HOST
type: kubernetes.io/basic-auth
data:
  username: $(echo $REG_USERNAME | base64 -w 0)
  password: $(base64 -w 0 $REG_PASSWORD_FILE)" | kubectl apply -n dev -f -

# create the image-pull-creds secret
kubectl create secret docker-registry image-pull-creds \
  --docker-server="$REG_HOST" \
  --docker-username="$REG_USERNAME" \
  --docker-password="$(cat $REG_PASSWORD_FILE)" \
  --docker-email=samalik@kpack.demo \
  -n dev

# create the github secret to pull private repos
echo "apiVersion: v1
kind: Secret
metadata:
  name: github-ssh
  annotations:
    kpack.io/git: git@github.com
type: kubernetes.io/ssh-auth
data:
  ssh-privatekey: $(base64 -w 0 creds/id_ed25519)" | kubectl apply -n dev -f -