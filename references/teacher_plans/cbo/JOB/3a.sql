== Physical Plan ==
AdaptiveSparkPlan (23)
+- SortAggregate (22)
   +- Exchange (21)
      +- SortAggregate (20)
         +- Project (19)
            +- BroadcastHashJoin Inner BuildLeft (18)
               :- BroadcastExchange (14)
               :  +- Project (13)
               :     +- BroadcastHashJoin Inner BuildLeft (12)
               :        :- BroadcastExchange (9)
               :        :  +- BroadcastHashJoin Inner BuildLeft (8)
               :        :     :- BroadcastExchange (4)
               :        :     :  +- Project (3)
               :        :     :     +- Filter (2)
               :        :     :        +- Scan parquet spark_catalog.imdb_10x.movie_info (1)
               :        :     +- Project (7)
               :        :        +- Filter (6)
               :        :           +- Scan parquet spark_catalog.imdb_10x.title (5)
               :        +- Filter (11)
               :           +- Scan parquet spark_catalog.imdb_10x.movie_keyword (10)
               +- Project (17)
                  +- Filter (16)
                     +- Scan parquet spark_catalog.imdb_10x.keyword (15)


(1) Scan parquet spark_catalog.imdb_10x.movie_info
Output [2]: [movie_id#213, info#215]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [In(info, [Denish,Denmark,German,Germany,Norway,Norwegian,Sweden,Swedish]), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,info:string>

(2) Filter
Input [2]: [movie_id#213, info#215]
Condition : (info#215 IN (Sweden,Norway,Germany,Denmark,Swedish,Denish,Norwegian,German) AND isnotnull(movie_id#213))

(3) Project
Output [1]: [movie_id#213]
Input [2]: [movie_id#213, info#215]

(4) BroadcastExchange
Input [1]: [movie_id#213]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=31748]

(5) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#39, title#40, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(6) Filter
Input [3]: [id#39, title#40, production_year#43]
Condition : ((isnotnull(production_year#43) AND (cast(production_year#43 as int) > 2005)) AND isnotnull(id#39))

(7) Project
Output [2]: [id#39, title#40]
Input [3]: [id#39, title#40, production_year#43]

(8) BroadcastHashJoin
Left keys [1]: [movie_id#213]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(9) BroadcastExchange
Input [3]: [movie_id#213, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[1, int, true] as bigint) & 4294967295))),false), [plan_id=31751]

(10) Scan parquet spark_catalog.imdb_10x.movie_keyword
Output [2]: [movie_id#116, keyword_id#117]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_keyword]
PushedFilters: [IsNotNull(keyword_id), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,keyword_id:int>

(11) Filter
Input [2]: [movie_id#116, keyword_id#117]
Condition : (isnotnull(keyword_id#117) AND isnotnull(movie_id#116))

(12) BroadcastHashJoin
Left keys [2]: [movie_id#213, id#39]
Right keys [2]: [movie_id#116, movie_id#116]
Join type: Inner
Join condition: None

(13) Project
Output [2]: [title#40, keyword_id#117]
Input [5]: [movie_id#213, id#39, title#40, movie_id#116, keyword_id#117]

(14) BroadcastExchange
Input [2]: [title#40, keyword_id#117]
Arguments: HashedRelationBroadcastMode(List(cast(input[1, int, true] as bigint)),false), [plan_id=31755]

(15) Scan parquet spark_catalog.imdb_10x.keyword
Output [2]: [id#110, keyword#111]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/keyword]
PushedFilters: [IsNotNull(keyword), StringContains(keyword,sequel), IsNotNull(id)]
ReadSchema: struct<id:int,keyword:string>

(16) Filter
Input [2]: [id#110, keyword#111]
Condition : ((isnotnull(keyword#111) AND Contains(keyword#111, sequel)) AND isnotnull(id#110))

(17) Project
Output [1]: [id#110]
Input [2]: [id#110, keyword#111]

(18) BroadcastHashJoin
Left keys [1]: [keyword_id#117]
Right keys [1]: [id#110]
Join type: Inner
Join condition: None

(19) Project
Output [1]: [title#40]
Input [3]: [title#40, keyword_id#117, id#110]

(20) SortAggregate
Input [1]: [title#40]
Keys: []
Functions [1]: [partial_min(title#40)]
Aggregate Attributes [1]: [min#2152]
Results [1]: [min#2153]

(21) Exchange
Input [1]: [min#2153]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=31760]

(22) SortAggregate
Input [1]: [min#2153]
Keys: []
Functions [1]: [min(title#40)]
Aggregate Attributes [1]: [min(title#40)#2151]
Results [1]: [min(title#40)#2151 AS movie_title#2145]

(23) AdaptiveSparkPlan
Output [1]: [movie_title#2145]
Arguments: isFinalPlan=false
Execution Time: 18.729
