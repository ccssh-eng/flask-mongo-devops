#!/bin/bash

set -e

MINIKUBE_VERSION=v1.33.1

echo "➡️ Téléchargement de Minikube $MINIKUBE_VERSION..."

curl -Lo minikube https://storage.googleapis.com/minikube/releases/$MINIKUBE_VERSION/minikube-linux-amd64
chmod +x minikube
sudo mv minikube /usr/local/bin/

echo "✅ Minikube installé !"
