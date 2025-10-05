source .env
docker exec -it iox influxdb3 query "SHOW DATABASES" --token $INFLUXDB_TOKEN
#docker exec -it iox influxdb3 create database $1 --token $INFLUXDB_TOKEN
