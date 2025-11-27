# Quick Start Guide - Mini-SOC

## 5-Minute Overview

This project helps you build a functional Security Operations Center (SOC) using open-source tools.

**Goal**: Learn real SOC operations without expensive software  
**Time**: 12 weeks (part-time)  
**Cost**: Free (using open-source tools)

---

## What You'll Build

- ✅ SIEM platform (Wazuh or Elastic)
- ✅ Log collection from Windows/Linux
- ✅ 6 attack detection use-cases
- ✅ Investigation playbooks
- ✅ Performance dashboards (MTTD, MTTR)
- ✅ Red-blue team exercise

---

## Step-by-Step (First 24 Hours)

### Hour 1: Understand the Project
1. Read: `README.md` (this gives you the big picture)
2. Review: `01-documentation/PROJECT_OVERVIEW.md`
3. Understand: `01-documentation/ARCHITECTURE.md`

### Hours 2-4: Set Up Lab Environment
**Option A: Virtual Machines (Recommended)**
- Install VMware Workstation or VirtualBox
- Download Ubuntu Server 22.04 ISO
- Download Windows 10 ISO
- Create VMs:
  - SIEM Server: 4 CPU, 8GB RAM, 100GB disk
  - Windows Test: 2 CPU, 4GB RAM, 60GB disk
  - Linux Test: 2 CPU, 2GB RAM, 40GB disk

**Option B: Cloud**
- AWS/Azure/GCP free tier
- Create instances matching above specs

### Hours 5-8: Install SIEM
**For Beginners: Choose Wazuh**

Follow: `01-documentation/INSTALLATION_GUIDE.md`

Quick commands:
```bash
# On Ubuntu Server
curl -sO https://packages.wazuh.com/4.7/wazuh-install.sh
sudo bash wazuh-install.sh -a
```

Access dashboard: `https://<server-ip>`  
Save the admin password shown during installation!

### Hours 9-12: Deploy First Agent

**Windows (Sysmon)**:
- Follow: `03-agents-deployment/windows/sysmon-deployment.md`
- Install Sysmon
- Configure log forwarding

**Linux (Auditd)**:
- Follow: `03-agents-deployment/linux/auditd-deployment.md`
- Install auditd
- Configure rules

### Hours 13-16: Test First Detection

**Brute-Force Use Case**:
1. Read: `04-use-cases/01-brute-force/use-case-brute-force.md`
2. Import rules: `02-siem-configs/wazuh/custom-rules.xml`
3. Test detection:
   ```powershell
   # Windows: Trigger failed logins
   1..10 | ForEach-Object { runas /user:fakeuser$_ cmd.exe }
   ```
4. Check SIEM for alerts

### Hours 17-24: Document & Practice

1. Create first incident ticket
2. Follow investigation playbook: `05-playbooks/investigation/`
3. Practice response: `05-playbooks/response/`
4. Document in REX template: `08-rex-feedback/REX-Template.md`

---

## Key Files Reference

| Need | File Location |
|------|---------------|
| Installation help | `01-documentation/INSTALLATION_GUIDE.md` |
| Wazuh rules | `02-siem-configs/wazuh/custom-rules.xml` |
| Elastic rules | `02-siem-configs/elastic-security/detection-rules.ndjson` |
| Windows agents | `03-agents-deployment/windows/` |
| Linux agents | `03-agents-deployment/linux/` |
| Use cases | `04-use-cases/` |
| Playbooks | `05-playbooks/` |
| Red-blue exercise | `07-red-blue-exercises/` |

---

## Common First-Day Issues

### Issue 1: SIEM Won't Install
**Solution**: 
- Check system requirements (4 CPU, 8GB RAM)
- Ensure fresh Ubuntu install
- Check firewall rules

### Issue 2: Agent Not Connecting
**Solution**:
- Verify SIEM IP address in agent config
- Check firewall allows port 1514
- Restart agent service

### Issue 3: No Logs Appearing
**Solution**:
- Verify agent is running
- Check agent configuration file
- Review SIEM logs for errors

### Issue 4: Can't Access Dashboard
**Solution**:
- Verify SIEM service is running
- Check firewall allows port 443
- Try from different browser
- Check credentials

---

## Your First Week Plan

**Day 1**: Lab setup + SIEM installation  
**Day 2**: Deploy Windows agent (Sysmon)  
**Day 3**: Deploy Linux agent (Auditd)  
**Day 4**: Import detection rules  
**Day 5**: Test brute-force detection  
**Day 6**: Practice investigation playbook  
**Day 7**: Document first REX

---

## Critical Commands Reference

### Check SIEM Status (Wazuh)
```bash
sudo systemctl status wazuh-manager
sudo systemctl status wazuh-dashboard
```

### View SIEM Logs
```bash
sudo tail -f /var/ossec/logs/ossec.log
```

### Check Agent Status
```bash
# Wazuh manager
sudo /var/ossec/bin/agent_control -l
```

### Test Detection Rule
```bash
# Wazuh
sudo /var/ossec/bin/ossec-logtest
# Paste log sample, press Enter twice
```

---

## Success Checklist (Week 1)

- [ ] SIEM installed and accessible
- [ ] Dashboard login working
- [ ] Windows agent deployed
- [ ] Linux agent deployed
- [ ] Logs visible in SIEM
- [ ] First detection rule tested
- [ ] Alert generated successfully
- [ ] Playbook followed
- [ ] Documentation created

---

## Need Help?

1. **Check documentation**: `01-documentation/` folder
2. **Review use-case**: Detailed steps in `04-use-cases/`
3. **Follow playbook**: Step-by-step in `05-playbooks/`
4. **Community resources**: 
   - Wazuh documentation
   - Elastic documentation
   - Security forums

---

## Next Steps After Week 1

1. ✅ Week 1 complete - Basic setup done
2. ➡️ Week 2 - Complete use-case #2 (Admin abuse)
3. ⏳ Week 3 - Complete use-case #3 (Web attacks)
4. ⏳ Week 4 - Complete use-case #4 (DNS exfiltration)
5. ⏳ Week 5 - Complete use-case #5 (Persistence)
6. ⏳ Week 6 - Complete use-case #6 (Lateral movement)
7. ⏳ Week 7-8 - Tune rules, reduce false positives
8. ⏳ Week 9 - Implement KPI dashboard
9. ⏳ Week 10-11 - Red-blue exercise
10. ⏳ Week 12 - Final documentation and REX

---

## Quick Tips

✅ **Start simple**: Begin with Wazuh, it's easier for beginners  
✅ **One step at a time**: Don't rush, validate each component  
✅ **Document everything**: Use the REX template from day 1  
✅ **Test frequently**: Break and fix to learn better  
✅ **Ask questions**: Communities are helpful  

❌ **Don't skip validation**: Always verify before moving on  
❌ **Don't run in production**: Use isolated test environment  
❌ **Don't ignore errors**: Fix issues before proceeding  

---

**Ready to start? Begin here**: `01-documentation/INSTALLATION_GUIDE.md`

**Questions?** Review the documentation in `01-documentation/`

**Good luck! 🚀**
