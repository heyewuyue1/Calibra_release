== Physical Plan ==
AdaptiveSparkPlan (59)
+- SortAggregate (58)
   +- Exchange (57)
      +- SortAggregate (56)
         +- Project (55)
            +- SortMergeJoin Inner (54)
               :- Sort (48)
               :  +- Exchange (47)
               :     +- Project (46)
               :        +- BroadcastHashJoin Inner BuildLeft (45)
               :           :- BroadcastExchange (30)
               :           :  +- Project (29)
               :           :     +- BroadcastHashJoin Inner BuildLeft (28)
               :           :        :- BroadcastExchange (24)
               :           :        :  +- BroadcastHashJoin Inner BuildLeft (23)
               :           :        :     :- BroadcastExchange (20)
               :           :        :     :  +- Project (19)
               :           :        :     :     +- BroadcastHashJoin Inner BuildRight (18)
               :           :        :     :        :- BroadcastHashJoin Inner BuildLeft (13)
               :           :        :     :        :  :- BroadcastExchange (9)
               :           :        :     :        :  :  +- Project (8)
               :           :        :     :        :  :     +- BroadcastHashJoin Inner BuildRight (7)
               :           :        :     :        :  :        :- Filter (2)
               :           :        :     :        :  :        :  +- Scan parquet spark_catalog.imdb_10x.movie_keyword (1)
               :           :        :     :        :  :        +- BroadcastExchange (6)
               :           :        :     :        :  :           +- Project (5)
               :           :        :     :        :  :              +- Filter (4)
               :           :        :     :        :  :                 +- Scan parquet spark_catalog.imdb_10x.keyword (3)
               :           :        :     :        :  +- Project (12)
               :           :        :     :        :     +- Filter (11)
               :           :        :     :        :        +- Scan parquet spark_catalog.imdb_10x.title (10)
               :           :        :     :        +- BroadcastExchange (17)
               :           :        :     :           +- Project (16)
               :           :        :     :              +- Filter (15)
               :           :        :     :                 +- Scan parquet spark_catalog.imdb_10x.kind_type (14)
               :           :        :     +- Filter (22)
               :           :        :        +- Scan parquet spark_catalog.imdb_10x.cast_info (21)
               :           :        +- Project (27)
               :           :           +- Filter (26)
               :           :              +- Scan parquet spark_catalog.imdb_10x.name (25)
               :           +- Project (44)
               :              +- BroadcastHashJoin Inner BuildRight (43)
               :                 :- Project (38)
               :                 :  +- BroadcastHashJoin Inner BuildRight (37)
               :                 :     :- Filter (32)
               :                 :     :  +- Scan parquet spark_catalog.imdb_10x.complete_cast (31)
               :                 :     +- BroadcastExchange (36)
               :                 :        +- Project (35)
               :                 :           +- Filter (34)
               :                 :              +- Scan parquet spark_catalog.imdb_10x.comp_cast_type (33)
               :                 +- BroadcastExchange (42)
               :                    +- Project (41)
               :                       +- Filter (40)
               :                          +- Scan parquet spark_catalog.imdb_10x.comp_cast_type (39)
               +- Sort (53)
                  +- Exchange (52)
                     +- Project (51)
                        +- Filter (50)
                           +- Scan parquet spark_catalog.imdb_10x.char_name (49)


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
PushedFilters: [In(keyword, [based-on-comic,fight,marvel-comics,second-part,sequel,superhero,tv-special,violence]), IsNotNull(id)]
ReadSchema: struct<id:int,keyword:string>

(4) Filter
Input [2]: [id#110, keyword#111]
Condition : (keyword#111 IN (superhero,sequel,second-part,marvel-comics,based-on-comic,tv-special,fight,violence) AND isnotnull(id#110))

(5) Project
Output [1]: [id#110]
Input [2]: [id#110, keyword#111]

(6) BroadcastExchange
Input [1]: [id#110]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=13579]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=13583]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=13586]

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
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[1, int, true] as bigint) & 4294967295))),false), [plan_id=13590]

