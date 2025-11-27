# Test Admin Privilege Abuse
Write-Host "`n=== SIMULATION ABUS PRIVILÈGES ADMIN ===" -ForegroundColor Red
Write-Host "Envoi de 5 actions admin suspectes...`n" -ForegroundColor Yellow

$udp = New-Object System.Net.Sockets.UdpClient

$actions = @(
    "sudo cat /etc/shadow",
    "sudo chmod 777 /etc/passwd",
    "sudo useradd -G sudo hacker",
    "sudo rm -rf /var/log/auth.log",
    "sudo iptables -F"
)

for ($i=0; $i -lt 5; $i++) {
    $timestamp = Get-Date -Format "MMM dd HH:mm:ss"
    $log = "$timestamp test-agent sudo: admin : COMMAND=$($actions[$i])"
    
    Write-Host "[$($i+1)/5] Action admin: $($actions[$i])" -ForegroundColor Cyan
    
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($log)
    $udp.Send($bytes, $bytes.Length, "localhost", 5140) | Out-Null
    Start-Sleep 1
}

$udp.Close()
Write-Host "`n✅ Test terminé! Cherchez 'sudo' dans Kibana`n" -ForegroundColor Green
