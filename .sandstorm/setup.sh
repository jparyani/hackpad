#!/bin/bash

set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y scala mysql-server openjdk-7-jdk

service mysql stop
systemctl disable mysql

# patch mysql conf to not change uid
sed --in-place='' \
        --expression='s/^user\t\t= mysql/#user\t\t= mysql/' \
        /etc/mysql/my.cnf
# patch mysql conf to use smaller transaction logs to save disk space
cat <<EOF > /etc/mysql/conf.d/sandstorm.cnf
[mysqld]
# Set the transaction log file to the minimum allowed size to save disk space.
innodb_log_file_size = 1048576
# Set the main data file to grow by 1MB at a time, rather than 8MB at a time.
innodb_autoextend_increment = 1
EOF
