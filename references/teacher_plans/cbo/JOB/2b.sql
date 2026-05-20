== Physical Plan ==
AdaptiveSparkPlan (27)
+- SortAggregate (26)
   +- Exchange (25)
      +- SortAggregate (24)
         +- Project (23)
            +- BroadcastHashJoin Inner BuildLeft (22)
               :- BroadcastExchange (18)
               :  +- Project (17)
               :     +- BroadcastHashJoin Inner BuildLeft (16)
               :        :- BroadcastExchange (13)
               :        :  +- BroadcastHashJoin Inner BuildLeft (12)
               :        :     :- BroadcastExchange (9)
               :        :     :  +- Project (8)
               :        :     :     +- BroadcastHashJoin Inner BuildRight (7)
               :        :     :        :- Filter (2)
               :        :     :        :  +- Scan parquet spark_catalog.imdb_10x.movie_keyword (1)
               :        :     :        +- BroadcastExchange (6)
               :        :     :           +- Project (5)
               :        :     :              +- Filter (4)
               :        :     :                 +- Scan parquet spark_catalog.imdb_10x.keyword (3)
               :        :     +- Filter (11)
               :        :        +- Scan parquet spark_catalog.imdb_10x.title (10)
               :        +- Filter (15)
               :           +- Scan parquet spark_catalog.imdb_10x.movie_companies (14)
               +- Project (21)
                  +- Filter (20)
                     +- Scan parquet spark_catalog.imdb_10x.company_name (19)


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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=26459]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=26463]

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
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[1, int, false] as bigint) & 4294967295))),false), [plan_id=26466]

(14) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [2]: [movie_id#33, company_id#34]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(company_id), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,company_id:int>

(15) Filter
Input [2]: [movie_id#33, company_id#34]
Condition : (isnotnull(company_id#34) AND isnotnull(movie_id#33))

(16) BroadcastHashJoin
Left keys [2]: [movie_id#116, id#39]
Right keys [2]: [movie_id#33, movie_id#33]
Join type: Inner
Join condition: None

(17) Project
Output [2]: [title#40, company_id#34]
Input [5]: [movie_id#116, id#39, title#40, movie_id#33, company_id#34]

(18) BroadcastExchange
Input [2]: [title#40, company_id#34]
Arguments: HashedRelationBroadcastMode(List(cast(input[1, int, true] as bigint)),false), [plan_id=26470]

(19) Scan parquet spark_catalog.imdb_10x.company_name
Output [2]: [id#23, country_code#25]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(country_code), EqualTo(country_code,[nl]), IsNotNull(id)]
ReadSchema: struct<id:int,country_code:string>

(20) Filter
Input [2]: [id#23, country_code#25]
Condition : ((isnotnull(country_code#25) AND (country_code#25 = [nl])) AND isnotnull(id#23))

(21) Project
Output [1]: [id#23]
Input [2]: [id#23, country_code#25]

(22) BroadcastHashJoin
Left keys [1]: [company_id#34]
Right keys [1]: [id#23]
Join type: Inner
Join condition: None

(23) Project
Output [1]: [title#40]
Input [3]: [title#40, company_id#34, id#23]

(24) SortAggregate
Input [1]: [title#40]
Keys: []
Functions [1]: [partial_min(title#40)]
Aggregate Attributes [1]: [min#1652]
Results [1]: [min#1653]

(25) Exchange
Input [1]: [min#1653]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=26475]

(26) SortAggregate
Input [1]: [min#1653]
Keys: []
Functions [1]: [min(title#40)]
Aggregate Attributes [1]: [min(title#40)#1651]
Results [1]: [min(title#40)#1651 AS movie_title#1645]

(27) AdaptiveSparkPlan
Output [1]: [movie_title#1645]
Arguments: isFinalPlan=false
Execution Time: 12.967
