#!/bin/bash
docker stack rm BE_198013
sleep 10

docker stack deploy -c docker-compose-klaster.yml BE_198013 --with-registry-auth

container_id=""
for i in {1..40}; do
    container_id=$(docker ps -q -f name=BE_198013_prestashop)
    [ ! -z "$container_id" ] && break
    echo "Retry $i/40..."
    sleep 5
done

if [ -z "$container_id" ]; then
    exit 1
fi

docker exec -u 0 -i $container_id bash <<EOF
rm -rf /var/www/html/var/cache/*
EOF