== Physical Plan ==
AdaptiveSparkPlan (40)
+- SortAggregate (39)
   +- Exchange (38)
      +- SortAggregate (37)
         +- Project (36)
            +- BroadcastHashJoin Inner BuildLeft (35)
               :- BroadcastExchange (32)
               :  +- BroadcastHashJoin Inner BuildLeft (31)
               :     :- BroadcastExchange (28)
               :     :  +- Project (27)
               :     :     +- BroadcastHashJoin Inner BuildLeft (26)
               :     :        :- BroadcastExchange (23)
               :     :        :  +- Project (22)
               :     :        :     +- BroadcastHashJoin Inner BuildLeft (21)
               :     :        :        :- BroadcastExchange (17)
               :     :        :        :  +- BroadcastHashJoin Inner BuildLeft (16)
               :     :        :        :     :- BroadcastExchange (13)
               :     :        :        :     :  +- BroadcastHashJoin Inner BuildLeft (12)
               :     :        :        :     :     :- BroadcastExchange (9)
               :     :        :        :     :     :  +- Project (8)
               :     :        :        :     :     :     +- BroadcastHashJoin Inner BuildRight (7)
               :     :        :        :     :     :        :- Filter (2)
               :     :        :        :     :     :        :  +- Scan parquet spark_catalog.imdb_10x.movie_keyword (1)
               :     :        :        :     :     :        +- BroadcastExchange (6)
               :     :        :        :     :     :           +- Project (5)
               :     :        :        :     :     :              +- Filter (4)
               :     :        :        :     :     :                 +- Scan parquet spark_catalog.imdb_10x.keyword (3)
               :     :        :        :     :     +- Filter (11)
               :     :        :        :     :        +- Scan parquet spark_catalog.imdb_10x.title (10)
               :     :        :        :     +- Filter (15)
               :     :        :        :        +- Scan parquet spark_catalog.imdb_10x.movie_companies (14)
               :     :        :        +- Project (20)
               :     :        :           +- Filter (19)
               :     :        :              +- Scan parquet spark_catalog.imdb_10x.company_name (18)
               :     :        +- Filter (25)
               :     :           +- Scan parquet spark_catalog.imdb_10x.cast_info (24)
               :     +- Filter (30)
               :        +- Scan parquet spark_catalog.imdb_10x.name (29)
               +- Filter (34)
                  +- Scan parquet spark_catalog.imdb_10x.aka_name (33)


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
PushedFilters: [IsNotNull(keyword), EqualTo(keyword,character-name-in-title), IsNotNull(id)]
ReadSchema: struct<id:int,keyword:string>

(4) Filter
Input [2]: [id#110, keyword#111]
Condition : ((isnotnull(keyword#111) AND (keyword#111 = character-name-in-title)) AND isnotnull(id#110))

(5) Project
Output [1]: [id#110]
Input [2]: [id#110, keyword#111]

(6) BroadcastExchange
Input [1]: [id#110]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=7359]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=7363]

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
Left keys [1]: [movie_id#116]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(13) BroadcastExchange
Input [3]: [movie_id#116, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[1, int, false] as bigint) & 4294967295))),false), [plan_id=7366]

(14) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [2]: [movie_id#33, company_id#34]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(movie_id), IsNotNull(company_id)]
ReadSchema: struct<movie_id:int,company_id:int>

(15) Filter
Input [2]: [movie_id#33, company_id#34]
Condition : (isnotnull(movie_id#33) AND isnotnull(company_id#34))

(16) BroadcastHashJoin
Left keys [2]: [movie_id#116, id#39]
Right keys [2]: [movie_id#33, movie_id#33]
Join type: Inner
Join condition: None

(17) BroadcastExchange
Input [5]: [movie_id#116, id#39, title#40, movie_id#33, company_id#34]
Arguments: HashedRelationBroadcastMode(List(cast(input[4, int, false] as bigint)),false), [plan_id=7369]

(18) Scan parquet spark_catalog.imdb_10x.company_name
Output [2]: [id#23, country_code#25]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(country_code), EqualTo(country_code,[us]), IsNotNull(id)]
ReadSchema: struct<id:int,country_code:string>

(19) Filter
Input [2]: [id#23, country_code#25]
Condition : ((isnotnull(country_code#25) AND (country_code#25 = [us])) AND isnotnull(id#23))

(20) Project
Output [1]: [id#23]
Input [2]: [id#23, country_code#25]

(21) BroadcastHashJoin
Left keys [1]: [company_id#34]
Right keys [1]: [id#23]
Join type: Inner
Join condition: None

(22) Project
Output [4]: [movie_id#116, id#39, title#40, movie_id#33]
Input [6]: [movie_id#116, id#39, title#40, movie_id#33, company_id#34, id#23]

(23) BroadcastExchange
Input [4]: [movie_id#116, id#39, title#40, movie_id#33]
Arguments: HashedRelationBroadcastMode(List(input[3, int, true], input[0, int, true], input[1, int, true]),false), [plan_id=7373]

(24) Scan parquet spark_catalog.imdb_10x.cast_info
Output [2]: [person_id#17, movie_id#18]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/cast_info]
PushedFilters: [IsNotNull(person_id), IsNotNull(movie_id)]
ReadSchema: struct<person_id:int,movie_id:int>

(25) Filter
Input [2]: [person_id#17, movie_id#18]
Condition : (isnotnull(person_id#17) AND isnotnull(movie_id#18))

(26) BroadcastHashJoin
Left keys [3]: [movie_id#33, movie_id#116, id#39]
Right keys [3]: [movie_id#18, movie_id#18, movie_id#18]
Join type: Inner
Join condition: None

(27) Project
Output [2]: [title#40, person_id#17]
Input [6]: [movie_id#116, id#39, title#40, movie_id#33, person_id#17, movie_id#18]

(28) BroadcastExchange
Input [2]: [title#40, person_id#17]
Arguments: HashedRelationBroadcastMode(List(cast(input[1, int, true] as bigint)),false), [plan_id=7377]

(29) Scan parquet spark_catalog.imdb_10x.name
Output [1]: [id#540]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/name]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int>

(30) Filter
Input [1]: [id#540]
Condition : isnotnull(id#540)

(31) BroadcastHashJoin
Left keys [1]: [person_id#17]
Right keys [1]: [id#540]
Join type: Inner
Join condition: None

(32) BroadcastExchange
Input [3]: [title#40, person_id#17, id#540]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[1, int, true] as bigint), 32) | (cast(input[2, int, false] as bigint) & 4294967295))),false), [plan_id=7380]

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
Input [5]: [title#40, person_id#17, id#540, person_id#533, name#534]

(37) SortAggregate
Input [2]: [name#534, title#40]
Keys: []
Functions [2]: [partial_min(name#534), partial_min(title#40)]
Aggregate Attributes [2]: [min#570, min#571]
Results [2]: [min#572, min#573]

(38) Exchange
Input [2]: [min#572, min#573]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=7385]

(39) SortAggregate
Input [2]: [min#572, min#573]
Keys: []
Functions [2]: [min(name#534), min(title#40)]
Aggregate Attributes [2]: [min(name#534)#568, min(title#40)#569]
Results [2]: [min(name#534)#568 AS cool_actor_pseudonym#561, min(title#40)#569 AS series_named_after_char#562]

(40) AdaptiveSparkPlan
Output [2]: [cool_actor_pseudonym#561, series_named_after_char#562]
Arguments: isFinalPlan=false
Execution Time: 74.69
