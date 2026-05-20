== Physical Plan ==
AdaptiveSparkPlan (48)
+- SortAggregate (47)
   +- Exchange (46)
      +- SortAggregate (45)
         +- Project (44)
            +- BroadcastHashJoin Inner BuildRight (43)
               :- BroadcastHashJoin Inner BuildRight (32)
               :  :- Project (22)
               :  :  +- BroadcastHashJoin Inner BuildRight (21)
               :  :     :- BroadcastHashJoin Inner BuildLeft (16)
               :  :     :  :- BroadcastExchange (13)
               :  :     :  :  +- BroadcastHashJoin Inner BuildLeft (12)
               :  :     :  :     :- BroadcastExchange (9)
               :  :     :  :     :  +- Project (8)
               :  :     :  :     :     +- BroadcastHashJoin Inner BuildRight (7)
               :  :     :  :     :        :- Filter (2)
               :  :     :  :     :        :  +- Scan parquet spark_catalog.imdb_10x.movie_info (1)
               :  :     :  :     :        +- BroadcastExchange (6)
               :  :     :  :     :           +- Project (5)
               :  :     :  :     :              +- Filter (4)
               :  :     :  :     :                 +- Scan parquet spark_catalog.imdb_10x.info_type (3)
               :  :     :  :     +- Filter (11)
               :  :     :  :        +- Scan parquet spark_catalog.imdb_10x.title (10)
               :  :     :  +- Filter (15)
               :  :     :     +- Scan parquet spark_catalog.imdb_10x.movie_info_idx (14)
               :  :     +- BroadcastExchange (20)
               :  :        +- Project (19)
               :  :           +- Filter (18)
               :  :              +- Scan parquet spark_catalog.imdb_10x.info_type (17)
               :  +- BroadcastExchange (31)
               :     +- Project (30)
               :        +- BroadcastHashJoin Inner BuildRight (29)
               :           :- Filter (24)
               :           :  +- Scan parquet spark_catalog.imdb_10x.movie_keyword (23)
               :           +- BroadcastExchange (28)
               :              +- Project (27)
               :                 +- Filter (26)
               :                    +- Scan parquet spark_catalog.imdb_10x.keyword (25)
               +- BroadcastExchange (42)
                  +- Project (41)
                     +- BroadcastHashJoin Inner BuildLeft (40)
                        :- BroadcastExchange (36)
                        :  +- Project (35)
                        :     +- Filter (34)
                        :        +- Scan parquet spark_catalog.imdb_10x.cast_info (33)
                        +- Project (39)
                           +- Filter (38)
                              +- Scan parquet spark_catalog.imdb_10x.name (37)


(1) Scan parquet spark_catalog.imdb_10x.movie_info
Output [3]: [movie_id#213, info_type_id#214, info#215]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [IsNotNull(info), EqualTo(info,Horror), IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(2) Filter
Input [3]: [movie_id#213, info_type_id#214, info#215]
Condition : (((isnotnull(info#215) AND (info#215 = Horror)) AND isnotnull(movie_id#213)) AND isnotnull(info_type_id#214))

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=19137]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=19141]

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
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[2, int, false] as bigint) & 4294967295))),false), [plan_id=19144]

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
Output [2]: [id#1241, info#1242]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,votes), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(18) Filter
Input [2]: [id#1241, info#1242]
Condition : ((isnotnull(info#1242) AND (info#1242 = votes)) AND isnotnull(id#1241))

(19) Project
Output [1]: [id#1241]
Input [2]: [id#1241, info#1242]

(20) BroadcastExchange
Input [1]: [id#1241]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=19147]

(21) BroadcastHashJoin
Left keys [1]: [info_type_id#219]
Right keys [1]: [id#1241]
Join type: Inner
Join condition: None

(22) Project
Output [6]: [movie_id#213, info#215, id#39, title#40, movie_id#218, info#220]
Input [8]: [movie_id#213, info#215, id#39, title#40, movie_id#218, info_type_id#219, info#220, id#1241]

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
PushedFilters: [In(keyword, [blood,death,female-nudity,gore,murder]), IsNotNull(id)]
ReadSchema: struct<id:int,keyword:string>

(26) Filter
Input [2]: [id#110, keyword#111]
Condition : (keyword#111 IN (murder,blood,gore,death,female-nudity) AND isnotnull(id#110))

(27) Project
Output [1]: [id#110]
Input [2]: [id#110, keyword#111]

(28) BroadcastExchange
Input [1]: [id#110]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=19150]

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
Arguments: HashedRelationBroadcastMode(List(input[0, int, true], input[0, int, true], input[0, int, true]),false), [plan_id=19154]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=19156]

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
Arguments: HashedRelationBroadcastMode(List(input[0, int, true], input[0, int, true], input[0, int, true], input[0, int, true]),false), [plan_id=19160]

(43) BroadcastHashJoin
Left keys [4]: [movie_id#213, movie_id#218, movie_id#116, id#39]
Right keys [4]: [movie_id#18, movie_id#18, movie_id#18, movie_id#18]
Join type: Inner
Join condition: None

(44) Project
Output [4]: [info#215, info#220, name#541, title#40]
Input [9]: [movie_id#213, info#215, id#39, title#40, movie_id#218, info#220, movie_id#116, movie_id#18, name#541]

(45) SortAggregate
Input [4]: [info#215, info#220, name#541, title#40]
Keys: []
Functions [4]: [partial_min(info#215), partial_min(info#220), partial_min(name#541), partial_min(title#40)]
Aggregate Attributes [4]: [min#1248, min#1249, min#1250, min#1251]
Results [4]: [min#1252, min#1253, min#1254, min#1255]

(46) Exchange
Input [4]: [min#1252, min#1253, min#1254, min#1255]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=19165]

(47) SortAggregate
Input [4]: [min#1252, min#1253, min#1254, min#1255]
Keys: []
Functions [4]: [min(info#215), min(info#220), min(name#541), min(title#40)]
Aggregate Attributes [4]: [min(info#215)#1243, min(info#220)#1244, min(name#541)#1245, min(title#40)#1246]
Results [4]: [min(info#215)#1243 AS movie_budget#1232, min(info#220)#1244 AS movie_votes#1233, min(name#541)#1245 AS male_writer#1234, min(title#40)#1246 AS violent_movie_title#1235]

(48) AdaptiveSparkPlan
Output [4]: [movie_budget#1232, movie_votes#1233, male_writer#1234, violent_movie_title#1235]
Arguments: isFinalPlan=false
Execution Time: 35.535
