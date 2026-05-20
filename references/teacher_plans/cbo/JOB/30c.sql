== Physical Plan ==
AdaptiveSparkPlan (67)
+- SortAggregate (66)
   +- Exchange (65)
      +- SortAggregate (64)
         +- Project (63)
            +- SortMergeJoin Inner (62)
               :- Sort (45)
               :  +- Exchange (44)
               :     +- BroadcastHashJoin Inner BuildRight (43)
               :        :- BroadcastHashJoin Inner BuildRight (32)
               :        :  :- Project (22)
               :        :  :  +- BroadcastHashJoin Inner BuildRight (21)
               :        :  :     :- BroadcastHashJoin Inner BuildLeft (16)
               :        :  :     :  :- BroadcastExchange (13)
               :        :  :     :  :  +- BroadcastHashJoin Inner BuildLeft (12)
               :        :  :     :  :     :- BroadcastExchange (9)
               :        :  :     :  :     :  +- Project (8)
               :        :  :     :  :     :     +- BroadcastHashJoin Inner BuildRight (7)
               :        :  :     :  :     :        :- Filter (2)
               :        :  :     :  :     :        :  +- Scan parquet spark_catalog.imdb_10x.movie_info (1)
               :        :  :     :  :     :        +- BroadcastExchange (6)
               :        :  :     :  :     :           +- Project (5)
               :        :  :     :  :     :              +- Filter (4)
               :        :  :     :  :     :                 +- Scan parquet spark_catalog.imdb_10x.info_type (3)
               :        :  :     :  :     +- Filter (11)
               :        :  :     :  :        +- Scan parquet spark_catalog.imdb_10x.title (10)
               :        :  :     :  +- Filter (15)
               :        :  :     :     +- Scan parquet spark_catalog.imdb_10x.movie_info_idx (14)
               :        :  :     +- BroadcastExchange (20)
               :        :  :        +- Project (19)
               :        :  :           +- Filter (18)
               :        :  :              +- Scan parquet spark_catalog.imdb_10x.info_type (17)
               :        :  +- BroadcastExchange (31)
               :        :     +- Project (30)
               :        :        +- BroadcastHashJoin Inner BuildRight (29)
               :        :           :- Filter (24)
               :        :           :  +- Scan parquet spark_catalog.imdb_10x.movie_keyword (23)
               :        :           +- BroadcastExchange (28)
               :        :              +- Project (27)
               :        :                 +- Filter (26)
               :        :                    +- Scan parquet spark_catalog.imdb_10x.keyword (25)
               :        +- BroadcastExchange (42)
               :           +- Project (41)
               :              +- BroadcastHashJoin Inner BuildLeft (40)
               :                 :- BroadcastExchange (36)
               :                 :  +- Project (35)
               :                 :     +- Filter (34)
               :                 :        +- Scan parquet spark_catalog.imdb_10x.cast_info (33)
               :                 +- Project (39)
               :                    +- Filter (38)
               :                       +- Scan parquet spark_catalog.imdb_10x.name (37)
               +- Sort (61)
                  +- Exchange (60)
                     +- Project (59)
                        +- BroadcastHashJoin Inner BuildRight (58)
                           :- Project (53)
                           :  +- BroadcastHashJoin Inner BuildRight (52)
                           :     :- Filter (47)
                           :     :  +- Scan parquet spark_catalog.imdb_10x.complete_cast (46)
                           :     +- BroadcastExchange (51)
                           :        +- Project (50)
                           :           +- Filter (49)
                           :              +- Scan parquet spark_catalog.imdb_10x.comp_cast_type (48)
                           +- BroadcastExchange (57)
                              +- Project (56)
                                 +- Filter (55)
                                    +- Scan parquet spark_catalog.imdb_10x.comp_cast_type (54)


