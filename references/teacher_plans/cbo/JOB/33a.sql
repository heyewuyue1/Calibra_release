== Physical Plan ==
AdaptiveSparkPlan (83)
+- SortAggregate (82)
   +- Exchange (81)
      +- SortAggregate (80)
         +- Project (79)
            +- SortMergeJoin Inner (78)
               :- Sort (57)
               :  +- Exchange (56)
               :     +- Project (55)
               :        +- SortMergeJoin Inner (54)
               :           :- Sort (49)
               :           :  +- Exchange (48)
               :           :     +- Project (47)
               :           :        +- SortMergeJoin Inner (46)
               :           :           :- Sort (41)
               :           :           :  +- Exchange (40)
               :           :           :     +- Project (39)
               :           :           :        +- BroadcastHashJoin Inner BuildRight (38)
               :           :           :           :- BroadcastHashJoin Inner BuildLeft (33)
               :           :           :           :  :- BroadcastExchange (30)
               :           :           :           :  :  +- Project (29)
               :           :           :           :  :     +- BroadcastHashJoin Inner BuildRight (28)
               :           :           :           :  :        :- BroadcastHashJoin Inner BuildLeft (23)
               :           :           :           :  :        :  :- BroadcastExchange (20)
               :           :           :           :  :        :  :  +- Project (19)
               :           :           :           :  :        :  :     +- BroadcastHashJoin Inner BuildRight (18)
               :           :           :           :  :        :  :        :- BroadcastHashJoin Inner BuildLeft (13)
               :           :           :           :  :        :  :        :  :- BroadcastExchange (9)
               :           :           :           :  :        :  :        :  :  +- Project (8)
               :           :           :           :  :        :  :        :  :     +- BroadcastHashJoin Inner BuildRight (7)
               :           :           :           :  :        :  :        :  :        :- Filter (2)
               :           :           :           :  :        :  :        :  :        :  +- Scan parquet spark_catalog.imdb_10x.movie_link (1)
               :           :           :           :  :        :  :        :  :        +- BroadcastExchange (6)
               :           :           :           :  :        :  :        :  :           +- Project (5)
               :           :           :           :  :        :  :        :  :              +- Filter (4)
               :           :           :           :  :        :  :        :  :                 +- Scan parquet spark_catalog.imdb_10x.link_type (3)
               :           :           :           :  :        :  :        :  +- Project (12)
               :           :           :           :  :        :  :        :     +- Filter (11)
               :           :           :           :  :        :  :        :        +- Scan parquet spark_catalog.imdb_10x.title (10)
               :           :           :           :  :        :  :        +- BroadcastExchange (17)
               :           :           :           :  :        :  :           +- Project (16)
               :           :           :           :  :        :  :              +- Filter (15)
               :           :           :           :  :        :  :                 +- Scan parquet spark_catalog.imdb_10x.kind_type (14)
               :           :           :           :  :        :  +- Filter (22)
               :           :           :           :  :        :     +- Scan parquet spark_catalog.imdb_10x.title (21)
               :           :           :           :  :        +- BroadcastExchange (27)
               :           :           :           :  :           +- Project (26)
               :           :           :           :  :              +- Filter (25)
               :           :           :           :  :                 +- Scan parquet spark_catalog.imdb_10x.kind_type (24)
               :           :           :           :  +- Filter (32)
               :           :           :           :     +- Scan parquet spark_catalog.imdb_10x.movie_info_idx (31)
               :           :           :           +- BroadcastExchange (37)
               :           :           :              +- Project (36)
               :           :           :                 +- Filter (35)
               :           :           :                    +- Scan parquet spark_catalog.imdb_10x.info_type (34)
               :           :           +- Sort (45)
               :           :              +- Exchange (44)
               :           :                 +- Filter (43)
               :           :                    +- Scan parquet spark_catalog.imdb_10x.movie_companies (42)
               :           +- Sort (53)
               :              +- Exchange (52)
               :                 +- Filter (51)
               :                    +- Scan parquet spark_catalog.imdb_10x.company_name (50)
               +- Sort (77)
                  +- Exchange (76)
                     +- Project (75)
                        +- BroadcastHashJoin Inner BuildRight (74)
                           :- BroadcastHashJoin Inner BuildLeft (69)
                           :  :- BroadcastExchange (66)
                           :  :  +- Project (65)
                           :  :     +- BroadcastHashJoin Inner BuildLeft (64)
                           :  :        :- BroadcastExchange (61)
                           :  :        :  +- Project (60)
                           :  :        :     +- Filter (59)
                           :  :        :        +- Scan parquet spark_catalog.imdb_10x.company_name (58)
                           :  :        +- Filter (63)
                           :  :           +- Scan parquet spark_catalog.imdb_10x.movie_companies (62)
                           :  +- Filter (68)
                           :     +- Scan parquet spark_catalog.imdb_10x.movie_info_idx (67)
                           +- BroadcastExchange (73)
                              +- Project (72)
                                 +- Filter (71)
                                    +- Scan parquet spark_catalog.imdb_10x.info_type (70)


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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=30438]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[1, int, true] as bigint)),false), [plan_id=30442]

