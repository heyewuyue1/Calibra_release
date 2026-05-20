== Physical Plan ==
AdaptiveSparkPlan (89)
+- SortAggregate (88)
   +- Exchange (87)
      +- SortAggregate (86)
         +- Project (85)
            +- SortMergeJoin Inner (84)
               :- Sort (73)
               :  +- Exchange (72)
               :     +- Project (71)
               :        +- SortMergeJoin Inner (70)
               :           :- Sort (64)
               :           :  +- Exchange (63)
               :           :     +- SortMergeJoin Inner (62)
               :           :        :- Sort (57)
               :           :        :  +- Exchange (56)
               :           :        :     +- Project (55)
               :           :        :        +- SortMergeJoin Inner (54)
               :           :        :           :- Sort (49)
               :           :        :           :  +- Exchange (48)
               :           :        :           :     +- Project (47)
               :           :        :           :        +- SortMergeJoin Inner (46)
               :           :        :           :           :- Sort (41)
               :           :        :           :           :  +- Exchange (40)
               :           :        :           :           :     +- Project (39)
               :           :        :           :           :        +- BroadcastHashJoin Inner BuildRight (38)
               :           :        :           :           :           :- BroadcastHashJoin Inner BuildLeft (33)
               :           :        :           :           :           :  :- BroadcastExchange (30)
               :           :        :           :           :           :  :  +- Project (29)
               :           :        :           :           :           :  :     +- BroadcastHashJoin Inner BuildRight (28)
               :           :        :           :           :           :  :        :- BroadcastHashJoin Inner BuildLeft (23)
               :           :        :           :           :           :  :        :  :- BroadcastExchange (20)
               :           :        :           :           :           :  :        :  :  +- Project (19)
               :           :        :           :           :           :  :        :  :     +- BroadcastHashJoin Inner BuildRight (18)
               :           :        :           :           :           :  :        :  :        :- BroadcastHashJoin Inner BuildLeft (13)
               :           :        :           :           :           :  :        :  :        :  :- BroadcastExchange (9)
               :           :        :           :           :           :  :        :  :        :  :  +- Project (8)
               :           :        :           :           :           :  :        :  :        :  :     +- BroadcastHashJoin Inner BuildRight (7)
               :           :        :           :           :           :  :        :  :        :  :        :- Filter (2)
               :           :        :           :           :           :  :        :  :        :  :        :  +- Scan parquet spark_catalog.imdb_10x.movie_link (1)
               :           :        :           :           :           :  :        :  :        :  :        +- BroadcastExchange (6)
               :           :        :           :           :           :  :        :  :        :  :           +- Project (5)
               :           :        :           :           :           :  :        :  :        :  :              +- Filter (4)
               :           :        :           :           :           :  :        :  :        :  :                 +- Scan parquet spark_catalog.imdb_10x.link_type (3)
               :           :        :           :           :           :  :        :  :        :  +- Project (12)
               :           :        :           :           :           :  :        :  :        :     +- Filter (11)
               :           :        :           :           :           :  :        :  :        :        +- Scan parquet spark_catalog.imdb_10x.title (10)
               :           :        :           :           :           :  :        :  :        +- BroadcastExchange (17)
               :           :        :           :           :           :  :        :  :           +- Project (16)
               :           :        :           :           :           :  :        :  :              +- Filter (15)
               :           :        :           :           :           :  :        :  :                 +- Scan parquet spark_catalog.imdb_10x.kind_type (14)
               :           :        :           :           :           :  :        :  +- Filter (22)
               :           :        :           :           :           :  :        :     +- Scan parquet spark_catalog.imdb_10x.title (21)
               :           :        :           :           :           :  :        +- BroadcastExchange (27)
               :           :        :           :           :           :  :           +- Project (26)
               :           :        :           :           :           :  :              +- Filter (25)
               :           :        :           :           :           :  :                 +- Scan parquet spark_catalog.imdb_10x.kind_type (24)
               :           :        :           :           :           :  +- Filter (32)
               :           :        :           :           :           :     +- Scan parquet spark_catalog.imdb_10x.movie_info_idx (31)
               :           :        :           :           :           +- BroadcastExchange (37)
               :           :        :           :           :              +- Project (36)
               :           :        :           :           :                 +- Filter (35)
               :           :        :           :           :                    +- Scan parquet spark_catalog.imdb_10x.info_type (34)
               :           :        :           :           +- Sort (45)
               :           :        :           :              +- Exchange (44)
               :           :        :           :                 +- Filter (43)
               :           :        :           :                    +- Scan parquet spark_catalog.imdb_10x.movie_companies (42)
               :           :        :           +- Sort (53)
               :           :        :              +- Exchange (52)
               :           :        :                 +- Filter (51)
               :           :        :                    +- Scan parquet spark_catalog.imdb_10x.company_name (50)
               :           :        +- Sort (61)
               :           :           +- Exchange (60)
               :           :              +- Filter (59)
               :           :                 +- Scan parquet spark_catalog.imdb_10x.movie_companies (58)
               :           +- Sort (69)
               :              +- Exchange (68)
               :                 +- Project (67)
               :                    +- Filter (66)
               :                       +- Scan parquet spark_catalog.imdb_10x.company_name (65)
               +- Sort (83)
                  +- Exchange (82)
                     +- Project (81)
                        +- BroadcastHashJoin Inner BuildRight (80)
                           :- Filter (75)
                           :  +- Scan parquet spark_catalog.imdb_10x.movie_info_idx (74)
                           +- BroadcastExchange (79)
                              +- Project (78)
                                 +- Filter (77)
                                    +- Scan parquet spark_catalog.imdb_10x.info_type (76)


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
PushedFilters: [In(link, [followed by,follows,sequel]), IsNotNull(id)]
ReadSchema: struct<id:int,link:string>

