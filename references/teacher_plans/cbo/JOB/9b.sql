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
               :        :     +- BroadcastHashJoin Inner BuildLeft (30)
               :        :        :- BroadcastExchange (26)
               :        :        :  +- Project (25)
               :        :        :     +- BroadcastHashJoin Inner BuildLeft (24)
               :        :        :        :- BroadcastExchange (20)
               :        :        :        :  +- BroadcastHashJoin Inner BuildLeft (19)
               :        :        :        :     :- BroadcastExchange (15)
               :        :        :        :     :  +- BroadcastHashJoin Inner BuildLeft (14)
               :        :        :        :     :     :- BroadcastExchange (10)
               :        :        :        :     :     :  +- Project (9)
               :        :        :        :     :     :     +- BroadcastHashJoin Inner BuildRight (8)
               :        :        :        :     :     :        :- Project (3)
               :        :        :        :     :     :        :  +- Filter (2)
               :        :        :        :     :     :        :     +- Scan parquet spark_catalog.imdb_10x.cast_info (1)
               :        :        :        :     :     :        +- BroadcastExchange (7)
               :        :        :        :     :     :           +- Project (6)
               :        :        :        :     :     :              +- Filter (5)
               :        :        :        :     :     :                 +- Scan parquet spark_catalog.imdb_10x.role_type (4)
               :        :        :        :     :     +- Project (13)
               :        :        :        :     :        +- Filter (12)
               :        :        :        :     :           +- Scan parquet spark_catalog.imdb_10x.name (11)
               :        :        :        :     +- Project (18)
               :        :        :        :        +- Filter (17)
               :        :        :        :           +- Scan parquet spark_catalog.imdb_10x.title (16)
               :        :        :        +- Project (23)
               :        :        :           +- Filter (22)
               :        :        :              +- Scan parquet spark_catalog.imdb_10x.movie_companies (21)
               :        :        +- Project (29)
               :        :           +- Filter (28)
               :        :              +- Scan parquet spark_catalog.imdb_10x.company_name (27)
               :        +- Filter (34)
               :           +- Scan parquet spark_catalog.imdb_10x.aka_name (33)
               +- Filter (39)
                  +- Scan parquet spark_catalog.imdb_10x.char_name (38)


