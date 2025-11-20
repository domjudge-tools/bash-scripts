#!/usr/bin/env bash
set -eEo pipefail

# --- Step 1: generate .env if missing ---
if [ ! -f .env ]; then
  echo "Generating .env file..."
  cat <<EOF > .env
MARIADB_ROOT_PASSWORD=$(openssl rand -hex 16)
MARIADB_DATABASE=domjudge

MARIADB_USER=domjudge
MARIADB_PASSWORD=$(openssl rand -hex 16)

DOMSERVER_API_PASSWORD=

DOMJUDGE_ADMIN_USER=admin
EOF
  echo ".env created."
else
  echo ".env already exists."
fi

# --- Step 2: start mariadb and domserver only ---
echo "Starting mariadb and domserver..."
docker compose up -d mariadb domserver

# --- Step 3: wait for domserver to be ready ---
echo "Waiting for DOMserver to initialize..."
until docker exec domserver test -f /opt/domjudge/domserver/etc/restapi.secret 2>/dev/null; do
  sleep 2
  echo -n "."
done
echo ""
echo "DOMserver REST API secret found!"

# --- Step 4: extract secret ---
REST_SECRET=$(docker exec -it domserver cat /opt/domjudge/domserver/etc/restapi.secret | awk '/judgehost/ {print $4}')
admin_password=$(docker exec -it domserver cat /opt/domjudge/domserver/etc/initial_admin_password.secret)


echo "REST API Secret: $REST_SECRET"
echo "Admin password Secret: $admin_password"

# --- Step 5: update .env with the secret ---
if grep -q "DOMSERVER_API_PASSWORD=" .env; then
  sed -i "s|DOMSERVER_API_PASSWORD=.*|DOMSERVER_API_PASSWORD=${REST_SECRET}|" .env
else
  echo "DOMSERVER_API_PASSWORD=${REST_SECRET}" >> .env
fi

echo "DOMJUDGE_ADMIN_PASS=${admin_password}" >> .env

echo "Updated .env with DOMSERVER_API_PASSWORD."

# --- Step 6: start judgehost ---
#
echo "Starting judgehost-0..."
echo ""
echo "
✅ You can now start additional judgehosts!

To add more judgehosts:
1. Copy the 'judgehost-0' block in your docker-compose.yml
2. Change the container_name and DAEMON_ID (e.g., judgehost-1, 1)
3. Repeat as many times as you want

Then run each new judgehost with:
   docker compose up -d judgehost-<number>

Example:
   docker compose up -d judgehost-1
   docker compose up -d judgehost-2
"
echo ""
read -p "Continue and start the judgehost-0? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

docker compose up -d judgehost-0

echo "✅ DOMjudge setup complete!"

