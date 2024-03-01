SELECT
  nb.mapname::text as neighborhood_name,
  COUNT(bs.stop_id)- COUNT(CASE WHEN bs.wheelchair_boarding = 1 THEN 1 END)::integer as num_bus_stops_inaccessible,
  COUNT(CASE WHEN bs.wheelchair_boarding = 1 THEN 1 END)::integer as num_bus_stops_accessible,
  CASE 
        WHEN COUNT(bs.stop_id) > 0 THEN 
            CAST(COUNT(CASE WHEN bs.wheelchair_boarding = 1 THEN 1 END) AS FLOAT) / COUNT(bs.stop_id) 
        ELSE 
            0 
    END AS accessibility_metric
FROM
  azavea.neighborhoods as nb
LEFT JOIN
  septa.bus_stops bs ON ST_Contains(nb.geog::geometry, bs.geog::geometry)
GROUP BY
  nb.mapname
ORDER BY
  accessibility_metric
LIMIT 5;