CREATE EXTERNAL TABLE IF NOT EXISTS analytics_events (

  schemaVersion bigint,
  event string,
  timestamp bigint,
  receivedAt string,
  sourceIp string,

  photoId string,
  country string,
  source string,

  `from` string,
  `to` string,

  overlay string

)

PARTITIONED BY (

  year string,
  month string,
  day string,
  event_partition string

)

ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'

LOCATION 's3://${analytics_bucket}/'

TBLPROPERTIES (
  'projection.enabled'='false'
);