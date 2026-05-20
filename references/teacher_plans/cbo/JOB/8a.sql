== Physical Plan ==
AdaptiveSparkPlan (39)
+- SortAggregate (38)
   +- Exchange (37)
      +- SortAggregate (36)
         +- Project (35)
            +- BroadcastHashJoin Inner BuildLeft (34)
               :- BroadcastExchange (31)
               :  +- Project (30)
               :     +- BroadcastHashJoin Inner BuildLeft (29)
               :        :- BroadcastExchange (25)
               :        :  +- Project (24)
               :        :     +- BroadcastHashJoin Inner BuildLeft (23)
               :        :        :- BroadcastExchange (19)
               :        :        :  +- BroadcastHashJoin Inner BuildLeft (18)
               :        :        :     :- BroadcastExchange (15)
               :        :        :     :  +- BroadcastHashJoin Inner BuildLeft (14)
               :        :        :     :     :- BroadcastExchange (10)
               :        :        :     :     :  +- Project (9)
               :        :        :     :     :     +- BroadcastHashJoin Inner BuildRight (8)
               :        :        :     :     :        :- Project (3)
               :        :        :     :     :        :  +- Filter (2)
               :        :        :     :     :        :     +- Scan parquet spark_catalog.imdb_10x.cast_info (1)
               :        :        :     :     :        +- BroadcastExchange (7)
               :        :        :     :     :           +- Project (6)
               :        :        :     :     :              +- Filter (5)
               :        :        :     :     :                 +- Scan parquet spark_catalog.imdb_10x.role_type (4)
               :        :        :     :     +- Project (13)
               :        :        :     :        +- Filter (12)
               :        :        :     :           +- Scan parquet spark_catalog.imdb_10x.name (11)
               :        :        :     +- Filter (17)
               :        :        :        +- Scan parquet spark_catalog.imdb_10x.title (16)
               :        :        +- Project (22)
               :        :           +- Filter (21)
               :        :              +- Scan parquet spark_catalog.imdb_10x.movie_companies (20)
               :        +- Project (28)
               :           +- Filter (27)
               :              +- Scan parquet spark_catalog.imdb_10x.company_name (26)
               +- Filter (33)
                  +- Scan parquet spark_catalog.imdb_10x.aka_name (32)