(1) Scan parquet spark_catalog.imdb_10x.movie_info
Output [3]: [movie_id#213, info_type_id#214, info#215]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [In(info, [Action,Crime,Horror,Sci-Fi,Thriller,War]), IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(2) Filter
Input [3]: [movie_id#213, info_type_id#214, info#215]
Condition : ((info#215 IN (Horror,Action,Sci-Fi,Thriller,Crime,War) AND isnotnull(movie_id#213)) AND isnotnull(info_type_id#214))

(3) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#210, info#211]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,genres), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(4) Filter
Input [2]: [id#210, info#211]
Condition : ((isnotnull(info#211) AND (info#211 = genres)) AND isnotnull(id#210))

(5) Project
Output [1]: [id#210]
Input [2]: [id#210, info#211]

(6) BroadcastExchange
Input [1]: [id#210]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=28194]

(7) BroadcastHashJoin
Left keys [1]: [info_type_id#214]
Right keys [1]: [id#210]
Join type: Inner
Join condition: None

(8) Project
Output [2]: [movie_id#213, info#215]
Input [4]: [movie_id#213, info_type_id#214, info#215, id#210]

(9) BroadcastExchange
Input [2]: [movie_id#213, info#215]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=28198]

(10) Scan parquet spark_catalog.imdb_10x.title
Output [2]: [id#39, title#40]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int,title:string>

(11) Filter
Input [2]: [id#39, title#40]
Condition : isnotnull(id#39)

(12) BroadcastHashJoin
Left keys [1]: [movie_id#213]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(13) BroadcastExchange
Input [4]: [movie_id#213, info#215, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[2, int, false] as bigint) & 4294967295))),false), [plan_id=28201]

(14) Scan parquet spark_catalog.imdb_10x.movie_info_idx
Output [3]: [movie_id#218, info_type_id#219, info#220]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info_idx]
PushedFilters: [IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(15) Filter
Input [3]: [movie_id#218, info_type_id#219, info#220]
Condition : (isnotnull(movie_id#218) AND isnotnull(info_type_id#219))

(16) BroadcastHashJoin
Left keys [2]: [movie_id#213, id#39]
Right keys [2]: [movie_id#218, movie_id#218]
Join type: Inner
Join condition: None

(17) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#1757, info#1758]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,votes), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(18) Filter
Input [2]: [id#1757, info#1758]
Condition : ((isnotnull(info#1758) AND (info#1758 = votes)) AND isnotnull(id#1757))

(19) Project
Output [1]: [id#1757]
Input [2]: [id#1757, info#1758]

(20) BroadcastExchange
Input [1]: [id#1757]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=28204]

(21) BroadcastHashJoin
Left keys [1]: [info_type_id#219]
Right keys [1]: [id#1757]
Join type: Inner
Join condition: None

(22) Project
Output [6]: [movie_id#213, info#215, id#39, title#40, movie_id#218, info#220]
Input [8]: [movie_id#213, info#215, id#39, title#40, movie_id#218, info_type_id#219, info#220, id#1757]

(23) Scan parquet spark_catalog.imdb_10x.movie_keyword
Output [2]: [movie_id#116, keyword_id#117]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_keyword]
PushedFilters: [IsNotNull(movie_id), IsNotNull(keyword_id)]
ReadSchema: struct<movie_id:int,keyword_id:int>

(24) Filter
Input [2]: [movie_id#116, keyword_id#117]
Condition : (isnotnull(movie_id#116) AND isnotnull(keyword_id#117))

(25) Scan parquet spark_catalog.imdb_10x.keyword
Output [2]: [id#110, keyword#111]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/keyword]
PushedFilters: [In(keyword, [blood,death,female-nudity,gore,hospital,murder,violence]), IsNotNull(id)]
ReadSchema: struct<id:int,keyword:string>

(26) Filter
Input [2]: [id#110, keyword#111]
Condition : (keyword#111 IN (murder,violence,blood,gore,death,female-nudity,hospital) AND isnotnull(id#110))

(27) Project
Output [1]: [id#110]
Input [2]: [id#110, keyword#111]

(28) BroadcastExchange
Input [1]: [id#110]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=28207]

(29) BroadcastHashJoin
Left keys [1]: [keyword_id#117]
Right keys [1]: [id#110]
Join type: Inner
Join condition: None

(30) Project
Output [1]: [movie_id#116]
Input [3]: [movie_id#116, keyword_id#117, id#110]

(31) BroadcastExchange
Input [1]: [movie_id#116]
Arguments: HashedRelationBroadcastMode(List(input[0, int, true], input[0, int, true], input[0, int, true]),false), [plan_id=28211]

(32) BroadcastHashJoin
Left keys [3]: [movie_id#213, movie_id#218, id#39]
Right keys [3]: [movie_id#116, movie_id#116, movie_id#116]
Join type: Inner
Join condition: None

(33) Scan parquet spark_catalog.imdb_10x.cast_info
Output [3]: [person_id#17, movie_id#18, note#20]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/cast_info]
PushedFilters: [In(note, [(head writer),(story editor),(story),(writer),(written by)]), IsNotNull(movie_id), IsNotNull(person_id)]
ReadSchema: struct<person_id:int,movie_id:int,note:string>

(34) Filter
Input [3]: [person_id#17, movie_id#18, note#20]
Condition : ((note#20 IN ((writer),(head writer),(written by),(story),(story editor)) AND isnotnull(movie_id#18)) AND isnotnull(person_id#17))

(35) Project
Output [2]: [person_id#17, movie_id#18]
Input [3]: [person_id#17, movie_id#18, note#20]

(36) BroadcastExchange
Input [2]: [person_id#17, movie_id#18]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=28213]

(37) Scan parquet spark_catalog.imdb_10x.name
Output [3]: [id#540, name#541, gender#544]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/name]
PushedFilters: [IsNotNull(gender), EqualTo(gender,m), IsNotNull(id)]
ReadSchema: struct<id:int,name:string,gender:string>

(38) Filter
Input [3]: [id#540, name#541, gender#544]
Condition : ((isnotnull(gender#544) AND (gender#544 = m)) AND isnotnull(id#540))

(39) Project
Output [2]: [id#540, name#541]
Input [3]: [id#540, name#541, gender#544]

(40) BroadcastHashJoin
Left keys [1]: [person_id#17]
Right keys [1]: [id#540]
Join type: Inner
Join condition: None

(41) Project
Output [2]: [movie_id#18, name#541]
Input [4]: [person_id#17, movie_id#18, id#540, name#541]

(42) BroadcastExchange
Input [2]: [movie_id#18, name#541]
Arguments: HashedRelationBroadcastMode(List(input[0, int, true], input[0, int, true], input[0, int, true], input[0, int, true]),false), [plan_id=28217]

(43) BroadcastHashJoin
Left keys [4]: [movie_id#213, movie_id#218, movie_id#116, id#39]
Right keys [4]: [movie_id#18, movie_id#18, movie_id#18, movie_id#18]
Join type: Inner
Join condition: None

(44) Exchange
Input [9]: [movie_id#213, info#215, id#39, title#40, movie_id#218, info#220, movie_id#116, movie_id#18, name#541]
Arguments: hashpartitioning(movie_id#18, movie_id#213, movie_id#218, movie_id#116, id#39, 200), ENSURE_REQUIREMENTS, [plan_id=28228]

(45) Sort
Input [9]: [movie_id#213, info#215, id#39, title#40, movie_id#218, info#220, movie_id#116, movie_id#18, name#541]
Arguments: [movie_id#18 ASC NULLS FIRST, movie_id#213 ASC NULLS FIRST, movie_id#218 ASC NULLS FIRST, movie_id#116 ASC NULLS FIRST, id#39 ASC NULLS FIRST], false, 0

(46) Scan parquet spark_catalog.imdb_10x.complete_cast
Output [3]: [movie_id#927, subject_id#928, status_id#929]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/complete_cast]
PushedFilters: [IsNotNull(subject_id), IsNotNull(status_id), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:string,subject_id:int,status_id:int>

(47) Filter
Input [3]: [movie_id#927, subject_id#928, status_id#929]
Condition : ((isnotnull(subject_id#928) AND isnotnull(status_id#929)) AND isnotnull(movie_id#927))

(48) Scan parquet spark_catalog.imdb_10x.comp_cast_type
Output [2]: [id#930, kind#931]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/comp_cast_type]
PushedFilters: [IsNotNull(kind), EqualTo(kind,cast), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(49) Filter
Input [2]: [id#930, kind#931]
Condition : ((isnotnull(kind#931) AND (kind#931 = cast)) AND isnotnull(id#930))

(50) Project
Output [1]: [id#930]
Input [2]: [id#930, kind#931]

(51) BroadcastExchange
Input [1]: [id#930]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=28219]

(52) BroadcastHashJoin
Left keys [1]: [subject_id#928]
Right keys [1]: [id#930]
Join type: Inner
Join condition: None

(53) Project
Output [2]: [movie_id#927, status_id#929]
Input [4]: [movie_id#927, subject_id#928, status_id#929, id#930]

(54) Scan parquet spark_catalog.imdb_10x.comp_cast_type
Output [2]: [id#1755, kind#1756]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/comp_cast_type]
PushedFilters: [IsNotNull(kind), EqualTo(kind,complete+verified), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(55) Filter
Input [2]: [id#1755, kind#1756]
Condition : ((isnotnull(kind#1756) AND (kind#1756 = complete+verified)) AND isnotnull(id#1755))

(56) Project
Output [1]: [id#1755]
Input [2]: [id#1755, kind#1756]

(57) BroadcastExchange
Input [1]: [id#1755]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=28223]

(58) BroadcastHashJoin
Left keys [1]: [status_id#929]
Right keys [1]: [id#1755]
Join type: Inner
Join condition: None

(59) Project
Output [1]: [movie_id#927]
Input [3]: [movie_id#927, status_id#929, id#1755]

(60) Exchange
Input [1]: [movie_id#927]
Arguments: hashpartitioning(cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int), 200), ENSURE_REQUIREMENTS, [plan_id=28229]

(61) Sort
Input [1]: [movie_id#927]
Arguments: [cast(movie_id#927 as int) ASC NULLS FIRST, cast(movie_id#927 as int) ASC NULLS FIRST, cast(movie_id#927 as int) ASC NULLS FIRST, cast(movie_id#927 as int) ASC NULLS FIRST, cast(movie_id#927 as int) ASC NULLS FIRST], false, 0

(62) SortMergeJoin
Left keys [5]: [movie_id#18, movie_id#213, movie_id#218, movie_id#116, id#39]
Right keys [5]: [cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int)]
Join type: Inner
Join condition: None

(63) Project
Output [4]: [info#215, info#220, name#541, title#40]
Input [10]: [movie_id#213, info#215, id#39, title#40, movie_id#218, info#220, movie_id#116, movie_id#18, name#541, movie_id#927]

(64) SortAggregate
Input [4]: [info#215, info#220, name#541, title#40]
Keys: []
Functions [4]: [partial_min(info#215), partial_min(info#220), partial_min(name#541), partial_min(title#40)]
Aggregate Attributes [4]: [min#1765, min#1766, min#1767, min#1768]
Results [4]: [min#1769, min#1770, min#1771, min#1772]

(65) Exchange
Input [4]: [min#1769, min#1770, min#1771, min#1772]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=28236]

(66) SortAggregate
Input [4]: [min#1769, min#1770, min#1771, min#1772]
Keys: []
Functions [4]: [min(info#215), min(info#220), min(name#541), min(title#40)]
Aggregate Attributes [4]: [min(info#215)#1761, min(info#220)#1762, min(name#541)#1763, min(title#40)#1764]
Results [4]: [min(info#215)#1761 AS movie_budget#1746, min(info#220)#1762 AS movie_votes#1747, min(name#541)#1763 AS writer#1748, min(title#40)#1764 AS complete_violent_movie#1749]

(67) AdaptiveSparkPlan
Output [4]: [movie_budget#1746, movie_votes#1747, writer#1748, complete_violent_movie#1749]
Arguments: isFinalPlan=false
Execution Time: 47.148
