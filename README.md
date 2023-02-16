# Part2

Write a query to answer each of the questions below.
* Your queries should produce results in the format specified.
* Write your query in a SQL file corresponding to the question number (e.g. a file named _query06.sql_ for the answer to question #6).
* Each SQL file should contain a single `SELECT` query.
* Any SQL that does things other than retrieve data (e.g. SQL that creates indexes or update columns) should be in the _db_structure.sql_ file.
* Some questions include a request for you to discuss your methods. Update this README file with your answers in the appropriate place.

There are several datasets that are prescribed for you to use in this part. Your datasets should be named:
  * `septa.bus_stops` ([SEPTA GTFS](http://www3.septa.org/developer/))
  * `septa.bus_shapes` ([SEPTA GTFS](http://www3.septa.org/developer/))
  * `septa.rail_stops` ([SEPTA GTFS](http://www3.septa.org/developer/))
  * `phl.pwd_parcels` ([OpenDataPhilly](https://opendataphilly.org/dataset/pwd-stormwater-billing-parcels))
  * `census.block_groups_2020` ([Census TIGER FTP](https://www2.census.gov/geo/tiger/TIGER2020/BG/) -- Each state has it's own file; Use file number `42` for PA)
    * Load into the database would use parameters like these:
      ```bash
      ogr2ogr \
        -f "PostgreSQL" \
        PG:"host=localhost user=postgres dbname=musa_509_spring2023 port=5434 password=postgres" \
        -nln "census.block_groups_2020" \
        -nlt MULTIPOLYGON \
        -overwrite \
        -lco GEOMETRY_NAME=geog \
        -lco GEOM_TYPE=geography \
        "./data/tl_2020_42_bg.shp"
      ```
  * `census.population_2020` ([Census Explorer](https://data.census.gov/table?t=Populations+and+People&g=0500000US42101$1500000&y=2020&d=DEC+Redistricting+Data+(PL+94-171)&tid=DECENNIALPL2020.P1))  
    Fields:
      * `geoid TEXT`
      * `geoname TEXT`
      * `total_pop INTEGER`



**Note, when tests aren't passing, I do take logic for solving problems into account when grading. When in doubt, write your thinking for solving the problem even if you aren't able to get a full response.**

## Questions

1.  Which bus stop has the largest population within 800 meters? As a rough estimation, consider any block group that intersects the buffer as being part of the 800 meter buffer.

2.  Which bus stop has the smallest population within 800 meters _inside of Philadelphia_ (Philadelphia county block groups have a geoid prefix of `42101`?

    **The queries to #1 & #2 should generate results with a single row, with the following structure:**

    ```sql
    (
        stop_name text, -- The name of the station
        estimated_pop_800m integer, -- The population within 800 meters
        geog geography -- The geography of the bus stop
    )
    ```

3.  Using the Philadelphia Water Department Stormwater Billing Parcels dataset, pair each parcel with its closest bus stop. The final result should give the parcel address, bus stop name, and distance apart in meters. Order by distance (largest on top).

    _Your query should run in under two minutes._

    **Structure:**
    ```sql
    (
        address text,  -- The address of the parcel
        stop_name text,  -- The name of the bus stop
        distance double precision  -- The distance apart in meters
    )
    ```

4.  Using the _shapes.txt_ file from GTFS bus feed, find the **two** routes with the longest trips. In the final query, give the `trip_headsign` that corresponds to the `shape_id` of this route and the length of the trip.

    _HINT: The `ST_MakeLine` function is useful here. You can see an example of how you could use it at [this MobilityData walkthrough](https://docs.mobilitydb.com/MobilityDB-workshop/master/ch04.html#:~:text=INSERT%20INTO%20shape_geoms) on using GTFS data. If you find other good examples, please share them in Slack._

    **Structure:**
    ```sql
    (
        trip_headsign text,  -- Headsign of the trip
        trip_length double precision  -- Length of the trip in meters
    )
    ```

5.  Rate neighborhoods by their bus stop accessibility for wheelchairs. Use Azavea's neighborhood dataset from OpenDataPhilly along with an appropriate dataset from the Septa GTFS bus feed. Use the [GTFS documentation](https://gtfs.org/reference/static/) for help. Use some creativity in the metric you devise in rating neighborhoods.

    _NOTE: There is no automated test for this question, as there's no one right answer. With urban data analysis, this is frequently the case._

    Discuss your accessibility metric and how you arrived at it below:

    **Description:**

6.  What are the _top five_ neighborhoods according to your accessibility metric?

7.  What are the _bottom five_ neighborhoods according to your accessibility metric?

    **Both #6 and #7 should have the structure:**
    ```sql
    (
      neighborhood_name text,  -- The name of the neighborhood
      accessibility_metric ...,  -- Your accessibility metric value
      num_bus_stops_accessible integer,
      num_bus_stops_inaccessible integer
    )
    ```

8.  With a query, find out how many census block groups Penn's main campus fully contains. Discuss which dataset you chose for defining Penn's campus.

    **Structure (should be a single value):**
    ```sql
    (
        count_block_groups integer
    )
    ```

    **Discussion:**

9. With a query involving PWD parcels and census block groups, find the `geo_id` of the block group that contains Meyerson Hall. `ST_MakePoint()` and functions like that are not allowed.

    **Structure (should be a single value):**
    ```sql
    (
        geo_id text
    )
    ```

10. You're tasked with giving more contextual information to rail stops to fill the `stop_desc` field in a GTFS feed. Using any of the data sets above, PostGIS functions (e.g., `ST_Distance`, `ST_Azimuth`, etc.), and PostgreSQL string functions, build a description (alias as `stop_desc`) for each stop. Feel free to supplement with other datasets (must provide link to data used so it's reproducible), and other methods of describing the relationships. SQL's `CASE` statements may be helpful for some operations.

    **Structure:**
    ```sql
    (
        stop_id integer,
        stop_name text,
        stop_desc text,
        stop_lon double precision,
        stop_lat double precision
    )
    ```

   As an example, your `stop_desc` for a station stop may be something like "37 meters NE of 1234 Market St" (that's only an example, feel free to be creative, silly, descriptive, etc.)

   **Tip when experimenting:** Use subqueries to limit your query to just a few rows to keep query times faster. Once your query is giving you answers you want, scale it up. E.g., instead of `FROM tablename`, use `FROM (SELECT * FROM tablename limit 10) as t`.
