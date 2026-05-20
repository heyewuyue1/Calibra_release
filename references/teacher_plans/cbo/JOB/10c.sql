== Physical Plan ==
AdaptiveSparkPlan (41)
+- SortAggregate (40)
   +- Exchange (39)
      +- SortAggregate (38)
         +- Project (37)
            +- SortMergeJoin Inner (36)
               :- Sort (31)
               :  +- Exchange (30)
               :     +- Project (29)
               :        +- BroadcastHashJoin Inner BuildRight (28)
               :           :- Project (24)
               :           :  +- BroadcastHashJoin Inner BuildLeft (23)
               :           :     :- BroadcastExchange (19)
               :           :     :  +- BroadcastHashJoin Inner BuildLeft (18)
               :           :     :     :- BroadcastExchange (14)
               :           :     :     :  +- Project (13)
               :           :     :     :     +- BroadcastHashJoin Inner BuildRight (12)
               :           :     :     :        :- Project (8)
               :           :     :     :        :  +- BroadcastHashJoin Inner BuildRight (7)
               :           :     :     :        :     :- Filter (2)
               :           :     :     :        :     :  +- Scan parquet spark_catalog.imdb_10x.movie_companies (1)
               :           :     :     :        :     +- BroadcastExchange (6)
               :           :     :     :        :        +- Project (5)
               :           :     :     :        :           +- Filter (4)
               :           :     :     :        :              +- Scan parquet spark_catalog.imdb_10x.company_name (3)
               :           :     :     :        +- BroadcastExchange (11)
               :           :     :     :           +- Filter (10)
               :           :     :     :              +- Scan parquet spark_catalog.imdb_10x.company_type (9)
               :           :     :     +- Project (17)
               :           :     :        +- Filter (16)
               :           :     :           +- Scan parquet spark_catalog.imdb_10x.title (15)
               :           :     +- Project (22)
               :           :        +- Filter (21)
               :           :           +- Scan parquet spark_catalog.imdb_10x.cast_info (20)
               :           +- BroadcastExchange (27)
               :              +- Filter (26)
               :                 +- Scan parquet spark_catalog.imdb_10x.role_type (25)
               +- Sort (35)
                  +- Exchange (34)
                     +- Filter (33)
                        +- Scan parquet spark_catalog.imdb_10x.char_name (32)


