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

### 1) MARIADB

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

### Windows
Download the file
```
curl --output northwind-dump.sql --url https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/northwindextended/Northwind.MySQL5.sql
```

### Docker setup for Windows if MariaDB cannot be downloaded
Go into docker compose file
```
cd docker\maria_db\docker-compose.yml
```
Run docker compose file to set up mariadb and adminer 
```
docker-compose up -d
```

Load docker to run MariaDB through CLI
```
docker exec -it [3 line container id, e.g 31c] sh 
apt-get update -y
apt-get install wget -y
wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/northwindextended/Northwind.MySQL5.sql -O northwind-dump.sql
mariadb -u root -proot_password -p northwind < northwind-dump.sql
mariadb -u root -p
```

In MariaDB
```
CREATE USER 'dev' IDENTIFIED BY 'pwd';
GRANT ALL PRIVILEGES ON northwind.* TO 'dev';
```


### 2) TRINO CLUSTER

```
docker-compose up --scale trino-worker=3
docker exec -it osmda-trino-coordinator-1  /usr/bin/trino --execute "SELECT * FROM system.runtime.nodes" --output-format=ALIGNED
docker exec -it osmda-trino-coordinator-1  /usr/bin/trino
```

