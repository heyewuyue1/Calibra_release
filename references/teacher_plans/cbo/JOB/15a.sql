== Physical Plan ==
AdaptiveSparkPlan (54)
+- SortAggregate (53)
   +- Exchange (52)
      +- SortAggregate (51)
         +- Project (50)
            +- SortMergeJoin Inner (49)
               :- Sort (37)
               :  +- Exchange (36)
               :     +- Project (35)
               :        +- SortMergeJoin Inner (34)
               :           :- Sort (29)
               :           :  +- Exchange (28)
               :           :     +- BroadcastHashJoin Inner BuildLeft (27)
               :           :        :- BroadcastExchange (24)
               :           :        :  +- BroadcastHashJoin Inner BuildLeft (23)
               :           :        :     :- BroadcastExchange (20)
               :           :        :     :  +- BroadcastHashJoin Inner BuildLeft (19)
               :           :        :     :     :- BroadcastExchange (15)
               :           :        :     :     :  +- Project (14)
               :           :        :     :     :     +- BroadcastHashJoin Inner BuildRight (13)
               :           :        :     :     :        :- Project (9)
               :           :        :     :     :        :  +- BroadcastHashJoin Inner BuildRight (8)
               :           :        :     :     :        :     :- Project (3)
               :           :        :     :     :        :     :  +- Filter (2)
               :           :        :     :     :        :     :     +- Scan parquet spark_catalog.imdb_10x.movie_companies (1)
               :           :        :     :     :        :     +- BroadcastExchange (7)
               :           :        :     :     :        :        +- Project (6)
               :           :        :     :     :        :           +- Filter (5)
               :           :        :     :     :        :              +- Scan parquet spark_catalog.imdb_10x.company_name (4)
               :           :        :     :     :        +- BroadcastExchange (12)
               :           :        :     :     :           +- Filter (11)
               :           :        :     :     :              +- Scan parquet spark_catalog.imdb_10x.company_type (10)
               :           :        :     :     +- Project (18)
               :           :        :     :        +- Filter (17)
               :           :        :     :           +- Scan parquet spark_catalog.imdb_10x.title (16)
               :           :        :     +- Filter (22)
               :           :        :        +- Scan parquet spark_catalog.imdb_10x.aka_title (21)
               :           :        +- Filter (26)
               :           :           +- Scan parquet spark_catalog.imdb_10x.movie_keyword (25)
               :           +- Sort (33)
               :              +- Exchange (32)
               :                 +- Filter (31)
               :                    +- Scan parquet spark_catalog.imdb_10x.keyword (30)
               +- Sort (48)
                  +- Exchange (47)
                     +- Project (46)
                        +- BroadcastHashJoin Inner BuildRight (45)
                           :- Project (40)
                           :  +- Filter (39)
                           :     +- Scan parquet spark_catalog.imdb_10x.movie_info (38)
                           +- BroadcastExchange (44)
                              +- Project (43)
                                 +- Filter (42)
                                    +- Scan parquet spark_catalog.imdb_10x.info_type (41)


