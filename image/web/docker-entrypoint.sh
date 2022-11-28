# cp /tmp/app/.env /usr/src/app;
echo '######WARNING: This is temporal file######' >> /usr/src/app/.env
cat /tmp/env/.env >> /usr/src/app/.env
npm run swenv;
if [ "$1" = "sleep" ]; then
	sleep infinity;
else
	git pull;
	npm run serve;
fi
