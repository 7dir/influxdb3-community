# TMSDB

## ### Understanding Time Series Data

Learn the basics of time series data and its applications.

### What is Time Series Data?

Time series data is a sequence of data points indexed in time order. Each point is a value paired with a timestamp, creating a chronological record of measurements or observations.

#### Common Examples of Time Series Data:

* **IoT Sensor Readings:** Temperature, humidity, or pressure readings collected from sensors at regular intervals
* **Server Metrics:** CPU usage, memory consumption, or network traffic measured over time
* **Financial Data:** Stock prices, trading volumes, or currency exchange rates tracked throughout trading sessions
* **Weather Data:** Temperature, precipitation, or wind speed measurements collected hourly or daily
* **Application Performance:** Request rates, response times, or error counts in web applications

### Why Use a Time Series Database?

InfluxDB is optimized for handling the unique characteristics of time series data and offers specialized benefits:

High Ingest Rates

Optimized to write millions of data points per second

Time-Based Queries

Efficient access to data by time ranges

Data Compression

Efficient historical data storage

Retention Policies

Automated data lifecycle and expiration

Key Time Series Concepts

**Tags**Metadata used for indexing and filtering (e.g., server name, region)

**Fields**The actual values being measured (e.g., usage_percent, degrees_celsius)

**Timestamps**When each data point was recorded, typically in nanosecond precision


### Introduction to InfluxDB 3

InfluxDB 3 is a purpose-built time series database optimized for high-throughput ingest, compression, and real-time querying of time series data.

#### Key InfluxDB 3 Advantages:

* **Performance:** Optimized for time series workloads with high ingest rates and fast queries
* **Scalability:** Designed to scale horizontally across multiple nodes
* **SQL Support:** Familiar SQL syntax for queries with time-specific extensions
* **Flexible Storage:** Options for in-memory, local, and cloud object storage
* **Unlimited Cardinality:** Store highly variable metadata without hurting performance
* **Processing Engine:** Take action on your incoming data

### InfluxDB Data Model

InfluxDB doesn't require a pre-defined schema. You can start writing data immediately using a simple format called Line Protocol.

Line Protocol

InfluxDB's Line Protocol format is a simple, text-based format designed for both machine generation and human readability.

Line Protocol Format:

table,tag_key=tag_value field_key=field_value timestamp

#### Sample Data Point:

cpu,host=server01,region=us-west usage_idle=95.5,usage_user=2.3 1617096263000000000

Table:

cpu

Tags:

host=server01, region=us-west

Fields:

usage_idle=95.5, usage_user=2.3

Timestamp:

1617096263000000000 (nanoseconds)

Ingestion Options

InfluxDB provides a number of ways to generate and write line protocol to InfluxDB:

Telegraf by InfluxData

Use Telegraf and its 300+ plug-ins to collect data from common sources and write it to InfluxDB

REST API and Client Libraries (SDKs)

Use the InfluxDB REST API and client libraries to programmatically write data to InfluxDB

### InfluxDB 3 Core Concepts & Terminology

Time Series Data Structure

Time series data has a specific structure in InfluxDB:

**Tables**Tables (formerly known as "measurements") help you organize data by topic (e.g., cpu, memory, temperature).

**Tags**Metadata for your time series that are indexed for fast querying (e.g., host, region, sensor_id).

**Fields**The actual measured values (e.g., temperature, CPU usage, voltage).

**Timestamp**When the measurement was recorded, with up to nanosecond precision.

Data Organization

Similar to a relational database, InfluxDB 3 organizes data by database name. A database contains tables and each table consists of columns for tags, fields, and timestamps.

Authentication

InfluxDB uses token-based authentication:

* API tokens provide secure access
* Permissions can be set per database
* Admin tokens for system management
* Read-only or read-write permissions

SQL Querying

InfluxDB 3 uses SQL with time extensions:

SELECT * FROM "cpu" WHERE time > now() - interval '1 hour' AND "host" = 'server01'

Processing Engine (PE)

Use PE Plugins to do things like:

* Transform Data
* Setup Automated Alerts
* Trigger actions based on data values
* Use Community Plug-Ins or create your own

Visualization

Multiple options for data visualization:

* Use Visualization Tools like Grafana
* Create custom applications via APIs
* Use the Query Data function in this app
* Use familiar tools like Plotly
