# Architecture Mini-SOC

## Vue d'Ensemble de l'Architecture Système

```
┌─────────────────────────────────────────────────────────────────┐
│                      Analyste SOC                            │
│                (Dashboard & Investigation)                   │
└────────────────────────┬─────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Plateforme SIEM                           │
│            (Wazuh Manager / Elastic Stack)                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │  Moteur de   │  │   Règles de │  │   Système   │      │
│  │  Corrélation│  │   Détection │  │   d'Alerte   │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└────────────────────────┬─────────────────────────────────────────┘
                         │
         ┌───────────────┼───────────────┬──────────────┐
         │               │               │              │
         ▼               ▼               ▼              ▼
┌─────────────┐  ┌─────────────┐  ┌──────────┐  ┌──────────────┐
│   Windows   │  │    Linux    │  │  Web App │  │   Network    │
│  Endpoints  │  │   Servers   │  │  Servers │  │   Devices    │
│             │  │             │  │          │  │              │
│ • Sysmon    │  │ • Auditd    │  │ • Apache │  │ • pfSense    │
│ • Winlogbeat│  │ • Osquery   │  │ • Nginx  │  │ • Firewall   │
│ • Wazuh Agt │  │ • Wazuh Agt │  │ • IIS    │  │   Logs       │
└─────────────┘  └─────────────┘  └──────────┘  └──────────────┘
```

---

## Détails des Composants

### 1. Plateforme SIEM (Analyse Centrale)

#### Option A: Wazuh (Recommandé pour Débutants)
**Avantages:**
- Plateforme de sécurité tout-en-un
- Gestion d'agents intégrée
- Règles pré-configurées pour attaques courantes
- Gratuit et open-source
- Bonne documentation

**Composants:**
- Wazuh Manager (moteur de règles, API)
- Wazuh Indexer (Opensearch pour stockage logs)
- Wazuh Dashboard (UI basée sur Kibana)

**Configuration Système Requise:**
- CPU: 4 cœurs minimum
- RAM: 8GB minimum (16GB recommandé)
- Stockage: 100GB+ pour rétention des logs
- OS: Ubuntu 20.04/22.04 ou RHEL 8/9

#### Option B: Elastic Security
**Avantages:**
- Plateforme standard de l'industrie
- Langage de requête puissant (KQL)
- Capacités ML avancées
- Personnalisation flexible

**Composants:**
- Elasticsearch (stockage de données)
- Logstash (traitement des logs)
- Kibana (visualisation)
- Elastic Agent ou Beats

**Configuration Système Requise:**
- CPU: 4 cœurs minimum
- RAM: 16GB minimum
- Stockage: 200GB+ pour rétention des logs
- OS: Ubuntu 20.04/22.04 ou RHEL 8/9

---

### 2. Agents de Collecte

#### Windows Endpoints

**Sysmon (System Monitor)**
- **Purpose**: Advanced Windows system activity monitoring
- **Key Features**:
  - Process creation tracking
  - Network connections
  - File creation/modification
  - Registry changes
  - Driver/DLL loading
- **Configuration**: SwiftOnSecurity config recommended
- **Log Location**: `Applications and Services Logs\Microsoft\Windows\Sysmon`

**Winlogbeat**
- **Purpose**: Ship Windows Event Logs to SIEM
- **Key Logs Collected**:
  - Security (Event ID 4624, 4625, 4672, etc.)
  - System
  - Application
  - Sysmon
- **Output**: Elasticsearch or Logstash

**Wazuh Agent (Windows)**
- **Purpose**: Unified security monitoring
- **Features**:
  - Log collection
  - File integrity monitoring (FIM)
  - Rootkit detection
  - Security configuration assessment

#### Linux Servers

**Auditd**
- **Purpose**: Linux audit framework
- **Key Monitoring**:
  - System calls
  - File access
  - User authentication
  - Privilege escalation
- **Rules**: Custom rules for suspicious activities

**Osquery**
- **Purpose**: SQL-powered endpoint visibility
- **Use Cases**:
  - Endpoint interrogation
  - Live forensics
  - Compliance checking
- **Integration**: Fleet manager for distributed queries

**Wazuh Agent (Linux)**
- **Purpose**: Comprehensive security monitoring
- **Key Features**:
  - Log analysis
  - Rootkit detection
  - File integrity monitoring
  - Vulnerability detection

#### Network Devices

**pfSense**
- **Purpose**: Firewall and network traffic logs
- **Key Logs**:
  - Firewall blocks/allows
  - VPN connections
  - DNS queries
  - IDS/IPS alerts (if Snort/Suricata enabled)
- **Export Method**: Syslog to SIEM

---

### 3. Couche de Détection

#### Catégories de Règles

