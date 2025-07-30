#!/bin/bash

set -e

echo "🚀 [1/6] Vérification de Minikube..."
if ! command -v minikube &>/dev/null; then
  echo "❌ Minikube n'est pas installé. Installe-le avant de continuer."
  exit 1
fi

echo "✅ Minikube est installé."

echo "🟢 [2/6] Démarrage du cluster Minikube..."
minikube start --driver=docker

echo "📡 [3/6] Configuration du contexte kubectl..."
kubectl config use-context minikube

echo "📁 [4/6] Application des manifests Kubernetes (hors secrets classiques)..."
kubectl apply -f k8s/ --exclude=k8s/secret.yaml

echo "🔍 [5/6] Analyse statique avec kube-score..."
if command -v kube-score &>/dev/null; then
  kube-score score k8s/*.yaml || true
else
  echo "⚠️ kube-score n'est pas installé (skipping)"
fi

echo "🔐 [6/6] Application sécurisée du SealedSecret..."
if [ -f "k8s/sealed-mongo-secret.yaml" ]; then
  kubectl apply -f k8s/sealed-mongo-secret.yaml
  echo "✅ SealedSecret Mongo appliqué"
else
  echo "⚠️ Aucun fichier k8s/sealed-mongo-secret.yaml trouvé"
fi

echo "📦 Déploiement terminé avec succès 🎉"
kubectl get all
