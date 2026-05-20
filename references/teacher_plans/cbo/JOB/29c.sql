== Physical Plan ==
AdaptiveSparkPlan (95)
+- SortAggregate (94)
   +- Exchange (93)
      +- SortAggregate (92)
         +- Project (91)
            +- SortMergeJoin Inner (90)
               :- Sort (52)
               :  +- Exchange (51)
               :     +- BroadcastHashJoin Inner BuildLeft (50)
               :        :- BroadcastExchange (35)
               :        :  +- Project (34)
               :        :     +- BroadcastHashJoin Inner BuildRight (33)
               :        :        :- BroadcastHashJoin Inner BuildLeft (28)
               :        :        :  :- BroadcastExchange (24)
               :        :        :  :  +- Project (23)
               :        :        :  :     +- BroadcastHashJoin Inner BuildLeft (22)
               :        :        :  :        :- BroadcastExchange (18)
               :        :        :  :        :  +- BroadcastHashJoin Inner BuildLeft (17)
               :        :        :  :        :     :- BroadcastExchange (14)
               :        :        :  :        :     :  +- BroadcastHashJoin Inner BuildLeft (13)
               :        :        :  :        :     :     :- BroadcastExchange (9)
               :        :        :  :        :     :     :  +- Project (8)
               :        :        :  :        :     :     :     +- BroadcastHashJoin Inner BuildRight (7)
               :        :        :  :        :     :     :        :- Filter (2)
               :        :        :  :        :     :     :        :  +- Scan parquet spark_catalog.imdb_10x.movie_keyword (1)
               :        :        :  :        :     :     :        +- BroadcastExchange (6)
               :        :        :  :        :     :     :           +- Project (5)
               :        :        :  :        :     :     :              +- Filter (4)
               :        :        :  :        :     :     :                 +- Scan parquet spark_catalog.imdb_10x.keyword (3)
               :        :        :  :        :     :     +- Project (12)
               :        :        :  :        :     :        +- Filter (11)
               :        :        :  :        :     :           +- Scan parquet spark_catalog.imdb_10x.title (10)
               :        :        :  :        :     +- Filter (16)
               :        :        :  :        :        +- Scan parquet spark_catalog.imdb_10x.movie_companies (15)
               :        :        :  :        +- Project (21)
               :        :        :  :           +- Filter (20)
               :        :        :  :              +- Scan parquet spark_catalog.imdb_10x.company_name (19)
               :        :        :  +- Project (27)
               :        :        :     +- Filter (26)
               :        :        :        +- Scan parquet spark_catalog.imdb_10x.movie_info (25)
               :        :        +- BroadcastExchange (32)
               :        :           +- Project (31)
               :        :              +- Filter (30)
               :        :                 +- Scan parquet spark_catalog.imdb_10x.info_type (29)
               :        +- Project (49)
               :           +- BroadcastHashJoin Inner BuildRight (48)
               :              :- Project (43)
               :              :  +- BroadcastHashJoin Inner BuildRight (42)
               :              :     :- Filter (37)
               :              :     :  +- Scan parquet spark_catalog.imdb_10x.complete_cast (36)
               :              :     +- BroadcastExchange (41)
               :              :        +- Project (40)
               :              :           +- Filter (39)
               :              :              +- Scan parquet spark_catalog.imdb_10x.comp_cast_type (38)
               :              +- BroadcastExchange (47)
               :                 +- Project (46)
               :                    +- Filter (45)
               :                       +- Scan parquet spark_catalog.imdb_10x.comp_cast_type (44)
               +- Sort (89)
                  +- Exchange (88)
                     +- Project (87)
                        +- BroadcastHashJoin Inner BuildLeft (86)
                           :- BroadcastExchange (83)
                           :  +- Project (82)
                           :     +- BroadcastHashJoin Inner BuildRight (81)
                           :        :- Project (76)
                           :        :  +- BroadcastHashJoin Inner BuildLeft (75)
                           :        :     :- BroadcastExchange (72)
                           :        :     :  +- Project (71)
                           :        :     :     +- BroadcastHashJoin Inner BuildLeft (70)
                           :        :     :        :- BroadcastExchange (67)
                           :        :     :        :  +- BroadcastHashJoin Inner BuildLeft (66)
                           :        :     :        :     :- BroadcastExchange (62)
                           :        :     :        :     :  +- Project (61)
                           :        :     :        :     :     +- BroadcastHashJoin Inner BuildRight (60)
                           :        :     :        :     :        :- Project (55)
                           :        :     :        :     :        :  +- Filter (54)
                           :        :     :        :     :        :     +- Scan parquet spark_catalog.imdb_10x.cast_info (53)
                           :        :     :        :     :        +- BroadcastExchange (59)
                           :        :     :        :     :           +- Project (58)
                           :        :     :        :     :              +- Filter (57)
                           :        :     :        :     :                 +- Scan parquet spark_catalog.imdb_10x.role_type (56)
                           :        :     :        :     +- Project (65)
                           :        :     :        :        +- Filter (64)
                           :        :     :        :           +- Scan parquet spark_catalog.imdb_10x.name (63)
                           :        :     :        +- Filter (69)
                           :        :     :           +- Scan parquet spark_catalog.imdb_10x.aka_name (68)
                           :        :     +- Filter (74)
                           :        :        +- Scan parquet spark_catalog.imdb_10x.person_info (73)
                           :        +- BroadcastExchange (80)
                           :           +- Project (79)
                           :              +- Filter (78)
                           :                 +- Scan parquet spark_catalog.imdb_10x.info_type (77)
                           +- Filter (85)
                              +- Scan parquet spark_catalog.imdb_10x.char_name (84)


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
PushedFilters: [IsNotNull(keyword), EqualTo(keyword,computer-animation), IsNotNull(id)]
ReadSchema: struct<id:int,keyword:string>

