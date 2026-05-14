CREATE EXTERNAL TABLE IF NOT EXISTS analytics_events (

  schemaVersion bigint,
  event string,
  timestamp bigint,

  receivedAt string,
  sourceIp string,
  userAgent string,

  deviceType string,
  viewportWidth bigint,
  viewportHeight bigint,
  orientation string,
  browserLanguage string,

  photoId string,
  country string,
  source string,

  previousLanguage string,
  selectedLanguage string,

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