== Physical Plan ==
AdaptiveSparkPlan (59)
+- SortAggregate (58)
   +- Exchange (57)
      +- SortAggregate (56)
         +- Project (55)
            +- BroadcastHashJoin Inner BuildLeft (54)
               :- BroadcastExchange (45)
               :  +- Project (44)
               :     +- BroadcastHashJoin Inner BuildRight (43)
               :        :- BroadcastHashJoin Inner BuildLeft (38)
               :        :  :- BroadcastExchange (34)
               :        :  :  +- Project (33)
               :        :  :     +- BroadcastHashJoin Inner BuildRight (32)
               :        :  :        :- Project (27)
               :        :  :        :  +- BroadcastHashJoin Inner BuildRight (26)
               :        :  :        :     :- BroadcastHashJoin Inner BuildLeft (22)
               :        :  :        :     :  :- BroadcastExchange (19)
               :        :  :        :     :  :  +- Project (18)
               :        :  :        :     :  :     +- BroadcastHashJoin Inner BuildRight (17)
               :        :  :        :     :  :        :- BroadcastHashJoin Inner BuildLeft (13)
               :        :  :        :     :  :        :  :- BroadcastExchange (9)
               :        :  :        :     :  :        :  :  +- Project (8)
               :        :  :        :     :  :        :  :     +- BroadcastHashJoin Inner BuildRight (7)
               :        :  :        :     :  :        :  :        :- Filter (2)
               :        :  :        :     :  :        :  :        :  +- Scan parquet spark_catalog.imdb_10x.movie_keyword (1)
               :        :  :        :     :  :        :  :        +- BroadcastExchange (6)
               :        :  :        :     :  :        :  :           +- Project (5)
               :        :  :        :     :  :        :  :              +- Filter (4)
               :        :  :        :     :  :        :  :                 +- Scan parquet spark_catalog.imdb_10x.keyword (3)
               :        :  :        :     :  :        :  +- Project (12)
               :        :  :        :     :  :        :     +- Filter (11)
               :        :  :        :     :  :        :        +- Scan parquet spark_catalog.imdb_10x.title (10)
               :        :  :        :     :  :        +- BroadcastExchange (16)
               :        :  :        :     :  :           +- Filter (15)
               :        :  :        :     :  :              +- Scan parquet spark_catalog.imdb_10x.kind_type (14)
               :        :  :        :     :  +- Filter (21)
               :        :  :        :     :     +- Scan parquet spark_catalog.imdb_10x.movie_companies (20)
               :        :  :        :     +- BroadcastExchange (25)
               :        :  :        :        +- Filter (24)
               :        :  :        :           +- Scan parquet spark_catalog.imdb_10x.company_type (23)
               :        :  :        +- BroadcastExchange (31)
               :        :  :           +- Project (30)
               :        :  :              +- Filter (29)
               :        :  :                 +- Scan parquet spark_catalog.imdb_10x.company_name (28)
               :        :  +- Project (37)
               :        :     +- Filter (36)
               :        :        +- Scan parquet spark_catalog.imdb_10x.movie_info (35)
               :        +- BroadcastExchange (42)
               :           +- Project (41)
               :              +- Filter (40)
               :                 +- Scan parquet spark_catalog.imdb_10x.info_type (39)
               +- Project (53)
                  +- BroadcastHashJoin Inner BuildRight (52)
                     :- Filter (47)
                     :  +- Scan parquet spark_catalog.imdb_10x.complete_cast (46)
                     +- BroadcastExchange (51)
                        +- Project (50)
                           +- Filter (49)
                              +- Scan parquet spark_catalog.imdb_10x.comp_cast_type (48)


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
PushedFilters: [In(keyword, [alienation,dignity,loner,nerd]), IsNotNull(id)]
ReadSchema: struct<id:int,keyword:string>

