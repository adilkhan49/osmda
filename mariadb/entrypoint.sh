# bin/sh

cd mnt
wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/northwindextended/Northwind.MySQL5.sql -O northwind-dump.sql
mariadb -uroot -proot_password northwind <  northwind-dump.sql
mariadb -uroot -proot_password "GRANT ALL PRIVILEGES ON northwind.* TO 'dev'"