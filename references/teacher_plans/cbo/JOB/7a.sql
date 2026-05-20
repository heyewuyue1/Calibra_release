== Physical Plan ==
AdaptiveSparkPlan (44)
+- SortAggregate (43)
   +- Exchange (42)
      +- SortAggregate (41)
         +- Project (40)
            +- BroadcastHashJoin Inner BuildLeft (39)
               :- BroadcastExchange (35)
               :  +- Project (34)
               :     +- BroadcastHashJoin Inner BuildRight (33)
               :        :- Project (28)
               :        :  +- BroadcastHashJoin Inner BuildLeft (27)
               :        :     :- BroadcastExchange (24)
               :        :     :  +- BroadcastHashJoin Inner BuildLeft (23)
               :        :     :     :- BroadcastExchange (19)
               :        :     :     :  +- BroadcastHashJoin Inner BuildLeft (18)
               :        :     :     :     :- BroadcastExchange (15)
               :        :     :     :     :  +- BroadcastHashJoin Inner BuildLeft (14)
               :        :     :     :     :     :- BroadcastExchange (10)
               :        :     :     :     :     :  +- Project (9)
               :        :     :     :     :     :     +- BroadcastHashJoin Inner BuildRight (8)
               :        :     :     :     :     :        :- Project (3)
               :        :     :     :     :     :        :  +- Filter (2)
               :        :     :     :     :     :        :     +- Scan parquet spark_catalog.imdb_10x.person_info (1)
               :        :     :     :     :     :        +- BroadcastExchange (7)
               :        :     :     :     :     :           +- Project (6)
               :        :     :     :     :     :              +- Filter (5)
               :        :     :     :     :     :                 +- Scan parquet spark_catalog.imdb_10x.info_type (4)
               :        :     :     :     :     +- Project (13)
               :        :     :     :     :        +- Filter (12)
               :        :     :     :     :           +- Scan parquet spark_catalog.imdb_10x.name (11)
               :        :     :     :     +- Filter (17)
               :        :     :     :        +- Scan parquet spark_catalog.imdb_10x.cast_info (16)
               :        :     :     +- Project (22)
               :        :     :        +- Filter (21)
               :        :     :           +- Scan parquet spark_catalog.imdb_10x.title (20)
               :        :     +- Filter (26)
               :        :        +- Scan parquet spark_catalog.imdb_10x.movie_link (25)
               :        +- BroadcastExchange (32)
               :           +- Project (31)
               :              +- Filter (30)
               :                 +- Scan parquet spark_catalog.imdb_10x.link_type (29)
               +- Project (38)
                  +- Filter (37)
                     +- Scan parquet spark_catalog.imdb_10x.aka_name (36)


