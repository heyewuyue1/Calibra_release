== Physical Plan ==
AdaptiveSparkPlan (67)
+- SortAggregate (66)
   +- Exchange (65)
      +- SortAggregate (64)
         +- Project (63)
            +- SortMergeJoin Inner (62)
               :- Sort (57)
               :  +- Exchange (56)
               :     +- Project (55)
               :        +- BroadcastHashJoin Inner BuildLeft (54)
               :           :- BroadcastExchange (39)
               :           :  +- Project (38)
               :           :     +- BroadcastHashJoin Inner BuildLeft (37)
               :           :        :- BroadcastExchange (34)
               :           :        :  +- BroadcastHashJoin Inner BuildLeft (33)
               :           :        :     :- BroadcastExchange (30)
               :           :        :     :  +- Project (29)
               :           :        :     :     +- BroadcastHashJoin Inner BuildRight (28)
               :           :        :     :        :- BroadcastHashJoin Inner BuildLeft (23)
               :           :        :     :        :  :- BroadcastExchange (20)
               :           :        :     :        :  :  +- Project (19)
               :           :        :     :        :  :     +- BroadcastHashJoin Inner BuildRight (18)
               :           :        :     :        :  :        :- BroadcastHashJoin Inner BuildLeft (13)
               :           :        :     :        :  :        :  :- BroadcastExchange (9)
               :           :        :     :        :  :        :  :  +- Project (8)
               :           :        :     :        :  :        :  :     +- BroadcastHashJoin Inner BuildRight (7)
               :           :        :     :        :  :        :  :        :- Filter (2)
               :           :        :     :        :  :        :  :        :  +- Scan parquet spark_catalog.imdb_10x.movie_keyword (1)
               :           :        :     :        :  :        :  :        +- BroadcastExchange (6)
               :           :        :     :        :  :        :  :           +- Project (5)
               :           :        :     :        :  :        :  :              +- Filter (4)
               :           :        :     :        :  :        :  :                 +- Scan parquet spark_catalog.imdb_10x.keyword (3)
               :           :        :     :        :  :        :  +- Project (12)
               :           :        :     :        :  :        :     +- Filter (11)
               :           :        :     :        :  :        :        +- Scan parquet spark_catalog.imdb_10x.title (10)
               :           :        :     :        :  :        +- BroadcastExchange (17)
               :           :        :     :        :  :           +- Project (16)
               :           :        :     :        :  :              +- Filter (15)
               :           :        :     :        :  :                 +- Scan parquet spark_catalog.imdb_10x.kind_type (14)
               :           :        :     :        :  +- Filter (22)
               :           :        :     :        :     +- Scan parquet spark_catalog.imdb_10x.movie_info_idx (21)
               :           :        :     :        +- BroadcastExchange (27)
               :           :        :     :           +- Project (26)
               :           :        :     :              +- Filter (25)
               :           :        :     :                 +- Scan parquet spark_catalog.imdb_10x.info_type (24)
               :           :        :     +- Filter (32)
               :           :        :        +- Scan parquet spark_catalog.imdb_10x.cast_info (31)
               :           :        +- Filter (36)
               :           :           +- Scan parquet spark_catalog.imdb_10x.name (35)
               :           +- Project (53)
               :              +- BroadcastHashJoin Inner BuildRight (52)
               :                 :- Project (47)
               :                 :  +- BroadcastHashJoin Inner BuildRight (46)
               :                 :     :- Filter (41)
               :                 :     :  +- Scan parquet spark_catalog.imdb_10x.complete_cast (40)
               :                 :     +- BroadcastExchange (45)
               :                 :        +- Project (44)
               :                 :           +- Filter (43)
               :                 :              +- Scan parquet spark_catalog.imdb_10x.comp_cast_type (42)
               :                 +- BroadcastExchange (51)
               :                    +- Project (50)
               :                       +- Filter (49)
               :                          +- Scan parquet spark_catalog.imdb_10x.comp_cast_type (48)
               +- Sort (61)
                  +- Exchange (60)
                     +- Filter (59)
                        +- Scan parquet spark_catalog.imdb_10x.char_name (58)


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
PushedFilters: [In(keyword, [based-on-comic,fight,marvel-comics,superhero]), IsNotNull(id)]
ReadSchema: struct<id:int,keyword:string>

