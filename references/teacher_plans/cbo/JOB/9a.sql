== Physical Plan ==
AdaptiveSparkPlan (45)
+- SortAggregate (44)
   +- Exchange (43)
      +- SortAggregate (42)
         +- Project (41)
            +- BroadcastHashJoin Inner BuildLeft (40)
               :- BroadcastExchange (37)
               :  +- Project (36)
               :     +- BroadcastHashJoin Inner BuildLeft (35)
               :        :- BroadcastExchange (32)
               :        :  +- Project (31)
               :        :     +- BroadcastHashJoin Inner BuildRight (30)
               :        :        :- Project (25)
               :        :        :  +- BroadcastHashJoin Inner BuildLeft (24)
               :        :        :     :- BroadcastExchange (20)
               :        :        :     :  +- BroadcastHashJoin Inner BuildLeft (19)
               :        :        :     :     :- BroadcastExchange (15)
               :        :        :     :     :  +- BroadcastHashJoin Inner BuildLeft (14)
               :        :        :     :     :     :- BroadcastExchange (10)
               :        :        :     :     :     :  +- Project (9)
               :        :        :     :     :     :     +- BroadcastHashJoin Inner BuildRight (8)
               :        :        :     :     :     :        :- Project (3)
               :        :        :     :     :     :        :  +- Filter (2)
               :        :        :     :     :     :        :     +- Scan parquet spark_catalog.imdb_10x.cast_info (1)
               :        :        :     :     :     :        +- BroadcastExchange (7)
               :        :        :     :     :     :           +- Project (6)
               :        :        :     :     :     :              +- Filter (5)
               :        :        :     :     :     :                 +- Scan parquet spark_catalog.imdb_10x.role_type (4)
               :        :        :     :     :     +- Project (13)
               :        :        :     :     :        +- Filter (12)
               :        :        :     :     :           +- Scan parquet spark_catalog.imdb_10x.name (11)
               :        :        :     :     +- Project (18)
               :        :        :     :        +- Filter (17)
               :        :        :     :           +- Scan parquet spark_catalog.imdb_10x.title (16)
               :        :        :     +- Project (23)
               :        :        :        +- Filter (22)
               :        :        :           +- Scan parquet spark_catalog.imdb_10x.movie_companies (21)
               :        :        +- BroadcastExchange (29)
               :        :           +- Project (28)
               :        :              +- Filter (27)
               :        :                 +- Scan parquet spark_catalog.imdb_10x.company_name (26)
               :        +- Filter (34)
               :           +- Scan parquet spark_catalog.imdb_10x.aka_name (33)
               +- Filter (39)
                  +- Scan parquet spark_catalog.imdb_10x.char_name (38)


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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=36890]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=36894]

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
Output [1]: [id#540]
Input [3]: [id#540, name#541, gender#544]

(14) BroadcastHashJoin
Left keys [1]: [person_id#17]
Right keys [1]: [id#540]
Join type: Inner
Join condition: None

(15) BroadcastExchange
Input [4]: [person_id#17, movie_id#18, person_role_id#19, id#540]
Arguments: HashedRelationBroadcastMode(List(cast(input[1, int, true] as bigint)),false), [plan_id=36897]

(16) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#39, title#40, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(17) Filter
Input [3]: [id#39, title#40, production_year#43]
Condition : (((isnotnull(production_year#43) AND (cast(production_year#43 as int) >= 2005)) AND (cast(production_year#43 as int) <= 2015)) AND isnotnull(id#39))

(18) Project
Output [2]: [id#39, title#40]
Input [3]: [id#39, title#40, production_year#43]

(19) BroadcastHashJoin
Left keys [1]: [movie_id#18]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(20) BroadcastExchange
Input [6]: [person_id#17, movie_id#18, person_role_id#19, id#540, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[1, int, true] as bigint), 32) | (cast(input[4, int, true] as bigint) & 4294967295))),false), [plan_id=36900]

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

(25) Project
Output [5]: [person_id#17, person_role_id#19, id#540, title#40, company_id#34]
Input [8]: [person_id#17, movie_id#18, person_role_id#19, id#540, id#39, title#40, movie_id#33, company_id#34]

(26) Scan parquet spark_catalog.imdb_10x.company_name
Output [2]: [id#23, country_code#25]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(country_code), EqualTo(country_code,[us]), IsNotNull(id)]
ReadSchema: struct<id:int,country_code:string>

(27) Filter
Input [2]: [id#23, country_code#25]
Condition : ((isnotnull(country_code#25) AND (country_code#25 = [us])) AND isnotnull(id#23))

(28) Project
Output [1]: [id#23]
Input [2]: [id#23, country_code#25]

(29) BroadcastExchange
Input [1]: [id#23]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=36904]

(30) BroadcastHashJoin
Left keys [1]: [company_id#34]
Right keys [1]: [id#23]
Join type: Inner
Join condition: None

(31) Project
Output [4]: [person_id#17, person_role_id#19, id#540, title#40]
Input [6]: [person_id#17, person_role_id#19, id#540, title#40, company_id#34, id#23]

(32) BroadcastExchange
Input [4]: [person_id#17, person_role_id#19, id#540, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[2, int, true] as bigint) & 4294967295))),false), [plan_id=36908]

(33) Scan parquet spark_catalog.imdb_10x.aka_name
Output [2]: [person_id#533, name#534]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/aka_name]
PushedFilters: [IsNotNull(person_id)]
ReadSchema: struct<person_id:int,name:string>

(34) Filter
Input [2]: [person_id#533, name#534]
Condition : isnotnull(person_id#533)

(35) BroadcastHashJoin
Left keys [2]: [person_id#17, id#540]
Right keys [2]: [person_id#533, person_id#533]
Join type: Inner
Join condition: None

(36) Project
Output [3]: [person_role_id#19, title#40, name#534]
Input [6]: [person_id#17, person_role_id#19, id#540, title#40, person_id#533, name#534]

(37) BroadcastExchange
Input [3]: [person_role_id#19, title#40, name#534]
Arguments: HashedRelationBroadcastMode(List(cast(cast(input[0, string, true] as int) as bigint)),false), [plan_id=36912]

(38) Scan parquet spark_catalog.imdb_10x.char_name
Output [2]: [id#9, name#10]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/char_name]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int,name:string>

(39) Filter
Input [2]: [id#9, name#10]
Condition : isnotnull(id#9)

(40) BroadcastHashJoin
Left keys [1]: [cast(person_role_id#19 as int)]
Right keys [1]: [id#9]
Join type: Inner
Join condition: None

(41) Project
Output [3]: [name#534, name#10, title#40]
Input [5]: [person_role_id#19, title#40, name#534, id#9, name#10]

(42) SortAggregate
Input [3]: [name#534, name#10, title#40]
Keys: []
Functions [3]: [partial_min(name#534), partial_min(name#10), partial_min(title#40)]
Aggregate Attributes [3]: [min#2530, min#2531, min#2532]
Results [3]: [min#2533, min#2534, min#2535]

(43) Exchange
Input [3]: [min#2533, min#2534, min#2535]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=36917]

(44) SortAggregate
Input [3]: [min#2533, min#2534, min#2535]
Keys: []
Functions [3]: [min(name#534), min(name#10), min(title#40)]
Aggregate Attributes [3]: [min(name#534)#2527, min(name#10)#2528, min(title#40)#2529]
Results [3]: [min(name#534)#2527 AS alternative_name#2519, min(name#10)#2528 AS character_name#2520, min(title#40)#2529 AS movie#2521]

(45) AdaptiveSparkPlan
Output [3]: [alternative_name#2519, character_name#2520, movie#2521]
Arguments: isFinalPlan=false
Execution Time: 20.32