(4) Filter
Input [2]: [id#110, keyword#111]
Condition : ((isnotnull(keyword#111) AND (keyword#111 = computer-animation)) AND isnotnull(id#110))

(5) Project
Output [1]: [id#110]
Input [2]: [id#110, keyword#111]

(6) BroadcastExchange
Input [1]: [id#110]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=26003]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=26007]

(10) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#39, title#40, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(11) Filter
Input [3]: [id#39, title#40, production_year#43]
Condition : (((isnotnull(production_year#43) AND (cast(production_year#43 as int) >= 2000)) AND (cast(production_year#43 as int) <= 2010)) AND isnotnull(id#39))

(12) Project
Output [2]: [id#39, title#40]
Input [3]: [id#39, title#40, production_year#43]

(13) BroadcastHashJoin
Left keys [1]: [movie_id#116]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(14) BroadcastExchange
Input [3]: [movie_id#116, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[1, int, true] as bigint) & 4294967295))),false), [plan_id=26010]

(15) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [2]: [movie_id#33, company_id#34]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(movie_id), IsNotNull(company_id)]
ReadSchema: struct<movie_id:int,company_id:int>

(16) Filter
Input [2]: [movie_id#33, company_id#34]
Condition : (isnotnull(movie_id#33) AND isnotnull(company_id#34))

(17) BroadcastHashJoin
Left keys [2]: [movie_id#116, id#39]
Right keys [2]: [movie_id#33, movie_id#33]
Join type: Inner
Join condition: None

(18) BroadcastExchange
Input [5]: [movie_id#116, id#39, title#40, movie_id#33, company_id#34]
Arguments: HashedRelationBroadcastMode(List(cast(input[4, int, false] as bigint)),false), [plan_id=26013]

(19) Scan parquet spark_catalog.imdb_10x.company_name
Output [2]: [id#23, country_code#25]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(country_code), EqualTo(country_code,[us]), IsNotNull(id)]
ReadSchema: struct<id:int,country_code:string>

(20) Filter
Input [2]: [id#23, country_code#25]
Condition : ((isnotnull(country_code#25) AND (country_code#25 = [us])) AND isnotnull(id#23))

(21) Project
Output [1]: [id#23]
Input [2]: [id#23, country_code#25]

(22) BroadcastHashJoin
Left keys [1]: [company_id#34]
Right keys [1]: [id#23]
Join type: Inner
Join condition: None

(23) Project
Output [4]: [movie_id#116, id#39, title#40, movie_id#33]
Input [6]: [movie_id#116, id#39, title#40, movie_id#33, company_id#34, id#23]

(24) BroadcastExchange
Input [4]: [movie_id#116, id#39, title#40, movie_id#33]
Arguments: HashedRelationBroadcastMode(List(input[3, int, true], input[0, int, true], input[1, int, true]),false), [plan_id=26017]

(25) Scan parquet spark_catalog.imdb_10x.movie_info
Output [3]: [movie_id#213, info_type_id#214, info#215]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [IsNotNull(info), IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(26) Filter
Input [3]: [movie_id#213, info_type_id#214, info#215]
Condition : (((isnotnull(info#215) AND (info#215 LIKE Japan:%200% OR info#215 LIKE USA:%200%)) AND isnotnull(movie_id#213)) AND isnotnull(info_type_id#214))

(27) Project
Output [2]: [movie_id#213, info_type_id#214]
Input [3]: [movie_id#213, info_type_id#214, info#215]

(28) BroadcastHashJoin
Left keys [3]: [movie_id#33, movie_id#116, id#39]
Right keys [3]: [movie_id#213, movie_id#213, movie_id#213]
Join type: Inner
Join condition: None

(29) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#210, info#211]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,release dates), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(30) Filter
Input [2]: [id#210, info#211]
Condition : ((isnotnull(info#211) AND (info#211 = release dates)) AND isnotnull(id#210))

(31) Project
Output [1]: [id#210]
Input [2]: [id#210, info#211]

(32) BroadcastExchange
Input [1]: [id#210]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=26020]

(33) BroadcastHashJoin
Left keys [1]: [info_type_id#214]
Right keys [1]: [id#210]
Join type: Inner
Join condition: None

(34) Project
Output [5]: [movie_id#116, id#39, title#40, movie_id#33, movie_id#213]
Input [7]: [movie_id#116, id#39, title#40, movie_id#33, movie_id#213, info_type_id#214, id#210]

(35) BroadcastExchange
Input [5]: [movie_id#116, id#39, title#40, movie_id#33, movie_id#213]
Arguments: HashedRelationBroadcastMode(List(input[3, int, true], input[4, int, true], input[0, int, true], input[1, int, true]),false), [plan_id=26031]

(36) Scan parquet spark_catalog.imdb_10x.complete_cast
Output [3]: [movie_id#927, subject_id#928, status_id#929]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/complete_cast]
PushedFilters: [IsNotNull(movie_id), IsNotNull(subject_id), IsNotNull(status_id)]
ReadSchema: struct<movie_id:string,subject_id:int,status_id:int>

(37) Filter
Input [3]: [movie_id#927, subject_id#928, status_id#929]
Condition : ((isnotnull(movie_id#927) AND isnotnull(subject_id#928)) AND isnotnull(status_id#929))

(38) Scan parquet spark_catalog.imdb_10x.comp_cast_type
Output [2]: [id#930, kind#931]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/comp_cast_type]
PushedFilters: [IsNotNull(kind), EqualTo(kind,cast), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(39) Filter
Input [2]: [id#930, kind#931]
Condition : ((isnotnull(kind#931) AND (kind#931 = cast)) AND isnotnull(id#930))

(40) Project
Output [1]: [id#930]
Input [2]: [id#930, kind#931]

(41) BroadcastExchange
Input [1]: [id#930]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=26023]

(42) BroadcastHashJoin
Left keys [1]: [subject_id#928]
Right keys [1]: [id#930]
Join type: Inner
Join condition: None

(43) Project
Output [2]: [movie_id#927, status_id#929]
Input [4]: [movie_id#927, subject_id#928, status_id#929, id#930]

(44) Scan parquet spark_catalog.imdb_10x.comp_cast_type
Output [2]: [id#1613, kind#1614]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/comp_cast_type]
PushedFilters: [IsNotNull(kind), EqualTo(kind,complete+verified), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(45) Filter
Input [2]: [id#1613, kind#1614]
Condition : ((isnotnull(kind#1614) AND (kind#1614 = complete+verified)) AND isnotnull(id#1613))

(46) Project
Output [1]: [id#1613]
Input [2]: [id#1613, kind#1614]

(47) BroadcastExchange
Input [1]: [id#1613]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=26027]

(48) BroadcastHashJoin
Left keys [1]: [status_id#929]
Right keys [1]: [id#1613]
Join type: Inner
Join condition: None

(49) Project
Output [1]: [movie_id#927]
Input [3]: [movie_id#927, status_id#929, id#1613]

(50) BroadcastHashJoin
Left keys [4]: [movie_id#33, movie_id#213, movie_id#116, id#39]
Right keys [4]: [cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int)]
Join type: Inner
Join condition: None

(51) Exchange
Input [6]: [movie_id#116, id#39, title#40, movie_id#33, movie_id#213, movie_id#927]
Arguments: hashpartitioning(cast(movie_id#927 as int), movie_id#33, movie_id#213, movie_id#116, id#39, 200), ENSURE_REQUIREMENTS, [plan_id=26057]

(52) Sort
Input [6]: [movie_id#116, id#39, title#40, movie_id#33, movie_id#213, movie_id#927]
Arguments: [cast(movie_id#927 as int) ASC NULLS FIRST, movie_id#33 ASC NULLS FIRST, movie_id#213 ASC NULLS FIRST, movie_id#116 ASC NULLS FIRST, id#39 ASC NULLS FIRST], false, 0

(53) Scan parquet spark_catalog.imdb_10x.cast_info
Output [5]: [person_id#17, movie_id#18, person_role_id#19, note#20, role_id#22]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/cast_info]
PushedFilters: [In(note, [(voice),(voice) (uncredited),(voice: English version),(voice: Japanese version)]), IsNotNull(person_id), IsNotNull(movie_id), IsNotNull(person_role_id), IsNotNull(role_id)]
ReadSchema: struct<person_id:int,movie_id:int,person_role_id:string,note:string,role_id:int>

(54) Filter
Input [5]: [person_id#17, movie_id#18, person_role_id#19, note#20, role_id#22]
Condition : ((((note#20 IN ((voice),(voice: Japanese version),(voice) (uncredited),(voice: English version)) AND isnotnull(person_id#17)) AND isnotnull(movie_id#18)) AND isnotnull(person_role_id#19)) AND isnotnull(role_id#22))

(55) Project
Output [4]: [person_id#17, movie_id#18, person_role_id#19, role_id#22]
Input [5]: [person_id#17, movie_id#18, person_role_id#19, note#20, role_id#22]

(56) Scan parquet spark_catalog.imdb_10x.role_type
Output [2]: [id#37, role#38]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/role_type]
PushedFilters: [IsNotNull(role), EqualTo(role,actress), IsNotNull(id)]
ReadSchema: struct<id:int,role:string>

(57) Filter
Input [2]: [id#37, role#38]
Condition : ((isnotnull(role#38) AND (role#38 = actress)) AND isnotnull(id#37))

(58) Project
Output [1]: [id#37]
Input [2]: [id#37, role#38]

(59) BroadcastExchange
Input [1]: [id#37]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=26033]

(60) BroadcastHashJoin
Left keys [1]: [role_id#22]
Right keys [1]: [id#37]
Join type: Inner
Join condition: None

(61) Project
Output [3]: [person_id#17, movie_id#18, person_role_id#19]
Input [5]: [person_id#17, movie_id#18, person_role_id#19, role_id#22, id#37]

(62) BroadcastExchange
Input [3]: [person_id#17, movie_id#18, person_role_id#19]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=26037]

(63) Scan parquet spark_catalog.imdb_10x.name
Output [3]: [id#540, name#541, gender#544]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/name]
PushedFilters: [IsNotNull(gender), IsNotNull(name), EqualTo(gender,f), StringContains(name,An), IsNotNull(id)]
ReadSchema: struct<id:int,name:string,gender:string>

(64) Filter
Input [3]: [id#540, name#541, gender#544]
Condition : ((((isnotnull(gender#544) AND isnotnull(name#541)) AND (gender#544 = f)) AND Contains(name#541, An)) AND isnotnull(id#540))

(65) Project
Output [2]: [id#540, name#541]
Input [3]: [id#540, name#541, gender#544]

(66) BroadcastHashJoin
Left keys [1]: [person_id#17]
Right keys [1]: [id#540]
Join type: Inner
Join condition: None

(67) BroadcastExchange
Input [5]: [person_id#17, movie_id#18, person_role_id#19, id#540, name#541]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[3, int, true] as bigint) & 4294967295))),false), [plan_id=26040]

(68) Scan parquet spark_catalog.imdb_10x.aka_name
Output [1]: [person_id#533]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/aka_name]
PushedFilters: [IsNotNull(person_id)]
ReadSchema: struct<person_id:int>

(69) Filter
Input [1]: [person_id#533]
Condition : isnotnull(person_id#533)

(70) BroadcastHashJoin
Left keys [2]: [person_id#17, id#540]
Right keys [2]: [person_id#533, person_id#533]
Join type: Inner
Join condition: None

(71) Project
Output [5]: [person_id#17, movie_id#18, person_role_id#19, id#540, name#541]
Input [6]: [person_id#17, movie_id#18, person_role_id#19, id#540, name#541, person_id#533]

(72) BroadcastExchange
Input [5]: [person_id#17, movie_id#18, person_role_id#19, id#540, name#541]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[3, int, true] as bigint), 32) | (cast(input[0, int, true] as bigint) & 4294967295))),false), [plan_id=26044]

(73) Scan parquet spark_catalog.imdb_10x.person_info
Output [2]: [person_id#1554, info_type_id#1555]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/person_info]
PushedFilters: [IsNotNull(person_id), IsNotNull(info_type_id)]
ReadSchema: struct<person_id:int,info_type_id:int>

(74) Filter
Input [2]: [person_id#1554, info_type_id#1555]
Condition : (isnotnull(person_id#1554) AND isnotnull(info_type_id#1555))

(75) BroadcastHashJoin
Left keys [2]: [id#540, person_id#17]
Right keys [2]: [person_id#1554, person_id#1554]
Join type: Inner
Join condition: None

(76) Project
Output [4]: [movie_id#18, person_role_id#19, name#541, info_type_id#1555]
Input [7]: [person_id#17, movie_id#18, person_role_id#19, id#540, name#541, person_id#1554, info_type_id#1555]

(77) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#1615, info#1616]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,trivia), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(78) Filter
Input [2]: [id#1615, info#1616]
Condition : ((isnotnull(info#1616) AND (info#1616 = trivia)) AND isnotnull(id#1615))

(79) Project
Output [1]: [id#1615]
Input [2]: [id#1615, info#1616]

(80) BroadcastExchange
Input [1]: [id#1615]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=26048]

(81) BroadcastHashJoin
Left keys [1]: [info_type_id#1555]
Right keys [1]: [id#1615]
Join type: Inner
Join condition: None

(82) Project
Output [3]: [movie_id#18, person_role_id#19, name#541]
Input [5]: [movie_id#18, person_role_id#19, name#541, info_type_id#1555, id#1615]

(83) BroadcastExchange
Input [3]: [movie_id#18, person_role_id#19, name#541]
Arguments: HashedRelationBroadcastMode(List(cast(cast(input[1, string, true] as int) as bigint)),false), [plan_id=26052]

(84) Scan parquet spark_catalog.imdb_10x.char_name
Output [2]: [id#9, name#10]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/char_name]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int,name:string>

(85) Filter
Input [2]: [id#9, name#10]
Condition : isnotnull(id#9)

(86) BroadcastHashJoin
Left keys [1]: [cast(person_role_id#19 as int)]
Right keys [1]: [id#9]
Join type: Inner
Join condition: None

(87) Project
Output [3]: [movie_id#18, name#541, name#10]
Input [5]: [movie_id#18, person_role_id#19, name#541, id#9, name#10]

(88) Exchange
Input [3]: [movie_id#18, name#541, name#10]
Arguments: hashpartitioning(movie_id#18, movie_id#18, movie_id#18, movie_id#18, movie_id#18, 200), ENSURE_REQUIREMENTS, [plan_id=26058]

(89) Sort
Input [3]: [movie_id#18, name#541, name#10]
Arguments: [movie_id#18 ASC NULLS FIRST, movie_id#18 ASC NULLS FIRST, movie_id#18 ASC NULLS FIRST, movie_id#18 ASC NULLS FIRST, movie_id#18 ASC NULLS FIRST], false, 0

(90) SortMergeJoin
Left keys [5]: [cast(movie_id#927 as int), movie_id#33, movie_id#213, movie_id#116, id#39]
Right keys [5]: [movie_id#18, movie_id#18, movie_id#18, movie_id#18, movie_id#18]
Join type: Inner
Join condition: None

(91) Project
Output [3]: [name#10, name#541, title#40]
Input [9]: [movie_id#116, id#39, title#40, movie_id#33, movie_id#213, movie_id#927, movie_id#18, name#541, name#10]

(92) SortAggregate
Input [3]: [name#10, name#541, title#40]
Keys: []
Functions [3]: [partial_min(name#10), partial_min(name#541), partial_min(title#40)]
Aggregate Attributes [3]: [min#1622, min#1623, min#1624]
Results [3]: [min#1625, min#1626, min#1627]

(93) Exchange
Input [3]: [min#1625, min#1626, min#1627]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=26065]

(94) SortAggregate
Input [3]: [min#1625, min#1626, min#1627]
Keys: []
Functions [3]: [min(name#10), min(name#541), min(title#40)]
Aggregate Attributes [3]: [min(name#10)#1619, min(name#541)#1620, min(title#40)#1621]
Results [3]: [min(name#10)#1619 AS voiced_char#1605, min(name#541)#1620 AS voicing_actress#1606, min(title#40)#1621 AS voiced_animation#1607]

(95) AdaptiveSparkPlan
Output [3]: [voiced_char#1605, voicing_actress#1606, voiced_animation#1607]
Arguments: isFinalPlan=false
Execution Time: 300.0
