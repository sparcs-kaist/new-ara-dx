# cp /tmp/app/.env /usr/src/app;
echo '######WARNING: This is temporal file######' > /usr/src/app/.env
cat /tmp/env/.env >> /usr/src/app/.env
npm run swenv;
if [ "$1" = "sleep" ]; then
	sleep infinity;
else
	service ssh start;
	git pull;
	npm install; # For new version of dev branch, it may requires new package.
	npm run serve; # It may killed by api container.
	sleep infinity;
fi
