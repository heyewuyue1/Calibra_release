== Physical Plan ==
AdaptiveSparkPlan (53)
+- SortAggregate (52)
   +- Exchange (51)
      +- SortAggregate (50)
         +- Project (49)
            +- SortMergeJoin Inner (48)
               :- Sort (28)
               :  +- Exchange (27)
               :     +- SortMergeJoin Inner (26)
               :        :- Sort (20)
               :        :  +- Exchange (19)
               :        :     +- Project (18)
               :        :        +- BroadcastHashJoin Inner BuildLeft (17)
               :        :           :- BroadcastExchange (14)
               :        :           :  +- BroadcastHashJoin Inner BuildLeft (13)
               :        :           :     :- BroadcastExchange (9)
               :        :           :     :  +- Project (8)
               :        :           :     :     +- BroadcastHashJoin Inner BuildRight (7)
               :        :           :     :        :- Filter (2)
               :        :           :     :        :  +- Scan parquet spark_catalog.imdb_10x.movie_link (1)
               :        :           :     :        +- BroadcastExchange (6)
               :        :           :     :           +- Project (5)
               :        :           :     :              +- Filter (4)
               :        :           :     :                 +- Scan parquet spark_catalog.imdb_10x.link_type (3)
               :        :           :     +- Project (12)
               :        :           :        +- Filter (11)
               :        :           :           +- Scan parquet spark_catalog.imdb_10x.title (10)
               :        :           +- Filter (16)
               :        :              +- Scan parquet spark_catalog.imdb_10x.cast_info (15)
               :        +- Sort (25)
               :           +- Exchange (24)
               :              +- Project (23)
               :                 +- Filter (22)
               :                    +- Scan parquet spark_catalog.imdb_10x.aka_name (21)
               +- Sort (47)
                  +- Exchange (46)
                     +- SortMergeJoin Inner (45)
                        :- Sort (39)
                        :  +- Exchange (38)
                        :     +- Project (37)
                        :        +- BroadcastHashJoin Inner BuildRight (36)
                        :           :- Project (31)
                        :           :  +- Filter (30)
                        :           :     +- Scan parquet spark_catalog.imdb_10x.person_info (29)
                        :           +- BroadcastExchange (35)
                        :              +- Project (34)
                        :                 +- Filter (33)
                        :                    +- Scan parquet spark_catalog.imdb_10x.info_type (32)
                        +- Sort (44)
                           +- Exchange (43)
                              +- Project (42)
                                 +- Filter (41)
                                    +- Scan parquet spark_catalog.imdb_10x.name (40)


