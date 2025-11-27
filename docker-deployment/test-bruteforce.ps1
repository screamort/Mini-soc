# Test Brute-Force Attack Simulation - Send logs to Logstash
Write-Host "`n=== SIMULATION ATTAQUE BRUTE-FORCE ===" -ForegroundColor Red
Write-Host "Envoi de 10 tentatives SSH échouées vers Logstash...`n" -ForegroundColor Yellow

$udp = New-Object System.Net.Sockets.UdpClient

for ($i=1; $i -le 10; $i++) {
    $timestamp = Get-Date -Format "MMM dd HH:mm:ss"
    $log = "$timestamp test-agent sshd[12345]: Failed password for fakeuser$i from 192.168.1.100 port 54321 ssh2"
    
    Write-Host "[$i/10] Envoi log: Failed password for fakeuser$i" -ForegroundColor Cyan
    
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($log)
    $udp.Send($bytes, $bytes.Length, "localhost", 5140) | Out-Null
    
    Start-Sleep 1
}

$udp.Close()

Write-Host "`n✅ Test terminé! 10 logs envoyés" -ForegroundColor Green
Write-Host "Allez dans Kibana (http://localhost:5601) > Discover" -ForegroundColor Yellow
Write-Host "Cherchez: 'Failed password' pour voir les attaques`n" -ForegroundColor White
