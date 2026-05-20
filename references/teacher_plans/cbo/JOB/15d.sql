== Physical Plan ==
AdaptiveSparkPlan (56)
+- SortAggregate (55)
   +- Exchange (54)
      +- SortAggregate (53)
         +- Project (52)
            +- SortMergeJoin Inner (51)
               :- Sort (39)
               :  +- Exchange (38)
               :     +- SortMergeJoin Inner (37)
               :        :- Sort (32)
               :        :  +- Exchange (31)
               :        :     +- Project (30)
               :        :        +- SortMergeJoin Inner (29)
               :        :           :- Sort (24)
               :        :           :  +- Exchange (23)
               :        :           :     +- BroadcastHashJoin Inner BuildLeft (22)
               :        :           :        :- BroadcastExchange (19)
               :        :           :        :  +- BroadcastHashJoin Inner BuildLeft (18)
               :        :           :        :     :- BroadcastExchange (14)
               :        :           :        :     :  +- Project (13)
               :        :           :        :     :     +- BroadcastHashJoin Inner BuildRight (12)
               :        :           :        :     :        :- Project (8)
               :        :           :        :     :        :  +- BroadcastHashJoin Inner BuildRight (7)
               :        :           :        :     :        :     :- Filter (2)
               :        :           :        :     :        :     :  +- Scan parquet spark_catalog.imdb_10x.movie_companies (1)
               :        :           :        :     :        :     +- BroadcastExchange (6)
               :        :           :        :     :        :        +- Project (5)
               :        :           :        :     :        :           +- Filter (4)
               :        :           :        :     :        :              +- Scan parquet spark_catalog.imdb_10x.company_name (3)
               :        :           :        :     :        +- BroadcastExchange (11)
               :        :           :        :     :           +- Filter (10)
               :        :           :        :     :              +- Scan parquet spark_catalog.imdb_10x.company_type (9)
               :        :           :        :     +- Project (17)
               :        :           :        :        +- Filter (16)
               :        :           :        :           +- Scan parquet spark_catalog.imdb_10x.title (15)
               :        :           :        +- Filter (21)
               :        :           :           +- Scan parquet spark_catalog.imdb_10x.movie_keyword (20)
               :        :           +- Sort (28)
               :        :              +- Exchange (27)
               :        :                 +- Filter (26)
               :        :                    +- Scan parquet spark_catalog.imdb_10x.keyword (25)
               :        +- Sort (36)
               :           +- Exchange (35)
               :              +- Filter (34)
               :                 +- Scan parquet spark_catalog.imdb_10x.aka_title (33)
               +- Sort (50)
                  +- Exchange (49)
                     +- Project (48)
                        +- BroadcastHashJoin Inner BuildRight (47)
                           :- Project (42)
                           :  +- Filter (41)
                           :     +- Scan parquet spark_catalog.imdb_10x.movie_info (40)
                           +- BroadcastExchange (46)
                              +- Project (45)
                                 +- Filter (44)
                                    +- Scan parquet spark_catalog.imdb_10x.info_type (43)


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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=6732]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, false] as bigint)),false), [plan_id=6736]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=6740]

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
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[1, int, true] as bigint) & 4294967295))),false), [plan_id=6743]

