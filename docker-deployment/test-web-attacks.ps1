# Test Web Attacks (SQL Injection, XSS)
Write-Host "`n=== SIMULATION ATTAQUES WEB ===" -ForegroundColor Red
Write-Host "Envoi de 6 attaques web...`n" -ForegroundColor Yellow

$udp = New-Object System.Net.Sockets.UdpClient

$attacks = @(
    "GET /login.php?id=1' OR '1'='1 HTTP/1.1",
    "POST /search?q=<script>alert('XSS')</script> HTTP/1.1",
    "GET /admin/../../../etc/passwd HTTP/1.1",
    "POST /api/users?id=1 UNION SELECT password FROM users HTTP/1.1",
    "GET /page.php?file=../../../../etc/shadow HTTP/1.1",
    "POST /comment?text=<img src=x onerror=alert(1)> HTTP/1.1"
)

for ($i=0; $i -lt 6; $i++) {
    $timestamp = Get-Date -Format "MMM dd HH:mm:ss"
    $log = "$timestamp web-server apache: 192.168.1.50 - - [$timestamp] `"$($attacks[$i])`" 200 1234"
    
    Write-Host "[$($i+1)/6] Attaque: $($attacks[$i].Substring(0,40))..." -ForegroundColor Cyan
    
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($log)
    $udp.Send($bytes, $bytes.Length, "localhost", 5140) | Out-Null
    Start-Sleep 1
}

$udp.Close()
Write-Host "`n✅ Test terminé! Cherchez 'script' ou 'UNION' dans Kibana`n" -ForegroundColor Green
