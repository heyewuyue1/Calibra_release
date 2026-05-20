== Physical Plan ==
AdaptiveSparkPlan (45)
+- SortAggregate (44)
   +- Exchange (43)
      +- SortAggregate (42)
         +- Project (41)
            +- BroadcastHashJoin Inner BuildRight (40)
               :- Project (19)
               :  +- BroadcastHashJoin Inner BuildRight (18)
               :     :- BroadcastHashJoin Inner BuildLeft (13)
               :     :  :- BroadcastExchange (10)
               :     :  :  +- Project (9)
               :     :  :     +- BroadcastHashJoin Inner BuildLeft (8)
               :     :  :        :- BroadcastExchange (4)
               :     :  :        :  +- Project (3)
               :     :  :        :     +- Filter (2)
               :     :  :        :        +- Scan parquet spark_catalog.imdb_10x.info_type (1)
               :     :  :        +- Project (7)
               :     :  :           +- Filter (6)
               :     :  :              +- Scan parquet spark_catalog.imdb_10x.movie_info (5)
               :     :  +- Filter (12)
               :     :     +- Scan parquet spark_catalog.imdb_10x.movie_info_idx (11)
               :     +- BroadcastExchange (17)
               :        +- Project (16)
               :           +- Filter (15)
               :              +- Scan parquet spark_catalog.imdb_10x.info_type (14)
               +- BroadcastExchange (39)
                  +- Project (38)
                     +- BroadcastHashJoin Inner BuildRight (37)
                        :- BroadcastHashJoin Inner BuildLeft (32)
                        :  :- BroadcastExchange (28)
                        :  :  +- Project (27)
                        :  :     +- BroadcastHashJoin Inner BuildRight (26)
                        :  :        :- Filter (21)
                        :  :        :  +- Scan parquet spark_catalog.imdb_10x.movie_keyword (20)
                        :  :        +- BroadcastExchange (25)
                        :  :           +- Project (24)
                        :  :              +- Filter (23)
                        :  :                 +- Scan parquet spark_catalog.imdb_10x.keyword (22)
                        :  +- Project (31)
                        :     +- Filter (30)
                        :        +- Scan parquet spark_catalog.imdb_10x.title (29)
                        +- BroadcastExchange (36)
                           +- Project (35)
                              +- Filter (34)
                                 +- Scan parquet spark_catalog.imdb_10x.kind_type (33)


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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=5044]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=5048]

