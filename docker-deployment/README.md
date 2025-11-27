# Mini-SOC - Docker Deployment

Deployez votre mini-SOC en utilisant Docker et Docker Compose.

## Prerequis

### Logiciels Requis
- Docker Desktop (Windows/Mac) ou Docker Engine (Linux)
- Docker Compose v2.0+
- Au moins 8 GB RAM disponible
- 50 GB d'espace disque

### Verifier l'Installation
```bash
docker --version
docker compose version
```

---

## Architecture Docker

```
┌─────────────────────────────────────────────────────────────┐
│                    Docker Network: soc-network               │
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Wazuh      │  │   Wazuh      │  │   Wazuh      │      │
│  │   Manager    │◄─┤   Indexer    │◄─┤  Dashboard   │      │
│  │              │  │ (OpenSearch) │  │   (Web UI)   │      │
│  │  Port 1514   │  │  Port 9200   │  │  Port 443    │      │
│  └──────┬───────┘  └──────────────┘  └──────────────┘      │
│         │                                                    │
│         │ Logs                                              │
│         │                                                    │
│  ┌──────▼───────┐                                           │
│  │ Test Agent   │                                           │
│  │   (Linux)    │                                           │
│  │  Port 2222   │                                           │
│  └──────────────┘                                           │
│                                                              │
│  Alternative: Elastic Stack (profile: elastic)              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │Elasticsearch │◄─┤   Logstash   │◄─┤    Kibana    │     │
│  │  Port 9201   │  │  Port 5044   │  │  Port 5601   │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
└─────────────────────────────────────────────────────────────┘
```

---

## Demarrage Rapide

### Option 1: Wazuh (Recommande)

```bash
# 1. Naviguer vers le dossier
cd docker-deployment

# 2. Demarrer les services Wazuh
docker compose up -d

# 3. Verifier les containers
docker compose ps

# 4. Voir les logs
docker compose logs -f wazuh-manager
```

**Acceder au Dashboard:**
- URL: `https://localhost:443`
- Username: `admin`
- Password: `SecretPassword`

### Option 2: Elastic Stack

```bash
# Demarrer avec le profil Elastic
docker compose --profile elastic up -d

# Acceder a Kibana
# URL: http://localhost:5601
```

---

## Configuration Detaillee

### Structure des Fichiers

```
docker-deployment/
├── docker-compose.yml          # Configuration principale
├── .env                        # Variables d'environnement
├── custom-rules.xml            # Regles Wazuh personnalisees
├── Dockerfile.wazuh-agent      # Image agent Wazuh
├── auditd-rules.conf          # Regles auditd
├── build-agent.sh             # Script de build agent
├── logstash/
│   ├── config/
│   │   └── logstash.yml       # Config Logstash
│   └── pipeline/
│       └── logstash.conf      # Pipeline de traitement
└── README.md                  # Ce fichier
```

### Variables d'Environnement (.env)

Editez le fichier `.env` pour personnaliser:

```bash
# Mots de passe
INDEXER_PASSWORD=VotreMotDePasse
API_PASSWORD=VotreAPIPassword

# Resources
ELASTICSEARCH_HEAP=2g
WAZUH_INDEXER_HEAP=1g
```

---

## Services Disponibles

### Services Wazuh (par defaut)

| Service | Port | Description |
|---------|------|-------------|
| wazuh-manager | 1514, 1515, 55000 | SIEM principal |
| wazuh-indexer | 9200 | Stockage des logs |
| wazuh-dashboard | 443 | Interface web |
| test-agent-linux | 2222 | Agent de test SSH |

### Services Elastic (profile: elastic)

| Service | Port | Description |
|---------|------|-------------|
| elasticsearch | 9201 | Stockage |
| logstash | 5044, 5140 | Processing |
| kibana | 5601 | Dashboard |

### Services Optionnels (profile: monitoring)

| Service | Port | Description |
|---------|------|-------------|
| grafana | 3000 | Metriques (admin/admin) |

---

## Operations

### Demarrer les Services

```bash
# Tous les services Wazuh
docker compose up -d

# Avec Elastic Stack
docker compose --profile elastic up -d

# Avec monitoring (Grafana)
docker compose --profile monitoring up -d

# Tous les profiles
docker compose --profile elastic --profile monitoring up -d
```

### Arreter les Services

```bash
# Arreter sans supprimer
docker compose stop

# Arreter et supprimer les conteneurs
docker compose down

# Supprimer avec les volumes (ATTENTION: perte de donnees)
docker compose down -v
```

### Voir les Logs

```bash
# Tous les services
docker compose logs -f

# Service specifique
docker compose logs -f wazuh-manager
docker compose logs -f wazuh-dashboard

# Derniers 100 lignes
docker compose logs --tail=100 wazuh-manager
```

### Verifier l'Etat

```bash
# Status de tous les conteneurs
docker compose ps

# Details d'un service
docker inspect wazuh-manager

# Utilisation des ressources
docker stats
```

---

## Importer les Regles de Detection

Les regles personnalisees sont automatiquement montees depuis `custom-rules.xml`.

### Verifier les Regles

```bash
# Entrer dans le conteneur manager
docker compose exec wazuh-manager bash

# Verifier les regles
cat /var/ossec/etc/rules/local_rules.xml

# Tester les regles
/var/ossec/bin/wazuh-logtest

# Redemarrer pour appliquer les changements
docker compose restart wazuh-manager
```

---

## Tester la Detection

### Test 1: Brute-Force SSH