(20) Scan parquet spark_catalog.imdb_10x.movie_keyword
Output [2]: [movie_id#116, keyword_id#117]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_keyword]
PushedFilters: [IsNotNull(movie_id), IsNotNull(keyword_id)]
ReadSchema: struct<movie_id:int,keyword_id:int>

(21) Filter
Input [2]: [movie_id#116, keyword_id#117]
Condition : (isnotnull(movie_id#116) AND isnotnull(keyword_id#117))

(22) BroadcastHashJoin
Left keys [2]: [movie_id#33, id#39]
Right keys [2]: [movie_id#116, movie_id#116]
Join type: Inner
Join condition: None

(23) Exchange
Input [5]: [movie_id#33, id#39, title#40, movie_id#116, keyword_id#117]
Arguments: hashpartitioning(keyword_id#117, 200), ENSURE_REQUIREMENTS, [plan_id=6747]

(24) Sort
Input [5]: [movie_id#33, id#39, title#40, movie_id#116, keyword_id#117]
Arguments: [keyword_id#117 ASC NULLS FIRST], false, 0

(25) Scan parquet spark_catalog.imdb_10x.keyword
Output [1]: [id#110]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/keyword]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int>

(26) Filter
Input [1]: [id#110]
Condition : isnotnull(id#110)

(27) Exchange
Input [1]: [id#110]
Arguments: hashpartitioning(id#110, 200), ENSURE_REQUIREMENTS, [plan_id=6748]

(28) Sort
Input [1]: [id#110]
Arguments: [id#110 ASC NULLS FIRST], false, 0

(29) SortMergeJoin
Left keys [1]: [keyword_id#117]
Right keys [1]: [id#110]
Join type: Inner
Join condition: None

(30) Project
Output [4]: [movie_id#33, id#39, title#40, movie_id#116]
Input [6]: [movie_id#33, id#39, title#40, movie_id#116, keyword_id#117, id#110]

(31) Exchange
Input [4]: [movie_id#33, id#39, title#40, movie_id#116]
Arguments: hashpartitioning(movie_id#33, movie_id#116, id#39, 200), ENSURE_REQUIREMENTS, [plan_id=6755]

(32) Sort
Input [4]: [movie_id#33, id#39, title#40, movie_id#116]
Arguments: [movie_id#33 ASC NULLS FIRST, movie_id#116 ASC NULLS FIRST, id#39 ASC NULLS FIRST], false, 0

(33) Scan parquet spark_catalog.imdb_10x.aka_title
Output [2]: [movie_id#452, title#453]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/aka_title]
PushedFilters: [IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,title:string>

(34) Filter
Input [2]: [movie_id#452, title#453]
Condition : isnotnull(movie_id#452)

(35) Exchange
Input [2]: [movie_id#452, title#453]
Arguments: hashpartitioning(movie_id#452, movie_id#452, movie_id#452, 200), ENSURE_REQUIREMENTS, [plan_id=6756]

(36) Sort
Input [2]: [movie_id#452, title#453]
Arguments: [movie_id#452 ASC NULLS FIRST, movie_id#452 ASC NULLS FIRST, movie_id#452 ASC NULLS FIRST], false, 0

(37) SortMergeJoin
Left keys [3]: [movie_id#33, movie_id#116, id#39]
Right keys [3]: [movie_id#452, movie_id#452, movie_id#452]
Join type: Inner
Join condition: None

(38) Exchange
Input [6]: [movie_id#33, id#39, title#40, movie_id#116, movie_id#452, title#453]
Arguments: hashpartitioning(movie_id#33, movie_id#33, movie_id#33, movie_id#33, 200), ENSURE_REQUIREMENTS, [plan_id=6766]

(39) Sort
Input [6]: [movie_id#33, id#39, title#40, movie_id#116, movie_id#452, title#453]
Arguments: [movie_id#33 ASC NULLS FIRST, movie_id#452 ASC NULLS FIRST, movie_id#116 ASC NULLS FIRST, id#39 ASC NULLS FIRST], false, 0

(40) Scan parquet spark_catalog.imdb_10x.movie_info
Output [3]: [movie_id#213, info_type_id#214, note#216]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [IsNotNull(note), StringContains(note,internet), IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,note:string>

(41) Filter
Input [3]: [movie_id#213, info_type_id#214, note#216]
Condition : (((isnotnull(note#216) AND Contains(note#216, internet)) AND isnotnull(movie_id#213)) AND isnotnull(info_type_id#214))

(42) Project
Output [2]: [movie_id#213, info_type_id#214]
Input [3]: [movie_id#213, info_type_id#214, note#216]

(43) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#210, info#211]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,release dates), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(44) Filter
Input [2]: [id#210, info#211]
Condition : ((isnotnull(info#211) AND (info#211 = release dates)) AND isnotnull(id#210))

(45) Project
Output [1]: [id#210]
Input [2]: [id#210, info#211]

(46) BroadcastExchange
Input [1]: [id#210]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=6760]

(47) BroadcastHashJoin
Left keys [1]: [info_type_id#214]
Right keys [1]: [id#210]
Join type: Inner
Join condition: None

(48) Project
Output [1]: [movie_id#213]
Input [3]: [movie_id#213, info_type_id#214, id#210]

(49) Exchange
Input [1]: [movie_id#213]
Arguments: hashpartitioning(movie_id#213, movie_id#213, movie_id#213, movie_id#213, 200), ENSURE_REQUIREMENTS, [plan_id=6765]

(50) Sort
Input [1]: [movie_id#213]
Arguments: [movie_id#213 ASC NULLS FIRST, movie_id#213 ASC NULLS FIRST, movie_id#213 ASC NULLS FIRST, movie_id#213 ASC NULLS FIRST], false, 0

(51) SortMergeJoin
Left keys [4]: [movie_id#33, movie_id#452, movie_id#116, id#39]
Right keys [4]: [movie_id#213, movie_id#213, movie_id#213, movie_id#213]
Join type: Inner
Join condition: None

(52) Project
Output [2]: [title#453, title#40]
Input [7]: [movie_id#33, id#39, title#40, movie_id#116, movie_id#452, title#453, movie_id#213]

(53) SortAggregate
Input [2]: [title#453, title#40]
Keys: []
Functions [2]: [partial_min(title#453), partial_min(title#40)]
Aggregate Attributes [2]: [min#517, min#518]
Results [2]: [min#519, min#520]

(54) Exchange
Input [2]: [min#519, min#520]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=6773]

(55) SortAggregate
Input [2]: [min#519, min#520]
Keys: []
Functions [2]: [min(title#453), min(title#40)]
Aggregate Attributes [2]: [min(title#453)#515, min(title#40)#516]
Results [2]: [min(title#453)#515 AS aka_title#508, min(title#40)#516 AS internet_movie_title#509]

(56) AdaptiveSparkPlan
Output [2]: [aka_title#508, internet_movie_title#509]
Arguments: isFinalPlan=false
Execution Time: 49.628
