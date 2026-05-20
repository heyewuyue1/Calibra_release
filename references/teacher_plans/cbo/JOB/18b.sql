== Physical Plan ==
AdaptiveSparkPlan (40)
+- SortAggregate (39)
   +- Exchange (38)
      +- SortAggregate (37)
         +- Project (36)
            +- BroadcastHashJoin Inner BuildRight (35)
               :- Project (24)
               :  +- BroadcastHashJoin Inner BuildRight (23)
               :     :- BroadcastHashJoin Inner BuildLeft (18)
               :     :  :- BroadcastExchange (15)
               :     :  :  +- BroadcastHashJoin Inner BuildLeft (14)
               :     :  :     :- BroadcastExchange (10)
               :     :  :     :  +- Project (9)
               :     :  :     :     +- BroadcastHashJoin Inner BuildRight (8)
               :     :  :     :        :- Project (3)
               :     :  :     :        :  +- Filter (2)
               :     :  :     :        :     +- Scan parquet spark_catalog.imdb_10x.movie_info (1)
               :     :  :     :        +- BroadcastExchange (7)
               :     :  :     :           +- Project (6)
               :     :  :     :              +- Filter (5)
               :     :  :     :                 +- Scan parquet spark_catalog.imdb_10x.info_type (4)
               :     :  :     +- Project (13)
               :     :  :        +- Filter (12)
               :     :  :           +- Scan parquet spark_catalog.imdb_10x.title (11)
               :     :  +- Filter (17)
               :     :     +- Scan parquet spark_catalog.imdb_10x.movie_info_idx (16)
               :     +- BroadcastExchange (22)
               :        +- Project (21)
               :           +- Filter (20)
               :              +- Scan parquet spark_catalog.imdb_10x.info_type (19)
               +- BroadcastExchange (34)
                  +- Project (33)
                     +- BroadcastHashJoin Inner BuildLeft (32)
                        :- BroadcastExchange (28)
                        :  +- Project (27)
                        :     +- Filter (26)
                        :        +- Scan parquet spark_catalog.imdb_10x.cast_info (25)
                        +- Project (31)
                           +- Filter (30)
                              +- Scan parquet spark_catalog.imdb_10x.name (29)


