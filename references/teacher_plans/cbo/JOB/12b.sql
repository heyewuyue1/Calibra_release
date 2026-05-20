== Physical Plan ==
AdaptiveSparkPlan (47)
+- SortAggregate (46)
   +- Exchange (45)
      +- SortAggregate (44)
         +- Project (43)
            +- SortMergeJoin Inner (42)
               :- Sort (31)
               :  +- Exchange (30)
               :     +- Project (29)
               :        +- BroadcastHashJoin Inner BuildRight (28)
               :           :- BroadcastHashJoin Inner BuildLeft (23)
               :           :  :- BroadcastExchange (20)
               :           :  :  +- BroadcastHashJoin Inner BuildLeft (19)
               :           :  :     :- BroadcastExchange (15)
               :           :  :     :  +- Project (14)
               :           :  :     :     +- BroadcastHashJoin Inner BuildRight (13)
               :           :  :     :        :- Project (8)
               :           :  :     :        :  +- BroadcastHashJoin Inner BuildLeft (7)
               :           :  :     :        :     :- BroadcastExchange (4)
               :           :  :     :        :     :  +- Project (3)
               :           :  :     :        :     :     +- Filter (2)
               :           :  :     :        :     :        +- Scan parquet spark_catalog.imdb_10x.company_name (1)
               :           :  :     :        :     +- Filter (6)
               :           :  :     :        :        +- Scan parquet spark_catalog.imdb_10x.movie_companies (5)
               :           :  :     :        +- BroadcastExchange (12)
               :           :  :     :           +- Project (11)
               :           :  :     :              +- Filter (10)
               :           :  :     :                 +- Scan parquet spark_catalog.imdb_10x.company_type (9)
               :           :  :     +- Project (18)
               :           :  :        +- Filter (17)
               :           :  :           +- Scan parquet spark_catalog.imdb_10x.title (16)
               :           :  +- Filter (22)
               :           :     +- Scan parquet spark_catalog.imdb_10x.movie_info_idx (21)
               :           +- BroadcastExchange (27)
               :              +- Project (26)
               :                 +- Filter (25)
               :                    +- Scan parquet spark_catalog.imdb_10x.info_type (24)
               +- Sort (41)
                  +- Exchange (40)
                     +- Project (39)
                        +- BroadcastHashJoin Inner BuildRight (38)
                           :- Filter (33)
                           :  +- Scan parquet spark_catalog.imdb_10x.movie_info (32)
                           +- BroadcastExchange (37)
                              +- Project (36)
                                 +- Filter (35)
                                    +- Scan parquet spark_catalog.imdb_10x.info_type (34)


