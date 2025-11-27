# Mini-SOC Project

A comprehensive Security Operations Center (SOC) training project focused on building operational skills using open-source tools.

## Project Status

**Phase**: Foundation Complete ✅  
**Version**: 1.0  
**Last Updated**: November 27, 2025

---

## Quick Start

### For Beginners
1. Read: [`01-documentation/PROJECT_OVERVIEW.md`](01-documentation/PROJECT_OVERVIEW.md)
2. Review: [`01-documentation/ARCHITECTURE.md`](01-documentation/ARCHITECTURE.md)
3. Follow: [`01-documentation/INSTALLATION_GUIDE.md`](01-documentation/INSTALLATION_GUIDE.md)

### For Implementation
1. Choose your SIEM: Wazuh (recommended) or Elastic Security
2. Deploy agents: See `03-agents-deployment/`
3. Import detection rules: See `02-siem-configs/`
4. Test with first use-case: `04-use-cases/01-brute-force/`

---

## Project Structure

```
mini-soc/
├── 01-documentation/              Project docs & guides
│   ├── PROJECT_OVERVIEW.md        Project goals & timeline
│   ├── ARCHITECTURE.md            System architecture
│   └── INSTALLATION_GUIDE.md      Installation steps
│
├── 02-siem-configs/               SIEM configurations
│   ├── wazuh/                     Wazuh detection rules
│   └── elastic-security/          Elastic Security rules
│
├── 03-agents-deployment/          Agent deployment guides
│   ├── windows/                   Windows agents (Sysmon, Winlogbeat)
│   ├── linux/                     Linux agents (Auditd, Osquery)
│   └── network/                   Network devices (pfSense)
│
├── 04-use-cases/                  Detection use-cases
│   ├── 01-brute-force/            Brute-force detection
│   ├── 02-admin-abuse/            Admin privilege abuse
│   ├── 03-web-attack/             Web application attacks
│   ├── 04-dns-exfiltration/       DNS exfiltration
│   ├── 05-persistence/            Persistence mechanisms
│   └── 06-lateral-movement/       Lateral movement
│
├── 05-playbooks/                  SOC playbooks
│   ├── investigation/             Investigation procedures
│   └── response/                  Incident response playbooks
│
├── 06-dashboards/                 SOC dashboards
│   └── SOC-KPI-Dashboard.md       KPI tracking (MTTD, MTTR)
│
├── 07-red-blue-exercises/         Red-blue team scenarios
│   └── Red-Blue-Exercise-Scenario-01.md
│
└── 08-rex-feedback/               Feedback & lessons learned
    └── REX-Template.md            After-action review template
```

---

## Core Components

### SIEM Platform Options

**Wazuh** (Recommended for beginners)
- All-in-one security platform
- Pre-configured rules
- Built-in compliance monitoring
- Free and open-source

**Elastic Security**
- Industry-standard ELK stack
- Powerful query language (KQL)
- Advanced ML capabilities
- Flexible and scalable

### Detection Use-Cases (6 Required)

| # | Use Case | MITRE Technique | Priority |
|---|----------|-----------------|----------|
| 1 | Brute-Force Attack | T1110.001 | High |
| 2 | Admin Privilege Abuse | T1078.003 | High |
| 3 | Web Application Attack | T1190 | Medium |
| 4 | DNS Exfiltration | T1071.004 | Medium |
| 5 | Persistence Mechanisms | T1547 | High |
| 6 | Lateral Movement | T1021 | High |

### Key Agents

- **Sysmon**: Windows system monitoring
- **Winlogbeat**: Windows log forwarding
- **Auditd**: Linux auditing
- **Osquery**: Endpoint visibility
- **pfSense**: Network/firewall logs

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

**Knowledge**:
- Basic networking (TCP/IP, DNS)
- Windows/Linux administration
- Command line proficiency

**Hardware** (Virtual Lab):
- SIEM Server: 4 vCPU, 8GB RAM, 100GB disk
- Test Windows: 2 vCPU, 4GB RAM
- Test Linux: 2 vCPU, 2GB RAM

**Software**:
- VMware/VirtualBox/Hyper-V
- Ubuntu Server 22.04 (for SIEM)
- Windows 10/11 (for testing)
- Linux (Ubuntu/Debian for testing)

### Installation Path

1. **Week 1-2**: Set up SIEM platform
   - Follow `01-documentation/INSTALLATION_GUIDE.md`
   - Choose Wazuh or Elastic Security
   - Verify dashboard access

2. **Week 3**: Deploy first agents
   - Windows: Sysmon + Winlogbeat
   - Linux: Auditd
   - Verify log ingestion

3. **Week 4**: Implement first use-case
   - Start with brute-force detection
   - Import detection rules
   - Test with simulation

4. **Week 5-8**: Complete remaining use-cases
   - One use-case per week
   - Test each thoroughly
   - Document findings

5. **Week 9**: Create dashboards
   - Implement KPI tracking
   - MTTD/MTTR monitoring

6. **Week 10-11**: Red-blue exercise
   - Execute attack scenario
   - Test detection/response
   - Document REX

7. **Week 12**: Final documentation
   - Complete all playbooks
   - Lessons learned
   - Future roadmap

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

### Phase 1: Foundation (Current) ✅
- [x] Project structure created
- [x] Core documentation written
- [x] SIEM configs prepared
- [x] Agent deployment guides created
- [x] 6 use-case templates ready
- [x] Playbooks documented
- [x] Dashboard framework defined
- [x] Red-blue exercise designed

### Phase 2: Implementation (Next)
- [ ] SIEM deployed
- [ ] Agents installed
- [ ] Detection rules active
- [ ] First use-case tested

### Phase 3: Validation
- [ ] All 6 use-cases operational
- [ ] Playbooks tested
- [ ] Metrics tracked
- [ ] Red-blue exercise executed

### Phase 4: Optimization
- [ ] False positives tuned
- [ ] Response times optimized
- [ ] Documentation refined
- [ ] REX completed

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

1. ✅ Review project structure
2. ➡️ Choose SIEM platform (Wazuh recommended)
3. ⏳ Set up lab environment
4. ⏳ Begin installation
5. ⏳ Deploy first agent
6. ⏳ Test first use-case

**Ready to begin? Start with:** `01-documentation/INSTALLATION_GUIDE.md`
