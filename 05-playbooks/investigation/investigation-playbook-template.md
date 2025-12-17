# Modèle de Playbook d'Investigation

## Informations sur le Playbook

**ID du Playbook** : PB-INV-[NUMÉRO]  
**Cas d'Usage** : [Cas d'Usage Associé]  
**Technique MITRE ATT&CK** : [ID et Nom de la Technique]  
**Niveau de Sévérité** : [Critique | Élevé | Moyen | Faible]  
**Temps Estimé** : [Minutes pour terminer]  
**Dernière Mise à Jour** : [Date]

---

## Objectif

Fournir des procédures d'investigation étape par étape pour que les analystes SOC puissent trier et investiguer efficacement les alertes de sécurité.

---

## Liste de Vérification Pré-Investigation

Avant de commencer l'investigation :

- [ ] L'alerte a été reconnue dans le SIEM
- [ ] Ticket d'incident créé (si applicable)
- [ ] Heure de début d'investigation documentée
- [ ] Outils requis accessibles (SIEM, EDR, outils réseau)
- [ ] Plan de préservation des preuves en place

---

## Étapes d'Investigation

### Phase 1 : Validation de l'Alerte (Temps : 3-5 minutes)

#### Étape 1.1 : Vérifier la Légitimité de l'Alerte
**Objectif** : Confirmer que l'alerte n'est pas un faux positif

**Actions** :
```
1. Consulter les détails de l'alerte dans le tableau de bord SIEM
2. Vérifier la fréquence des alertes pour cette règle
3. Confirmer que les sources de données fonctionnent correctement
4. Confirmer que les horodatages sont raisonnables
```

**Questions Clés** :
- ✅ L'alerte contient-elle tous les champs attendus ?
- ✅ L'horodatage est-il dans la plage attendue ?
- ✅ Les IP source/destination sont-elles valides ?

**Preuves à Collecter** :
- Capture d'écran de l'alerte originale
- Entrées de logs brutes déclenchant l'alerte
- Configuration de la règle d'alerte

**Point de Décision** :
```
SI l'alerte semble invalide ou mal configurée
  ALORS : Documenter les constatations, fermer comme faux positif
SINON : Passer à l'Étape 1.2
```

---

#### Step 1.2: Initial Context Gathering
**Objective**: Gather basic information about the alert

**Actions**:
```
1. Identify source IP/hostname
2. Identify destination IP/hostname (if applicable)
3. Identify user account involved
4. Note time range of suspicious activity
5. Check if similar alerts exist
```

**SIEM Queries**:

*Wazuh*:
```
# Search for related events
agent.name:"<hostname>" AND rule.id:"<rule_id>"

# Check user activity
user.name:"<username>" AND @timestamp:[now-1h TO now]
```

*Elastic*:
```kql
/* Related events from same host */
host.name:"<hostname>" AND event.category:security

/* User activity timeline */
user.name:"<username>" AND @timestamp >= now-1h
```

**Decision Point**:
```
IF sufficient context gathered
  THEN: Proceed to Phase 2
ELSE: Escalate for senior analyst review
```

---

### Phase 2: Detailed Investigation (Time: 10-15 minutes)

#### Step 2.1: Timeline Analysis
**Objective**: Build a timeline of events

**Actions**:
```
1. Identify first occurrence of suspicious activity
2. Identify last occurrence
3. Map out sequence of events
4. Look for patterns or anomalies
```

**Timeline Template**:
```
T-0:00 - Initial suspicious event detected
T+0:05 - [Event description]
T+0:10 - [Event description]
T+0:15 - Alert triggered
```

**Tools**:
- SIEM timeline view
- Excel/spreadsheet for manual correlation
- Visualization tools (if available)

---

#### Step 2.2: Scope Assessment
**Objective**: Determine if incident is isolated or widespread

**Actions**:
```
1. Check if other systems affected
2. Identify if multiple users involved
3. Assess geographic spread (if applicable)
4. Determine if attack is ongoing
```

**Queries**:
```
# Check for similar activity across all systems
<search_all_hosts> <suspicious_pattern>

# Check if pattern is widespread
stats count by host.name, user.name
```

**Scope Classification**:
- **Isolated**: Single host/user affected
- **Limited**: 2-5 hosts/users affected
- **Widespread**: >5 hosts/users affected

---

#### Step 2.3: Impact Analysis
**Objective**: Assess potential damage or risk

**Key Questions**:
- ✅ What data/systems were accessed?
- ✅ Was sensitive information exposed?
- ✅ Were administrative privileges used?
- ✅ Is there evidence of data exfiltration?
- ✅ Were systems modified?

