# Quick Start Guide - Mini-SOC

## 5-Minute Overview

This project provides a fully functional Security Operations Center (SOC) using Docker and Elastic Stack.

**Goal**: Run a complete SOC in under 5 minutes  
**Time**: 5 minutes to deploy, days to master  
**Cost**: Free (Docker + Elastic Stack)

---

## What You'll Get

- ✅ Elasticsearch for log storage
- ✅ Kibana for visualization
- ✅ Logstash for log processing
- ✅ 3 pre-configured attack simulations
- ✅ Test agent container (Ubuntu with SSH)
- ✅ Network-accessible services

---

## Step-by-Step (5 Minutes)

### Step 1: Prerequisites (1 minute)
- Install Docker Desktop (Windows/Mac) or Docker Engine (Linux)
- Minimum 8GB RAM available
- 20GB free disk space

### Step 2: Clone & Deploy (2 minutes)
```bash
# Clone repository
git clone https://github.com/screamort/Mini-soc.git
cd Mini-soc/docker-deployment

# Start all services
docker compose -f docker-compose-elastic.yml up -d
```

### Step 3: Wait for Startup (2 minutes)
Services take ~60 seconds to initialize:
- Elasticsearch
- Kibana  
- Logstash
- Test Agent

### Step 4: Access & Test (1 minute)
1. **Open Kibana**: http://localhost:5601
2. **Run first test**:
   ```powershell
   # Windows PowerShell
   .\test-bruteforce.ps1
   ```
   ```bash
   # Linux/Mac
   ./test-bruteforce.ps1
   ```
3. **View results** in Kibana > Discover > Search: `Failed password`

---

## Services & Access

| Service | URL | Purpose |
|---------|-----|----------|
| Kibana | http://localhost:5601 | Dashboards & visualization |
| Elasticsearch | http://localhost:9200 | Data storage & search |
| Logstash Syslog | UDP 5140 | Log collection |
| Logstash Beats | TCP 5044 | Agent connections |
| Test Agent SSH | Port 2222 | Attack target (root/testpassword) |

## Available Test Scripts

| Script | Attack Type | Events Generated |
|--------|-------------|------------------|
| `test-bruteforce.ps1` | SSH brute-force | 10 failed logins |
| `test-admin-abuse.ps1` | Privilege abuse | 5 sudo commands |
| `test-web-attacks.ps1` | Web attacks | 6 SQL/XSS attempts |
| `test-all.ps1` | All attacks | 21 total events |

---

## Common Issues

### Issue 1: Docker Not Running
**Solution**: 
- Start Docker Desktop
- Wait 30 seconds for Docker to initialize
- Retry `docker compose up -d`

### Issue 2: Port Already in Use
**Solution**:
- Check if services already running: `docker ps`
- Stop existing containers: `docker compose down`
- Kill process using port: `netstat -ano | findstr :5601`

### Issue 3: Kibana Not Accessible
**Solution**:
- Wait 60-90 seconds after `docker compose up`
- Check container status: `docker compose ps`
- View logs: `docker compose logs kibana`

### Issue 4: Network Access from Other Devices
**Solution**:
- Run firewall script (as Admin): `.\configure-firewall.ps1`
- Use your machine's IP instead of localhost
- Ensure devices are on same network

---

## Your First Hour

**Minute 0-5**: Deploy the stack  
**Minute 5-10**: Explore Kibana interface  
**Minute 10-20**: Run attack simulations  
**Minute 20-40**: Analyze detection results  
**Minute 40-60**: Create first dashboard

---

## Critical Commands

### Start/Stop Services
```bash
# Start all services
docker compose -f docker-compose-elastic.yml up -d

# Stop all services
docker compose -f docker-compose-elastic.yml down

# View status
docker compose -f docker-compose-elastic.yml ps
```

### View Logs
```bash
# All services
docker compose logs

# Specific service
docker compose logs kibana
docker compose logs elasticsearch

# Follow logs
docker compose logs -f
```

### Access Test Agent
```bash
# SSH into test agent
ssh -p 2222 root@localhost
# Password: testpassword

# Execute command in container
docker exec -it test-agent bash
```

---

## Success Checklist (First Hour)

- [ ] Docker Desktop running
- [ ] Repository cloned
- [ ] Services deployed (`docker compose up -d`)
- [ ] Kibana accessible (http://localhost:5601)
- [ ] Test script executed
- [ ] Logs visible in Kibana Discover
- [ ] Attack events detected
- [ ] Ready for advanced testing

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
