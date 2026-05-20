== Physical Plan ==
AdaptiveSparkPlan (45)
+- SortAggregate (44)
   +- Exchange (43)
      +- SortAggregate (42)
         +- Project (41)
            +- BroadcastHashJoin Inner BuildRight (40)
               :- Project (30)
               :  +- BroadcastHashJoin Inner BuildRight (29)
               :     :- BroadcastHashJoin Inner BuildLeft (24)
               :     :  :- BroadcastExchange (21)
               :     :  :  +- Project (20)
               :     :  :     +- BroadcastHashJoin Inner BuildRight (19)
               :     :  :        :- BroadcastHashJoin Inner BuildLeft (14)
               :     :  :        :  :- BroadcastExchange (10)
               :     :  :        :  :  +- Project (9)
               :     :  :        :  :     +- BroadcastHashJoin Inner BuildLeft (8)
               :     :  :        :  :        :- BroadcastExchange (4)
               :     :  :        :  :        :  +- Project (3)
               :     :  :        :  :        :     +- Filter (2)
               :     :  :        :  :        :        +- Scan parquet spark_catalog.imdb_10x.info_type (1)
               :     :  :        :  :        +- Project (7)
               :     :  :        :  :           +- Filter (6)
               :     :  :        :  :              +- Scan parquet spark_catalog.imdb_10x.movie_info (5)
               :     :  :        :  +- Project (13)
               :     :  :        :     +- Filter (12)
               :     :  :        :        +- Scan parquet spark_catalog.imdb_10x.title (11)
               :     :  :        +- BroadcastExchange (18)
               :     :  :           +- Project (17)
               :     :  :              +- Filter (16)
               :     :  :                 +- Scan parquet spark_catalog.imdb_10x.kind_type (15)
               :     :  +- Filter (23)
               :     :     +- Scan parquet spark_catalog.imdb_10x.movie_info_idx (22)
               :     +- BroadcastExchange (28)
               :        +- Project (27)
               :           +- Filter (26)
               :              +- Scan parquet spark_catalog.imdb_10x.info_type (25)
               +- BroadcastExchange (39)
                  +- Project (38)
                     +- BroadcastHashJoin Inner BuildRight (37)
                        :- Filter (32)
                        :  +- Scan parquet spark_catalog.imdb_10x.movie_keyword (31)
                        +- BroadcastExchange (36)
                           +- Project (35)
                              +- Filter (34)
                                 +- Scan parquet spark_catalog.imdb_10x.keyword (33)


