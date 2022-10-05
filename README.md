# kpack-showcase

This repository contains Kubernetes resources and scripts that will showcase how Kpack can be used to follow changes in a Git repository to convert into OCI complaint images and push/tag them to the Docker registry. These app images can then be used to deploy your applications in Kubernetes.

## Pre-requisites

1. Access to a Docker registry like GCR. This example assumes GCR
1. Minikube installed and running:

```
berw install minikube
minikube start
```

1. kubectl and/or k9s installed

```
brew install kubernetes-cli k9s
```

1. Generate a new SSH key-pair using the following command but change the location of where the files are generated. The files should be called `ed25519` and `ed25519.pub` and placed in the `creds` directory. The contents of `ed25519.pub` need to be registered with git.
1. A private Git repository accessible via SSH key-pair
1. `creds/gcr-key.json` - place the GCR key contents in this file

## Steps

1. Install latest version of kpack:

```
./10-install-kpack.sh
```

1. Create kpack *store* and *stack* which are cluster level resources:

```
kubectl apply -f 20-kpack-cluster.yml
```

1. Create a *namespace* where we will play:

```
kubectl apply -f 30-create-space.yml
```

1. Create a various *secret* resources that are needed:

```
./40-create-secrets.sh
```

1. Create a *service-account* that kpack will use to pull source code from Git and then push the built image to a docker registry

```
kubectl apply -f 50-service-account.yml
```

1. Create a kpack *builder* that knows which buildpacks are in play. The builder is namespaced resource:

```
kubectl apply -f 60-builder.yml
```

1. Create a kpack *image* resource which points to our private Git repo. This is the resource which will create images in our configured docker registry:

```
kubectl apply -f 70-image.yml
```

1. Create a *deployment* which will use that image and deploy the app to our cluster

```
kubectl apply -f 80-deployment.yml
```
