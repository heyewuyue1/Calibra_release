== Physical Plan ==
AdaptiveSparkPlan (38)
+- SortAggregate (37)
   +- Exchange (36)
      +- SortAggregate (35)
         +- Project (34)
            +- BroadcastHashJoin Inner BuildRight (33)
               :- Project (28)
               :  +- BroadcastHashJoin Inner BuildLeft (27)
               :     :- BroadcastExchange (24)
               :     :  +- Project (23)
               :     :     +- BroadcastHashJoin Inner BuildRight (22)
               :     :        :- BroadcastHashJoin Inner BuildLeft (17)
               :     :        :  :- BroadcastExchange (14)
               :     :        :  :  +- BroadcastHashJoin Inner BuildLeft (13)
               :     :        :  :     :- BroadcastExchange (10)
               :     :        :  :     :  +- Project (9)
               :     :        :  :     :     +- BroadcastHashJoin Inner BuildLeft (8)
               :     :        :  :     :        :- BroadcastExchange (4)
               :     :        :  :     :        :  +- Project (3)
               :     :        :  :     :        :     +- Filter (2)
               :     :        :  :     :        :        +- Scan parquet spark_catalog.imdb_10x.cast_info (1)
               :     :        :  :     :        +- Project (7)
               :     :        :  :     :           +- Filter (6)
               :     :        :  :     :              +- Scan parquet spark_catalog.imdb_10x.name (5)
               :     :        :  :     +- Filter (12)
               :     :        :  :        +- Scan parquet spark_catalog.imdb_10x.title (11)
               :     :        :  +- Filter (16)
               :     :        :     +- Scan parquet spark_catalog.imdb_10x.movie_info_idx (15)
               :     :        +- BroadcastExchange (21)
               :     :           +- Project (20)
               :     :              +- Filter (19)
               :     :                 +- Scan parquet spark_catalog.imdb_10x.info_type (18)
               :     +- Filter (26)
               :        +- Scan parquet spark_catalog.imdb_10x.movie_info (25)
               +- BroadcastExchange (32)
                  +- Project (31)
                     +- Filter (30)
                        +- Scan parquet spark_catalog.imdb_10x.info_type (29)


