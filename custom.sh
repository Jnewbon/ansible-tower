#!/bin/bash

# Generate password for database
hash=$(date | sha256sum)
pass=${hash::-3}

# Generate tower iventory
cat >/opt/ansible-tower/inventory <<EOL
[tower]
localhost ansible_connection=local

[database]

[all:vars]
admin_password='password'

pg_host=''
pg_port=''

pg_database='awx'
pg_username='awx'
pg_password='${pass}'

rabbitmq_port=5672
rabbitmq_vhost=tower
rabbitmq_username=tower
rabbitmq_password='${pass}'
rabbitmq_cookie=rabbitmqcookie
rabbitmq_use_long_name=false
EOL

# Save password in file for read
cat >/opt/ansible-tower-password <<EOL
${pass}
EOL

chmod 700 /opt/ansible-tower-password
chmod 700 /opt/ansible-tower/inventory
