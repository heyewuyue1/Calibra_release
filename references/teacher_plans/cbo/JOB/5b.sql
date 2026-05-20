== Physical Plan ==
AdaptiveSparkPlan (29)
+- SortAggregate (28)
   +- Exchange (27)
      +- SortAggregate (26)
         +- Project (25)
            +- BroadcastHashJoin Inner BuildRight (24)
               :- Project (19)
               :  +- BroadcastHashJoin Inner BuildLeft (18)
               :     :- BroadcastExchange (14)
               :     :  +- BroadcastHashJoin Inner BuildLeft (13)
               :     :     :- BroadcastExchange (9)
               :     :     :  +- Project (8)
               :     :     :     +- BroadcastHashJoin Inner BuildLeft (7)
               :     :     :        :- BroadcastExchange (4)
               :     :     :        :  +- Project (3)
               :     :     :        :     +- Filter (2)
               :     :     :        :        +- Scan parquet spark_catalog.imdb_10x.movie_info (1)
               :     :     :        +- Filter (6)
               :     :     :           +- Scan parquet spark_catalog.imdb_10x.info_type (5)
               :     :     +- Project (12)
               :     :        +- Filter (11)
               :     :           +- Scan parquet spark_catalog.imdb_10x.title (10)
               :     +- Project (17)
               :        +- Filter (16)
               :           +- Scan parquet spark_catalog.imdb_10x.movie_companies (15)
               +- BroadcastExchange (23)
                  +- Project (22)
                     +- Filter (21)
                        +- Scan parquet spark_catalog.imdb_10x.company_type (20)


(1) Scan parquet spark_catalog.imdb_10x.movie_info
Output [3]: [movie_id#213, info_type_id#214, info#215]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [In(info, [America,USA]), IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(2) Filter
Input [3]: [movie_id#213, info_type_id#214, info#215]
Condition : ((info#215 IN (USA,America) AND isnotnull(movie_id#213)) AND isnotnull(info_type_id#214))

(3) Project
Output [2]: [movie_id#213, info_type_id#214]
Input [3]: [movie_id#213, info_type_id#214, info#215]

(4) BroadcastExchange
Input [2]: [movie_id#213, info_type_id#214]
Arguments: HashedRelationBroadcastMode(List(cast(input[1, int, true] as bigint)),false), [plan_id=33135]

(5) Scan parquet spark_catalog.imdb_10x.info_type
Output [1]: [id#210]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int>

(6) Filter
Input [1]: [id#210]
Condition : isnotnull(id#210)

(7) BroadcastHashJoin
Left keys [1]: [info_type_id#214]
Right keys [1]: [id#210]
Join type: Inner
Join condition: None

(8) Project
Output [1]: [movie_id#213]
Input [3]: [movie_id#213, info_type_id#214, id#210]

(9) BroadcastExchange
Input [1]: [movie_id#213]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=33139]

(10) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#39, title#40, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(11) Filter
Input [3]: [id#39, title#40, production_year#43]
Condition : ((isnotnull(production_year#43) AND (cast(production_year#43 as int) > 2010)) AND isnotnull(id#39))

(12) Project
Output [2]: [id#39, title#40]
Input [3]: [id#39, title#40, production_year#43]

(13) BroadcastHashJoin
Left keys [1]: [movie_id#213]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(14) BroadcastExchange
Input [3]: [movie_id#213, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[1, int, true] as bigint) & 4294967295))),false), [plan_id=33142]

(15) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [3]: [movie_id#33, company_type_id#35, note#36]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(note), StringContains(note,(VHS)), StringContains(note,(USA)), StringContains(note,(1994)), IsNotNull(company_type_id), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,company_type_id:int,note:string>

(16) Filter
Input [3]: [movie_id#33, company_type_id#35, note#36]
Condition : (((((isnotnull(note#36) AND Contains(note#36, (VHS))) AND Contains(note#36, (USA))) AND Contains(note#36, (1994))) AND isnotnull(company_type_id#35)) AND isnotnull(movie_id#33))

(17) Project
Output [2]: [movie_id#33, company_type_id#35]
Input [3]: [movie_id#33, company_type_id#35, note#36]

(18) BroadcastHashJoin
Left keys [2]: [movie_id#213, id#39]
Right keys [2]: [movie_id#33, movie_id#33]
Join type: Inner
Join condition: None

(19) Project
Output [2]: [title#40, company_type_id#35]
Input [5]: [movie_id#213, id#39, title#40, movie_id#33, company_type_id#35]

(20) Scan parquet spark_catalog.imdb_10x.company_type
Output [2]: [id#30, kind#31]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_type]
PushedFilters: [IsNotNull(kind), EqualTo(kind,production companies), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(21) Filter
Input [2]: [id#30, kind#31]
Condition : ((isnotnull(kind#31) AND (kind#31 = production companies)) AND isnotnull(id#30))

(22) Project
Output [1]: [id#30]
Input [2]: [id#30, kind#31]

(23) BroadcastExchange
Input [1]: [id#30]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=33146]

(24) BroadcastHashJoin
Left keys [1]: [company_type_id#35]
Right keys [1]: [id#30]
Join type: Inner
Join condition: None

(25) Project
Output [1]: [title#40]
Input [3]: [title#40, company_type_id#35, id#30]

(26) SortAggregate
Input [1]: [title#40]
Keys: []
Functions [1]: [partial_min(title#40)]
Aggregate Attributes [1]: [min#2255]
Results [1]: [min#2256]

(27) Exchange
Input [1]: [min#2256]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=33151]

(28) SortAggregate
Input [1]: [min#2256]
Keys: []
Functions [1]: [min(title#40)]
Aggregate Attributes [1]: [min(title#40)#2254]
Results [1]: [min(title#40)#2254 AS american_vhs_movie#2248]

(29) AdaptiveSparkPlan
Output [1]: [american_vhs_movie#2248]
Arguments: isFinalPlan=false
Execution Time: 23.325
