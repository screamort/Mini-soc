# Installation Guide - Mini-SOC

## Prerequisites

### Lab Environment Options

#### Option 1: Virtual Machines (Recommended)
- **Hypervisor**: VMware Workstation, VirtualBox, or Hyper-V
- **Minimum Resources**:
  - SIEM Server: 4 vCPU, 8GB RAM, 100GB disk
  - Windows Test Machine: 2 vCPU, 4GB RAM, 60GB disk
  - Linux Test Machine: 2 vCPU, 2GB RAM, 40GB disk

#### Option 2: Cloud Environment
- **Providers**: AWS, Azure, Google Cloud
- **Instance Types**:
  - SIEM: t3.xlarge (4 vCPU, 16GB RAM)
  - Endpoints: t3.medium (2 vCPU, 4GB RAM)
- **Note**: Cloud costs can add up - monitor usage

#### Option 3: Physical Lab
- Repurposed old hardware
- Raspberry Pi for lightweight components
- Mixed physical/virtual environment

---

## Part 1: SIEM Installation

### Option A: Wazuh Installation (Recommended for Beginners)

#### Step 1: Prepare Ubuntu Server

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install prerequisites
sudo apt install curl apt-transport-https unzip wget libcap2-bin -y

# Set hostname
sudo hostnamectl set-hostname wazuh-server

# Configure firewall
sudo ufw allow 22/tcp     # SSH
sudo ufw allow 443/tcp    # Wazuh Dashboard
sudo ufw allow 1514/tcp   # Wazuh agents
sudo ufw allow 1515/tcp   # Wazuh agents enrollment
sudo ufw allow 514/udp    # Syslog
sudo ufw allow 9200/tcp   # Opensearch (if exposing)
sudo ufw enable
```

#### Step 2: Install Wazuh All-in-One

```bash
# Download installation script
curl -sO https://packages.wazuh.com/4.7/wazuh-install.sh

# Run installation (all components on one server)
sudo bash wazuh-install.sh -a

# Save the output - contains admin credentials!
# Example output:
# User: admin
# Password: <random-password>
```

#### Step 3: Access Wazuh Dashboard

```bash
# Access in browser
https://<wazuh-server-ip>

# Default credentials (change immediately!)
Username: admin
Password: <from-installation-output>
```

#### Step 4: Initial Configuration

```bash
# Extract API credentials
sudo tar -xvf wazuh-install-files.tar wazuh-install-files/wazuh-passwords.txt

# View passwords
sudo cat wazuh-install-files/wazuh-passwords.txt

# Change admin password (recommended)
# Navigate to: Dashboard > Security > Internal Users > admin > Edit
```

---

### Option B: Elastic Security Installation

#### Step 1: Prepare Ubuntu Server

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Java (required for Elasticsearch)
sudo apt install openjdk-11-jdk -y

# Verify Java installation
java -version
```

#### Step 2: Install Elasticsearch

```bash
# Import Elasticsearch GPG key
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

# Add Elasticsearch repository
echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list

# Install Elasticsearch
sudo apt update && sudo apt install elasticsearch -y

# Configure Elasticsearch
sudo nano /etc/elasticsearch/elasticsearch.yml
```

Edit configuration:
```yaml
cluster.name: mini-soc
node.name: node-1
network.host: 0.0.0.0
http.port: 9200
discovery.type: single-node
xpack.security.enabled: true
```

```bash
# Start Elasticsearch
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch

# Set passwords for built-in users
sudo /usr/share/elasticsearch/bin/elasticsearch-setup-passwords interactive
```

#### Step 3: Install Kibana

```bash
# Install Kibana
sudo apt install kibana -y

# Configure Kibana
sudo nano /etc/kibana/kibana.yml
```

Edit configuration:
```yaml
server.port: 5601
server.host: "0.0.0.0"
elasticsearch.hosts: ["http://localhost:9200"]
elasticsearch.username: "kibana_system"
elasticsearch.password: "<password-from-previous-step>"
```

```bash
# Start Kibana
sudo systemctl enable kibana
sudo systemctl start kibana

# Access Kibana
# Browser: http://<server-ip>:5601
# Login with elastic user credentials
```

#### Step 4: Install Logstash (Optional)

```bash
# Install Logstash
sudo apt install logstash -y

# Create basic pipeline
sudo nano /etc/logstash/conf.d/syslog.conf
```

Example configuration:
```
input {
  tcp {
    port => 5140
    type => syslog
  }
  udp {
    port => 5140
    type => syslog
  }
}

filter {
  if [type] == "syslog" {
    grok {
      match => { "message" => "%{SYSLOGLINE}" }
    }
    date {
      match => [ "timestamp", "MMM  d HH:mm:ss", "MMM dd HH:mm:ss" ]
    }
  }
}

output {
  elasticsearch {
    hosts => ["localhost:9200"]
    user => "elastic"
    password => "<elastic-password>"
    index => "syslog-%{+YYYY.MM.dd}"
  }
}
```

