== Physical Plan ==
AdaptiveSparkPlan (45)
+- SortAggregate (44)
   +- Exchange (43)
      +- SortAggregate (42)
         +- Project (41)
            +- BroadcastHashJoin Inner BuildRight (40)
               :- Project (35)
               :  +- BroadcastHashJoin Inner BuildLeft (34)
               :     :- BroadcastExchange (31)
               :     :  +- Project (30)
               :     :     +- BroadcastHashJoin Inner BuildLeft (29)
               :     :        :- BroadcastExchange (25)
               :     :        :  +- Project (24)
               :     :        :     +- BroadcastHashJoin Inner BuildRight (23)
               :     :        :        :- BroadcastHashJoin Inner BuildLeft (18)
               :     :        :        :  :- BroadcastExchange (15)
               :     :        :        :  :  +- BroadcastHashJoin Inner BuildLeft (14)
               :     :        :        :  :     :- BroadcastExchange (10)
               :     :        :        :  :     :  +- Project (9)
               :     :        :        :  :     :     +- BroadcastHashJoin Inner BuildRight (8)
               :     :        :        :  :     :        :- Project (3)
               :     :        :        :  :     :        :  +- Filter (2)
               :     :        :        :  :     :        :     +- Scan parquet spark_catalog.imdb_10x.movie_info (1)
               :     :        :        :  :     :        +- BroadcastExchange (7)
               :     :        :        :  :     :           +- Project (6)
               :     :        :        :  :     :              +- Filter (5)
               :     :        :        :  :     :                 +- Scan parquet spark_catalog.imdb_10x.info_type (4)
               :     :        :        :  :     +- Project (13)
               :     :        :        :  :        +- Filter (12)
               :     :        :        :  :           +- Scan parquet spark_catalog.imdb_10x.title (11)
               :     :        :        :  +- Filter (17)
               :     :        :        :     +- Scan parquet spark_catalog.imdb_10x.movie_companies (16)
               :     :        :        +- BroadcastExchange (22)
               :     :        :           +- Project (21)
               :     :        :              +- Filter (20)
               :     :        :                 +- Scan parquet spark_catalog.imdb_10x.company_type (19)
               :     :        +- Project (28)
               :     :           +- Filter (27)
               :     :              +- Scan parquet spark_catalog.imdb_10x.company_name (26)
               :     +- Filter (33)
               :        +- Scan parquet spark_catalog.imdb_10x.movie_info_idx (32)
               +- BroadcastExchange (39)
                  +- Project (38)
                     +- Filter (37)
                        +- Scan parquet spark_catalog.imdb_10x.info_type (36)


