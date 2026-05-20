== Physical Plan ==
AdaptiveSparkPlan (53)
+- SortAggregate (52)
   +- Exchange (51)
      +- SortAggregate (50)
         +- Project (49)
            +- SortMergeJoin Inner (48)
               :- Sort (36)
               :  +- Exchange (35)
               :     +- Project (34)
               :        +- SortMergeJoin Inner (33)
               :           :- Sort (28)
               :           :  +- Exchange (27)
               :           :     +- BroadcastHashJoin Inner BuildLeft (26)
               :           :        :- BroadcastExchange (23)
               :           :        :  +- BroadcastHashJoin Inner BuildLeft (22)
               :           :        :     :- BroadcastExchange (19)
               :           :        :     :  +- BroadcastHashJoin Inner BuildLeft (18)
               :           :        :     :     :- BroadcastExchange (14)
               :           :        :     :     :  +- Project (13)
               :           :        :     :     :     +- BroadcastHashJoin Inner BuildRight (12)
               :           :        :     :     :        :- Project (8)
               :           :        :     :     :        :  +- BroadcastHashJoin Inner BuildRight (7)
               :           :        :     :     :        :     :- Filter (2)
               :           :        :     :     :        :     :  +- Scan parquet spark_catalog.imdb_10x.movie_companies (1)
               :           :        :     :     :        :     +- BroadcastExchange (6)
               :           :        :     :     :        :        +- Project (5)
               :           :        :     :     :        :           +- Filter (4)
               :           :        :     :     :        :              +- Scan parquet spark_catalog.imdb_10x.company_name (3)
               :           :        :     :     :        +- BroadcastExchange (11)
               :           :        :     :     :           +- Filter (10)
               :           :        :     :     :              +- Scan parquet spark_catalog.imdb_10x.company_type (9)
               :           :        :     :     +- Project (17)
               :           :        :     :        +- Filter (16)
               :           :        :     :           +- Scan parquet spark_catalog.imdb_10x.title (15)
               :           :        :     +- Filter (21)
               :           :        :        +- Scan parquet spark_catalog.imdb_10x.aka_title (20)
               :           :        +- Filter (25)
               :           :           +- Scan parquet spark_catalog.imdb_10x.movie_keyword (24)
               :           +- Sort (32)
               :              +- Exchange (31)
               :                 +- Filter (30)
               :                    +- Scan parquet spark_catalog.imdb_10x.keyword (29)
               +- Sort (47)
                  +- Exchange (46)
                     +- Project (45)
                        +- BroadcastHashJoin Inner BuildRight (44)
                           :- Project (39)
                           :  +- Filter (38)
                           :     +- Scan parquet spark_catalog.imdb_10x.movie_info (37)
                           +- BroadcastExchange (43)
                              +- Project (42)
                                 +- Filter (41)
                                    +- Scan parquet spark_catalog.imdb_10x.info_type (40)


