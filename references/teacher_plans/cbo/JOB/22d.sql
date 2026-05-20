== Physical Plan ==
AdaptiveSparkPlan (60)
+- SortAggregate (59)
   +- Exchange (58)
      +- SortAggregate (57)
         +- Project (56)
            +- BroadcastHashJoin Inner BuildLeft (55)
               :- BroadcastExchange (36)
               :  +- Project (35)
               :     +- BroadcastHashJoin Inner BuildLeft (34)
               :        :- BroadcastExchange (30)
               :        :  +- Project (29)
               :        :     +- BroadcastHashJoin Inner BuildRight (28)
               :        :        :- BroadcastHashJoin Inner BuildLeft (24)
               :        :        :  :- BroadcastExchange (21)
               :        :        :  :  +- Project (20)
               :        :        :  :     +- BroadcastHashJoin Inner BuildRight (19)
               :        :        :  :        :- BroadcastHashJoin Inner BuildLeft (14)
               :        :        :  :        :  :- BroadcastExchange (10)
               :        :        :  :        :  :  +- Project (9)
               :        :        :  :        :  :     +- BroadcastHashJoin Inner BuildRight (8)
               :        :        :  :        :  :        :- Project (3)
               :        :        :  :        :  :        :  +- Filter (2)
               :        :        :  :        :  :        :     +- Scan parquet spark_catalog.imdb_10x.movie_info (1)
               :        :        :  :        :  :        +- BroadcastExchange (7)
               :        :        :  :        :  :           +- Project (6)
               :        :        :  :        :  :              +- Filter (5)
               :        :        :  :        :  :                 +- Scan parquet spark_catalog.imdb_10x.info_type (4)
               :        :        :  :        :  +- Project (13)
               :        :        :  :        :     +- Filter (12)
               :        :        :  :        :        +- Scan parquet spark_catalog.imdb_10x.title (11)
               :        :        :  :        +- BroadcastExchange (18)
               :        :        :  :           +- Project (17)
               :        :        :  :              +- Filter (16)
               :        :        :  :                 +- Scan parquet spark_catalog.imdb_10x.kind_type (15)
               :        :        :  +- Filter (23)
               :        :        :     +- Scan parquet spark_catalog.imdb_10x.movie_companies (22)
               :        :        +- BroadcastExchange (27)
               :        :           +- Filter (26)
               :        :              +- Scan parquet spark_catalog.imdb_10x.company_type (25)
               :        +- Project (33)
               :           +- Filter (32)
               :              +- Scan parquet spark_catalog.imdb_10x.company_name (31)
               +- Project (54)
                  +- BroadcastHashJoin Inner BuildRight (53)
                     :- BroadcastHashJoin Inner BuildLeft (48)
                     :  :- BroadcastExchange (45)
                     :  :  +- Project (44)
                     :  :     +- BroadcastHashJoin Inner BuildRight (43)
                     :  :        :- Filter (38)
                     :  :        :  +- Scan parquet spark_catalog.imdb_10x.movie_keyword (37)
                     :  :        +- BroadcastExchange (42)
                     :  :           +- Project (41)
                     :  :              +- Filter (40)
                     :  :                 +- Scan parquet spark_catalog.imdb_10x.keyword (39)
                     :  +- Filter (47)
                     :     +- Scan parquet spark_catalog.imdb_10x.movie_info_idx (46)
                     +- BroadcastExchange (52)
                        +- Project (51)
                           +- Filter (50)
                              +- Scan parquet spark_catalog.imdb_10x.info_type (49)


