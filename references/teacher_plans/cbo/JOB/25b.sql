== Physical Plan ==
AdaptiveSparkPlan (49)
+- SortAggregate (48)
   +- Exchange (47)
      +- SortAggregate (46)
         +- Project (45)
            +- BroadcastHashJoin Inner BuildRight (44)
               :- BroadcastHashJoin Inner BuildRight (33)
               :  :- Project (23)
               :  :  +- BroadcastHashJoin Inner BuildRight (22)
               :  :     :- BroadcastHashJoin Inner BuildLeft (17)
               :  :     :  :- BroadcastExchange (14)
               :  :     :  :  +- BroadcastHashJoin Inner BuildLeft (13)
               :  :     :  :     :- BroadcastExchange (9)
               :  :     :  :     :  +- Project (8)
               :  :     :  :     :     +- BroadcastHashJoin Inner BuildRight (7)
               :  :     :  :     :        :- Filter (2)
               :  :     :  :     :        :  +- Scan parquet spark_catalog.imdb_10x.movie_info (1)
               :  :     :  :     :        +- BroadcastExchange (6)
               :  :     :  :     :           +- Project (5)
               :  :     :  :     :              +- Filter (4)
               :  :     :  :     :                 +- Scan parquet spark_catalog.imdb_10x.info_type (3)
               :  :     :  :     +- Project (12)
               :  :     :  :        +- Filter (11)
               :  :     :  :           +- Scan parquet spark_catalog.imdb_10x.title (10)
               :  :     :  +- Filter (16)
               :  :     :     +- Scan parquet spark_catalog.imdb_10x.movie_info_idx (15)
               :  :     +- BroadcastExchange (21)
               :  :        +- Project (20)
               :  :           +- Filter (19)
               :  :              +- Scan parquet spark_catalog.imdb_10x.info_type (18)
               :  +- BroadcastExchange (32)
               :     +- Project (31)
               :        +- BroadcastHashJoin Inner BuildRight (30)
               :           :- Filter (25)
               :           :  +- Scan parquet spark_catalog.imdb_10x.movie_keyword (24)
               :           +- BroadcastExchange (29)
               :              +- Project (28)
               :                 +- Filter (27)
               :                    +- Scan parquet spark_catalog.imdb_10x.keyword (26)
               +- BroadcastExchange (43)
                  +- Project (42)
                     +- BroadcastHashJoin Inner BuildLeft (41)
                        :- BroadcastExchange (37)
                        :  +- Project (36)
                        :     +- Filter (35)
                        :        +- Scan parquet spark_catalog.imdb_10x.cast_info (34)
                        +- Project (40)
                           +- Filter (39)
                              +- Scan parquet spark_catalog.imdb_10x.name (38)


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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=19478]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=19482]

(10) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#39, title#40, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(title), StringStartsWith(title,Vampire), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(11) Filter
Input [3]: [id#39, title#40, production_year#43]
Condition : ((((isnotnull(production_year#43) AND isnotnull(title#40)) AND (cast(production_year#43 as int) > 2010)) AND StartsWith(title#40, Vampire)) AND isnotnull(id#39))

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
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[2, int, true] as bigint) & 4294967295))),false), [plan_id=19485]

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
Output [2]: [id#1269, info#1270]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,votes), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(19) Filter
Input [2]: [id#1269, info#1270]
Condition : ((isnotnull(info#1270) AND (info#1270 = votes)) AND isnotnull(id#1269))

(20) Project
Output [1]: [id#1269]
Input [2]: [id#1269, info#1270]

(21) BroadcastExchange
Input [1]: [id#1269]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=19488]

(22) BroadcastHashJoin
Left keys [1]: [info_type_id#219]
Right keys [1]: [id#1269]
Join type: Inner
Join condition: None

(23) Project
Output [6]: [movie_id#213, info#215, id#39, title#40, movie_id#218, info#220]
Input [8]: [movie_id#213, info#215, id#39, title#40, movie_id#218, info_type_id#219, info#220, id#1269]

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
PushedFilters: [In(keyword, [blood,death,female-nudity,gore,murder]), IsNotNull(id)]
ReadSchema: struct<id:int,keyword:string>

(27) Filter
Input [2]: [id#110, keyword#111]
Condition : (keyword#111 IN (murder,blood,gore,death,female-nudity) AND isnotnull(id#110))

(28) Project
Output [1]: [id#110]
Input [2]: [id#110, keyword#111]

(29) BroadcastExchange
Input [1]: [id#110]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=19491]

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
Arguments: HashedRelationBroadcastMode(List(input[0, int, true], input[0, int, true], input[0, int, true]),false), [plan_id=19495]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=19497]

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
Arguments: HashedRelationBroadcastMode(List(input[0, int, true], input[0, int, true], input[0, int, true], input[0, int, true]),false), [plan_id=19501]

(44) BroadcastHashJoin
Left keys [4]: [movie_id#213, movie_id#218, movie_id#116, id#39]
Right keys [4]: [movie_id#18, movie_id#18, movie_id#18, movie_id#18]
Join type: Inner
Join condition: None

(45) Project
Output [4]: [info#215, info#220, name#541, title#40]
Input [9]: [movie_id#213, info#215, id#39, title#40, movie_id#218, info#220, movie_id#116, movie_id#18, name#541]

(46) SortAggregate
Input [4]: [info#215, info#220, name#541, title#40]
Keys: []
Functions [4]: [partial_min(info#215), partial_min(info#220), partial_min(name#541), partial_min(title#40)]
Aggregate Attributes [4]: [min#1276, min#1277, min#1278, min#1279]
Results [4]: [min#1280, min#1281, min#1282, min#1283]

(47) Exchange
Input [4]: [min#1280, min#1281, min#1282, min#1283]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=19506]

(48) SortAggregate
Input [4]: [min#1280, min#1281, min#1282, min#1283]
Keys: []
Functions [4]: [min(info#215), min(info#220), min(name#541), min(title#40)]
Aggregate Attributes [4]: [min(info#215)#1272, min(info#220)#1273, min(name#541)#1274, min(title#40)#1275]
Results [4]: [min(info#215)#1272 AS movie_budget#1260, min(info#220)#1273 AS movie_votes#1261, min(name#541)#1274 AS male_writer#1262, min(title#40)#1275 AS violent_movie_title#1263]

(49) AdaptiveSparkPlan
Output [4]: [movie_budget#1260, movie_votes#1261, male_writer#1262, violent_movie_title#1263]
Arguments: isFinalPlan=false
Execution Time: 36.998
