== Physical Plan ==
AdaptiveSparkPlan (38)
+- SortAggregate (37)
   +- Exchange (36)
      +- SortAggregate (35)
         +- Project (34)
            +- BroadcastHashJoin Inner BuildRight (33)
               :- Project (22)
               :  +- BroadcastHashJoin Inner BuildRight (21)
               :     :- BroadcastHashJoin Inner BuildLeft (16)
               :     :  :- BroadcastExchange (13)
               :     :  :  +- BroadcastHashJoin Inner BuildLeft (12)
               :     :  :     :- BroadcastExchange (9)
               :     :  :     :  +- Project (8)
               :     :  :     :     +- BroadcastHashJoin Inner BuildRight (7)
               :     :  :     :        :- Filter (2)
               :     :  :     :        :  +- Scan parquet spark_catalog.imdb_10x.movie_info (1)
               :     :  :     :        +- BroadcastExchange (6)
               :     :  :     :           +- Project (5)
               :     :  :     :              +- Filter (4)
               :     :  :     :                 +- Scan parquet spark_catalog.imdb_10x.info_type (3)
               :     :  :     +- Filter (11)
               :     :  :        +- Scan parquet spark_catalog.imdb_10x.title (10)
               :     :  +- Filter (15)
               :     :     +- Scan parquet spark_catalog.imdb_10x.movie_info_idx (14)
               :     +- BroadcastExchange (20)
               :        +- Project (19)
               :           +- Filter (18)
               :              +- Scan parquet spark_catalog.imdb_10x.info_type (17)
               +- BroadcastExchange (32)
                  +- Project (31)
                     +- BroadcastHashJoin Inner BuildLeft (30)
                        :- BroadcastExchange (26)
                        :  +- Project (25)
                        :     +- Filter (24)
                        :        +- Scan parquet spark_catalog.imdb_10x.cast_info (23)
                        +- Project (29)
                           +- Filter (28)
                              +- Scan parquet spark_catalog.imdb_10x.name (27)


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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=10439]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=10443]

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
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[2, int, false] as bigint) & 4294967295))),false), [plan_id=10446]

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
Output [2]: [id#752, info#753]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,votes), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(18) Filter
Input [2]: [id#752, info#753]
Condition : ((isnotnull(info#753) AND (info#753 = votes)) AND isnotnull(id#752))

(19) Project
Output [1]: [id#752]
Input [2]: [id#752, info#753]

(20) BroadcastExchange
Input [1]: [id#752]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=10449]

(21) BroadcastHashJoin
Left keys [1]: [info_type_id#219]
Right keys [1]: [id#752]
Join type: Inner
Join condition: None

(22) Project
Output [6]: [movie_id#213, info#215, id#39, title#40, movie_id#218, info#220]
Input [8]: [movie_id#213, info#215, id#39, title#40, movie_id#218, info_type_id#219, info#220, id#752]

(23) Scan parquet spark_catalog.imdb_10x.cast_info
Output [3]: [person_id#17, movie_id#18, note#20]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/cast_info]
PushedFilters: [In(note, [(head writer),(story editor),(story),(writer),(written by)]), IsNotNull(movie_id), IsNotNull(person_id)]
ReadSchema: struct<person_id:int,movie_id:int,note:string>

(24) Filter
Input [3]: [person_id#17, movie_id#18, note#20]
Condition : ((note#20 IN ((writer),(head writer),(written by),(story),(story editor)) AND isnotnull(movie_id#18)) AND isnotnull(person_id#17))

(25) Project
Output [2]: [person_id#17, movie_id#18]
Input [3]: [person_id#17, movie_id#18, note#20]

(26) BroadcastExchange
Input [2]: [person_id#17, movie_id#18]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=10452]

(27) Scan parquet spark_catalog.imdb_10x.name
Output [2]: [id#540, gender#544]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/name]
PushedFilters: [IsNotNull(gender), EqualTo(gender,m), IsNotNull(id)]
ReadSchema: struct<id:int,gender:string>

(28) Filter
Input [2]: [id#540, gender#544]
Condition : ((isnotnull(gender#544) AND (gender#544 = m)) AND isnotnull(id#540))

(29) Project
Output [1]: [id#540]
Input [2]: [id#540, gender#544]

(30) BroadcastHashJoin
Left keys [1]: [person_id#17]
Right keys [1]: [id#540]
Join type: Inner
Join condition: None

(31) Project
Output [1]: [movie_id#18]
Input [3]: [person_id#17, movie_id#18, id#540]

(32) BroadcastExchange
Input [1]: [movie_id#18]
Arguments: HashedRelationBroadcastMode(List(input[0, int, true], input[0, int, true], input[0, int, true]),false), [plan_id=10456]

(33) BroadcastHashJoin
Left keys [3]: [movie_id#213, movie_id#218, id#39]
Right keys [3]: [movie_id#18, movie_id#18, movie_id#18]
Join type: Inner
Join condition: None

(34) Project
Output [3]: [info#215, info#220, title#40]
Input [7]: [movie_id#213, info#215, id#39, title#40, movie_id#218, info#220, movie_id#18]

(35) SortAggregate
Input [3]: [info#215, info#220, title#40]
Keys: []
Functions [3]: [partial_min(info#215), partial_min(info#220), partial_min(title#40)]
Aggregate Attributes [3]: [min#758, min#759, min#760]
Results [3]: [min#761, min#762, min#763]

(36) Exchange
Input [3]: [min#761, min#762, min#763]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=10461]

(37) SortAggregate
Input [3]: [min#761, min#762, min#763]
Keys: []
Functions [3]: [min(info#215), min(info#220), min(title#40)]
Aggregate Attributes [3]: [min(info#215)#754, min(info#220)#755, min(title#40)#756]
Results [3]: [min(info#215)#754 AS movie_budget#744, min(info#220)#755 AS movie_votes#745, min(title#40)#756 AS movie_title#746]

(38) AdaptiveSparkPlan
Output [3]: [movie_budget#744, movie_votes#745, movie_title#746]
Arguments: isFinalPlan=false
Execution Time: 35.243
