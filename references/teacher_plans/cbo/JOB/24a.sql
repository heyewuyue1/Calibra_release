== Physical Plan ==
AdaptiveSparkPlan (68)
+- SortAggregate (67)
   +- Exchange (66)
      +- SortAggregate (65)
         +- Project (64)
            +- SortMergeJoin Inner (63)
               :- Sort (58)
               :  +- Exchange (57)
               :     +- Project (56)
               :        +- BroadcastHashJoin Inner BuildRight (55)
               :           :- Project (34)
               :           :  +- BroadcastHashJoin Inner BuildLeft (33)
               :           :     :- BroadcastExchange (30)
               :           :     :  +- Project (29)
               :           :     :     +- BroadcastHashJoin Inner BuildRight (28)
               :           :     :        :- BroadcastHashJoin Inner BuildLeft (23)
               :           :     :        :  :- BroadcastExchange (20)
               :           :     :        :  :  +- BroadcastHashJoin Inner BuildLeft (19)
               :           :     :        :  :     :- BroadcastExchange (15)
               :           :     :        :  :     :  +- BroadcastHashJoin Inner BuildLeft (14)
               :           :     :        :  :     :     :- BroadcastExchange (10)
               :           :     :        :  :     :     :  +- Project (9)
               :           :     :        :  :     :     :     +- BroadcastHashJoin Inner BuildRight (8)
               :           :     :        :  :     :     :        :- Project (3)
               :           :     :        :  :     :     :        :  +- Filter (2)
               :           :     :        :  :     :     :        :     +- Scan parquet spark_catalog.imdb_10x.cast_info (1)
               :           :     :        :  :     :     :        +- BroadcastExchange (7)
               :           :     :        :  :     :     :           +- Project (6)
               :           :     :        :  :     :     :              +- Filter (5)
               :           :     :        :  :     :     :                 +- Scan parquet spark_catalog.imdb_10x.role_type (4)
               :           :     :        :  :     :     +- Project (13)
               :           :     :        :  :     :        +- Filter (12)
               :           :     :        :  :     :           +- Scan parquet spark_catalog.imdb_10x.name (11)
               :           :     :        :  :     +- Project (18)
               :           :     :        :  :        +- Filter (17)
               :           :     :        :  :           +- Scan parquet spark_catalog.imdb_10x.title (16)
               :           :     :        :  +- Filter (22)
               :           :     :        :     +- Scan parquet spark_catalog.imdb_10x.movie_companies (21)
               :           :     :        +- BroadcastExchange (27)
               :           :     :           +- Project (26)
               :           :     :              +- Filter (25)
               :           :     :                 +- Scan parquet spark_catalog.imdb_10x.company_name (24)
               :           :     +- Filter (32)
               :           :        +- Scan parquet spark_catalog.imdb_10x.aka_name (31)
               :           +- BroadcastExchange (54)
               :              +- Project (53)
               :                 +- BroadcastHashJoin Inner BuildRight (52)
               :                    :- BroadcastHashJoin Inner BuildLeft (47)
               :                    :  :- BroadcastExchange (43)
               :                    :  :  +- Project (42)
               :                    :  :     +- BroadcastHashJoin Inner BuildRight (41)
               :                    :  :        :- Filter (36)
               :                    :  :        :  +- Scan parquet spark_catalog.imdb_10x.movie_keyword (35)
               :                    :  :        +- BroadcastExchange (40)
               :                    :  :           +- Project (39)
               :                    :  :              +- Filter (38)
               :                    :  :                 +- Scan parquet spark_catalog.imdb_10x.keyword (37)
               :                    :  +- Project (46)
               :                    :     +- Filter (45)
               :                    :        +- Scan parquet spark_catalog.imdb_10x.movie_info (44)
               :                    +- BroadcastExchange (51)
               :                       +- Project (50)
               :                          +- Filter (49)
               :                             +- Scan parquet spark_catalog.imdb_10x.info_type (48)
               +- Sort (62)
                  +- Exchange (61)
                     +- Filter (60)
                        +- Scan parquet spark_catalog.imdb_10x.char_name (59)


