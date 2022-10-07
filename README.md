# kpack-showcase

This repository contains Kubernetes resources and scripts that will showcase how Kpack can be used to follow changes in a Git repository to convert code into OCI complaint images and push/tag them to the Docker registry. These  images can then be used to deploy your apps in Kubernetes.

## Pre-requisites

1. Minikube installed and running:

```
berw install minikube
minikube start
```

2. kubectl and/or k9s installed

```
brew install kubernetes-cli k9s
```

3. Generate a new SSH key-pair using the following command but change the location of where the files are generated. The files should be called `ed25519` and `ed25519.pub` and placed in the `creds` directory. The contents of `ed25519.pub` need to be registered with git.


5. A private Git repository accessible via SSH key-pair

6. Access to a Docker registry where OCI images will be uploaded to. This example assumes GCR. The JSON key to access GCP services programmatically is needed. Once obtained, place the contents in `creds/gcr-key.json`

## Steps

1. Install latest version of kpack:

```
./10-install-kpack.sh
```

2. Create kpack *store* and *stack* which are cluster level resources:

```
kubectl apply -f 20-kpack-cluster.yml
```

3. Create the `dev` *namespace* where we will play:

```
kubectl apply -f 30-create-dev-space.yml
```

4. Create various *secret* resources (pushing/pulling images, accessing git):

```
./40-create-secrets.sh
```

5. Create a *service-account* that kpack will use to pull source code from Git and then push the built image to a docker registry

```
kubectl apply -f 50-service-account.yml
```

6. Create a kpack *builder* that knows which buildpacks are in play. The *builder* is a namespaced resource:

```
kubectl apply -f 60-builder.yml
```

7. Create a kpack *image* resource which points to our private Git repo. This is the resource which will create OCI images in our configured docker registry:

```
kubectl apply -f 70-image.yml
```

8. Create a *deployment* which will use that image and deploy the app to our cluster

```
kubectl apply -f 80-deployment.yml
```
