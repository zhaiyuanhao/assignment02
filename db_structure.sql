create schema if not exists septa;
create schema if not exists phl;
create schema if not exists census;

alter table septa_bus_stops
add column if not exists geog geography;

update septa_bus_stops
set geog = st_makepoint(stop_lon, stop_lat)::geography;

create index if not exists septa_bus_stops__geog__idx
on septa_bus_stops using gist
(geog);
