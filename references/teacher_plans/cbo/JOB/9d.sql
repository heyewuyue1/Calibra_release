== Physical Plan ==
AdaptiveSparkPlan (43)
+- SortAggregate (42)
   +- Exchange (41)
      +- SortAggregate (40)
         +- Project (39)
            +- BroadcastHashJoin Inner BuildLeft (38)
               :- BroadcastExchange (35)
               :  +- Project (34)
               :     +- BroadcastHashJoin Inner BuildLeft (33)
               :        :- BroadcastExchange (30)
               :        :  +- Project (29)
               :        :     +- BroadcastHashJoin Inner BuildRight (28)
               :        :        :- Project (23)
               :        :        :  +- BroadcastHashJoin Inner BuildLeft (22)
               :        :        :     :- BroadcastExchange (19)
               :        :        :     :  +- BroadcastHashJoin Inner BuildLeft (18)
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
               :        :        :     :     +- Filter (17)
               :        :        :     :        +- Scan parquet spark_catalog.imdb_10x.title (16)
               :        :        :     +- Filter (21)
               :        :        :        +- Scan parquet spark_catalog.imdb_10x.movie_companies (20)
               :        :        +- BroadcastExchange (27)
               :        :           +- Project (26)
               :        :              +- Filter (25)
               :        :                 +- Scan parquet spark_catalog.imdb_10x.company_name (24)
               :        +- Filter (32)
               :           +- Scan parquet spark_catalog.imdb_10x.aka_name (31)
               +- Filter (37)
                  +- Scan parquet spark_catalog.imdb_10x.char_name (36)


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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=37818]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=37822]

(11) Scan parquet spark_catalog.imdb_10x.name
Output [3]: [id#540, name#541, gender#544]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/name]
PushedFilters: [IsNotNull(gender), EqualTo(gender,f), IsNotNull(id)]
ReadSchema: struct<id:int,name:string,gender:string>

(12) Filter
Input [3]: [id#540, name#541, gender#544]
Condition : ((isnotnull(gender#544) AND (gender#544 = f)) AND isnotnull(id#540))

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
Arguments: HashedRelationBroadcastMode(List(cast(input[1, int, true] as bigint)),false), [plan_id=37825]

(16) Scan parquet spark_catalog.imdb_10x.title
Output [2]: [id#39, title#40]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int,title:string>

(17) Filter
Input [2]: [id#39, title#40]
Condition : isnotnull(id#39)

(18) BroadcastHashJoin
Left keys [1]: [movie_id#18]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(19) BroadcastExchange
Input [7]: [person_id#17, movie_id#18, person_role_id#19, id#540, name#541, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[1, int, true] as bigint), 32) | (cast(input[5, int, false] as bigint) & 4294967295))),false), [plan_id=37828]

(20) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [2]: [movie_id#33, company_id#34]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(movie_id), IsNotNull(company_id)]
ReadSchema: struct<movie_id:int,company_id:int>

(21) Filter
Input [2]: [movie_id#33, company_id#34]
Condition : (isnotnull(movie_id#33) AND isnotnull(company_id#34))

(22) BroadcastHashJoin
Left keys [2]: [movie_id#18, id#39]
Right keys [2]: [movie_id#33, movie_id#33]
Join type: Inner
Join condition: None

(23) Project
Output [6]: [person_id#17, person_role_id#19, id#540, name#541, title#40, company_id#34]
Input [9]: [person_id#17, movie_id#18, person_role_id#19, id#540, name#541, id#39, title#40, movie_id#33, company_id#34]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=37832]

(28) BroadcastHashJoin
Left keys [1]: [company_id#34]
Right keys [1]: [id#23]
Join type: Inner
Join condition: None

(29) Project
Output [5]: [person_id#17, person_role_id#19, id#540, name#541, title#40]
Input [7]: [person_id#17, person_role_id#19, id#540, name#541, title#40, company_id#34, id#23]

(30) BroadcastExchange
Input [5]: [person_id#17, person_role_id#19, id#540, name#541, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[2, int, true] as bigint) & 4294967295))),false), [plan_id=37836]

(31) Scan parquet spark_catalog.imdb_10x.aka_name
Output [2]: [person_id#533, name#534]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/aka_name]
PushedFilters: [IsNotNull(person_id)]
ReadSchema: struct<person_id:int,name:string>

(32) Filter
Input [2]: [person_id#533, name#534]
Condition : isnotnull(person_id#533)

(33) BroadcastHashJoin
Left keys [2]: [person_id#17, id#540]
Right keys [2]: [person_id#533, person_id#533]
Join type: Inner
Join condition: None

(34) Project
Output [4]: [person_role_id#19, name#541, title#40, name#534]
Input [7]: [person_id#17, person_role_id#19, id#540, name#541, title#40, person_id#533, name#534]

(35) BroadcastExchange
Input [4]: [person_role_id#19, name#541, title#40, name#534]
Arguments: HashedRelationBroadcastMode(List(cast(cast(input[0, string, true] as int) as bigint)),false), [plan_id=37840]

(36) Scan parquet spark_catalog.imdb_10x.char_name
Output [2]: [id#9, name#10]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/char_name]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int,name:string>

(37) Filter
Input [2]: [id#9, name#10]
Condition : isnotnull(id#9)

(38) BroadcastHashJoin
Left keys [1]: [cast(person_role_id#19 as int)]
Right keys [1]: [id#9]
Join type: Inner
Join condition: None

(39) Project
Output [4]: [name#534, name#10, name#541, title#40]
Input [6]: [person_role_id#19, name#541, title#40, name#534, id#9, name#10]

(40) SortAggregate
Input [4]: [name#534, name#10, name#541, title#40]
Keys: []
Functions [4]: [partial_min(name#534), partial_min(name#10), partial_min(name#541), partial_min(title#40)]
Aggregate Attributes [4]: [min#2603, min#2604, min#2605, min#2606]
Results [4]: [min#2607, min#2608, min#2609, min#2610]

(41) Exchange
Input [4]: [min#2607, min#2608, min#2609, min#2610]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=37845]

(42) SortAggregate
Input [4]: [min#2607, min#2608, min#2609, min#2610]
Keys: []
Functions [4]: [min(name#534), min(name#10), min(name#541), min(title#40)]
Aggregate Attributes [4]: [min(name#534)#2599, min(name#10)#2600, min(name#541)#2601, min(title#40)#2602]
Results [4]: [min(name#534)#2599 AS alternative_name#2590, min(name#10)#2600 AS voiced_char_name#2591, min(name#541)#2601 AS voicing_actress#2592, min(title#40)#2602 AS american_movie#2593]

(43) AdaptiveSparkPlan
Output [4]: [alternative_name#2590, voiced_char_name#2591, voicing_actress#2592, american_movie#2593]
Arguments: isFinalPlan=false
Execution Time: 36.357