(1) Scan parquet spark_catalog.imdb_10x.cast_info
Output [3]: [person_id#17, movie_id#18, note#20]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/cast_info]
PushedFilters: [In(note, [(executive producer),(producer)]), IsNotNull(movie_id), IsNotNull(person_id)]
ReadSchema: struct<person_id:int,movie_id:int,note:string>

(2) Filter
Input [3]: [person_id#17, movie_id#18, note#20]
Condition : ((note#20 IN ((producer),(executive producer)) AND isnotnull(movie_id#18)) AND isnotnull(person_id#17))

(3) Project
Output [2]: [person_id#17, movie_id#18]
Input [3]: [person_id#17, movie_id#18, note#20]

(4) BroadcastExchange
Input [2]: [person_id#17, movie_id#18]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=9897]

(5) Scan parquet spark_catalog.imdb_10x.name
Output [3]: [id#540, name#541, gender#544]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/name]
PushedFilters: [IsNotNull(gender), IsNotNull(name), EqualTo(gender,m), StringContains(name,Tim), IsNotNull(id)]
ReadSchema: struct<id:int,name:string,gender:string>

(6) Filter
Input [3]: [id#540, name#541, gender#544]
Condition : ((((isnotnull(gender#544) AND isnotnull(name#541)) AND (gender#544 = m)) AND Contains(name#541, Tim)) AND isnotnull(id#540))

(7) Project
Output [1]: [id#540]
Input [3]: [id#540, name#541, gender#544]

(8) BroadcastHashJoin
Left keys [1]: [person_id#17]
Right keys [1]: [id#540]
Join type: Inner
Join condition: None

(9) Project
Output [1]: [movie_id#18]
Input [3]: [person_id#17, movie_id#18, id#540]

(10) BroadcastExchange
Input [1]: [movie_id#18]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=9901]

(11) Scan parquet spark_catalog.imdb_10x.title
Output [2]: [id#39, title#40]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int,title:string>

(12) Filter
Input [2]: [id#39, title#40]
Condition : isnotnull(id#39)

(13) BroadcastHashJoin
Left keys [1]: [movie_id#18]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(14) BroadcastExchange
Input [3]: [movie_id#18, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[1, int, false] as bigint) & 4294967295))),false), [plan_id=9904]

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
Left keys [2]: [movie_id#18, id#39]
Right keys [2]: [movie_id#218, movie_id#218]
Join type: Inner
Join condition: None

(18) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#704, info#705]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,votes), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(19) Filter
Input [2]: [id#704, info#705]
Condition : ((isnotnull(info#705) AND (info#705 = votes)) AND isnotnull(id#704))

(20) Project
Output [1]: [id#704]
Input [2]: [id#704, info#705]

(21) BroadcastExchange
Input [1]: [id#704]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=9907]

(22) BroadcastHashJoin
Left keys [1]: [info_type_id#219]
Right keys [1]: [id#704]
Join type: Inner
Join condition: None

(23) Project
Output [5]: [movie_id#18, id#39, title#40, movie_id#218, info#220]
Input [7]: [movie_id#18, id#39, title#40, movie_id#218, info_type_id#219, info#220, id#704]

(24) BroadcastExchange
Input [5]: [movie_id#18, id#39, title#40, movie_id#218, info#220]
Arguments: HashedRelationBroadcastMode(List(input[0, int, true], input[3, int, true], input[1, int, true]),false), [plan_id=9911]

(25) Scan parquet spark_catalog.imdb_10x.movie_info
Output [3]: [movie_id#213, info_type_id#214, info#215]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(26) Filter
Input [3]: [movie_id#213, info_type_id#214, info#215]
Condition : (isnotnull(movie_id#213) AND isnotnull(info_type_id#214))

(27) BroadcastHashJoin
Left keys [3]: [movie_id#18, movie_id#218, id#39]
Right keys [3]: [movie_id#213, movie_id#213, movie_id#213]
Join type: Inner
Join condition: None

(28) Project
Output [4]: [title#40, info#220, info_type_id#214, info#215]
Input [8]: [movie_id#18, id#39, title#40, movie_id#218, info#220, movie_id#213, info_type_id#214, info#215]

(29) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#210, info#211]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,budget), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(30) Filter
Input [2]: [id#210, info#211]
Condition : ((isnotnull(info#211) AND (info#211 = budget)) AND isnotnull(id#210))

(31) Project
Output [1]: [id#210]
Input [2]: [id#210, info#211]

(32) BroadcastExchange
Input [1]: [id#210]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=9915]

(33) BroadcastHashJoin
Left keys [1]: [info_type_id#214]
Right keys [1]: [id#210]
Join type: Inner
Join condition: None

(34) Project
Output [3]: [info#215, info#220, title#40]
Input [5]: [title#40, info#220, info_type_id#214, info#215, id#210]

(35) SortAggregate
Input [3]: [info#215, info#220, title#40]
Keys: []
Functions [3]: [partial_min(info#215), partial_min(info#220), partial_min(title#40)]
Aggregate Attributes [3]: [min#710, min#711, min#712]
Results [3]: [min#713, min#714, min#715]

(36) Exchange
Input [3]: [min#713, min#714, min#715]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=9920]

(37) SortAggregate
Input [3]: [min#713, min#714, min#715]
Keys: []
Functions [3]: [min(info#215), min(info#220), min(title#40)]
Aggregate Attributes [3]: [min(info#215)#706, min(info#220)#707, min(title#40)#708]
Results [3]: [min(info#215)#706 AS movie_budget#696, min(info#220)#707 AS movie_votes#697, min(title#40)#708 AS movie_title#698]

(38) AdaptiveSparkPlan
Output [3]: [movie_budget#696, movie_votes#697, movie_title#698]
Arguments: isFinalPlan=false
Execution Time: 39.99