(4) Filter
Input [2]: [id#110, keyword#111]
Condition : (keyword#111 IN (superhero,marvel-comics,based-on-comic,fight) AND isnotnull(id#110))

(5) Project
Output [1]: [id#110]
Input [2]: [id#110, keyword#111]

(6) BroadcastExchange
Input [1]: [id#110]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=20740]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=20744]

(10) Scan parquet spark_catalog.imdb_10x.title
Output [4]: [id#39, title#40, kind_id#42, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id), IsNotNull(kind_id)]
ReadSchema: struct<id:int,title:string,kind_id:int,production_year:string>

(11) Filter
Input [4]: [id#39, title#40, kind_id#42, production_year#43]
Condition : (((isnotnull(production_year#43) AND (cast(production_year#43 as int) > 2005)) AND isnotnull(id#39)) AND isnotnull(kind_id#42))

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=20747]

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
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[1, int, true] as bigint) & 4294967295))),false), [plan_id=20751]

(21) Scan parquet spark_catalog.imdb_10x.movie_info_idx
Output [3]: [movie_id#218, info_type_id#219, info#220]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info_idx]
PushedFilters: [IsNotNull(info), GreaterThan(info,8.0), IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(22) Filter
Input [3]: [movie_id#218, info_type_id#219, info#220]
Condition : (((isnotnull(info#220) AND (info#220 > 8.0)) AND isnotnull(movie_id#218)) AND isnotnull(info_type_id#219))

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=20754]

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
Arguments: HashedRelationBroadcastMode(List(input[3, int, true], input[0, int, true], input[1, int, true]),false), [plan_id=20758]

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

(34) BroadcastExchange
Input [8]: [movie_id#116, id#39, title#40, movie_id#218, info#220, person_id#17, movie_id#18, person_role_id#19]
Arguments: HashedRelationBroadcastMode(List(cast(input[5, int, false] as bigint)),false), [plan_id=20761]

(35) Scan parquet spark_catalog.imdb_10x.name
Output [1]: [id#540]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/name]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int>

(36) Filter
Input [1]: [id#540]
Condition : isnotnull(id#540)

(37) BroadcastHashJoin
Left keys [1]: [person_id#17]
Right keys [1]: [id#540]
Join type: Inner
Join condition: None

(38) Project
Output [7]: [movie_id#116, id#39, title#40, movie_id#218, info#220, movie_id#18, person_role_id#19]
Input [9]: [movie_id#116, id#39, title#40, movie_id#218, info#220, person_id#17, movie_id#18, person_role_id#19, id#540]

(39) BroadcastExchange
Input [7]: [movie_id#116, id#39, title#40, movie_id#218, info#220, movie_id#18, person_role_id#19]
Arguments: HashedRelationBroadcastMode(List(input[5, int, true], input[3, int, true], input[0, int, true], input[1, int, true]),false), [plan_id=20772]

(40) Scan parquet spark_catalog.imdb_10x.complete_cast
Output [3]: [movie_id#927, subject_id#928, status_id#929]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/complete_cast]
PushedFilters: [IsNotNull(subject_id), IsNotNull(status_id), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:string,subject_id:int,status_id:int>

(41) Filter
Input [3]: [movie_id#927, subject_id#928, status_id#929]
Condition : ((isnotnull(subject_id#928) AND isnotnull(status_id#929)) AND isnotnull(movie_id#927))

(42) Scan parquet spark_catalog.imdb_10x.comp_cast_type
Output [2]: [id#930, kind#931]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/comp_cast_type]
PushedFilters: [IsNotNull(kind), EqualTo(kind,cast), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(43) Filter
Input [2]: [id#930, kind#931]
Condition : ((isnotnull(kind#931) AND (kind#931 = cast)) AND isnotnull(id#930))

(44) Project
Output [1]: [id#930]
Input [2]: [id#930, kind#931]

(45) BroadcastExchange
Input [1]: [id#930]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=20764]

(46) BroadcastHashJoin
Left keys [1]: [subject_id#928]
Right keys [1]: [id#930]
Join type: Inner
Join condition: None

(47) Project
Output [2]: [movie_id#927, status_id#929]
Input [4]: [movie_id#927, subject_id#928, status_id#929, id#930]

(48) Scan parquet spark_catalog.imdb_10x.comp_cast_type
Output [2]: [id#1352, kind#1353]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/comp_cast_type]
PushedFilters: [IsNotNull(kind), StringContains(kind,complete), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(49) Filter
Input [2]: [id#1352, kind#1353]
Condition : ((isnotnull(kind#1353) AND Contains(kind#1353, complete)) AND isnotnull(id#1352))

(50) Project
Output [1]: [id#1352]
Input [2]: [id#1352, kind#1353]

(51) BroadcastExchange
Input [1]: [id#1352]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=20768]

(52) BroadcastHashJoin
Left keys [1]: [status_id#929]
Right keys [1]: [id#1352]
Join type: Inner
Join condition: None

(53) Project
Output [1]: [movie_id#927]
Input [3]: [movie_id#927, status_id#929, id#1352]

(54) BroadcastHashJoin
Left keys [4]: [movie_id#18, movie_id#218, movie_id#116, id#39]
Right keys [4]: [cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int)]
Join type: Inner
Join condition: None

(55) Project
Output [3]: [title#40, info#220, person_role_id#19]
Input [8]: [movie_id#116, id#39, title#40, movie_id#218, info#220, movie_id#18, person_role_id#19, movie_id#927]

(56) Exchange
Input [3]: [title#40, info#220, person_role_id#19]
Arguments: hashpartitioning(cast(person_role_id#19 as int), 200), ENSURE_REQUIREMENTS, [plan_id=20777]

(57) Sort
Input [3]: [title#40, info#220, person_role_id#19]
Arguments: [cast(person_role_id#19 as int) ASC NULLS FIRST], false, 0

(58) Scan parquet spark_catalog.imdb_10x.char_name
Output [2]: [id#9, name#10]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/char_name]
PushedFilters: [IsNotNull(name), Or(StringContains(name,man),StringContains(name,Man)), IsNotNull(id)]
ReadSchema: struct<id:int,name:string>

(59) Filter
Input [2]: [id#9, name#10]
Condition : ((isnotnull(name#10) AND (Contains(name#10, man) OR Contains(name#10, Man))) AND isnotnull(id#9))

(60) Exchange
Input [2]: [id#9, name#10]
Arguments: hashpartitioning(id#9, 200), ENSURE_REQUIREMENTS, [plan_id=20778]

(61) Sort
Input [2]: [id#9, name#10]
Arguments: [id#9 ASC NULLS FIRST], false, 0

(62) SortMergeJoin
Left keys [1]: [cast(person_role_id#19 as int)]
Right keys [1]: [id#9]
Join type: Inner
Join condition: None

(63) Project
Output [3]: [name#10, info#220, title#40]
Input [5]: [title#40, info#220, person_role_id#19, id#9, name#10]

(64) SortAggregate
Input [3]: [name#10, info#220, title#40]
Keys: []
Functions [3]: [partial_min(name#10), partial_min(info#220), partial_min(title#40)]
Aggregate Attributes [3]: [min#1358, min#1359, min#1360]
Results [3]: [min#1361, min#1362, min#1363]

(65) Exchange
Input [3]: [min#1361, min#1362, min#1363]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=20785]

(66) SortAggregate
Input [3]: [min#1361, min#1362, min#1363]
Keys: []
Functions [3]: [min(name#10), min(info#220), min(title#40)]
Aggregate Attributes [3]: [min(name#10)#1355, min(info#220)#1356, min(title#40)#1357]
Results [3]: [min(name#10)#1355 AS character_name#1344, min(info#220)#1356 AS rating#1345, min(title#40)#1357 AS complete_hero_movie#1346]

(67) AdaptiveSparkPlan
Output [3]: [character_name#1344, rating#1345, complete_hero_movie#1346]
Arguments: isFinalPlan=false
Execution Time: 26.912