(1) Scan parquet spark_catalog.imdb_10x.cast_info
Output [5]: [person_id#17, movie_id#18, person_role_id#19, note#20, role_id#22]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/cast_info]
PushedFilters: [IsNotNull(note), EqualTo(note,(voice)), IsNotNull(person_id), IsNotNull(person_role_id), IsNotNull(movie_id), IsNotNull(role_id)]
ReadSchema: struct<person_id:int,movie_id:int,person_role_id:string,note:string,role_id:int>

(2) Filter
Input [5]: [person_id#17, movie_id#18, person_role_id#19, note#20, role_id#22]
Condition : (((((isnotnull(note#20) AND (note#20 = (voice))) AND isnotnull(person_id#17)) AND isnotnull(person_role_id#19)) AND isnotnull(movie_id#18)) AND isnotnull(role_id#22))

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=37196]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=37200]

(11) Scan parquet spark_catalog.imdb_10x.name
Output [3]: [id#540, name#541, gender#544]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/name]
PushedFilters: [IsNotNull(gender), IsNotNull(name), EqualTo(gender,f), StringContains(name,Angel), IsNotNull(id)]
ReadSchema: struct<id:int,name:string,gender:string>

(12) Filter
Input [3]: [id#540, name#541, gender#544]
Condition : ((((isnotnull(gender#544) AND isnotnull(name#541)) AND (gender#544 = f)) AND Contains(name#541, Angel)) AND isnotnull(id#540))

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
Arguments: HashedRelationBroadcastMode(List(cast(input[1, int, true] as bigint)),false), [plan_id=37203]

(16) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#39, title#40, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(17) Filter
Input [3]: [id#39, title#40, production_year#43]
Condition : (((isnotnull(production_year#43) AND (cast(production_year#43 as int) >= 2007)) AND (cast(production_year#43 as int) <= 2010)) AND isnotnull(id#39))

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
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[1, int, true] as bigint), 32) | (cast(input[5, int, true] as bigint) & 4294967295))),false), [plan_id=37206]

(21) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [3]: [movie_id#33, company_id#34, note#36]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(note), Or(StringContains(note,(USA)),StringContains(note,(worldwide))), IsNotNull(movie_id), IsNotNull(company_id)]
ReadSchema: struct<movie_id:int,company_id:int,note:string>

(22) Filter
Input [3]: [movie_id#33, company_id#34, note#36]
Condition : ((((isnotnull(note#36) AND note#36 LIKE %(200%)%) AND (Contains(note#36, (USA)) OR Contains(note#36, (worldwide)))) AND isnotnull(movie_id#33)) AND isnotnull(company_id#34))

(23) Project
Output [2]: [movie_id#33, company_id#34]
Input [3]: [movie_id#33, company_id#34, note#36]

(24) BroadcastHashJoin
Left keys [2]: [movie_id#18, id#39]
Right keys [2]: [movie_id#33, movie_id#33]
Join type: Inner
Join condition: None

(25) Project
Output [6]: [person_id#17, person_role_id#19, id#540, name#541, title#40, company_id#34]
Input [9]: [person_id#17, movie_id#18, person_role_id#19, id#540, name#541, id#39, title#40, movie_id#33, company_id#34]

(26) BroadcastExchange
Input [6]: [person_id#17, person_role_id#19, id#540, name#541, title#40, company_id#34]
Arguments: HashedRelationBroadcastMode(List(cast(input[5, int, true] as bigint)),false), [plan_id=37210]

(27) Scan parquet spark_catalog.imdb_10x.company_name
Output [2]: [id#23, country_code#25]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(country_code), EqualTo(country_code,[us]), IsNotNull(id)]
ReadSchema: struct<id:int,country_code:string>

(28) Filter
Input [2]: [id#23, country_code#25]
Condition : ((isnotnull(country_code#25) AND (country_code#25 = [us])) AND isnotnull(id#23))

(29) Project
Output [1]: [id#23]
Input [2]: [id#23, country_code#25]

(30) BroadcastHashJoin
Left keys [1]: [company_id#34]
Right keys [1]: [id#23]
Join type: Inner
Join condition: None

(31) Project
Output [5]: [person_id#17, person_role_id#19, id#540, name#541, title#40]
Input [7]: [person_id#17, person_role_id#19, id#540, name#541, title#40, company_id#34, id#23]

(32) BroadcastExchange
Input [5]: [person_id#17, person_role_id#19, id#540, name#541, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[2, int, true] as bigint) & 4294967295))),false), [plan_id=37214]

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
Output [4]: [person_role_id#19, name#541, title#40, name#534]
Input [7]: [person_id#17, person_role_id#19, id#540, name#541, title#40, person_id#533, name#534]

(37) BroadcastExchange
Input [4]: [person_role_id#19, name#541, title#40, name#534]
Arguments: HashedRelationBroadcastMode(List(cast(cast(input[0, string, true] as int) as bigint)),false), [plan_id=37218]

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
Output [4]: [name#534, name#10, name#541, title#40]
Input [6]: [person_role_id#19, name#541, title#40, name#534, id#9, name#10]

(42) SortAggregate
Input [4]: [name#534, name#10, name#541, title#40]
Keys: []
Functions [4]: [partial_min(name#534), partial_min(name#10), partial_min(name#541), partial_min(title#40)]
Aggregate Attributes [4]: [min#2553, min#2554, min#2555, min#2556]
Results [4]: [min#2557, min#2558, min#2559, min#2560]

(43) Exchange
Input [4]: [min#2557, min#2558, min#2559, min#2560]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=37223]

(44) SortAggregate
Input [4]: [min#2557, min#2558, min#2559, min#2560]
Keys: []
Functions [4]: [min(name#534), min(name#10), min(name#541), min(title#40)]
Aggregate Attributes [4]: [min(name#534)#2549, min(name#10)#2550, min(name#541)#2551, min(title#40)#2552]
Results [4]: [min(name#534)#2549 AS alternative_name#2540, min(name#10)#2550 AS voiced_character#2541, min(name#541)#2551 AS voicing_actress#2542, min(title#40)#2552 AS american_movie#2543]

(45) AdaptiveSparkPlan
Output [4]: [alternative_name#2540, voiced_character#2541, voicing_actress#2542, american_movie#2543]
Arguments: isFinalPlan=false
Execution Time: 19.534
