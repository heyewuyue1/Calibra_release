== Physical Plan ==
AdaptiveSparkPlan (65)
+- SortAggregate (64)
   +- Exchange (63)
      +- SortAggregate (62)
         +- Project (61)
            +- BroadcastHashJoin Inner BuildLeft (60)
               :- BroadcastExchange (57)
               :  +- Project (56)
               :     +- BroadcastHashJoin Inner BuildLeft (55)
               :        :- BroadcastExchange (35)
               :        :  +- Project (34)
               :        :     +- BroadcastHashJoin Inner BuildRight (33)
               :        :        :- BroadcastHashJoin Inner BuildLeft (28)
               :        :        :  :- BroadcastExchange (25)
               :        :        :  :  +- Project (24)
               :        :        :  :     +- BroadcastHashJoin Inner BuildRight (23)
               :        :        :  :        :- BroadcastHashJoin Inner BuildLeft (18)
               :        :        :  :        :  :- BroadcastExchange (14)
               :        :        :  :        :  :  +- BroadcastHashJoin Inner BuildLeft (13)
               :        :        :  :        :  :     :- BroadcastExchange (9)
               :        :        :  :        :  :     :  +- Project (8)
               :        :        :  :        :  :     :     +- BroadcastHashJoin Inner BuildRight (7)
               :        :        :  :        :  :     :        :- Filter (2)
               :        :        :  :        :  :     :        :  +- Scan parquet spark_catalog.imdb_10x.movie_companies (1)
               :        :        :  :        :  :     :        +- BroadcastExchange (6)
               :        :        :  :        :  :     :           +- Project (5)
               :        :        :  :        :  :     :              +- Filter (4)
               :        :        :  :        :  :     :                 +- Scan parquet spark_catalog.imdb_10x.company_name (3)
               :        :        :  :        :  :     +- Project (12)
               :        :        :  :        :  :        +- Filter (11)
               :        :        :  :        :  :           +- Scan parquet spark_catalog.imdb_10x.title (10)
               :        :        :  :        :  +- Project (17)
               :        :        :  :        :     +- Filter (16)
               :        :        :  :        :        +- Scan parquet spark_catalog.imdb_10x.movie_info (15)
               :        :        :  :        +- BroadcastExchange (22)
               :        :        :  :           +- Project (21)
               :        :        :  :              +- Filter (20)
               :        :        :  :                 +- Scan parquet spark_catalog.imdb_10x.info_type (19)
               :        :        :  +- Filter (27)
               :        :        :     +- Scan parquet spark_catalog.imdb_10x.movie_keyword (26)
               :        :        +- BroadcastExchange (32)
               :        :           +- Project (31)
               :        :              +- Filter (30)
               :        :                 +- Scan parquet spark_catalog.imdb_10x.keyword (29)
               :        +- Project (54)
               :           +- BroadcastHashJoin Inner BuildLeft (53)
               :              :- BroadcastExchange (50)
               :              :  +- BroadcastHashJoin Inner BuildLeft (49)
               :              :     :- BroadcastExchange (45)
               :              :     :  +- Project (44)
               :              :     :     +- BroadcastHashJoin Inner BuildRight (43)
               :              :     :        :- Project (38)
               :              :     :        :  +- Filter (37)
               :              :     :        :     +- Scan parquet spark_catalog.imdb_10x.cast_info (36)
               :              :     :        +- BroadcastExchange (42)
               :              :     :           +- Project (41)
               :              :     :              +- Filter (40)
               :              :     :                 +- Scan parquet spark_catalog.imdb_10x.role_type (39)
               :              :     +- Project (48)
               :              :        +- Filter (47)
               :              :           +- Scan parquet spark_catalog.imdb_10x.name (46)
               :              +- Filter (52)
               :                 +- Scan parquet spark_catalog.imdb_10x.aka_name (51)
               +- Filter (59)
                  +- Scan parquet spark_catalog.imdb_10x.char_name (58)