(1) Scan parquet spark_catalog.imdb_10x.cast_info
Output [4]: [person_id#17, movie_id#18, note#20, role_id#22]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/cast_info]
PushedFilters: [IsNotNull(note), EqualTo(note,(voice: English version)), IsNotNull(person_id), IsNotNull(role_id), IsNotNull(movie_id)]
ReadSchema: struct<person_id:int,movie_id:int,note:string,role_id:int>

(2) Filter
Input [4]: [person_id#17, movie_id#18, note#20, role_id#22]
Condition : ((((isnotnull(note#20) AND (note#20 = (voice: English version))) AND isnotnull(person_id#17)) AND isnotnull(role_id#22)) AND isnotnull(movie_id#18))

(3) Project
Output [3]: [person_id#17, movie_id#18, role_id#22]
Input [4]: [person_id#17, movie_id#18, note#20, role_id#22]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=35755]

(8) BroadcastHashJoin
Left keys [1]: [role_id#22]
Right keys [1]: [id#37]
Join type: Inner
Join condition: None

(9) Project
Output [2]: [person_id#17, movie_id#18]
Input [4]: [person_id#17, movie_id#18, role_id#22, id#37]

(10) BroadcastExchange
Input [2]: [person_id#17, movie_id#18]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=35759]

(11) Scan parquet spark_catalog.imdb_10x.name
Output [2]: [id#540, name#541]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/name]
PushedFilters: [IsNotNull(name), StringContains(name,Yo), Not(StringContains(name,Yu)), IsNotNull(id)]
ReadSchema: struct<id:int,name:string>

(12) Filter
Input [2]: [id#540, name#541]
Condition : (((isnotnull(name#541) AND Contains(name#541, Yo)) AND NOT Contains(name#541, Yu)) AND isnotnull(id#540))

(13) Project
Output [1]: [id#540]
Input [2]: [id#540, name#541]

(14) BroadcastHashJoin
Left keys [1]: [person_id#17]
Right keys [1]: [id#540]
Join type: Inner
Join condition: None

(15) BroadcastExchange
Input [3]: [person_id#17, movie_id#18, id#540]
Arguments: HashedRelationBroadcastMode(List(cast(input[1, int, true] as bigint)),false), [plan_id=35762]

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
Input [5]: [person_id#17, movie_id#18, id#540, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[1, int, true] as bigint), 32) | (cast(input[3, int, false] as bigint) & 4294967295))),false), [plan_id=35765]

(20) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [3]: [movie_id#33, company_id#34, note#36]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(note), StringContains(note,(Japan)), Not(StringContains(note,(USA))), IsNotNull(movie_id), IsNotNull(company_id)]
ReadSchema: struct<movie_id:int,company_id:int,note:string>

(21) Filter
Input [3]: [movie_id#33, company_id#34, note#36]
Condition : ((((isnotnull(note#36) AND Contains(note#36, (Japan))) AND NOT Contains(note#36, (USA))) AND isnotnull(movie_id#33)) AND isnotnull(company_id#34))

(22) Project
Output [2]: [movie_id#33, company_id#34]
Input [3]: [movie_id#33, company_id#34, note#36]

(23) BroadcastHashJoin
Left keys [2]: [movie_id#18, id#39]
Right keys [2]: [movie_id#33, movie_id#33]
Join type: Inner
Join condition: None

(24) Project
Output [4]: [person_id#17, id#540, title#40, company_id#34]
Input [7]: [person_id#17, movie_id#18, id#540, id#39, title#40, movie_id#33, company_id#34]

(25) BroadcastExchange
Input [4]: [person_id#17, id#540, title#40, company_id#34]
Arguments: HashedRelationBroadcastMode(List(cast(input[3, int, true] as bigint)),false), [plan_id=35769]

(26) Scan parquet spark_catalog.imdb_10x.company_name
Output [2]: [id#23, country_code#25]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(country_code), EqualTo(country_code,[jp]), IsNotNull(id)]
ReadSchema: struct<id:int,country_code:string>

(27) Filter
Input [2]: [id#23, country_code#25]
Condition : ((isnotnull(country_code#25) AND (country_code#25 = [jp])) AND isnotnull(id#23))

(28) Project
Output [1]: [id#23]
Input [2]: [id#23, country_code#25]

(29) BroadcastHashJoin
Left keys [1]: [company_id#34]
Right keys [1]: [id#23]
Join type: Inner
Join condition: None

(30) Project
Output [3]: [person_id#17, id#540, title#40]
Input [5]: [person_id#17, id#540, title#40, company_id#34, id#23]

(31) BroadcastExchange
Input [3]: [person_id#17, id#540, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[1, int, true] as bigint) & 4294967295))),false), [plan_id=35773]

(32) Scan parquet spark_catalog.imdb_10x.aka_name
Output [2]: [person_id#533, name#534]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/aka_name]
PushedFilters: [IsNotNull(person_id)]
ReadSchema: struct<person_id:int,name:string>

(33) Filter
Input [2]: [person_id#533, name#534]
Condition : isnotnull(person_id#533)

(34) BroadcastHashJoin
Left keys [2]: [person_id#17, id#540]
Right keys [2]: [person_id#533, person_id#533]
Join type: Inner
Join condition: None

(35) Project
Output [2]: [name#534, title#40]
Input [5]: [person_id#17, id#540, title#40, person_id#533, name#534]

(36) SortAggregate
Input [2]: [name#534, title#40]
Keys: []
Functions [2]: [partial_min(name#534), partial_min(title#40)]
Aggregate Attributes [2]: [min#2460, min#2461]
Results [2]: [min#2462, min#2463]

(37) Exchange
Input [2]: [min#2462, min#2463]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=35778]

(38) SortAggregate
Input [2]: [min#2462, min#2463]
Keys: []
Functions [2]: [min(name#534), min(title#40)]
Aggregate Attributes [2]: [min(name#534)#2458, min(title#40)#2459]
Results [2]: [min(name#534)#2458 AS actress_pseudonym#2451, min(title#40)#2459 AS japanese_movie_dubbed#2452]

(39) AdaptiveSparkPlan
Output [2]: [actress_pseudonym#2451, japanese_movie_dubbed#2452]
Arguments: isFinalPlan=false
Execution Time: 17.964
