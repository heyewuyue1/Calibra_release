== Physical Plan ==
AdaptiveSparkPlan (86)
+- SortAggregate (85)
   +- Exchange (84)
      +- SortAggregate (83)
         +- Project (82)
            +- SortMergeJoin Inner (81)
               :- Sort (50)
               :  +- Exchange (49)
               :     +- Project (48)
               :        +- SortMergeJoin Inner (47)
               :           :- Sort (36)
               :           :  +- Exchange (35)
               :           :     +- Project (34)
               :           :        +- SortMergeJoin Inner (33)
               :           :           :- Sort (28)
               :           :           :  +- Exchange (27)
               :           :           :     +- SortMergeJoin Inner (26)
               :           :           :        :- Sort (21)
               :           :           :        :  +- Exchange (20)
               :           :           :        :     +- Project (19)
               :           :           :        :        +- BroadcastHashJoin Inner BuildRight (18)
               :           :           :        :           :- BroadcastHashJoin Inner BuildLeft (13)
               :           :           :        :           :  :- BroadcastExchange (9)
               :           :           :        :           :  :  +- Project (8)
               :           :           :        :           :  :     +- BroadcastHashJoin Inner BuildRight (7)
               :           :           :        :           :  :        :- Filter (2)
               :           :           :        :           :  :        :  +- Scan parquet spark_catalog.imdb_10x.movie_link (1)
               :           :           :        :           :  :        +- BroadcastExchange (6)
               :           :           :        :           :  :           +- Project (5)
               :           :           :        :           :  :              +- Filter (4)
               :           :           :        :           :  :                 +- Scan parquet spark_catalog.imdb_10x.link_type (3)
               :           :           :        :           :  +- Project (12)
               :           :           :        :           :     +- Filter (11)
               :           :           :        :           :        +- Scan parquet spark_catalog.imdb_10x.title (10)
               :           :           :        :           +- BroadcastExchange (17)
               :           :           :        :              +- Project (16)
               :           :           :        :                 +- Filter (15)
               :           :           :        :                    +- Scan parquet spark_catalog.imdb_10x.kind_type (14)
               :           :           :        +- Sort (25)
               :           :           :           +- Exchange (24)
               :           :           :              +- Filter (23)
               :           :           :                 +- Scan parquet spark_catalog.imdb_10x.movie_companies (22)
               :           :           +- Sort (32)
               :           :              +- Exchange (31)
               :           :                 +- Filter (30)
               :           :                    +- Scan parquet spark_catalog.imdb_10x.company_name (29)
               :           +- Sort (46)
               :              +- Exchange (45)
               :                 +- Project (44)
               :                    +- BroadcastHashJoin Inner BuildRight (43)
               :                       :- Filter (38)
               :                       :  +- Scan parquet spark_catalog.imdb_10x.movie_info_idx (37)
               :                       +- BroadcastExchange (42)
               :                          +- Project (41)
               :                             +- Filter (40)
               :                                +- Scan parquet spark_catalog.imdb_10x.info_type (39)
               +- Sort (80)
                  +- Exchange (79)
                     +- Project (78)
                        +- BroadcastHashJoin Inner BuildRight (77)
                           :- BroadcastHashJoin Inner BuildLeft (72)
                           :  :- BroadcastExchange (69)
                           :  :  +- Project (68)
                           :  :     +- BroadcastHashJoin Inner BuildRight (67)
                           :  :        :- BroadcastHashJoin Inner BuildLeft (62)
                           :  :        :  :- BroadcastExchange (59)
                           :  :        :  :  +- Project (58)
                           :  :        :  :     +- BroadcastHashJoin Inner BuildLeft (57)
                           :  :        :  :        :- BroadcastExchange (54)
                           :  :        :  :        :  +- Project (53)
                           :  :        :  :        :     +- Filter (52)
                           :  :        :  :        :        +- Scan parquet spark_catalog.imdb_10x.company_name (51)
                           :  :        :  :        +- Filter (56)
                           :  :        :  :           +- Scan parquet spark_catalog.imdb_10x.movie_companies (55)
                           :  :        :  +- Filter (61)
                           :  :        :     +- Scan parquet spark_catalog.imdb_10x.title (60)
                           :  :        +- BroadcastExchange (66)
                           :  :           +- Project (65)
                           :  :              +- Filter (64)
                           :  :                 +- Scan parquet spark_catalog.imdb_10x.kind_type (63)
                           :  +- Filter (71)
                           :     +- Scan parquet spark_catalog.imdb_10x.movie_info_idx (70)
                           +- BroadcastExchange (76)
                              +- Project (75)
                                 +- Filter (74)
                                    +- Scan parquet spark_catalog.imdb_10x.info_type (73)


