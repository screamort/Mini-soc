# Demarrage Rapide - Mini-SOC Docker

## Installation en 10 Minutes

### Etape 1: Verifier les Prerequis (1 minute)

```bash
# Verifier Docker
docker --version
# Doit afficher: Docker version 20.x ou superieur

# Verifier Docker Compose
docker compose version
# Doit afficher: Docker Compose version v2.x ou superieur
```

Si Docker n'est pas installe:
- **Windows/Mac**: Installer Docker Desktop
- **Linux**: `sudo apt install docker.io docker-compose-plugin`

---

### Etape 2: Naviguer vers le Dossier (30 secondes)

```bash
cd "docker-deployment"
```

---

### Etape 3: Demarrer le SOC (5 minutes)

```bash
# Lancer tous les services Wazuh
docker compose up -d

# Attendre que tous les conteneurs soient "Up"
docker compose ps
```

Sortie attendue:
```
NAME              STATUS        PORTS
wazuh-manager     Up            1514, 1515, 55000
wazuh-indexer     Up            9200
wazuh-dashboard   Up            0.0.0.0:443->5601
test-agent-linux  Up            0.0.0.0:2222->22
```

---

### Etape 4: Acceder au Dashboard (30 secondes)

1. Ouvrir le navigateur
2. Aller a: `https://localhost:443`
3. Ignorer l'avertissement SSL (certificat auto-signe)
4. Se connecter:
   - **Username**: `admin`
   - **Password**: `SecretPassword`

---

### Etape 5: Verifier que ca Fonctionne (2 minutes)

#### Test 1: Verifier les Agents

Dans le Dashboard Wazuh:
- Cliquer sur "Agents" dans le menu
- Vous devriez voir `test-agent-linux` (peut prendre 1-2 min)

#### Test 2: Generer une Alerte

```bash
# Depuis votre terminal
# Tenter des connexions SSH echouees
for i in {1..10}; do
  ssh -p 2222 fakeuser$i@localhost
  sleep 2
done
# Taper Ctrl+C apres quelques tentatives
```

#### Test 3: Voir l'Alerte

Dans Wazuh Dashboard:
- Cliquer sur "Security Events"
- Chercher "brute" ou "Multiple.*failed login"
- Vous devriez voir l'alerte de brute-force!

---

## Commandes Essentielles

```bash
# Voir les logs en temps reel
docker compose logs -f wazuh-manager

# Arreter le SOC
docker compose stop

# Redemarrer le SOC
docker compose start

# Supprimer completement (ATTENTION: perte de donnees)
docker compose down -v
```

---

## Prochaines Etapes

1. ✅ SOC deploye et fonctionnel
2. ➡️ Tester les autres use-cases (../04-use-cases/)
3. ⏳ Configurer des agents Windows (voir README.md)
4. ⏳ Executer l'exercice red-blue

---

## Problemes Courants

### Le dashboard ne s'affiche pas
```bash
# Attendre 2-3 minutes pour le demarrage complet
docker compose logs wazuh-dashboard

# Redemarrer si necessaire
docker compose restart wazuh-dashboard
```

### Erreur "port already in use"
```bash
# Modifier le port dans docker-compose.yml
# Remplacer "443:5601" par "8443:5601"
# Puis acceder a https://localhost:8443
```

### Pas assez de memoire
```bash
# Fermer d'autres applications
# Ou augmenter la RAM allouee a Docker Desktop
# Parametres > Resources > Memory: 8GB minimum
```

---

**Bravo! Votre mini-SOC est maintenant operationnel! 🎉**
