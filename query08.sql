with

penn_building as (
    select
    tencode,    
	address,
    geog
    from 
	phl.pwd_parcels
	WHERE
	owner1 LIKE 'UNIVERSITY CITY'
	OR
	owner1 LIKE 'UNIVERSITY OF PENN%'
)

SELECT
COUNT(bg.geoid) as count_block_groups
FROM 
census.blockgroups_2020 as bg
JOIN
penn_building as pb
ON
ST_Contains(bg.geog::geometry, pb.geog::geometry)