(1) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [4]: [movie_id#33, company_id#34, company_type_id#35, note#36]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(note), StringContains(note,(worldwide)), IsNotNull(movie_id), IsNotNull(company_type_id), IsNotNull(company_id)]
ReadSchema: struct<movie_id:int,company_id:int,company_type_id:int,note:string>

(2) Filter
Input [4]: [movie_id#33, company_id#34, company_type_id#35, note#36]
Condition : (((((isnotnull(note#36) AND note#36 LIKE %(200%)%) AND Contains(note#36, (worldwide))) AND isnotnull(movie_id#33)) AND isnotnull(company_type_id#35)) AND isnotnull(company_id#34))

(3) Project
Output [3]: [movie_id#33, company_id#34, company_type_id#35]
Input [4]: [movie_id#33, company_id#34, company_type_id#35, note#36]

(4) Scan parquet spark_catalog.imdb_10x.company_name
Output [2]: [id#23, country_code#25]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(country_code), EqualTo(country_code,[us]), IsNotNull(id)]
ReadSchema: struct<id:int,country_code:string>

(5) Filter
Input [2]: [id#23, country_code#25]
Condition : ((isnotnull(country_code#25) AND (country_code#25 = [us])) AND isnotnull(id#23))

(6) Project
Output [1]: [id#23]
Input [2]: [id#23, country_code#25]

(7) BroadcastExchange
Input [1]: [id#23]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=5689]

(8) BroadcastHashJoin
Left keys [1]: [company_id#34]
Right keys [1]: [id#23]
Join type: Inner
Join condition: None

(9) Project
Output [2]: [movie_id#33, company_type_id#35]
Input [4]: [movie_id#33, company_id#34, company_type_id#35, id#23]

(10) Scan parquet spark_catalog.imdb_10x.company_type
Output [1]: [id#30]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_type]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int>

(11) Filter
Input [1]: [id#30]
Condition : isnotnull(id#30)

(12) BroadcastExchange
Input [1]: [id#30]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, false] as bigint)),false), [plan_id=5693]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=5697]

(16) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#39, title#40, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(17) Filter
Input [3]: [id#39, title#40, production_year#43]
Condition : ((isnotnull(production_year#43) AND (cast(production_year#43 as int) > 2000)) AND isnotnull(id#39))

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
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[1, int, true] as bigint) & 4294967295))),false), [plan_id=5700]

(21) Scan parquet spark_catalog.imdb_10x.aka_title
Output [1]: [movie_id#452]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/aka_title]
PushedFilters: [IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int>

(22) Filter
Input [1]: [movie_id#452]
Condition : isnotnull(movie_id#452)

(23) BroadcastHashJoin
Left keys [2]: [movie_id#33, id#39]
Right keys [2]: [movie_id#452, movie_id#452]
Join type: Inner
Join condition: None

(24) BroadcastExchange
Input [4]: [movie_id#33, id#39, title#40, movie_id#452]
Arguments: HashedRelationBroadcastMode(List(input[0, int, true], input[3, int, false], input[1, int, true]),false), [plan_id=5703]

(25) Scan parquet spark_catalog.imdb_10x.movie_keyword
Output [2]: [movie_id#116, keyword_id#117]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_keyword]
PushedFilters: [IsNotNull(movie_id), IsNotNull(keyword_id)]
ReadSchema: struct<movie_id:int,keyword_id:int>

(26) Filter
Input [2]: [movie_id#116, keyword_id#117]
Condition : (isnotnull(movie_id#116) AND isnotnull(keyword_id#117))

(27) BroadcastHashJoin
Left keys [3]: [movie_id#33, movie_id#452, id#39]
Right keys [3]: [movie_id#116, movie_id#116, movie_id#116]
Join type: Inner
Join condition: None

(28) Exchange
Input [6]: [movie_id#33, id#39, title#40, movie_id#452, movie_id#116, keyword_id#117]
Arguments: hashpartitioning(keyword_id#117, 200), ENSURE_REQUIREMENTS, [plan_id=5707]

(29) Sort
Input [6]: [movie_id#33, id#39, title#40, movie_id#452, movie_id#116, keyword_id#117]
Arguments: [keyword_id#117 ASC NULLS FIRST], false, 0

(30) Scan parquet spark_catalog.imdb_10x.keyword
Output [1]: [id#110]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/keyword]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int>

(31) Filter
Input [1]: [id#110]
Condition : isnotnull(id#110)

(32) Exchange
Input [1]: [id#110]
Arguments: hashpartitioning(id#110, 200), ENSURE_REQUIREMENTS, [plan_id=5708]

(33) Sort
Input [1]: [id#110]
Arguments: [id#110 ASC NULLS FIRST], false, 0

(34) SortMergeJoin
Left keys [1]: [keyword_id#117]
Right keys [1]: [id#110]
Join type: Inner
Join condition: None

(35) Project
Output [5]: [movie_id#33, id#39, title#40, movie_id#452, movie_id#116]
Input [7]: [movie_id#33, id#39, title#40, movie_id#452, movie_id#116, keyword_id#117, id#110]

(36) Exchange
Input [5]: [movie_id#33, id#39, title#40, movie_id#452, movie_id#116]
Arguments: hashpartitioning(movie_id#33, movie_id#452, movie_id#116, id#39, 200), ENSURE_REQUIREMENTS, [plan_id=5718]

(37) Sort
Input [5]: [movie_id#33, id#39, title#40, movie_id#452, movie_id#116]
Arguments: [movie_id#33 ASC NULLS FIRST, movie_id#452 ASC NULLS FIRST, movie_id#116 ASC NULLS FIRST, id#39 ASC NULLS FIRST], false, 0

(38) Scan parquet spark_catalog.imdb_10x.movie_info
Output [4]: [movie_id#213, info_type_id#214, info#215, note#216]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [IsNotNull(note), IsNotNull(info), StringContains(note,internet), IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string,note:string>

(39) Filter
Input [4]: [movie_id#213, info_type_id#214, info#215, note#216]
Condition : (((((isnotnull(note#216) AND isnotnull(info#215)) AND Contains(note#216, internet)) AND info#215 LIKE USA:% 200%) AND isnotnull(movie_id#213)) AND isnotnull(info_type_id#214))

(40) Project
Output [3]: [movie_id#213, info_type_id#214, info#215]
Input [4]: [movie_id#213, info_type_id#214, info#215, note#216]

(41) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#210, info#211]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,release dates), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(42) Filter
Input [2]: [id#210, info#211]
Condition : ((isnotnull(info#211) AND (info#211 = release dates)) AND isnotnull(id#210))

(43) Project
Output [1]: [id#210]
Input [2]: [id#210, info#211]

(44) BroadcastExchange
Input [1]: [id#210]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=5713]

(45) BroadcastHashJoin
Left keys [1]: [info_type_id#214]
Right keys [1]: [id#210]
Join type: Inner
Join condition: None

(46) Project
Output [2]: [movie_id#213, info#215]
Input [4]: [movie_id#213, info_type_id#214, info#215, id#210]

(47) Exchange
Input [2]: [movie_id#213, info#215]
Arguments: hashpartitioning(movie_id#213, movie_id#213, movie_id#213, movie_id#213, 200), ENSURE_REQUIREMENTS, [plan_id=5719]

(48) Sort
Input [2]: [movie_id#213, info#215]
Arguments: [movie_id#213 ASC NULLS FIRST, movie_id#213 ASC NULLS FIRST, movie_id#213 ASC NULLS FIRST, movie_id#213 ASC NULLS FIRST], false, 0

(49) SortMergeJoin
Left keys [4]: [movie_id#33, movie_id#452, movie_id#116, id#39]
Right keys [4]: [movie_id#213, movie_id#213, movie_id#213, movie_id#213]
Join type: Inner
Join condition: None

(50) Project
Output [2]: [info#215, title#40]
Input [7]: [movie_id#33, id#39, title#40, movie_id#452, movie_id#116, movie_id#213, info#215]

(51) SortAggregate
Input [2]: [info#215, title#40]
Keys: []
Functions [2]: [partial_min(info#215), partial_min(title#40)]
Aggregate Attributes [2]: [min#466, min#467]
Results [2]: [min#468, min#469]

(52) Exchange
Input [2]: [min#468, min#469]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=5726]

(53) SortAggregate
Input [2]: [min#468, min#469]
Keys: []
Functions [2]: [min(info#215), min(title#40)]
Aggregate Attributes [2]: [min(info#215)#464, min(title#40)#465]
Results [2]: [min(info#215)#464 AS release_date#444, min(title#40)#465 AS internet_movie#445]

(54) AdaptiveSparkPlan
Output [2]: [release_date#444, internet_movie#445]
Arguments: isFinalPlan=false
Execution Time: 22.451
