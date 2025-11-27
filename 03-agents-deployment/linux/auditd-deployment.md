# Linux Agent Deployment - Auditd Configuration

## Overview
Auditd (Linux Audit Daemon) is the userspace component to the Linux Auditing System. It's responsible for writing audit records to disk and is essential for security monitoring and compliance.

## Prerequisites
- Linux distribution (Ubuntu, Debian, RHEL, CentOS)
- Root or sudo privileges
- Kernel support for auditing (enabled by default in most distributions)

---

## Installation

### Ubuntu/Debian
```bash
sudo apt update
sudo apt install auditd audispd-plugins -y
```

### RHEL/CentOS/Rocky Linux
```bash
sudo yum install audit audit-libs -y
# OR
sudo dnf install audit audit-libs -y
```

### Enable and Start Service
```bash
sudo systemctl enable auditd
sudo systemctl start auditd
sudo systemctl status auditd
```

---

## Configuration Overview

### Key Configuration Files

| File | Purpose |
|------|---------|
| `/etc/audit/auditd.conf` | Main daemon configuration |
| `/etc/audit/rules.d/*.rules` | Audit rules (persistent) |
| `/etc/audit/audit.rules` | Compiled rules (generated) |
| `/var/log/audit/audit.log` | Audit log file |

---

## Mini-SOC Audit Rules

Create file: `/etc/audit/rules.d/mini-soc.rules`

