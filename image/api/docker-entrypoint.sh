echo ====File move start====;
# move credentials to container
if ! [ "$(ls -A /root/api/apps)" ]; then
    echo Directory is empty: copy src, run initialize
    cp -a /tmp/newara/www/root/. /root/
    # For elasticsearch, below synonym is volume-mapped
    # It generate empty synonym file, and git clone failed.
    rm -rf /root/api/ara
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
    make i18n_compile;
    make i18n_generate;
    # if all tasks done, then create .env so that allow to do make run
    echo -e "\n"|ssh-keygen -t rsa -N ""
    touch /root/.ssh/authorized_keys
    cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
    echo 'set \-a; source /root/api/.env; set +a; source /root/api/.venv/bin/activate;' >> /root/.zshrc
 fi

echo '######WARNING: This is temporal file######' > /root/api/.env;
cat /tmp/env/.env >> /root/api/.env;
service ssh start;
echo ====File move done====;

sleep infinity;