(1) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#210, info#211]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,countries), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(2) Filter
Input [2]: [id#210, info#211]
Condition : ((isnotnull(info#211) AND (info#211 = countries)) AND isnotnull(id#210))

(3) Project
Output [1]: [id#210]
Input [2]: [id#210, info#211]

(4) BroadcastExchange
Input [1]: [id#210]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=4733]

(5) Scan parquet spark_catalog.imdb_10x.movie_info
Output [3]: [movie_id#213, info_type_id#214, info#215]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [In(info, [American,Denish,Denmark,German,Germany,Norway,Norwegian,Sweden,Swedish,USA]), IsNotNull(info_type_id), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(6) Filter
Input [3]: [movie_id#213, info_type_id#214, info#215]
Condition : ((info#215 IN (Sweden,Norway,Germany,Denmark,Swedish,Denish,Norwegian,German,USA,American) AND isnotnull(info_type_id#214)) AND isnotnull(movie_id#213))

(7) Project
Output [2]: [movie_id#213, info_type_id#214]
Input [3]: [movie_id#213, info_type_id#214, info#215]

(8) BroadcastHashJoin
Left keys [1]: [id#210]
Right keys [1]: [info_type_id#214]
Join type: Inner
Join condition: None

(9) Project
Output [1]: [movie_id#213]
Input [3]: [id#210, movie_id#213, info_type_id#214]

(10) BroadcastExchange
Input [1]: [movie_id#213]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=4737]

(11) Scan parquet spark_catalog.imdb_10x.title
Output [4]: [id#39, title#40, kind_id#42, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id), IsNotNull(kind_id)]
ReadSchema: struct<id:int,title:string,kind_id:int,production_year:string>

(12) Filter
Input [4]: [id#39, title#40, kind_id#42, production_year#43]
Condition : (((isnotnull(production_year#43) AND (cast(production_year#43 as int) > 2010)) AND isnotnull(id#39)) AND isnotnull(kind_id#42))

(13) Project
Output [3]: [id#39, title#40, kind_id#42]
Input [4]: [id#39, title#40, kind_id#42, production_year#43]

(14) BroadcastHashJoin
Left keys [1]: [movie_id#213]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(15) Scan parquet spark_catalog.imdb_10x.kind_type
Output [2]: [id#293, kind#294]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/kind_type]
PushedFilters: [IsNotNull(kind), EqualTo(kind,movie), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(16) Filter
Input [2]: [id#293, kind#294]
Condition : ((isnotnull(kind#294) AND (kind#294 = movie)) AND isnotnull(id#293))

(17) Project
Output [1]: [id#293]
Input [2]: [id#293, kind#294]

(18) BroadcastExchange
Input [1]: [id#293]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=4740]

(19) BroadcastHashJoin
Left keys [1]: [kind_id#42]
Right keys [1]: [id#293]
Join type: Inner
Join condition: None

(20) Project
Output [3]: [movie_id#213, id#39, title#40]
Input [5]: [movie_id#213, id#39, title#40, kind_id#42, id#293]

(21) BroadcastExchange
Input [3]: [movie_id#213, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[1, int, true] as bigint) & 4294967295))),false), [plan_id=4744]

(22) Scan parquet spark_catalog.imdb_10x.movie_info_idx
Output [3]: [movie_id#218, info_type_id#219, info#220]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info_idx]
PushedFilters: [IsNotNull(info), LessThan(info,8.5), IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(23) Filter
Input [3]: [movie_id#218, info_type_id#219, info#220]
Condition : (((isnotnull(info#220) AND (info#220 < 8.5)) AND isnotnull(movie_id#218)) AND isnotnull(info_type_id#219))

(24) BroadcastHashJoin
Left keys [2]: [movie_id#213, id#39]
Right keys [2]: [movie_id#218, movie_id#218]
Join type: Inner
Join condition: None

(25) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#391, info#392]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,rating), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(26) Filter
Input [2]: [id#391, info#392]
Condition : ((isnotnull(info#392) AND (info#392 = rating)) AND isnotnull(id#391))

(27) Project
Output [1]: [id#391]
Input [2]: [id#391, info#392]

(28) BroadcastExchange
Input [1]: [id#391]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=4747]

(29) BroadcastHashJoin
Left keys [1]: [info_type_id#219]
Right keys [1]: [id#391]
Join type: Inner
Join condition: None

(30) Project
Output [5]: [movie_id#213, id#39, title#40, movie_id#218, info#220]
Input [7]: [movie_id#213, id#39, title#40, movie_id#218, info_type_id#219, info#220, id#391]

(31) Scan parquet spark_catalog.imdb_10x.movie_keyword
Output [2]: [movie_id#116, keyword_id#117]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_keyword]
PushedFilters: [IsNotNull(movie_id), IsNotNull(keyword_id)]
ReadSchema: struct<movie_id:int,keyword_id:int>

(32) Filter
Input [2]: [movie_id#116, keyword_id#117]
Condition : (isnotnull(movie_id#116) AND isnotnull(keyword_id#117))

(33) Scan parquet spark_catalog.imdb_10x.keyword
Output [2]: [id#110, keyword#111]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/keyword]
PushedFilters: [In(keyword, [blood,murder,murder-in-title,violence]), IsNotNull(id)]
ReadSchema: struct<id:int,keyword:string>

(34) Filter
Input [2]: [id#110, keyword#111]
Condition : (keyword#111 IN (murder,murder-in-title,blood,violence) AND isnotnull(id#110))

(35) Project
Output [1]: [id#110]
Input [2]: [id#110, keyword#111]

(36) BroadcastExchange
Input [1]: [id#110]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=4750]

(37) BroadcastHashJoin
Left keys [1]: [keyword_id#117]
Right keys [1]: [id#110]
Join type: Inner
Join condition: None

(38) Project
Output [1]: [movie_id#116]
Input [3]: [movie_id#116, keyword_id#117, id#110]

(39) BroadcastExchange
Input [1]: [movie_id#116]
Arguments: HashedRelationBroadcastMode(List(input[0, int, true], input[0, int, true], input[0, int, true]),false), [plan_id=4754]

(40) BroadcastHashJoin
Left keys [3]: [movie_id#213, movie_id#218, id#39]
Right keys [3]: [movie_id#116, movie_id#116, movie_id#116]
Join type: Inner
Join condition: None

(41) Project
Output [2]: [info#220, title#40]
Input [6]: [movie_id#213, id#39, title#40, movie_id#218, info#220, movie_id#116]

(42) SortAggregate
Input [2]: [info#220, title#40]
Keys: []
Functions [2]: [partial_min(info#220), partial_min(title#40)]
Aggregate Attributes [2]: [min#396, min#397]
Results [2]: [min#398, min#399]

(43) Exchange
Input [2]: [min#398, min#399]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=4759]

(44) SortAggregate
Input [2]: [min#398, min#399]
Keys: []
Functions [2]: [min(info#220), min(title#40)]
Aggregate Attributes [2]: [min(info#220)#394, min(title#40)#395]
Results [2]: [min(info#220)#394 AS rating#384, min(title#40)#395 AS northern_dark_movie#385]

(45) AdaptiveSparkPlan
Output [2]: [rating#384, northern_dark_movie#385]
Arguments: isFinalPlan=false
Execution Time: 24.084
