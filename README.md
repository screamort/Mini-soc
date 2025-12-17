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

## Objectives

### End of Year Goals

**Quantitative**:
- ✅ 6 complete use-cases with detection rules
- ⏳ 1 red-blue team exercise
- ⏳ Professional documentation

**Qualitative**:
- ⏳ Low false-positive rates (<10%)
- ⏳ Clear investigation playbooks
- ⏳ SOC performance dashboard
- ⏳ Complete REX documentation

### Stretch Goals
- 8 use-cases with TheHive/Cortex integration
- Significant FP reduction through tuning
- Automated response workflows

---

## Getting Started

### Prerequisites

**Software**:
- Docker Desktop (Windows/Mac) or Docker Engine (Linux)
- 8GB RAM minimum
- 20GB free disk space

**Knowledge** (Optional):
- Basic Docker concepts
- Basic networking (TCP/IP)
- Command line basics

### Quick Installation

1. **Clone repository**
   ```bash
   git clone https://github.com/screamort/Mini-soc.git
   cd Mini-soc/docker-deployment
   ```

2. **Start services**
   ```bash
   docker compose -f docker-compose-elastic.yml up -d
   ```

3. **Wait 60 seconds**, then access:
   - Kibana: http://localhost:5601
   - Elasticsearch: http://localhost:9200

4. **Test detection**
   ```powershell
   .\test-bruteforce.ps1
   ```

5. **View alerts in Kibana**
   - Go to Discover
   - Search: `Failed password`

---

## Key Performance Indicators

### Detection Metrics
- **MTTD** (Mean Time to Detect): < 15 minutes
- **Detection Coverage**: > 90% of attacks
- **False Positive Rate**: < 10%

### Response Metrics
- **MTTA** (Mean Time to Acknowledge): < 5 minutes
- **MTTR** (Mean Time to Respond): < 60 minutes
- **MTTC** (Mean Time to Contain): < 30 minutes

---

## Learning Outcomes

### Technical Skills
- SIEM deployment and configuration
- Log analysis and correlation
- Detection rule development
- Incident investigation
- Threat hunting basics

### Operational Skills
- SOC workflows
- Playbook execution
- Incident response
- Metrics tracking
- Documentation practices

### Certification Preparation
- CompTIA Security+ objectives
- Hands-on SOC experience
- Real-world scenarios
- Industry best practices

---

## Resources

### Documentation
- All guides in `01-documentation/`
- Use-case details in `04-use-cases/`
- Playbooks in `05-playbooks/`

### External Resources
- [MITRE ATT&CK Framework](https://attack.mitre.org/)
- [Wazuh Documentation](https://documentation.wazuh.com/)
- [Elastic Security Docs](https://www.elastic.co/guide/en/security/current/index.html)
- [Sysmon Community Guide](https://github.com/SwiftOnSecurity/sysmon-config)

### Community
- Wazuh Slack/Forums
- Elastic Community
- /r/sysadmin
- /r/netsec

---

## Contributing

This is a personal learning project, but feedback and suggestions are welcome:

1. Document issues or gaps found
2. Share improvements to detection rules
3. Contribute additional use-cases
4. Share lessons learned

---

## Roadmap

### Phase 1: Foundation ✅
- [x] Docker Compose configuration
- [x] Elastic Stack integration
- [x] Test agent container
- [x] Attack simulation scripts
- [x] Network accessibility

### Phase 2: Detection ✅
- [x] Brute-force detection
- [x] Admin abuse detection  
- [x] Web attack detection
- [x] Log pipeline configured
- [x] Kibana dashboards accessible

### Phase 3: Future Enhancements
- [ ] Additional use-cases (DNS exfiltration, persistence)
- [ ] Automated alerting
- [ ] Response playbook automation
- [ ] Performance optimization

---

## Success Criteria

### Technical
- All 6 use-cases detect with >90% accuracy
- FP rate <10% after tuning
- MTTD <15 min for critical alerts
- Complete incident documentation

### Educational
- Deep understanding of SOC operations
- Hands-on SIEM expertise
- Professional portfolio piece
- Security+ certification readiness

---

## License

This project is for educational purposes.  
Open-source tools used retain their respective licenses.

---

## Acknowledgments

- MITRE ATT&CK for framework
- Wazuh/Elastic communities
- SwiftOnSecurity for Sysmon configs
- Open-source security community

---

## Contact

**Project Owner**: Mini-SOC Training Project  
**Created**: November 27, 2025  
**Status**: Active Development

---

## Next Steps

1. ✅ Clone and deploy
2. ✅ Access Kibana dashboard
3. ✅ Run attack simulations
4. ➡️ Create custom detection rules
5. ⏳ Build SOC dashboards
6. ⏳ Implement alerting

**Ready to test? Run:** `docker compose -f docker-compose-elastic.yml up -d`
