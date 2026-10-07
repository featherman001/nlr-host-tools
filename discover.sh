#!/bin/bash
echo "=== hostname ==="; hostname
echo "=== identity ==="; id
echo "=== os ==="; head -3 /etc/os-release
echo "=== uptime ==="; uptime
echo "=== docker ps ==="; (docker ps 2>&1 || sudo docker ps 2>&1) | head -30
echo "=== docker ps -a ==="; (docker ps -a 2>&1 || sudo docker ps -a 2>&1) | head -40
echo "=== docker images ==="; (docker images 2>&1 || sudo docker images 2>&1) | head -25
echo "=== compose files ==="; find / -maxdepth 5 \( -name "docker-compose*.yml" -o -name "compose.y*ml" \) 2>/dev/null | head -20
echo "=== running services ==="; systemctl list-units --type=service --state=running --no-pager 2>&1 | head -30
echo "=== nginx ==="; nginx -v 2>&1; ls -la /etc/nginx/conf.d /etc/nginx/sites-enabled 2>&1 | head -30
echo "=== dirs ==="; ls -la /home /srv /opt /var/www 2>&1 | head -40
echo "=== git repos ==="; find /home /srv /opt /var/www -maxdepth 4 -name ".git" -type d 2>/dev/null | head -20
echo "=== listening ports ==="; (ss -ltnp 2>&1 || netstat -ltnp 2>&1) | head -30
echo "=== container env (names only) ==="; for c in $(sudo docker ps --format '{{.Names}}' 2>/dev/null); do echo "-- $c --"; sudo docker inspect -f '{{range .Config.Env}}{{println .}}{{end}}' "$c" 2>/dev/null | grep -iE "SESSION|QBO|DATABASE|MICROSOFT|OWNER|NODE_ENV" | sed 's/=.*/=<set>/'; done
echo "=== per-boot scripts ==="; ls -la /var/lib/cloud/scripts/per-boot 2>&1 | head -10
echo "=== DONE ==="
