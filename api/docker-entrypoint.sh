echo ====File move start====;
mv /tmp/newara/firebaseServiceAccountKey.json /root/api;
if ! [ "$(ls -A /root/api/apps)" ]; then
    echo Directory is empty: copy src, run initialize
    mv -n /tmp/newara/www/* /tmp/newara/www/.* /root/api;
    poetry install;
    set -a;
    source /tmp/newara/.env;
    set +a;
    source /root/api/.venv/bin/activate;
    while ! nc -vz $NEWARA_DB_HOST $NEWARA_DB_PORT; do
    	>&2 echo "MySQL is unavailable - sleeping"
	sleep 1
    done
    make migrate;
    echo 'set \-a; source .env; set +a; source .venv/bin/activate;' > /root/api/activate
 fi

# if all tasks done, then create .env so that mllow to do make run 
mv /tmp/newara/.env /root/api;

echo ====File move done====;

sleep infinity;
