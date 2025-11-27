# Configuration Pare-feu Windows pour Mini-SOC
# EXECUTER EN TANT QU'ADMINISTRATEUR

Write-Host "`n=== CONFIGURATION PARE-FEU WINDOWS ===" -ForegroundColor Cyan
Write-Host "Autorisation des ports SOC sur le reseau...`n" -ForegroundColor Yellow

# Kibana Dashboard
Write-Host "[1/4] Kibana (port 5601)..." -ForegroundColor White
netsh advfirewall firewall add rule name="Mini-SOC Kibana" dir=in action=allow protocol=TCP localport=5601

# Elasticsearch
Write-Host "[2/4] Elasticsearch (port 9200)..." -ForegroundColor White
netsh advfirewall firewall add rule name="Mini-SOC Elasticsearch" dir=in action=allow protocol=TCP localport=9200

# Logstash Beats
Write-Host "[3/4] Logstash Beats (port 5044)..." -ForegroundColor White
netsh advfirewall firewall add rule name="Mini-SOC Logstash" dir=in action=allow protocol=TCP localport=5044

# Logstash Syslog
Write-Host "[4/4] Logstash Syslog (port 5140 UDP)..." -ForegroundColor White
netsh advfirewall firewall add rule name="Mini-SOC Syslog" dir=in action=allow protocol=UDP localport=5140

Write-Host "`n=== CONFIGURATION TERMINEE ===" -ForegroundColor Green
Write-Host "`nVos services sont maintenant accessibles depuis le reseau:" -ForegroundColor Yellow
Write-Host "  - Kibana: http://<VOTRE_IP>:5601" -ForegroundColor Cyan
Write-Host "  - Elasticsearch: http://<VOTRE_IP>:9200" -ForegroundColor Cyan
Write-Host "`nTrouvez votre IP avec: ipconfig`n" -ForegroundColor White
