# Open Source Modern Data Architecture


The objective of this project is to build an architecture based on Trino. 

## Archicture

- 3 worker Trino cluster
- MariaDB Source Database with the Northwind dataset loaded
- MinIO Object Store with Hive Metastore and Titanic dataset loaded


Next Steps:

- Add more data sources (Snowflake, S3, Blob)
- Visualisation with Grafana
- Data Processing with DBT
- Orchestration with Airflow


# Set up

```
docker-compose up --scale trino-worker=3 --build trino-coordinator trino-worker 
docker-compose up --scale trino-worker=3 --builddo
docker compose exec -it trino-coordinator  /usr/bin/trino --execute "SELECT * FROM system.runtime.nodes" --output-format=ALIGNED
docker exec -it osmda-trino-coordinator-1  /usr/bin/trino
```

# Trino CLI

```
wget https://repo1.maven.org/maven2/io/trino/trino-cli/426/trino-cli-426-executable.jar -O ~/bin/trino
chmod +x ~/bin/trino
export PATH=~/bin:$PATH
trino
> SELECT * FROM system.runtime.nodes;
```

Alternatively connect using client (e.g. DBeaver)

Run commands in demo.sql

## Install dependencies for python packages

Install python dependencies
```
pip install -r requirements.txt
```

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

### 3) dbt Setup
#### For local use dbt-core setup

Initializing dbt
```
mkdir dbt-dagster
cd dbt-dagster
dbt init
```

- Project name: northwind_dbt
- Please use the profiles.yml to set up connection between dbt and MariaDB (dbt-dagster\profiles.yml)


### 4) Dagster

Linking Dagster with dbt and creating a dagster project
```
dagster-dbt project scaffold --project-name northwind_dagster --dbt-project-dir '[Location of the dbt project]'
```

- workspace.ymal file can be used to link different project workspace. To be used for orchestration.

To run dagster based on different workspaces/code spaces
```
dagster dev -w workspace.yaml
```