(1) Scan parquet spark_catalog.imdb_10x.person_info
Output [3]: [person_id#1554, info_type_id#1555, note#1557]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/person_info]
PushedFilters: [IsNotNull(note), EqualTo(note,Volker Boehm), IsNotNull(person_id), IsNotNull(info_type_id)]
ReadSchema: struct<person_id:int,info_type_id:int,note:string>

(2) Filter
Input [3]: [person_id#1554, info_type_id#1555, note#1557]
Condition : (((isnotnull(note#1557) AND (note#1557 = Volker Boehm)) AND isnotnull(person_id#1554)) AND isnotnull(info_type_id#1555))

(3) Project
Output [2]: [person_id#1554, info_type_id#1555]
Input [3]: [person_id#1554, info_type_id#1555, note#1557]

(4) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#210, info#211]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,mini biography), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(5) Filter
Input [2]: [id#210, info#211]
Condition : ((isnotnull(info#211) AND (info#211 = mini biography)) AND isnotnull(id#210))

(6) Project
Output [1]: [id#210]
Input [2]: [id#210, info#211]

(7) BroadcastExchange
Input [1]: [id#210]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=34863]

(8) BroadcastHashJoin
Left keys [1]: [info_type_id#1555]
Right keys [1]: [id#210]
Join type: Inner
Join condition: None

(9) Project
Output [1]: [person_id#1554]
Input [3]: [person_id#1554, info_type_id#1555, id#210]

(10) BroadcastExchange
Input [1]: [person_id#1554]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=34867]

(11) Scan parquet spark_catalog.imdb_10x.name
Output [4]: [id#540, name#541, gender#544, name_pcode_cf#545]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/name]
PushedFilters: [IsNotNull(name_pcode_cf), GreaterThanOrEqual(name_pcode_cf,A), LessThanOrEqual(name_pcode_cf,F), Or(EqualTo(gender,m),And(EqualTo(gender,f),StringStartsWith(name,B))), IsNotNull(id)]
ReadSchema: struct<id:int,name:string,gender:string,name_pcode_cf:string>

(12) Filter
Input [4]: [id#540, name#541, gender#544, name_pcode_cf#545]
Condition : ((((isnotnull(name_pcode_cf#545) AND (name_pcode_cf#545 >= A)) AND (name_pcode_cf#545 <= F)) AND ((gender#544 = m) OR ((gender#544 = f) AND StartsWith(name#541, B)))) AND isnotnull(id#540))

(13) Project
Output [2]: [id#540, name#541]
Input [4]: [id#540, name#541, gender#544, name_pcode_cf#545]

(14) BroadcastHashJoin
Left keys [1]: [person_id#1554]
Right keys [1]: [id#540]
Join type: Inner
Join condition: None

(15) BroadcastExchange
Input [3]: [person_id#1554, id#540, name#541]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[1, int, true] as bigint), 32) | (cast(input[0, int, true] as bigint) & 4294967295))),false), [plan_id=34870]

(16) Scan parquet spark_catalog.imdb_10x.cast_info
Output [2]: [person_id#17, movie_id#18]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/cast_info]
PushedFilters: [IsNotNull(person_id), IsNotNull(movie_id)]
ReadSchema: struct<person_id:int,movie_id:int>

(17) Filter
Input [2]: [person_id#17, movie_id#18]
Condition : (isnotnull(person_id#17) AND isnotnull(movie_id#18))

(18) BroadcastHashJoin
Left keys [2]: [id#540, person_id#1554]
Right keys [2]: [person_id#17, person_id#17]
Join type: Inner
Join condition: None

(19) BroadcastExchange
Input [5]: [person_id#1554, id#540, name#541, person_id#17, movie_id#18]
Arguments: HashedRelationBroadcastMode(List(cast(input[4, int, false] as bigint)),false), [plan_id=34873]

(20) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#39, title#40, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(21) Filter
Input [3]: [id#39, title#40, production_year#43]
Condition : (((isnotnull(production_year#43) AND (cast(production_year#43 as int) >= 1980)) AND (cast(production_year#43 as int) <= 1995)) AND isnotnull(id#39))

(22) Project
Output [2]: [id#39, title#40]
Input [3]: [id#39, title#40, production_year#43]

(23) BroadcastHashJoin
Left keys [1]: [movie_id#18]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(24) BroadcastExchange
Input [7]: [person_id#1554, id#540, name#541, person_id#17, movie_id#18, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[4, int, false] as bigint), 32) | (cast(input[5, int, true] as bigint) & 4294967295))),false), [plan_id=34876]

(25) Scan parquet spark_catalog.imdb_10x.movie_link
Output [2]: [linked_movie_id#120, link_type_id#121]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_link]
PushedFilters: [IsNotNull(linked_movie_id), IsNotNull(link_type_id)]
ReadSchema: struct<linked_movie_id:int,link_type_id:int>

(26) Filter
Input [2]: [linked_movie_id#120, link_type_id#121]
Condition : (isnotnull(linked_movie_id#120) AND isnotnull(link_type_id#121))

(27) BroadcastHashJoin
Left keys [2]: [movie_id#18, id#39]
Right keys [2]: [linked_movie_id#120, linked_movie_id#120]
Join type: Inner
Join condition: None

(28) Project
Output [6]: [person_id#1554, id#540, name#541, person_id#17, title#40, link_type_id#121]
Input [9]: [person_id#1554, id#540, name#541, person_id#17, movie_id#18, id#39, title#40, linked_movie_id#120, link_type_id#121]

(29) Scan parquet spark_catalog.imdb_10x.link_type
Output [2]: [id#113, link#114]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/link_type]
PushedFilters: [IsNotNull(link), EqualTo(link,features), IsNotNull(id)]
ReadSchema: struct<id:int,link:string>

(30) Filter
Input [2]: [id#113, link#114]
Condition : ((isnotnull(link#114) AND (link#114 = features)) AND isnotnull(id#113))

(31) Project
Output [1]: [id#113]
Input [2]: [id#113, link#114]

(32) BroadcastExchange
Input [1]: [id#113]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=34880]

(33) BroadcastHashJoin
Left keys [1]: [link_type_id#121]
Right keys [1]: [id#113]
Join type: Inner
Join condition: None

(34) Project
Output [5]: [person_id#1554, id#540, name#541, person_id#17, title#40]
Input [7]: [person_id#1554, id#540, name#541, person_id#17, title#40, link_type_id#121, id#113]

(35) BroadcastExchange
Input [5]: [person_id#1554, id#540, name#541, person_id#17, title#40]
Arguments: HashedRelationBroadcastMode(List(input[3, int, true], input[1, int, true], input[0, int, true]),false), [plan_id=34884]

(36) Scan parquet spark_catalog.imdb_10x.aka_name
Output [2]: [person_id#533, name#534]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/aka_name]
PushedFilters: [IsNotNull(name), StringContains(name,a), IsNotNull(person_id)]
ReadSchema: struct<person_id:int,name:string>

(37) Filter
Input [2]: [person_id#533, name#534]
Condition : ((isnotnull(name#534) AND Contains(name#534, a)) AND isnotnull(person_id#533))

(38) Project
Output [1]: [person_id#533]
Input [2]: [person_id#533, name#534]

(39) BroadcastHashJoin
Left keys [3]: [person_id#17, id#540, person_id#1554]
Right keys [3]: [person_id#533, person_id#533, person_id#533]
Join type: Inner
Join condition: None

(40) Project
Output [2]: [name#541, title#40]
Input [6]: [person_id#1554, id#540, name#541, person_id#17, title#40, person_id#533]

(41) SortAggregate
Input [2]: [name#541, title#40]
Keys: []
Functions [2]: [partial_min(name#541), partial_min(title#40)]
Aggregate Attributes [2]: [min#2409, min#2410]
Results [2]: [min#2411, min#2412]

(42) Exchange
Input [2]: [min#2411, min#2412]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=34889]

(43) SortAggregate
Input [2]: [min#2411, min#2412]
Keys: []
Functions [2]: [min(name#541), min(title#40)]
Aggregate Attributes [2]: [min(name#541)#2407, min(title#40)#2408]
Results [2]: [min(name#541)#2407 AS of_person#2400, min(title#40)#2408 AS biography_movie#2401]

(44) AdaptiveSparkPlan
Output [2]: [of_person#2400, biography_movie#2401]
Arguments: isFinalPlan=false
Execution Time: 16.441
