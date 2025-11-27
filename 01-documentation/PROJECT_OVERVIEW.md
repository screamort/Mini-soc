# Mini-SOC Project - Overview

## 1. Project Origin

This project was created to acquire operational SOC skills without relying on expensive software solutions. The goal is to structure comprehensive learning around the four pillars of SOC operations:

1. **Collection** - Log and event aggregation
2. **Correlation** - Event analysis and pattern matching
3. **Detection** - Threat identification through rules and analytics
4. **Response** - Incident handling and remediation

This project also serves as preparation for the **Security+ certification** with professional-grade documentation and hands-on experience.

---

## 2. Main Objective

Build a functional mini-SOC environment including:

### Core Components
- **SIEM Platform**: Open-source solution (Wazuh or Elastic Security)
- **Log Collection Agents**:
  - Winlogbeat (Windows event logs)
  - Sysmon (Windows system monitoring)
  - Auditd (Linux auditing)
  - Osquery (endpoint visibility)
  - pfSense (network/firewall logs)

### Detection Use-Cases (≥6 Required)
1. Brute-force attacks
2. Administrator privilege abuse
3. Web application attacks
4. DNS exfiltration
5. Persistence mechanisms
6. Lateral movement

### Operational Elements
- Clear response playbooks for each use-case
- SOC performance dashboard with key KPIs:
  - **MTTD** (Mean Time To Detect)
  - **MTTR** (Mean Time To Respond)

---

## 3. Qualitative Objectives (End of Year)

- [ ] Precise detection rules with low false-positive rates
- [ ] Simple, actionable investigation playbooks
- [ ] SOC performance dashboard (KPIs + runbooks)
- [ ] Clear documentation covering:
  - Installation procedures
  - Operational workflows
  - Agent onboarding guides
- [ ] Structured feedback report (REX) from red-blue team exercise

---

## 4. Quantitative Objectives (End of Year)

- [ ] **6 complete and documented use-cases**
- [ ] **1 multi-stage red-blue team exercise** simulating realistic attack scenarios

---

## 5. Stretch Goals (Exceeding Expectations)

- [ ] **8 published use-cases** with advanced TheHive/Cortex integration
- [ ] **Significant reduction in false positives** through rule tuning
- [ ] Automated response workflows
- [ ] Threat intelligence feed integration

---

## Project Structure

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

## Timeline & Milestones

### Phase 1: Foundation (Weeks 1-2)
- SIEM installation and configuration
- Agent deployment on test systems
- Basic log collection validation

### Phase 2: Detection Development (Weeks 3-6)
- Develop 6 core use-cases
- Create detection rules
- Initial testing and tuning

### Phase 3: Playbook Creation (Weeks 7-8)
- Investigation procedures
- Response workflows
- Escalation paths

### Phase 4: Dashboard & Metrics (Week 9)
- KPI tracking implementation
- Performance monitoring
- Alert statistics

### Phase 5: Red-Blue Exercise (Weeks 10-11)
- Scenario design
- Attack simulation
- Detection validation

### Phase 6: Documentation & REX (Week 12)
- Final documentation
- Lessons learned
- Future improvements

---

## Success Criteria

### Technical
- All 6 use-cases detect threats with >90% accuracy
- False positive rate <5% after tuning
- MTTD <15 minutes for critical alerts
- MTTR <60 minutes for high-severity incidents

### Educational
- Complete understanding of SOC operations
- Hands-on experience with industry-standard tools
- Professional documentation portfolio
- Readiness for Security+ certification

---

## Next Steps

1. Choose SIEM platform (Wazuh vs Elastic Security)
2. Set up lab environment
3. Deploy first agent (recommended: Sysmon on Windows)
4. Create first use-case (recommended: Brute-force detection)

---

**Document Version**: 1.0  
**Last Updated**: November 27, 2025  
**Author**: SOC Training Project