(11) Scan parquet spark_catalog.imdb_10x.movie_info_idx
Output [3]: [movie_id#218, info_type_id#219, info#220]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info_idx]
PushedFilters: [IsNotNull(info), GreaterThan(info,6.0), IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(12) Filter
Input [3]: [movie_id#218, info_type_id#219, info#220]
Condition : (((isnotnull(info#220) AND (info#220 > 6.0)) AND isnotnull(movie_id#218)) AND isnotnull(info_type_id#219))

(13) BroadcastHashJoin
Left keys [1]: [movie_id#213]
Right keys [1]: [movie_id#218]
Join type: Inner
Join condition: None

(14) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#411, info#412]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,rating), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(15) Filter
Input [2]: [id#411, info#412]
Condition : ((isnotnull(info#412) AND (info#412 = rating)) AND isnotnull(id#411))

(16) Project
Output [1]: [id#411]
Input [2]: [id#411, info#412]

(17) BroadcastExchange
Input [1]: [id#411]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=5051]

(18) BroadcastHashJoin
Left keys [1]: [info_type_id#219]
Right keys [1]: [id#411]
Join type: Inner
Join condition: None

(19) Project
Output [3]: [movie_id#213, movie_id#218, info#220]
Input [5]: [movie_id#213, movie_id#218, info_type_id#219, info#220, id#411]

(20) Scan parquet spark_catalog.imdb_10x.movie_keyword
Output [2]: [movie_id#116, keyword_id#117]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_keyword]
PushedFilters: [IsNotNull(movie_id), IsNotNull(keyword_id)]
ReadSchema: struct<movie_id:int,keyword_id:int>

(21) Filter
Input [2]: [movie_id#116, keyword_id#117]
Condition : (isnotnull(movie_id#116) AND isnotnull(keyword_id#117))

(22) Scan parquet spark_catalog.imdb_10x.keyword
Output [2]: [id#110, keyword#111]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/keyword]
PushedFilters: [In(keyword, [murder,murder-in-title]), IsNotNull(id)]
ReadSchema: struct<id:int,keyword:string>

(23) Filter
Input [2]: [id#110, keyword#111]
Condition : (keyword#111 IN (murder,murder-in-title) AND isnotnull(id#110))

(24) Project
Output [1]: [id#110]
Input [2]: [id#110, keyword#111]

(25) BroadcastExchange
Input [1]: [id#110]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=5054]

(26) BroadcastHashJoin
Left keys [1]: [keyword_id#117]
Right keys [1]: [id#110]
Join type: Inner
Join condition: None

(27) Project
Output [1]: [movie_id#116]
Input [3]: [movie_id#116, keyword_id#117, id#110]

(28) BroadcastExchange
Input [1]: [movie_id#116]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=5058]

(29) Scan parquet spark_catalog.imdb_10x.title
Output [4]: [id#39, title#40, kind_id#42, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), Or(Or(StringContains(title,murder),StringContains(title,Murder)),StringContains(title,Mord)), IsNotNull(id), IsNotNull(kind_id)]
ReadSchema: struct<id:int,title:string,kind_id:int,production_year:string>

(30) Filter
Input [4]: [id#39, title#40, kind_id#42, production_year#43]
Condition : ((((isnotnull(production_year#43) AND (cast(production_year#43 as int) > 2010)) AND ((Contains(title#40, murder) OR Contains(title#40, Murder)) OR Contains(title#40, Mord))) AND isnotnull(id#39)) AND isnotnull(kind_id#42))

(31) Project
Output [3]: [id#39, title#40, kind_id#42]
Input [4]: [id#39, title#40, kind_id#42, production_year#43]

(32) BroadcastHashJoin
Left keys [1]: [movie_id#116]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(33) Scan parquet spark_catalog.imdb_10x.kind_type
Output [2]: [id#293, kind#294]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/kind_type]
PushedFilters: [IsNotNull(kind), EqualTo(kind,movie), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(34) Filter
Input [2]: [id#293, kind#294]
Condition : ((isnotnull(kind#294) AND (kind#294 = movie)) AND isnotnull(id#293))

(35) Project
Output [1]: [id#293]
Input [2]: [id#293, kind#294]

(36) BroadcastExchange
Input [1]: [id#293]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=5061]

(37) BroadcastHashJoin
Left keys [1]: [kind_id#42]
Right keys [1]: [id#293]
Join type: Inner
Join condition: None

(38) Project
Output [3]: [movie_id#116, id#39, title#40]
Input [5]: [movie_id#116, id#39, title#40, kind_id#42, id#293]

(39) BroadcastExchange
Input [3]: [movie_id#116, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List(input[0, int, true], input[0, int, true], input[1, int, true], input[1, int, true]),false), [plan_id=5065]

(40) BroadcastHashJoin
Left keys [4]: [movie_id#213, movie_id#218, movie_id#213, movie_id#218]
Right keys [4]: [movie_id#116, movie_id#116, id#39, id#39]
Join type: Inner
Join condition: None

(41) Project
Output [2]: [info#220, title#40]
Input [6]: [movie_id#213, movie_id#218, info#220, movie_id#116, id#39, title#40]

(42) SortAggregate
Input [2]: [info#220, title#40]
Keys: []
Functions [2]: [partial_min(info#220), partial_min(title#40)]
Aggregate Attributes [2]: [min#416, min#417]
Results [2]: [min#418, min#419]

(43) Exchange
Input [2]: [min#418, min#419]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=5070]

(44) SortAggregate
Input [2]: [min#418, min#419]
Keys: []
Functions [2]: [min(info#220), min(title#40)]
Aggregate Attributes [2]: [min(info#220)#414, min(title#40)#415]
Results [2]: [min(info#220)#414 AS rating#404, min(title#40)#415 AS western_dark_production#405]

(45) AdaptiveSparkPlan
Output [2]: [rating#404, western_dark_production#405]
Arguments: isFinalPlan=false
Execution Time: 25.479
