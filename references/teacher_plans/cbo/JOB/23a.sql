== Physical Plan ==
AdaptiveSparkPlan (67)
+- SortAggregate (66)
   +- Exchange (65)
      +- SortAggregate (64)
         +- Project (63)
            +- SortMergeJoin Inner (62)
               :- Sort (51)
               :  +- Exchange (50)
               :     +- SortMergeJoin Inner (49)
               :        :- Sort (37)
               :        :  +- Exchange (36)
               :        :     +- Project (35)
               :        :        +- SortMergeJoin Inner (34)
               :        :           :- Sort (29)
               :        :           :  +- Exchange (28)
               :        :           :     +- BroadcastHashJoin Inner BuildLeft (27)
               :        :           :        :- BroadcastExchange (24)
               :        :           :        :  +- Project (23)
               :        :           :        :     +- BroadcastHashJoin Inner BuildRight (22)
               :        :           :        :        :- BroadcastHashJoin Inner BuildLeft (18)
               :        :           :        :        :  :- BroadcastExchange (14)
               :        :           :        :        :  :  +- Project (13)
               :        :           :        :        :  :     +- BroadcastHashJoin Inner BuildRight (12)
               :        :           :        :        :  :        :- Project (8)
               :        :           :        :        :  :        :  +- BroadcastHashJoin Inner BuildRight (7)
               :        :           :        :        :  :        :     :- Filter (2)
               :        :           :        :        :  :        :     :  +- Scan parquet spark_catalog.imdb_10x.movie_companies (1)
               :        :           :        :        :  :        :     +- BroadcastExchange (6)
               :        :           :        :        :  :        :        +- Project (5)
               :        :           :        :        :  :        :           +- Filter (4)
               :        :           :        :        :  :        :              +- Scan parquet spark_catalog.imdb_10x.company_name (3)
               :        :           :        :        :  :        +- BroadcastExchange (11)
               :        :           :        :        :  :           +- Filter (10)
               :        :           :        :        :  :              +- Scan parquet spark_catalog.imdb_10x.company_type (9)
               :        :           :        :        :  +- Project (17)
               :        :           :        :        :     +- Filter (16)
               :        :           :        :        :        +- Scan parquet spark_catalog.imdb_10x.title (15)
               :        :           :        :        +- BroadcastExchange (21)
               :        :           :        :           +- Filter (20)
               :        :           :        :              +- Scan parquet spark_catalog.imdb_10x.kind_type (19)
               :        :           :        +- Filter (26)
               :        :           :           +- Scan parquet spark_catalog.imdb_10x.movie_keyword (25)
               :        :           +- Sort (33)
               :        :              +- Exchange (32)
               :        :                 +- Filter (31)
               :        :                    +- Scan parquet spark_catalog.imdb_10x.keyword (30)
               :        +- Sort (48)
               :           +- Exchange (47)
               :              +- Project (46)
               :                 +- BroadcastHashJoin Inner BuildRight (45)
               :                    :- Project (40)
               :                    :  +- Filter (39)
               :                    :     +- Scan parquet spark_catalog.imdb_10x.movie_info (38)
               :                    +- BroadcastExchange (44)
               :                       +- Project (43)
               :                          +- Filter (42)
               :                             +- Scan parquet spark_catalog.imdb_10x.info_type (41)
               +- Sort (61)
                  +- Exchange (60)
                     +- Project (59)
                        +- BroadcastHashJoin Inner BuildRight (58)
                           :- Filter (53)
                           :  +- Scan parquet spark_catalog.imdb_10x.complete_cast (52)
                           +- BroadcastExchange (57)
                              +- Project (56)
                                 +- Filter (55)
                                    +- Scan parquet spark_catalog.imdb_10x.comp_cast_type (54)


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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=17040]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, false] as bigint)),false), [plan_id=17044]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=17048]

