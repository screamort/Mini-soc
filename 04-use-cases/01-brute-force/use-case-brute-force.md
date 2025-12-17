# CAS D'USAGE 01 : Détection d'Attaque par Force Brute

## Résumé Exécutif

**ID du Cas d'Usage** : UC-001  
**Nom du Cas d'Usage** : Détection d'Attaque d'Authentification par Force Brute  
**MITRE ATT&CK** : T1110 (Force Brute), T1110.001 (Devinette de Mot de Passe)  
**Sévérité** : Élevée  
**Score CVSS** : 7.5

### Description
Détecte plusieurs tentatives d'authentification échouées suivies d'une connexion potentiellement réussie, indiquant des attaques par force brute ou pulvérisation de mots de passe contre les comptes utilisateurs.

---

## Vue d'Ensemble de l'Attaque

### Qu'est-ce qu'une Attaque par Force Brute ?
Une attaque par force brute tente d'obtenir un accès non autorisé en essayant systématiquement de nombreux mots de passe ou phrases de passe dans l'espoir de finalement deviner correctement.

### Variantes d'Attaque
1. **Force Brute Traditionnelle** : Tentatives rapides contre un seul compte
2. **Pulvérisation de Mots de Passe** : Mots de passe communs contre plusieurs comptes
3. **Credential Stuffing** : Paires nom d'utilisateur/mot de passe connues issues de fuites
4. **Force Brute Inverse** : Un seul mot de passe contre plusieurs noms d'utilisateur

### Cibles Courantes
- SSH (serveurs Linux)
- RDP (bureaux/serveurs Windows)
- Pages de connexion d'applications web
- Passerelles VPN
- Serveurs email (IMAP, POP3, SMTP)

---

## Logique de Détection

### Critères de Détection

#### Windows (Event ID 4625)
```
SI nombre_échecs_connexion >= 5 
  DANS 2 minutes
  DEPUIS même_ip_source
ALORS ALERTE : Attaque Potentielle par Force Brute
```

#### Linux (SSH)
```
SI nombre "Failed password" >= 5
  DANS 2 minutes
  DEPUIS même_ip_source
ALORS ALERTE : Attaque SSH par Force Brute
```

### Détection de Suivi Critique
```
SI connexion_réussie (Event ID 4624 ou "Accepted password")
  DANS 5 minutes
  APRÈS alerte_force_brute
  DEPUIS même_ip_source
ALORS ALERTE : VIOLATION RÉUSSIE APRÈS FORCE BRUTE (Priorité Critique)
```

---

## Sources de Données

### Windows
| Source de Données | ID Événement | Description |
|-------------|----------|-------------|
| Journal Sécurité | 4625 | Tentative de connexion échouée |
| Journal Sécurité | 4624 | Connexion réussie |
| Journal Sécurité | 4648 | Connexion avec identifiants explicites |
| Journal Sécurité | 4771 | Échec pré-authentification Kerberos |

### Linux
| Source de Données | Emplacement Log | Pattern |
|-------------|--------------|---------|
| Auth Log | /var/log/auth.log | "Failed password" |
| Auth Log | /var/log/auth.log | "Accepted password" |
| SSH Log | /var/log/secure | "authentication failure" |
| Auditd | /var/log/audit/audit.log | User authentication events |

---

## Règles de Détection

### Wazuh Rule (Custom)

```xml
<!-- Brute-Force Detection -->
<rule id="100001" level="10" frequency="5" timeframe="120">
  <if_matched_sid>60122</if_matched_sid>
  <description>Multiple Windows failed login attempts (Possible brute-force)</description>
  <mitre>
    <id>T1110.001</id>
  </mitre>
  <group>authentication_failures,windows,brute_force</group>
</rule>

<rule id="100002" level="10" frequency="5" timeframe="120">
  <if_matched_sid>5551</if_matched_sid>
  <description>Multiple SSH failed login attempts (Possible brute-force)</description>
  <mitre>
    <id>T1110.001</id>
  </mitre>
  <group>authentication_failures,ssh,brute_force</group>
</rule>

<!-- Critical: Successful login after brute-force -->
<rule id="100003" level="15">
  <if_matched_sid>100001,100002</if_matched_sid>
  <if_sid>60103,5501</if_sid>
  <description>CRITICAL: Successful login after brute-force (Potential breach)</description>
  <mitre>
    <id>T1110.001</id>
  </mitre>
  <group>authentication_success,brute_force,breach</group>
</rule>
```

### Elastic Security Rule (KQL)

```kql
/* Brute-Force Detection - Windows */
event.code:4625 AND event.provider:"Microsoft-Windows-Security-Auditing"

/* Threshold: 5 events in 2 minutes, grouped by source.ip */

/* Brute-Force Detection - Linux SSH */
event.action:("ssh_login_failed" OR "failed") AND system.auth.ssh.event:*

/* Follow-up: Successful login */
event.code:4624 AND source.ip:<brute_force_ip>
```

