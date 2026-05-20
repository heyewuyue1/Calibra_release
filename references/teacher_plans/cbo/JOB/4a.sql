== Physical Plan ==
AdaptiveSparkPlan (37)
+- SortAggregate (36)
   +- Exchange (35)
      +- SortAggregate (34)
         +- Project (33)
            +- SortMergeJoin Inner (32)
               :- Sort (26)
               :  +- Exchange (25)
               :     +- Project (24)
               :        +- SortMergeJoin Inner (23)
               :           :- Sort (18)
               :           :  +- Exchange (17)
               :           :     +- SortMergeJoin Inner (16)
               :           :        :- Sort (10)
               :           :        :  +- Exchange (9)
               :           :        :     +- Project (8)
               :           :        :        +- BroadcastHashJoin Inner BuildLeft (7)
               :           :        :           :- BroadcastExchange (4)
               :           :        :           :  +- Project (3)
               :           :        :           :     +- Filter (2)
               :           :        :           :        +- Scan parquet spark_catalog.imdb_10x.info_type (1)
               :           :        :           +- Filter (6)
               :           :        :              +- Scan parquet spark_catalog.imdb_10x.movie_info_idx (5)
               :           :        +- Sort (15)
               :           :           +- Exchange (14)
               :           :              +- Project (13)
               :           :                 +- Filter (12)
               :           :                    +- Scan parquet spark_catalog.imdb_10x.title (11)
               :           +- Sort (22)
               :              +- Exchange (21)
               :                 +- Filter (20)
               :                    +- Scan parquet spark_catalog.imdb_10x.movie_keyword (19)
               +- Sort (31)
                  +- Exchange (30)
                     +- Project (29)
                        +- Filter (28)
                           +- Scan parquet spark_catalog.imdb_10x.keyword (27)


