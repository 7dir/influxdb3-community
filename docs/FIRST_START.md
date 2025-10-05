# FIRST START

## Create TOKEN

```sh
docker exec -it iox influxdb3 create token --admin
# export INFLUXDB_TOKEN=apiv3_yzALPZKm5Ukr50tnxgDQgu1anMpaBMXOOiytb0LDjifvF_PLnjA_x6whx8linZQKDEqxp9_REsqoXLM4gGhldg
```

## Create DATABASE

```sh
# connect to docker
export INFLUXDB_TOKEN=apiv3_yzALPZKm5Ukr50tnxgDQgu1anMpaBMXOOiytb0LDjifvF_PLnjA_x6whx8linZQKDEqxp9_REsqoXLM4gGhldg
influxdb3 create database js1 --token $INFLUXDB_TOKEN

docker exec -it iox influxdb3 create database $1 --token $INFLUXDB_TOKEN
```

## SHOW DATABASES

```sh
docker exec -it iox influxdb3 query "SHOW DATABASES"
export INFLUXDB_TOKEN=apiv3_yzALPZKm5Ukr50tnxgDQgu1anMpaBMXOOiytb0LDjifvF_PLnjA_x6whx8linZQKDEqxp9_REsqoXLM4gGhldg

$ docker exec -it iox influxdb3 query --database "_internal" --token $INFLUXDB_TOKEN --help
Perform a query against a running InfluxDB 3 Core server

Usage: influxdb3 query [OPTIONS] --database <DATABASE_NAME> [QUERY]

Arguments:
  [QUERY]  The query string to execute

Options:
  -H, --host <HOST_URL>            The host URL of the running InfluxDB 3 Core server [env: INFLUXDB3_HOST_URL=] [default: http://127.0.0.1:8181]
  -d, --database <DATABASE_NAME>   The name of the database to operate on [env: INFLUXDB3_DATABASE_NAME=]
      --token <AUTH_TOKEN>         The token for authentication with the InfluxDB 3 Core server [env: INFLUXDB3_AUTH_TOKEN=]
  -l, --language <LANGUAGE>        The query language used to format the provided query string [default: sql] [possible values: sql, influxql]
      --format <OUTPUT_FORMAT>     The format in which to output the query [default: pretty] [possible values: pretty, json, jsonl, csv, parquet]
  -o, --output <OUTPUT_FILE_PATH>  Put all query output into `output`
  -f, --file <FILE_PATH>           A file containing sql statements to execute
      --tls-ca <CA_CERT>           An optional arg to use a custom ca for useful for testing with self signed certs [env: INFLUXDB3_TLS_CA=]
  -h, --help                       Print help information
      --help-all                   Print more detailed help information

$ docker exec -it iox influxdb3 query --database "_internal" --token $INFLUXDB_TOKEN --language influxql "SHOW DATABASES" --format jsonl
{"iox::database":"_internal","deleted":false}
{"iox::database":"js1","deleted":false}
{"iox::database":"mike-home","deleted":false}
{"iox::database":"mydb","deleted":false}
{"iox::database":"node-red_pc","deleted":false}

$ docker exec -it iox influxdb3 query --database "_internal" --token $INFLUXDB_TOKEN --language influxql "SHOW DATABASES" --format pretty
+---------------+---------+
| iox::database | deleted |
+---------------+---------+
| _internal     | false   |
| js1           | false   |
| mike-home     | false   |
| mydb          | false   |
| node-red_pc   | false   |
+---------------+---------+

$ docker exec -it iox influxdb3 query --database "_internal" --token $INFLUXDB_TOKEN --language influxql "SHOW DATABASES" --format json

[{"iox::database":"_internal","deleted":false},{"iox::database":"js1","deleted":false},{"iox::database":"mike-home","deleted":false},{"iox::database":"mydb","deleted":false},{"iox::database":"node-red_pc","deleted":false}]

```

## Write data

```ts
// cpu,host=server-a,region=eu usage_percent=58.3 1712345678000000000
// cpu,host=localhost,region=ru cpu_percent=58.3,ram_usage=1000 1712345678000000000

<measurement>[,<tag_key>=<tag_value>[,<tag_key>=<tag_value>...]] <field_key>=<field_value>[,<field_key>=<field_value>...] [<timestamp>]
```

cpu,host=server-a,region=eu usage_percent=58.3 1712345678000000000
└──┘└─────────────┬──────────────┘└──────────────┬─────────────┘└──────────────┬────────┘
measurement       tags (meta)                    fields (данные)              timestamp

| Тип                             | Синтаксис в LP                                 | Пример                      | SQL-тип в таблице |
| ------------------------------- | ---------------------------------------------- | --------------------------- | ----------------- |
| **Float 64-bit**                | без постфикса                                  | `temp=23.7`                 | `DOUBLE`          |
| **Integer 64-bit signed**       | суффикс `i`                                    | `co=-123i`                  | `BIGINT`          |
| **Integer 64-bit unsigned**     | суффикс `u`                                    | `counter=42u`               | `BIGINT UNSIGNED` |
| **String / text**               | двойные кавычки                                | `msg="error"`               | `STRING`          |
| **Boolean**                     | `t` / `T` / `true` / `TRUE` (аналогично false) | `alarm=true`                | `BOOLEAN`         |
| **Timestamp (вставка в поле!)** | строка в кавычках                              | `ts="2024-06-01T12:00:00Z"` | `TIMESTAMP`       |



```sh
export INFLUXDB_TOKEN=apiv3_yzALPZKm5Ukr50tnxgDQgu1anMpaBMXOOiytb0LDjifvF_PLnjA_x6whx8linZQKDEqxp9_REsqoXLM4gGhldg

curl -i -X POST 'http://192.168.1.10:8181/api/v3/write_lp?db=js1&precision=auto' \
  -H "Content-Type: text/plain" \
  -H "Authorization: Bearer $INFLUXDB_TOKEN" \
  -d 'cpu,host=server-a,region=eu usage_percent=58.3 1712345678000000000'

export INFLUXDB_TOKEN=apiv3_yzALPZKm5Ukr50tnxgDQgu1anMpaBMXOOiytb0LDjifvF_PLnjA_x6whx8linZQKDEqxp9_REsqoXLM4gGhldg
curl -i -X POST 'http://192.168.1.10:8181/api/v3/write_lp?db=js1' \
  -H "Content-Type: text/plain" \
  -H "Authorization: Bearer $INFLUXDB_TOKEN" \
  -d 'cpu,host="mike-home",region="ru" usage_percent=58.3'
```

## Health

```sh
export INFLUXDB_TOKEN=apiv3_yzALPZKm5Ukr50tnxgDQgu1anMpaBMXOOiytb0LDjifvF_PLnjA_x6whx8linZQKDEqxp9_REsqoXLM4gGhldg

curl -i -X GET 'http://192.168.1.10:8181/health' \
  -H "Content-Type: text/plain" \
  -H "Authorization: Bearer $INFLUXDB_TOKEN"
```

```sh
export INFLUXDB_TOKEN=apiv3_yzALPZKm5Ukr50tnxgDQgu1anMpaBMXOOiytb0LDjifvF_PLnjA_x6whx8linZQKDEqxp9_REsqoXLM4gGhldg
curl -Gs http://192.168.1.10:8181/api/v3/query_sql -H "Authorization: Bearer $INFLUXDB_TOKEN" --data-urlencode 'db=mike-home' --data-urlencode 'q=SELECT 1'
```
