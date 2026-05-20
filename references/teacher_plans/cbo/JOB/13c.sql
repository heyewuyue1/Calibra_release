== Physical Plan ==
AdaptiveSparkPlan (52)
+- SortAggregate (51)
   +- Exchange (50)
      +- SortAggregate (49)
         +- Project (48)
            +- SortMergeJoin Inner (47)
               :- Sort (36)
               :  +- Exchange (35)
               :     +- Project (34)
               :        +- BroadcastHashJoin Inner BuildRight (33)
               :           :- BroadcastHashJoin Inner BuildLeft (28)
               :           :  :- BroadcastExchange (25)
               :           :  :  +- Project (24)
               :           :  :     +- BroadcastHashJoin Inner BuildRight (23)
               :           :  :        :- BroadcastHashJoin Inner BuildLeft (18)
               :           :  :        :  :- BroadcastExchange (15)
               :           :  :        :  :  +- Project (14)
               :           :  :        :  :     +- BroadcastHashJoin Inner BuildRight (13)
               :           :  :        :  :        :- Project (8)
               :           :  :        :  :        :  +- BroadcastHashJoin Inner BuildLeft (7)
               :           :  :        :  :        :     :- BroadcastExchange (4)
               :           :  :        :  :        :     :  +- Project (3)
               :           :  :        :  :        :     :     +- Filter (2)
               :           :  :        :  :        :     :        +- Scan parquet spark_catalog.imdb_10x.company_name (1)
               :           :  :        :  :        :     +- Filter (6)
               :           :  :        :  :        :        +- Scan parquet spark_catalog.imdb_10x.movie_companies (5)
               :           :  :        :  :        +- BroadcastExchange (12)
               :           :  :        :  :           +- Project (11)
               :           :  :        :  :              +- Filter (10)
               :           :  :        :  :                 +- Scan parquet spark_catalog.imdb_10x.company_type (9)
               :           :  :        :  +- Filter (17)
               :           :  :        :     +- Scan parquet spark_catalog.imdb_10x.title (16)
               :           :  :        +- BroadcastExchange (22)
               :           :  :           +- Project (21)
               :           :  :              +- Filter (20)
               :           :  :                 +- Scan parquet spark_catalog.imdb_10x.kind_type (19)
               :           :  +- Filter (27)
               :           :     +- Scan parquet spark_catalog.imdb_10x.movie_info_idx (26)
               :           +- BroadcastExchange (32)
               :              +- Project (31)
               :                 +- Filter (30)
               :                    +- Scan parquet spark_catalog.imdb_10x.info_type (29)
               +- Sort (46)
                  +- Exchange (45)
                     +- Project (44)
                        +- BroadcastHashJoin Inner BuildRight (43)
                           :- Filter (38)
                           :  +- Scan parquet spark_catalog.imdb_10x.movie_info (37)
                           +- BroadcastExchange (42)
                              +- Project (41)
                                 +- Filter (40)
                                    +- Scan parquet spark_catalog.imdb_10x.info_type (39)