```bash
# Mini-SOC Audit Rules
# High-value security monitoring rules for SOC operations

# ============================================
# USE CASE 1: Authentication & Access Control
# ============================================

# Monitor authentication attempts
-w /var/log/auth.log -p wa -k auth_log
-w /var/log/secure -p wa -k auth_log

# Monitor password file changes
-w /etc/passwd -p wa -k passwd_changes
-w /etc/shadow -p rwa -k shadow_changes
-w /etc/group -p wa -k group_changes
-w /etc/gshadow -p wa -k gshadow_changes

# Monitor sudo configuration
-w /etc/sudoers -p wa -k sudoers_changes
-w /etc/sudoers.d/ -p wa -k sudoers_changes

# Monitor SSH configuration
-w /etc/ssh/sshd_config -p wa -k sshd_config_changes

# ============================================
# USE CASE 2: Privilege Escalation
# ============================================

# Monitor sudo usage
-a always,exit -F arch=b64 -S execve -F exe=/usr/bin/sudo -k sudo_execution
-a always,exit -F arch=b32 -S execve -F exe=/usr/bin/sudo -k sudo_execution

# Monitor su usage
-a always,exit -F arch=b64 -S execve -F exe=/bin/su -k su_execution
-a always,exit -F arch=b32 -S execve -F exe=/bin/su -k su_execution

# Monitor privilege escalation via setuid
-a always,exit -F arch=b64 -S setuid -S setreuid -S setresuid -k privilege_escalation
-a always,exit -F arch=b32 -S setuid -S setreuid -S setresuid -k privilege_escalation

# ============================================
# USE CASE 3: File & Directory Monitoring
# ============================================

# Monitor system binary directories
-w /bin/ -p wa -k system_binaries
-w /sbin/ -p wa -k system_binaries
-w /usr/bin/ -p wa -k system_binaries
-w /usr/sbin/ -p wa -k system_binaries

# Monitor critical system files
-w /etc/hosts -p wa -k hosts_file
-w /etc/hostname -p wa -k hostname_changes
-w /etc/resolv.conf -p wa -k dns_config
-w /etc/hosts.allow -p wa -k host_access
-w /etc/hosts.deny -p wa -k host_access

# Monitor temp directories (malware staging)
-w /tmp -p wa -k tmp_operations
-w /var/tmp -p wa -k tmp_operations

# Monitor home directories of privileged users
-w /root -p wa -k root_operations
-w /home/admin -p wa -k admin_operations

# ============================================
# USE CASE 4: Network Activity
# ============================================

# Monitor network connections
-a always,exit -F arch=b64 -S socket -S connect -k network_connections
-a always,exit -F arch=b32 -S socket -S connect -k network_connections

# Monitor changes to network configuration
-w /etc/network/ -p wa -k network_config
-w /etc/sysconfig/network-scripts/ -p wa -k network_config
-w /etc/netplan/ -p wa -k network_config

# Monitor firewall changes
-w /etc/iptables/ -p wa -k firewall_config
-w /etc/ufw/ -p wa -k firewall_config
-a always,exit -F arch=b64 -S setsockopt -k firewall_changes

# ============================================
# USE CASE 5: Persistence Mechanisms
# ============================================

# Monitor cron jobs
-w /etc/cron.allow -p wa -k cron_changes
-w /etc/cron.deny -p wa -k cron_changes
-w /etc/cron.d/ -p wa -k cron_changes
-w /etc/cron.daily/ -p wa -k cron_changes
-w /etc/cron.hourly/ -p wa -k cron_changes
-w /etc/cron.monthly/ -p wa -k cron_changes
-w /etc/cron.weekly/ -p wa -k cron_changes
-w /etc/crontab -p wa -k cron_changes
-w /var/spool/cron/ -p wa -k cron_changes

# Monitor systemd services
-w /etc/systemd/system/ -p wa -k systemd_services
-w /usr/lib/systemd/system/ -p wa -k systemd_services

# Monitor init scripts
-w /etc/init.d/ -p wa -k init_scripts
-w /etc/rc.d/ -p wa -k init_scripts

# Monitor user profile scripts
-w /etc/profile -p wa -k profile_changes
-w /etc/bash.bashrc -p wa -k shell_config
-w /root/.bashrc -p wa -k shell_config
-w /root/.bash_profile -p wa -k shell_config

# ============================================
# USE CASE 6: Lateral Movement & Remote Access
# ============================================

# Monitor SSH key access
-w /root/.ssh -p wa -k ssh_key_access
-w /home/*/.ssh -p wa -k ssh_key_access

# Monitor remote shell commands
-a always,exit -F arch=b64 -S execve -F exe=/usr/bin/ssh -k ssh_usage
-a always,exit -F arch=b64 -S execve -F exe=/usr/bin/scp -k scp_usage
-a always,exit -F arch=b64 -S execve -F exe=/usr/bin/sftp -k sftp_usage

# ============================================
# ADDITIONAL HIGH-VALUE MONITORING
# ============================================

# Monitor kernel module loading (rootkits)
-a always,exit -F arch=b64 -S init_module -S delete_module -k kernel_modules
-a always,exit -F arch=b32 -S init_module -S delete_module -k kernel_modules
-w /sbin/insmod -p x -k kernel_modules
-w /sbin/rmmod -p x -k kernel_modules
-w /sbin/modprobe -p x -k kernel_modules

# Monitor process execution in unusual locations
-a always,exit -F arch=b64 -S execve -F path=/dev/shm -k suspicious_execution
-a always,exit -F arch=b64 -S execve -F path=/tmp -k suspicious_execution

# Monitor file deletion (anti-forensics)
-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -k file_deletion
-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -k file_deletion

# Monitor time changes (log tampering)
-a always,exit -F arch=b64 -S adjtimex -S settimeofday -S clock_settime -k time_changes
-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S clock_settime -k time_changes

# Monitor audit system
-w /etc/audit/ -p wa -k audit_config
-w /sbin/auditctl -p x -k audit_tools
-w /sbin/auditd -p x -k audit_tools

# Make audit configuration immutable (optional - prevents tampering)
# -e 2
```

---

## Load Audit Rules

```bash
# Load rules from rules.d directory
sudo augenrules --load

# Verify loaded rules
sudo auditctl -l

# Check rule count
sudo auditctl -l | wc -l
```

---

## Test Audit Rules

### Test 1: Password File Access
```bash
# Trigger event
sudo cat /etc/shadow

# Search for events
sudo ausearch -k shadow_changes

# Expected output: Shows record of shadow file access
```

### Test 2: Sudo Execution
```bash
# Trigger event
sudo ls /root

# Search for events
sudo ausearch -k sudo_execution -ts recent

# View formatted output
sudo ausearch -k sudo_execution -i
```

### Test 3: SSH Key Access
```bash
# Trigger event
ls ~/.ssh/

# Search for events
sudo ausearch -k ssh_key_access -ts recent
```

---

## Query Audit Logs

