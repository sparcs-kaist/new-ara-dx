#! /bin/bash

if [ "$1" = "on" ]; then
	if [ -f "nginx/$2.conf" ]; then
		echo "Already enabled";
	elif [ -f "nginx/$2.conf.old" ]; then
		mv nginx/$2.conf.old nginx/$2.conf;
		docker exec nginx-dx nginx -s reload &&
		echo "Successfully enabled domain $2.newaradx.sparcs.org" ||
		mv nginx/$2.conf nginx/$2.conf.old;
	else
		echo "No named file nginx/$2.conf.old; Would you like to create new domain? [y/n]";
		read inp
		if [ "$inp" = "y" ]; then
			cat <<-EOF > nginx/$2.conf.old
			server {
				server_name $2.newaradx.sparcs.org;
				listen 80;
				listen [::]:80;


				location / {
					# Default headers
					proxy_set_header Host                   \$http_host;
					proxy_set_header X-Real-IP              \$remote_addr;
					proxy_set_header X-Forwarded-For        \$proxy_add_x_forwarded_for;
					proxy_set_header X-NginX-Proxy          true;

					# For websocket
					proxy_http_version 1.1;
					proxy_set_header Upgrade                \$http_upgrade;
					proxy_set_header Connection             "Upgrade";

					proxy_redirect off;

					# Send to Frontend
					location / {
						proxy_pass http://$2-web-1:8080;
					}

					# Send to Backend
					location /api {
						proxy_pass http://$2-api-1:9000;
					}

					location /robots.txt {
						return 200 "User-agent: *\\nDisallow: /\\n";
					}

				}
			}
			EOF
			
			mv nginx/$2.conf.old nginx/$2.conf;
			docker exec nginx-dx nginx -s reload &&
			echo "Successfully enabled domain $2.newaradx.sparcs.org" ||
			mv nginx/$2.conf nginx/$2.conf.old;
		fi
	fi;
elif [ "$1" = "off" ]; then
	if [ -f "nginx/$2.conf" ]; then
		mv nginx/$2.conf nginx/$2.conf.old;
		docker exec nginx-dx nginx -s reload &&
		echo "Successfully disabled domain $2.newaradx.sparcs.org" ||
		mv nginx/$2.conf.old nginx/$2.conf;
	elif [ -f "nginx/$2.conf.old" ]; then
		echo "Already disabled";
	else
		echo "No named file nginx/$2.conf";
		exit 1;
	fi;
elif [ "$1" = "rm" ]; then
	rm nginx/$2.conf nginx/$2.conf.old 2> /dev/null;
	echo "Delete $2 conf file"
else
	echo "Unknown command $1";
	exit 1;
fi

# cat <<EOF > nginx/$2.con
# EOFf