(1) Scan parquet spark_catalog.imdb_10x.movie_info
Output [3]: [movie_id#213, info_type_id#214, info#215]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [In(info, [American,Danish,Denmark,German,Germany,Norway,Norwegian,Sweden,Swedish,USA]), IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(2) Filter
Input [3]: [movie_id#213, info_type_id#214, info#215]
Condition : ((info#215 IN (Sweden,Norway,Germany,Denmark,Swedish,Danish,Norwegian,German,USA,American) AND isnotnull(movie_id#213)) AND isnotnull(info_type_id#214))

(3) Project
Output [2]: [movie_id#213, info_type_id#214]
Input [3]: [movie_id#213, info_type_id#214, info#215]

(4) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#210, info#211]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,countries), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(5) Filter
Input [2]: [id#210, info#211]
Condition : ((isnotnull(info#211) AND (info#211 = countries)) AND isnotnull(id#210))

(6) Project
Output [1]: [id#210]
Input [2]: [id#210, info#211]

(7) BroadcastExchange
Input [1]: [id#210]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=16630]

(8) BroadcastHashJoin
Left keys [1]: [info_type_id#214]
Right keys [1]: [id#210]
Join type: Inner
Join condition: None

(9) Project
Output [1]: [movie_id#213]
Input [3]: [movie_id#213, info_type_id#214, id#210]

(10) BroadcastExchange
Input [1]: [movie_id#213]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=16634]

(11) Scan parquet spark_catalog.imdb_10x.title
Output [4]: [id#39, title#40, kind_id#42, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id), IsNotNull(kind_id)]
ReadSchema: struct<id:int,title:string,kind_id:int,production_year:string>

(12) Filter
Input [4]: [id#39, title#40, kind_id#42, production_year#43]
Condition : (((isnotnull(production_year#43) AND (cast(production_year#43 as int) > 2005)) AND isnotnull(id#39)) AND isnotnull(kind_id#42))

(13) Project
Output [3]: [id#39, title#40, kind_id#42]
Input [4]: [id#39, title#40, kind_id#42, production_year#43]

(14) BroadcastHashJoin
Left keys [1]: [movie_id#213]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(15) Scan parquet spark_catalog.imdb_10x.kind_type
Output [2]: [id#293, kind#294]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/kind_type]
PushedFilters: [In(kind, [episode,movie]), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(16) Filter
Input [2]: [id#293, kind#294]
Condition : (kind#294 IN (movie,episode) AND isnotnull(id#293))

(17) Project
Output [1]: [id#293]
Input [2]: [id#293, kind#294]

(18) BroadcastExchange
Input [1]: [id#293]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=16637]

(19) BroadcastHashJoin
Left keys [1]: [kind_id#42]
Right keys [1]: [id#293]
Join type: Inner
Join condition: None

(20) Project
Output [3]: [movie_id#213, id#39, title#40]
Input [5]: [movie_id#213, id#39, title#40, kind_id#42, id#293]

(21) BroadcastExchange
Input [3]: [movie_id#213, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[1, int, true] as bigint) & 4294967295))),false), [plan_id=16641]

(22) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [3]: [movie_id#33, company_id#34, company_type_id#35]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(company_id), IsNotNull(company_type_id), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,company_id:int,company_type_id:int>

(23) Filter
Input [3]: [movie_id#33, company_id#34, company_type_id#35]
Condition : ((isnotnull(company_id#34) AND isnotnull(company_type_id#35)) AND isnotnull(movie_id#33))

(24) BroadcastHashJoin
Left keys [2]: [movie_id#213, id#39]
Right keys [2]: [movie_id#33, movie_id#33]
Join type: Inner
Join condition: None

(25) Scan parquet spark_catalog.imdb_10x.company_type
Output [1]: [id#30]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_type]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int>

(26) Filter
Input [1]: [id#30]
Condition : isnotnull(id#30)

(27) BroadcastExchange
Input [1]: [id#30]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, false] as bigint)),false), [plan_id=16644]

(28) BroadcastHashJoin
Left keys [1]: [company_type_id#35]
Right keys [1]: [id#30]
Join type: Inner
Join condition: None

(29) Project
Output [5]: [movie_id#213, id#39, title#40, movie_id#33, company_id#34]
Input [7]: [movie_id#213, id#39, title#40, movie_id#33, company_id#34, company_type_id#35, id#30]

(30) BroadcastExchange
Input [5]: [movie_id#213, id#39, title#40, movie_id#33, company_id#34]
Arguments: HashedRelationBroadcastMode(List(cast(input[4, int, true] as bigint)),false), [plan_id=16648]

(31) Scan parquet spark_catalog.imdb_10x.company_name
Output [3]: [id#23, name#24, country_code#25]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(country_code), Not(EqualTo(country_code,[us])), IsNotNull(id)]
ReadSchema: struct<id:int,name:string,country_code:string>

(32) Filter
Input [3]: [id#23, name#24, country_code#25]
Condition : ((isnotnull(country_code#25) AND NOT (country_code#25 = [us])) AND isnotnull(id#23))

(33) Project
Output [2]: [id#23, name#24]
Input [3]: [id#23, name#24, country_code#25]

(34) BroadcastHashJoin
Left keys [1]: [company_id#34]
Right keys [1]: [id#23]
Join type: Inner
Join condition: None

(35) Project
Output [5]: [movie_id#213, id#39, title#40, movie_id#33, name#24]
Input [7]: [movie_id#213, id#39, title#40, movie_id#33, company_id#34, id#23, name#24]

(36) BroadcastExchange
Input [5]: [movie_id#213, id#39, title#40, movie_id#33, name#24]
Arguments: HashedRelationBroadcastMode(List(input[0, int, true], input[3, int, true], input[0, int, true], input[3, int, true], input[1, int, true], input[1, int, true]),false), [plan_id=16662]

(37) Scan parquet spark_catalog.imdb_10x.movie_keyword
Output [2]: [movie_id#116, keyword_id#117]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_keyword]
PushedFilters: [IsNotNull(movie_id), IsNotNull(keyword_id)]
ReadSchema: struct<movie_id:int,keyword_id:int>

(38) Filter
Input [2]: [movie_id#116, keyword_id#117]
Condition : (isnotnull(movie_id#116) AND isnotnull(keyword_id#117))

(39) Scan parquet spark_catalog.imdb_10x.keyword
Output [2]: [id#110, keyword#111]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/keyword]
PushedFilters: [In(keyword, [blood,murder,murder-in-title,violence]), IsNotNull(id)]
ReadSchema: struct<id:int,keyword:string>

(40) Filter
Input [2]: [id#110, keyword#111]
Condition : (keyword#111 IN (murder,murder-in-title,blood,violence) AND isnotnull(id#110))

(41) Project
Output [1]: [id#110]
Input [2]: [id#110, keyword#111]

(42) BroadcastExchange
Input [1]: [id#110]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=16651]

(43) BroadcastHashJoin
Left keys [1]: [keyword_id#117]
Right keys [1]: [id#110]
Join type: Inner
Join condition: None

(44) Project
Output [1]: [movie_id#116]
Input [3]: [movie_id#116, keyword_id#117, id#110]

(45) BroadcastExchange
Input [1]: [movie_id#116]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=16655]

(46) Scan parquet spark_catalog.imdb_10x.movie_info_idx
Output [3]: [movie_id#218, info_type_id#219, info#220]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info_idx]
PushedFilters: [IsNotNull(info), LessThan(info,8.5), IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(47) Filter
Input [3]: [movie_id#218, info_type_id#219, info#220]
Condition : (((isnotnull(info#220) AND (info#220 < 8.5)) AND isnotnull(movie_id#218)) AND isnotnull(info_type_id#219))

(48) BroadcastHashJoin
Left keys [1]: [movie_id#116]
Right keys [1]: [movie_id#218]
Join type: Inner
Join condition: None

(49) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#1123, info#1124]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,rating), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(50) Filter
Input [2]: [id#1123, info#1124]
Condition : ((isnotnull(info#1124) AND (info#1124 = rating)) AND isnotnull(id#1123))

(51) Project
Output [1]: [id#1123]
Input [2]: [id#1123, info#1124]

(52) BroadcastExchange
Input [1]: [id#1123]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=16658]

(53) BroadcastHashJoin
Left keys [1]: [info_type_id#219]
Right keys [1]: [id#1123]
Join type: Inner
Join condition: None

(54) Project
Output [3]: [movie_id#116, movie_id#218, info#220]
Input [5]: [movie_id#116, movie_id#218, info_type_id#219, info#220, id#1123]

(55) BroadcastHashJoin
Left keys [6]: [movie_id#213, movie_id#33, movie_id#213, movie_id#33, id#39, id#39]
Right keys [6]: [movie_id#218, movie_id#218, movie_id#116, movie_id#116, movie_id#116, movie_id#218]
Join type: Inner
Join condition: None

(56) Project
Output [3]: [name#24, info#220, title#40]
Input [8]: [movie_id#213, id#39, title#40, movie_id#33, name#24, movie_id#116, movie_id#218, info#220]

(57) SortAggregate
Input [3]: [name#24, info#220, title#40]
Keys: []
Functions [3]: [partial_min(name#24), partial_min(info#220), partial_min(title#40)]
Aggregate Attributes [3]: [min#1129, min#1130, min#1131]
Results [3]: [min#1132, min#1133, min#1134]

(58) Exchange
Input [3]: [min#1132, min#1133, min#1134]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=16667]

(59) SortAggregate
Input [3]: [min#1132, min#1133, min#1134]
Keys: []
Functions [3]: [min(name#24), min(info#220), min(title#40)]
Aggregate Attributes [3]: [min(name#24)#1126, min(info#220)#1127, min(title#40)#1128]
Results [3]: [min(name#24)#1126 AS movie_company#1115, min(info#220)#1127 AS rating#1116, min(title#40)#1128 AS western_violent_movie#1117]

(60) AdaptiveSparkPlan
Output [3]: [movie_company#1115, rating#1116, western_violent_movie#1117]
Arguments: isFinalPlan=false
Execution Time: 37.476