(1) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [2]: [movie_id#33, company_id#34]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(movie_id), IsNotNull(company_id)]
ReadSchema: struct<movie_id:int,company_id:int>

(2) Filter
Input [2]: [movie_id#33, company_id#34]
Condition : (isnotnull(movie_id#33) AND isnotnull(company_id#34))

(3) Scan parquet spark_catalog.imdb_10x.company_name
Output [3]: [id#23, name#24, country_code#25]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(country_code), IsNotNull(name), EqualTo(country_code,[us]), EqualTo(name,DreamWorks Animation), IsNotNull(id)]
ReadSchema: struct<id:int,name:string,country_code:string>

(4) Filter
Input [3]: [id#23, name#24, country_code#25]
Condition : ((((isnotnull(country_code#25) AND isnotnull(name#24)) AND (country_code#25 = [us])) AND (name#24 = DreamWorks Animation)) AND isnotnull(id#23))

(5) Project
Output [1]: [id#23]
Input [3]: [id#23, name#24, country_code#25]

(6) BroadcastExchange
Input [1]: [id#23]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=18784]

(7) BroadcastHashJoin
Left keys [1]: [company_id#34]
Right keys [1]: [id#23]
Join type: Inner
Join condition: None

(8) Project
Output [1]: [movie_id#33]
Input [3]: [movie_id#33, company_id#34, id#23]

(9) BroadcastExchange
Input [1]: [movie_id#33]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=18788]

(10) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#39, title#40, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(title), StringStartsWith(title,Kung Fu Panda), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(11) Filter
Input [3]: [id#39, title#40, production_year#43]
Condition : ((((isnotnull(production_year#43) AND isnotnull(title#40)) AND (cast(production_year#43 as int) > 2010)) AND StartsWith(title#40, Kung Fu Panda)) AND isnotnull(id#39))

(12) Project
Output [2]: [id#39, title#40]
Input [3]: [id#39, title#40, production_year#43]

(13) BroadcastHashJoin
Left keys [1]: [movie_id#33]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(14) BroadcastExchange
Input [3]: [movie_id#33, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[1, int, true] as bigint) & 4294967295))),false), [plan_id=18791]

(15) Scan parquet spark_catalog.imdb_10x.movie_info
Output [3]: [movie_id#213, info_type_id#214, info#215]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [IsNotNull(info), IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(16) Filter
Input [3]: [movie_id#213, info_type_id#214, info#215]
Condition : (((isnotnull(info#215) AND (info#215 LIKE Japan:%201% OR info#215 LIKE USA:%201%)) AND isnotnull(movie_id#213)) AND isnotnull(info_type_id#214))

(17) Project
Output [2]: [movie_id#213, info_type_id#214]
Input [3]: [movie_id#213, info_type_id#214, info#215]

(18) BroadcastHashJoin
Left keys [2]: [movie_id#33, id#39]
Right keys [2]: [movie_id#213, movie_id#213]
Join type: Inner
Join condition: None

(19) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#210, info#211]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,release dates), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(20) Filter
Input [2]: [id#210, info#211]
Condition : ((isnotnull(info#211) AND (info#211 = release dates)) AND isnotnull(id#210))

(21) Project
Output [1]: [id#210]
Input [2]: [id#210, info#211]

(22) BroadcastExchange
Input [1]: [id#210]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=18794]

(23) BroadcastHashJoin
Left keys [1]: [info_type_id#214]
Right keys [1]: [id#210]
Join type: Inner
Join condition: None

(24) Project
Output [4]: [movie_id#33, id#39, title#40, movie_id#213]
Input [6]: [movie_id#33, id#39, title#40, movie_id#213, info_type_id#214, id#210]

(25) BroadcastExchange
Input [4]: [movie_id#33, id#39, title#40, movie_id#213]
Arguments: HashedRelationBroadcastMode(List(input[0, int, true], input[3, int, true], input[1, int, true]),false), [plan_id=18798]

(26) Scan parquet spark_catalog.imdb_10x.movie_keyword
Output [2]: [movie_id#116, keyword_id#117]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_keyword]
PushedFilters: [IsNotNull(movie_id), IsNotNull(keyword_id)]
ReadSchema: struct<movie_id:int,keyword_id:int>

(27) Filter
Input [2]: [movie_id#116, keyword_id#117]
Condition : (isnotnull(movie_id#116) AND isnotnull(keyword_id#117))

(28) BroadcastHashJoin
Left keys [3]: [movie_id#33, movie_id#213, id#39]
Right keys [3]: [movie_id#116, movie_id#116, movie_id#116]
Join type: Inner
Join condition: None

(29) Scan parquet spark_catalog.imdb_10x.keyword
Output [2]: [id#110, keyword#111]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/keyword]
PushedFilters: [In(keyword, [computer-animated-movie,hand-to-hand-combat,hero,martial-arts]), IsNotNull(id)]
ReadSchema: struct<id:int,keyword:string>

(30) Filter
Input [2]: [id#110, keyword#111]
Condition : (keyword#111 IN (hero,martial-arts,hand-to-hand-combat,computer-animated-movie) AND isnotnull(id#110))

(31) Project
Output [1]: [id#110]
Input [2]: [id#110, keyword#111]

(32) BroadcastExchange
Input [1]: [id#110]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=18801]

(33) BroadcastHashJoin
Left keys [1]: [keyword_id#117]
Right keys [1]: [id#110]
Join type: Inner
Join condition: None

(34) Project
Output [5]: [movie_id#33, id#39, title#40, movie_id#213, movie_id#116]
Input [7]: [movie_id#33, id#39, title#40, movie_id#213, movie_id#116, keyword_id#117, id#110]

(35) BroadcastExchange
Input [5]: [movie_id#33, id#39, title#40, movie_id#213, movie_id#116]
Arguments: HashedRelationBroadcastMode(List(input[0, int, true], input[3, int, true], input[4, int, true], input[1, int, true]),false), [plan_id=18815]

(36) Scan parquet spark_catalog.imdb_10x.cast_info
Output [5]: [person_id#17, movie_id#18, person_role_id#19, note#20, role_id#22]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/cast_info]
PushedFilters: [In(note, [(voice),(voice) (uncredited),(voice: English version),(voice: Japanese version)]), IsNotNull(person_id), IsNotNull(person_role_id), IsNotNull(movie_id), IsNotNull(role_id)]
ReadSchema: struct<person_id:int,movie_id:int,person_role_id:string,note:string,role_id:int>

(37) Filter
Input [5]: [person_id#17, movie_id#18, person_role_id#19, note#20, role_id#22]
Condition : ((((note#20 IN ((voice),(voice: Japanese version),(voice) (uncredited),(voice: English version)) AND isnotnull(person_id#17)) AND isnotnull(person_role_id#19)) AND isnotnull(movie_id#18)) AND isnotnull(role_id#22))

(38) Project
Output [4]: [person_id#17, movie_id#18, person_role_id#19, role_id#22]
Input [5]: [person_id#17, movie_id#18, person_role_id#19, note#20, role_id#22]

(39) Scan parquet spark_catalog.imdb_10x.role_type
Output [2]: [id#37, role#38]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/role_type]
PushedFilters: [IsNotNull(role), EqualTo(role,actress), IsNotNull(id)]
ReadSchema: struct<id:int,role:string>

(40) Filter
Input [2]: [id#37, role#38]
Condition : ((isnotnull(role#38) AND (role#38 = actress)) AND isnotnull(id#37))

(41) Project
Output [1]: [id#37]
Input [2]: [id#37, role#38]

(42) BroadcastExchange
Input [1]: [id#37]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=18804]

(43) BroadcastHashJoin
Left keys [1]: [role_id#22]
Right keys [1]: [id#37]
Join type: Inner
Join condition: None

(44) Project
Output [3]: [person_id#17, movie_id#18, person_role_id#19]
Input [5]: [person_id#17, movie_id#18, person_role_id#19, role_id#22, id#37]

(45) BroadcastExchange
Input [3]: [person_id#17, movie_id#18, person_role_id#19]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=18808]

(46) Scan parquet spark_catalog.imdb_10x.name
Output [3]: [id#540, name#541, gender#544]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/name]
PushedFilters: [IsNotNull(gender), IsNotNull(name), EqualTo(gender,f), StringContains(name,An), IsNotNull(id)]
ReadSchema: struct<id:int,name:string,gender:string>

(47) Filter
Input [3]: [id#540, name#541, gender#544]
Condition : ((((isnotnull(gender#544) AND isnotnull(name#541)) AND (gender#544 = f)) AND Contains(name#541, An)) AND isnotnull(id#540))

(48) Project
Output [2]: [id#540, name#541]
Input [3]: [id#540, name#541, gender#544]

(49) BroadcastHashJoin
Left keys [1]: [person_id#17]
Right keys [1]: [id#540]
Join type: Inner
Join condition: None

(50) BroadcastExchange
Input [5]: [person_id#17, movie_id#18, person_role_id#19, id#540, name#541]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[3, int, true] as bigint) & 4294967295))),false), [plan_id=18811]

(51) Scan parquet spark_catalog.imdb_10x.aka_name
Output [1]: [person_id#533]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/aka_name]
PushedFilters: [IsNotNull(person_id)]
ReadSchema: struct<person_id:int>

(52) Filter
Input [1]: [person_id#533]
Condition : isnotnull(person_id#533)

(53) BroadcastHashJoin
Left keys [2]: [person_id#17, id#540]
Right keys [2]: [person_id#533, person_id#533]
Join type: Inner
Join condition: None

(54) Project
Output [3]: [movie_id#18, person_role_id#19, name#541]
Input [6]: [person_id#17, movie_id#18, person_role_id#19, id#540, name#541, person_id#533]

(55) BroadcastHashJoin
Left keys [4]: [movie_id#33, movie_id#213, movie_id#116, id#39]
Right keys [4]: [movie_id#18, movie_id#18, movie_id#18, movie_id#18]
Join type: Inner
Join condition: None

(56) Project
Output [3]: [title#40, person_role_id#19, name#541]
Input [8]: [movie_id#33, id#39, title#40, movie_id#213, movie_id#116, movie_id#18, person_role_id#19, name#541]

(57) BroadcastExchange
Input [3]: [title#40, person_role_id#19, name#541]
Arguments: HashedRelationBroadcastMode(List(cast(cast(input[1, string, true] as int) as bigint)),false), [plan_id=18819]

(58) Scan parquet spark_catalog.imdb_10x.char_name
Output [2]: [id#9, name#10]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/char_name]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int,name:string>

(59) Filter
Input [2]: [id#9, name#10]
Condition : isnotnull(id#9)

(60) BroadcastHashJoin
Left keys [1]: [cast(person_role_id#19 as int)]
Right keys [1]: [id#9]
Join type: Inner
Join condition: None

(61) Project
Output [3]: [name#10, name#541, title#40]
Input [5]: [title#40, person_role_id#19, name#541, id#9, name#10]

(62) SortAggregate
Input [3]: [name#10, name#541, title#40]
Keys: []
Functions [3]: [partial_min(name#10), partial_min(name#541), partial_min(title#40)]
Aggregate Attributes [3]: [min#1222, min#1223, min#1224]
Results [3]: [min#1225, min#1226, min#1227]

(63) Exchange
Input [3]: [min#1225, min#1226, min#1227]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=18824]

(64) SortAggregate
Input [3]: [min#1225, min#1226, min#1227]
Keys: []
Functions [3]: [min(name#10), min(name#541), min(title#40)]
Aggregate Attributes [3]: [min(name#10)#1219, min(name#541)#1220, min(title#40)#1221]
Results [3]: [min(name#10)#1219 AS voiced_char_name#1211, min(name#541)#1220 AS voicing_actress_name#1212, min(title#40)#1221 AS kung_fu_panda#1213]

(65) AdaptiveSparkPlan
Output [3]: [voiced_char_name#1211, voicing_actress_name#1212, kung_fu_panda#1213]
Arguments: isFinalPlan=false
Execution Time: 39.126
