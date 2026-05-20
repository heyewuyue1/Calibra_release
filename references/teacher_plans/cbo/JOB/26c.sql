== Physical Plan ==
AdaptiveSparkPlan (73)
+- SortAggregate (72)
   +- Exchange (71)
      +- SortAggregate (70)
         +- Project (69)
            +- SortMergeJoin Inner (68)
               :- Sort (63)
               :  +- Exchange (62)
               :     +- Project (61)
               :        +- SortMergeJoin Inner (60)
               :           :- Sort (43)
               :           :  +- Exchange (42)
               :           :     +- Project (41)
               :           :        +- SortMergeJoin Inner (40)
               :           :           :- Sort (35)
               :           :           :  +- Exchange (34)
               :           :           :     +- BroadcastHashJoin Inner BuildLeft (33)
               :           :           :        :- BroadcastExchange (30)
               :           :           :        :  +- Project (29)
               :           :           :        :     +- BroadcastHashJoin Inner BuildRight (28)
               :           :           :        :        :- BroadcastHashJoin Inner BuildLeft (23)
               :           :           :        :        :  :- BroadcastExchange (20)
               :           :           :        :        :  :  +- Project (19)
               :           :           :        :        :  :     +- BroadcastHashJoin Inner BuildRight (18)
               :           :           :        :        :  :        :- BroadcastHashJoin Inner BuildLeft (13)
               :           :           :        :        :  :        :  :- BroadcastExchange (9)
               :           :           :        :        :  :        :  :  +- Project (8)
               :           :           :        :        :  :        :  :     +- BroadcastHashJoin Inner BuildRight (7)
               :           :           :        :        :  :        :  :        :- Filter (2)
               :           :           :        :        :  :        :  :        :  +- Scan parquet spark_catalog.imdb_10x.movie_keyword (1)
               :           :           :        :        :  :        :  :        +- BroadcastExchange (6)
               :           :           :        :        :  :        :  :           +- Project (5)
               :           :           :        :        :  :        :  :              +- Filter (4)
               :           :           :        :        :  :        :  :                 +- Scan parquet spark_catalog.imdb_10x.keyword (3)
               :           :           :        :        :  :        :  +- Project (12)
               :           :           :        :        :  :        :     +- Filter (11)
               :           :           :        :        :  :        :        +- Scan parquet spark_catalog.imdb_10x.title (10)
               :           :           :        :        :  :        +- BroadcastExchange (17)
               :           :           :        :        :  :           +- Project (16)
               :           :           :        :        :  :              +- Filter (15)
               :           :           :        :        :  :                 +- Scan parquet spark_catalog.imdb_10x.kind_type (14)
               :           :           :        :        :  +- Filter (22)
               :           :           :        :        :     +- Scan parquet spark_catalog.imdb_10x.movie_info_idx (21)
               :           :           :        :        +- BroadcastExchange (27)
               :           :           :        :           +- Project (26)
               :           :           :        :              +- Filter (25)
               :           :           :        :                 +- Scan parquet spark_catalog.imdb_10x.info_type (24)
               :           :           :        +- Filter (32)
               :           :           :           +- Scan parquet spark_catalog.imdb_10x.cast_info (31)
               :           :           +- Sort (39)
               :           :              +- Exchange (38)
               :           :                 +- Filter (37)
               :           :                    +- Scan parquet spark_catalog.imdb_10x.name (36)
               :           +- Sort (59)
               :              +- Exchange (58)
               :                 +- Project (57)
               :                    +- BroadcastHashJoin Inner BuildRight (56)
               :                       :- Project (51)
               :                       :  +- BroadcastHashJoin Inner BuildRight (50)
               :                       :     :- Filter (45)
               :                       :     :  +- Scan parquet spark_catalog.imdb_10x.complete_cast (44)
               :                       :     +- BroadcastExchange (49)
               :                       :        +- Project (48)
               :                       :           +- Filter (47)
               :                       :              +- Scan parquet spark_catalog.imdb_10x.comp_cast_type (46)
               :                       +- BroadcastExchange (55)
               :                          +- Project (54)
               :                             +- Filter (53)
               :                                +- Scan parquet spark_catalog.imdb_10x.comp_cast_type (52)
               +- Sort (67)
                  +- Exchange (66)
                     +- Filter (65)
                        +- Scan parquet spark_catalog.imdb_10x.char_name (64)


