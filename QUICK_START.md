# Guide de Démarrage Rapide - Mini-SOC

## Aperçu en 5 Minutes

Ce projet fournit un Centre d'Opérations de Sécurité (SOC) pleinement fonctionnel utilisant Docker et Elastic Stack.

**Objectif**: Exécuter un SOC complet en moins de 5 minutes  
**Temps**: 5 minutes pour déployer, des jours pour maîtriser  
**Coût**: Gratuit (Docker + Elastic Stack)

---

## Ce Que Vous Obtiendrez

- ✅ Elasticsearch pour le stockage des logs
- ✅ Kibana pour la visualisation
- ✅ Logstash pour le traitement des logs
- ✅ 3 simulations d'attaques pré-configurées
- ✅ Conteneur agent de test (Ubuntu avec SSH)
- ✅ Services accessibles sur le réseau

---

## Étape par Étape (5 Minutes)

### Étape 1: Prérequis (1 minute)
- Installer Docker Desktop (Windows/Mac) ou Docker Engine (Linux)
- Minimum 8GB RAM disponible
- 20GB d'espace disque libre

### Étape 2: Cloner & Déployer (2 minutes)
```bash
# Cloner le dépôt
git clone https://github.com/screamort/Mini-soc.git
cd Mini-soc/docker-deployment

# Démarrer tous les services
docker compose -f docker-compose-elastic.yml up -d
```

### Étape 3: Attendre le Démarrage (2 minutes)
Les services prennent ~60 secondes à s'initialiser:
- Elasticsearch
- Kibana  
- Logstash
- Agent de Test

### Étape 4: Accéder & Tester (1 minute)
1. **Ouvrir Kibana**: http://localhost:5601
2. **Lancer le premier test**:
   ```powershell
   # Windows PowerShell
   .\test-bruteforce.ps1
   ```
   ```bash
   # Linux/Mac
   ./test-bruteforce.ps1
   ```
3. **Voir les résultats** dans Kibana > Discover > Rechercher: `Failed password`

---

## Services & Accès

| Service | URL | Objectif |
|---------|-----|----------|
| Kibana | http://localhost:5601 | Tableaux de bord & visualisation |
| Elasticsearch | http://localhost:9200 | Stockage & recherche de données |
| Logstash Syslog | UDP 5140 | Collecte de logs |
| Logstash Beats | TCP 5044 | Connexions agents |
| Agent de Test SSH | Port 2222 | Cible d'attaque (root/testpassword) |

## Scripts de Test Disponibles

| Script | Type d'Attaque | Événements Générés |
|--------|----------------|----------------------|
| `test-bruteforce.ps1` | Brute-force SSH | 10 échecs de connexion |
| `test-admin-abuse.ps1` | Abus de privilèges | 5 commandes sudo |
| `test-web-attacks.ps1` | Attaques web | 6 tentatives SQL/XSS |
| `test-all.ps1` | Toutes les attaques | 21 événements totaux |

---

## Problèmes Courants

### Problème 1: Docker Ne Fonctionne Pas
**Solution**: 
- Démarrer Docker Desktop
- Attendre 30 secondes que Docker s'initialise
- Réessayer `docker compose up -d`

### Problème 2: Port Déjà Utilisé
**Solution**:
- Vérifier si les services sont déjà en cours: `docker ps`
- Arrêter les conteneurs existants: `docker compose down`
- Tuer le processus utilisant le port: `netstat -ano | findstr :5601`

### Problème 3: Kibana Non Accessible
**Solution**:
- Attendre 60-90 secondes après `docker compose up`
- Vérifier le statut des conteneurs: `docker compose ps`
- Voir les logs: `docker compose logs kibana`

### Problème 4: Accès Réseau depuis D'autres Appareils
**Solution**:
- Exécuter le script pare-feu (en Admin): `.\configure-firewall.ps1`
- Utiliser l'IP de votre machine au lieu de localhost
- S'assurer que les appareils sont sur le même réseau

---

## Votre Première Heure

**Minute 0-5**: Déployer la stack  
**Minute 5-10**: Explorer l'interface Kibana  
**Minute 10-20**: Lancer les simulations d'attaques  
**Minute 20-40**: Analyser les résultats de détection  
**Minute 40-60**: Créer le premier dashboard

---

## Commandes Critiques

### Démarrer/Arrêter les Services
```bash
# Démarrer tous les services
docker compose -f docker-compose-elastic.yml up -d

# Arrêter tous les services
docker compose -f docker-compose-elastic.yml down

# Voir le statut
docker compose -f docker-compose-elastic.yml ps
```

### Voir les Logs
```bash
# Tous les services
docker compose logs

# Service spécifique
docker compose logs kibana
docker compose logs elasticsearch

# Suivre les logs
docker compose logs -f
```

### Accéder à l'Agent de Test
```bash
# SSH dans l'agent de test
ssh -p 2222 root@localhost
# Mot de passe: testpassword

# Exécuter une commande dans le conteneur
docker exec -it test-agent bash
```

---

## Liste de Contrôle de Succès (Première Heure)

- [ ] Docker Desktop en cours d'exécution
- [ ] Dépôt cloné
- [ ] Services déployés (`docker compose up -d`)
- [ ] Kibana accessible (http://localhost:5601)
- [ ] Script de test exécuté
- [ ] Logs visibles dans Kibana Discover
- [ ] Événements d'attaque détectés
- [ ] Prêt pour les tests avancés

---

## Besoin d'Aide ?

1. **Consulter la documentation**: dossier `01-documentation/`
2. **Revoir le cas d'usage**: Étapes détaillées dans `04-use-cases/`
3. **Suivre le playbook**: Étape par étape dans `05-playbooks/`
4. **Ressources communautaires**: 
   - Documentation Wazuh
   - Documentation Elastic
   - Forums de sécurité

---

## Prochaines Étapes Après la Semaine 1

1. ✅ Semaine 1 terminée - Configuration de base effectuée
2. ➡️ Semaine 2 - Compléter le cas d'usage #2 (Abus admin)
3. ⏳ Semaine 3 - Compléter le cas d'usage #3 (Attaques web)
4. ⏳ Semaine 4 - Compléter le cas d'usage #4 (Exfiltration DNS)
5. ⏳ Semaine 5 - Compléter le cas d'usage #5 (Persistence)
6. ⏳ Semaine 6 - Compléter le cas d'usage #6 (Mouvement latéral)
7. ⏳ Semaine 7-8 - Ajuster les règles, réduire les faux positifs
8. ⏳ Semaine 9 - Implémenter le dashboard KPI
9. ⏳ Semaine 10-11 - Exercice red-blue
10. ⏳ Semaine 12 - Documentation finale et REX

---

## Conseils Rapides

✅ **Commencer simple**: Débutez avec Wazuh, c'est plus facile pour les débutants  
✅ **Une étape à la fois**: Ne vous précipitez pas, validez chaque composant  
✅ **Tout documenter**: Utilisez le modèle REX dès le premier jour  
✅ **Tester fréquemment**: Casser et réparer pour mieux apprendre  
✅ **Poser des questions**: Les communautés sont utiles  

❌ **Ne pas sauter la validation**: Toujours vérifier avant de continuer  
❌ **Ne pas exécuter en production**: Utiliser un environnement de test isolé  
❌ **Ne pas ignorer les erreurs**: Corriger les problèmes avant de procéder  

---

**Prêt à commencer ? Débutez ici**: `01-documentation/INSTALLATION_GUIDE.md`

**Des questions ?** Consultez la documentation dans `01-documentation/`

**Bonne chance ! 🚀**