```bash
# Depuis votre machine hote
# Tentatives de connexion echouees
for i in {1..10}; do
  ssh -p 2222 fakeuser$i@localhost
  sleep 2
done

# Verifier les alertes dans Wazuh Dashboard
# Security Events > Rule ID 100002
```

### Test 2: Commande Sudo

```bash
# Entrer dans l'agent de test
docker compose exec test-agent-linux sh

# Executer des commandes sudo
sudo ls /root
sudo cat /etc/shadow

# Verifier l'alerte dans Wazuh
# Rule ID: sudo_execution
```

### Test 3: Modification de Fichier Sensible

```bash
# Dans l'agent
docker compose exec test-agent-linux sh

# Modifier passwd
echo "testuser:x:1001:1001::/home/testuser:/bin/bash" >> /etc/passwd

# Verifier l'alerte
# Rule ID: passwd_changes
```

---

## Deployer des Agents Personnalises

### Construire l'Image Agent

```bash
# Build l'image
docker build -f Dockerfile.wazuh-agent -t mini-soc-wazuh-agent:latest .

# Ou utiliser le script
bash build-agent.sh
```

### Ajouter au Docker Compose

Ajoutez dans `docker-compose.yml`:

```yaml
  custom-agent-1:
    image: mini-soc-wazuh-agent:latest
    container_name: custom-agent-1
    hostname: custom-agent-1
    environment:
      - WAZUH_MANAGER=wazuh-manager
    networks:
      - soc-network
    depends_on:
      - wazuh-manager
```

---

## Monitoring et Performance

### Verifier la Consommation

```bash
# Memoire et CPU en temps reel
docker stats

# Espace disque des volumes
docker system df -v
```

### Limiter les Ressources

Editez `docker-compose.yml`:

```yaml
services:
  wazuh-manager:
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 4G
        reservations:
          memory: 2G
```

---

## Troubleshooting

### Probleme: Services ne demarrent pas

```bash
# Verifier les logs
docker compose logs

# Verifier l'espace disque
df -h

# Verifier la memoire
free -h

# Nettoyer Docker
docker system prune -a
```

### Probleme: Agent ne se connecte pas

```bash
# Verifier la connectivite reseau
docker compose exec test-agent-linux ping wazuh-manager

# Verifier le port 1514
docker compose exec wazuh-manager netstat -tuln | grep 1514

# Voir les logs de l'agent
docker compose logs test-agent-linux
```

### Probleme: Dashboard inaccessible

```bash
# Verifier que le service tourne
docker compose ps wazuh-dashboard

# Redemarrer le dashboard
docker compose restart wazuh-dashboard

# Verifier les logs
docker compose logs wazuh-dashboard
```

### Probleme: Performances lentes

```bash
# Augmenter la memoire Java (editez .env)
WAZUH_INDEXER_HEAP=2g

# Redemarrer les services
docker compose restart

# Limiter les logs (editez custom-rules.xml)
# Ajouter des exclusions pour reduire le volume
```

---

## Sauvegarde et Restauration

### Sauvegarder les Donnees

```bash
# Creer un backup des volumes
docker run --rm -v mini-soc_wazuh_etc:/data -v $(pwd):/backup \
  ubuntu tar czf /backup/wazuh-etc-backup.tar.gz /data

# Backup de l'indexer
docker run --rm -v mini-soc_wazuh-indexer-data:/data -v $(pwd):/backup \
  ubuntu tar czf /backup/wazuh-indexer-backup.tar.gz /data
```

### Restaurer les Donnees

```bash
# Restaurer depuis backup
docker run --rm -v mini-soc_wazuh_etc:/data -v $(pwd):/backup \
  ubuntu tar xzf /backup/wazuh-etc-backup.tar.gz -C /

# Redemarrer les services
docker compose restart
```

---

## Mise a Jour

### Mettre a Jour les Images

```bash
# Telecharger les nouvelles images
docker compose pull

# Redemarrer avec les nouvelles images
docker compose up -d

# Nettoyer les anciennes images
docker image prune -a
```

---

## Nettoyage Complet

```bash
# ATTENTION: Supprime tout (donnees incluses)
docker compose down -v
docker rmi mini-soc-wazuh-agent:latest
docker system prune -a -f
```

---

## Configuration Avancee

### Ajouter un Reverse Proxy (Nginx)

Ajoutez dans `docker-compose.yml`:

```yaml
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - wazuh-dashboard
    networks:
      - soc-network
```

### Activer HTTPS avec Certificats

```bash
# Generer des certificats auto-signes
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout wazuh-dashboard.key -out wazuh-dashboard.crt

# Monter dans le conteneur (editez docker-compose.yml)
volumes:
  - ./wazuh-dashboard.crt:/etc/ssl/certs/wazuh.crt:ro
  - ./wazuh-dashboard.key:/etc/ssl/private/wazuh.key:ro
```

---

## Ressources Necessaires

### Configuration Minimale
- CPU: 4 cores
- RAM: 8 GB
- Disk: 50 GB

### Configuration Recommandee
- CPU: 8 cores
- RAM: 16 GB
- Disk: 100 GB SSD

### Production
- CPU: 16+ cores
- RAM: 32+ GB
- Disk: 500+ GB SSD

---

## Prochaines Etapes

1. ✅ Services deployes
2. ➡️ Tester les 6 use-cases
3. ⏳ Configurer les alertes
4. ⏳ Ajuster les regles
5. ⏳ Executer l'exercice red-blue

---

## Support

**Documentation Complete**: Voir `../01-documentation/`  
**Use-Cases**: Voir `../04-use-cases/`  
**Playbooks**: Voir `../05-playbooks/`

---

**Version**: 1.0  
**Date**: November 27, 2025