(15) Scan parquet spark_catalog.imdb_10x.title
Output [4]: [id#39, title#40, kind_id#42, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id), IsNotNull(kind_id)]
ReadSchema: struct<id:int,title:string,kind_id:int,production_year:string>

(16) Filter
Input [4]: [id#39, title#40, kind_id#42, production_year#43]
Condition : (((isnotnull(production_year#43) AND (cast(production_year#43 as int) > 2000)) AND isnotnull(id#39)) AND isnotnull(kind_id#42))

(17) Project
Output [3]: [id#39, title#40, kind_id#42]
Input [4]: [id#39, title#40, kind_id#42, production_year#43]

(18) BroadcastHashJoin
Left keys [1]: [movie_id#33]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(19) Scan parquet spark_catalog.imdb_10x.kind_type
Output [2]: [id#293, kind#294]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/kind_type]
PushedFilters: [IsNotNull(kind), EqualTo(kind,movie), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(20) Filter
Input [2]: [id#293, kind#294]
Condition : ((isnotnull(kind#294) AND (kind#294 = movie)) AND isnotnull(id#293))

(21) BroadcastExchange
Input [2]: [id#293, kind#294]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, false] as bigint)),false), [plan_id=17051]

(22) BroadcastHashJoin
Left keys [1]: [kind_id#42]
Right keys [1]: [id#293]
Join type: Inner
Join condition: None

(23) Project
Output [4]: [movie_id#33, id#39, title#40, kind#294]
Input [6]: [movie_id#33, id#39, title#40, kind_id#42, id#293, kind#294]

(24) BroadcastExchange
Input [4]: [movie_id#33, id#39, title#40, kind#294]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[1, int, true] as bigint) & 4294967295))),false), [plan_id=17055]

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
Left keys [2]: [movie_id#33, id#39]
Right keys [2]: [movie_id#116, movie_id#116]
Join type: Inner
Join condition: None

(28) Exchange
Input [6]: [movie_id#33, id#39, title#40, kind#294, movie_id#116, keyword_id#117]
Arguments: hashpartitioning(keyword_id#117, 200), ENSURE_REQUIREMENTS, [plan_id=17059]

(29) Sort
Input [6]: [movie_id#33, id#39, title#40, kind#294, movie_id#116, keyword_id#117]
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
Arguments: hashpartitioning(id#110, 200), ENSURE_REQUIREMENTS, [plan_id=17060]

(33) Sort
Input [1]: [id#110]
Arguments: [id#110 ASC NULLS FIRST], false, 0

(34) SortMergeJoin
Left keys [1]: [keyword_id#117]
Right keys [1]: [id#110]
Join type: Inner
Join condition: None

(35) Project
Output [5]: [movie_id#33, id#39, title#40, kind#294, movie_id#116]
Input [7]: [movie_id#33, id#39, title#40, kind#294, movie_id#116, keyword_id#117, id#110]

(36) Exchange
Input [5]: [movie_id#33, id#39, title#40, kind#294, movie_id#116]
Arguments: hashpartitioning(movie_id#33, movie_id#116, id#39, 200), ENSURE_REQUIREMENTS, [plan_id=17070]

(37) Sort
Input [5]: [movie_id#33, id#39, title#40, kind#294, movie_id#116]
Arguments: [movie_id#33 ASC NULLS FIRST, movie_id#116 ASC NULLS FIRST, id#39 ASC NULLS FIRST], false, 0

(38) Scan parquet spark_catalog.imdb_10x.movie_info
Output [4]: [movie_id#213, info_type_id#214, info#215, note#216]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [IsNotNull(note), StringContains(note,internet), IsNotNull(info), IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string,note:string>

(39) Filter
Input [4]: [movie_id#213, info_type_id#214, info#215, note#216]
Condition : (((((isnotnull(note#216) AND Contains(note#216, internet)) AND isnotnull(info#215)) AND (info#215 LIKE USA:% 199% OR info#215 LIKE USA:% 200%)) AND isnotnull(movie_id#213)) AND isnotnull(info_type_id#214))

(40) Project
Output [2]: [movie_id#213, info_type_id#214]
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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=17065]

(45) BroadcastHashJoin
Left keys [1]: [info_type_id#214]
Right keys [1]: [id#210]
Join type: Inner
Join condition: None

(46) Project
Output [1]: [movie_id#213]
Input [3]: [movie_id#213, info_type_id#214, id#210]

(47) Exchange
Input [1]: [movie_id#213]
Arguments: hashpartitioning(movie_id#213, movie_id#213, movie_id#213, 200), ENSURE_REQUIREMENTS, [plan_id=17071]

(48) Sort
Input [1]: [movie_id#213]
Arguments: [movie_id#213 ASC NULLS FIRST, movie_id#213 ASC NULLS FIRST, movie_id#213 ASC NULLS FIRST], false, 0

(49) SortMergeJoin
Left keys [3]: [movie_id#33, movie_id#116, id#39]
Right keys [3]: [movie_id#213, movie_id#213, movie_id#213]
Join type: Inner
Join condition: None

(50) Exchange
Input [6]: [movie_id#33, id#39, title#40, kind#294, movie_id#116, movie_id#213]
Arguments: hashpartitioning(movie_id#33, movie_id#33, movie_id#33, movie_id#33, 200), ENSURE_REQUIREMENTS, [plan_id=17081]

(51) Sort
Input [6]: [movie_id#33, id#39, title#40, kind#294, movie_id#116, movie_id#213]
Arguments: [movie_id#33 ASC NULLS FIRST, movie_id#213 ASC NULLS FIRST, movie_id#116 ASC NULLS FIRST, id#39 ASC NULLS FIRST], false, 0

(52) Scan parquet spark_catalog.imdb_10x.complete_cast
Output [2]: [movie_id#927, status_id#929]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/complete_cast]
PushedFilters: [IsNotNull(status_id), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:string,status_id:int>

(53) Filter
Input [2]: [movie_id#927, status_id#929]
Condition : (isnotnull(status_id#929) AND isnotnull(movie_id#927))

(54) Scan parquet spark_catalog.imdb_10x.comp_cast_type
Output [2]: [id#930, kind#931]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/comp_cast_type]
PushedFilters: [IsNotNull(kind), EqualTo(kind,complete+verified), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(55) Filter
Input [2]: [id#930, kind#931]
Condition : ((isnotnull(kind#931) AND (kind#931 = complete+verified)) AND isnotnull(id#930))

(56) Project
Output [1]: [id#930]
Input [2]: [id#930, kind#931]

(57) BroadcastExchange
Input [1]: [id#930]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=17075]

(58) BroadcastHashJoin
Left keys [1]: [status_id#929]
Right keys [1]: [id#930]
Join type: Inner
Join condition: None

(59) Project
Output [1]: [movie_id#927]
Input [3]: [movie_id#927, status_id#929, id#930]

(60) Exchange
Input [1]: [movie_id#927]
Arguments: hashpartitioning(cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int), 200), ENSURE_REQUIREMENTS, [plan_id=17080]

(61) Sort
Input [1]: [movie_id#927]
Arguments: [cast(movie_id#927 as int) ASC NULLS FIRST, cast(movie_id#927 as int) ASC NULLS FIRST, cast(movie_id#927 as int) ASC NULLS FIRST, cast(movie_id#927 as int) ASC NULLS FIRST], false, 0

(62) SortMergeJoin
Left keys [4]: [movie_id#33, movie_id#213, movie_id#116, id#39]
Right keys [4]: [cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int)]
Join type: Inner
Join condition: None

(63) Project
Output [2]: [kind#294, title#40]
Input [7]: [movie_id#33, id#39, title#40, kind#294, movie_id#116, movie_id#213, movie_id#927]

(64) SortAggregate
Input [2]: [kind#294, title#40]
Keys: []
Functions [2]: [partial_min(kind#294), partial_min(title#40)]
Aggregate Attributes [2]: [min#1148, min#1149]
Results [2]: [min#1150, min#1151]

(65) Exchange
Input [2]: [min#1150, min#1151]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=17088]

(66) SortAggregate
Input [2]: [min#1150, min#1151]
Keys: []
Functions [2]: [min(kind#294), min(title#40)]
Aggregate Attributes [2]: [min(kind#294)#1146, min(title#40)#1147]
Results [2]: [min(kind#294)#1146 AS movie_kind#1139, min(title#40)#1147 AS complete_us_internet_movie#1140]

(67) AdaptiveSparkPlan
Output [2]: [movie_kind#1139, complete_us_internet_movie#1140]
Arguments: isFinalPlan=false
Execution Time: 35.587
