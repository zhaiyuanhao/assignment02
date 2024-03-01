SELECT
  nb.mapname::text as neighbor_name,
  COUNT(bs.stop_id)::integer as total_bus_stops,
  COUNT(CASE WHEN bs.wheelchair_boarding = 1 THEN 1 END)::integer as bus_stops_wheelchairs_friendly,
  CASE 
        WHEN COUNT(bs.stop_id) > 0 THEN 
            CAST(COUNT(CASE WHEN bs.wheelchair_boarding = 1 THEN 1 END) AS FLOAT) / COUNT(bs.stop_id) 
        ELSE 
            0 
    END AS percentage_wheelchairs,
  MAX(nb.geog::geometry)::geography as neighbor_geog
FROM
  azavea.neighborhoods as nb
LEFT JOIN
  septa.bus_stops bs ON ST_Contains(nb.geog::geometry, bs.geog::geometry)
GROUP BY
  nb.mapname
ORDER BY
  percentage_wheelchairs