### Splunk SPL Query

```spl
index=windows EventCode=4625
| stats count by src_ip, user
| where count > 5
| table src_ip, user, count

/* Follow-up successful login */
index=windows EventCode=4624 src_ip=<identified_ip>
| table _time, user, src_ip, EventCode
```

---

## Triage des Alertes

### Questions Initiales
1. ✅ **Est-ce une adresse IP connue/de confiance ?**
   - IP interne : Possible mauvaise configuration ou verrouillage utilisateur légitime
   - IP externe : Suspicion élevée - procéder à l'investigation

2. ✅ **Quel est le compte cible ?**
   - Compte administrateur : Priorité plus élevée
   - Compte de service : Vérifier si processus automatisé
   - Compte désactivé : Probablement malveillant

3. ✅ **L'attaque a-t-elle réussi ?**
   - Aucune connexion réussie : Surveiller et bloquer
   - Connexion réussie : **CRITIQUE - Réponse immédiate requise**

4. ✅ **Ce pattern est-il normal pour cet environnement ?**
   - Vérifier les bases de référence historiques
   - Analyse comportementale utilisateur

### Arbre de Décision

```
Alerte Force Brute Déclenchée
    │
    ├─ Succès ? NON ──> Priorité Basse
    │   │
    │   ├─ IP Interne ? OUI ──> Verrouillage utilisateur/réinit mot de passe
    │   └─ IP Externe ? OUI ──> Bloquer IP, surveiller
    │
    └─ Succès ? OUI ──> PRIORITÉ CRITIQUE
        │
        ├─ Actions Immédiates :
        │   1. Désactiver le compte compromis
        │   2. Bloquer l'IP source
        │   3. Forcer la réinitialisation du mot de passe
        │   4. Escalader vers l'équipe IR
        │
        └─ Investigation :
            1. Vérifier l'activité post-compromission
            2. Identifier le mouvement latéral
            3. Analyse forensique complète
```

---

## Playbook d'Investigation

### Step 1: Validate the Alert (3 minutes)

#### Windows
```powershell
# Check failed login attempts
Get-WinEvent -FilterHashtable @{
    LogName='Security'
    ID=4625
} | Where-Object {$_.TimeCreated -gt (Get-Date).AddMinutes(-10)} | 
Select TimeCreated, @{N='User';E={$_.Properties[5].Value}}, 
@{N='SourceIP';E={$_.Properties[19].Value}} | 
Group-Object SourceIP | Sort Count -Descending

# Check successful logins from suspicious IP
Get-WinEvent -FilterHashtable @{
    LogName='Security'
    ID=4624
} | Where-Object {$_.Properties[18].Value -eq "<suspicious_ip>"} |
Select TimeCreated, @{N='User';E={$_.Properties[5].Value}}
```

#### Linux
```bash
# Check failed SSH attempts
sudo grep "Failed password" /var/log/auth.log | tail -50

# Count by IP
sudo grep "Failed password" /var/log/auth.log | 
awk '{print $(NF-3)}' | sort | uniq -c | sort -rn

# Check successful logins from suspicious IP
sudo grep "Accepted password" /var/log/auth.log | grep "<suspicious_ip>"
```

### Step 2: Gather Context (5 minutes)

```bash
# Check IP reputation
curl -s "https://api.abuseipdb.com/api/v2/check?ipAddress=<IP>&maxAgeInDays=90" \
  -H "Key: <YOUR_API_KEY>" | jq

# WHOIS lookup
whois <suspicious_ip>

# Check geolocation
curl -s "http://ip-api.com/json/<suspicious_ip>" | jq
```

### Step 3: Assess Impact (10 minutes)

#### If Attack Failed
```
1. Document the attempt
2. Block source IP at firewall
3. Check if account locked
4. Notify account owner
5. Monitor for repeat attempts
```

#### If Attack Succeeded ⚠️ CRITICAL
```
1. Immediately disable compromised account
2. Block source IP at perimeter firewall
3. Review account activity since compromise:
   - File access
   - Privilege changes
   - Lateral movement attempts
   - Data exfiltration
4. Check for persistence mechanisms:
   - Scheduled tasks
   - Registry Run keys
   - New user accounts
5. Escalate to Incident Response team
6. Preserve evidence
```

### Step 4: Containment Actions

```powershell
# Windows: Disable compromised account
Disable-ADAccount -Identity <username>

# Windows: Block IP at firewall (Windows Firewall)
New-NetFirewallRule -DisplayName "Block Brute-Force IP" `
  -Direction Inbound -Action Block -RemoteAddress <IP>

# Windows: Force account password reset
Set-ADAccountPassword -Identity <username> -Reset
```

```bash
# Linux: Lock user account
sudo passwd -l <username>

# Linux: Block IP with iptables
sudo iptables -A INPUT -s <IP> -j DROP

# Linux: Block IP with UFW
sudo ufw deny from <IP>

