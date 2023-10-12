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
docker-compose up -d --scale trino-worker=3 --build trino-coordinator trino-worker mariadb
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


