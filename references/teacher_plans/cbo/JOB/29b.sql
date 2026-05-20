== Physical Plan ==
AdaptiveSparkPlan (95)
+- SortAggregate (94)
   +- Exchange (93)
      +- SortAggregate (92)
         +- Project (91)
            +- SortMergeJoin Inner (90)
               :- Sort (73)
               :  +- Exchange (72)
               :     +- BroadcastHashJoin Inner BuildRight (71)
               :        :- Project (40)
               :        :  +- BroadcastHashJoin Inner BuildRight (39)
               :        :     :- Project (35)
               :        :     :  +- BroadcastHashJoin Inner BuildRight (34)
               :        :     :     :- Project (29)
               :        :     :     :  +- BroadcastHashJoin Inner BuildLeft (28)
               :        :     :     :     :- BroadcastExchange (25)
               :        :     :     :     :  +- Project (24)
               :        :     :     :     :     +- BroadcastHashJoin Inner BuildLeft (23)
               :        :     :     :     :        :- BroadcastExchange (20)
               :        :     :     :     :        :  +- BroadcastHashJoin Inner BuildLeft (19)
               :        :     :     :     :        :     :- BroadcastExchange (15)
               :        :     :     :     :        :     :  +- Project (14)
               :        :     :     :     :        :     :     +- BroadcastHashJoin Inner BuildRight (13)
               :        :     :     :     :        :     :        :- BroadcastHashJoin Inner BuildRight (8)
               :        :     :     :     :        :     :        :  :- Project (3)
               :        :     :     :     :        :     :        :  :  +- Filter (2)
               :        :     :     :     :        :     :        :  :     +- Scan parquet spark_catalog.imdb_10x.cast_info (1)
               :        :     :     :     :        :     :        :  +- BroadcastExchange (7)
               :        :     :     :     :        :     :        :     +- Project (6)
               :        :     :     :     :        :     :        :        +- Filter (5)
               :        :     :     :     :        :     :        :           +- Scan parquet spark_catalog.imdb_10x.title (4)
               :        :     :     :     :        :     :        +- BroadcastExchange (12)
               :        :     :     :     :        :     :           +- Project (11)
               :        :     :     :     :        :     :              +- Filter (10)
               :        :     :     :     :        :     :                 +- Scan parquet spark_catalog.imdb_10x.role_type (9)
               :        :     :     :     :        :     +- Project (18)
               :        :     :     :     :        :        +- Filter (17)
               :        :     :     :     :        :           +- Scan parquet spark_catalog.imdb_10x.name (16)
               :        :     :     :     :        +- Filter (22)
               :        :     :     :     :           +- Scan parquet spark_catalog.imdb_10x.aka_name (21)
               :        :     :     :     +- Filter (27)
               :        :     :     :        +- Scan parquet spark_catalog.imdb_10x.person_info (26)
               :        :     :     +- BroadcastExchange (33)
               :        :     :        +- Project (32)
               :        :     :           +- Filter (31)
               :        :     :              +- Scan parquet spark_catalog.imdb_10x.info_type (30)
               :        :     +- BroadcastExchange (38)
               :        :        +- Filter (37)
               :        :           +- Scan parquet spark_catalog.imdb_10x.char_name (36)
               :        +- BroadcastExchange (70)
               :           +- Project (69)
               :              +- BroadcastHashJoin Inner BuildRight (68)
               :                 :- BroadcastHashJoin Inner BuildLeft (63)
               :                 :  :- BroadcastExchange (59)
               :                 :  :  +- Project (58)
               :                 :  :     +- BroadcastHashJoin Inner BuildLeft (57)
               :                 :  :        :- BroadcastExchange (53)
               :                 :  :        :  +- BroadcastHashJoin Inner BuildLeft (52)
               :                 :  :        :     :- BroadcastExchange (49)
               :                 :  :        :     :  +- Project (48)
               :                 :  :        :     :     +- BroadcastHashJoin Inner BuildRight (47)
               :                 :  :        :     :        :- Filter (42)
               :                 :  :        :     :        :  +- Scan parquet spark_catalog.imdb_10x.movie_keyword (41)
               :                 :  :        :     :        +- BroadcastExchange (46)
               :                 :  :        :     :           +- Project (45)
               :                 :  :        :     :              +- Filter (44)
               :                 :  :        :     :                 +- Scan parquet spark_catalog.imdb_10x.keyword (43)
               :                 :  :        :     +- Filter (51)
               :                 :  :        :        +- Scan parquet spark_catalog.imdb_10x.movie_companies (50)
               :                 :  :        +- Project (56)
               :                 :  :           +- Filter (55)
               :                 :  :              +- Scan parquet spark_catalog.imdb_10x.company_name (54)
               :                 :  +- Project (62)
               :                 :     +- Filter (61)
               :                 :        +- Scan parquet spark_catalog.imdb_10x.movie_info (60)
               :                 +- BroadcastExchange (67)
               :                    +- Project (66)
               :                       +- Filter (65)
               :                          +- Scan parquet spark_catalog.imdb_10x.info_type (64)
               +- Sort (89)
                  +- Exchange (88)
                     +- Project (87)
                        +- BroadcastHashJoin Inner BuildRight (86)
                           :- Project (81)
                           :  +- BroadcastHashJoin Inner BuildRight (80)
                           :     :- Filter (75)
                           :     :  +- Scan parquet spark_catalog.imdb_10x.complete_cast (74)
                           :     +- BroadcastExchange (79)
                           :        +- Project (78)
                           :           +- Filter (77)
                           :              +- Scan parquet spark_catalog.imdb_10x.comp_cast_type (76)
                           +- BroadcastExchange (85)
                              +- Project (84)
                                 +- Filter (83)
                                    +- Scan parquet spark_catalog.imdb_10x.comp_cast_type (82)


