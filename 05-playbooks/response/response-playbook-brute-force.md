# Playbook de Réponse aux Incidents - Attaque par Force Brute

## Objectifs de Réponse

1. Prévenir toute violation réussie
2. Minimiser les perturbations  
3. Préserver les preuves
4. Prévenir la récurrence

## Critères d'Activation

- Alerte: 5+ tentatives de connexion échouées en 2 minutes
- Alerte: Connexion réussie après tentatives échouées
- L'analyste SOC confirme un pattern de force brute

## Phases de Réponse

### Phase 1: Détection (0-5 minutes)

Évaluation rapide et triage de l'alerte.

### Phase 2: Confinement (5-15 minutes)

Bloquer l'IP source et protéger les comptes.

### Phase 3: Investigation (15-30 minutes)

Analyser l'attaque et déterminer la portée.

### Phase 4: Récupération (30-60 minutes)

Réinitialiser les identifiants et renforcer les systèmes.

### Phase 5: Post-Incident (1-24 heures)

Documenter et améliorer les défenses.

---

**Version du Playbook** : 1.0  
**Dernière Mise à Jour** : 27 novembre 2025
