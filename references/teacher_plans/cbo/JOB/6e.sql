== Physical Plan ==
AdaptiveSparkPlan (26)
+- SortAggregate (25)
   +- Exchange (24)
      +- SortAggregate (23)
         +- Project (22)
            +- BroadcastHashJoin Inner BuildLeft (21)
               :- BroadcastExchange (18)
               :  +- Project (17)
               :     +- BroadcastHashJoin Inner BuildLeft (16)
               :        :- BroadcastExchange (13)
               :        :  +- BroadcastHashJoin Inner BuildLeft (12)
               :        :     :- BroadcastExchange (8)
               :        :     :  +- Project (7)
               :        :     :     +- BroadcastHashJoin Inner BuildRight (6)
               :        :     :        :- Filter (2)
               :        :     :        :  +- Scan parquet spark_catalog.imdb_10x.movie_keyword (1)
               :        :     :        +- BroadcastExchange (5)
               :        :     :           +- Filter (4)
               :        :     :              +- Scan parquet spark_catalog.imdb_10x.keyword (3)
               :        :     +- Project (11)
               :        :        +- Filter (10)
               :        :           +- Scan parquet spark_catalog.imdb_10x.title (9)
               :        +- Filter (15)
               :           +- Scan parquet spark_catalog.imdb_10x.cast_info (14)
               +- Filter (20)
                  +- Scan parquet spark_catalog.imdb_10x.name (19)


(1) Scan parquet spark_catalog.imdb_10x.movie_keyword
Output [2]: [movie_id#116, keyword_id#117]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_keyword]
PushedFilters: [IsNotNull(movie_id), IsNotNull(keyword_id)]
ReadSchema: struct<movie_id:int,keyword_id:int>

(2) Filter
Input [2]: [movie_id#116, keyword_id#117]
Condition : (isnotnull(movie_id#116) AND isnotnull(keyword_id#117))

(3) Scan parquet spark_catalog.imdb_10x.keyword
Output [2]: [id#110, keyword#111]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/keyword]
PushedFilters: [IsNotNull(keyword), EqualTo(keyword,marvel-cinematic-universe), IsNotNull(id)]
ReadSchema: struct<id:int,keyword:string>

(4) Filter
Input [2]: [id#110, keyword#111]
Condition : ((isnotnull(keyword#111) AND (keyword#111 = marvel-cinematic-universe)) AND isnotnull(id#110))

(5) BroadcastExchange
Input [2]: [id#110, keyword#111]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, false] as bigint)),false), [plan_id=34365]

(6) BroadcastHashJoin
Left keys [1]: [keyword_id#117]
Right keys [1]: [id#110]
Join type: Inner
Join condition: None

(7) Project
Output [2]: [movie_id#116, keyword#111]
Input [4]: [movie_id#116, keyword_id#117, id#110, keyword#111]

(8) BroadcastExchange
Input [2]: [movie_id#116, keyword#111]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=34369]

(9) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#39, title#40, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(10) Filter
Input [3]: [id#39, title#40, production_year#43]
Condition : ((isnotnull(production_year#43) AND (cast(production_year#43 as int) > 2000)) AND isnotnull(id#39))

(11) Project
Output [2]: [id#39, title#40]
Input [3]: [id#39, title#40, production_year#43]

(12) BroadcastHashJoin
Left keys [1]: [movie_id#116]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(13) BroadcastExchange
Input [4]: [movie_id#116, keyword#111, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[2, int, true] as bigint) & 4294967295))),false), [plan_id=34372]

(14) Scan parquet spark_catalog.imdb_10x.cast_info
Output [2]: [person_id#17, movie_id#18]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/cast_info]
PushedFilters: [IsNotNull(movie_id), IsNotNull(person_id)]
ReadSchema: struct<person_id:int,movie_id:int>

(15) Filter
Input [2]: [person_id#17, movie_id#18]
Condition : (isnotnull(movie_id#18) AND isnotnull(person_id#17))

(16) BroadcastHashJoin
Left keys [2]: [movie_id#116, id#39]
Right keys [2]: [movie_id#18, movie_id#18]
Join type: Inner
Join condition: None

(17) Project
Output [3]: [keyword#111, title#40, person_id#17]
Input [6]: [movie_id#116, keyword#111, id#39, title#40, person_id#17, movie_id#18]

(18) BroadcastExchange
Input [3]: [keyword#111, title#40, person_id#17]
Arguments: HashedRelationBroadcastMode(List(cast(input[2, int, true] as bigint)),false), [plan_id=34376]

(19) Scan parquet spark_catalog.imdb_10x.name
Output [2]: [id#540, name#541]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/name]
PushedFilters: [IsNotNull(name), IsNotNull(id)]
ReadSchema: struct<id:int,name:string>

(20) Filter
Input [2]: [id#540, name#541]
Condition : ((isnotnull(name#541) AND name#541 LIKE %Downey%Robert%) AND isnotnull(id#540))

(21) BroadcastHashJoin
Left keys [1]: [person_id#17]
Right keys [1]: [id#540]
Join type: Inner
Join condition: None

(22) Project
Output [3]: [keyword#111, name#541, title#40]
Input [5]: [keyword#111, title#40, person_id#17, id#540, name#541]

(23) SortAggregate
Input [3]: [keyword#111, name#541, title#40]
Keys: []
Functions [3]: [partial_min(keyword#111), partial_min(name#541), partial_min(title#40)]
Aggregate Attributes [3]: [min#2369, min#2370, min#2371]
Results [3]: [min#2372, min#2373, min#2374]

(24) Exchange
Input [3]: [min#2372, min#2373, min#2374]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=34381]

(25) SortAggregate
Input [3]: [min#2372, min#2373, min#2374]
Keys: []
Functions [3]: [min(keyword#111), min(name#541), min(title#40)]
Aggregate Attributes [3]: [min(keyword#111)#2366, min(name#541)#2367, min(title#40)#2368]
Results [3]: [min(keyword#111)#2366 AS movie_keyword#2358, min(name#541)#2367 AS actor_name#2359, min(title#40)#2368 AS marvel_movie#2360]

(26) AdaptiveSparkPlan
Output [3]: [movie_keyword#2358, actor_name#2359, marvel_movie#2360]
Arguments: isFinalPlan=false
Execution Time: 15.432