(1) Scan parquet spark_catalog.imdb_10x.movie_link
Output [2]: [linked_movie_id#120, link_type_id#121]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_link]
PushedFilters: [IsNotNull(linked_movie_id), IsNotNull(link_type_id)]
ReadSchema: struct<linked_movie_id:int,link_type_id:int>

(2) Filter
Input [2]: [linked_movie_id#120, link_type_id#121]
Condition : (isnotnull(linked_movie_id#120) AND isnotnull(link_type_id#121))

(3) Scan parquet spark_catalog.imdb_10x.link_type
Output [2]: [id#113, link#114]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/link_type]
PushedFilters: [In(link, [featured in,features,referenced in,references]), IsNotNull(id)]
ReadSchema: struct<id:int,link:string>

(4) Filter
Input [2]: [id#113, link#114]
Condition : (link#114 IN (references,referenced in,features,featured in) AND isnotnull(id#113))

(5) Project
Output [1]: [id#113]
Input [2]: [id#113, link#114]

(6) BroadcastExchange
Input [1]: [id#113]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=35469]

(7) BroadcastHashJoin
Left keys [1]: [link_type_id#121]
Right keys [1]: [id#113]
Join type: Inner
Join condition: None

(8) Project
Output [1]: [linked_movie_id#120]
Input [3]: [linked_movie_id#120, link_type_id#121, id#113]

(9) BroadcastExchange
Input [1]: [linked_movie_id#120]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=35473]

(10) Scan parquet spark_catalog.imdb_10x.title
Output [2]: [id#39, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id)]
ReadSchema: struct<id:int,production_year:string>

(11) Filter
Input [2]: [id#39, production_year#43]
Condition : (((isnotnull(production_year#43) AND (cast(production_year#43 as int) >= 1980)) AND (cast(production_year#43 as int) <= 2010)) AND isnotnull(id#39))

(12) Project
Output [1]: [id#39]
Input [2]: [id#39, production_year#43]

(13) BroadcastHashJoin
Left keys [1]: [linked_movie_id#120]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(14) BroadcastExchange
Input [2]: [linked_movie_id#120, id#39]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[1, int, true] as bigint) & 4294967295))),false), [plan_id=35476]

(15) Scan parquet spark_catalog.imdb_10x.cast_info
Output [2]: [person_id#17, movie_id#18]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/cast_info]
PushedFilters: [IsNotNull(person_id), IsNotNull(movie_id)]
ReadSchema: struct<person_id:int,movie_id:int>

(16) Filter
Input [2]: [person_id#17, movie_id#18]
Condition : (isnotnull(person_id#17) AND isnotnull(movie_id#18))

(17) BroadcastHashJoin
Left keys [2]: [linked_movie_id#120, id#39]
Right keys [2]: [movie_id#18, movie_id#18]
Join type: Inner
Join condition: None

(18) Project
Output [1]: [person_id#17]
Input [4]: [linked_movie_id#120, id#39, person_id#17, movie_id#18]

(19) Exchange
Input [1]: [person_id#17]
Arguments: hashpartitioning(person_id#17, 200), ENSURE_REQUIREMENTS, [plan_id=35481]

(20) Sort
Input [1]: [person_id#17]
Arguments: [person_id#17 ASC NULLS FIRST], false, 0

(21) Scan parquet spark_catalog.imdb_10x.aka_name
Output [2]: [person_id#533, name#534]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/aka_name]
PushedFilters: [IsNotNull(name), Or(StringContains(name,a),StringStartsWith(name,A)), IsNotNull(person_id)]
ReadSchema: struct<person_id:int,name:string>

(22) Filter
Input [2]: [person_id#533, name#534]
Condition : ((isnotnull(name#534) AND (Contains(name#534, a) OR StartsWith(name#534, A))) AND isnotnull(person_id#533))

(23) Project
Output [1]: [person_id#533]
Input [2]: [person_id#533, name#534]

(24) Exchange
Input [1]: [person_id#533]
Arguments: hashpartitioning(person_id#533, 200), ENSURE_REQUIREMENTS, [plan_id=35482]

(25) Sort
Input [1]: [person_id#533]
Arguments: [person_id#533 ASC NULLS FIRST], false, 0

(26) SortMergeJoin
Left keys [1]: [person_id#17]
Right keys [1]: [person_id#533]
Join type: Inner
Join condition: None

(27) Exchange
Input [2]: [person_id#17, person_id#533]
Arguments: hashpartitioning(person_id#533, person_id#17, person_id#533, person_id#17, 200), ENSURE_REQUIREMENTS, [plan_id=35498]

(28) Sort
Input [2]: [person_id#17, person_id#533]
Arguments: [person_id#533 ASC NULLS FIRST, person_id#17 ASC NULLS FIRST, person_id#533 ASC NULLS FIRST, person_id#17 ASC NULLS FIRST], false, 0

(29) Scan parquet spark_catalog.imdb_10x.person_info
Output [4]: [person_id#1554, info_type_id#1555, info#1556, note#1557]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/person_info]
PushedFilters: [IsNotNull(note), IsNotNull(person_id), IsNotNull(info_type_id)]
ReadSchema: struct<person_id:int,info_type_id:int,info:string,note:string>

(30) Filter
Input [4]: [person_id#1554, info_type_id#1555, info#1556, note#1557]
Condition : ((isnotnull(note#1557) AND isnotnull(person_id#1554)) AND isnotnull(info_type_id#1555))

(31) Project
Output [3]: [person_id#1554, info_type_id#1555, info#1556]
Input [4]: [person_id#1554, info_type_id#1555, info#1556, note#1557]

(32) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#210, info#211]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,mini biography), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(33) Filter
Input [2]: [id#210, info#211]
Condition : ((isnotnull(info#211) AND (info#211 = mini biography)) AND isnotnull(id#210))

(34) Project
Output [1]: [id#210]
Input [2]: [id#210, info#211]

(35) BroadcastExchange
Input [1]: [id#210]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=35486]

(36) BroadcastHashJoin
Left keys [1]: [info_type_id#1555]
Right keys [1]: [id#210]
Join type: Inner
Join condition: None

(37) Project
Output [2]: [person_id#1554, info#1556]
Input [4]: [person_id#1554, info_type_id#1555, info#1556, id#210]

(38) Exchange
Input [2]: [person_id#1554, info#1556]
Arguments: hashpartitioning(person_id#1554, 200), ENSURE_REQUIREMENTS, [plan_id=35491]

(39) Sort
Input [2]: [person_id#1554, info#1556]
Arguments: [person_id#1554 ASC NULLS FIRST], false, 0

(40) Scan parquet spark_catalog.imdb_10x.name
Output [4]: [id#540, name#541, gender#544, name_pcode_cf#545]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/name]
PushedFilters: [IsNotNull(name_pcode_cf), GreaterThanOrEqual(name_pcode_cf,A), LessThanOrEqual(name_pcode_cf,F), Or(EqualTo(gender,m),And(EqualTo(gender,f),StringStartsWith(name,A))), IsNotNull(id)]
ReadSchema: struct<id:int,name:string,gender:string,name_pcode_cf:string>

(41) Filter
Input [4]: [id#540, name#541, gender#544, name_pcode_cf#545]
Condition : ((((isnotnull(name_pcode_cf#545) AND (name_pcode_cf#545 >= A)) AND (name_pcode_cf#545 <= F)) AND ((gender#544 = m) OR ((gender#544 = f) AND StartsWith(name#541, A)))) AND isnotnull(id#540))

(42) Project
Output [2]: [id#540, name#541]
Input [4]: [id#540, name#541, gender#544, name_pcode_cf#545]

(43) Exchange
Input [2]: [id#540, name#541]
Arguments: hashpartitioning(id#540, 200), ENSURE_REQUIREMENTS, [plan_id=35492]

(44) Sort
Input [2]: [id#540, name#541]
Arguments: [id#540 ASC NULLS FIRST], false, 0

(45) SortMergeJoin
Left keys [1]: [person_id#1554]
Right keys [1]: [id#540]
Join type: Inner
Join condition: None

(46) Exchange
Input [4]: [person_id#1554, info#1556, id#540, name#541]
Arguments: hashpartitioning(id#540, id#540, person_id#1554, person_id#1554, 200), ENSURE_REQUIREMENTS, [plan_id=35499]

(47) Sort
Input [4]: [person_id#1554, info#1556, id#540, name#541]
Arguments: [id#540 ASC NULLS FIRST, id#540 ASC NULLS FIRST, person_id#1554 ASC NULLS FIRST, person_id#1554 ASC NULLS FIRST], false, 0

(48) SortMergeJoin
Left keys [4]: [person_id#533, person_id#17, person_id#533, person_id#17]
Right keys [4]: [id#540, id#540, person_id#1554, person_id#1554]
Join type: Inner
Join condition: None

(49) Project
Output [2]: [name#541, info#1556]
Input [6]: [person_id#17, person_id#533, person_id#1554, info#1556, id#540, name#541]

(50) SortAggregate
Input [2]: [name#541, info#1556]
Keys: []
Functions [2]: [partial_min(name#541), partial_min(info#1556)]
Aggregate Attributes [2]: [min#2443, min#2444]
Results [2]: [min#2445, min#2446]

(51) Exchange
Input [2]: [min#2445, min#2446]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=35506]

(52) SortAggregate
Input [2]: [min#2445, min#2446]
Keys: []
Functions [2]: [min(name#541), min(info#1556)]
Aggregate Attributes [2]: [min(name#541)#2441, min(info#1556)#2442]
Results [2]: [min(name#541)#2441 AS cast_member_name#2434, min(info#1556)#2442 AS cast_member_info#2435]

(53) AdaptiveSparkPlan
Output [2]: [cast_member_name#2434, cast_member_info#2435]
Arguments: isFinalPlan=false
Execution Time: 22.78
