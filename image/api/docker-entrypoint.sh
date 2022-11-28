echo ====File move start====;
# move credentials to container
if ! [ "$(ls -A /root/api/apps)" ]; then
    echo Directory is empty: copy src, run initialize
    git clone https://github.com/sparcs-kaist/new-ara-api.git /root/api/.
    cat /tmp/env/firebaseServiceAccountKey.json > /root/api/firebaseServiceAccountKey.json;
    git fetch;
    git checkout develop;
    poetry install;
    set -a;
    source /tmp/env/.env;
    set +a;
    source /root/api/.venv/bin/activate;
    while ! nc -vz $NEWARA_DB_HOST $NEWARA_DB_PORT; do
    	>&2 echo "MySQL is unavailable - sleeping"
	sleep 1
    done
    make migrate;
    # if all tasks done, then create .env so that allow to do make run 
    echo 'set \-a; source .env; set +a; source .venv/bin/activate;' > /root/api/activate
 fi

echo '######WARNING: This is temporal file######' > /root/api/.env;
cat /tmp/env/.env >> /root/api/.env;
echo ====File move done====;

sleep infinity;