(1) Scan parquet spark_catalog.imdb_10x.cast_info
Output [5]: [person_id#17, movie_id#18, person_role_id#19, note#20, role_id#22]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/cast_info]
PushedFilters: [In(note, [(voice),(voice) (uncredited),(voice: English version)]), IsNotNull(person_id), IsNotNull(movie_id), IsNotNull(person_role_id), IsNotNull(role_id)]
ReadSchema: struct<person_id:int,movie_id:int,person_role_id:string,note:string,role_id:int>

(2) Filter
Input [5]: [person_id#17, movie_id#18, person_role_id#19, note#20, role_id#22]
Condition : ((((note#20 IN ((voice),(voice) (uncredited),(voice: English version)) AND isnotnull(person_id#17)) AND isnotnull(movie_id#18)) AND isnotnull(person_role_id#19)) AND isnotnull(role_id#22))

(3) Project
Output [4]: [person_id#17, movie_id#18, person_role_id#19, role_id#22]
Input [5]: [person_id#17, movie_id#18, person_role_id#19, note#20, role_id#22]

(4) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#39, title#40, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(title), IsNotNull(production_year), EqualTo(title,Shrek 2), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(5) Filter
Input [3]: [id#39, title#40, production_year#43]
Condition : (((((isnotnull(title#40) AND isnotnull(production_year#43)) AND (title#40 = Shrek 2)) AND (cast(production_year#43 as int) >= 2000)) AND (cast(production_year#43 as int) <= 2005)) AND isnotnull(id#39))

(6) Project
Output [2]: [id#39, title#40]
Input [3]: [id#39, title#40, production_year#43]

(7) BroadcastExchange
Input [2]: [id#39, title#40]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=25363]

(8) BroadcastHashJoin
Left keys [1]: [movie_id#18]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(9) Scan parquet spark_catalog.imdb_10x.role_type
Output [2]: [id#37, role#38]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/role_type]
PushedFilters: [IsNotNull(role), EqualTo(role,actress), IsNotNull(id)]
ReadSchema: struct<id:int,role:string>

(10) Filter
Input [2]: [id#37, role#38]
Condition : ((isnotnull(role#38) AND (role#38 = actress)) AND isnotnull(id#37))

(11) Project
Output [1]: [id#37]
Input [2]: [id#37, role#38]

(12) BroadcastExchange
Input [1]: [id#37]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=25366]

(13) BroadcastHashJoin
Left keys [1]: [role_id#22]
Right keys [1]: [id#37]
Join type: Inner
Join condition: None

(14) Project
Output [5]: [person_id#17, movie_id#18, person_role_id#19, id#39, title#40]
Input [7]: [person_id#17, movie_id#18, person_role_id#19, role_id#22, id#39, title#40, id#37]

(15) BroadcastExchange
Input [5]: [person_id#17, movie_id#18, person_role_id#19, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=25370]

(16) Scan parquet spark_catalog.imdb_10x.name
Output [3]: [id#540, name#541, gender#544]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/name]
PushedFilters: [IsNotNull(gender), IsNotNull(name), EqualTo(gender,f), StringContains(name,An), IsNotNull(id)]
ReadSchema: struct<id:int,name:string,gender:string>

(17) Filter
Input [3]: [id#540, name#541, gender#544]
Condition : ((((isnotnull(gender#544) AND isnotnull(name#541)) AND (gender#544 = f)) AND Contains(name#541, An)) AND isnotnull(id#540))

(18) Project
Output [2]: [id#540, name#541]
Input [3]: [id#540, name#541, gender#544]

(19) BroadcastHashJoin
Left keys [1]: [person_id#17]
Right keys [1]: [id#540]
Join type: Inner
Join condition: None

(20) BroadcastExchange
Input [7]: [person_id#17, movie_id#18, person_role_id#19, id#39, title#40, id#540, name#541]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[5, int, true] as bigint) & 4294967295))),false), [plan_id=25373]

(21) Scan parquet spark_catalog.imdb_10x.aka_name
Output [1]: [person_id#533]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/aka_name]
PushedFilters: [IsNotNull(person_id)]
ReadSchema: struct<person_id:int>

(22) Filter
Input [1]: [person_id#533]
Condition : isnotnull(person_id#533)

(23) BroadcastHashJoin
Left keys [2]: [person_id#17, id#540]
Right keys [2]: [person_id#533, person_id#533]
Join type: Inner
Join condition: None

(24) Project
Output [7]: [person_id#17, movie_id#18, person_role_id#19, id#39, title#40, id#540, name#541]
Input [8]: [person_id#17, movie_id#18, person_role_id#19, id#39, title#40, id#540, name#541, person_id#533]

(25) BroadcastExchange
Input [7]: [person_id#17, movie_id#18, person_role_id#19, id#39, title#40, id#540, name#541]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[5, int, true] as bigint), 32) | (cast(input[0, int, true] as bigint) & 4294967295))),false), [plan_id=25377]

(26) Scan parquet spark_catalog.imdb_10x.person_info
Output [2]: [person_id#1554, info_type_id#1555]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/person_info]
PushedFilters: [IsNotNull(person_id), IsNotNull(info_type_id)]
ReadSchema: struct<person_id:int,info_type_id:int>

(27) Filter
Input [2]: [person_id#1554, info_type_id#1555]
Condition : (isnotnull(person_id#1554) AND isnotnull(info_type_id#1555))

(28) BroadcastHashJoin
Left keys [2]: [id#540, person_id#17]
Right keys [2]: [person_id#1554, person_id#1554]
Join type: Inner
Join condition: None

(29) Project
Output [6]: [movie_id#18, person_role_id#19, id#39, title#40, name#541, info_type_id#1555]
Input [9]: [person_id#17, movie_id#18, person_role_id#19, id#39, title#40, id#540, name#541, person_id#1554, info_type_id#1555]

(30) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#1588, info#1589]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,height), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(31) Filter
Input [2]: [id#1588, info#1589]
Condition : ((isnotnull(info#1589) AND (info#1589 = height)) AND isnotnull(id#1588))

(32) Project
Output [1]: [id#1588]
Input [2]: [id#1588, info#1589]

(33) BroadcastExchange
Input [1]: [id#1588]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=25381]

(34) BroadcastHashJoin
Left keys [1]: [info_type_id#1555]
Right keys [1]: [id#1588]
Join type: Inner
Join condition: None

(35) Project
Output [5]: [movie_id#18, person_role_id#19, id#39, title#40, name#541]
Input [7]: [movie_id#18, person_role_id#19, id#39, title#40, name#541, info_type_id#1555, id#1588]

(36) Scan parquet spark_catalog.imdb_10x.char_name
Output [2]: [id#9, name#10]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/char_name]
PushedFilters: [IsNotNull(name), EqualTo(name,Queen), IsNotNull(id)]
ReadSchema: struct<id:int,name:string>

(37) Filter
Input [2]: [id#9, name#10]
Condition : ((isnotnull(name#10) AND (name#10 = Queen)) AND isnotnull(id#9))

(38) BroadcastExchange
Input [2]: [id#9, name#10]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, false] as bigint)),false), [plan_id=25385]

(39) BroadcastHashJoin
Left keys [1]: [cast(person_role_id#19 as int)]
Right keys [1]: [id#9]
Join type: Inner
Join condition: None

(40) Project
Output [5]: [movie_id#18, id#39, title#40, name#541, name#10]
Input [7]: [movie_id#18, person_role_id#19, id#39, title#40, name#541, id#9, name#10]

(41) Scan parquet spark_catalog.imdb_10x.movie_keyword
Output [2]: [movie_id#116, keyword_id#117]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_keyword]
PushedFilters: [IsNotNull(movie_id), IsNotNull(keyword_id)]
ReadSchema: struct<movie_id:int,keyword_id:int>

(42) Filter
Input [2]: [movie_id#116, keyword_id#117]
Condition : (isnotnull(movie_id#116) AND isnotnull(keyword_id#117))

(43) Scan parquet spark_catalog.imdb_10x.keyword
Output [2]: [id#110, keyword#111]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/keyword]
PushedFilters: [IsNotNull(keyword), EqualTo(keyword,computer-animation), IsNotNull(id)]
ReadSchema: struct<id:int,keyword:string>

(44) Filter
Input [2]: [id#110, keyword#111]
Condition : ((isnotnull(keyword#111) AND (keyword#111 = computer-animation)) AND isnotnull(id#110))

(45) Project
Output [1]: [id#110]
Input [2]: [id#110, keyword#111]

(46) BroadcastExchange
Input [1]: [id#110]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=25388]

(47) BroadcastHashJoin
Left keys [1]: [keyword_id#117]
Right keys [1]: [id#110]
Join type: Inner
Join condition: None

(48) Project
Output [1]: [movie_id#116]
Input [3]: [movie_id#116, keyword_id#117, id#110]

(49) BroadcastExchange
Input [1]: [movie_id#116]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=25392]

(50) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [2]: [movie_id#33, company_id#34]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(movie_id), IsNotNull(company_id)]
ReadSchema: struct<movie_id:int,company_id:int>

(51) Filter
Input [2]: [movie_id#33, company_id#34]
Condition : (isnotnull(movie_id#33) AND isnotnull(company_id#34))

(52) BroadcastHashJoin
Left keys [1]: [movie_id#116]
Right keys [1]: [movie_id#33]
Join type: Inner
Join condition: None

(53) BroadcastExchange
Input [3]: [movie_id#116, movie_id#33, company_id#34]
Arguments: HashedRelationBroadcastMode(List(cast(input[2, int, false] as bigint)),false), [plan_id=25395]

(54) Scan parquet spark_catalog.imdb_10x.company_name
Output [2]: [id#23, country_code#25]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(country_code), EqualTo(country_code,[us]), IsNotNull(id)]
ReadSchema: struct<id:int,country_code:string>

(55) Filter
Input [2]: [id#23, country_code#25]
Condition : ((isnotnull(country_code#25) AND (country_code#25 = [us])) AND isnotnull(id#23))

(56) Project
Output [1]: [id#23]
Input [2]: [id#23, country_code#25]

(57) BroadcastHashJoin
Left keys [1]: [company_id#34]
Right keys [1]: [id#23]
Join type: Inner
Join condition: None

(58) Project
Output [2]: [movie_id#116, movie_id#33]
Input [4]: [movie_id#116, movie_id#33, company_id#34, id#23]

(59) BroadcastExchange
Input [2]: [movie_id#116, movie_id#33]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[1, int, true] as bigint), 32) | (cast(input[0, int, true] as bigint) & 4294967295))),false), [plan_id=25399]

(60) Scan parquet spark_catalog.imdb_10x.movie_info
Output [3]: [movie_id#213, info_type_id#214, info#215]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [IsNotNull(info), IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(61) Filter
Input [3]: [movie_id#213, info_type_id#214, info#215]
Condition : (((isnotnull(info#215) AND info#215 LIKE USA:%200%) AND isnotnull(movie_id#213)) AND isnotnull(info_type_id#214))

(62) Project
Output [2]: [movie_id#213, info_type_id#214]
Input [3]: [movie_id#213, info_type_id#214, info#215]

(63) BroadcastHashJoin
Left keys [2]: [movie_id#33, movie_id#116]
Right keys [2]: [movie_id#213, movie_id#213]
Join type: Inner
Join condition: None

(64) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#210, info#211]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,release dates), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(65) Filter
Input [2]: [id#210, info#211]
Condition : ((isnotnull(info#211) AND (info#211 = release dates)) AND isnotnull(id#210))

(66) Project
Output [1]: [id#210]
Input [2]: [id#210, info#211]

(67) BroadcastExchange
Input [1]: [id#210]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=25402]

(68) BroadcastHashJoin
Left keys [1]: [info_type_id#214]
Right keys [1]: [id#210]
Join type: Inner
Join condition: None

(69) Project
Output [3]: [movie_id#116, movie_id#33, movie_id#213]
Input [5]: [movie_id#116, movie_id#33, movie_id#213, info_type_id#214, id#210]

(70) BroadcastExchange
Input [3]: [movie_id#116, movie_id#33, movie_id#213]
Arguments: HashedRelationBroadcastMode(List(input[1, int, true], input[2, int, true], input[0, int, true], input[2, int, true], input[1, int, true], input[0, int, true]),false), [plan_id=25406]

(71) BroadcastHashJoin
Left keys [6]: [movie_id#18, movie_id#18, movie_id#18, id#39, id#39, id#39]
Right keys [6]: [movie_id#33, movie_id#213, movie_id#116, movie_id#213, movie_id#33, movie_id#116]
Join type: Inner
Join condition: None

(72) Exchange
Input [8]: [movie_id#18, id#39, title#40, name#541, name#10, movie_id#116, movie_id#33, movie_id#213]
Arguments: hashpartitioning(movie_id#18, movie_id#33, movie_id#213, movie_id#116, id#39, 200), ENSURE_REQUIREMENTS, [plan_id=25417]

(73) Sort
Input [8]: [movie_id#18, id#39, title#40, name#541, name#10, movie_id#116, movie_id#33, movie_id#213]
Arguments: [movie_id#18 ASC NULLS FIRST, movie_id#33 ASC NULLS FIRST, movie_id#213 ASC NULLS FIRST, movie_id#116 ASC NULLS FIRST, id#39 ASC NULLS FIRST], false, 0

(74) Scan parquet spark_catalog.imdb_10x.complete_cast
Output [3]: [movie_id#927, subject_id#928, status_id#929]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/complete_cast]
PushedFilters: [IsNotNull(movie_id), IsNotNull(subject_id), IsNotNull(status_id)]
ReadSchema: struct<movie_id:string,subject_id:int,status_id:int>

(75) Filter
Input [3]: [movie_id#927, subject_id#928, status_id#929]
Condition : ((isnotnull(movie_id#927) AND isnotnull(subject_id#928)) AND isnotnull(status_id#929))

(76) Scan parquet spark_catalog.imdb_10x.comp_cast_type
Output [2]: [id#930, kind#931]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/comp_cast_type]
PushedFilters: [IsNotNull(kind), EqualTo(kind,cast), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(77) Filter
Input [2]: [id#930, kind#931]
Condition : ((isnotnull(kind#931) AND (kind#931 = cast)) AND isnotnull(id#930))

(78) Project
Output [1]: [id#930]
Input [2]: [id#930, kind#931]

(79) BroadcastExchange
Input [1]: [id#930]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=25408]

(80) BroadcastHashJoin
Left keys [1]: [subject_id#928]
Right keys [1]: [id#930]
Join type: Inner
Join condition: None

(81) Project
Output [2]: [movie_id#927, status_id#929]
Input [4]: [movie_id#927, subject_id#928, status_id#929, id#930]

(82) Scan parquet spark_catalog.imdb_10x.comp_cast_type
Output [2]: [id#1586, kind#1587]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/comp_cast_type]
PushedFilters: [IsNotNull(kind), EqualTo(kind,complete+verified), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(83) Filter
Input [2]: [id#1586, kind#1587]
Condition : ((isnotnull(kind#1587) AND (kind#1587 = complete+verified)) AND isnotnull(id#1586))

(84) Project
Output [1]: [id#1586]
Input [2]: [id#1586, kind#1587]

(85) BroadcastExchange
Input [1]: [id#1586]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=25412]

(86) BroadcastHashJoin
Left keys [1]: [status_id#929]
Right keys [1]: [id#1586]
Join type: Inner
Join condition: None

(87) Project
Output [1]: [movie_id#927]
Input [3]: [movie_id#927, status_id#929, id#1586]

(88) Exchange
Input [1]: [movie_id#927]
Arguments: hashpartitioning(cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int), 200), ENSURE_REQUIREMENTS, [plan_id=25418]

(89) Sort
Input [1]: [movie_id#927]
Arguments: [cast(movie_id#927 as int) ASC NULLS FIRST, cast(movie_id#927 as int) ASC NULLS FIRST, cast(movie_id#927 as int) ASC NULLS FIRST, cast(movie_id#927 as int) ASC NULLS FIRST, cast(movie_id#927 as int) ASC NULLS FIRST], false, 0

(90) SortMergeJoin
Left keys [5]: [movie_id#18, movie_id#33, movie_id#213, movie_id#116, id#39]
Right keys [5]: [cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int)]
Join type: Inner
Join condition: None

(91) Project
Output [3]: [name#10, name#541, title#40]
Input [9]: [movie_id#18, id#39, title#40, name#541, name#10, movie_id#116, movie_id#33, movie_id#213, movie_id#927]

(92) SortAggregate
Input [3]: [name#10, name#541, title#40]
Keys: []
Functions [3]: [partial_min(name#10), partial_min(name#541), partial_min(title#40)]
Aggregate Attributes [3]: [min#1595, min#1596, min#1597]
Results [3]: [min#1598, min#1599, min#1600]

(93) Exchange
Input [3]: [min#1598, min#1599, min#1600]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=25425]

(94) SortAggregate
Input [3]: [min#1598, min#1599, min#1600]
Keys: []
Functions [3]: [min(name#10), min(name#541), min(title#40)]
Aggregate Attributes [3]: [min(name#10)#1592, min(name#541)#1593, min(title#40)#1594]
Results [3]: [min(name#10)#1592 AS voiced_char#1578, min(name#541)#1593 AS voicing_actress#1579, min(title#40)#1594 AS voiced_animation#1580]

(95) AdaptiveSparkPlan
Output [3]: [voiced_char#1578, voicing_actress#1579, voiced_animation#1580]
Arguments: isFinalPlan=false
Execution Time: 300.0
