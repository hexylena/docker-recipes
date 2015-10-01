sed -i "s|PROXY_PREFIX|${PROXY_PREFIX}|" /proxy.conf;
sed -i "s|PROXY_HOST|${GUACAMOLE_PORT_8080_TCP_ADDR}|" /proxy.conf;
cp /proxy.conf /etc/nginx/conf.d/default.conf
nginx -g 'daemon off;'