(1) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [3]: [movie_id#33, company_id#34, company_type_id#35]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(movie_id), IsNotNull(company_id), IsNotNull(company_type_id)]
ReadSchema: struct<movie_id:int,company_id:int,company_type_id:int>

(2) Filter
Input [3]: [movie_id#33, company_id#34, company_type_id#35]
Condition : ((isnotnull(movie_id#33) AND isnotnull(company_id#34)) AND isnotnull(company_type_id#35))

(3) Scan parquet spark_catalog.imdb_10x.company_name
Output [2]: [id#23, country_code#25]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(country_code), EqualTo(country_code,[us]), IsNotNull(id)]
ReadSchema: struct<id:int,country_code:string>

(4) Filter
Input [2]: [id#23, country_code#25]
Condition : ((isnotnull(country_code#25) AND (country_code#25 = [us])) AND isnotnull(id#23))

(5) Project
Output [1]: [id#23]
Input [2]: [id#23, country_code#25]

(6) BroadcastExchange
Input [1]: [id#23]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=826]

(7) BroadcastHashJoin
Left keys [1]: [company_id#34]
Right keys [1]: [id#23]
Join type: Inner
Join condition: None

(8) Project
Output [2]: [movie_id#33, company_type_id#35]
Input [4]: [movie_id#33, company_id#34, company_type_id#35, id#23]

(9) Scan parquet spark_catalog.imdb_10x.company_type
Output [1]: [id#30]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_type]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int>

(10) Filter
Input [1]: [id#30]
Condition : isnotnull(id#30)

(11) BroadcastExchange
Input [1]: [id#30]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, false] as bigint)),false), [plan_id=830]

(12) BroadcastHashJoin
Left keys [1]: [company_type_id#35]
Right keys [1]: [id#30]
Join type: Inner
Join condition: None

(13) Project
Output [1]: [movie_id#33]
Input [3]: [movie_id#33, company_type_id#35, id#30]

(14) BroadcastExchange
Input [1]: [movie_id#33]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=834]

(15) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#39, title#40, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(16) Filter
Input [3]: [id#39, title#40, production_year#43]
Condition : ((isnotnull(production_year#43) AND (cast(production_year#43 as int) > 1990)) AND isnotnull(id#39))

(17) Project
Output [2]: [id#39, title#40]
Input [3]: [id#39, title#40, production_year#43]

(18) BroadcastHashJoin
Left keys [1]: [movie_id#33]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(19) BroadcastExchange
Input [3]: [movie_id#33, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[1, int, true] as bigint) & 4294967295))),false), [plan_id=837]

(20) Scan parquet spark_catalog.imdb_10x.cast_info
Output [4]: [movie_id#18, person_role_id#19, note#20, role_id#22]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/cast_info]
PushedFilters: [IsNotNull(note), StringContains(note,(producer)), IsNotNull(person_role_id), IsNotNull(movie_id), IsNotNull(role_id)]
ReadSchema: struct<movie_id:int,person_role_id:string,note:string,role_id:int>

(21) Filter
Input [4]: [movie_id#18, person_role_id#19, note#20, role_id#22]
Condition : ((((isnotnull(note#20) AND Contains(note#20, (producer))) AND isnotnull(person_role_id#19)) AND isnotnull(movie_id#18)) AND isnotnull(role_id#22))

(22) Project
Output [3]: [movie_id#18, person_role_id#19, role_id#22]
Input [4]: [movie_id#18, person_role_id#19, note#20, role_id#22]

(23) BroadcastHashJoin
Left keys [2]: [movie_id#33, id#39]
Right keys [2]: [movie_id#18, movie_id#18]
Join type: Inner
Join condition: None

(24) Project
Output [3]: [title#40, person_role_id#19, role_id#22]
Input [6]: [movie_id#33, id#39, title#40, movie_id#18, person_role_id#19, role_id#22]

(25) Scan parquet spark_catalog.imdb_10x.role_type
Output [1]: [id#37]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/role_type]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int>

(26) Filter
Input [1]: [id#37]
Condition : isnotnull(id#37)

(27) BroadcastExchange
Input [1]: [id#37]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, false] as bigint)),false), [plan_id=841]

(28) BroadcastHashJoin
Left keys [1]: [role_id#22]
Right keys [1]: [id#37]
Join type: Inner
Join condition: None

(29) Project
Output [2]: [title#40, person_role_id#19]
Input [4]: [title#40, person_role_id#19, role_id#22, id#37]

(30) Exchange
Input [2]: [title#40, person_role_id#19]
Arguments: hashpartitioning(cast(person_role_id#19 as int), 200), ENSURE_REQUIREMENTS, [plan_id=846]

(31) Sort
Input [2]: [title#40, person_role_id#19]
Arguments: [cast(person_role_id#19 as int) ASC NULLS FIRST], false, 0

(32) Scan parquet spark_catalog.imdb_10x.char_name
Output [2]: [id#9, name#10]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/char_name]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int,name:string>

(33) Filter
Input [2]: [id#9, name#10]
Condition : isnotnull(id#9)

(34) Exchange
Input [2]: [id#9, name#10]
Arguments: hashpartitioning(id#9, 200), ENSURE_REQUIREMENTS, [plan_id=847]

(35) Sort
Input [2]: [id#9, name#10]
Arguments: [id#9 ASC NULLS FIRST], false, 0

(36) SortMergeJoin
Left keys [1]: [cast(person_role_id#19 as int)]
Right keys [1]: [id#9]
Join type: Inner
Join condition: None

(37) Project
Output [2]: [name#10, title#40]
Input [4]: [title#40, person_role_id#19, id#9, name#10]

(38) SortAggregate
Input [2]: [name#10, title#40]
Keys: []
Functions [2]: [partial_min(name#10), partial_min(title#40)]
Aggregate Attributes [2]: [min#94, min#95]
Results [2]: [min#96, min#97]

(39) Exchange
Input [2]: [min#96, min#97]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=854]

(40) SortAggregate
Input [2]: [min#96, min#97]
Keys: []
Functions [2]: [min(name#10), min(title#40)]
Aggregate Attributes [2]: [min(name#10)#92, min(title#40)#93]
Results [2]: [min(name#10)#92 AS character#85, min(title#40)#93 AS movie_with_american_producer#86]

(41) AdaptiveSparkPlan
Output [2]: [character#85, movie_with_american_producer#86]
Arguments: isFinalPlan=false
Execution Time: 30.739
