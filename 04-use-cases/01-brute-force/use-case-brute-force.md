# USE CASE 01: Brute-Force Attack Detection

## Executive Summary

**Use Case ID**: UC-001  
**Use Case Name**: Brute-Force Authentication Attack Detection  
**MITRE ATT&CK**: T1110 (Brute Force), T1110.001 (Password Guessing)  
**Severity**: High  
**CVSS Score**: 7.5

### Description
Detects multiple failed authentication attempts followed by potential successful login, indicating brute-force or password spraying attacks against user accounts.

---

## Attack Overview

### What is Brute-Force?
A brute-force attack attempts to gain unauthorized access by systematically trying many passwords or passphrases with the hope of eventually guessing correctly.

### Attack Variants
1. **Traditional Brute-Force**: Rapid attempts against single account
2. **Password Spraying**: Common passwords against many accounts
3. **Credential Stuffing**: Known username/password pairs from breaches
4. **Reverse Brute-Force**: Single password against many usernames

### Common Targets
- SSH (Linux servers)
- RDP (Windows desktops/servers)
- Web application login pages
- VPN gateways
- Email servers (IMAP, POP3, SMTP)

---

## Detection Logic

### Detection Criteria

#### Windows (Event ID 4625)
```
IF failed_login_count >= 5 
  WITHIN 2 minutes
  FROM same_source_ip
THEN ALERT: Potential Brute-Force Attack
```

#### Linux (SSH)
```
IF "Failed password" count >= 5
  WITHIN 2 minutes
  FROM same_source_ip
THEN ALERT: SSH Brute-Force Attack
```

### Critical Follow-Up Detection
```
IF successful_login (Event ID 4624 or "Accepted password")
  WITHIN 5 minutes
  AFTER brute_force_alert
  FROM same_source_ip
THEN ALERT: SUCCESSFUL BREACH AFTER BRUTE-FORCE (Critical Priority)
```

---

## Data Sources

### Windows
| Data Source | Event ID | Description |
|-------------|----------|-------------|
| Security Event Log | 4625 | Failed logon attempt |
| Security Event Log | 4624 | Successful logon |
| Security Event Log | 4648 | Logon using explicit credentials |
| Security Event Log | 4771 | Kerberos pre-authentication failed |

### Linux
| Data Source | Log Location | Pattern |
|-------------|--------------|---------|
| Auth Log | /var/log/auth.log | "Failed password" |
| Auth Log | /var/log/auth.log | "Accepted password" |
| SSH Log | /var/log/secure | "authentication failure" |
| Auditd | /var/log/audit/audit.log | User authentication events |

---

## Detection Rules

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

## Alert Triage

### Initial Questions
1. ✅ **Is this a known/trusted IP address?**
   - Internal IP: Possible misconfiguration or legitimate user lockout
   - External IP: Higher suspicion - proceed with investigation

2. ✅ **What is the target account?**
   - Administrative account: Higher priority
   - Service account: Check if automated process
   - Disabled account: Likely malicious

3. ✅ **Was the attack successful?**
   - No successful login: Monitor and block
   - Successful login: **CRITICAL - Immediate response required**

4. ✅ **Is this pattern normal for this environment?**
   - Check historical baselines
   - User behavior analytics

### Decision Tree

```
Brute-Force Alert Triggered
    │
    ├─ Success? NO ──> Low Priority
    │   │
    │   ├─ Internal IP? YES ──> User lockout/password reset
    │   └─ External IP? YES ──> Block IP, monitor
    │
    └─ Success? YES ──> CRITICAL PRIORITY
        │
        ├─ Immediate Actions:
        │   1. Disable compromised account
        │   2. Block source IP
        │   3. Force password reset
        │   4. Escalate to IR team
        │
        └─ Investigation:
            1. Check post-compromise activity
            2. Identify lateral movement
            3. Full forensic analysis
```

---

## Investigation Playbook

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