# Linux: Kill active sessions
sudo pkill -u <username>
```

---

## False Positive Scenarios

### Common False Positives

1. **Legitimate User Forgot Password**
   - Indicators: 
     - Internal IP
     - Normal business hours
     - User contact confirms
   - Action: Password reset assistance

2. **Automated Service Account**
   - Indicators:
     - Service account name
     - Regular pattern
     - Internal source
   - Action: Fix service configuration

3. **VPN Reconnection Issues**
   - Indicators:
     - Known VPN gateway
     - Multiple users
     - Time correlation
   - Action: IT infrastructure check

4. **Password Expiration**
   - Indicators:
     - Multiple users
     - After weekend/holiday
     - Password policy timing
   - Action: User education

### Tuning Recommendations

```xml
<!-- Exclude service accounts -->
<rule id="100001" level="10" frequency="5" timeframe="120">
  <if_matched_sid>60122</if_matched_sid>
  <field name="user">^(?!svc-|service-)</field>
  <description>Brute-force (excluding service accounts)</description>
</rule>

<!-- Whitelist known IPs -->
<rule id="100001" level="10" frequency="5" timeframe="120">
  <if_matched_sid>60122</if_matched_sid>
  <srcip>!10.0.0.0/8,!192.168.0.0/16</srcip>
  <description>Brute-force from external IPs only</description>
</rule>
```

---

## Testing & Validation

### Simulate Brute-Force Attack

#### Windows (Test from Windows machine)
```powershell
# WARNING: Only run in test environment
# Trigger failed login attempts
1..10 | ForEach-Object {
    runas /user:fakeuser$_ cmd.exe 2>&1 | Out-Null
    Start-Sleep -Seconds 5
}

# Check if alert triggered in SIEM
```

#### Linux (Test SSH brute-force)
```bash
# Using hydra (install: sudo apt install hydra)
# WARNING: Only use in authorized test environment
hydra -l testuser -P /usr/share/wordlists/rockyou.txt \
  ssh://<target-ip> -t 4 -V

# Alternative: Manual test
for i in {1..10}; do
  ssh fakeuser$i@localhost
  sleep 2
done
```

### Validate Detection

```bash
# Wazuh: Check for alert
curl -k -X GET "https://<wazuh-manager>:55000/security/alerts?pretty" \
  -H "Authorization: Bearer <token>"

# Elastic: Query for alert
# Kibana > Security > Alerts
# Filter: rule.name:"Brute Force"
```

---

## Metrics & KPIs

### Detection Metrics
- **MTTD** (Mean Time To Detect): Target < 5 minutes
- **False Positive Rate**: Target < 5%
- **Detection Coverage**: >95% of brute-force attempts

### Response Metrics
- **MTTR** (Mean Time To Respond): 
  - Failed attempts: <15 minutes
  - Successful breach: <5 minutes (CRITICAL)
- **Containment Time**: <10 minutes from detection

### Effectiveness Tracking
```
Total Brute-Force Attempts Detected: ____
True Positives: ____
False Positives: ____
Successful Breaches Prevented: ____
Successful Breaches (IR escalated): ____

False Positive Rate = (FP / Total Alerts) * 100
Detection Rate = (TP / Total Real Attacks) * 100
```

---

## Preventive Measures

### Technical Controls
1. ✅ **Account Lockout Policy**
   - Windows: GPO - Account Lockout Threshold = 5 attempts
   - Linux: PAM faillock module

2. ✅ **Strong Password Policy**
   - Minimum 12 characters
   - Complexity requirements
   - Password history

3. ✅ **Multi-Factor Authentication (MFA)**
   - All administrative accounts
   - Remote access (VPN, RDP, SSH)
   - External-facing services

4. ✅ **IP Whitelisting**
   - Restrict administrative access to known IPs
   - Use VPN for remote administration

5. ✅ **Rate Limiting**
   - Web applications: Implement login throttling
   - SSH: Use fail2ban
   - RDP: Limit concurrent connections

### Monitoring Enhancements
- Deploy honeypot accounts
- Enable detailed authentication logging
- Geo-IP blocking for non-business countries

---

## References

### MITRE ATT&CK
- **T1110**: Brute Force
- **T1110.001**: Password Guessing
- **T1110.002**: Password Cracking
- **T1110.003**: Password Spraying
- **T1110.004**: Credential Stuffing

### Security+ Objectives
- 1.4 Explain the importance of using appropriate cryptographic solutions
- 2.4 Summarize authentication and authorization design concepts
- 4.3 Explain various activities associated with vulnerability management

### Additional Resources
- NIST SP 800-63B: Digital Identity Guidelines
- CIS Controls v8: Control 6.3 (Multi-factor Authentication)
- OWASP Authentication Cheat Sheet

---

**Use Case Version**: 1.0  
**Last Updated**: November 27, 2025  
**Next Review**: December 27, 2025  
**Owner**: SOC Team
