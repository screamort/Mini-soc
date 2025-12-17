# Projet Mini-SOC

Un projet de formation complet au Centre d'Opérations de Sécurité (SOC) utilisant Elastic Stack sur Docker pour la détection et l'analyse des menaces en temps réel.

## Statut du Projet

**Phase**: Opérationnel ✅  
**Version**: 1.0  
**Stack**: Elastic Stack (Docker)
**Dernière mise à jour**: 17 décembre 2025

---

## Démarrage Rapide

### Lancer le SOC
1. Naviguez vers: `docker-deployment/`
2. Exécutez: `docker compose -f docker-compose-elastic.yml up -d`
3. Accédez à Kibana: http://localhost:5601
4. Testez la détection: `.\test-bruteforce.ps1`

### Pour le Développement
1. Consultez l'architecture: `01-documentation/ARCHITECTURE.md`
2. Testez les cas d'usage: `04-use-cases/`
3. Lancez les simulations: `docker-deployment/test-*.ps1`

---

## Structure du Projet

```
mini-soc/
├── docker-deployment/             Configurations Docker Compose
│   ├── docker-compose-elastic.yml Services Elastic Stack
│   ├── logstash/                  Pipeline de traitement des logs
│   ├── configure-firewall.ps1     Configuration pare-feu Windows
│   ├── test-bruteforce.ps1        Simulation brute-force SSH
│   ├── test-admin-abuse.ps1       Simulation abus de privilèges
│   ├── test-web-attacks.ps1       Simulation attaques web
│   └── test-all.ps1               Exécute tous les tests
│
├── 01-documentation/              Documentation du projet
│   ├── PROJECT_OVERVIEW.md        Objectifs du projet
│   ├── ARCHITECTURE.md            Architecture système
│   └── INSTALLATION_GUIDE.md      Guide d'installation
│
├── 04-use-cases/                  Scénarios de menaces
│   ├── 01-brute-force/            Brute-force SSH
│   ├── 02-admin-abuse/            Escalade de privilèges
│   └── 03-web-attack/             Injection SQL/XSS
│
├── 05-playbooks/                  Guides d'investigation
│   ├── investigation/             Procédures d'investigation
│   └── response/                  Playbooks de réponse
│
└── 06-dashboards/                 Métriques SOC
    └── SOC-KPI-Dashboard.md       Suivi des KPI
```

---

## Composants Principaux

### Stack Technologique

**Elastic Stack** (Basé sur Docker)
- **Elasticsearch 8.11.0** - Stockage et moteur de recherche
- **Kibana 8.11.0** - Visualisation et tableaux de bord
- **Logstash 8.11.0** - Traitement et enrichissement des logs
- **Ubuntu 22.04** - Conteneur agent de test avec SSH

**Fonctionnalités**
- Pas d'authentification (environnement de lab)
- Accessible sur le réseau (configurable)
- Pipelines de logs pré-configurés
- Simulations d'attaques automatisées

### Cas d'Usage de Détection (Implémentés)

| # | Cas d'Usage | Technique MITRE | Statut |
|---|-------------|-----------------|--------|
| 1 | Attaque Brute-Force | T1110.001 | ✅ Opérationnel |
| 2 | Abus de Privilèges Admin | T1078.003 | ✅ Opérationnel |
| 3 | Attaque Application Web | T1190 | ✅ Opérationnel |

### Services & Ports

- **Kibana Dashboard**: http://localhost:5601
- **Elasticsearch API**: http://localhost:9200
- **Logstash Syslog (UDP)**: Port 5140
- **Logstash Beats (TCP)**: Port 5044  
- **Agent de Test SSH**: Port 2222 (root/testpassword)

---

## Objectifs

### Objectifs de Fin d'Année

**Quantitatifs**:
- ✅ 6 cas d'usage complets avec règles de détection
- ⏳ 1 exercice red-blue team
- ⏳ Documentation professionnelle

**Qualitatifs**:
- ⏳ Taux de faux positifs faible (<10%)
- ⏳ Playbooks d'investigation clairs
- ⏳ Tableau de bord de performance SOC
- ⏳ Documentation REX complète

### Objectifs Supplémentaires
- 8 cas d'usage avec intégration TheHive/Cortex
- Réduction significative des FP par ajustement
- Workflows de réponse automatisés

---

## Démarrage

### Prérequis

**Logiciels**:
- Docker Desktop (Windows/Mac) ou Docker Engine (Linux)
- 8GB RAM minimum
- 20GB d'espace disque libre

**Connaissances** (Optionnel):
- Concepts Docker de base
- Réseaux de base (TCP/IP)
- Bases de ligne de commande

### Installation Rapide

