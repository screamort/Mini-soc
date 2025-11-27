Write-Host 'LANCEMENT DE TOUS LES TESTS' -ForegroundColor Magenta

Write-Host '1/3 Brute-Force Attack...' -ForegroundColor Cyan
& '.\test-bruteforce.ps1'

Start-Sleep 2

Write-Host '2/3 Admin Privilege Abuse...' -ForegroundColor Cyan
& '.\test-admin-abuse.ps1'

Start-Sleep 2

Write-Host '3/3 Web Attacks...' -ForegroundColor Cyan
& '.\test-web-attacks.ps1'

Write-Host 'TERMINE - Allez sur http://localhost:5601' -ForegroundColor Green
