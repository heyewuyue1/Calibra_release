== Physical Plan ==
AdaptiveSparkPlan (40)
+- SortAggregate (39)
   +- Exchange (38)
      +- SortAggregate (37)
         +- Project (36)
            +- BroadcastHashJoin Inner BuildLeft (35)
               :- BroadcastExchange (32)
               :  +- Project (31)
               :     +- BroadcastHashJoin Inner BuildLeft (30)
               :        :- BroadcastExchange (26)
               :        :  +- Project (25)
               :        :     +- BroadcastHashJoin Inner BuildLeft (24)
               :        :        :- BroadcastExchange (20)
               :        :        :  +- BroadcastHashJoin Inner BuildLeft (19)
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
               :        :        :     +- Project (18)
               :        :        :        +- Filter (17)
               :        :        :           +- Scan parquet spark_catalog.imdb_10x.title (16)
               :        :        +- Project (23)
               :        :           +- Filter (22)
               :        :              +- Scan parquet spark_catalog.imdb_10x.movie_companies (21)
               :        +- Project (29)
               :           +- Filter (28)
               :              +- Scan parquet spark_catalog.imdb_10x.company_name (27)
               +- Filter (34)
                  +- Scan parquet spark_catalog.imdb_10x.aka_name (33)


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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=36022]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=36026]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[1, int, true] as bigint)),false), [plan_id=36029]

(16) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#39, title#40, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), Or(StringStartsWith(title,One Piece),StringStartsWith(title,Dragon Ball Z)), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(17) Filter
Input [3]: [id#39, title#40, production_year#43]
Condition : ((((isnotnull(production_year#43) AND (cast(production_year#43 as int) >= 2006)) AND (cast(production_year#43 as int) <= 2007)) AND (StartsWith(title#40, One Piece) OR StartsWith(title#40, Dragon Ball Z))) AND isnotnull(id#39))

(18) Project
Output [2]: [id#39, title#40]
Input [3]: [id#39, title#40, production_year#43]

(19) BroadcastHashJoin
Left keys [1]: [movie_id#18]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(20) BroadcastExchange
Input [5]: [person_id#17, movie_id#18, id#540, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[1, int, true] as bigint), 32) | (cast(input[3, int, true] as bigint) & 4294967295))),false), [plan_id=36032]

(21) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [3]: [movie_id#33, company_id#34, note#36]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(note), StringContains(note,(Japan)), Not(StringContains(note,(USA))), Or(StringContains(note,(2006)),StringContains(note,(2007))), IsNotNull(movie_id), IsNotNull(company_id)]
ReadSchema: struct<movie_id:int,company_id:int,note:string>

(22) Filter
Input [3]: [movie_id#33, company_id#34, note#36]
Condition : (((((isnotnull(note#36) AND Contains(note#36, (Japan))) AND NOT Contains(note#36, (USA))) AND (Contains(note#36, (2006)) OR Contains(note#36, (2007)))) AND isnotnull(movie_id#33)) AND isnotnull(company_id#34))

(23) Project
Output [2]: [movie_id#33, company_id#34]
Input [3]: [movie_id#33, company_id#34, note#36]

(24) BroadcastHashJoin
Left keys [2]: [movie_id#18, id#39]
Right keys [2]: [movie_id#33, movie_id#33]
Join type: Inner
Join condition: None

(25) Project
Output [4]: [person_id#17, id#540, title#40, company_id#34]
Input [7]: [person_id#17, movie_id#18, id#540, id#39, title#40, movie_id#33, company_id#34]

(26) BroadcastExchange
Input [4]: [person_id#17, id#540, title#40, company_id#34]
Arguments: HashedRelationBroadcastMode(List(cast(input[3, int, true] as bigint)),false), [plan_id=36036]

(27) Scan parquet spark_catalog.imdb_10x.company_name
Output [2]: [id#23, country_code#25]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(country_code), EqualTo(country_code,[jp]), IsNotNull(id)]
ReadSchema: struct<id:int,country_code:string>

(28) Filter
Input [2]: [id#23, country_code#25]
Condition : ((isnotnull(country_code#25) AND (country_code#25 = [jp])) AND isnotnull(id#23))

(29) Project
Output [1]: [id#23]
Input [2]: [id#23, country_code#25]

(30) BroadcastHashJoin
Left keys [1]: [company_id#34]
Right keys [1]: [id#23]
Join type: Inner
Join condition: None

(31) Project
Output [3]: [person_id#17, id#540, title#40]
Input [5]: [person_id#17, id#540, title#40, company_id#34, id#23]

(32) BroadcastExchange
Input [3]: [person_id#17, id#540, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[1, int, true] as bigint) & 4294967295))),false), [plan_id=36040]

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
Output [2]: [name#534, title#40]
Input [5]: [person_id#17, id#540, title#40, person_id#533, name#534]

(37) SortAggregate
Input [2]: [name#534, title#40]
Keys: []
Functions [2]: [partial_min(name#534), partial_min(title#40)]
Aggregate Attributes [2]: [min#2477, min#2478]
Results [2]: [min#2479, min#2480]

(38) Exchange
Input [2]: [min#2479, min#2480]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=36045]

(39) SortAggregate
Input [2]: [min#2479, min#2480]
Keys: []
Functions [2]: [min(name#534), min(title#40)]
Aggregate Attributes [2]: [min(name#534)#2475, min(title#40)#2476]
Results [2]: [min(name#534)#2475 AS acress_pseudonym#2468, min(title#40)#2476 AS japanese_anime_movie#2469]

(40) AdaptiveSparkPlan
Output [2]: [acress_pseudonym#2468, japanese_anime_movie#2469]
Arguments: isFinalPlan=false
Execution Time: 18.919