(1) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [3]: [movie_id#33, company_id#34, company_type_id#35]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(movie_id), IsNotNull(company_type_id), IsNotNull(company_id)]
ReadSchema: struct<movie_id:int,company_id:int,company_type_id:int>

(2) Filter
Input [3]: [movie_id#33, company_id#34, company_type_id#35]
Condition : ((isnotnull(movie_id#33) AND isnotnull(company_type_id#35)) AND isnotnull(company_id#34))

(3) Scan parquet spark_catalog.imdb_10x.company_name
Output [2]: [id#23, country_code#25]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(country_code), EqualTo(country_code,[us]), IsNotNull(id)]
ReadSchema: struct<id:int,country_code:string>

(4) Filter
Input [2]: [id#23, country_code#25]
Condition : ((isnotnull(country_code#25) AND (country_code#25 = [us])) AND isnotnull(id#23))

(5) Project
Output [1]: [id#23]
Input [2]: [id#23, country_code#25]

(6) BroadcastExchange
Input [1]: [id#23]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=6382]

(7) BroadcastHashJoin
Left keys [1]: [company_id#34]
Right keys [1]: [id#23]
Join type: Inner
Join condition: None

(8) Project
Output [2]: [movie_id#33, company_type_id#35]
Input [4]: [movie_id#33, company_id#34, company_type_id#35, id#23]

(9) Scan parquet spark_catalog.imdb_10x.company_type
Output [1]: [id#30]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_type]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int>

(10) Filter
Input [1]: [id#30]
Condition : isnotnull(id#30)

(11) BroadcastExchange
Input [1]: [id#30]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, false] as bigint)),false), [plan_id=6386]

(12) BroadcastHashJoin
Left keys [1]: [company_type_id#35]
Right keys [1]: [id#30]
Join type: Inner
Join condition: None

(13) Project
Output [1]: [movie_id#33]
Input [3]: [movie_id#33, company_type_id#35, id#30]

(14) BroadcastExchange
Input [1]: [movie_id#33]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=6390]

(15) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#39, title#40, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(16) Filter
Input [3]: [id#39, title#40, production_year#43]
Condition : ((isnotnull(production_year#43) AND (cast(production_year#43 as int) > 1990)) AND isnotnull(id#39))

(17) Project
Output [2]: [id#39, title#40]
Input [3]: [id#39, title#40, production_year#43]

(18) BroadcastHashJoin
Left keys [1]: [movie_id#33]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(19) BroadcastExchange
Input [3]: [movie_id#33, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[1, int, true] as bigint) & 4294967295))),false), [plan_id=6393]

(20) Scan parquet spark_catalog.imdb_10x.aka_title
Output [1]: [movie_id#452]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/aka_title]
PushedFilters: [IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int>

(21) Filter
Input [1]: [movie_id#452]
Condition : isnotnull(movie_id#452)

(22) BroadcastHashJoin
Left keys [2]: [movie_id#33, id#39]
Right keys [2]: [movie_id#452, movie_id#452]
Join type: Inner
Join condition: None

(23) BroadcastExchange
Input [4]: [movie_id#33, id#39, title#40, movie_id#452]
Arguments: HashedRelationBroadcastMode(List(input[0, int, true], input[3, int, false], input[1, int, true]),false), [plan_id=6396]

(24) Scan parquet spark_catalog.imdb_10x.movie_keyword
Output [2]: [movie_id#116, keyword_id#117]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_keyword]
PushedFilters: [IsNotNull(movie_id), IsNotNull(keyword_id)]
ReadSchema: struct<movie_id:int,keyword_id:int>

(25) Filter
Input [2]: [movie_id#116, keyword_id#117]
Condition : (isnotnull(movie_id#116) AND isnotnull(keyword_id#117))

(26) BroadcastHashJoin
Left keys [3]: [movie_id#33, movie_id#452, id#39]
Right keys [3]: [movie_id#116, movie_id#116, movie_id#116]
Join type: Inner
Join condition: None

(27) Exchange
Input [6]: [movie_id#33, id#39, title#40, movie_id#452, movie_id#116, keyword_id#117]
Arguments: hashpartitioning(keyword_id#117, 200), ENSURE_REQUIREMENTS, [plan_id=6400]

(28) Sort
Input [6]: [movie_id#33, id#39, title#40, movie_id#452, movie_id#116, keyword_id#117]
Arguments: [keyword_id#117 ASC NULLS FIRST], false, 0

(29) Scan parquet spark_catalog.imdb_10x.keyword
Output [1]: [id#110]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/keyword]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int>

(30) Filter
Input [1]: [id#110]
Condition : isnotnull(id#110)

(31) Exchange
Input [1]: [id#110]
Arguments: hashpartitioning(id#110, 200), ENSURE_REQUIREMENTS, [plan_id=6401]

(32) Sort
Input [1]: [id#110]
Arguments: [id#110 ASC NULLS FIRST], false, 0

(33) SortMergeJoin
Left keys [1]: [keyword_id#117]
Right keys [1]: [id#110]
Join type: Inner
Join condition: None

(34) Project
Output [5]: [movie_id#33, id#39, title#40, movie_id#452, movie_id#116]
Input [7]: [movie_id#33, id#39, title#40, movie_id#452, movie_id#116, keyword_id#117, id#110]

(35) Exchange
Input [5]: [movie_id#33, id#39, title#40, movie_id#452, movie_id#116]
Arguments: hashpartitioning(movie_id#33, movie_id#452, movie_id#116, id#39, 200), ENSURE_REQUIREMENTS, [plan_id=6411]

(36) Sort
Input [5]: [movie_id#33, id#39, title#40, movie_id#452, movie_id#116]
Arguments: [movie_id#33 ASC NULLS FIRST, movie_id#452 ASC NULLS FIRST, movie_id#116 ASC NULLS FIRST, id#39 ASC NULLS FIRST], false, 0

(37) Scan parquet spark_catalog.imdb_10x.movie_info
Output [4]: [movie_id#213, info_type_id#214, info#215, note#216]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [IsNotNull(note), StringContains(note,internet), IsNotNull(info), IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string,note:string>

(38) Filter
Input [4]: [movie_id#213, info_type_id#214, info#215, note#216]
Condition : (((((isnotnull(note#216) AND Contains(note#216, internet)) AND isnotnull(info#215)) AND (info#215 LIKE USA:% 199% OR info#215 LIKE USA:% 200%)) AND isnotnull(movie_id#213)) AND isnotnull(info_type_id#214))

(39) Project
Output [3]: [movie_id#213, info_type_id#214, info#215]
Input [4]: [movie_id#213, info_type_id#214, info#215, note#216]

(40) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#210, info#211]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,release dates), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(41) Filter
Input [2]: [id#210, info#211]
Condition : ((isnotnull(info#211) AND (info#211 = release dates)) AND isnotnull(id#210))

(42) Project
Output [1]: [id#210]
Input [2]: [id#210, info#211]

(43) BroadcastExchange
Input [1]: [id#210]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=6406]

(44) BroadcastHashJoin
Left keys [1]: [info_type_id#214]
Right keys [1]: [id#210]
Join type: Inner
Join condition: None

(45) Project
Output [2]: [movie_id#213, info#215]
Input [4]: [movie_id#213, info_type_id#214, info#215, id#210]

(46) Exchange
Input [2]: [movie_id#213, info#215]
Arguments: hashpartitioning(movie_id#213, movie_id#213, movie_id#213, movie_id#213, 200), ENSURE_REQUIREMENTS, [plan_id=6412]

(47) Sort
Input [2]: [movie_id#213, info#215]
Arguments: [movie_id#213 ASC NULLS FIRST, movie_id#213 ASC NULLS FIRST, movie_id#213 ASC NULLS FIRST, movie_id#213 ASC NULLS FIRST], false, 0

(48) SortMergeJoin
Left keys [4]: [movie_id#33, movie_id#452, movie_id#116, id#39]
Right keys [4]: [movie_id#213, movie_id#213, movie_id#213, movie_id#213]
Join type: Inner
Join condition: None

(49) Project
Output [2]: [info#215, title#40]
Input [7]: [movie_id#33, id#39, title#40, movie_id#452, movie_id#116, movie_id#213, info#215]

(50) SortAggregate
Input [2]: [info#215, title#40]
Keys: []
Functions [2]: [partial_min(info#215), partial_min(title#40)]
Aggregate Attributes [2]: [min#500, min#501]
Results [2]: [min#502, min#503]

(51) Exchange
Input [2]: [min#502, min#503]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=6419]

(52) SortAggregate
Input [2]: [min#502, min#503]
Keys: []
Functions [2]: [min(info#215), min(title#40)]
Aggregate Attributes [2]: [min(info#215)#498, min(title#40)#499]
Results [2]: [min(info#215)#498 AS release_date#491, min(title#40)#499 AS modern_american_internet_movie#492]

(53) AdaptiveSparkPlan
Output [2]: [release_date#491, modern_american_internet_movie#492]
Arguments: isFinalPlan=false
Execution Time: 47.575
