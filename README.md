# kpack-showcase

This repository contains Kubernetes resources and scripts that will showcase how Kpack can be used to follow changes in a Git repository to convert code into OCI complaint images and push/tag them to the Docker registry. These  images can then be used to deploy your apps in Kubernetes.

## Pre-requisites

1. `kubectl` and/or `k9s` installed

```
brew install kubernetes-cli k9s
```

2. *Minikube* installed and running:

```
berw install minikube
minikube start
```

3. Generate a new SSH key-pair using the command bellow. The files (`id_ed25519` and `id_ed25519.pub`) will be placed in the `creds` directory. The contents of `creds/id_ed25519.pub` need to be registered with your Git provider (like GitHub) as the SSH key.

```
ssh-keygen -t ed25519 \
    -C "user@kpack.demo" \
    -f creds/id_ed25519 \
    -q -N ""
```

4. A private Git repository hosted by the above mentioned Git provider and accessible via above generated SSH key-pair. This needs to be a *cloud-native buildpacks* compatible code-base - like a spring-boot app. For example, https://github.com/maliksalman/spring-data-jpa-sample. If you want to use that code, fork the repository but keep the forked copy private so the SSH keys generated above can be utilized.

6. Access to a Docker registry where OCI images will be uploaded to. This example assumes [Google Cloud Container Registry](https://cloud.google.com/container-registry). The [JSON key](https://cloud.google.com/iam/docs/creating-managing-service-account-keys) to access GCP services programmatically is needed. Once obtained, place the contents in `creds/gcr-key.json`

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