(1) Scan parquet spark_catalog.imdb_10x.movie_link
Output [3]: [movie_id#119, linked_movie_id#120, link_type_id#121]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_link]
PushedFilters: [IsNotNull(movie_id), IsNotNull(linked_movie_id), IsNotNull(link_type_id)]
ReadSchema: struct<movie_id:int,linked_movie_id:int,link_type_id:int>

(2) Filter
Input [3]: [movie_id#119, linked_movie_id#120, link_type_id#121]
Condition : ((isnotnull(movie_id#119) AND isnotnull(linked_movie_id#120)) AND isnotnull(link_type_id#121))

(3) Scan parquet spark_catalog.imdb_10x.link_type
Output [2]: [id#113, link#114]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/link_type]
PushedFilters: [IsNotNull(link), StringContains(link,follow), IsNotNull(id)]
ReadSchema: struct<id:int,link:string>

(4) Filter
Input [2]: [id#113, link#114]
Condition : ((isnotnull(link#114) AND Contains(link#114, follow)) AND isnotnull(id#113))

(5) Project
Output [1]: [id#113]
Input [2]: [id#113, link#114]

(6) BroadcastExchange
Input [1]: [id#113]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=30981]

(7) BroadcastHashJoin
Left keys [1]: [link_type_id#121]
Right keys [1]: [id#113]
Join type: Inner
Join condition: None

(8) Project
Output [2]: [movie_id#119, linked_movie_id#120]
Input [4]: [movie_id#119, linked_movie_id#120, link_type_id#121, id#113]

(9) BroadcastExchange
Input [2]: [movie_id#119, linked_movie_id#120]
Arguments: HashedRelationBroadcastMode(List(cast(input[1, int, true] as bigint)),false), [plan_id=30985]

(10) Scan parquet spark_catalog.imdb_10x.title
Output [4]: [id#2033, title#2034, kind_id#2036, production_year#2037]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id), IsNotNull(kind_id)]
ReadSchema: struct<id:int,title:string,kind_id:int,production_year:string>

(11) Filter
Input [4]: [id#2033, title#2034, kind_id#2036, production_year#2037]
Condition : (((isnotnull(production_year#2037) AND (cast(production_year#2037 as int) = 2007)) AND isnotnull(id#2033)) AND isnotnull(kind_id#2036))

(12) Project
Output [3]: [id#2033, title#2034, kind_id#2036]
Input [4]: [id#2033, title#2034, kind_id#2036, production_year#2037]

(13) BroadcastHashJoin
Left keys [1]: [linked_movie_id#120]
Right keys [1]: [id#2033]
Join type: Inner
Join condition: None

(14) Scan parquet spark_catalog.imdb_10x.kind_type
Output [2]: [id#2021, kind#2022]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/kind_type]
PushedFilters: [IsNotNull(kind), EqualTo(kind,tv series), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(15) Filter
Input [2]: [id#2021, kind#2022]
Condition : ((isnotnull(kind#2022) AND (kind#2022 = tv series)) AND isnotnull(id#2021))

(16) Project
Output [1]: [id#2021]
Input [2]: [id#2021, kind#2022]

(17) BroadcastExchange
Input [1]: [id#2021]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=30988]

(18) BroadcastHashJoin
Left keys [1]: [kind_id#2036]
Right keys [1]: [id#2021]
Join type: Inner
Join condition: None

(19) Project
Output [4]: [movie_id#119, linked_movie_id#120, id#2033, title#2034]
Input [6]: [movie_id#119, linked_movie_id#120, id#2033, title#2034, kind_id#2036, id#2021]

(20) Exchange
Input [4]: [movie_id#119, linked_movie_id#120, id#2033, title#2034]
Arguments: hashpartitioning(linked_movie_id#120, id#2033, 200), ENSURE_REQUIREMENTS, [plan_id=30993]

(21) Sort
Input [4]: [movie_id#119, linked_movie_id#120, id#2033, title#2034]
Arguments: [linked_movie_id#120 ASC NULLS FIRST, id#2033 ASC NULLS FIRST], false, 0

(22) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [2]: [movie_id#2024, company_id#2025]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(movie_id), IsNotNull(company_id)]
ReadSchema: struct<movie_id:int,company_id:int>

(23) Filter
Input [2]: [movie_id#2024, company_id#2025]
Condition : (isnotnull(movie_id#2024) AND isnotnull(company_id#2025))

(24) Exchange
Input [2]: [movie_id#2024, company_id#2025]
Arguments: hashpartitioning(movie_id#2024, movie_id#2024, 200), ENSURE_REQUIREMENTS, [plan_id=30994]

(25) Sort
Input [2]: [movie_id#2024, company_id#2025]
Arguments: [movie_id#2024 ASC NULLS FIRST, movie_id#2024 ASC NULLS FIRST], false, 0

(26) SortMergeJoin
Left keys [2]: [linked_movie_id#120, id#2033]
Right keys [2]: [movie_id#2024, movie_id#2024]
Join type: Inner
Join condition: None

(27) Exchange
Input [6]: [movie_id#119, linked_movie_id#120, id#2033, title#2034, movie_id#2024, company_id#2025]
Arguments: hashpartitioning(company_id#2025, 200), ENSURE_REQUIREMENTS, [plan_id=31000]

(28) Sort
Input [6]: [movie_id#119, linked_movie_id#120, id#2033, title#2034, movie_id#2024, company_id#2025]
Arguments: [company_id#2025 ASC NULLS FIRST], false, 0

(29) Scan parquet spark_catalog.imdb_10x.company_name
Output [2]: [id#2012, name#2013]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int,name:string>

(30) Filter
Input [2]: [id#2012, name#2013]
Condition : isnotnull(id#2012)

(31) Exchange
Input [2]: [id#2012, name#2013]
Arguments: hashpartitioning(id#2012, 200), ENSURE_REQUIREMENTS, [plan_id=31001]

(32) Sort
Input [2]: [id#2012, name#2013]
Arguments: [id#2012 ASC NULLS FIRST], false, 0

(33) SortMergeJoin
Left keys [1]: [company_id#2025]
Right keys [1]: [id#2012]
Join type: Inner
Join condition: None

(34) Project
Output [6]: [movie_id#119, linked_movie_id#120, id#2033, title#2034, movie_id#2024, name#2013]
Input [8]: [movie_id#119, linked_movie_id#120, id#2033, title#2034, movie_id#2024, company_id#2025, id#2012, name#2013]

(35) Exchange
Input [6]: [movie_id#119, linked_movie_id#120, id#2033, title#2034, movie_id#2024, name#2013]
Arguments: hashpartitioning(linked_movie_id#120, movie_id#2024, id#2033, 200), ENSURE_REQUIREMENTS, [plan_id=31011]

(36) Sort
Input [6]: [movie_id#119, linked_movie_id#120, id#2033, title#2034, movie_id#2024, name#2013]
Arguments: [linked_movie_id#120 ASC NULLS FIRST, movie_id#2024 ASC NULLS FIRST, id#2033 ASC NULLS FIRST], false, 0

(37) Scan parquet spark_catalog.imdb_10x.movie_info_idx
Output [3]: [movie_id#2029, info_type_id#2030, info#2031]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info_idx]
PushedFilters: [IsNotNull(info), LessThan(info,3.0), IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(38) Filter
Input [3]: [movie_id#2029, info_type_id#2030, info#2031]
Condition : (((isnotnull(info#2031) AND (info#2031 < 3.0)) AND isnotnull(movie_id#2029)) AND isnotnull(info_type_id#2030))

(39) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#2019, info#2020]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,rating), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(40) Filter
Input [2]: [id#2019, info#2020]
Condition : ((isnotnull(info#2020) AND (info#2020 = rating)) AND isnotnull(id#2019))

(41) Project
Output [1]: [id#2019]
Input [2]: [id#2019, info#2020]

(42) BroadcastExchange
Input [1]: [id#2019]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=31006]

(43) BroadcastHashJoin
Left keys [1]: [info_type_id#2030]
Right keys [1]: [id#2019]
Join type: Inner
Join condition: None

(44) Project
Output [2]: [movie_id#2029, info#2031]
Input [4]: [movie_id#2029, info_type_id#2030, info#2031, id#2019]

(45) Exchange
Input [2]: [movie_id#2029, info#2031]
Arguments: hashpartitioning(movie_id#2029, movie_id#2029, movie_id#2029, 200), ENSURE_REQUIREMENTS, [plan_id=31012]

(46) Sort
Input [2]: [movie_id#2029, info#2031]
Arguments: [movie_id#2029 ASC NULLS FIRST, movie_id#2029 ASC NULLS FIRST, movie_id#2029 ASC NULLS FIRST], false, 0

(47) SortMergeJoin
Left keys [3]: [linked_movie_id#120, movie_id#2024, id#2033]
Right keys [3]: [movie_id#2029, movie_id#2029, movie_id#2029]
Join type: Inner
Join condition: None

(48) Project
Output [4]: [movie_id#119, title#2034, name#2013, info#2031]
Input [8]: [movie_id#119, linked_movie_id#120, id#2033, title#2034, movie_id#2024, name#2013, movie_id#2029, info#2031]

(49) Exchange
Input [4]: [movie_id#119, title#2034, name#2013, info#2031]
Arguments: hashpartitioning(movie_id#119, movie_id#119, movie_id#119, 200), ENSURE_REQUIREMENTS, [plan_id=31036]

(50) Sort
Input [4]: [movie_id#119, title#2034, name#2013, info#2031]
Arguments: [movie_id#119 ASC NULLS FIRST, movie_id#119 ASC NULLS FIRST, movie_id#119 ASC NULLS FIRST], false, 0

(51) Scan parquet spark_catalog.imdb_10x.company_name
Output [3]: [id#23, name#24, country_code#25]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(country_code), EqualTo(country_code,[nl]), IsNotNull(id)]
ReadSchema: struct<id:int,name:string,country_code:string>

(52) Filter
Input [3]: [id#23, name#24, country_code#25]
Condition : ((isnotnull(country_code#25) AND (country_code#25 = [nl])) AND isnotnull(id#23))

(53) Project
Output [2]: [id#23, name#24]
Input [3]: [id#23, name#24, country_code#25]

(54) BroadcastExchange
Input [2]: [id#23, name#24]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=31017]

(55) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [2]: [movie_id#33, company_id#34]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(company_id), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,company_id:int>

(56) Filter
Input [2]: [movie_id#33, company_id#34]
Condition : (isnotnull(company_id#34) AND isnotnull(movie_id#33))

(57) BroadcastHashJoin
Left keys [1]: [id#23]
Right keys [1]: [company_id#34]
Join type: Inner
Join condition: None

(58) Project
Output [2]: [name#24, movie_id#33]
Input [4]: [id#23, name#24, movie_id#33, company_id#34]

(59) BroadcastExchange
Input [2]: [name#24, movie_id#33]
Arguments: HashedRelationBroadcastMode(List(cast(input[1, int, true] as bigint)),false), [plan_id=31021]

(60) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#39, title#40, kind_id#42]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(id), IsNotNull(kind_id)]
ReadSchema: struct<id:int,title:string,kind_id:int>

(61) Filter
Input [3]: [id#39, title#40, kind_id#42]
Condition : (isnotnull(id#39) AND isnotnull(kind_id#42))

(62) BroadcastHashJoin
Left keys [1]: [movie_id#33]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(63) Scan parquet spark_catalog.imdb_10x.kind_type
Output [2]: [id#293, kind#294]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/kind_type]
PushedFilters: [IsNotNull(kind), EqualTo(kind,tv series), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(64) Filter
Input [2]: [id#293, kind#294]
Condition : ((isnotnull(kind#294) AND (kind#294 = tv series)) AND isnotnull(id#293))

(65) Project
Output [1]: [id#293]
Input [2]: [id#293, kind#294]

(66) BroadcastExchange
Input [1]: [id#293]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=31024]

(67) BroadcastHashJoin
Left keys [1]: [kind_id#42]
Right keys [1]: [id#293]
Join type: Inner
Join condition: None

(68) Project
Output [4]: [name#24, movie_id#33, id#39, title#40]
Input [6]: [name#24, movie_id#33, id#39, title#40, kind_id#42, id#293]

(69) BroadcastExchange
Input [4]: [name#24, movie_id#33, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[1, int, true] as bigint), 32) | (cast(input[2, int, true] as bigint) & 4294967295))),false), [plan_id=31028]

(70) Scan parquet spark_catalog.imdb_10x.movie_info_idx
Output [3]: [movie_id#218, info_type_id#219, info#220]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info_idx]
PushedFilters: [IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(71) Filter
Input [3]: [movie_id#218, info_type_id#219, info#220]
Condition : (isnotnull(movie_id#218) AND isnotnull(info_type_id#219))

(72) BroadcastHashJoin
Left keys [2]: [movie_id#33, id#39]
Right keys [2]: [movie_id#218, movie_id#218]
Join type: Inner
Join condition: None

(73) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#210, info#211]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,rating), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(74) Filter
Input [2]: [id#210, info#211]
Condition : ((isnotnull(info#211) AND (info#211 = rating)) AND isnotnull(id#210))

(75) Project
Output [1]: [id#210]
Input [2]: [id#210, info#211]

(76) BroadcastExchange
Input [1]: [id#210]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=31031]

(77) BroadcastHashJoin
Left keys [1]: [info_type_id#219]
Right keys [1]: [id#210]
Join type: Inner
Join condition: None

(78) Project
Output [6]: [name#24, movie_id#33, id#39, title#40, movie_id#218, info#220]
Input [8]: [name#24, movie_id#33, id#39, title#40, movie_id#218, info_type_id#219, info#220, id#210]

(79) Exchange
Input [6]: [name#24, movie_id#33, id#39, title#40, movie_id#218, info#220]
Arguments: hashpartitioning(movie_id#218, movie_id#33, id#39, 200), ENSURE_REQUIREMENTS, [plan_id=31037]

(80) Sort
Input [6]: [name#24, movie_id#33, id#39, title#40, movie_id#218, info#220]
Arguments: [movie_id#218 ASC NULLS FIRST, movie_id#33 ASC NULLS FIRST, id#39 ASC NULLS FIRST], false, 0

(81) SortMergeJoin
Left keys [3]: [movie_id#119, movie_id#119, movie_id#119]
Right keys [3]: [movie_id#218, movie_id#33, id#39]
Join type: Inner
Join condition: None

(82) Project
Output [6]: [name#24, name#2013, info#220, info#2031, title#40, title#2034]
Input [10]: [movie_id#119, title#2034, name#2013, info#2031, name#24, movie_id#33, id#39, title#40, movie_id#218, info#220]

(83) SortAggregate
Input [6]: [name#24, name#2013, info#220, info#2031, title#40, title#2034]
Keys: []
Functions [6]: [partial_min(name#24), partial_min(name#2013), partial_min(info#220), partial_min(info#2031), partial_min(title#40), partial_min(title#2034)]
Aggregate Attributes [6]: [min#2057, min#2058, min#2059, min#2060, min#2061, min#2062]
Results [6]: [min#2063, min#2064, min#2065, min#2066, min#2067, min#2068]

(84) Exchange
Input [6]: [min#2063, min#2064, min#2065, min#2066, min#2067, min#2068]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=31044]

(85) SortAggregate
Input [6]: [min#2063, min#2064, min#2065, min#2066, min#2067, min#2068]
Keys: []
Functions [6]: [min(name#24), min(name#2013), min(info#220), min(info#2031), min(title#40), min(title#2034)]
Aggregate Attributes [6]: [min(name#24)#2051, min(name#2013)#2052, min(info#220)#2053, min(info#2031)#2054, min(title#40)#2055, min(title#2034)#2056]
Results [6]: [min(name#24)#2051 AS first_company#2001, min(name#2013)#2052 AS second_company#2002, min(info#220)#2053 AS first_rating#2003, min(info#2031)#2054 AS second_rating#2004, min(title#40)#2055 AS first_movie#2005, min(title#2034)#2056 AS second_movie#2006]

(86) AdaptiveSparkPlan
Output [6]: [first_company#2001, second_company#2002, first_rating#2003, second_rating#2004, first_movie#2005, second_movie#2006]
Arguments: isFinalPlan=false
Execution Time: 40.962
