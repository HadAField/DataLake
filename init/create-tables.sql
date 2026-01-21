-- Create schema for security logs
CREATE SCHEMA IF NOT EXISTS hive.security
WITH (location = 's3a://security-logs/');

-- Create external table for ECS events from UDM Pro
CREATE TABLE IF NOT EXISTS hive.security.udm_events (
    "@timestamp" VARCHAR,
    message VARCHAR,
    ecs ROW(version VARCHAR),
    event ROW(
        kind VARCHAR,
        module VARCHAR,
        category ARRAY(VARCHAR),
        action VARCHAR,
        ingested VARCHAR
    ),
    host ROW(
        name VARCHAR,
        ip VARCHAR
    ),
    source ROW(
        ip VARCHAR,
        port INTEGER
    ),
    destination ROW(
        ip VARCHAR,
        port INTEGER
    ),
    observer ROW(
        vendor VARCHAR,
        product VARCHAR,
        type VARCHAR
    ),
    log ROW(
        level VARCHAR,
        original VARCHAR,
        syslog ROW(
            facility ROW(code INTEGER),
            severity ROW(code INTEGER),
            priority INTEGER
        )
    ),
    year VARCHAR,
    month VARCHAR,
    day VARCHAR
)
WITH (
    external_location = 's3a://security-logs/ecs_events/source=udm/',
    format = 'JSON',
    partitioned_by = ARRAY['year', 'month', 'day']
);

-- Create external table for Docker container logs
CREATE TABLE IF NOT EXISTS hive.security.docker_events (
    "@timestamp" VARCHAR,
    message VARCHAR,
    ecs ROW(version VARCHAR),
    event ROW(
        kind VARCHAR,
        module VARCHAR,
        category ARRAY(VARCHAR),
        ingested VARCHAR
    ),
    container ROW(
        id VARCHAR,
        name VARCHAR,
        image ROW(name VARCHAR)
    ),
    host ROW(name VARCHAR),
    log ROW(level VARCHAR),
    error ROW(message VARCHAR),
    labels MAP(VARCHAR, VARCHAR),
    year VARCHAR,
    month VARCHAR,
    day VARCHAR
)
WITH (
    external_location = 's3a://security-logs/ecs_events/source=docker/',
    format = 'JSON',
    partitioned_by = ARRAY['year', 'month', 'day']
);

-- Sync partitions (run after data is ingested)
-- CALL system.sync_partition_metadata('security', 'udm_events', 'FULL');
-- CALL system.sync_partition_metadata('security', 'docker_events', 'FULL');

-- Example queries:
-- SELECT * FROM hive.security.udm_events LIMIT 10;
-- SELECT * FROM hive.security.docker_events LIMIT 10;
-- SELECT event.action, COUNT(*) FROM hive.security.udm_events GROUP BY event.action;