### Using ausearch

```bash
# Search by key
sudo ausearch -k passwd_changes

# Search by user
sudo ausearch -ua username

# Search by time range
sudo ausearch -ts today
sudo ausearch -ts 10:00:00 -te 11:00:00

# Search by event ID
sudo ausearch -a 1234

# Format output for readability
sudo ausearch -k sudo_execution -i
```

### Using aureport

```bash
# Generate summary report
sudo aureport

# Authentication report
sudo aureport -au

# File access report
sudo aureport -f

# User activity report
sudo aureport -u

# Summary of events by key
sudo aureport -k
```

---

## Integration with SIEM

### Option 1: Forward to Wazuh

Edit `/var/ossec/etc/ossec.conf`:

```xml
<localfile>
  <log_format>audit</log_format>
  <location>/var/log/audit/audit.log</location>
</localfile>
```

Restart Wazuh agent:
```bash
sudo systemctl restart wazuh-agent
```

### Option 2: Forward to Elastic (via Filebeat)

Edit `/etc/filebeat/filebeat.yml`:

```yaml
filebeat.inputs:
  - type: log
    enabled: true
    paths:
      - /var/log/audit/audit.log
    fields:
      log_type: auditd
    fields_under_root: true

# OR use auditbeat module
filebeat.modules:
  - module: auditd
    log:
      enabled: true
```

Restart Filebeat:
```bash
sudo systemctl restart filebeat
```

### Option 3: Use Auditbeat (Elastic)

```bash
# Install Auditbeat
curl -L -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-8.11.0-amd64.deb
sudo dpkg -i auditbeat-8.11.0-amd64.deb

# Configure
sudo nano /etc/auditbeat/auditbeat.yml
```

Configuration:
```yaml
auditbeat.modules:
  - module: auditd
    audit_rules: |
      # Include your rules here or reference file
      -w /etc/passwd -p wa -k passwd_changes
      -w /etc/shadow -p rwa -k shadow_changes

  - module: file_integrity
    paths:
      - /bin
      - /usr/bin
      - /sbin
      - /usr/sbin
      - /etc

output.elasticsearch:
  hosts: ["<elasticsearch-ip>:9200"]
  username: "elastic"
  password: "<password>"
```

```bash
# Start Auditbeat
sudo systemctl enable auditbeat
sudo systemctl start auditbeat
```

---

## Performance Tuning

### Check Audit Queue Status
```bash
sudo auditctl -s
```

Look for:
- `backlog`: Should be well below `backlog_limit`
- `lost`: Should be 0

### Increase Buffer if Needed
Edit `/etc/audit/auditd.conf`:
```
# Increase buffer size
num_logs = 10
max_log_file = 100
```

Restart:
```bash
sudo systemctl restart auditd
```

---

## Troubleshooting

### Auditd Not Starting
```bash
# Check status
sudo systemctl status auditd

# Check logs
sudo journalctl -u auditd -n 50

# Verify kernel support
zcat /proc/config.gz | grep AUDIT
```

### Rules Not Loading
```bash
# Check syntax
sudo auditctl -l

# Reload rules
sudo augenrules --load

# Check for errors
sudo dmesg | grep audit
```

### High Log Volume
```bash
# Check log size
sudo du -sh /var/log/audit/

# Add exclusions to reduce noise
# Edit /etc/audit/rules.d/mini-soc.rules
# Add exclude rules for noisy processes
```

---

## Best Practices

1. **Test rules incrementally** - Add rules gradually and monitor performance
2. **Use meaningful keys** - Name keys descriptively (e.g., `passwd_changes` not `rule1`)
3. **Monitor log rotation** - Ensure logs don't fill disk
4. **Regular review** - Analyze aureport output weekly
5. **Immutable mode carefully** - Only use `-e 2` in production after testing
6. **Document exclusions** - Note why specific events are excluded

---

## Log Rotation

Edit `/etc/audit/auditd.conf`:
```
max_log_file = 100
num_logs = 10
max_log_file_action = ROTATE
```

This keeps last 10 files of 100MB each = 1GB total

---

**Configuration Version**: 1.0  
**Last Updated**: November 27, 2025  
**Auditd Version**: 3.0+