```bash
# Start Logstash
sudo systemctl enable logstash
sudo systemctl start logstash
```

---

## Part 2: Windows Agent Deployment

### Step 1: Install Sysmon

```powershell
# Download Sysmon
Invoke-WebRequest -Uri "https://download.sysinternals.com/files/Sysmon.zip" -OutFile "$env:TEMP\Sysmon.zip"

# Extract
Expand-Archive -Path "$env:TEMP\Sysmon.zip" -DestinationPath "$env:TEMP\Sysmon"

# Download SwiftOnSecurity config
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/master/sysmonconfig-export.xml" -OutFile "$env:TEMP\sysmonconfig.xml"

# Install Sysmon with config
cd "$env:TEMP\Sysmon"
.\Sysmon64.exe -accepteula -i "$env:TEMP\sysmonconfig.xml"

# Verify installation
Get-Service Sysmon64
Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" -MaxEvents 5
```

### Step 2: Install Winlogbeat

```powershell
# Download Winlogbeat
Invoke-WebRequest -Uri "https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-8.11.0-windows-x86_64.zip" -OutFile "$env:TEMP\winlogbeat.zip"

# Extract to Program Files
Expand-Archive -Path "$env:TEMP\winlogbeat.zip" -DestinationPath "C:\Program Files"
Rename-Item "C:\Program Files\winlogbeat-8.11.0-windows-x86_64" "Winlogbeat"

# Navigate to directory
cd "C:\Program Files\Winlogbeat"

# Edit configuration
notepad winlogbeat.yml
```

Configuration template:
```yaml
winlogbeat.event_logs:
  - name: Application
    ignore_older: 72h
  - name: System
  - name: Security
  - name: Microsoft-Windows-Sysmon/Operational

output.elasticsearch:
  hosts: ["<siem-server-ip>:9200"]
  username: "elastic"
  password: "<elastic-password>"

# OR for Logstash output:
# output.logstash:
#   hosts: ["<siem-server-ip>:5044"]
```

```powershell
# Test configuration
.\winlogbeat.exe test config -c .\winlogbeat.yml

# Install as service
.\install-service-winlogbeat.ps1

# Start service
Start-Service winlogbeat

# Verify service status
Get-Service winlogbeat
```

### Step 3: Install Wazuh Agent (If using Wazuh)

```powershell
# Download Wazuh agent
Invoke-WebRequest -Uri "https://packages.wazuh.com/4.x/windows/wazuh-agent-4.7.0-1.msi" -OutFile "$env:TEMP\wazuh-agent.msi"

# Install with manager IP
msiexec.exe /i $env:TEMP\wazuh-agent.msi /q WAZUH_MANAGER="<wazuh-manager-ip>"

# Start agent
NET START WazuhSvc

# Verify connection
& "C:\Program Files (x86)\ossec-agent\agent-auth.exe" -m <wazuh-manager-ip>
```

---

## Part 3: Linux Agent Deployment

### Step 1: Install Auditd

```bash
# Install auditd
sudo apt install auditd audispd-plugins -y  # Ubuntu/Debian
# OR
sudo yum install audit audit-libs -y         # RHEL/CentOS

# Enable service
sudo systemctl enable auditd
sudo systemctl start auditd

# Add custom rules
sudo nano /etc/audit/rules.d/custom.rules
```

Example audit rules:
```
# Monitor authentication attempts
-w /var/log/auth.log -p wa -k auth_log
-w /etc/passwd -p wa -k passwd_changes
-w /etc/shadow -p wa -k shadow_changes

# Monitor privilege escalation
-w /usr/bin/sudo -p x -k sudo_execution
-w /etc/sudoers -p wa -k sudoers_changes

# Monitor suspicious file operations
-w /tmp -p wa -k tmp_operations
-w /root -p wa -k root_operations

# Monitor network connections
-a always,exit -F arch=b64 -S socket,connect -k network_connections
```

```bash
# Load rules
sudo augenrules --load

# Verify rules
sudo auditctl -l

# Test rule triggering
sudo cat /etc/shadow
ausearch -k shadow_changes
```

### Step 2: Install Osquery

```bash
# Add Osquery repository (Ubuntu)
export OSQUERY_KEY=1484120AC4E9F8A1A577AEEE97A80C63C9D8B80B
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $OSQUERY_KEY
sudo add-apt-repository 'deb [arch=amd64] https://pkg.osquery.io/deb deb main'

# Install
sudo apt update
sudo apt install osquery -y

# Configure osquery
sudo nano /etc/osquery/osquery.conf
```

