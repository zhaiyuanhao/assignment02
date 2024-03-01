UPDATE septa.rail_stops rs
SET stop_desc = (
    SELECT
        'The name of this stop is: ' || rs.stop_name || ', and we are closing to bus stop:' || 
        bs.stop_name || ', the distance is:' || ROUND(ST_Distance(ST_SetSRID(ST_MakePoint(rs.stop_lon, rs.stop_lat), 4326)::geography, ST_SetSRID(ST_MakePoint(bs.stop_lon, bs.stop_lat), 4326)::geography)::numeric, 2) || ' meters'
    FROM
        septa.bus_stops bs
    ORDER BY
        ST_SetSRID(ST_MakePoint(rs.stop_lon, rs.stop_lat), 4326) <-> ST_SetSRID(ST_MakePoint(bs.stop_lon, bs.stop_lat), 4326)
    LIMIT 1
)
WHERE EXISTS (
    SELECT 1
    FROM septa.bus_stops bs
    WHERE ST_Distance(ST_SetSRID(ST_MakePoint(rs.stop_lon, rs.stop_lat), 4326), ST_SetSRID(ST_MakePoint(bs.stop_lon, bs.stop_lat), 4326)) IS NOT NULL
);

SELECT
stop_id,
stop_name,
stop_desc,
stop_lon,
stop_lat
FROM
septa.rail_stops