(1) Scan parquet spark_catalog.imdb_10x.movie_info
Output [4]: [movie_id#213, info_type_id#214, info#215, note#216]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [In(info, [Horror,Thriller]), IsNull(note), IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string,note:string>

(2) Filter
Input [4]: [movie_id#213, info_type_id#214, info#215, note#216]
Condition : (((info#215 IN (Horror,Thriller) AND isnull(note#216)) AND isnotnull(movie_id#213)) AND isnotnull(info_type_id#214))

(3) Project
Output [3]: [movie_id#213, info_type_id#214, info#215]
Input [4]: [movie_id#213, info_type_id#214, info#215, note#216]

(4) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#210, info#211]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,genres), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(5) Filter
Input [2]: [id#210, info#211]
Condition : ((isnotnull(info#211) AND (info#211 = genres)) AND isnotnull(id#210))

(6) Project
Output [1]: [id#210]
Input [2]: [id#210, info#211]

(7) BroadcastExchange
Input [1]: [id#210]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=10167]

(8) BroadcastHashJoin
Left keys [1]: [info_type_id#214]
Right keys [1]: [id#210]
Join type: Inner
Join condition: None

(9) Project
Output [2]: [movie_id#213, info#215]
Input [4]: [movie_id#213, info_type_id#214, info#215, id#210]

(10) BroadcastExchange
Input [2]: [movie_id#213, info#215]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=10171]

(11) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#39, title#40, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(12) Filter
Input [3]: [id#39, title#40, production_year#43]
Condition : (((isnotnull(production_year#43) AND (cast(production_year#43 as int) >= 2008)) AND (cast(production_year#43 as int) <= 2014)) AND isnotnull(id#39))

(13) Project
Output [2]: [id#39, title#40]
Input [3]: [id#39, title#40, production_year#43]

(14) BroadcastHashJoin
Left keys [1]: [movie_id#213]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(15) BroadcastExchange
Input [4]: [movie_id#213, info#215, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[2, int, true] as bigint) & 4294967295))),false), [plan_id=10174]

(16) Scan parquet spark_catalog.imdb_10x.movie_info_idx
Output [3]: [movie_id#218, info_type_id#219, info#220]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info_idx]
PushedFilters: [IsNotNull(info), GreaterThan(info,8.0), IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(17) Filter
Input [3]: [movie_id#218, info_type_id#219, info#220]
Condition : (((isnotnull(info#220) AND (info#220 > 8.0)) AND isnotnull(movie_id#218)) AND isnotnull(info_type_id#219))

(18) BroadcastHashJoin
Left keys [2]: [movie_id#213, id#39]
Right keys [2]: [movie_id#218, movie_id#218]
Join type: Inner
Join condition: None

(19) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#728, info#729]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,rating), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(20) Filter
Input [2]: [id#728, info#729]
Condition : ((isnotnull(info#729) AND (info#729 = rating)) AND isnotnull(id#728))

(21) Project
Output [1]: [id#728]
Input [2]: [id#728, info#729]

(22) BroadcastExchange
Input [1]: [id#728]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=10177]

(23) BroadcastHashJoin
Left keys [1]: [info_type_id#219]
Right keys [1]: [id#728]
Join type: Inner
Join condition: None

(24) Project
Output [6]: [movie_id#213, info#215, id#39, title#40, movie_id#218, info#220]
Input [8]: [movie_id#213, info#215, id#39, title#40, movie_id#218, info_type_id#219, info#220, id#728]

(25) Scan parquet spark_catalog.imdb_10x.cast_info
Output [3]: [person_id#17, movie_id#18, note#20]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/cast_info]
PushedFilters: [In(note, [(head writer),(story editor),(story),(writer),(written by)]), IsNotNull(movie_id), IsNotNull(person_id)]
ReadSchema: struct<person_id:int,movie_id:int,note:string>

(26) Filter
Input [3]: [person_id#17, movie_id#18, note#20]
Condition : ((note#20 IN ((writer),(head writer),(written by),(story),(story editor)) AND isnotnull(movie_id#18)) AND isnotnull(person_id#17))

(27) Project
Output [2]: [person_id#17, movie_id#18]
Input [3]: [person_id#17, movie_id#18, note#20]

(28) BroadcastExchange
Input [2]: [person_id#17, movie_id#18]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=10180]

(29) Scan parquet spark_catalog.imdb_10x.name
Output [2]: [id#540, gender#544]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/name]
PushedFilters: [IsNotNull(gender), EqualTo(gender,f), IsNotNull(id)]
ReadSchema: struct<id:int,gender:string>

(30) Filter
Input [2]: [id#540, gender#544]
Condition : ((isnotnull(gender#544) AND (gender#544 = f)) AND isnotnull(id#540))

(31) Project
Output [1]: [id#540]
Input [2]: [id#540, gender#544]

(32) BroadcastHashJoin
Left keys [1]: [person_id#17]
Right keys [1]: [id#540]
Join type: Inner
Join condition: None

(33) Project
Output [1]: [movie_id#18]
Input [3]: [person_id#17, movie_id#18, id#540]

(34) BroadcastExchange
Input [1]: [movie_id#18]
Arguments: HashedRelationBroadcastMode(List(input[0, int, true], input[0, int, true], input[0, int, true]),false), [plan_id=10184]

(35) BroadcastHashJoin
Left keys [3]: [movie_id#213, movie_id#218, id#39]
Right keys [3]: [movie_id#18, movie_id#18, movie_id#18]
Join type: Inner
Join condition: None

(36) Project
Output [3]: [info#215, info#220, title#40]
Input [7]: [movie_id#213, info#215, id#39, title#40, movie_id#218, info#220, movie_id#18]

(37) SortAggregate
Input [3]: [info#215, info#220, title#40]
Keys: []
Functions [3]: [partial_min(info#215), partial_min(info#220), partial_min(title#40)]
Aggregate Attributes [3]: [min#734, min#735, min#736]
Results [3]: [min#737, min#738, min#739]

(38) Exchange
Input [3]: [min#737, min#738, min#739]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=10189]

(39) SortAggregate
Input [3]: [min#737, min#738, min#739]
Keys: []
Functions [3]: [min(info#215), min(info#220), min(title#40)]
Aggregate Attributes [3]: [min(info#215)#731, min(info#220)#732, min(title#40)#733]
Results [3]: [min(info#215)#731 AS movie_budget#720, min(info#220)#732 AS movie_votes#721, min(title#40)#733 AS movie_title#722]

(40) AdaptiveSparkPlan
Output [3]: [movie_budget#720, movie_votes#721, movie_title#722]
Arguments: isFinalPlan=false
Execution Time: 27.758
