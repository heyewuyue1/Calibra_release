== Physical Plan ==
AdaptiveSparkPlan (56)
+- SortAggregate (55)
   +- Exchange (54)
      +- SortAggregate (53)
         +- Project (52)
            +- BroadcastHashJoin Inner BuildLeft (51)
               :- BroadcastExchange (48)
               :  +- Project (47)
               :     +- BroadcastHashJoin Inner BuildRight (46)
               :        :- Project (41)
               :        :  +- BroadcastHashJoin Inner BuildLeft (40)
               :        :     :- BroadcastExchange (36)
               :        :     :  +- Project (35)
               :        :     :     +- BroadcastHashJoin Inner BuildLeft (34)
               :        :     :        :- BroadcastExchange (31)
               :        :     :        :  +- Project (30)
               :        :     :        :     +- BroadcastHashJoin Inner BuildRight (29)
               :        :     :        :        :- BroadcastHashJoin Inner BuildLeft (24)
               :        :     :        :        :  :- BroadcastExchange (20)
               :        :     :        :        :  :  +- BroadcastHashJoin Inner BuildLeft (19)
               :        :     :        :        :  :     :- BroadcastExchange (15)
               :        :     :        :        :  :     :  +- BroadcastHashJoin Inner BuildLeft (14)
               :        :     :        :        :  :     :     :- BroadcastExchange (10)
               :        :     :        :        :  :     :     :  +- Project (9)
               :        :     :        :        :  :     :     :     +- BroadcastHashJoin Inner BuildRight (8)
               :        :     :        :        :  :     :     :        :- Project (3)
               :        :     :        :        :  :     :     :        :  +- Filter (2)
               :        :     :        :        :  :     :     :        :     +- Scan parquet spark_catalog.imdb_10x.cast_info (1)
               :        :     :        :        :  :     :     :        +- BroadcastExchange (7)
               :        :     :        :        :  :     :     :           +- Project (6)
               :        :     :        :        :  :     :     :              +- Filter (5)
               :        :     :        :        :  :     :     :                 +- Scan parquet spark_catalog.imdb_10x.role_type (4)
               :        :     :        :        :  :     :     +- Project (13)
               :        :     :        :        :  :     :        +- Filter (12)
               :        :     :        :        :  :     :           +- Scan parquet spark_catalog.imdb_10x.name (11)
               :        :     :        :        :  :     +- Project (18)
               :        :     :        :        :  :        +- Filter (17)
               :        :     :        :        :  :           +- Scan parquet spark_catalog.imdb_10x.title (16)
               :        :     :        :        :  +- Project (23)
               :        :     :        :        :     +- Filter (22)
               :        :     :        :        :        +- Scan parquet spark_catalog.imdb_10x.movie_companies (21)
               :        :     :        :        +- BroadcastExchange (28)
               :        :     :        :           +- Project (27)
               :        :     :        :              +- Filter (26)
               :        :     :        :                 +- Scan parquet spark_catalog.imdb_10x.company_name (25)
               :        :     :        +- Filter (33)
               :        :     :           +- Scan parquet spark_catalog.imdb_10x.aka_name (32)
               :        :     +- Project (39)
               :        :        +- Filter (38)
               :        :           +- Scan parquet spark_catalog.imdb_10x.movie_info (37)
               :        +- BroadcastExchange (45)
               :           +- Project (44)
               :              +- Filter (43)
               :                 +- Scan parquet spark_catalog.imdb_10x.info_type (42)
               +- Filter (50)
                  +- Scan parquet spark_catalog.imdb_10x.char_name (49)


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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=10804]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=10808]