1. **Détection Basée sur Signatures**
   - Patterns d'attaques connus
   - Correspondance IOC (Indicateurs de Compromission)
   - Mapping MITRE ATT&CK

2. **Détection Basée sur Anomalies**
   - Analyse comportementale de base
   - Valeurs aberrantes statistiques
   - Machine learning (si utilisation Elastic ML)

3. **Règles de Corrélation**
   - Correspondance de patterns multi-événements
   - Séquences temporelles
   - Corrélation inter-systèmes

#### Detection Use-Cases

| Use-Case | Primary Data Source | Detection Method |
|----------|-------------------|------------------|
| Brute-force | Windows Security, SSH logs | Failed login threshold |
| Admin Abuse | Windows Security, Auditd | Privilege elevation tracking |
| Web Attacks | Apache/Nginx logs | SQL injection, XSS patterns |
| DNS Exfiltration | DNS logs, pfSense | Unusual query patterns |
| Persistence | Sysmon, Registry logs | Startup modification |
| Lateral Movement | Network logs, SMB | Unusual authentication patterns |

---

### 4. Response & Orchestration

#### Manual Response Workflow
1. **Alert Triage**: Analyst reviews alert in dashboard
2. **Investigation**: Follow playbook procedures
3. **Containment**: Isolate affected systems (manual)
4. **Remediation**: Remove threat, restore systems
5. **Documentation**: Log incident in REX

#### Optional Advanced Response (Stretch Goal)
- **TheHive**: Incident response platform
- **Cortex**: Automated analysis and response
- **SOAR Integration**: Automated containment actions

---

## Network Topology

```
┌──────────────────────────────────────────────────────────┐
│                    Management Network                     │
│                      10.0.1.0/24                         │
│                                                           │
│  ┌─────────────────┐         ┌──────────────────┐       │
│  │  SIEM Server    │         │  Analyst Station │       │
│  │  10.0.1.10      │◄────────┤  10.0.1.100      │       │
│  └────────┬────────┘         └──────────────────┘       │
└───────────┼───────────────────────────────────────────────┘
            │
            │ Log Collection (Port 514/1514/5140)
            │
┌───────────┼───────────────────────────────────────────────┐
│           │       Production Network                      │
│           │         10.0.2.0/24                           │
│           │                                               │
│  ┌────────▼────────┐  ┌──────────────┐  ┌──────────────┐│
│  │  Windows DC     │  │  Linux Web   │  │  pfSense     ││
│  │  10.0.2.10      │  │  10.0.2.20   │  │  10.0.2.1    ││
│  │  (Agents)       │  │  (Agents)    │  │  (Syslog)    ││
│  └─────────────────┘  └──────────────┘  └──────────────┘│
└───────────────────────────────────────────────────────────┘
```

---

## Data Flow

### Log Collection Flow

```
1. Event Occurs on Endpoint
   └─> Agent Collects Event (Sysmon, Auditd, etc.)
       └─> Agent Forwards to SIEM (Port 1514/5140)
           └─> SIEM Receives and Parses Log
               └─> Rule Engine Evaluates Event
                   ├─> No Match: Store for analysis
                   └─> Match: Generate Alert
                       └─> Alert Dashboard
                           └─> Analyst Investigation
```

### Detection Logic Flow

```
Incoming Event
    │
    ▼
[Normalization] - Convert to common format
    │
    ▼
[Enrichment] - Add context (GeoIP, threat intel)
    │
    ▼
[Rule Evaluation] - Check against detection rules
    │
    ├─> No Match ──> [Archive]
    │
    └─> Match ──> [Alert Generation]
                      │
                      ├─> Low Severity ──> Log only
                      ├─> Medium Severity ──> Email
                      └─> High/Critical ──> Dashboard + Email + Ticket
```

---

## Security Considerations

### SIEM Hardening
- [ ] Dedicated management interface
- [ ] TLS encryption for agent communication
- [ ] Strong authentication (MFA if possible)
- [ ] Regular backup of rules and dashboards
- [ ] Access control lists (ACLs)

### Log Retention
- **Hot Storage**: 30 days (fast queries)
- **Warm Storage**: 90 days (compressed)
- **Cold Storage**: 1 year (archived)

### Monitoring the Monitor
- SIEM self-monitoring
- Agent health checks
- Log ingestion rate monitoring
- Disk space alerts

---

## Scalability Path

### Phase 1: Single Server (Current)
- All-in-one SIEM installation
- 5-10 monitored endpoints
- Basic use-cases

### Phase 2: Distributed (Future)
- Separate indexer nodes
- Multiple SIEM workers
- 50+ monitored endpoints
- Advanced correlation

### Phase 3: Enterprise-Ready (Stretch)
- High availability cluster
- Load balancing
- Thousands of endpoints
- SOAR integration

---

**Document Version**: 1.0  
**Last Updated**: November 27, 2025
