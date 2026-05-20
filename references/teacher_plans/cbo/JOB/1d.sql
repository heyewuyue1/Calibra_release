== Physical Plan ==
AdaptiveSparkPlan (33)
+- SortAggregate (32)
   +- Exchange (31)
      +- SortAggregate (30)
         +- Project (29)
            +- BroadcastHashJoin Inner BuildRight (28)
               :- Project (23)
               :  +- SortMergeJoin Inner (22)
               :     :- Sort (17)
               :     :  +- Exchange (16)
               :     :     +- SortMergeJoin Inner (15)
               :     :        :- Sort (10)
               :     :        :  +- Exchange (9)
               :     :        :     +- Project (8)
               :     :        :        +- BroadcastHashJoin Inner BuildRight (7)
               :     :        :           :- Filter (2)
               :     :        :           :  +- Scan parquet spark_catalog.imdb_10x.movie_info_idx (1)
               :     :        :           +- BroadcastExchange (6)
               :     :        :              +- Project (5)
               :     :        :                 +- Filter (4)
               :     :        :                    +- Scan parquet spark_catalog.imdb_10x.info_type (3)
               :     :        +- Sort (14)
               :     :           +- Exchange (13)
               :     :              +- Filter (12)
               :     :                 +- Scan parquet spark_catalog.imdb_10x.title (11)
               :     +- Sort (21)
               :        +- Exchange (20)
               :           +- Filter (19)
               :              +- Scan parquet spark_catalog.imdb_10x.movie_companies (18)
               +- BroadcastExchange (27)
                  +- Project (26)
                     +- Filter (25)
                        +- Scan parquet spark_catalog.imdb_10x.company_type (24)


(1) Scan parquet spark_catalog.imdb_10x.movie_info_idx
Output [2]: [movie_id#218, info_type_id#219]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info_idx]
PushedFilters: [IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int>

(2) Filter
Input [2]: [movie_id#218, info_type_id#219]
Condition : (isnotnull(movie_id#218) AND isnotnull(info_type_id#219))

(3) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#210, info#211]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,bottom 10 rank), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(4) Filter
Input [2]: [id#210, info#211]
Condition : ((isnotnull(info#211) AND (info#211 = bottom 10 rank)) AND isnotnull(id#210))

(5) Project
Output [1]: [id#210]
Input [2]: [id#210, info#211]

(6) BroadcastExchange
Input [1]: [id#210]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=12803]

(7) BroadcastHashJoin
Left keys [1]: [info_type_id#219]
Right keys [1]: [id#210]
Join type: Inner
Join condition: None

(8) Project
Output [1]: [movie_id#218]
Input [3]: [movie_id#218, info_type_id#219, id#210]

(9) Exchange
Input [1]: [movie_id#218]
Arguments: hashpartitioning(movie_id#218, 200), ENSURE_REQUIREMENTS, [plan_id=12808]

(10) Sort
Input [1]: [movie_id#218]
Arguments: [movie_id#218 ASC NULLS FIRST], false, 0

(11) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#39, title#40, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(12) Filter
Input [3]: [id#39, title#40, production_year#43]
Condition : ((isnotnull(production_year#43) AND (cast(production_year#43 as int) > 2000)) AND isnotnull(id#39))

(13) Exchange
Input [3]: [id#39, title#40, production_year#43]
Arguments: hashpartitioning(id#39, 200), ENSURE_REQUIREMENTS, [plan_id=12809]

(14) Sort
Input [3]: [id#39, title#40, production_year#43]
Arguments: [id#39 ASC NULLS FIRST], false, 0

(15) SortMergeJoin
Left keys [1]: [movie_id#218]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(16) Exchange
Input [4]: [movie_id#218, id#39, title#40, production_year#43]
Arguments: hashpartitioning(movie_id#218, movie_id#218, 200), ENSURE_REQUIREMENTS, [plan_id=12816]

(17) Sort
Input [4]: [movie_id#218, id#39, title#40, production_year#43]
Arguments: [movie_id#218 ASC NULLS FIRST, id#39 ASC NULLS FIRST], false, 0

(18) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [3]: [movie_id#33, company_type_id#35, note#36]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(note), Not(StringContains(note,(as Metro-Goldwyn-Mayer Pictures))), IsNotNull(company_type_id), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,company_type_id:int,note:string>

(19) Filter
Input [3]: [movie_id#33, company_type_id#35, note#36]
Condition : (((isnotnull(note#36) AND NOT Contains(note#36, (as Metro-Goldwyn-Mayer Pictures))) AND isnotnull(company_type_id#35)) AND isnotnull(movie_id#33))

(20) Exchange
Input [3]: [movie_id#33, company_type_id#35, note#36]
Arguments: hashpartitioning(movie_id#33, movie_id#33, 200), ENSURE_REQUIREMENTS, [plan_id=12815]

(21) Sort
Input [3]: [movie_id#33, company_type_id#35, note#36]
Arguments: [movie_id#33 ASC NULLS FIRST, movie_id#33 ASC NULLS FIRST], false, 0

(22) SortMergeJoin
Left keys [2]: [movie_id#218, id#39]
Right keys [2]: [movie_id#33, movie_id#33]
Join type: Inner
Join condition: None

(23) Project
Output [4]: [title#40, production_year#43, company_type_id#35, note#36]
Input [7]: [movie_id#218, id#39, title#40, production_year#43, movie_id#33, company_type_id#35, note#36]

(24) Scan parquet spark_catalog.imdb_10x.company_type
Output [2]: [id#30, kind#31]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_type]
PushedFilters: [IsNotNull(kind), EqualTo(kind,production companies), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(25) Filter
Input [2]: [id#30, kind#31]
Condition : ((isnotnull(kind#31) AND (kind#31 = production companies)) AND isnotnull(id#30))

(26) Project
Output [1]: [id#30]
Input [2]: [id#30, kind#31]

(27) BroadcastExchange
Input [1]: [id#30]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=12822]

(28) BroadcastHashJoin
Left keys [1]: [company_type_id#35]
Right keys [1]: [id#30]
Join type: Inner
Join condition: None

(29) Project
Output [3]: [note#36, title#40, production_year#43]
Input [5]: [title#40, production_year#43, company_type_id#35, note#36, id#30]

(30) SortAggregate
Input [3]: [note#36, title#40, production_year#43]
Keys: []
Functions [3]: [partial_min(note#36), partial_min(title#40), partial_min(production_year#43)]
Aggregate Attributes [3]: [min#910, min#911, min#912]
Results [3]: [min#913, min#914, min#915]

(31) Exchange
Input [3]: [min#913, min#914, min#915]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=12827]

(32) SortAggregate
Input [3]: [min#913, min#914, min#915]
Keys: []
Functions [3]: [min(note#36), min(title#40), min(production_year#43)]
Aggregate Attributes [3]: [min(note#36)#907, min(title#40)#908, min(production_year#43)#909]
Results [3]: [min(note#36)#907 AS production_note#899, min(title#40)#908 AS movie_title#900, min(production_year#43)#909 AS movie_year#901]

(33) AdaptiveSparkPlan
Output [3]: [production_note#899, movie_title#900, movie_year#901]
Arguments: isFinalPlan=false
Execution Time: 13.963
