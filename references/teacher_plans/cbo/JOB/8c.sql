== Physical Plan ==
AdaptiveSparkPlan (42)
+- SortAggregate (41)
   +- Exchange (40)
      +- SortAggregate (39)
         +- Project (38)
            +- SortMergeJoin Inner (37)
               :- Sort (32)
               :  +- Exchange (31)
               :     +- SortMergeJoin Inner (30)
               :        :- Sort (25)
               :        :  +- Exchange (24)
               :        :     +- Project (23)
               :        :        +- BroadcastHashJoin Inner BuildRight (22)
               :        :           :- Project (17)
               :        :           :  +- BroadcastHashJoin Inner BuildLeft (16)
               :        :           :     :- BroadcastExchange (13)
               :        :           :     :  +- BroadcastHashJoin Inner BuildLeft (12)
               :        :           :     :     :- BroadcastExchange (9)
               :        :           :     :     :  +- Project (8)
               :        :           :     :     :     +- BroadcastHashJoin Inner BuildRight (7)
               :        :           :     :     :        :- Filter (2)
               :        :           :     :     :        :  +- Scan parquet spark_catalog.imdb_10x.movie_companies (1)
               :        :           :     :     :        +- BroadcastExchange (6)
               :        :           :     :     :           +- Project (5)
               :        :           :     :     :              +- Filter (4)
               :        :           :     :     :                 +- Scan parquet spark_catalog.imdb_10x.company_name (3)
               :        :           :     :     +- Filter (11)
               :        :           :     :        +- Scan parquet spark_catalog.imdb_10x.title (10)
               :        :           :     +- Filter (15)
               :        :           :        +- Scan parquet spark_catalog.imdb_10x.cast_info (14)
               :        :           +- BroadcastExchange (21)
               :        :              +- Project (20)
               :        :                 +- Filter (19)
               :        :                    +- Scan parquet spark_catalog.imdb_10x.role_type (18)
               :        +- Sort (29)
               :           +- Exchange (28)
               :              +- Filter (27)
               :                 +- Scan parquet spark_catalog.imdb_10x.name (26)
               +- Sort (36)
                  +- Exchange (35)
                     +- Filter (34)
                        +- Scan parquet spark_catalog.imdb_10x.aka_name (33)


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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=36297]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=36301]

