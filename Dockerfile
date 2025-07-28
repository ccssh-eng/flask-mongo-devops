# ✅ Image de base légère et à jour (Debian Bookworm)
FROM python:3.11-slim-bookworm

# 🔐 Meilleures pratiques : définir un utilisateur non root
ENV APP_HOME=/app
WORKDIR $APP_HOME

# 🛠️ Dépendances système minimales
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libpq-dev \
    curl \
 && rm -rf /var/lib/apt/lists/*

# 📦 Installation des dépendances Python
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip setuptools && \
    pip install --no-cache-dir -r requirements.txt

# 👇 Ajoute le reste du code
COPY . .

# 🔐 Utilisateur non-root
RUN adduser --disabled-password --gecos '' flaskuser && \
    chown -R flaskuser $APP_HOME
USER flaskuser

# 🌍 Port exposé
EXPOSE 5000

# 🚀 Commande de lancement
CMD ["python", "app.py"]