(11) Scan parquet spark_catalog.imdb_10x.name
Output [3]: [id#540, name#541, gender#544]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/name]
PushedFilters: [IsNotNull(gender), IsNotNull(name), EqualTo(gender,f), StringContains(name,Ang), IsNotNull(id)]
ReadSchema: struct<id:int,name:string,gender:string>

(12) Filter
Input [3]: [id#540, name#541, gender#544]
Condition : ((((isnotnull(gender#544) AND isnotnull(name#541)) AND (gender#544 = f)) AND Contains(name#541, Ang)) AND isnotnull(id#540))

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
Arguments: HashedRelationBroadcastMode(List(cast(input[1, int, true] as bigint)),false), [plan_id=10811]

(16) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#39, title#40, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(17) Filter
Input [3]: [id#39, title#40, production_year#43]
Condition : (((isnotnull(production_year#43) AND (cast(production_year#43 as int) >= 2005)) AND (cast(production_year#43 as int) <= 2009)) AND isnotnull(id#39))

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
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[1, int, true] as bigint), 32) | (cast(input[5, int, true] as bigint) & 4294967295))),false), [plan_id=10814]

(21) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [3]: [movie_id#33, company_id#34, note#36]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(note), Or(StringContains(note,(USA)),StringContains(note,(worldwide))), IsNotNull(movie_id), IsNotNull(company_id)]
ReadSchema: struct<movie_id:int,company_id:int,note:string>

(22) Filter
Input [3]: [movie_id#33, company_id#34, note#36]
Condition : (((isnotnull(note#36) AND (Contains(note#36, (USA)) OR Contains(note#36, (worldwide)))) AND isnotnull(movie_id#33)) AND isnotnull(company_id#34))

(23) Project
Output [2]: [movie_id#33, company_id#34]
Input [3]: [movie_id#33, company_id#34, note#36]

(24) BroadcastHashJoin
Left keys [2]: [movie_id#18, id#39]
Right keys [2]: [movie_id#33, movie_id#33]
Join type: Inner
Join condition: None

(25) Scan parquet spark_catalog.imdb_10x.company_name
Output [2]: [id#23, country_code#25]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(country_code), EqualTo(country_code,[us]), IsNotNull(id)]
ReadSchema: struct<id:int,country_code:string>

(26) Filter
Input [2]: [id#23, country_code#25]
Condition : ((isnotnull(country_code#25) AND (country_code#25 = [us])) AND isnotnull(id#23))

(27) Project
Output [1]: [id#23]
Input [2]: [id#23, country_code#25]

(28) BroadcastExchange
Input [1]: [id#23]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=10817]

(29) BroadcastHashJoin
Left keys [1]: [company_id#34]
Right keys [1]: [id#23]
Join type: Inner
Join condition: None

(30) Project
Output [8]: [person_id#17, movie_id#18, person_role_id#19, id#540, name#541, id#39, title#40, movie_id#33]
Input [10]: [person_id#17, movie_id#18, person_role_id#19, id#540, name#541, id#39, title#40, movie_id#33, company_id#34, id#23]

(31) BroadcastExchange
Input [8]: [person_id#17, movie_id#18, person_role_id#19, id#540, name#541, id#39, title#40, movie_id#33]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[3, int, true] as bigint) & 4294967295))),false), [plan_id=10821]

(32) Scan parquet spark_catalog.imdb_10x.aka_name
Output [1]: [person_id#533]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/aka_name]
PushedFilters: [IsNotNull(person_id)]
ReadSchema: struct<person_id:int>

(33) Filter
Input [1]: [person_id#533]
Condition : isnotnull(person_id#533)

(34) BroadcastHashJoin
Left keys [2]: [person_id#17, id#540]
Right keys [2]: [person_id#533, person_id#533]
Join type: Inner
Join condition: None

(35) Project
Output [6]: [movie_id#18, person_role_id#19, name#541, id#39, title#40, movie_id#33]
Input [9]: [person_id#17, movie_id#18, person_role_id#19, id#540, name#541, id#39, title#40, movie_id#33, person_id#533]

(36) BroadcastExchange
Input [6]: [movie_id#18, person_role_id#19, name#541, id#39, title#40, movie_id#33]
Arguments: HashedRelationBroadcastMode(List(input[5, int, true], input[0, int, true], input[3, int, true]),false), [plan_id=10825]

(37) Scan parquet spark_catalog.imdb_10x.movie_info
Output [3]: [movie_id#213, info_type_id#214, info#215]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [IsNotNull(info), IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(38) Filter
Input [3]: [movie_id#213, info_type_id#214, info#215]
Condition : (((isnotnull(info#215) AND (info#215 LIKE Japan:%200% OR info#215 LIKE USA:%200%)) AND isnotnull(movie_id#213)) AND isnotnull(info_type_id#214))

(39) Project
Output [2]: [movie_id#213, info_type_id#214]
Input [3]: [movie_id#213, info_type_id#214, info#215]

(40) BroadcastHashJoin
Left keys [3]: [movie_id#33, movie_id#18, id#39]
Right keys [3]: [movie_id#213, movie_id#213, movie_id#213]
Join type: Inner
Join condition: None

(41) Project
Output [4]: [person_role_id#19, name#541, title#40, info_type_id#214]
Input [8]: [movie_id#18, person_role_id#19, name#541, id#39, title#40, movie_id#33, movie_id#213, info_type_id#214]

(42) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#210, info#211]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,release dates), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(43) Filter
Input [2]: [id#210, info#211]
Condition : ((isnotnull(info#211) AND (info#211 = release dates)) AND isnotnull(id#210))

(44) Project
Output [1]: [id#210]
Input [2]: [id#210, info#211]

(45) BroadcastExchange
Input [1]: [id#210]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=10829]

(46) BroadcastHashJoin
Left keys [1]: [info_type_id#214]
Right keys [1]: [id#210]
Join type: Inner
Join condition: None

(47) Project
Output [3]: [person_role_id#19, name#541, title#40]
Input [5]: [person_role_id#19, name#541, title#40, info_type_id#214, id#210]

(48) BroadcastExchange
Input [3]: [person_role_id#19, name#541, title#40]
Arguments: HashedRelationBroadcastMode(List(cast(cast(input[0, string, true] as int) as bigint)),false), [plan_id=10833]

(49) Scan parquet spark_catalog.imdb_10x.char_name
Output [1]: [id#9]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/char_name]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int>

(50) Filter
Input [1]: [id#9]
Condition : isnotnull(id#9)

(51) BroadcastHashJoin
Left keys [1]: [cast(person_role_id#19 as int)]
Right keys [1]: [id#9]
Join type: Inner
Join condition: None

(52) Project
Output [2]: [name#541, title#40]
Input [4]: [person_role_id#19, name#541, title#40, id#9]

(53) SortAggregate
Input [2]: [name#541, title#40]
Keys: []
Functions [2]: [partial_min(name#541), partial_min(title#40)]
Aggregate Attributes [2]: [min#777, min#778]
Results [2]: [min#779, min#780]

(54) Exchange
Input [2]: [min#779, min#780]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=10838]

(55) SortAggregate
Input [2]: [min#779, min#780]
Keys: []
Functions [2]: [min(name#541), min(title#40)]
Aggregate Attributes [2]: [min(name#541)#775, min(title#40)#776]
Results [2]: [min(name#541)#775 AS voicing_actress#768, min(title#40)#776 AS voiced_movie#769]

(56) AdaptiveSparkPlan
Output [2]: [voicing_actress#768, voiced_movie#769]
Arguments: isFinalPlan=false
Execution Time: 30.022
