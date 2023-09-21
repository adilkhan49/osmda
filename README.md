# Open Source Modern Data Architecture


## MARIADB SET UP


```
brew install mariadb
brew services start mariadb
mysql -e "CREATE OR REPLACE DATABASE northwind"
wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/northwindextended/Northwind.MySQL5.sql -O northwind-dump.sql
mysql northwind < northwind-dump.sql
mysql -e "CREATE USER 'dev'@localhost IDENTIFIED BY 'pwd'" 
mysql -e "GRANT ALL PRIVILEGES ON northwind.* TO 'dev'@localhost" 
```


## START TRINO CLUSTER

```
docker-compose up --scale trino-worker=3
docker exec -it osmda-trino-coordinator-1  /usr/bin/trino --execute "SELECT * FROM system.runtime.nodes" --output-format=ALIGNED
docker exec -it osmda-trino-coordinator-1  /usr/bin/trino
```