(10) Scan parquet spark_catalog.imdb_10x.title
Output [4]: [id#1961, title#1962, kind_id#1964, production_year#1965]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id), IsNotNull(kind_id)]
ReadSchema: struct<id:int,title:string,kind_id:int,production_year:string>

(11) Filter
Input [4]: [id#1961, title#1962, kind_id#1964, production_year#1965]
Condition : ((((isnotnull(production_year#1965) AND (cast(production_year#1965 as int) >= 2005)) AND (cast(production_year#1965 as int) <= 2008)) AND isnotnull(id#1961)) AND isnotnull(kind_id#1964))

(12) Project
Output [3]: [id#1961, title#1962, kind_id#1964]
Input [4]: [id#1961, title#1962, kind_id#1964, production_year#1965]

(13) BroadcastHashJoin
Left keys [1]: [linked_movie_id#120]
Right keys [1]: [id#1961]
Join type: Inner
Join condition: None

(14) Scan parquet spark_catalog.imdb_10x.kind_type
Output [2]: [id#1949, kind#1950]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/kind_type]
PushedFilters: [IsNotNull(kind), EqualTo(kind,tv series), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(15) Filter
Input [2]: [id#1949, kind#1950]
Condition : ((isnotnull(kind#1950) AND (kind#1950 = tv series)) AND isnotnull(id#1949))

(16) Project
Output [1]: [id#1949]
Input [2]: [id#1949, kind#1950]

(17) BroadcastExchange
Input [1]: [id#1949]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=30445]

(18) BroadcastHashJoin
Left keys [1]: [kind_id#1964]
Right keys [1]: [id#1949]
Join type: Inner
Join condition: None

(19) Project
Output [4]: [movie_id#119, linked_movie_id#120, id#1961, title#1962]
Input [6]: [movie_id#119, linked_movie_id#120, id#1961, title#1962, kind_id#1964, id#1949]

(20) BroadcastExchange
Input [4]: [movie_id#119, linked_movie_id#120, id#1961, title#1962]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=30449]

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
PushedFilters: [IsNotNull(kind), EqualTo(kind,tv series), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(25) Filter
Input [2]: [id#293, kind#294]
Condition : ((isnotnull(kind#294) AND (kind#294 = tv series)) AND isnotnull(id#293))

(26) Project
Output [1]: [id#293]
Input [2]: [id#293, kind#294]

(27) BroadcastExchange
Input [1]: [id#293]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=30452]

(28) BroadcastHashJoin
Left keys [1]: [kind_id#42]
Right keys [1]: [id#293]
Join type: Inner
Join condition: None

(29) Project
Output [6]: [movie_id#119, linked_movie_id#120, id#1961, title#1962, id#39, title#40]
Input [8]: [movie_id#119, linked_movie_id#120, id#1961, title#1962, id#39, title#40, kind_id#42, id#293]

(30) BroadcastExchange
Input [6]: [movie_id#119, linked_movie_id#120, id#1961, title#1962, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[1, int, true] as bigint), 32) | (cast(input[2, int, true] as bigint) & 4294967295))),false), [plan_id=30456]

(31) Scan parquet spark_catalog.imdb_10x.movie_info_idx
Output [3]: [movie_id#1957, info_type_id#1958, info#1959]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info_idx]
PushedFilters: [IsNotNull(info), LessThan(info,3.0), IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(32) Filter
Input [3]: [movie_id#1957, info_type_id#1958, info#1959]
Condition : (((isnotnull(info#1959) AND (info#1959 < 3.0)) AND isnotnull(movie_id#1957)) AND isnotnull(info_type_id#1958))

(33) BroadcastHashJoin
Left keys [2]: [linked_movie_id#120, id#1961]
Right keys [2]: [movie_id#1957, movie_id#1957]
Join type: Inner
Join condition: None

(34) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#1947, info#1948]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,rating), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(35) Filter
Input [2]: [id#1947, info#1948]
Condition : ((isnotnull(info#1948) AND (info#1948 = rating)) AND isnotnull(id#1947))

(36) Project
Output [1]: [id#1947]
Input [2]: [id#1947, info#1948]

(37) BroadcastExchange
Input [1]: [id#1947]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=30459]

(38) BroadcastHashJoin
Left keys [1]: [info_type_id#1958]
Right keys [1]: [id#1947]
Join type: Inner
Join condition: None

(39) Project
Output [8]: [movie_id#119, linked_movie_id#120, id#1961, title#1962, id#39, title#40, movie_id#1957, info#1959]
Input [10]: [movie_id#119, linked_movie_id#120, id#1961, title#1962, id#39, title#40, movie_id#1957, info_type_id#1958, info#1959, id#1947]

(40) Exchange
Input [8]: [movie_id#119, linked_movie_id#120, id#1961, title#1962, id#39, title#40, movie_id#1957, info#1959]
Arguments: hashpartitioning(linked_movie_id#120, movie_id#1957, id#1961, 200), ENSURE_REQUIREMENTS, [plan_id=30464]

(41) Sort
Input [8]: [movie_id#119, linked_movie_id#120, id#1961, title#1962, id#39, title#40, movie_id#1957, info#1959]
Arguments: [linked_movie_id#120 ASC NULLS FIRST, movie_id#1957 ASC NULLS FIRST, id#1961 ASC NULLS FIRST], false, 0

(42) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [2]: [movie_id#1952, company_id#1953]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(movie_id), IsNotNull(company_id)]
ReadSchema: struct<movie_id:int,company_id:int>

(43) Filter
Input [2]: [movie_id#1952, company_id#1953]
Condition : (isnotnull(movie_id#1952) AND isnotnull(company_id#1953))

(44) Exchange
Input [2]: [movie_id#1952, company_id#1953]
Arguments: hashpartitioning(movie_id#1952, movie_id#1952, movie_id#1952, 200), ENSURE_REQUIREMENTS, [plan_id=30465]

(45) Sort
Input [2]: [movie_id#1952, company_id#1953]
Arguments: [movie_id#1952 ASC NULLS FIRST, movie_id#1952 ASC NULLS FIRST, movie_id#1952 ASC NULLS FIRST], false, 0

(46) SortMergeJoin
Left keys [3]: [linked_movie_id#120, movie_id#1957, id#1961]
Right keys [3]: [movie_id#1952, movie_id#1952, movie_id#1952]
Join type: Inner
Join condition: None

(47) Project
Output [6]: [movie_id#119, title#1962, id#39, title#40, info#1959, company_id#1953]
Input [10]: [movie_id#119, linked_movie_id#120, id#1961, title#1962, id#39, title#40, movie_id#1957, info#1959, movie_id#1952, company_id#1953]

(48) Exchange
Input [6]: [movie_id#119, title#1962, id#39, title#40, info#1959, company_id#1953]
Arguments: hashpartitioning(company_id#1953, 200), ENSURE_REQUIREMENTS, [plan_id=30472]

(49) Sort
Input [6]: [movie_id#119, title#1962, id#39, title#40, info#1959, company_id#1953]
Arguments: [company_id#1953 ASC NULLS FIRST], false, 0

(50) Scan parquet spark_catalog.imdb_10x.company_name
Output [2]: [id#1940, name#1941]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int,name:string>

(51) Filter
Input [2]: [id#1940, name#1941]
Condition : isnotnull(id#1940)

(52) Exchange
Input [2]: [id#1940, name#1941]
Arguments: hashpartitioning(id#1940, 200), ENSURE_REQUIREMENTS, [plan_id=30473]

(53) Sort
Input [2]: [id#1940, name#1941]
Arguments: [id#1940 ASC NULLS FIRST], false, 0

(54) SortMergeJoin
Left keys [1]: [company_id#1953]
Right keys [1]: [id#1940]
Join type: Inner
Join condition: None

(55) Project
Output [6]: [movie_id#119, title#1962, id#39, title#40, info#1959, name#1941]
Input [8]: [movie_id#119, title#1962, id#39, title#40, info#1959, company_id#1953, id#1940, name#1941]

(56) Exchange
Input [6]: [movie_id#119, title#1962, id#39, title#40, info#1959, name#1941]
Arguments: hashpartitioning(movie_id#119, movie_id#119, id#39, id#39, 200), ENSURE_REQUIREMENTS, [plan_id=30490]

(57) Sort
Input [6]: [movie_id#119, title#1962, id#39, title#40, info#1959, name#1941]
Arguments: [movie_id#119 ASC NULLS FIRST, movie_id#119 ASC NULLS FIRST, id#39 ASC NULLS FIRST, id#39 ASC NULLS FIRST], false, 0

(58) Scan parquet spark_catalog.imdb_10x.company_name
Output [3]: [id#23, name#24, country_code#25]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(country_code), EqualTo(country_code,[us]), IsNotNull(id)]
ReadSchema: struct<id:int,name:string,country_code:string>

(59) Filter
Input [3]: [id#23, name#24, country_code#25]
Condition : ((isnotnull(country_code#25) AND (country_code#25 = [us])) AND isnotnull(id#23))

(60) Project
Output [2]: [id#23, name#24]
Input [3]: [id#23, name#24, country_code#25]

(61) BroadcastExchange
Input [2]: [id#23, name#24]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=30478]

(62) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [2]: [movie_id#33, company_id#34]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(company_id), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,company_id:int>

(63) Filter
Input [2]: [movie_id#33, company_id#34]
Condition : (isnotnull(company_id#34) AND isnotnull(movie_id#33))

(64) BroadcastHashJoin
Left keys [1]: [id#23]
Right keys [1]: [company_id#34]
Join type: Inner
Join condition: None

(65) Project
Output [2]: [name#24, movie_id#33]
Input [4]: [id#23, name#24, movie_id#33, company_id#34]

(66) BroadcastExchange
Input [2]: [name#24, movie_id#33]
Arguments: HashedRelationBroadcastMode(List(cast(input[1, int, true] as bigint)),false), [plan_id=30482]

(67) Scan parquet spark_catalog.imdb_10x.movie_info_idx
Output [3]: [movie_id#218, info_type_id#219, info#220]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info_idx]
PushedFilters: [IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(68) Filter
Input [3]: [movie_id#218, info_type_id#219, info#220]
Condition : (isnotnull(movie_id#218) AND isnotnull(info_type_id#219))

(69) BroadcastHashJoin
Left keys [1]: [movie_id#33]
Right keys [1]: [movie_id#218]
Join type: Inner
Join condition: None

(70) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#210, info#211]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,rating), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(71) Filter
Input [2]: [id#210, info#211]
Condition : ((isnotnull(info#211) AND (info#211 = rating)) AND isnotnull(id#210))

(72) Project
Output [1]: [id#210]
Input [2]: [id#210, info#211]

(73) BroadcastExchange
Input [1]: [id#210]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=30485]

(74) BroadcastHashJoin
Left keys [1]: [info_type_id#219]
Right keys [1]: [id#210]
Join type: Inner
Join condition: None

(75) Project
Output [4]: [name#24, movie_id#33, movie_id#218, info#220]
Input [6]: [name#24, movie_id#33, movie_id#218, info_type_id#219, info#220, id#210]

(76) Exchange
Input [4]: [name#24, movie_id#33, movie_id#218, info#220]
Arguments: hashpartitioning(movie_id#218, movie_id#33, movie_id#218, movie_id#33, 200), ENSURE_REQUIREMENTS, [plan_id=30491]

(77) Sort
Input [4]: [name#24, movie_id#33, movie_id#218, info#220]
Arguments: [movie_id#218 ASC NULLS FIRST, movie_id#33 ASC NULLS FIRST, movie_id#218 ASC NULLS FIRST, movie_id#33 ASC NULLS FIRST], false, 0

(78) SortMergeJoin
Left keys [4]: [movie_id#119, movie_id#119, id#39, id#39]
Right keys [4]: [movie_id#218, movie_id#33, movie_id#218, movie_id#33]
Join type: Inner
Join condition: None

(79) Project
Output [6]: [name#24, name#1941, info#220, info#1959, title#40, title#1962]
Input [10]: [movie_id#119, title#1962, id#39, title#40, info#1959, name#1941, name#24, movie_id#33, movie_id#218, info#220]

(80) SortAggregate
Input [6]: [name#24, name#1941, info#220, info#1959, title#40, title#1962]
Keys: []
Functions [6]: [partial_min(name#24), partial_min(name#1941), partial_min(info#220), partial_min(info#1959), partial_min(title#40), partial_min(title#1962)]
Aggregate Attributes [6]: [min#1985, min#1986, min#1987, min#1988, min#1989, min#1990]
Results [6]: [min#1991, min#1992, min#1993, min#1994, min#1995, min#1996]

(81) Exchange
Input [6]: [min#1991, min#1992, min#1993, min#1994, min#1995, min#1996]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=30498]

(82) SortAggregate
Input [6]: [min#1991, min#1992, min#1993, min#1994, min#1995, min#1996]
Keys: []
Functions [6]: [min(name#24), min(name#1941), min(info#220), min(info#1959), min(title#40), min(title#1962)]
Aggregate Attributes [6]: [min(name#24)#1979, min(name#1941)#1980, min(info#220)#1981, min(info#1959)#1982, min(title#40)#1983, min(title#1962)#1984]
Results [6]: [min(name#24)#1979 AS first_company#1929, min(name#1941)#1980 AS second_company#1930, min(info#220)#1981 AS first_rating#1931, min(info#1959)#1982 AS second_rating#1932, min(title#40)#1983 AS first_movie#1933, min(title#1962)#1984 AS second_movie#1934]

(83) AdaptiveSparkPlan
Output [6]: [first_company#1929, second_company#1930, first_rating#1931, second_rating#1932, first_movie#1933, second_movie#1934]
Arguments: isFinalPlan=false
Execution Time: 55.783
