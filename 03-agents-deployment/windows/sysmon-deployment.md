# Windows Agent Deployment - Sysmon Configuration

## Overview
Sysmon (System Monitor) is a Windows system service that monitors and logs system activity to the Windows event log. It provides detailed information about process creations, network connections, file changes, and more.

## Prerequisites
- Windows 7+ or Windows Server 2008 R2+
- Administrator privileges
- PowerShell 3.0 or higher

---

## Installation Steps

### Method 1: PowerShell Automated Deployment

```powershell
# Create deployment directory
New-Item -Path "C:\SOC-Deployment" -ItemType Directory -Force
Set-Location "C:\SOC-Deployment"

# Download Sysmon
$sysmonUrl = "https://download.sysinternals.com/files/Sysmon.zip"
Invoke-WebRequest -Uri $sysmonUrl -OutFile "Sysmon.zip"

# Extract Sysmon
Expand-Archive -Path "Sysmon.zip" -DestinationPath ".\Sysmon" -Force

# Download SwiftOnSecurity configuration (recommended baseline)
$configUrl = "https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/master/sysmonconfig-export.xml"
Invoke-WebRequest -Uri $configUrl -OutFile ".\sysmonconfig.xml"

# Install Sysmon
Set-Location ".\Sysmon"
.\Sysmon64.exe -accepteula -i "..\sysmonconfig.xml"

# Verify installation
Get-Service Sysmon64
Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" -MaxEvents 10
```

### Method 2: Manual Installation

1. **Download Sysmon**
   - Visit: https://docs.microsoft.com/en-us/sysinternals/downloads/sysmon
   - Download Sysmon.zip

2. **Download Configuration**
   - SwiftOnSecurity config: https://github.com/SwiftOnSecurity/sysmon-config
   - Alternative configs:
     - Olaf Hartong: https://github.com/olafhartong/sysmon-modular
     - Ion-Storm: https://github.com/ion-storm/sysmon-config

3. **Install Sysmon**
   ```cmd
   Sysmon64.exe -accepteula -i sysmonconfig.xml
   ```

---

## Configuration File (Custom Mini-SOC)

Save this as `sysmonconfig-minisoc.xml`:

```xml
<Sysmon schemaversion="4.90">
  <HashAlgorithms>SHA256</HashAlgorithms>
  <CheckRevocation/>
  
  <EventFiltering>
    
    <!-- Event ID 1: Process Creation -->
    <RuleGroup name="" groupRelation="or">
      <ProcessCreate onmatch="exclude">
        <!-- Exclude noisy but safe processes -->
        <Image condition="end with">Google\Chrome\Application\chrome.exe</Image>
        <Image condition="end with">Microsoft\Edge\Application\msedge.exe</Image>
      </ProcessCreate>
    </RuleGroup>
    
    <!-- Event ID 3: Network Connection -->
    <RuleGroup name="" groupRelation="or">
      <NetworkConnect onmatch="include">
        <!-- Monitor all external connections -->
        <DestinationIp condition="is not">127.0.0.1</DestinationIp>
      </NetworkConnect>
    </RuleGroup>
    
    <!-- Event ID 7: Image/DLL Load -->
    <RuleGroup name="" groupRelation="or">
      <ImageLoad onmatch="include">
        <!-- Monitor suspicious DLL loads -->
        <Signed condition="is">false</Signed>
      </ImageLoad>
    </RuleGroup>
    
    <!-- Event ID 8: CreateRemoteThread (Injection) -->
    <RuleGroup name="" groupRelation="or">
      <CreateRemoteThread onmatch="include">
        <!-- Monitor all remote thread creation -->
      </CreateRemoteThread>
    </RuleGroup>
    
    <!-- Event ID 10: Process Access -->
    <RuleGroup name="" groupRelation="or">
      <ProcessAccess onmatch="include">
        <!-- Monitor LSASS access (credential dumping) -->
        <TargetImage condition="end with">lsass.exe</TargetImage>
      </ProcessAccess>
    </RuleGroup>
    
    <!-- Event ID 11: File Creation -->
    <RuleGroup name="" groupRelation="or">
      <FileCreate onmatch="include">
        <!-- Monitor startup locations -->
        <TargetFilename condition="contains">Start Menu\Programs\Startup</TargetFilename>
        <TargetFilename condition="contains">\AppData\Roaming\Microsoft\Windows\Start Menu</TargetFilename>
        <!-- Monitor temp executables -->
        <TargetFilename condition="begin with">C:\Users</TargetFilename>
        <TargetFilename condition="contains">\Temp\</TargetFilename>
        <TargetFilename condition="end with">.exe</TargetFilename>
      </FileCreate>
    </RuleGroup>
    
    <!-- Event ID 12/13/14: Registry Events -->
    <RuleGroup name="" groupRelation="or">
      <RegistryEvent onmatch="include">
        <!-- Monitor Run keys -->
        <TargetObject condition="contains">CurrentVersion\Run</TargetObject>
        <TargetObject condition="contains">CurrentVersion\RunOnce</TargetObject>
        <!-- Monitor services -->
        <TargetObject condition="contains">\services\</TargetObject>
        <!-- Monitor WinLogon -->
        <TargetObject condition="contains">Windows NT\CurrentVersion\Winlogon</TargetObject>
      </RegistryEvent>
    </RuleGroup>
    
    <!-- Event ID 15: FileStream Created (ADS) -->
    <RuleGroup name="" groupRelation="or">
      <FileCreateStreamHash onmatch="include">
        <!-- Monitor all Alternate Data Streams -->
      </FileCreateStreamHash>
    </RuleGroup>
    
    <!-- Event ID 22: DNS Query -->
    <RuleGroup name="" groupRelation="or">
      <DnsQuery onmatch="exclude">
        <!-- Exclude common safe domains -->
        <QueryName condition="end with">microsoft.com</QueryName>
        <QueryName condition="end with">windows.com</QueryName>
      </DnsQuery>
    </RuleGroup>
    
  </EventFiltering>
</Sysmon>
```