**Impact Levels**:
- **Critical**: Confirmed breach, data loss, or system compromise
- **High**: Potential breach or unauthorized access
- **Medium**: Suspicious activity, no confirmed compromise
- **Low**: Anomalous but likely benign activity

**Decision Point**:
```
IF impact is Critical or High
  THEN: Escalate to Incident Response team immediately
ELSE: Continue investigation
```

---

### Phase 3: Root Cause Analysis (Time: 15-20 minutes)

#### Step 3.1: Identify Attack Vector
**Objective**: Determine how the attack occurred

**Common Attack Vectors**:
- Phishing email
- Brute-force authentication
- Exploited vulnerability
- Malicious insider
- Supply chain compromise
- Misconfiguration

**Investigation Actions**:
```
1. Review authentication logs
2. Check email gateway logs (if phishing suspected)
3. Review firewall/IDS logs
4. Examine process execution logs
5. Check for known vulnerabilities in affected systems
```

---

#### Step 3.2: Threat Actor Analysis
**Objective**: Identify indicators of compromise and attribution

**Actions**:
```
1. Extract IOCs (IPs, domains, file hashes)
2. Check threat intelligence feeds
3. Search for known malware signatures
4. Identify tactics, techniques, and procedures (TTPs)
```

**Threat Intelligence Sources**:
- VirusTotal (file hashes)
- AbuseIPDB (IP reputation)
- AlienVault OTX (IOC database)
- MISP (threat sharing platform)

**IOC Collection Template**:
```
IP Addresses:
- <IP>: [Reputation score, geolocation]

Domains:
- <domain>: [Reputation, registration date]

File Hashes (SHA256):
- <hash>: [Detection rate, file name]

User Accounts:
- <account>: [Compromised? Y/N, Last password change]
```

---

### Phase 4: Evidence Preservation (Time: 5-10 minutes)

#### Step 4.1: Document Findings
**Objective**: Preserve evidence for potential incident response

**Documentation Checklist**:
- [ ] Export relevant logs from SIEM
- [ ] Take screenshots of key findings
- [ ] Document all queries executed
- [ ] Note analyst actions taken
- [ ] Record timeline of events

**Evidence Export Commands**:

*Wazuh*:
```bash
# Export alerts to JSON
curl -k -X GET "https://<wazuh-manager>:55000/security/alerts" \
  -H "Authorization: Bearer <token>" > alert-export.json
```

*Elastic*:
```bash
# Export search results
# Use Kibana > Discover > Share > CSV Reports
```

---

#### Step 4.2: Preserve Volatile Data (If needed)
**Objective**: Capture memory and system state

**Critical Systems Only**:
```powershell
# Windows: Memory capture (requires admin)
# DumpIt.exe or WinPmem

# Windows: Process list
Get-Process | Export-Csv processes.csv

# Windows: Network connections
Get-NetTCPConnection | Export-Csv connections.csv
```

```bash
# Linux: Memory capture
sudo dd if=/dev/mem of=/tmp/memory.dump bs=1M

# Linux: Process list
ps aux > /tmp/processes.txt

# Linux: Network connections
netstat -anp > /tmp/connections.txt
```

---

### Phase 5: Containment Recommendations (Time: 5 minutes)

#### Step 5.1: Determine Containment Strategy

**Containment Options**:

| Action | Use When | Risk |
|--------|----------|------|
| Monitor Only | Low severity, ongoing investigation | Low |
| Isolate System | Confirmed compromise, preserve evidence | Medium |
| Disable Account | Compromised credentials | Low |
| Block IP | External threat, clear malicious intent | Low |
| Full Shutdown | Critical system, active breach | High |

**Containment Decision Tree**:
```
Is there active ongoing attack?
├─ YES → Immediate containment required
│   ├─ Compromised credentials? → Disable account
│   ├─ External attacker? → Block source IP
│   └─ System compromised? → Isolate from network
└─ NO → Continue monitoring
    └─ Document and track
```

---

#### Step 5.2: Execute Containment (If approved)

**Always get approval before containment actions on production systems**

**Containment Commands** (Reference Only):

```powershell
# Windows: Disable user account
Disable-ADAccount -Identity <username>

# Windows: Block IP at firewall
New-NetFirewallRule -DisplayName "Block Threat" -Direction Inbound -RemoteAddress <IP> -Action Block

# Windows: Isolate system (requires admin)
Disable-NetAdapter -Name "Ethernet"
```