1. **Cloner le dépôt**
   ```bash
   git clone https://github.com/screamort/Mini-soc.git
   cd Mini-soc/docker-deployment
   ```

2. **Démarrer les services**
   ```bash
   docker compose -f docker-compose-elastic.yml up -d
   ```

3. **Attendre 60 secondes**, puis accéder:
   - Kibana: http://localhost:5601
   - Elasticsearch: http://localhost:9200

4. **Tester la détection**
   ```powershell
   .\test-bruteforce.ps1
   ```

5. **Voir les alertes dans Kibana**
   - Aller sur Discover
   - Rechercher: `Failed password`

---

## Indicateurs Clés de Performance

### Métriques de Détection
- **MTTD** (Temps Moyen de Détection): < 15 minutes
- **Couverture de Détection**: > 90% des attaques
- **Taux de Faux Positifs**: < 10%

### Métriques de Réponse
- **MTTA** (Temps Moyen de Prise en Compte): < 5 minutes
- **MTTR** (Temps Moyen de Réponse): < 60 minutes
- **MTTC** (Temps Moyen de Confinement): < 30 minutes

---

## Compétences Acquises

### Compétences Techniques
- Déploiement et configuration SIEM
- Analyse et corrélation de logs
- Développement de règles de détection
- Investigation d'incidents
- Bases de la chasse aux menaces

### Compétences Opérationnelles
- Workflows SOC
- Exécution de playbooks
- Réponse aux incidents
- Suivi des métriques
- Pratiques de documentation

### Préparation aux Certifications
- Objectifs CompTIA Security+
- Expérience pratique SOC
- Scénarios réalistes
- Meilleures pratiques de l'industrie

---

## Ressources

### Documentation
- Tous les guides dans `01-documentation/`
- Détails des cas d'usage dans `04-use-cases/`
- Playbooks dans `05-playbooks/`

### Ressources Externes
- [MITRE ATT&CK Framework](https://attack.mitre.org/)
- [Documentation Wazuh](https://documentation.wazuh.com/)
- [Docs Elastic Security](https://www.elastic.co/guide/en/security/current/index.html)
- [Guide Communautaire Sysmon](https://github.com/SwiftOnSecurity/sysmon-config)

### Communauté
- Wazuh Slack/Forums
- Elastic Community
- /r/sysadmin
- /r/netsec

---

## Contribution

Ceci est un projet d'apprentissage personnel, mais les retours et suggestions sont les bienvenus :

1. Documenter les problèmes ou lacunes trouvés
2. Partager des améliorations aux règles de détection
3. Contribuer des cas d'usage supplémentaires
4. Partager les leçons apprises

---

## Feuille de Route

### Phase 1: Fondation ✅
- [x] Configuration Docker Compose
- [x] Intégration Elastic Stack
- [x] Conteneur agent de test
- [x] Scripts de simulation d'attaques
- [x] Accessibilité réseau

### Phase 2: Détection ✅
- [x] Détection brute-force
- [x] Détection abus admin  
- [x] Détection attaques web
- [x] Pipeline de logs configuré
- [x] Dashboards Kibana accessibles

### Phase 3: Améliorations Futures
- [ ] Cas d'usage supplémentaires (Exfiltration DNS, persistence)
- [ ] Alertes automatisées
- [ ] Automatisation des playbooks de réponse
- [ ] Optimisation des performances

---

## Critères de Succès

### Technique
- Tous les 6 cas d'usage détectent avec >90% de précision
- Taux de FP <10% après ajustement
- MTTD <15 min pour les alertes critiques
- Documentation complète des incidents

### Éducatif
- Compréhension approfondie des opérations SOC
- Expertise pratique SIEM
- Pièce de portfolio professionnelle
- Préparation certification Security+

---

## Licence

Ce projet est à des fins éducatives.  
Les outils open-source utilisés conservent leurs licences respectives.

---

## Remerciements

- MITRE ATT&CK pour le framework
- Communautés Wazuh/Elastic
- SwiftOnSecurity pour les configs Sysmon
- Communauté sécurité open-source

---

## Contact

**Propriétaire du Projet**: Projet de Formation Mini-SOC  
**Créé**: 27 novembre 2025  
**Statut**: Développement Actif

---

## Prochaines Étapes

1. ✅ Cloner et déployer
2. ✅ Accéder au dashboard Kibana
3. ✅ Lancer les simulations d'attaques
4. ➡️ Créer des règles de détection personnalisées
5. ⏳ Construire des dashboards SOC
6. ⏳ Implémenter l'alerting

**Prêt à tester ? Lancez:** `docker compose -f docker-compose-elastic.yml up -d`
