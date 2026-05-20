== Physical Plan ==
AdaptiveSparkPlan (32)
+- SortAggregate (31)
   +- Exchange (30)
      +- SortAggregate (29)
         +- Project (28)
            +- BroadcastHashJoin Inner BuildLeft (27)
               :- BroadcastExchange (24)
               :  +- Project (23)
               :     +- BroadcastHashJoin Inner BuildRight (22)
               :        :- Project (18)
               :        :  +- BroadcastHashJoin Inner BuildLeft (17)
               :        :     :- BroadcastExchange (14)
               :        :     :  +- Project (13)
               :        :     :     +- BroadcastHashJoin Inner BuildLeft (12)
               :        :     :        :- BroadcastExchange (9)
               :        :     :        :  +- Project (8)
               :        :     :        :     +- BroadcastHashJoin Inner BuildLeft (7)
               :        :     :        :        :- BroadcastExchange (4)
               :        :     :        :        :  +- Project (3)
               :        :     :        :        :     +- Filter (2)
               :        :     :        :        :        +- Scan parquet spark_catalog.imdb_10x.keyword (1)
               :        :     :        :        +- Filter (6)
               :        :     :        :           +- Scan parquet spark_catalog.imdb_10x.movie_keyword (5)
               :        :     :        +- Filter (11)
               :        :     :           +- Scan parquet spark_catalog.imdb_10x.title (10)
               :        :     +- Filter (16)
               :        :        +- Scan parquet spark_catalog.imdb_10x.movie_link (15)
               :        +- BroadcastExchange (21)
               :           +- Filter (20)
               :              +- Scan parquet spark_catalog.imdb_10x.link_type (19)
               +- Filter (26)
                  +- Scan parquet spark_catalog.imdb_10x.title (25)


(1) Scan parquet spark_catalog.imdb_10x.keyword
Output [2]: [id#110, keyword#111]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/keyword]
PushedFilters: [IsNotNull(keyword), EqualTo(keyword,character-name-in-title), IsNotNull(id)]
ReadSchema: struct<id:int,keyword:string>

(2) Filter
Input [2]: [id#110, keyword#111]
Condition : ((isnotnull(keyword#111) AND (keyword#111 = character-name-in-title)) AND isnotnull(id#110))

(3) Project
Output [1]: [id#110]
Input [2]: [id#110, keyword#111]

(4) BroadcastExchange
Input [1]: [id#110]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=29934]

(5) Scan parquet spark_catalog.imdb_10x.movie_keyword
Output [2]: [movie_id#116, keyword_id#117]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_keyword]
PushedFilters: [IsNotNull(keyword_id), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,keyword_id:int>

(6) Filter
Input [2]: [movie_id#116, keyword_id#117]
Condition : (isnotnull(keyword_id#117) AND isnotnull(movie_id#116))

(7) BroadcastHashJoin
Left keys [1]: [id#110]
Right keys [1]: [keyword_id#117]
Join type: Inner
Join condition: None

(8) Project
Output [1]: [movie_id#116]
Input [3]: [id#110, movie_id#116, keyword_id#117]

(9) BroadcastExchange
Input [1]: [movie_id#116]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=29938]

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

(13) Project
Output [2]: [id#39, title#40]
Input [3]: [movie_id#116, id#39, title#40]

(14) BroadcastExchange
Input [2]: [id#39, title#40]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=29942]

(15) Scan parquet spark_catalog.imdb_10x.movie_link
Output [3]: [movie_id#119, linked_movie_id#120, link_type_id#121]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_link]
PushedFilters: [IsNotNull(movie_id), IsNotNull(link_type_id), IsNotNull(linked_movie_id)]
ReadSchema: struct<movie_id:int,linked_movie_id:int,link_type_id:int>

(16) Filter
Input [3]: [movie_id#119, linked_movie_id#120, link_type_id#121]
Condition : ((isnotnull(movie_id#119) AND isnotnull(link_type_id#121)) AND isnotnull(linked_movie_id#120))

(17) BroadcastHashJoin
Left keys [1]: [id#39]
Right keys [1]: [movie_id#119]
Join type: Inner
Join condition: None

(18) Project
Output [3]: [title#40, linked_movie_id#120, link_type_id#121]
Input [5]: [id#39, title#40, movie_id#119, linked_movie_id#120, link_type_id#121]

(19) Scan parquet spark_catalog.imdb_10x.link_type
Output [2]: [id#113, link#114]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/link_type]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int,link:string>

(20) Filter
Input [2]: [id#113, link#114]
Condition : isnotnull(id#113)

(21) BroadcastExchange
Input [2]: [id#113, link#114]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, false] as bigint)),false), [plan_id=29946]

(22) BroadcastHashJoin
Left keys [1]: [link_type_id#121]
Right keys [1]: [id#113]
Join type: Inner
Join condition: None

(23) Project
Output [3]: [title#40, linked_movie_id#120, link#114]
Input [5]: [title#40, linked_movie_id#120, link_type_id#121, id#113, link#114]

(24) BroadcastExchange
Input [3]: [title#40, linked_movie_id#120, link#114]
Arguments: HashedRelationBroadcastMode(List(cast(input[1, int, true] as bigint)),false), [plan_id=29950]

(25) Scan parquet spark_catalog.imdb_10x.title
Output [2]: [id#1903, title#1904]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int,title:string>

(26) Filter
Input [2]: [id#1903, title#1904]
Condition : isnotnull(id#1903)

(27) BroadcastHashJoin
Left keys [1]: [linked_movie_id#120]
Right keys [1]: [id#1903]
Join type: Inner
Join condition: None

(28) Project
Output [3]: [link#114, title#40, title#1904]
Input [5]: [title#40, linked_movie_id#120, link#114, id#1903, title#1904]

(29) SortAggregate
Input [3]: [link#114, title#40, title#1904]
Keys: []
Functions [3]: [partial_min(link#114), partial_min(title#40), partial_min(title#1904)]
Aggregate Attributes [3]: [min#1919, min#1920, min#1921]
Results [3]: [min#1922, min#1923, min#1924]

(30) Exchange
Input [3]: [min#1922, min#1923, min#1924]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=29955]

(31) SortAggregate
Input [3]: [min#1922, min#1923, min#1924]
Keys: []
Functions [3]: [min(link#114), min(title#40), min(title#1904)]
Aggregate Attributes [3]: [min(link#114)#1915, min(title#40)#1916, min(title#1904)#1917]
Results [3]: [min(link#114)#1915 AS link_type#1895, min(title#40)#1916 AS first_movie#1896, min(title#1904)#1917 AS second_movie#1897]

(32) AdaptiveSparkPlan
Output [3]: [link_type#1895, first_movie#1896, second_movie#1897]
Arguments: isFinalPlan=false
Execution Time: 13.461