(1) Scan parquet spark_catalog.imdb_10x.company_name
Output [3]: [id#23, name#24, country_code#25]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(country_code), EqualTo(country_code,[us]), IsNotNull(id)]
ReadSchema: struct<id:int,name:string,country_code:string>

(2) Filter
Input [3]: [id#23, name#24, country_code#25]
Condition : ((isnotnull(country_code#25) AND (country_code#25 = [us])) AND isnotnull(id#23))

(3) Project
Output [2]: [id#23, name#24]
Input [3]: [id#23, name#24, country_code#25]

(4) BroadcastExchange
Input [2]: [id#23, name#24]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=4061]

(5) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [3]: [movie_id#33, company_id#34, company_type_id#35]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(company_id), IsNotNull(company_type_id), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,company_id:int,company_type_id:int>

(6) Filter
Input [3]: [movie_id#33, company_id#34, company_type_id#35]
Condition : ((isnotnull(company_id#34) AND isnotnull(company_type_id#35)) AND isnotnull(movie_id#33))

(7) BroadcastHashJoin
Left keys [1]: [id#23]
Right keys [1]: [company_id#34]
Join type: Inner
Join condition: None

(8) Project
Output [3]: [name#24, movie_id#33, company_type_id#35]
Input [5]: [id#23, name#24, movie_id#33, company_id#34, company_type_id#35]

(9) Scan parquet spark_catalog.imdb_10x.company_type
Output [2]: [id#30, kind#31]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_type]
PushedFilters: [IsNotNull(kind), EqualTo(kind,production companies), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(10) Filter
Input [2]: [id#30, kind#31]
Condition : ((isnotnull(kind#31) AND (kind#31 = production companies)) AND isnotnull(id#30))

(11) Project
Output [1]: [id#30]
Input [2]: [id#30, kind#31]

(12) BroadcastExchange
Input [1]: [id#30]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=4065]

(13) BroadcastHashJoin
Left keys [1]: [company_type_id#35]
Right keys [1]: [id#30]
Join type: Inner
Join condition: None

(14) Project
Output [2]: [name#24, movie_id#33]
Input [4]: [name#24, movie_id#33, company_type_id#35, id#30]

(15) BroadcastExchange
Input [2]: [name#24, movie_id#33]
Arguments: HashedRelationBroadcastMode(List(cast(input[1, int, true] as bigint)),false), [plan_id=4069]

(16) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#39, title#40, kind_id#42]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(title), Not(EqualTo(title,)), Or(StringStartsWith(title,Champion),StringStartsWith(title,Loser)), IsNotNull(id), IsNotNull(kind_id)]
ReadSchema: struct<id:int,title:string,kind_id:int>

(17) Filter
Input [3]: [id#39, title#40, kind_id#42]
Condition : ((((isnotnull(title#40) AND NOT (title#40 = )) AND (StartsWith(title#40, Champion) OR StartsWith(title#40, Loser))) AND isnotnull(id#39)) AND isnotnull(kind_id#42))

(18) BroadcastHashJoin
Left keys [1]: [movie_id#33]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(19) Scan parquet spark_catalog.imdb_10x.kind_type
Output [2]: [id#293, kind#294]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/kind_type]
PushedFilters: [IsNotNull(kind), EqualTo(kind,movie), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(20) Filter
Input [2]: [id#293, kind#294]
Condition : ((isnotnull(kind#294) AND (kind#294 = movie)) AND isnotnull(id#293))

(21) Project
Output [1]: [id#293]
Input [2]: [id#293, kind#294]

(22) BroadcastExchange
Input [1]: [id#293]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=4072]

(23) BroadcastHashJoin
Left keys [1]: [kind_id#42]
Right keys [1]: [id#293]
Join type: Inner
Join condition: None

(24) Project
Output [4]: [name#24, movie_id#33, id#39, title#40]
Input [6]: [name#24, movie_id#33, id#39, title#40, kind_id#42, id#293]

(25) BroadcastExchange
Input [4]: [name#24, movie_id#33, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[1, int, true] as bigint), 32) | (cast(input[2, int, true] as bigint) & 4294967295))),false), [plan_id=4076]

(26) Scan parquet spark_catalog.imdb_10x.movie_info_idx
Output [3]: [movie_id#218, info_type_id#219, info#220]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info_idx]
PushedFilters: [IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(27) Filter
Input [3]: [movie_id#218, info_type_id#219, info#220]
Condition : (isnotnull(movie_id#218) AND isnotnull(info_type_id#219))

(28) BroadcastHashJoin
Left keys [2]: [movie_id#33, id#39]
Right keys [2]: [movie_id#218, movie_id#218]
Join type: Inner
Join condition: None

(29) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#210, info#211]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,rating), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(30) Filter
Input [2]: [id#210, info#211]
Condition : ((isnotnull(info#211) AND (info#211 = rating)) AND isnotnull(id#210))

(31) Project
Output [1]: [id#210]
Input [2]: [id#210, info#211]

(32) BroadcastExchange
Input [1]: [id#210]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=4079]

(33) BroadcastHashJoin
Left keys [1]: [info_type_id#219]
Right keys [1]: [id#210]
Join type: Inner
Join condition: None

(34) Project
Output [6]: [name#24, movie_id#33, id#39, title#40, movie_id#218, info#220]
Input [8]: [name#24, movie_id#33, id#39, title#40, movie_id#218, info_type_id#219, info#220, id#210]

(35) Exchange
Input [6]: [name#24, movie_id#33, id#39, title#40, movie_id#218, info#220]
Arguments: hashpartitioning(movie_id#33, movie_id#218, id#39, 200), ENSURE_REQUIREMENTS, [plan_id=4087]

(36) Sort
Input [6]: [name#24, movie_id#33, id#39, title#40, movie_id#218, info#220]
Arguments: [movie_id#33 ASC NULLS FIRST, movie_id#218 ASC NULLS FIRST, id#39 ASC NULLS FIRST], false, 0

(37) Scan parquet spark_catalog.imdb_10x.movie_info
Output [2]: [movie_id#213, info_type_id#214]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int>

(38) Filter
Input [2]: [movie_id#213, info_type_id#214]
Condition : (isnotnull(movie_id#213) AND isnotnull(info_type_id#214))

(39) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#344, info#345]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,release dates), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(40) Filter
Input [2]: [id#344, info#345]
Condition : ((isnotnull(info#345) AND (info#345 = release dates)) AND isnotnull(id#344))

(41) Project
Output [1]: [id#344]
Input [2]: [id#344, info#345]

(42) BroadcastExchange
Input [1]: [id#344]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=4082]

(43) BroadcastHashJoin
Left keys [1]: [info_type_id#214]
Right keys [1]: [id#344]
Join type: Inner
Join condition: None

(44) Project
Output [1]: [movie_id#213]
Input [3]: [movie_id#213, info_type_id#214, id#344]

(45) Exchange
Input [1]: [movie_id#213]
Arguments: hashpartitioning(movie_id#213, movie_id#213, movie_id#213, 200), ENSURE_REQUIREMENTS, [plan_id=4088]

(46) Sort
Input [1]: [movie_id#213]
Arguments: [movie_id#213 ASC NULLS FIRST, movie_id#213 ASC NULLS FIRST, movie_id#213 ASC NULLS FIRST], false, 0

(47) SortMergeJoin
Left keys [3]: [movie_id#33, movie_id#218, id#39]
Right keys [3]: [movie_id#213, movie_id#213, movie_id#213]
Join type: Inner
Join condition: None

(48) Project
Output [3]: [name#24, info#220, title#40]
Input [7]: [name#24, movie_id#33, id#39, title#40, movie_id#218, info#220, movie_id#213]

(49) SortAggregate
Input [3]: [name#24, info#220, title#40]
Keys: []
Functions [3]: [partial_min(name#24), partial_min(info#220), partial_min(title#40)]
Aggregate Attributes [3]: [min#350, min#351, min#352]
Results [3]: [min#353, min#354, min#355]

(50) Exchange
Input [3]: [min#353, min#354, min#355]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=4095]

(51) SortAggregate
Input [3]: [min#353, min#354, min#355]
Keys: []
Functions [3]: [min(name#24), min(info#220), min(title#40)]
Aggregate Attributes [3]: [min(name#24)#346, min(info#220)#347, min(title#40)#348]
Results [3]: [min(name#24)#346 AS producing_company#336, min(info#220)#347 AS rating#337, min(title#40)#348 AS movie_about_winning#338]

(52) AdaptiveSparkPlan
Output [3]: [producing_company#336, rating#337, movie_about_winning#338]
Arguments: isFinalPlan=false
Execution Time: 24.31
