# Open Source Modern Data Architecture


THe objective of this project is to build an architecture based on Trino. 

## Archicture

- MariaDB Source Database with the Northwind dataset loaded
- 3 worker Trino cluster

Next Steps:

- Add more data sources (flat file, APIs, DWH)
- Visualisation with Grafana
- Data Processing with DBT
- Orchestration with Airflow


## Set up

### MARIADB

NB: Set up instructions are for Mac


```
brew install mariadb
brew services start mariadb
mysql -e "CREATE OR REPLACE DATABASE northwind"
wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/northwindextended/Northwind.MySQL5.sql -O northwind-dump.sql
mysql northwind < northwind-dump.sql
mysql -e "CREATE USER 'dev'@localhost IDENTIFIED BY 'pwd'" 
mysql -e "GRANT ALL PRIVILEGES ON northwind.* TO 'dev'@localhost" 
```

### TRINO CLUSTER

```
docker-compose up --scale trino-worker=3
docker exec -it osmda-trino-coordinator-1  /usr/bin/trino --execute "SELECT * FROM system.runtime.nodes" --output-format=ALIGNED
docker exec -it osmda-trino-coordinator-1  /usr/bin/trino
```