(4) Filter
Input [2]: [id#113, link#114]
Condition : (link#114 IN (sequel,follows,followed by) AND isnotnull(id#113))

(5) Project
Output [1]: [id#113]
Input [2]: [id#113, link#114]

(6) BroadcastExchange
Input [1]: [id#113]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=31527]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[1, int, true] as bigint)),false), [plan_id=31531]

(10) Scan parquet spark_catalog.imdb_10x.title
Output [4]: [id#2105, title#2106, kind_id#2108, production_year#2109]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id), IsNotNull(kind_id)]
ReadSchema: struct<id:int,title:string,kind_id:int,production_year:string>

(11) Filter
Input [4]: [id#2105, title#2106, kind_id#2108, production_year#2109]
Condition : ((((isnotnull(production_year#2109) AND (cast(production_year#2109 as int) >= 2000)) AND (cast(production_year#2109 as int) <= 2010)) AND isnotnull(id#2105)) AND isnotnull(kind_id#2108))

(12) Project
Output [3]: [id#2105, title#2106, kind_id#2108]
Input [4]: [id#2105, title#2106, kind_id#2108, production_year#2109]

(13) BroadcastHashJoin
Left keys [1]: [linked_movie_id#120]
Right keys [1]: [id#2105]
Join type: Inner
Join condition: None

(14) Scan parquet spark_catalog.imdb_10x.kind_type
Output [2]: [id#2093, kind#2094]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/kind_type]
PushedFilters: [In(kind, [episode,tv series]), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(15) Filter
Input [2]: [id#2093, kind#2094]
Condition : (kind#2094 IN (tv series,episode) AND isnotnull(id#2093))

(16) Project
Output [1]: [id#2093]
Input [2]: [id#2093, kind#2094]

(17) BroadcastExchange
Input [1]: [id#2093]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=31534]

(18) BroadcastHashJoin
Left keys [1]: [kind_id#2108]
Right keys [1]: [id#2093]
Join type: Inner
Join condition: None

(19) Project
Output [4]: [movie_id#119, linked_movie_id#120, id#2105, title#2106]
Input [6]: [movie_id#119, linked_movie_id#120, id#2105, title#2106, kind_id#2108, id#2093]

(20) BroadcastExchange
Input [4]: [movie_id#119, linked_movie_id#120, id#2105, title#2106]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=31538]

(21) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#39, title#40, kind_id#42]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(id), IsNotNull(kind_id)]
ReadSchema: struct<id:int,title:string,kind_id:int>

(22) Filter
Input [3]: [id#39, title#40, kind_id#42]
Condition : (isnotnull(id#39) AND isnotnull(kind_id#42))

(23) BroadcastHashJoin
Left keys [1]: [movie_id#119]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(24) Scan parquet spark_catalog.imdb_10x.kind_type
Output [2]: [id#293, kind#294]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/kind_type]
PushedFilters: [In(kind, [episode,tv series]), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(25) Filter
Input [2]: [id#293, kind#294]
Condition : (kind#294 IN (tv series,episode) AND isnotnull(id#293))

(26) Project
Output [1]: [id#293]
Input [2]: [id#293, kind#294]

(27) BroadcastExchange
Input [1]: [id#293]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=31541]

(28) BroadcastHashJoin
Left keys [1]: [kind_id#42]
Right keys [1]: [id#293]
Join type: Inner
Join condition: None

(29) Project
Output [6]: [movie_id#119, linked_movie_id#120, id#2105, title#2106, id#39, title#40]
Input [8]: [movie_id#119, linked_movie_id#120, id#2105, title#2106, id#39, title#40, kind_id#42, id#293]

(30) BroadcastExchange
Input [6]: [movie_id#119, linked_movie_id#120, id#2105, title#2106, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[1, int, true] as bigint), 32) | (cast(input[2, int, true] as bigint) & 4294967295))),false), [plan_id=31545]

(31) Scan parquet spark_catalog.imdb_10x.movie_info_idx
Output [3]: [movie_id#2101, info_type_id#2102, info#2103]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info_idx]
PushedFilters: [IsNotNull(info), LessThan(info,3.5), IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(32) Filter
Input [3]: [movie_id#2101, info_type_id#2102, info#2103]
Condition : (((isnotnull(info#2103) AND (info#2103 < 3.5)) AND isnotnull(movie_id#2101)) AND isnotnull(info_type_id#2102))

(33) BroadcastHashJoin
Left keys [2]: [linked_movie_id#120, id#2105]
Right keys [2]: [movie_id#2101, movie_id#2101]
Join type: Inner
Join condition: None

(34) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#2091, info#2092]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,rating), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(35) Filter
Input [2]: [id#2091, info#2092]
Condition : ((isnotnull(info#2092) AND (info#2092 = rating)) AND isnotnull(id#2091))

(36) Project
Output [1]: [id#2091]
Input [2]: [id#2091, info#2092]

(37) BroadcastExchange
Input [1]: [id#2091]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=31548]

(38) BroadcastHashJoin
Left keys [1]: [info_type_id#2102]
Right keys [1]: [id#2091]
Join type: Inner
Join condition: None

(39) Project
Output [8]: [movie_id#119, linked_movie_id#120, id#2105, title#2106, id#39, title#40, movie_id#2101, info#2103]
Input [10]: [movie_id#119, linked_movie_id#120, id#2105, title#2106, id#39, title#40, movie_id#2101, info_type_id#2102, info#2103, id#2091]

(40) Exchange
Input [8]: [movie_id#119, linked_movie_id#120, id#2105, title#2106, id#39, title#40, movie_id#2101, info#2103]
Arguments: hashpartitioning(linked_movie_id#120, movie_id#2101, id#2105, 200), ENSURE_REQUIREMENTS, [plan_id=31553]

(41) Sort
Input [8]: [movie_id#119, linked_movie_id#120, id#2105, title#2106, id#39, title#40, movie_id#2101, info#2103]
Arguments: [linked_movie_id#120 ASC NULLS FIRST, movie_id#2101 ASC NULLS FIRST, id#2105 ASC NULLS FIRST], false, 0

(42) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [2]: [movie_id#2096, company_id#2097]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(movie_id), IsNotNull(company_id)]
ReadSchema: struct<movie_id:int,company_id:int>

(43) Filter
Input [2]: [movie_id#2096, company_id#2097]
Condition : (isnotnull(movie_id#2096) AND isnotnull(company_id#2097))

(44) Exchange
Input [2]: [movie_id#2096, company_id#2097]
Arguments: hashpartitioning(movie_id#2096, movie_id#2096, movie_id#2096, 200), ENSURE_REQUIREMENTS, [plan_id=31554]

(45) Sort
Input [2]: [movie_id#2096, company_id#2097]
Arguments: [movie_id#2096 ASC NULLS FIRST, movie_id#2096 ASC NULLS FIRST, movie_id#2096 ASC NULLS FIRST], false, 0

(46) SortMergeJoin
Left keys [3]: [linked_movie_id#120, movie_id#2101, id#2105]
Right keys [3]: [movie_id#2096, movie_id#2096, movie_id#2096]
Join type: Inner
Join condition: None

(47) Project
Output [6]: [movie_id#119, title#2106, id#39, title#40, info#2103, company_id#2097]
Input [10]: [movie_id#119, linked_movie_id#120, id#2105, title#2106, id#39, title#40, movie_id#2101, info#2103, movie_id#2096, company_id#2097]

(48) Exchange
Input [6]: [movie_id#119, title#2106, id#39, title#40, info#2103, company_id#2097]
Arguments: hashpartitioning(company_id#2097, 200), ENSURE_REQUIREMENTS, [plan_id=31561]

(49) Sort
Input [6]: [movie_id#119, title#2106, id#39, title#40, info#2103, company_id#2097]
Arguments: [company_id#2097 ASC NULLS FIRST], false, 0

(50) Scan parquet spark_catalog.imdb_10x.company_name
Output [2]: [id#2084, name#2085]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int,name:string>

(51) Filter
Input [2]: [id#2084, name#2085]
Condition : isnotnull(id#2084)

(52) Exchange
Input [2]: [id#2084, name#2085]
Arguments: hashpartitioning(id#2084, 200), ENSURE_REQUIREMENTS, [plan_id=31562]

(53) Sort
Input [2]: [id#2084, name#2085]
Arguments: [id#2084 ASC NULLS FIRST], false, 0

(54) SortMergeJoin
Left keys [1]: [company_id#2097]
Right keys [1]: [id#2084]
Join type: Inner
Join condition: None

(55) Project
Output [6]: [movie_id#119, title#2106, id#39, title#40, info#2103, name#2085]
Input [8]: [movie_id#119, title#2106, id#39, title#40, info#2103, company_id#2097, id#2084, name#2085]

(56) Exchange
Input [6]: [movie_id#119, title#2106, id#39, title#40, info#2103, name#2085]
Arguments: hashpartitioning(movie_id#119, id#39, 200), ENSURE_REQUIREMENTS, [plan_id=31569]

(57) Sort
Input [6]: [movie_id#119, title#2106, id#39, title#40, info#2103, name#2085]
Arguments: [movie_id#119 ASC NULLS FIRST, id#39 ASC NULLS FIRST], false, 0

(58) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [2]: [movie_id#33, company_id#34]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(company_id), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,company_id:int>

(59) Filter
Input [2]: [movie_id#33, company_id#34]
Condition : (isnotnull(company_id#34) AND isnotnull(movie_id#33))

(60) Exchange
Input [2]: [movie_id#33, company_id#34]
Arguments: hashpartitioning(movie_id#33, movie_id#33, 200), ENSURE_REQUIREMENTS, [plan_id=31570]

(61) Sort
Input [2]: [movie_id#33, company_id#34]
Arguments: [movie_id#33 ASC NULLS FIRST, movie_id#33 ASC NULLS FIRST], false, 0

(62) SortMergeJoin
Left keys [2]: [movie_id#119, id#39]
Right keys [2]: [movie_id#33, movie_id#33]
Join type: Inner
Join condition: None

(63) Exchange
Input [8]: [movie_id#119, title#2106, id#39, title#40, info#2103, name#2085, movie_id#33, company_id#34]
Arguments: hashpartitioning(company_id#34, 200), ENSURE_REQUIREMENTS, [plan_id=31576]

(64) Sort
Input [8]: [movie_id#119, title#2106, id#39, title#40, info#2103, name#2085, movie_id#33, company_id#34]
Arguments: [company_id#34 ASC NULLS FIRST], false, 0

(65) Scan parquet spark_catalog.imdb_10x.company_name
Output [3]: [id#23, name#24, country_code#25]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(country_code), Not(EqualTo(country_code,[us])), IsNotNull(id)]
ReadSchema: struct<id:int,name:string,country_code:string>

(66) Filter
Input [3]: [id#23, name#24, country_code#25]
Condition : ((isnotnull(country_code#25) AND NOT (country_code#25 = [us])) AND isnotnull(id#23))

(67) Project
Output [2]: [id#23, name#24]
Input [3]: [id#23, name#24, country_code#25]

(68) Exchange
Input [2]: [id#23, name#24]
Arguments: hashpartitioning(id#23, 200), ENSURE_REQUIREMENTS, [plan_id=31577]

(69) Sort
Input [2]: [id#23, name#24]
Arguments: [id#23 ASC NULLS FIRST], false, 0

(70) SortMergeJoin
Left keys [1]: [company_id#34]
Right keys [1]: [id#23]
Join type: Inner
Join condition: None

(71) Project
Output [8]: [movie_id#119, title#2106, id#39, title#40, info#2103, name#2085, movie_id#33, name#24]
Input [10]: [movie_id#119, title#2106, id#39, title#40, info#2103, name#2085, movie_id#33, company_id#34, id#23, name#24]

(72) Exchange
Input [8]: [movie_id#119, title#2106, id#39, title#40, info#2103, name#2085, movie_id#33, name#24]
Arguments: hashpartitioning(movie_id#33, movie_id#119, id#39, 200), ENSURE_REQUIREMENTS, [plan_id=31587]

(73) Sort
Input [8]: [movie_id#119, title#2106, id#39, title#40, info#2103, name#2085, movie_id#33, name#24]
Arguments: [movie_id#33 ASC NULLS FIRST, movie_id#119 ASC NULLS FIRST, id#39 ASC NULLS FIRST], false, 0

(74) Scan parquet spark_catalog.imdb_10x.movie_info_idx
Output [3]: [movie_id#218, info_type_id#219, info#220]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info_idx]
PushedFilters: [IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(75) Filter
Input [3]: [movie_id#218, info_type_id#219, info#220]
Condition : (isnotnull(movie_id#218) AND isnotnull(info_type_id#219))

(76) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#210, info#211]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,rating), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(77) Filter
Input [2]: [id#210, info#211]
Condition : ((isnotnull(info#211) AND (info#211 = rating)) AND isnotnull(id#210))

(78) Project
Output [1]: [id#210]
Input [2]: [id#210, info#211]

(79) BroadcastExchange
Input [1]: [id#210]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=31582]

(80) BroadcastHashJoin
Left keys [1]: [info_type_id#219]
Right keys [1]: [id#210]
Join type: Inner
Join condition: None

(81) Project
Output [2]: [movie_id#218, info#220]
Input [4]: [movie_id#218, info_type_id#219, info#220, id#210]

(82) Exchange
Input [2]: [movie_id#218, info#220]
Arguments: hashpartitioning(movie_id#218, movie_id#218, movie_id#218, 200), ENSURE_REQUIREMENTS, [plan_id=31588]

(83) Sort
Input [2]: [movie_id#218, info#220]
Arguments: [movie_id#218 ASC NULLS FIRST, movie_id#218 ASC NULLS FIRST, movie_id#218 ASC NULLS FIRST], false, 0

(84) SortMergeJoin
Left keys [3]: [movie_id#33, movie_id#119, id#39]
Right keys [3]: [movie_id#218, movie_id#218, movie_id#218]
Join type: Inner
Join condition: None

(85) Project
Output [6]: [name#24, name#2085, info#220, info#2103, title#40, title#2106]
Input [10]: [movie_id#119, title#2106, id#39, title#40, info#2103, name#2085, movie_id#33, name#24, movie_id#218, info#220]

(86) SortAggregate
Input [6]: [name#24, name#2085, info#220, info#2103, title#40, title#2106]
Keys: []
Functions [6]: [partial_min(name#24), partial_min(name#2085), partial_min(info#220), partial_min(info#2103), partial_min(title#40), partial_min(title#2106)]
Aggregate Attributes [6]: [min#2129, min#2130, min#2131, min#2132, min#2133, min#2134]
Results [6]: [min#2135, min#2136, min#2137, min#2138, min#2139, min#2140]

(87) Exchange
Input [6]: [min#2135, min#2136, min#2137, min#2138, min#2139, min#2140]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=31595]

(88) SortAggregate
Input [6]: [min#2135, min#2136, min#2137, min#2138, min#2139, min#2140]
Keys: []
Functions [6]: [min(name#24), min(name#2085), min(info#220), min(info#2103), min(title#40), min(title#2106)]
Aggregate Attributes [6]: [min(name#24)#2123, min(name#2085)#2124, min(info#220)#2125, min(info#2103)#2126, min(title#40)#2127, min(title#2106)#2128]
Results [6]: [min(name#24)#2123 AS first_company#2073, min(name#2085)#2124 AS second_company#2074, min(info#220)#2125 AS first_rating#2075, min(info#2103)#2126 AS second_rating#2076, min(title#40)#2127 AS first_movie#2077, min(title#2106)#2128 AS second_movie#2078]

(89) AdaptiveSparkPlan
Output [6]: [first_company#2073, second_company#2074, first_rating#2075, second_rating#2076, first_movie#2077, second_movie#2078]
Arguments: isFinalPlan=false
Execution Time: 32.846
