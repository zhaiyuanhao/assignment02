SELECT
    br.route_id AS route_short_name,
	bt.trip_headsign,
    sp.shape_geog,
    ST_Length(sp.shape_geog::geography) AS shape_length
FROM
    (SELECT 
        shape_id, 
        ST_MakeLine(array_agg(
            ST_SetSRID(ST_MakePoint(shape_pt_lon, shape_pt_lat), 4326) 
            ORDER BY shape_pt_sequence
        )) AS shape_geog
    FROM 
        septa.bus_shapes
    GROUP BY 
        shape_id
    ) AS sp
JOIN
    (SELECT
	shape_id,
	MAX(trip_headsign) as trip_headsign,
	MAX(route_id) as route_id
	FROM
	septa.bus_trips
	GROUP BY
	shape_id) AS bt ON sp.shape_id = bt.shape_id
JOIN
septa.bus_routes br ON br.route_id = bt.route_id
ORDER BY 
    shape_length desc
LIMIT 2;