(1) Scan parquet spark_catalog.imdb_10x.cast_info
Output [5]: [person_id#17, movie_id#18, person_role_id#19, note#20, role_id#22]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/cast_info]
PushedFilters: [In(note, [(voice),(voice) (uncredited),(voice: English version),(voice: Japanese version)]), IsNotNull(person_id), IsNotNull(person_role_id), IsNotNull(movie_id), IsNotNull(role_id)]
ReadSchema: struct<person_id:int,movie_id:int,person_role_id:string,note:string,role_id:int>

(2) Filter
Input [5]: [person_id#17, movie_id#18, person_role_id#19, note#20, role_id#22]
Condition : ((((note#20 IN ((voice),(voice: Japanese version),(voice) (uncredited),(voice: English version)) AND isnotnull(person_id#17)) AND isnotnull(person_role_id#19)) AND isnotnull(movie_id#18)) AND isnotnull(role_id#22))

(3) Project
Output [4]: [person_id#17, movie_id#18, person_role_id#19, role_id#22]
Input [5]: [person_id#17, movie_id#18, person_role_id#19, note#20, role_id#22]

(4) Scan parquet spark_catalog.imdb_10x.role_type
Output [2]: [id#37, role#38]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/role_type]
PushedFilters: [IsNotNull(role), EqualTo(role,actress), IsNotNull(id)]
ReadSchema: struct<id:int,role:string>

(5) Filter
Input [2]: [id#37, role#38]
Condition : ((isnotnull(role#38) AND (role#38 = actress)) AND isnotnull(id#37))

(6) Project
Output [1]: [id#37]
Input [2]: [id#37, role#38]

(7) BroadcastExchange
Input [1]: [id#37]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=18330]

(8) BroadcastHashJoin
Left keys [1]: [role_id#22]
Right keys [1]: [id#37]
Join type: Inner
Join condition: None

(9) Project
Output [3]: [person_id#17, movie_id#18, person_role_id#19]
Input [5]: [person_id#17, movie_id#18, person_role_id#19, role_id#22, id#37]

(10) BroadcastExchange
Input [3]: [person_id#17, movie_id#18, person_role_id#19]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=18334]

(11) Scan parquet spark_catalog.imdb_10x.name
Output [3]: [id#540, name#541, gender#544]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/name]
PushedFilters: [IsNotNull(gender), IsNotNull(name), EqualTo(gender,f), StringContains(name,An), IsNotNull(id)]
ReadSchema: struct<id:int,name:string,gender:string>

(12) Filter
Input [3]: [id#540, name#541, gender#544]
Condition : ((((isnotnull(gender#544) AND isnotnull(name#541)) AND (gender#544 = f)) AND Contains(name#541, An)) AND isnotnull(id#540))

(13) Project
Output [2]: [id#540, name#541]
Input [3]: [id#540, name#541, gender#544]

(14) BroadcastHashJoin
Left keys [1]: [person_id#17]
Right keys [1]: [id#540]
Join type: Inner
Join condition: None

(15) BroadcastExchange
Input [5]: [person_id#17, movie_id#18, person_role_id#19, id#540, name#541]
Arguments: HashedRelationBroadcastMode(List(cast(input[1, int, true] as bigint)),false), [plan_id=18337]

(16) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#39, title#40, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(17) Filter
Input [3]: [id#39, title#40, production_year#43]
Condition : ((isnotnull(production_year#43) AND (cast(production_year#43 as int) > 2010)) AND isnotnull(id#39))

(18) Project
Output [2]: [id#39, title#40]
Input [3]: [id#39, title#40, production_year#43]

(19) BroadcastHashJoin
Left keys [1]: [movie_id#18]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(20) BroadcastExchange
Input [7]: [person_id#17, movie_id#18, person_role_id#19, id#540, name#541, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[1, int, true] as bigint), 32) | (cast(input[5, int, true] as bigint) & 4294967295))),false), [plan_id=18340]

(21) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [2]: [movie_id#33, company_id#34]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(movie_id), IsNotNull(company_id)]
ReadSchema: struct<movie_id:int,company_id:int>

(22) Filter
Input [2]: [movie_id#33, company_id#34]
Condition : (isnotnull(movie_id#33) AND isnotnull(company_id#34))

(23) BroadcastHashJoin
Left keys [2]: [movie_id#18, id#39]
Right keys [2]: [movie_id#33, movie_id#33]
Join type: Inner
Join condition: None

(24) Scan parquet spark_catalog.imdb_10x.company_name
Output [2]: [id#23, country_code#25]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(country_code), EqualTo(country_code,[us]), IsNotNull(id)]
ReadSchema: struct<id:int,country_code:string>

(25) Filter
Input [2]: [id#23, country_code#25]
Condition : ((isnotnull(country_code#25) AND (country_code#25 = [us])) AND isnotnull(id#23))

(26) Project
Output [1]: [id#23]
Input [2]: [id#23, country_code#25]

(27) BroadcastExchange
Input [1]: [id#23]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=18343]

(28) BroadcastHashJoin
Left keys [1]: [company_id#34]
Right keys [1]: [id#23]
Join type: Inner
Join condition: None

(29) Project
Output [8]: [person_id#17, movie_id#18, person_role_id#19, id#540, name#541, id#39, title#40, movie_id#33]
Input [10]: [person_id#17, movie_id#18, person_role_id#19, id#540, name#541, id#39, title#40, movie_id#33, company_id#34, id#23]

(30) BroadcastExchange
Input [8]: [person_id#17, movie_id#18, person_role_id#19, id#540, name#541, id#39, title#40, movie_id#33]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[3, int, true] as bigint) & 4294967295))),false), [plan_id=18347]

(31) Scan parquet spark_catalog.imdb_10x.aka_name
Output [1]: [person_id#533]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/aka_name]
PushedFilters: [IsNotNull(person_id)]
ReadSchema: struct<person_id:int>

(32) Filter
Input [1]: [person_id#533]
Condition : isnotnull(person_id#533)

(33) BroadcastHashJoin
Left keys [2]: [person_id#17, id#540]
Right keys [2]: [person_id#533, person_id#533]
Join type: Inner
Join condition: None

(34) Project
Output [6]: [movie_id#18, person_role_id#19, name#541, id#39, title#40, movie_id#33]
Input [9]: [person_id#17, movie_id#18, person_role_id#19, id#540, name#541, id#39, title#40, movie_id#33, person_id#533]

(35) Scan parquet spark_catalog.imdb_10x.movie_keyword
Output [2]: [movie_id#116, keyword_id#117]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_keyword]
PushedFilters: [IsNotNull(movie_id), IsNotNull(keyword_id)]
ReadSchema: struct<movie_id:int,keyword_id:int>

(36) Filter
Input [2]: [movie_id#116, keyword_id#117]
Condition : (isnotnull(movie_id#116) AND isnotnull(keyword_id#117))

(37) Scan parquet spark_catalog.imdb_10x.keyword
Output [2]: [id#110, keyword#111]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/keyword]
PushedFilters: [In(keyword, [hand-to-hand-combat,hero,martial-arts]), IsNotNull(id)]
ReadSchema: struct<id:int,keyword:string>

(38) Filter
Input [2]: [id#110, keyword#111]
Condition : (keyword#111 IN (hero,martial-arts,hand-to-hand-combat) AND isnotnull(id#110))

(39) Project
Output [1]: [id#110]
Input [2]: [id#110, keyword#111]

(40) BroadcastExchange
Input [1]: [id#110]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=18350]

(41) BroadcastHashJoin
Left keys [1]: [keyword_id#117]
Right keys [1]: [id#110]
Join type: Inner
Join condition: None

(42) Project
Output [1]: [movie_id#116]
Input [3]: [movie_id#116, keyword_id#117, id#110]

(43) BroadcastExchange
Input [1]: [movie_id#116]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=18354]

(44) Scan parquet spark_catalog.imdb_10x.movie_info
Output [3]: [movie_id#213, info_type_id#214, info#215]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [IsNotNull(info), IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(45) Filter
Input [3]: [movie_id#213, info_type_id#214, info#215]
Condition : (((isnotnull(info#215) AND (info#215 LIKE Japan:%201% OR info#215 LIKE USA:%201%)) AND isnotnull(movie_id#213)) AND isnotnull(info_type_id#214))

(46) Project
Output [2]: [movie_id#213, info_type_id#214]
Input [3]: [movie_id#213, info_type_id#214, info#215]

(47) BroadcastHashJoin
Left keys [1]: [movie_id#116]
Right keys [1]: [movie_id#213]
Join type: Inner
Join condition: None

(48) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#210, info#211]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,release dates), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(49) Filter
Input [2]: [id#210, info#211]
Condition : ((isnotnull(info#211) AND (info#211 = release dates)) AND isnotnull(id#210))

(50) Project
Output [1]: [id#210]
Input [2]: [id#210, info#211]

(51) BroadcastExchange
Input [1]: [id#210]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=18357]

(52) BroadcastHashJoin
Left keys [1]: [info_type_id#214]
Right keys [1]: [id#210]
Join type: Inner
Join condition: None

(53) Project
Output [2]: [movie_id#116, movie_id#213]
Input [4]: [movie_id#116, movie_id#213, info_type_id#214, id#210]

(54) BroadcastExchange
Input [2]: [movie_id#116, movie_id#213]
Arguments: HashedRelationBroadcastMode(List(input[1, int, true], input[1, int, true], input[0, int, true], input[0, int, true], input[1, int, true], input[0, int, true]),false), [plan_id=18361]

(55) BroadcastHashJoin
Left keys [6]: [movie_id#33, movie_id#18, movie_id#33, movie_id#18, id#39, id#39]
Right keys [6]: [movie_id#213, movie_id#213, movie_id#116, movie_id#116, movie_id#213, movie_id#116]
Join type: Inner
Join condition: None

(56) Project
Output [3]: [person_role_id#19, name#541, title#40]
Input [8]: [movie_id#18, person_role_id#19, name#541, id#39, title#40, movie_id#33, movie_id#116, movie_id#213]

(57) Exchange
Input [3]: [person_role_id#19, name#541, title#40]
Arguments: hashpartitioning(cast(person_role_id#19 as int), 200), ENSURE_REQUIREMENTS, [plan_id=18366]

(58) Sort
Input [3]: [person_role_id#19, name#541, title#40]
Arguments: [cast(person_role_id#19 as int) ASC NULLS FIRST], false, 0

(59) Scan parquet spark_catalog.imdb_10x.char_name
Output [2]: [id#9, name#10]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/char_name]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int,name:string>

(60) Filter
Input [2]: [id#9, name#10]
Condition : isnotnull(id#9)

(61) Exchange
Input [2]: [id#9, name#10]
Arguments: hashpartitioning(id#9, 200), ENSURE_REQUIREMENTS, [plan_id=18367]

(62) Sort
Input [2]: [id#9, name#10]
Arguments: [id#9 ASC NULLS FIRST], false, 0

(63) SortMergeJoin
Left keys [1]: [cast(person_role_id#19 as int)]
Right keys [1]: [id#9]
Join type: Inner
Join condition: None

(64) Project
Output [3]: [name#10, name#541, title#40]
Input [5]: [person_role_id#19, name#541, title#40, id#9, name#10]

(65) SortAggregate
Input [3]: [name#10, name#541, title#40]
Keys: []
Functions [3]: [partial_min(name#10), partial_min(name#541), partial_min(title#40)]
Aggregate Attributes [3]: [min#1201, min#1202, min#1203]
Results [3]: [min#1204, min#1205, min#1206]

(66) Exchange
Input [3]: [min#1204, min#1205, min#1206]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=18374]

(67) SortAggregate
Input [3]: [min#1204, min#1205, min#1206]
Keys: []
Functions [3]: [min(name#10), min(name#541), min(title#40)]
Aggregate Attributes [3]: [min(name#10)#1198, min(name#541)#1199, min(title#40)#1200]
Results [3]: [min(name#10)#1198 AS voiced_char_name#1190, min(name#541)#1199 AS voicing_actress_name#1191, min(title#40)#1200 AS voiced_action_movie_jap_eng#1192]

(68) AdaptiveSparkPlan
Output [3]: [voiced_char_name#1190, voicing_actress_name#1191, voiced_action_movie_jap_eng#1192]
Arguments: isFinalPlan=false
Execution Time: 38.308