Basic configuration:
```json
{
  "options": {
    "host_identifier": "hostname",
    "schedule_splay_percent": 10
  },
  "schedule": {
    "system_info": {
      "query": "SELECT * FROM system_info;",
      "interval": 3600
    },
    "open_connections": {
      "query": "SELECT * FROM process_open_sockets WHERE remote_address != '';",
      "interval": 600
    },
    "logged_in_users": {
      "query": "SELECT * FROM logged_in_users;",
      "interval": 600
    }
  }
}
```

```bash
# Start osquery
sudo systemctl enable osqueryd
sudo systemctl start osqueryd

# Test queries
osqueryi
> SELECT * FROM system_info;
> .quit
```

### Step 3: Forward Logs to SIEM

#### Option A: Using Filebeat

```bash
# Install Filebeat
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.11.0-amd64.deb
sudo dpkg -i filebeat-8.11.0-amd64.deb

# Configure Filebeat
sudo nano /etc/filebeat/filebeat.yml
```

Configuration:
```yaml
filebeat.inputs:
  - type: log
    enabled: true
    paths:
      - /var/log/auth.log
      - /var/log/syslog
      - /var/log/audit/audit.log

output.elasticsearch:
  hosts: ["<siem-ip>:9200"]
  username: "elastic"
  password: "<password>"
```

```bash
# Start Filebeat
sudo systemctl enable filebeat
sudo systemctl start filebeat
```

#### Option B: Using Wazuh Agent

```bash
# Download Wazuh agent
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | sudo apt-key add -
echo "deb https://packages.wazuh.com/4.x/apt/ stable main" | sudo tee /etc/apt/sources.list.d/wazuh.list

# Install
sudo apt update
sudo apt install wazuh-agent -y

# Configure manager
sudo nano /var/ossec/etc/ossec.conf
```

Update manager IP:
```xml
<client>
  <server>
    <address>WAZUH_MANAGER_IP</address>
  </server>
</client>
```

```bash
# Start agent
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
```

---

## Part 4: Network Device Configuration

### pfSense Syslog Configuration

1. **Access pfSense Web Interface**
   - Navigate to: `https://<pfsense-ip>`
   - Login with admin credentials

2. **Configure Remote Syslog**
   - Go to: `Status > System Logs > Settings`
   - Enable: "Enable Remote Logging"
   - Remote log servers: `<siem-ip>:514`
   - Select log contents:
     - [x] Firewall events
     - [x] DHCP service events
     - [x] VPN events
     - [x] System events

3. **Test Logging**
   ```bash
   # On SIEM server, listen for syslog
   sudo tcpdump -i any port 514 -vv
   
   # Trigger firewall event on pfSense
   # Check if logs appear
   ```

---

## Validation & Testing

### Check Agent Connectivity

#### Wazuh
```bash
# On Wazuh Manager
sudo /var/ossec/bin/agent_control -l

# Expected output: List of connected agents
```

#### Elastic
```bash
# Check indices
curl -X GET "localhost:9200/_cat/indices?v"

# Should see: winlogbeat-*, filebeat-*, etc.
```

### Verify Log Ingestion

```bash
# Search for recent events
# Wazuh: Dashboard > Security Events
# Elastic: Kibana > Discover > Select index pattern
```

### Test Detection Rules

```powershell
# Windows: Trigger failed login
runas /user:fakeuser cmd.exe

# Check SIEM for event ID 4625
```

```bash
# Linux: Trigger sudo event
sudo ls /root

# Check SIEM for sudo execution
```

---

## Troubleshooting

### Common Issues

#### Agent Not Connecting
```bash
# Check firewall
sudo ufw status
sudo netstat -tulpn | grep 1514

# Check agent logs
# Wazuh: /var/ossec/logs/ossec.log
# Winlogbeat: C:\ProgramData\winlogbeat\Logs
```

#### No Logs Appearing
```bash
# Verify agent is running
sudo systemctl status wazuh-agent
Get-Service winlogbeat

# Check output configuration
# Verify SIEM IP address and credentials
```

#### Dashboard Not Loading
```bash
# Check service status
sudo systemctl status wazuh-dashboard
sudo systemctl status kibana

# Check logs
sudo journalctl -u wazuh-dashboard -f
sudo journalctl -u kibana -f
```

---

## Next Steps

1. ✅ SIEM installed and accessible
2. ✅ At least one Windows agent deployed
3. ✅ At least one Linux agent deployed
4. ✅ Logs flowing to SIEM
5. ➡️ **Next**: Configure first use-case (Brute-force detection)

---

**Document Version**: 1.0  
**Last Updated**: November 27, 2025
