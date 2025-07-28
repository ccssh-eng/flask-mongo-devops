#!/bin/bash

set -e

FILE="minikube-linux-amd64"

echo "🧹 Removing $FILE from Git history..."

# Supprimer le fichier suivi
git rm --cached "$FILE" || echo "⚠️ File not tracked in index."
rm -f "$FILE"

# Ajouter au .gitignore
echo "$FILE" >> .gitignore
git add .gitignore
git commit -m "remove large file $FILE and ignore it"

# Nettoyer l'historique (nécessite git-filter-repo)
echo "🧹 Rewriting Git history..."
pip install git-filter-repo
git filter-repo --path "$FILE" --invert-paths

# Forcer le push propre
git push --force

echo "✅ Cleanup complete."
