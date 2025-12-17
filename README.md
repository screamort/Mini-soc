# Mini-SOC Project

A comprehensive Security Operations Center (SOC) training project using Docker-based Elastic Stack for real-time threat detection and analysis.

## Project Status

**Phase**: Operational ✅  
**Version**: 1.0  
**Stack**: Elastic Stack (Docker)
**Last Updated**: December 17, 2025

---

## Quick Start

### Launch the SOC
1. Navigate to: `docker-deployment/`
2. Run: `docker compose -f docker-compose-elastic.yml up -d`
3. Access Kibana: http://localhost:5601
4. Test detection: `.\test-bruteforce.ps1`

### For Development
1. Review architecture: `01-documentation/ARCHITECTURE.md`
2. Test use-cases: `04-use-cases/`
3. Run simulations: `docker-deployment/test-*.ps1`

---

## Project Structure

```
mini-soc/
├── docker-deployment/             Docker Compose configs
│   ├── docker-compose-elastic.yml Elastic Stack services
│   ├── logstash/                  Log processing pipeline
│   ├── configure-firewall.ps1     Windows firewall setup
│   ├── test-bruteforce.ps1        SSH brute-force simulation
│   ├── test-admin-abuse.ps1       Privilege abuse simulation
│   ├── test-web-attacks.ps1       Web attack simulation
│   └── test-all.ps1               Run all tests
│
├── 01-documentation/              Project documentation
│   ├── PROJECT_OVERVIEW.md        Project goals
│   ├── ARCHITECTURE.md            System architecture
│   └── INSTALLATION_GUIDE.md      Setup guide
│
├── 04-use-cases/                  Threat scenarios
│   ├── 01-brute-force/            SSH brute-force
│   ├── 02-admin-abuse/            Privilege escalation
│   └── 03-web-attack/             SQL injection/XSS
│
├── 05-playbooks/                  Investigation guides
│   ├── investigation/             Investigation procedures
│   └── response/                  Response playbooks
│
└── 06-dashboards/                 SOC metrics
    └── SOC-KPI-Dashboard.md       KPI tracking
```

---

## Core Components

### Technology Stack

**Elastic Stack** (Docker-based)
- **Elasticsearch 8.11.0** - Data storage and search engine
- **Kibana 8.11.0** - Visualization and dashboards
- **Logstash 8.11.0** - Log processing and enrichment
- **Ubuntu 22.04** - Test agent container with SSH

**Features**
- No authentication (lab environment)
- Network accessible (configurable)
- Pre-configured log pipelines
- Automated attack simulations

### Detection Use-Cases (Implemented)

| # | Use Case | MITRE Technique | Status |
|---|----------|-----------------|--------|
| 1 | Brute-Force Attack | T1110.001 | ✅ Operational |
| 2 | Admin Privilege Abuse | T1078.003 | ✅ Operational |
| 3 | Web Application Attack | T1190 | ✅ Operational |

### Services & Ports

- **Kibana Dashboard**: http://localhost:5601
- **Elasticsearch API**: http://localhost:9200
- **Logstash Syslog (UDP)**: Port 5140
- **Logstash Beats (TCP)**: Port 5044  
- **Test Agent SSH**: Port 2222 (root/testpassword)

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