```bash
# Linux: Lock user account
sudo passwd -l <username>

# Linux: Block IP
sudo iptables -A INPUT -s <IP> -j DROP

# Linux: Disable network interface
sudo ip link set eth0 down
```

---

### Phase 6: Escalation & Reporting (Time: 5-10 minutes)

#### Step 6.1: Escalation Criteria

**Escalate to Incident Response Team if**:
- ✅ Confirmed system compromise
- ✅ Data exfiltration detected
- ✅ Ransomware or destructive malware
- ✅ Widespread/multi-system incident
- ✅ Unable to contain with standard procedures
- ✅ Media/regulatory attention likely

**Escalation Contacts**:
```
Level 1 Escalation: Senior SOC Analyst
  - Email: senior-analyst@company.com
  - Phone: [Number]

Level 2 Escalation: SOC Manager
  - Email: soc-manager@company.com
  - Phone: [Number]

Level 3 Escalation: CISO/Incident Response
  - Email: ciso@company.com
  - Phone: [Number]
```

---

#### Step 6.2: Investigation Summary Report

**Template**:

```markdown
# Investigation Summary

**Incident ID**: INC-[YYYYMMDD]-[###]
**Alert Name**: [Original Alert Name]
**Analyst**: [Your Name]
**Investigation Start**: [Timestamp]
**Investigation End**: [Timestamp]
**Total Investigation Time**: [Minutes]

## Executive Summary
[2-3 sentences describing what happened]

## Findings
- **Severity**: [Critical/High/Medium/Low]
- **Scope**: [Isolated/Limited/Widespread]
- **Impact**: [Description]
- **Root Cause**: [How attack occurred]

## Evidence Collected
- [List of logs, screenshots, etc.]

## Indicators of Compromise (IOCs)
- IP Addresses: [List]
- Domains: [List]
- File Hashes: [List]
- User Accounts: [List]

## Actions Taken
1. [Action 1]
2. [Action 2]
3. [Action 3]

## Recommendations
1. [Recommendation 1]
2. [Recommendation 2]

## Status
- [ ] False Positive - Closed
- [ ] True Positive - Contained and Closed
- [ ] Escalated to Incident Response
- [ ] Ongoing Monitoring Required

**Next Steps**: [What should happen next]
```

---

## Decision Matrix

### Severity Classification

| Finding | Severity | Action |
|---------|----------|--------|
| False positive confirmed | Informational | Close, document FP |
| Suspicious but no evidence of compromise | Low | Monitor, document |
| Policy violation, no security impact | Medium | User education, log |
| Potential breach, unconfirmed | High | Contain, escalate |
| Confirmed breach or data loss | Critical | Immediate escalation |

---

## Key Performance Indicators (KPIs)

Track these metrics for continuous improvement:

- **Mean Time to Acknowledge (MTTA)**: Target < 5 minutes
- **Mean Time to Investigate (MTTI)**: Target < 30 minutes
- **Mean Time to Contain (MTTC)**: Target < 1 hour
- **False Positive Rate**: Target < 10%
- **Escalation Rate**: Track % escalated to IR

---

## Common Mistakes to Avoid

1. ❌ **Jumping to conclusions** - Follow the evidence
2. ❌ **Taking containment actions without approval** - Always get authorization
3. ❌ **Not documenting steps** - Every action should be logged
4. ❌ **Alerting user before investigation** - May tip off attacker
5. ❌ **Deleting evidence** - Preserve, don't destroy
6. ❌ **Working beyond your skill level** - Escalate when needed

---

## Tools Reference

### Essential SIEM Queries
```
[Include commonly used queries for this use case]
```

### Network Tools
- `nslookup <domain>` - DNS lookup
- `ping <IP>` - Connectivity test
- `tracert <IP>` - Route tracing (Windows)
- `traceroute <IP>` - Route tracing (Linux)
- `whois <IP/domain>` - Registration info

### Threat Intelligence
- VirusTotal: https://www.virustotal.com
- AbuseIPDB: https://www.abuseipdb.com
- URLScan: https://urlscan.io
- AlienVault OTX: https://otx.alienvault.com

---

## Training & Certification

**Skills Required**:
- Basic understanding of networking (OSI model, TCP/IP)
- Log analysis fundamentals
- SIEM query language proficiency
- Incident response basics

**Recommended Training**:
- CompTIA Security+
- SANS SEC450 (Blue Team Fundamentals)
- Vendor-specific SIEM training

---

## Appendix: Use Case-Specific Notes

[Add specific investigation steps unique to this use case]

---

**Playbook Version**: 1.0  
**Approved By**: SOC Manager  
**Review Date**: [Monthly]
