#!/bin/bash
set -e
CONTAINER=$(docker ps --filter "name=admin-mysql_db" --format "{{.Names}}")
if [ -z "$CONTAINER" ]; then
  echo "Container not running"
  exit 1
fi
echo "Creating database"
docker exec "$CONTAINER" mysql -u root -pstudent -e "DROP DATABASE IF EXISTS BE_198013; CREATE DATABASE BE_198013;"
echo "Importing database"
docker exec -i "$CONTAINER" mysql -u root -pstudent BE_198013 < prestashop_backup.sql
echo "Database loaded"

docker exec -i $CONTAINER mysql -u root -pstudent BE_198013 <<EOF
UPDATE ps_configuration SET value='localhost:19801' WHERE name IN ('PS_SHOP_DOMAIN', 'PS_SHOP_DOMAIN_SSL');
UPDATE ps_shop_url SET domain='localhost:19801', domain_ssl='localhost:19801';
EOF
echo "Database configured"