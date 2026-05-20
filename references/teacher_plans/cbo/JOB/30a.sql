== Physical Plan ==
AdaptiveSparkPlan (65)
+- SortAggregate (64)
   +- Exchange (63)
      +- SortAggregate (62)
         +- Project (61)
            +- BroadcastHashJoin Inner BuildLeft (60)
               :- BroadcastExchange (45)
               :  +- BroadcastHashJoin Inner BuildRight (44)
               :     :- BroadcastHashJoin Inner BuildRight (33)
               :     :  :- Project (23)
               :     :  :  +- BroadcastHashJoin Inner BuildRight (22)
               :     :  :     :- BroadcastHashJoin Inner BuildLeft (17)
               :     :  :     :  :- BroadcastExchange (14)
               :     :  :     :  :  +- BroadcastHashJoin Inner BuildLeft (13)
               :     :  :     :  :     :- BroadcastExchange (9)
               :     :  :     :  :     :  +- Project (8)
               :     :  :     :  :     :     +- BroadcastHashJoin Inner BuildRight (7)
               :     :  :     :  :     :        :- Filter (2)
               :     :  :     :  :     :        :  +- Scan parquet spark_catalog.imdb_10x.movie_info (1)
               :     :  :     :  :     :        +- BroadcastExchange (6)
               :     :  :     :  :     :           +- Project (5)
               :     :  :     :  :     :              +- Filter (4)
               :     :  :     :  :     :                 +- Scan parquet spark_catalog.imdb_10x.info_type (3)
               :     :  :     :  :     +- Project (12)
               :     :  :     :  :        +- Filter (11)
               :     :  :     :  :           +- Scan parquet spark_catalog.imdb_10x.title (10)
               :     :  :     :  +- Filter (16)
               :     :  :     :     +- Scan parquet spark_catalog.imdb_10x.movie_info_idx (15)
               :     :  :     +- BroadcastExchange (21)
               :     :  :        +- Project (20)
               :     :  :           +- Filter (19)
               :     :  :              +- Scan parquet spark_catalog.imdb_10x.info_type (18)
               :     :  +- BroadcastExchange (32)
               :     :     +- Project (31)
               :     :        +- BroadcastHashJoin Inner BuildRight (30)
               :     :           :- Filter (25)
               :     :           :  +- Scan parquet spark_catalog.imdb_10x.movie_keyword (24)
               :     :           +- BroadcastExchange (29)
               :     :              +- Project (28)
               :     :                 +- Filter (27)
               :     :                    +- Scan parquet spark_catalog.imdb_10x.keyword (26)
               :     +- BroadcastExchange (43)
               :        +- Project (42)
               :           +- BroadcastHashJoin Inner BuildLeft (41)
               :              :- BroadcastExchange (37)
               :              :  +- Project (36)
               :              :     +- Filter (35)
               :              :        +- Scan parquet spark_catalog.imdb_10x.cast_info (34)
               :              +- Project (40)
               :                 +- Filter (39)
               :                    +- Scan parquet spark_catalog.imdb_10x.name (38)
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
PushedFilters: [In(info, [Horror,Thriller]), IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(2) Filter
Input [3]: [movie_id#213, info_type_id#214, info#215]
Condition : ((info#215 IN (Horror,Thriller) AND isnotnull(movie_id#213)) AND isnotnull(info_type_id#214))

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=27296]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=27300]

(10) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#39, title#40, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(11) Filter
Input [3]: [id#39, title#40, production_year#43]
Condition : ((isnotnull(production_year#43) AND (cast(production_year#43 as int) > 2000)) AND isnotnull(id#39))

(12) Project
Output [2]: [id#39, title#40]
Input [3]: [id#39, title#40, production_year#43]

(13) BroadcastHashJoin
Left keys [1]: [movie_id#213]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(14) BroadcastExchange
Input [4]: [movie_id#213, info#215, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[2, int, true] as bigint) & 4294967295))),false), [plan_id=27303]

(15) Scan parquet spark_catalog.imdb_10x.movie_info_idx
Output [3]: [movie_id#218, info_type_id#219, info#220]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info_idx]
PushedFilters: [IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(16) Filter
Input [3]: [movie_id#218, info_type_id#219, info#220]
Condition : (isnotnull(movie_id#218) AND isnotnull(info_type_id#219))

(17) BroadcastHashJoin
Left keys [2]: [movie_id#213, id#39]
Right keys [2]: [movie_id#218, movie_id#218]
Join type: Inner
Join condition: None

(18) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#1695, info#1696]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,votes), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(19) Filter
Input [2]: [id#1695, info#1696]
Condition : ((isnotnull(info#1696) AND (info#1696 = votes)) AND isnotnull(id#1695))

(20) Project
Output [1]: [id#1695]
Input [2]: [id#1695, info#1696]

(21) BroadcastExchange
Input [1]: [id#1695]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=27306]

(22) BroadcastHashJoin
Left keys [1]: [info_type_id#219]
Right keys [1]: [id#1695]
Join type: Inner
Join condition: None

(23) Project
Output [6]: [movie_id#213, info#215, id#39, title#40, movie_id#218, info#220]
Input [8]: [movie_id#213, info#215, id#39, title#40, movie_id#218, info_type_id#219, info#220, id#1695]

(24) Scan parquet spark_catalog.imdb_10x.movie_keyword
Output [2]: [movie_id#116, keyword_id#117]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_keyword]
PushedFilters: [IsNotNull(movie_id), IsNotNull(keyword_id)]
ReadSchema: struct<movie_id:int,keyword_id:int>

(25) Filter
Input [2]: [movie_id#116, keyword_id#117]
Condition : (isnotnull(movie_id#116) AND isnotnull(keyword_id#117))

(26) Scan parquet spark_catalog.imdb_10x.keyword
Output [2]: [id#110, keyword#111]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/keyword]
PushedFilters: [In(keyword, [blood,death,female-nudity,gore,hospital,murder,violence]), IsNotNull(id)]
ReadSchema: struct<id:int,keyword:string>

(27) Filter
Input [2]: [id#110, keyword#111]
Condition : (keyword#111 IN (murder,violence,blood,gore,death,female-nudity,hospital) AND isnotnull(id#110))

(28) Project
Output [1]: [id#110]
Input [2]: [id#110, keyword#111]

(29) BroadcastExchange
Input [1]: [id#110]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=27309]

(30) BroadcastHashJoin
Left keys [1]: [keyword_id#117]
Right keys [1]: [id#110]
Join type: Inner
Join condition: None

(31) Project
Output [1]: [movie_id#116]
Input [3]: [movie_id#116, keyword_id#117, id#110]

(32) BroadcastExchange
Input [1]: [movie_id#116]
Arguments: HashedRelationBroadcastMode(List(input[0, int, true], input[0, int, true], input[0, int, true]),false), [plan_id=27313]

(33) BroadcastHashJoin
Left keys [3]: [movie_id#213, movie_id#218, id#39]
Right keys [3]: [movie_id#116, movie_id#116, movie_id#116]
Join type: Inner
Join condition: None

(34) Scan parquet spark_catalog.imdb_10x.cast_info
Output [3]: [person_id#17, movie_id#18, note#20]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/cast_info]
PushedFilters: [In(note, [(head writer),(story editor),(story),(writer),(written by)]), IsNotNull(movie_id), IsNotNull(person_id)]
ReadSchema: struct<person_id:int,movie_id:int,note:string>

(35) Filter
Input [3]: [person_id#17, movie_id#18, note#20]
Condition : ((note#20 IN ((writer),(head writer),(written by),(story),(story editor)) AND isnotnull(movie_id#18)) AND isnotnull(person_id#17))

(36) Project
Output [2]: [person_id#17, movie_id#18]
Input [3]: [person_id#17, movie_id#18, note#20]

(37) BroadcastExchange
Input [2]: [person_id#17, movie_id#18]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=27315]

(38) Scan parquet spark_catalog.imdb_10x.name
Output [3]: [id#540, name#541, gender#544]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/name]
PushedFilters: [IsNotNull(gender), EqualTo(gender,m), IsNotNull(id)]
ReadSchema: struct<id:int,name:string,gender:string>

(39) Filter
Input [3]: [id#540, name#541, gender#544]
Condition : ((isnotnull(gender#544) AND (gender#544 = m)) AND isnotnull(id#540))

(40) Project
Output [2]: [id#540, name#541]
Input [3]: [id#540, name#541, gender#544]

(41) BroadcastHashJoin
Left keys [1]: [person_id#17]
Right keys [1]: [id#540]
Join type: Inner
Join condition: None

(42) Project
Output [2]: [movie_id#18, name#541]
Input [4]: [person_id#17, movie_id#18, id#540, name#541]

(43) BroadcastExchange
Input [2]: [movie_id#18, name#541]
Arguments: HashedRelationBroadcastMode(List(input[0, int, true], input[0, int, true], input[0, int, true], input[0, int, true]),false), [plan_id=27319]

(44) BroadcastHashJoin
Left keys [4]: [movie_id#213, movie_id#218, movie_id#116, id#39]
Right keys [4]: [movie_id#18, movie_id#18, movie_id#18, movie_id#18]
Join type: Inner
Join condition: None

(45) BroadcastExchange
Input [9]: [movie_id#213, info#215, id#39, title#40, movie_id#218, info#220, movie_id#116, movie_id#18, name#541]
Arguments: HashedRelationBroadcastMode(List(input[7, int, true], input[0, int, true], input[4, int, true], input[6, int, true], input[2, int, true]),false), [plan_id=27329]

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
Output [2]: [id#1693, kind#1694]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/comp_cast_type]
PushedFilters: [IsNotNull(kind), EqualTo(kind,complete+verified), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(49) Filter
Input [2]: [id#1693, kind#1694]
Condition : ((isnotnull(kind#1694) AND (kind#1694 = complete+verified)) AND isnotnull(id#1693))

(50) Project
Output [1]: [id#1693]
Input [2]: [id#1693, kind#1694]

(51) BroadcastExchange
Input [1]: [id#1693]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=27321]

(52) BroadcastHashJoin
Left keys [1]: [status_id#929]
Right keys [1]: [id#1693]
Join type: Inner
Join condition: None

(53) Project
Output [2]: [movie_id#927, subject_id#928]
Input [4]: [movie_id#927, subject_id#928, status_id#929, id#1693]

(54) Scan parquet spark_catalog.imdb_10x.comp_cast_type
Output [2]: [id#930, kind#931]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/comp_cast_type]
PushedFilters: [In(kind, [cast,crew]), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(55) Filter
Input [2]: [id#930, kind#931]
Condition : (kind#931 IN (cast,crew) AND isnotnull(id#930))

(56) Project
Output [1]: [id#930]
Input [2]: [id#930, kind#931]

(57) BroadcastExchange
Input [1]: [id#930]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=27325]

(58) BroadcastHashJoin
Left keys [1]: [subject_id#928]
Right keys [1]: [id#930]
Join type: Inner
Join condition: None

(59) Project
Output [1]: [movie_id#927]
Input [3]: [movie_id#927, subject_id#928, id#930]

(60) BroadcastHashJoin
Left keys [5]: [movie_id#18, movie_id#213, movie_id#218, movie_id#116, id#39]
Right keys [5]: [cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int)]
Join type: Inner
Join condition: None

(61) Project
Output [4]: [info#215, info#220, name#541, title#40]
Input [10]: [movie_id#213, info#215, id#39, title#40, movie_id#218, info#220, movie_id#116, movie_id#18, name#541, movie_id#927]

(62) SortAggregate
Input [4]: [info#215, info#220, name#541, title#40]
Keys: []
Functions [4]: [partial_min(info#215), partial_min(info#220), partial_min(name#541), partial_min(title#40)]
Aggregate Attributes [4]: [min#1703, min#1704, min#1705, min#1706]
Results [4]: [min#1707, min#1708, min#1709, min#1710]

(63) Exchange
Input [4]: [min#1707, min#1708, min#1709, min#1710]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=27334]

(64) SortAggregate
Input [4]: [min#1707, min#1708, min#1709, min#1710]
Keys: []
Functions [4]: [min(info#215), min(info#220), min(name#541), min(title#40)]
Aggregate Attributes [4]: [min(info#215)#1699, min(info#220)#1700, min(name#541)#1701, min(title#40)#1702]
Results [4]: [min(info#215)#1699 AS movie_budget#1684, min(info#220)#1700 AS movie_votes#1685, min(name#541)#1701 AS writer#1686, min(title#40)#1702 AS complete_violent_movie#1687]

(65) AdaptiveSparkPlan
Output [4]: [movie_budget#1684, movie_votes#1685, writer#1686, complete_violent_movie#1687]
Arguments: isFinalPlan=false
Execution Time: 47.284
