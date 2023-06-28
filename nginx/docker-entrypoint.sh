#! /bin/sh

nicknames=$NICKNAMES

# Set the IFS variable to a comma
IFS=","

for nickname in $nicknames; do
    echo "setup $nickname.newaradx.sparcs.org..."
    cat <<-EOF > /etc/nginx/conf.d/$nickname.conf
    server {
        server_name $nickname.newaradx.sparcs.org;
        listen 80;
        listen [::]:80;
        recursive_error_pages   on;
        proxy_ssl_server_name on;

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
                proxy_pass http://dind-$nickname:80;
            }

            # Send to Backend
            location /api {
                proxy_pass http://dind-$nickname:9000;
            }

            location /robots.txt {
                return 200 "User-agent: *\\nDisallow: /\\n";
            }

        }

        error_page 502 /502;
        location = /502 {
            proxy_pass https://http.cat/502;
        }

    }
EOF
done

nginx -g "daemon off;";