(21) Scan parquet spark_catalog.imdb_10x.cast_info
Output [3]: [person_id#17, movie_id#18, person_role_id#19]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/cast_info]
PushedFilters: [IsNotNull(movie_id), IsNotNull(person_id), IsNotNull(person_role_id)]
ReadSchema: struct<person_id:int,movie_id:int,person_role_id:string>

(22) Filter
Input [3]: [person_id#17, movie_id#18, person_role_id#19]
Condition : ((isnotnull(movie_id#18) AND isnotnull(person_id#17)) AND isnotnull(person_role_id#19))

(23) BroadcastHashJoin
Left keys [2]: [movie_id#116, id#39]
Right keys [2]: [movie_id#18, movie_id#18]
Join type: Inner
Join condition: None

(24) BroadcastExchange
Input [6]: [movie_id#116, id#39, title#40, person_id#17, movie_id#18, person_role_id#19]
Arguments: HashedRelationBroadcastMode(List(cast(input[3, int, false] as bigint)),false), [plan_id=13593]

(25) Scan parquet spark_catalog.imdb_10x.name
Output [2]: [id#540, name#541]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/name]
PushedFilters: [IsNotNull(name), IsNotNull(id)]
ReadSchema: struct<id:int,name:string>

(26) Filter
Input [2]: [id#540, name#541]
Condition : ((isnotnull(name#541) AND name#541 LIKE %Downey%Robert%) AND isnotnull(id#540))

(27) Project
Output [1]: [id#540]
Input [2]: [id#540, name#541]

(28) BroadcastHashJoin
Left keys [1]: [person_id#17]
Right keys [1]: [id#540]
Join type: Inner
Join condition: None

(29) Project
Output [5]: [movie_id#116, id#39, title#40, movie_id#18, person_role_id#19]
Input [7]: [movie_id#116, id#39, title#40, person_id#17, movie_id#18, person_role_id#19, id#540]

(30) BroadcastExchange
Input [5]: [movie_id#116, id#39, title#40, movie_id#18, person_role_id#19]
Arguments: HashedRelationBroadcastMode(List(input[3, int, true], input[0, int, true], input[1, int, true]),false), [plan_id=13604]

(31) Scan parquet spark_catalog.imdb_10x.complete_cast
Output [3]: [movie_id#927, subject_id#928, status_id#929]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/complete_cast]
PushedFilters: [IsNotNull(subject_id), IsNotNull(status_id), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:string,subject_id:int,status_id:int>

(32) Filter
Input [3]: [movie_id#927, subject_id#928, status_id#929]
Condition : ((isnotnull(subject_id#928) AND isnotnull(status_id#929)) AND isnotnull(movie_id#927))

(33) Scan parquet spark_catalog.imdb_10x.comp_cast_type
Output [2]: [id#930, kind#931]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/comp_cast_type]
PushedFilters: [IsNotNull(kind), EqualTo(kind,cast), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(34) Filter
Input [2]: [id#930, kind#931]
Condition : ((isnotnull(kind#931) AND (kind#931 = cast)) AND isnotnull(id#930))

(35) Project
Output [1]: [id#930]
Input [2]: [id#930, kind#931]

(36) BroadcastExchange
Input [1]: [id#930]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=13596]

(37) BroadcastHashJoin
Left keys [1]: [subject_id#928]
Right keys [1]: [id#930]
Join type: Inner
Join condition: None

(38) Project
Output [2]: [movie_id#927, status_id#929]
Input [4]: [movie_id#927, subject_id#928, status_id#929, id#930]

(39) Scan parquet spark_catalog.imdb_10x.comp_cast_type
Output [2]: [id#950, kind#951]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/comp_cast_type]
PushedFilters: [IsNotNull(kind), StringContains(kind,complete), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(40) Filter
Input [2]: [id#950, kind#951]
Condition : ((isnotnull(kind#951) AND Contains(kind#951, complete)) AND isnotnull(id#950))

(41) Project
Output [1]: [id#950]
Input [2]: [id#950, kind#951]

(42) BroadcastExchange
Input [1]: [id#950]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=13600]

(43) BroadcastHashJoin
Left keys [1]: [status_id#929]
Right keys [1]: [id#950]
Join type: Inner
Join condition: None

(44) Project
Output [1]: [movie_id#927]
Input [3]: [movie_id#927, status_id#929, id#950]

(45) BroadcastHashJoin
Left keys [3]: [movie_id#18, movie_id#116, id#39]
Right keys [3]: [cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int)]
Join type: Inner
Join condition: None

(46) Project
Output [2]: [title#40, person_role_id#19]
Input [6]: [movie_id#116, id#39, title#40, movie_id#18, person_role_id#19, movie_id#927]

(47) Exchange
Input [2]: [title#40, person_role_id#19]
Arguments: hashpartitioning(cast(person_role_id#19 as int), 200), ENSURE_REQUIREMENTS, [plan_id=13609]

(48) Sort
Input [2]: [title#40, person_role_id#19]
Arguments: [cast(person_role_id#19 as int) ASC NULLS FIRST], false, 0

(49) Scan parquet spark_catalog.imdb_10x.char_name
Output [2]: [id#9, name#10]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/char_name]
PushedFilters: [IsNotNull(name), Not(StringContains(name,Sherlock)), IsNotNull(id)]
ReadSchema: struct<id:int,name:string>

(50) Filter
Input [2]: [id#9, name#10]
Condition : (((isnotnull(name#10) AND NOT Contains(name#10, Sherlock)) AND (name#10 LIKE %Tony%Stark% OR name#10 LIKE %Iron%Man%)) AND isnotnull(id#9))

(51) Project
Output [1]: [id#9]
Input [2]: [id#9, name#10]

(52) Exchange
Input [1]: [id#9]
Arguments: hashpartitioning(id#9, 200), ENSURE_REQUIREMENTS, [plan_id=13610]

(53) Sort
Input [1]: [id#9]
Arguments: [id#9 ASC NULLS FIRST], false, 0

(54) SortMergeJoin
Left keys [1]: [cast(person_role_id#19 as int)]
Right keys [1]: [id#9]
Join type: Inner
Join condition: None

(55) Project
Output [1]: [title#40]
Input [3]: [title#40, person_role_id#19, id#9]

(56) SortAggregate
Input [1]: [title#40]
Keys: []
Functions [1]: [partial_min(title#40)]
Aggregate Attributes [1]: [min#954]
Results [1]: [min#955]

(57) Exchange
Input [1]: [min#955]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=13617]

(58) SortAggregate
Input [1]: [min#955]
Keys: []
Functions [1]: [min(title#40)]
Aggregate Attributes [1]: [min(title#40)#953]
Results [1]: [min(title#40)#953 AS complete_downey_ironman_movie#944]

(59) AdaptiveSparkPlan
Output [1]: [complete_downey_ironman_movie#944]
Arguments: isFinalPlan=false
Execution Time: 24.706
