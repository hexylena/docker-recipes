#!/bin/sh

while [ -n "$(curl http://apollo:8080/apollo/annotator/index > /dev/null)"  ]; do
    echo "$(date) - waiting for apollo..."
    sleep 2
done

curl 'http://apollo:8080/apollo/login/registerAdmin' \
    --connect-timeout 2 \
     -H 'Content-type: application/x-www-form-urlencoded' \
     --data 'data={"operation":"register", "username":"'${ADMIN_USERNAME}'", "password":"'${ADMIN_PASSWORD}'", "rememberMe":false, "firstName":"'${ADMIN_FIRST_NAME}'", "lastName":"'${ADMIN_LAST_NAME}'"}'