(4) Filter
Input [2]: [id#110, keyword#111]
Condition : (keyword#111 IN (nerd,loner,alienation,dignity) AND isnotnull(id#110))

(5) Project
Output [1]: [id#110]
Input [2]: [id#110, keyword#111]

(6) BroadcastExchange
Input [1]: [id#110]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=17463]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=17467]

(10) Scan parquet spark_catalog.imdb_10x.title
Output [4]: [id#39, title#40, kind_id#42, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id), IsNotNull(kind_id)]
ReadSchema: struct<id:int,title:string,kind_id:int,production_year:string>

(11) Filter
Input [4]: [id#39, title#40, kind_id#42, production_year#43]
Condition : (((isnotnull(production_year#43) AND (cast(production_year#43 as int) > 2000)) AND isnotnull(id#39)) AND isnotnull(kind_id#42))

(12) Project
Output [3]: [id#39, title#40, kind_id#42]
Input [4]: [id#39, title#40, kind_id#42, production_year#43]

(13) BroadcastHashJoin
Left keys [1]: [movie_id#116]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(14) Scan parquet spark_catalog.imdb_10x.kind_type
Output [2]: [id#293, kind#294]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/kind_type]
PushedFilters: [IsNotNull(kind), EqualTo(kind,movie), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(15) Filter
Input [2]: [id#293, kind#294]
Condition : ((isnotnull(kind#294) AND (kind#294 = movie)) AND isnotnull(id#293))

(16) BroadcastExchange
Input [2]: [id#293, kind#294]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, false] as bigint)),false), [plan_id=17470]

(17) BroadcastHashJoin
Left keys [1]: [kind_id#42]
Right keys [1]: [id#293]
Join type: Inner
Join condition: None

(18) Project
Output [4]: [movie_id#116, id#39, title#40, kind#294]
Input [6]: [movie_id#116, id#39, title#40, kind_id#42, id#293, kind#294]

(19) BroadcastExchange
Input [4]: [movie_id#116, id#39, title#40, kind#294]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[1, int, true] as bigint) & 4294967295))),false), [plan_id=17474]

(20) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [3]: [movie_id#33, company_id#34, company_type_id#35]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(movie_id), IsNotNull(company_type_id), IsNotNull(company_id)]
ReadSchema: struct<movie_id:int,company_id:int,company_type_id:int>

(21) Filter
Input [3]: [movie_id#33, company_id#34, company_type_id#35]
Condition : ((isnotnull(movie_id#33) AND isnotnull(company_type_id#35)) AND isnotnull(company_id#34))

(22) BroadcastHashJoin
Left keys [2]: [movie_id#116, id#39]
Right keys [2]: [movie_id#33, movie_id#33]
Join type: Inner
Join condition: None

(23) Scan parquet spark_catalog.imdb_10x.company_type
Output [1]: [id#30]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_type]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int>

(24) Filter
Input [1]: [id#30]
Condition : isnotnull(id#30)

(25) BroadcastExchange
Input [1]: [id#30]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, false] as bigint)),false), [plan_id=17477]

(26) BroadcastHashJoin
Left keys [1]: [company_type_id#35]
Right keys [1]: [id#30]
Join type: Inner
Join condition: None

(27) Project
Output [6]: [movie_id#116, id#39, title#40, kind#294, movie_id#33, company_id#34]
Input [8]: [movie_id#116, id#39, title#40, kind#294, movie_id#33, company_id#34, company_type_id#35, id#30]

(28) Scan parquet spark_catalog.imdb_10x.company_name
Output [2]: [id#23, country_code#25]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(country_code), EqualTo(country_code,[us]), IsNotNull(id)]
ReadSchema: struct<id:int,country_code:string>

(29) Filter
Input [2]: [id#23, country_code#25]
Condition : ((isnotnull(country_code#25) AND (country_code#25 = [us])) AND isnotnull(id#23))

(30) Project
Output [1]: [id#23]
Input [2]: [id#23, country_code#25]

(31) BroadcastExchange
Input [1]: [id#23]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=17481]

(32) BroadcastHashJoin
Left keys [1]: [company_id#34]
Right keys [1]: [id#23]
Join type: Inner
Join condition: None

(33) Project
Output [5]: [movie_id#116, id#39, title#40, kind#294, movie_id#33]
Input [7]: [movie_id#116, id#39, title#40, kind#294, movie_id#33, company_id#34, id#23]

(34) BroadcastExchange
Input [5]: [movie_id#116, id#39, title#40, kind#294, movie_id#33]
Arguments: HashedRelationBroadcastMode(List(input[4, int, true], input[0, int, true], input[1, int, true]),false), [plan_id=17485]

(35) Scan parquet spark_catalog.imdb_10x.movie_info
Output [4]: [movie_id#213, info_type_id#214, info#215, note#216]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [IsNotNull(note), IsNotNull(info), StringContains(note,internet), IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string,note:string>

(36) Filter
Input [4]: [movie_id#213, info_type_id#214, info#215, note#216]
Condition : (((((isnotnull(note#216) AND isnotnull(info#215)) AND Contains(note#216, internet)) AND info#215 LIKE USA:% 200%) AND isnotnull(movie_id#213)) AND isnotnull(info_type_id#214))

(37) Project
Output [2]: [movie_id#213, info_type_id#214]
Input [4]: [movie_id#213, info_type_id#214, info#215, note#216]

(38) BroadcastHashJoin
Left keys [3]: [movie_id#33, movie_id#116, id#39]
Right keys [3]: [movie_id#213, movie_id#213, movie_id#213]
Join type: Inner
Join condition: None

(39) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#210, info#211]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,release dates), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(40) Filter
Input [2]: [id#210, info#211]
Condition : ((isnotnull(info#211) AND (info#211 = release dates)) AND isnotnull(id#210))

(41) Project
Output [1]: [id#210]
Input [2]: [id#210, info#211]

(42) BroadcastExchange
Input [1]: [id#210]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=17488]

(43) BroadcastHashJoin
Left keys [1]: [info_type_id#214]
Right keys [1]: [id#210]
Join type: Inner
Join condition: None

(44) Project
Output [6]: [movie_id#116, id#39, title#40, kind#294, movie_id#33, movie_id#213]
Input [8]: [movie_id#116, id#39, title#40, kind#294, movie_id#33, movie_id#213, info_type_id#214, id#210]

(45) BroadcastExchange
Input [6]: [movie_id#116, id#39, title#40, kind#294, movie_id#33, movie_id#213]
Arguments: HashedRelationBroadcastMode(List(input[4, int, true], input[5, int, true], input[0, int, true], input[1, int, true]),false), [plan_id=17495]

(46) Scan parquet spark_catalog.imdb_10x.complete_cast
Output [2]: [movie_id#927, status_id#929]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/complete_cast]
PushedFilters: [IsNotNull(status_id), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:string,status_id:int>

(47) Filter
Input [2]: [movie_id#927, status_id#929]
Condition : (isnotnull(status_id#929) AND isnotnull(movie_id#927))

(48) Scan parquet spark_catalog.imdb_10x.comp_cast_type
Output [2]: [id#930, kind#931]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/comp_cast_type]
PushedFilters: [IsNotNull(kind), EqualTo(kind,complete+verified), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(49) Filter
Input [2]: [id#930, kind#931]
Condition : ((isnotnull(kind#931) AND (kind#931 = complete+verified)) AND isnotnull(id#930))

(50) Project
Output [1]: [id#930]
Input [2]: [id#930, kind#931]

(51) BroadcastExchange
Input [1]: [id#930]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=17491]

(52) BroadcastHashJoin
Left keys [1]: [status_id#929]
Right keys [1]: [id#930]
Join type: Inner
Join condition: None

(53) Project
Output [1]: [movie_id#927]
Input [3]: [movie_id#927, status_id#929, id#930]

(54) BroadcastHashJoin
Left keys [4]: [movie_id#33, movie_id#213, movie_id#116, id#39]
Right keys [4]: [cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int)]
Join type: Inner
Join condition: None

(55) Project
Output [2]: [kind#294, title#40]
Input [7]: [movie_id#116, id#39, title#40, kind#294, movie_id#33, movie_id#213, movie_id#927]

(56) SortAggregate
Input [2]: [kind#294, title#40]
Keys: []
Functions [2]: [partial_min(kind#294), partial_min(title#40)]
Aggregate Attributes [2]: [min#1165, min#1166]
Results [2]: [min#1167, min#1168]

(57) Exchange
Input [2]: [min#1167, min#1168]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=17500]

(58) SortAggregate
Input [2]: [min#1167, min#1168]
Keys: []
Functions [2]: [min(kind#294), min(title#40)]
Aggregate Attributes [2]: [min(kind#294)#1163, min(title#40)#1164]
Results [2]: [min(kind#294)#1163 AS movie_kind#1156, min(title#40)#1164 AS complete_nerdy_internet_movie#1157]

(59) AdaptiveSparkPlan
Output [2]: [movie_kind#1156, complete_nerdy_internet_movie#1157]
Arguments: isFinalPlan=false
Execution Time: 19.472