(1) Scan parquet spark_catalog.imdb_10x.movie_keyword
Output [2]: [movie_id#116, keyword_id#117]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_keyword]
PushedFilters: [IsNotNull(movie_id), IsNotNull(keyword_id)]
ReadSchema: struct<movie_id:int,keyword_id:int>

(2) Filter
Input [2]: [movie_id#116, keyword_id#117]
Condition : (isnotnull(movie_id#116) AND isnotnull(keyword_id#117))

(3) Scan parquet spark_catalog.imdb_10x.keyword
Output [2]: [id#110, keyword#111]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/keyword]
PushedFilters: [In(keyword, [based-on-comic,claw,fight,laser,magnet,marvel-comics,superhero,tv-special,violence,web]), IsNotNull(id)]
ReadSchema: struct<id:int,keyword:string>

(4) Filter
Input [2]: [id#110, keyword#111]
Condition : (keyword#111 IN (superhero,marvel-comics,based-on-comic,tv-special,fight,violence,magnet,web,claw,laser) AND isnotnull(id#110))

(5) Project
Output [1]: [id#110]
Input [2]: [id#110, keyword#111]

(6) BroadcastExchange
Input [1]: [id#110]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=21205]

(7) BroadcastHashJoin
Left keys [1]: [keyword_id#117]
Right keys [1]: [id#110]
Join type: Inner
Join condition: None

(8) Project
Output [1]: [movie_id#116]
Input [3]: [movie_id#116, keyword_id#117, id#110]

(9) BroadcastExchange
Input [1]: [movie_id#116]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=21209]

(10) Scan parquet spark_catalog.imdb_10x.title
Output [4]: [id#39, title#40, kind_id#42, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id), IsNotNull(kind_id)]
ReadSchema: struct<id:int,title:string,kind_id:int,production_year:string>

(11) Filter
Input [4]: [id#39, title#40, kind_id#42, production_year#43]
Condition : (((isnotnull(production_year#43) AND (cast(production_year#43 as int) > 2000)) AND isnotnull(id#39)) AND isnotnull(kind_id#42))

(12) Project
Output [3]: [id#39, title#40, kind_id#42]
Input [4]: [id#39, title#40, kind_id#42, production_year#43]

(13) BroadcastHashJoin
Left keys [1]: [movie_id#116]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(14) Scan parquet spark_catalog.imdb_10x.kind_type
Output [2]: [id#293, kind#294]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/kind_type]
PushedFilters: [IsNotNull(kind), EqualTo(kind,movie), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(15) Filter
Input [2]: [id#293, kind#294]
Condition : ((isnotnull(kind#294) AND (kind#294 = movie)) AND isnotnull(id#293))

(16) Project
Output [1]: [id#293]
Input [2]: [id#293, kind#294]

(17) BroadcastExchange
Input [1]: [id#293]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=21212]

(18) BroadcastHashJoin
Left keys [1]: [kind_id#42]
Right keys [1]: [id#293]
Join type: Inner
Join condition: None

(19) Project
Output [3]: [movie_id#116, id#39, title#40]
Input [5]: [movie_id#116, id#39, title#40, kind_id#42, id#293]

(20) BroadcastExchange
Input [3]: [movie_id#116, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[1, int, true] as bigint) & 4294967295))),false), [plan_id=21216]

(21) Scan parquet spark_catalog.imdb_10x.movie_info_idx
Output [3]: [movie_id#218, info_type_id#219, info#220]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info_idx]
PushedFilters: [IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(22) Filter
Input [3]: [movie_id#218, info_type_id#219, info#220]
Condition : (isnotnull(movie_id#218) AND isnotnull(info_type_id#219))

(23) BroadcastHashJoin
Left keys [2]: [movie_id#116, id#39]
Right keys [2]: [movie_id#218, movie_id#218]
Join type: Inner
Join condition: None

(24) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#210, info#211]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,rating), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(25) Filter
Input [2]: [id#210, info#211]
Condition : ((isnotnull(info#211) AND (info#211 = rating)) AND isnotnull(id#210))

(26) Project
Output [1]: [id#210]
Input [2]: [id#210, info#211]

(27) BroadcastExchange
Input [1]: [id#210]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=21219]

(28) BroadcastHashJoin
Left keys [1]: [info_type_id#219]
Right keys [1]: [id#210]
Join type: Inner
Join condition: None

(29) Project
Output [5]: [movie_id#116, id#39, title#40, movie_id#218, info#220]
Input [7]: [movie_id#116, id#39, title#40, movie_id#218, info_type_id#219, info#220, id#210]

(30) BroadcastExchange
Input [5]: [movie_id#116, id#39, title#40, movie_id#218, info#220]
Arguments: HashedRelationBroadcastMode(List(input[3, int, true], input[0, int, true], input[1, int, true]),false), [plan_id=21223]

(31) Scan parquet spark_catalog.imdb_10x.cast_info
Output [3]: [person_id#17, movie_id#18, person_role_id#19]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/cast_info]
PushedFilters: [IsNotNull(movie_id), IsNotNull(person_id), IsNotNull(person_role_id)]
ReadSchema: struct<person_id:int,movie_id:int,person_role_id:string>

(32) Filter
Input [3]: [person_id#17, movie_id#18, person_role_id#19]
Condition : ((isnotnull(movie_id#18) AND isnotnull(person_id#17)) AND isnotnull(person_role_id#19))

(33) BroadcastHashJoin
Left keys [3]: [movie_id#218, movie_id#116, id#39]
Right keys [3]: [movie_id#18, movie_id#18, movie_id#18]
Join type: Inner
Join condition: None

(34) Exchange
Input [8]: [movie_id#116, id#39, title#40, movie_id#218, info#220, person_id#17, movie_id#18, person_role_id#19]
Arguments: hashpartitioning(person_id#17, 200), ENSURE_REQUIREMENTS, [plan_id=21227]

(35) Sort
Input [8]: [movie_id#116, id#39, title#40, movie_id#218, info#220, person_id#17, movie_id#18, person_role_id#19]
Arguments: [person_id#17 ASC NULLS FIRST], false, 0

(36) Scan parquet spark_catalog.imdb_10x.name
Output [1]: [id#540]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/name]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int>

(37) Filter
Input [1]: [id#540]
Condition : isnotnull(id#540)

(38) Exchange
Input [1]: [id#540]
Arguments: hashpartitioning(id#540, 200), ENSURE_REQUIREMENTS, [plan_id=21228]

(39) Sort
Input [1]: [id#540]
Arguments: [id#540 ASC NULLS FIRST], false, 0

(40) SortMergeJoin
Left keys [1]: [person_id#17]
Right keys [1]: [id#540]
Join type: Inner
Join condition: None

(41) Project
Output [7]: [movie_id#116, id#39, title#40, movie_id#218, info#220, movie_id#18, person_role_id#19]
Input [9]: [movie_id#116, id#39, title#40, movie_id#218, info#220, person_id#17, movie_id#18, person_role_id#19, id#540]

(42) Exchange
Input [7]: [movie_id#116, id#39, title#40, movie_id#218, info#220, movie_id#18, person_role_id#19]
Arguments: hashpartitioning(movie_id#18, movie_id#218, movie_id#116, id#39, 200), ENSURE_REQUIREMENTS, [plan_id=21242]

(43) Sort
Input [7]: [movie_id#116, id#39, title#40, movie_id#218, info#220, movie_id#18, person_role_id#19]
Arguments: [movie_id#18 ASC NULLS FIRST, movie_id#218 ASC NULLS FIRST, movie_id#116 ASC NULLS FIRST, id#39 ASC NULLS FIRST], false, 0

(44) Scan parquet spark_catalog.imdb_10x.complete_cast
Output [3]: [movie_id#927, subject_id#928, status_id#929]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/complete_cast]
PushedFilters: [IsNotNull(subject_id), IsNotNull(status_id), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:string,subject_id:int,status_id:int>

(45) Filter
Input [3]: [movie_id#927, subject_id#928, status_id#929]
Condition : ((isnotnull(subject_id#928) AND isnotnull(status_id#929)) AND isnotnull(movie_id#927))

(46) Scan parquet spark_catalog.imdb_10x.comp_cast_type
Output [2]: [id#930, kind#931]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/comp_cast_type]
PushedFilters: [IsNotNull(kind), EqualTo(kind,cast), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(47) Filter
Input [2]: [id#930, kind#931]
Condition : ((isnotnull(kind#931) AND (kind#931 = cast)) AND isnotnull(id#930))

(48) Project
Output [1]: [id#930]
Input [2]: [id#930, kind#931]

(49) BroadcastExchange
Input [1]: [id#930]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=21233]

(50) BroadcastHashJoin
Left keys [1]: [subject_id#928]
Right keys [1]: [id#930]
Join type: Inner
Join condition: None

(51) Project
Output [2]: [movie_id#927, status_id#929]
Input [4]: [movie_id#927, subject_id#928, status_id#929, id#930]

(52) Scan parquet spark_catalog.imdb_10x.comp_cast_type
Output [2]: [id#1376, kind#1377]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/comp_cast_type]
PushedFilters: [IsNotNull(kind), StringContains(kind,complete), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(53) Filter
Input [2]: [id#1376, kind#1377]
Condition : ((isnotnull(kind#1377) AND Contains(kind#1377, complete)) AND isnotnull(id#1376))

(54) Project
Output [1]: [id#1376]
Input [2]: [id#1376, kind#1377]

(55) BroadcastExchange
Input [1]: [id#1376]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=21237]

(56) BroadcastHashJoin
Left keys [1]: [status_id#929]
Right keys [1]: [id#1376]
Join type: Inner
Join condition: None

(57) Project
Output [1]: [movie_id#927]
Input [3]: [movie_id#927, status_id#929, id#1376]

(58) Exchange
Input [1]: [movie_id#927]
Arguments: hashpartitioning(cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int), 200), ENSURE_REQUIREMENTS, [plan_id=21243]

(59) Sort
Input [1]: [movie_id#927]
Arguments: [cast(movie_id#927 as int) ASC NULLS FIRST, cast(movie_id#927 as int) ASC NULLS FIRST, cast(movie_id#927 as int) ASC NULLS FIRST, cast(movie_id#927 as int) ASC NULLS FIRST], false, 0

(60) SortMergeJoin
Left keys [4]: [movie_id#18, movie_id#218, movie_id#116, id#39]
Right keys [4]: [cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int)]
Join type: Inner
Join condition: None

(61) Project
Output [3]: [title#40, info#220, person_role_id#19]
Input [8]: [movie_id#116, id#39, title#40, movie_id#218, info#220, movie_id#18, person_role_id#19, movie_id#927]

(62) Exchange
Input [3]: [title#40, info#220, person_role_id#19]
Arguments: hashpartitioning(cast(person_role_id#19 as int), 200), ENSURE_REQUIREMENTS, [plan_id=21250]

(63) Sort
Input [3]: [title#40, info#220, person_role_id#19]
Arguments: [cast(person_role_id#19 as int) ASC NULLS FIRST], false, 0

(64) Scan parquet spark_catalog.imdb_10x.char_name
Output [2]: [id#9, name#10]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/char_name]
PushedFilters: [IsNotNull(name), Or(StringContains(name,man),StringContains(name,Man)), IsNotNull(id)]
ReadSchema: struct<id:int,name:string>

(65) Filter
Input [2]: [id#9, name#10]
Condition : ((isnotnull(name#10) AND (Contains(name#10, man) OR Contains(name#10, Man))) AND isnotnull(id#9))

(66) Exchange
Input [2]: [id#9, name#10]
Arguments: hashpartitioning(id#9, 200), ENSURE_REQUIREMENTS, [plan_id=21251]

(67) Sort
Input [2]: [id#9, name#10]
Arguments: [id#9 ASC NULLS FIRST], false, 0

(68) SortMergeJoin
Left keys [1]: [cast(person_role_id#19 as int)]
Right keys [1]: [id#9]
Join type: Inner
Join condition: None

(69) Project
Output [3]: [name#10, info#220, title#40]
Input [5]: [title#40, info#220, person_role_id#19, id#9, name#10]

(70) SortAggregate
Input [3]: [name#10, info#220, title#40]
Keys: []
Functions [3]: [partial_min(name#10), partial_min(info#220), partial_min(title#40)]
Aggregate Attributes [3]: [min#1382, min#1383, min#1384]
Results [3]: [min#1385, min#1386, min#1387]

(71) Exchange
Input [3]: [min#1385, min#1386, min#1387]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=21258]

(72) SortAggregate
Input [3]: [min#1385, min#1386, min#1387]
Keys: []
Functions [3]: [min(name#10), min(info#220), min(title#40)]
Aggregate Attributes [3]: [min(name#10)#1379, min(info#220)#1380, min(title#40)#1381]
Results [3]: [min(name#10)#1379 AS character_name#1368, min(info#220)#1380 AS rating#1369, min(title#40)#1381 AS complete_hero_movie#1370]

(73) AdaptiveSparkPlan
Output [3]: [character_name#1368, rating#1369, complete_hero_movie#1370]
Arguments: isFinalPlan=false
Execution Time: 35.125