(1) Scan parquet spark_catalog.imdb_10x.movie_info
Output [3]: [movie_id#213, info_type_id#214, info#215]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [In(info, [Drama,Family,Horror,Western]), IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(2) Filter
Input [3]: [movie_id#213, info_type_id#214, info#215]
Condition : ((info#215 IN (Drama,Horror,Western,Family) AND isnotnull(movie_id#213)) AND isnotnull(info_type_id#214))

(3) Project
Output [2]: [movie_id#213, info_type_id#214]
Input [3]: [movie_id#213, info_type_id#214, info#215]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=3000]

(8) BroadcastHashJoin
Left keys [1]: [info_type_id#214]
Right keys [1]: [id#210]
Join type: Inner
Join condition: None

(9) Project
Output [1]: [movie_id#213]
Input [3]: [movie_id#213, info_type_id#214, id#210]

(10) BroadcastExchange
Input [1]: [movie_id#213]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=3004]

(11) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#39, title#40, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(12) Filter
Input [3]: [id#39, title#40, production_year#43]
Condition : (((isnotnull(production_year#43) AND (cast(production_year#43 as int) >= 2000)) AND (cast(production_year#43 as int) <= 2010)) AND isnotnull(id#39))

(13) Project
Output [2]: [id#39, title#40]
Input [3]: [id#39, title#40, production_year#43]

(14) BroadcastHashJoin
Left keys [1]: [movie_id#213]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(15) BroadcastExchange
Input [3]: [movie_id#213, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[1, int, true] as bigint) & 4294967295))),false), [plan_id=3007]

(16) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [3]: [movie_id#33, company_id#34, company_type_id#35]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(company_id), IsNotNull(company_type_id), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,company_id:int,company_type_id:int>

(17) Filter
Input [3]: [movie_id#33, company_id#34, company_type_id#35]
Condition : ((isnotnull(company_id#34) AND isnotnull(company_type_id#35)) AND isnotnull(movie_id#33))

(18) BroadcastHashJoin
Left keys [2]: [movie_id#213, id#39]
Right keys [2]: [movie_id#33, movie_id#33]
Join type: Inner
Join condition: None

(19) Scan parquet spark_catalog.imdb_10x.company_type
Output [2]: [id#30, kind#31]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_type]
PushedFilters: [IsNotNull(kind), EqualTo(kind,production companies), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(20) Filter
Input [2]: [id#30, kind#31]
Condition : ((isnotnull(kind#31) AND (kind#31 = production companies)) AND isnotnull(id#30))

(21) Project
Output [1]: [id#30]
Input [2]: [id#30, kind#31]

(22) BroadcastExchange
Input [1]: [id#30]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=3010]

(23) BroadcastHashJoin
Left keys [1]: [company_type_id#35]
Right keys [1]: [id#30]
Join type: Inner
Join condition: None

(24) Project
Output [5]: [movie_id#213, id#39, title#40, movie_id#33, company_id#34]
Input [7]: [movie_id#213, id#39, title#40, movie_id#33, company_id#34, company_type_id#35, id#30]

(25) BroadcastExchange
Input [5]: [movie_id#213, id#39, title#40, movie_id#33, company_id#34]
Arguments: HashedRelationBroadcastMode(List(cast(input[4, int, true] as bigint)),false), [plan_id=3014]

(26) Scan parquet spark_catalog.imdb_10x.company_name
Output [3]: [id#23, name#24, country_code#25]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(country_code), EqualTo(country_code,[us]), IsNotNull(id)]
ReadSchema: struct<id:int,name:string,country_code:string>

(27) Filter
Input [3]: [id#23, name#24, country_code#25]
Condition : ((isnotnull(country_code#25) AND (country_code#25 = [us])) AND isnotnull(id#23))

(28) Project
Output [2]: [id#23, name#24]
Input [3]: [id#23, name#24, country_code#25]

(29) BroadcastHashJoin
Left keys [1]: [company_id#34]
Right keys [1]: [id#23]
Join type: Inner
Join condition: None

(30) Project
Output [5]: [movie_id#213, id#39, title#40, movie_id#33, name#24]
Input [7]: [movie_id#213, id#39, title#40, movie_id#33, company_id#34, id#23, name#24]

(31) BroadcastExchange
Input [5]: [movie_id#213, id#39, title#40, movie_id#33, name#24]
Arguments: HashedRelationBroadcastMode(List(input[3, int, true], input[0, int, true], input[1, int, true]),false), [plan_id=3018]

(32) Scan parquet spark_catalog.imdb_10x.movie_info_idx
Output [3]: [movie_id#218, info_type_id#219, info#220]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info_idx]
PushedFilters: [IsNotNull(info), GreaterThan(info,7.0), IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(33) Filter
Input [3]: [movie_id#218, info_type_id#219, info#220]
Condition : (((isnotnull(info#220) AND (info#220 > 7.0)) AND isnotnull(movie_id#218)) AND isnotnull(info_type_id#219))

(34) BroadcastHashJoin
Left keys [3]: [movie_id#33, movie_id#213, id#39]
Right keys [3]: [movie_id#218, movie_id#218, movie_id#218]
Join type: Inner
Join condition: None

(35) Project
Output [4]: [title#40, name#24, info_type_id#219, info#220]
Input [8]: [movie_id#213, id#39, title#40, movie_id#33, name#24, movie_id#218, info_type_id#219, info#220]

(36) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#269, info#270]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,rating), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(37) Filter
Input [2]: [id#269, info#270]
Condition : ((isnotnull(info#270) AND (info#270 = rating)) AND isnotnull(id#269))

(38) Project
Output [1]: [id#269]
Input [2]: [id#269, info#270]

(39) BroadcastExchange
Input [1]: [id#269]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=3022]

(40) BroadcastHashJoin
Left keys [1]: [info_type_id#219]
Right keys [1]: [id#269]
Join type: Inner
Join condition: None

(41) Project
Output [3]: [name#24, info#220, title#40]
Input [5]: [title#40, name#24, info_type_id#219, info#220, id#269]

(42) SortAggregate
Input [3]: [name#24, info#220, title#40]
Keys: []
Functions [3]: [partial_min(name#24), partial_min(info#220), partial_min(title#40)]
Aggregate Attributes [3]: [min#275, min#276, min#277]
Results [3]: [min#278, min#279, min#280]

(43) Exchange
Input [3]: [min#278, min#279, min#280]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=3027]

(44) SortAggregate
Input [3]: [min#278, min#279, min#280]
Keys: []
Functions [3]: [min(name#24), min(info#220), min(title#40)]
Aggregate Attributes [3]: [min(name#24)#272, min(info#220)#273, min(title#40)#274]
Results [3]: [min(name#24)#272 AS movie_company#261, min(info#220)#273 AS rating#262, min(title#40)#274 AS mainstream_movie#263]

(45) AdaptiveSparkPlan
Output [3]: [movie_company#261, rating#262, mainstream_movie#263]
Arguments: isFinalPlan=false
Execution Time: 24.336
