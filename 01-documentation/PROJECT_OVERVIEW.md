# Projet Mini-SOC - Vue d'Ensemble

## 1. Origine du Projet

Ce projet a été créé pour acquérir des compétences opérationnelles SOC sans dépendre de solutions logicielles coûteuses. L'objectif est de structurer un apprentissage complet autour des quatre piliers des opérations SOC :

1. **Collecte** - Agrégation des logs et événements
2. **Corrélation** - Analyse d'événements et détection de motifs
3. **Détection** - Identification des menaces via règles et analyses
4. **Réponse** - Gestion et remédiation des incidents

Ce projet sert également de préparation à la **certification Security+** avec une documentation de niveau professionnel et une expérience pratique.

---

## 2. Objectif Principal

Construire un environnement mini-SOC fonctionnel comprenant :

### Composants Principaux
- **Plateforme SIEM**: Solution open-source (Wazuh ou Elastic Security)
- **Agents de Collecte de Logs**:
  - Winlogbeat (logs d'événements Windows)
  - Sysmon (surveillance système Windows)
  - Auditd (audit Linux)
  - Osquery (visibilité des endpoints)
  - pfSense (logs réseau/pare-feu)

### Cas d'Usage de Détection (≪6 Requis)
1. Attaques par force brute
2. Abus de privilèges administrateur
3. Attaques d'applications web
4. Exfiltration DNS
5. Mécanismes de persistence
6. Mouvement latéral

### Éléments Opérationnels
- Playbooks de réponse clairs pour chaque cas d'usage
- Tableau de bord de performance SOC avec KPIs clés :
  - **MTTD** (Temps Moyen de Détection)
  - **MTTR** (Temps Moyen de Réponse)

---

## 3. Objectifs Qualitatifs (Fin d'Année)

- [ ] Règles de détection précises avec faibles taux de faux positifs
- [ ] Playbooks d'investigation simples et actionnables
- [ ] Tableau de bord de performance SOC (KPIs + runbooks)
- [ ] Documentation claire couvrant :
  - Procédures d'installation
  - Workflows opérationnels
  - Guides d'intégration des agents
- [ ] Rapport de retour d'expérience structuré (REX) de l'exercice red-blue team

---

## 4. Objectifs Quantitatifs (Fin d'Année)

- [ ] **6 cas d'usage complets et documentés**
- [ ] **1 exercice red-blue team multi-étapes** simulant des scénarios d'attaque réalistes

---

## 5. Objectifs Supplémentaires (Dépasser les Attentes)

- [ ] **8 cas d'usage publiés** avec intégration avancée TheHive/Cortex
- [ ] **Réduction significative des faux positifs** par ajustement des règles
- [ ] Workflows de réponse automatisés
- [ ] Intégration de flux de threat intelligence

---

## Structure du Projet

```
mini-soc/
├── 01-documentation/          # Project documentation
├── 02-siem-configs/           # SIEM configuration files
│   ├── wazuh/                 # Wazuh configurations
│   └── elastic-security/      # Elastic Security configurations
├── 03-agents-deployment/      # Agent deployment guides & configs
│   ├── windows/               # Windows agents (Winlogbeat, Sysmon)
│   ├── linux/                 # Linux agents (Auditd, Osquery)
│   └── network/               # Network devices (pfSense)
├── 04-use-cases/              # Detection use-cases
│   ├── 01-brute-force/
│   ├── 02-admin-abuse/
│   ├── 03-web-attack/
│   ├── 04-dns-exfiltration/
│   ├── 05-persistence/
│   └── 06-lateral-movement/
├── 05-playbooks/              # Investigation & response playbooks
│   ├── investigation/
│   └── response/
├── 06-dashboards/             # SOC dashboards & KPI tracking
├── 07-red-blue-exercises/     # Red-blue team scenarios
└── 08-rex-feedback/           # Feedback & lessons learned
```

---

## Chronologie & Jalons

### Phase 1 : Fondation (Semaines 1-2)
- Installation et configuration SIEM
- Déploiement d'agents sur systèmes de test
- Validation de collecte de logs basique

### Phase 2 : Développement de Détection (Semaines 3-6)
- Développer 6 cas d'usage principaux
- Créer les règles de détection
- Tests initiaux et ajustements

### Phase 3 : Création de Playbooks (Semaines 7-8)
- Procédures d'investigation
- Workflows de réponse
- Chemins d'escalade

### Phase 4 : Dashboards & Métriques (Semaine 9)
- Implémentation du suivi KPI
- Surveillance des performances
- Statistiques d'alertes

### Phase 5 : Exercice Red-Blue (Semaines 10-11)
- Conception de scénarios
- Simulation d'attaques
- Validation de détection

### Phase 6 : Documentation & REX (Semaine 12)
- Documentation finale
- Leçons apprises
- Améliorations futures

---

## Critères de Succès

### Technique
- Tous les 6 cas d'usage détectent les menaces avec >90% de précision
- Taux de faux positifs <5% après ajustement
- MTTD <15 minutes pour les alertes critiques
- MTTR <60 minutes pour les incidents de haute sévérité

### Éducatif
- Compréhension complète des opérations SOC
- Expérience pratique avec des outils standards de l'industrie
- Portfolio de documentation professionnelle
- Préparation à la certification Security+

---

## Prochaines Étapes

1. Choisir la plateforme SIEM (Wazuh vs Elastic Security)
2. Configurer l'environnement de laboratoire
3. Déployer le premier agent (recommandé : Sysmon sur Windows)
4. Créer le premier cas d'usage (recommandé : Détection de force brute)

---

**Version du Document** : 1.0  
**Dernière Mise à Jour** : 27 novembre 2025  
**Auteur** : Projet de Formation SOC