---

## Update Sysmon Configuration

```powershell
# Update config
Sysmon64.exe -c sysmonconfig-minisoc.xml

# Verify update
Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" -MaxEvents 5
```

---

## Verify Sysmon is Working

### Check Service Status
```powershell
Get-Service Sysmon64
```

Expected output:
```
Status   Name               DisplayName
------   ----               -----------
Running  Sysmon64           Sysmon64
```

### View Recent Events
```powershell
# View last 20 Sysmon events
Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" -MaxEvents 20 | Format-Table TimeCreated, Id, Message -AutoSize

# View specific event type (Process Creation)
Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-Sysmon/Operational'; ID=1} -MaxEvents 10
```

### Test Detection

```powershell
# Test 1: Process Creation (Event ID 1)
notepad.exe

# Test 2: Network Connection (Event ID 3)
Test-NetConnection google.com -Port 443

# Test 3: File Creation (Event ID 11)
New-Item -Path "$env:TEMP\test-sysmon.txt" -ItemType File

# Check events
Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" -MaxEvents 10 | Select TimeCreated, Id, Message
```

---

## Key Event IDs Reference

| Event ID | Description | Use Case |
|----------|-------------|----------|
| 1 | Process Creation | Malware execution, suspicious commands |
| 2 | File Creation Time Changed | Anti-forensics detection |
| 3 | Network Connection | C2 communications, lateral movement |
| 5 | Process Terminated | Process lifecycle tracking |
| 6 | Driver Loaded | Rootkit detection |
| 7 | Image/DLL Loaded | DLL injection, malicious libraries |
| 8 | CreateRemoteThread | Process injection |
| 10 | Process Access | Credential dumping (LSASS) |
| 11 | File Created | Malware droppers, persistence |
| 12 | Registry Object Created/Deleted | Persistence mechanisms |
| 13 | Registry Value Set | Configuration changes |
| 14 | Registry Object Renamed | Anti-forensics |
| 15 | FileStream Created (ADS) | Hidden data streams |
| 17/18 | Pipe Created/Connected | Inter-process communication |
| 22 | DNS Query | C2 communications, exfiltration |

---

## Integration with SIEM

Sysmon logs are written to:
```
Applications and Services Logs\Microsoft\Windows\Sysmon\Operational
```

### Forward to Wazuh

Edit `C:\Program Files (x86)\ossec-agent\ossec.conf`:

```xml
<localfile>
  <location>Microsoft-Windows-Sysmon/Operational</location>
  <log_format>eventchannel</log_format>
</localfile>
```

Restart Wazuh agent:
```powershell
Restart-Service WazuhSvc
```

### Forward to Elastic (via Winlogbeat)

Edit `C:\Program Files\Winlogbeat\winlogbeat.yml`:

```yaml
winlogbeat.event_logs:
  - name: Microsoft-Windows-Sysmon/Operational
    ignore_older: 72h
```

Restart Winlogbeat:
```powershell
Restart-Service winlogbeat
```

---

## Troubleshooting

### Sysmon Not Starting
```powershell
# Check event viewer for errors
Get-WinEvent -LogName "Application" | Where-Object {$_.Source -eq "Sysmon"}

# Reinstall
Sysmon64.exe -u
Sysmon64.exe -accepteula -i sysmonconfig.xml
```

### High CPU/Disk Usage
```xml
<!-- Add exclusions to config -->
<ProcessCreate onmatch="exclude">
  <Image condition="end with">chrome.exe</Image>
  <Image condition="end with">teams.exe</Image>
</ProcessCreate>
```

### Configuration Errors
```powershell
# Validate XML syntax
[xml](Get-Content sysmonconfig.xml)

# Test config without installing
Sysmon64.exe -c sysmonconfig.xml -dry
```

---

## Uninstallation

```powershell
# Uninstall Sysmon
Sysmon64.exe -u

# Verify removal
Get-Service Sysmon64
```

---

## Best Practices

1. **Start with SwiftOnSecurity config** - Well-balanced, low noise
2. **Monitor log volume** - Adjust exclusions if too high
3. **Regular updates** - Download latest Sysmon version
4. **Test changes** - Use -c switch to update config
5. **Backup config** - Keep version control of your config
6. **Document exclusions** - Note why specific items are excluded

---

**Configuration Version**: 1.0  
**Last Updated**: November 27, 2025  
**Sysmon Version**: 15.0+
