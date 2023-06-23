FROM nginx
COPY 000_default.conf /etc/nginx/conf.d/
COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["sh", "/docker-entrypoint.sh"]