(10) Scan parquet spark_catalog.imdb_10x.title
Output [2]: [id#39, title#40]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int,title:string>

(11) Filter
Input [2]: [id#39, title#40]
Condition : isnotnull(id#39)

(12) BroadcastHashJoin
Left keys [1]: [movie_id#33]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(13) BroadcastExchange
Input [3]: [movie_id#33, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[1, int, false] as bigint) & 4294967295))),false), [plan_id=36304]

(14) Scan parquet spark_catalog.imdb_10x.cast_info
Output [3]: [person_id#17, movie_id#18, role_id#22]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/cast_info]
PushedFilters: [IsNotNull(person_id), IsNotNull(role_id), IsNotNull(movie_id)]
ReadSchema: struct<person_id:int,movie_id:int,role_id:int>

(15) Filter
Input [3]: [person_id#17, movie_id#18, role_id#22]
Condition : ((isnotnull(person_id#17) AND isnotnull(role_id#22)) AND isnotnull(movie_id#18))

(16) BroadcastHashJoin
Left keys [2]: [movie_id#33, id#39]
Right keys [2]: [movie_id#18, movie_id#18]
Join type: Inner
Join condition: None

(17) Project
Output [3]: [title#40, person_id#17, role_id#22]
Input [6]: [movie_id#33, id#39, title#40, person_id#17, movie_id#18, role_id#22]

(18) Scan parquet spark_catalog.imdb_10x.role_type
Output [2]: [id#37, role#38]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/role_type]
PushedFilters: [IsNotNull(role), EqualTo(role,writer), IsNotNull(id)]
ReadSchema: struct<id:int,role:string>

(19) Filter
Input [2]: [id#37, role#38]
Condition : ((isnotnull(role#38) AND (role#38 = writer)) AND isnotnull(id#37))

(20) Project
Output [1]: [id#37]
Input [2]: [id#37, role#38]

(21) BroadcastExchange
Input [1]: [id#37]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=36308]

(22) BroadcastHashJoin
Left keys [1]: [role_id#22]
Right keys [1]: [id#37]
Join type: Inner
Join condition: None

(23) Project
Output [2]: [title#40, person_id#17]
Input [4]: [title#40, person_id#17, role_id#22, id#37]

(24) Exchange
Input [2]: [title#40, person_id#17]
Arguments: hashpartitioning(person_id#17, 200), ENSURE_REQUIREMENTS, [plan_id=36313]

(25) Sort
Input [2]: [title#40, person_id#17]
Arguments: [person_id#17 ASC NULLS FIRST], false, 0

(26) Scan parquet spark_catalog.imdb_10x.name
Output [1]: [id#540]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/name]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int>

(27) Filter
Input [1]: [id#540]
Condition : isnotnull(id#540)

(28) Exchange
Input [1]: [id#540]
Arguments: hashpartitioning(id#540, 200), ENSURE_REQUIREMENTS, [plan_id=36314]

(29) Sort
Input [1]: [id#540]
Arguments: [id#540 ASC NULLS FIRST], false, 0

(30) SortMergeJoin
Left keys [1]: [person_id#17]
Right keys [1]: [id#540]
Join type: Inner
Join condition: None

(31) Exchange
Input [3]: [title#40, person_id#17, id#540]
Arguments: hashpartitioning(person_id#17, person_id#17, 200), ENSURE_REQUIREMENTS, [plan_id=36321]

(32) Sort
Input [3]: [title#40, person_id#17, id#540]
Arguments: [person_id#17 ASC NULLS FIRST, id#540 ASC NULLS FIRST], false, 0

(33) Scan parquet spark_catalog.imdb_10x.aka_name
Output [2]: [person_id#533, name#534]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/aka_name]
PushedFilters: [IsNotNull(person_id)]
ReadSchema: struct<person_id:int,name:string>

(34) Filter
Input [2]: [person_id#533, name#534]
Condition : isnotnull(person_id#533)

(35) Exchange
Input [2]: [person_id#533, name#534]
Arguments: hashpartitioning(person_id#533, person_id#533, 200), ENSURE_REQUIREMENTS, [plan_id=36320]

(36) Sort
Input [2]: [person_id#533, name#534]
Arguments: [person_id#533 ASC NULLS FIRST, person_id#533 ASC NULLS FIRST], false, 0

(37) SortMergeJoin
Left keys [2]: [person_id#17, id#540]
Right keys [2]: [person_id#533, person_id#533]
Join type: Inner
Join condition: None

(38) Project
Output [2]: [name#534, title#40]
Input [5]: [title#40, person_id#17, id#540, person_id#533, name#534]

(39) SortAggregate
Input [2]: [name#534, title#40]
Keys: []
Functions [2]: [partial_min(name#534), partial_min(title#40)]
Aggregate Attributes [2]: [min#2494, min#2495]
Results [2]: [min#2496, min#2497]

(40) Exchange
Input [2]: [min#2496, min#2497]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=36328]

(41) SortAggregate
Input [2]: [min#2496, min#2497]
Keys: []
Functions [2]: [min(name#534), min(title#40)]
Aggregate Attributes [2]: [min(name#534)#2492, min(title#40)#2493]
Results [2]: [min(name#534)#2492 AS writer_pseudo_name#2485, min(title#40)#2493 AS movie_title#2486]

(42) AdaptiveSparkPlan
Output [2]: [writer_pseudo_name#2485, movie_title#2486]
Arguments: isFinalPlan=false
Execution Time: 52.191