(1) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#210, info#211]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,rating), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(2) Filter
Input [2]: [id#210, info#211]
Condition : ((isnotnull(info#211) AND (info#211 = rating)) AND isnotnull(id#210))

(3) Project
Output [1]: [id#210]
Input [2]: [id#210, info#211]

(4) BroadcastExchange
Input [1]: [id#210]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=32279]

(5) Scan parquet spark_catalog.imdb_10x.movie_info_idx
Output [3]: [movie_id#218, info_type_id#219, info#220]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info_idx]
PushedFilters: [IsNotNull(info), GreaterThan(info,5.0), IsNotNull(info_type_id), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(6) Filter
Input [3]: [movie_id#218, info_type_id#219, info#220]
Condition : (((isnotnull(info#220) AND (info#220 > 5.0)) AND isnotnull(info_type_id#219)) AND isnotnull(movie_id#218))

(7) BroadcastHashJoin
Left keys [1]: [id#210]
Right keys [1]: [info_type_id#219]
Join type: Inner
Join condition: None

(8) Project
Output [2]: [movie_id#218, info#220]
Input [4]: [id#210, movie_id#218, info_type_id#219, info#220]

(9) Exchange
Input [2]: [movie_id#218, info#220]
Arguments: hashpartitioning(movie_id#218, 200), ENSURE_REQUIREMENTS, [plan_id=32284]

(10) Sort
Input [2]: [movie_id#218, info#220]
Arguments: [movie_id#218 ASC NULLS FIRST], false, 0

(11) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#39, title#40, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(12) Filter
Input [3]: [id#39, title#40, production_year#43]
Condition : ((isnotnull(production_year#43) AND (cast(production_year#43 as int) > 2005)) AND isnotnull(id#39))

(13) Project
Output [2]: [id#39, title#40]
Input [3]: [id#39, title#40, production_year#43]

(14) Exchange
Input [2]: [id#39, title#40]
Arguments: hashpartitioning(id#39, 200), ENSURE_REQUIREMENTS, [plan_id=32285]

(15) Sort
Input [2]: [id#39, title#40]
Arguments: [id#39 ASC NULLS FIRST], false, 0

(16) SortMergeJoin
Left keys [1]: [movie_id#218]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(17) Exchange
Input [4]: [movie_id#218, info#220, id#39, title#40]
Arguments: hashpartitioning(movie_id#218, movie_id#218, 200), ENSURE_REQUIREMENTS, [plan_id=32292]

(18) Sort
Input [4]: [movie_id#218, info#220, id#39, title#40]
Arguments: [movie_id#218 ASC NULLS FIRST, id#39 ASC NULLS FIRST], false, 0

(19) Scan parquet spark_catalog.imdb_10x.movie_keyword
Output [2]: [movie_id#116, keyword_id#117]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_keyword]
PushedFilters: [IsNotNull(movie_id), IsNotNull(keyword_id)]
ReadSchema: struct<movie_id:int,keyword_id:int>

(20) Filter
Input [2]: [movie_id#116, keyword_id#117]
Condition : (isnotnull(movie_id#116) AND isnotnull(keyword_id#117))

(21) Exchange
Input [2]: [movie_id#116, keyword_id#117]
Arguments: hashpartitioning(movie_id#116, movie_id#116, 200), ENSURE_REQUIREMENTS, [plan_id=32291]

(22) Sort
Input [2]: [movie_id#116, keyword_id#117]
Arguments: [movie_id#116 ASC NULLS FIRST, movie_id#116 ASC NULLS FIRST], false, 0

(23) SortMergeJoin
Left keys [2]: [movie_id#218, id#39]
Right keys [2]: [movie_id#116, movie_id#116]
Join type: Inner
Join condition: None

(24) Project
Output [3]: [info#220, title#40, keyword_id#117]
Input [6]: [movie_id#218, info#220, id#39, title#40, movie_id#116, keyword_id#117]

(25) Exchange
Input [3]: [info#220, title#40, keyword_id#117]
Arguments: hashpartitioning(keyword_id#117, 200), ENSURE_REQUIREMENTS, [plan_id=32299]

(26) Sort
Input [3]: [info#220, title#40, keyword_id#117]
Arguments: [keyword_id#117 ASC NULLS FIRST], false, 0

(27) Scan parquet spark_catalog.imdb_10x.keyword
Output [2]: [id#110, keyword#111]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/keyword]
PushedFilters: [IsNotNull(keyword), StringContains(keyword,sequel), IsNotNull(id)]
ReadSchema: struct<id:int,keyword:string>

(28) Filter
Input [2]: [id#110, keyword#111]
Condition : ((isnotnull(keyword#111) AND Contains(keyword#111, sequel)) AND isnotnull(id#110))

(29) Project
Output [1]: [id#110]
Input [2]: [id#110, keyword#111]

(30) Exchange
Input [1]: [id#110]
Arguments: hashpartitioning(id#110, 200), ENSURE_REQUIREMENTS, [plan_id=32300]

(31) Sort
Input [1]: [id#110]
Arguments: [id#110 ASC NULLS FIRST], false, 0

(32) SortMergeJoin
Left keys [1]: [keyword_id#117]
Right keys [1]: [id#110]
Join type: Inner
Join condition: None

(33) Project
Output [2]: [info#220, title#40]
Input [4]: [info#220, title#40, keyword_id#117, id#110]

(34) SortAggregate
Input [2]: [info#220, title#40]
Keys: []
Functions [2]: [partial_min(info#220), partial_min(title#40)]
Aggregate Attributes [2]: [min#2193, min#2194]
Results [2]: [min#2195, min#2196]

(35) Exchange
Input [2]: [min#2195, min#2196]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=32307]

(36) SortAggregate
Input [2]: [min#2195, min#2196]
Keys: []
Functions [2]: [min(info#220), min(title#40)]
Aggregate Attributes [2]: [min(info#220)#2191, min(title#40)#2192]
Results [2]: [min(info#220)#2191 AS rating#2184, min(title#40)#2192 AS movie_title#2185]

(37) AdaptiveSparkPlan
Output [2]: [rating#2184, movie_title#2185]
Arguments: isFinalPlan=false
Execution Time: 16.795
