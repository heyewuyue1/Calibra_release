== Physical Plan ==
AdaptiveSparkPlan (35)
+- SortAggregate (34)
   +- Exchange (33)
      +- SortAggregate (32)
         +- Project (31)
            +- BroadcastHashJoin Inner BuildLeft (30)
               :- BroadcastExchange (27)
               :  +- Project (26)
               :     +- BroadcastHashJoin Inner BuildLeft (25)
               :        :- BroadcastExchange (22)
               :        :  +- Project (21)
               :        :     +- BroadcastHashJoin Inner BuildLeft (20)
               :        :        :- BroadcastExchange (17)
               :        :        :  +- BroadcastHashJoin Inner BuildLeft (16)
               :        :        :     :- BroadcastExchange (13)
               :        :        :     :  +- BroadcastHashJoin Inner BuildLeft (12)
               :        :        :     :     :- BroadcastExchange (9)
               :        :        :     :     :  +- Project (8)
               :        :        :     :     :     +- BroadcastHashJoin Inner BuildRight (7)
               :        :        :     :     :        :- Filter (2)
               :        :        :     :     :        :  +- Scan parquet spark_catalog.imdb_10x.movie_keyword (1)
               :        :        :     :     :        +- BroadcastExchange (6)
               :        :        :     :     :           +- Project (5)
               :        :        :     :     :              +- Filter (4)
               :        :        :     :     :                 +- Scan parquet spark_catalog.imdb_10x.keyword (3)
               :        :        :     :     +- Filter (11)
               :        :        :     :        +- Scan parquet spark_catalog.imdb_10x.title (10)
               :        :        :     +- Filter (15)
               :        :        :        +- Scan parquet spark_catalog.imdb_10x.movie_companies (14)
               :        :        +- Filter (19)
               :        :           +- Scan parquet spark_catalog.imdb_10x.company_name (18)
               :        +- Filter (24)
               :           +- Scan parquet spark_catalog.imdb_10x.cast_info (23)
               +- Filter (29)
                  +- Scan parquet spark_catalog.imdb_10x.name (28)


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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=9074]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=9078]

(10) Scan parquet spark_catalog.imdb_10x.title
Output [1]: [id#39]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int>

(11) Filter
Input [1]: [id#39]
Condition : isnotnull(id#39)

(12) BroadcastHashJoin
Left keys [1]: [movie_id#116]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(13) BroadcastExchange
Input [2]: [movie_id#116, id#39]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[1, int, false] as bigint) & 4294967295))),false), [plan_id=9081]

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
Input [4]: [movie_id#116, id#39, movie_id#33, company_id#34]
Arguments: HashedRelationBroadcastMode(List(cast(input[3, int, false] as bigint)),false), [plan_id=9084]

(18) Scan parquet spark_catalog.imdb_10x.company_name
Output [1]: [id#23]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int>

(19) Filter
Input [1]: [id#23]
Condition : isnotnull(id#23)

(20) BroadcastHashJoin
Left keys [1]: [company_id#34]
Right keys [1]: [id#23]
Join type: Inner
Join condition: None

(21) Project
Output [3]: [movie_id#116, id#39, movie_id#33]
Input [5]: [movie_id#116, id#39, movie_id#33, company_id#34, id#23]

(22) BroadcastExchange
Input [3]: [movie_id#116, id#39, movie_id#33]
Arguments: HashedRelationBroadcastMode(List(input[2, int, true], input[0, int, true], input[1, int, true]),false), [plan_id=9088]

(23) Scan parquet spark_catalog.imdb_10x.cast_info
Output [2]: [person_id#17, movie_id#18]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/cast_info]
PushedFilters: [IsNotNull(movie_id), IsNotNull(person_id)]
ReadSchema: struct<person_id:int,movie_id:int>

(24) Filter
Input [2]: [person_id#17, movie_id#18]
Condition : (isnotnull(movie_id#18) AND isnotnull(person_id#17))

(25) BroadcastHashJoin
Left keys [3]: [movie_id#33, movie_id#116, id#39]
Right keys [3]: [movie_id#18, movie_id#18, movie_id#18]
Join type: Inner
Join condition: None

(26) Project
Output [1]: [person_id#17]
Input [5]: [movie_id#116, id#39, movie_id#33, person_id#17, movie_id#18]

(27) BroadcastExchange
Input [1]: [person_id#17]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=9092]

(28) Scan parquet spark_catalog.imdb_10x.name
Output [2]: [id#540, name#541]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/name]
PushedFilters: [IsNotNull(name), StringContains(name,Bert), IsNotNull(id)]
ReadSchema: struct<id:int,name:string>

(29) Filter
Input [2]: [id#540, name#541]
Condition : ((isnotnull(name#541) AND Contains(name#541, Bert)) AND isnotnull(id#540))

(30) BroadcastHashJoin
Left keys [1]: [person_id#17]
Right keys [1]: [id#540]
Join type: Inner
Join condition: None

(31) Project
Output [1]: [name#541]
Input [3]: [person_id#17, id#540, name#541]

(32) SortAggregate
Input [1]: [name#541]
Keys: []
Functions [1]: [partial_min(name#541)]
Aggregate Attributes [1]: [min#664]
Results [1]: [min#665]

(33) Exchange
Input [1]: [min#665]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=9097]

(34) SortAggregate
Input [1]: [min#665]
Keys: []
Functions [1]: [min(name#541)]
Aggregate Attributes [1]: [min(name#541)#663]
Results [1]: [min(name#541)#663 AS member_in_charnamed_movie#657]

(35) AdaptiveSparkPlan
Output [1]: [member_in_charnamed_movie#657]
Arguments: isFinalPlan=false
Execution Time: 61.337