(1) Scan parquet spark_catalog.imdb_10x.company_name
Output [2]: [id#23, country_code#25]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(country_code), EqualTo(country_code,[us]), IsNotNull(id)]
ReadSchema: struct<id:int,country_code:string>

(2) Filter
Input [2]: [id#23, country_code#25]
Condition : ((isnotnull(country_code#25) AND (country_code#25 = [us])) AND isnotnull(id#23))

(3) Project
Output [1]: [id#23]
Input [2]: [id#23, country_code#25]

(4) BroadcastExchange
Input [1]: [id#23]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=2686]

(5) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [3]: [movie_id#33, company_id#34, company_type_id#35]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(company_id), IsNotNull(company_type_id), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,company_id:int,company_type_id:int>

(6) Filter
Input [3]: [movie_id#33, company_id#34, company_type_id#35]
Condition : ((isnotnull(company_id#34) AND isnotnull(company_type_id#35)) AND isnotnull(movie_id#33))

(7) BroadcastHashJoin
Left keys [1]: [id#23]
Right keys [1]: [company_id#34]
Join type: Inner
Join condition: None

(8) Project
Output [2]: [movie_id#33, company_type_id#35]
Input [4]: [id#23, movie_id#33, company_id#34, company_type_id#35]

(9) Scan parquet spark_catalog.imdb_10x.company_type
Output [2]: [id#30, kind#31]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_type]
PushedFilters: [IsNotNull(kind), Or(EqualTo(kind,production companies),EqualTo(kind,distributors)), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(10) Filter
Input [2]: [id#30, kind#31]
Condition : ((isnotnull(kind#31) AND ((kind#31 = production companies) OR (kind#31 = distributors))) AND isnotnull(id#30))

(11) Project
Output [1]: [id#30]
Input [2]: [id#30, kind#31]

(12) BroadcastExchange
Input [1]: [id#30]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=2690]

(13) BroadcastHashJoin
Left keys [1]: [company_type_id#35]
Right keys [1]: [id#30]
Join type: Inner
Join condition: None

(14) Project
Output [1]: [movie_id#33]
Input [3]: [movie_id#33, company_type_id#35, id#30]

(15) BroadcastExchange
Input [1]: [movie_id#33]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=2694]

(16) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#39, title#40, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), Or(StringStartsWith(title,Birdemic),StringContains(title,Movie)), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(17) Filter
Input [3]: [id#39, title#40, production_year#43]
Condition : (((isnotnull(production_year#43) AND (cast(production_year#43 as int) > 2000)) AND (StartsWith(title#40, Birdemic) OR Contains(title#40, Movie))) AND isnotnull(id#39))

(18) Project
Output [2]: [id#39, title#40]
Input [3]: [id#39, title#40, production_year#43]

(19) BroadcastHashJoin
Left keys [1]: [movie_id#33]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(20) BroadcastExchange
Input [3]: [movie_id#33, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[1, int, true] as bigint) & 4294967295))),false), [plan_id=2697]

(21) Scan parquet spark_catalog.imdb_10x.movie_info_idx
Output [2]: [movie_id#218, info_type_id#219]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info_idx]
PushedFilters: [IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int>

(22) Filter
Input [2]: [movie_id#218, info_type_id#219]
Condition : (isnotnull(movie_id#218) AND isnotnull(info_type_id#219))

(23) BroadcastHashJoin
Left keys [2]: [movie_id#33, id#39]
Right keys [2]: [movie_id#218, movie_id#218]
Join type: Inner
Join condition: None

(24) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#248, info#249]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,bottom 10 rank), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(25) Filter
Input [2]: [id#248, info#249]
Condition : ((isnotnull(info#249) AND (info#249 = bottom 10 rank)) AND isnotnull(id#248))

(26) Project
Output [1]: [id#248]
Input [2]: [id#248, info#249]

(27) BroadcastExchange
Input [1]: [id#248]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=2700]

(28) BroadcastHashJoin
Left keys [1]: [info_type_id#219]
Right keys [1]: [id#248]
Join type: Inner
Join condition: None

(29) Project
Output [4]: [movie_id#33, id#39, title#40, movie_id#218]
Input [6]: [movie_id#33, id#39, title#40, movie_id#218, info_type_id#219, id#248]

(30) Exchange
Input [4]: [movie_id#33, id#39, title#40, movie_id#218]
Arguments: hashpartitioning(movie_id#33, movie_id#218, id#39, 200), ENSURE_REQUIREMENTS, [plan_id=2708]

(31) Sort
Input [4]: [movie_id#33, id#39, title#40, movie_id#218]
Arguments: [movie_id#33 ASC NULLS FIRST, movie_id#218 ASC NULLS FIRST, id#39 ASC NULLS FIRST], false, 0

(32) Scan parquet spark_catalog.imdb_10x.movie_info
Output [3]: [movie_id#213, info_type_id#214, info#215]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(33) Filter
Input [3]: [movie_id#213, info_type_id#214, info#215]
Condition : (isnotnull(movie_id#213) AND isnotnull(info_type_id#214))

(34) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#210, info#211]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,budget), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(35) Filter
Input [2]: [id#210, info#211]
Condition : ((isnotnull(info#211) AND (info#211 = budget)) AND isnotnull(id#210))

(36) Project
Output [1]: [id#210]
Input [2]: [id#210, info#211]

(37) BroadcastExchange
Input [1]: [id#210]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=2703]

(38) BroadcastHashJoin
Left keys [1]: [info_type_id#214]
Right keys [1]: [id#210]
Join type: Inner
Join condition: None

(39) Project
Output [2]: [movie_id#213, info#215]
Input [4]: [movie_id#213, info_type_id#214, info#215, id#210]

(40) Exchange
Input [2]: [movie_id#213, info#215]
Arguments: hashpartitioning(movie_id#213, movie_id#213, movie_id#213, 200), ENSURE_REQUIREMENTS, [plan_id=2709]

(41) Sort
Input [2]: [movie_id#213, info#215]
Arguments: [movie_id#213 ASC NULLS FIRST, movie_id#213 ASC NULLS FIRST, movie_id#213 ASC NULLS FIRST], false, 0

(42) SortMergeJoin
Left keys [3]: [movie_id#33, movie_id#218, id#39]
Right keys [3]: [movie_id#213, movie_id#213, movie_id#213]
Join type: Inner
Join condition: None

(43) Project
Output [2]: [info#215, title#40]
Input [6]: [movie_id#33, id#39, title#40, movie_id#218, movie_id#213, info#215]

(44) SortAggregate
Input [2]: [info#215, title#40]
Keys: []
Functions [2]: [partial_min(info#215), partial_min(title#40)]
Aggregate Attributes [2]: [min#253, min#254]
Results [2]: [min#255, min#256]

(45) Exchange
Input [2]: [min#255, min#256]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=2716]

(46) SortAggregate
Input [2]: [min#255, min#256]
Keys: []
Functions [2]: [min(info#215), min(title#40)]
Aggregate Attributes [2]: [min(info#215)#251, min(title#40)#252]
Results [2]: [min(info#215)#251 AS budget#241, min(title#40)#252 AS unsuccsessful_movie#242]

(47) AdaptiveSparkPlan
Output [2]: [budget#241, unsuccsessful_movie#242]
Arguments: isFinalPlan=false
Execution Time: 25.441
