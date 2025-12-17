# Tableau de Bord de Performance SOC - Suivi des KPI

## Vue d'Ensemble du Tableau de Bord

Ce document décrit les indicateurs clés de performance (KPI) pour surveiller l'efficacité et l'efficience du SOC.

---

## KPI Critiques

### 1. Temps Moyen de Détection (MTTD)

**Définition** : Temps moyen entre le début d'une attaque et sa détection par le SOC.

**Formule** : 
```
MTTD = (Heure de Détection - Heure de Début de l'Attaque)
```

**Objectif** : < 15 minutes pour les alertes critiques

**Mesure** :
- Horodatage de la première activité malveillante
- Horodatage de génération de l'alerte
- Calculer la différence

**Visualisation Tableau de Bord** : Graphique linéaire montrant la tendance MTTD dans le temps

---

### 2. Temps Moyen de Prise en Charge (MTTA)

**Définition** : Temps moyen entre la génération de l'alerte et l'accusé de réception par l'analyste.

**Formule** :
```
MTTA = (Heure d'Accusé de Réception - Heure de l'Alerte)
```

**Objectif** : < 5 minutes

**Mesure** :
- Horodatage de création de l'alerte
- Horodatage d'accusé de réception de l'analyste
- Calculer la différence

**Visualisation Tableau de Bord** : Graphique à barres par sévérité d'alerte

---

### 3. Temps Moyen de Réponse (MTTR)

**Définition** : Temps moyen entre la détection de l'alerte et l'action de confinement.

**Formule** :
```
MTTR = (Heure de Confinement - Heure de Détection)
```

**Objectifs** :
- Critique : < 15 minutes
- Élevé : < 30 minutes
- Moyen : < 60 minutes
- Faible : < 4 heures

**Visualisation Tableau de Bord** : Graphique à barres empilées par niveau de sévérité

---

### 4. Volume des Alertes

**Métriques** :
- Nombre total d'alertes par jour
- Alertes par sévérité
- Alertes par cas d'usage
- Alertes par source de données

**Objectifs** :
- Garder le volume total gérable (< 100/jour pour petit SOC)
- 70% Faible/Moyen, 20% Élevé, 10% Critique

**Visualisation Tableau de Bord** : 
- Courbe de tendance quotidienne
- Camembert par sévérité
- Graphique à barres par cas d'usage

---

### 5. Taux de Faux Positifs

**Définition** : Pourcentage d'alertes qui sont des faux positifs.

**Formule** :
```
Taux de Faux Positifs = (Faux Positifs / Alertes Totales) × 100
```

**Objectif** : < 10%

**Mesure** :
- Suivre la classification de chaque alerte par l'analyste
- Calculer le pourcentage mensuellement

**Visualisation Tableau de Bord** : Graphique linéaire montrant la tendance du taux de faux positifs

---

### 6. Couverture de Détection

**Métriques** :
- Nombre de règles de détection actives
- Nombre de points de terminaison surveillés
- Nombre de sources de logs
- Couverture par technique MITRE ATT&CK

**Objectif** : 
- 100% des points de terminaison surveillés
- >50% de couverture des techniques MITRE ATT&CK

**Visualisation Tableau de Bord** : 
- Pourcentage de couverture des points de terminaison
- Carte thermique MITRE ATT&CK

---

### 7. Distribution de la Sévérité des Incidents

**Métriques** :
- Comptage par niveau de sévérité
- Tendance dans le temps

**Distribution Saine** :
- Critique : 5-10%
- Élevé : 10-20%
- Moyen : 30-40%
- Faible : 40-50%

**Visualisation Tableau de Bord** : Graphique en aires empilées

---

## Métriques Opérationnelles

### 8. Efficacité de Traitement des Alertes

**Métriques** :
- Alertes fermées par analyste par jour
- Temps moyen de traitement par alerte
- Taux d'escalade

**Objectifs** :
- Temps de traitement : < 30 minutes en moyenne
- Taux d'escalade : < 20%

---

### 9. Performance des Règles de Détection

**Métriques par règle** :
- Nombre total d'alertes générées
- Nombre de vrais positifs
- Nombre de faux positifs
- Taux de précision

**Formule** :
```
Précision de la Règle = (Vrais Positifs / Alertes Totales) × 100
```

**Objectif** : > 90% de précision par règle

---

### 10. Intégration d'Intelligence sur les Menaces

**Métriques** :
- Correspondances IOC par jour
- Sources d'intelligence sur les menaces actives
- Temps entre publication IOC et détection

**Objectif** : Détecter les IOC connus dans les 24 heures suivant leur publication

---

## Implémentation du Tableau de Bord

### Configuration du Tableau de Bord Wazuh

Le tableau de bord Wazuh fournit des visualisations intégrées. Des tableaux de bord personnalisés peuvent être créés dans Kibana.

**Visualisations Clés** :
1. Vue d'Ensemble des Événements de Sécurité
2. Alertes de Sécurité Principales
3. Évolution des Alertes par Règle
4. Statut des Agents
5. Couverture MITRE ATT&CK

---

### Elastic Kibana Dashboard

Create custom dashboard with these panels:

**Panel 1: Alert Volume**
```json
{
  "visualization": "line",
  "data_source": "alerts",
  "aggregation": "count",
  "time_field": "@timestamp",
  "interval": "1h"
}
```

**Panel 2: MTTD/MTTR**
```json
{
  "visualization": "metric",
  "calculation": "average",
  "field": "response_time_minutes"
}
```

**Panel 3: Top Threats**
```json
{
  "visualization": "table",
  "fields": ["rule.name", "count", "severity"],
  "sort": "count DESC",
  "limit": 10
}
```

---

## KPI Tracking Spreadsheet

Track metrics in Excel/Google Sheets:

| Date | Total Alerts | Critical | High | Medium | Low | MTTD (min) | MTTR (min) | False Positives |
|------|--------------|----------|------|--------|-----|------------|------------|-----------------|
| 2025-01-01 | 45 | 2 | 8 | 15 | 20 | 8 | 22 | 3 |
| 2025-01-02 | 52 | 3 | 10 | 18 | 21 | 6 | 18 | 4 |

Calculate:
- FP Rate = (FP / Total) × 100
- Average MTTD per week
- Average MTTR per severity

---

## Monthly SOC Report Template

```markdown
# SOC Monthly Performance Report
## [Month Year]

### Executive Summary
[Brief overview of the month]

### Key Metrics
- Total Alerts: [Count]
- Critical Incidents: [Count]
- Average MTTD: [Minutes]
- Average MTTR: [Minutes]
- False Positive Rate: [Percentage]

### Top Threats Detected
1. [Threat type] - [Count] incidents
2. [Threat type] - [Count] incidents
3. [Threat type] - [Count] incidents

### Improvements Made
- [Improvement 1]
- [Improvement 2]

### Next Month Goals
- [Goal 1]
- [Goal 2]
```

---

## Continuous Improvement

### Weekly Review
- Review alert volume trends
- Identify high false-positive rules
- Tune detection rules
- Update playbooks based on lessons learned

### Monthly Review
- Comprehensive KPI analysis
- SOC performance report
- Rule effectiveness review
- Training needs assessment

### Quarterly Review
- Strategic improvements
- Technology evaluation
- Staffing assessment
- Budget planning

---

**Dashboard Version**: 1.0  
**Last Updated**: November 27, 2025
