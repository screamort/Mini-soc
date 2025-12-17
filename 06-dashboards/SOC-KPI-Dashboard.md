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

### 4. Alert Volume

**Metrics**:
- Total alerts per day
- Alerts by severity
- Alerts by use case
- Alerts by data source

**Targets**:
- Keep total volume manageable (< 100/day for small SOC)
- 70% Low/Medium, 20% High, 10% Critical

**Dashboard Visualization**: 
- Daily volume trend line
- Pie chart by severity
- Bar chart by use case

---

### 5. False Positive Rate

**Definition**: Percentage of alerts that are false positives.

**Formula**:
```
False Positive Rate = (False Positives / Total Alerts) × 100
```

**Target**: < 10%

**Measurement**:
- Track analyst classification of each alert
- Calculate percentage monthly

**Dashboard Visualization**: Line chart showing FP rate trend

---

### 6. Detection Coverage

**Metrics**:
- Number of active detection rules
- Number of monitored endpoints
- Number of log sources
- Coverage by MITRE ATT&CK technique

**Target**: 
- 100% of endpoints monitored
- >50% coverage of MITRE ATT&CK techniques

**Dashboard Visualization**: 
- Endpoint coverage percentage
- MITRE ATT&CK heatmap

---

### 7. Incident Severity Distribution

**Metrics**:
- Count by severity level
- Trend over time

**Healthy Distribution**:
- Critical: 5-10%
- High: 10-20%
- Medium: 30-40%
- Low: 40-50%

**Dashboard Visualization**: Stacked area chart

---

## Operational Metrics

### 8. Alert Handling Efficiency

**Metrics**:
- Alerts closed per analyst per day
- Average handling time per alert
- Escalation rate

**Targets**:
- Handling time: < 30 minutes average
- Escalation rate: < 20%

---

### 9. Detection Rule Performance

**Metrics per rule**:
- Total alerts generated
- True positive count
- False positive count
- Accuracy rate

**Formula**:
```
Rule Accuracy = (True Positives / Total Alerts) × 100
```

**Target**: > 90% accuracy per rule

---

### 10. Threat Intelligence Integration

**Metrics**:
- IOC matches per day
- Threat intel sources active
- Time from IOC publication to detection

**Target**: Detect known IOCs within 24 hours of publication

---

## Dashboard Implementation

### Wazuh Dashboard Configuration

The Wazuh dashboard provides built-in visualizations. Custom dashboards can be created in Kibana.

**Key Visualizations**:
1. Security Events Overview
2. Top Security Alerts
3. Alert Evolution by Rule
4. Agent Status
5. MITRE ATT&CK Coverage

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
