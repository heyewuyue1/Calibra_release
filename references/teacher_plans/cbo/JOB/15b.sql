== Physical Plan ==
AdaptiveSparkPlan (48)
+- SortAggregate (47)
   +- Exchange (46)
      +- SortAggregate (45)
         +- Project (44)
            +- BroadcastHashJoin Inner BuildLeft (43)
               :- BroadcastExchange (40)
               :  +- Project (39)
               :     +- BroadcastHashJoin Inner BuildLeft (38)
               :        :- BroadcastExchange (35)
               :        :  +- BroadcastHashJoin Inner BuildLeft (34)
               :        :     :- BroadcastExchange (31)
               :        :     :  +- Project (30)
               :        :     :     +- BroadcastHashJoin Inner BuildRight (29)
               :        :     :        :- BroadcastHashJoin Inner BuildLeft (24)
               :        :     :        :  :- BroadcastExchange (20)
               :        :     :        :  :  +- BroadcastHashJoin Inner BuildLeft (19)
               :        :     :        :  :     :- BroadcastExchange (15)
               :        :     :        :  :     :  +- Project (14)
               :        :     :        :  :     :     +- BroadcastHashJoin Inner BuildLeft (13)
               :        :     :        :  :     :        :- BroadcastExchange (10)
               :        :     :        :  :     :        :  +- Project (9)
               :        :     :        :  :     :        :     +- BroadcastHashJoin Inner BuildRight (8)
               :        :     :        :  :     :        :        :- Project (3)
               :        :     :        :  :     :        :        :  +- Filter (2)
               :        :     :        :  :     :        :        :     +- Scan parquet spark_catalog.imdb_10x.movie_companies (1)
               :        :     :        :  :     :        :        +- BroadcastExchange (7)
               :        :     :        :  :     :        :           +- Project (6)
               :        :     :        :  :     :        :              +- Filter (5)
               :        :     :        :  :     :        :                 +- Scan parquet spark_catalog.imdb_10x.company_name (4)
               :        :     :        :  :     :        +- Filter (12)
               :        :     :        :  :     :           +- Scan parquet spark_catalog.imdb_10x.company_type (11)
               :        :     :        :  :     +- Project (18)
               :        :     :        :  :        +- Filter (17)
               :        :     :        :  :           +- Scan parquet spark_catalog.imdb_10x.title (16)
               :        :     :        :  +- Project (23)
               :        :     :        :     +- Filter (22)
               :        :     :        :        +- Scan parquet spark_catalog.imdb_10x.movie_info (21)
               :        :     :        +- BroadcastExchange (28)
               :        :     :           +- Project (27)
               :        :     :              +- Filter (26)
               :        :     :                 +- Scan parquet spark_catalog.imdb_10x.info_type (25)
               :        :     +- Filter (33)
               :        :        +- Scan parquet spark_catalog.imdb_10x.aka_title (32)
               :        +- Filter (37)
               :           +- Scan parquet spark_catalog.imdb_10x.movie_keyword (36)
               +- Filter (42)
                  +- Scan parquet spark_catalog.imdb_10x.keyword (41)


(1) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [4]: [movie_id#33, company_id#34, company_type_id#35, note#36]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(note), StringContains(note,(worldwide)), IsNotNull(movie_id), IsNotNull(company_type_id), IsNotNull(company_id)]
ReadSchema: struct<movie_id:int,company_id:int,company_type_id:int,note:string>

(2) Filter
Input [4]: [movie_id#33, company_id#34, company_type_id#35, note#36]
Condition : (((((isnotnull(note#36) AND note#36 LIKE %(200%)%) AND Contains(note#36, (worldwide))) AND isnotnull(movie_id#33)) AND isnotnull(company_type_id#35)) AND isnotnull(company_id#34))

(3) Project
Output [3]: [movie_id#33, company_id#34, company_type_id#35]
Input [4]: [movie_id#33, company_id#34, company_type_id#35, note#36]

(4) Scan parquet spark_catalog.imdb_10x.company_name
Output [3]: [id#23, name#24, country_code#25]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(country_code), IsNotNull(name), EqualTo(country_code,[us]), EqualTo(name,YouTube), IsNotNull(id)]
ReadSchema: struct<id:int,name:string,country_code:string>

(5) Filter
Input [3]: [id#23, name#24, country_code#25]
Condition : ((((isnotnull(country_code#25) AND isnotnull(name#24)) AND (country_code#25 = [us])) AND (name#24 = YouTube)) AND isnotnull(id#23))

(6) Project
Output [1]: [id#23]
Input [3]: [id#23, name#24, country_code#25]

(7) BroadcastExchange
Input [1]: [id#23]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=6039]

(8) BroadcastHashJoin
Left keys [1]: [company_id#34]
Right keys [1]: [id#23]
Join type: Inner
Join condition: None

(9) Project
Output [2]: [movie_id#33, company_type_id#35]
Input [4]: [movie_id#33, company_id#34, company_type_id#35, id#23]

(10) BroadcastExchange
Input [2]: [movie_id#33, company_type_id#35]
Arguments: HashedRelationBroadcastMode(List(cast(input[1, int, true] as bigint)),false), [plan_id=6043]

(11) Scan parquet spark_catalog.imdb_10x.company_type
Output [1]: [id#30]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_type]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int>

(12) Filter
Input [1]: [id#30]
Condition : isnotnull(id#30)

(13) BroadcastHashJoin
Left keys [1]: [company_type_id#35]
Right keys [1]: [id#30]
Join type: Inner
Join condition: None

(14) Project
Output [1]: [movie_id#33]
Input [3]: [movie_id#33, company_type_id#35, id#30]

(15) BroadcastExchange
Input [1]: [movie_id#33]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=6047]

(16) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#39, title#40, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(17) Filter
Input [3]: [id#39, title#40, production_year#43]
Condition : (((isnotnull(production_year#43) AND (cast(production_year#43 as int) >= 2005)) AND (cast(production_year#43 as int) <= 2010)) AND isnotnull(id#39))

(18) Project
Output [2]: [id#39, title#40]
Input [3]: [id#39, title#40, production_year#43]

(19) BroadcastHashJoin
Left keys [1]: [movie_id#33]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(20) BroadcastExchange
Input [3]: [movie_id#33, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[1, int, true] as bigint) & 4294967295))),false), [plan_id=6050]

(21) Scan parquet spark_catalog.imdb_10x.movie_info
Output [4]: [movie_id#213, info_type_id#214, info#215, note#216]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [IsNotNull(note), IsNotNull(info), StringContains(note,internet), IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string,note:string>

(22) Filter
Input [4]: [movie_id#213, info_type_id#214, info#215, note#216]
Condition : (((((isnotnull(note#216) AND isnotnull(info#215)) AND Contains(note#216, internet)) AND info#215 LIKE USA:% 200%) AND isnotnull(movie_id#213)) AND isnotnull(info_type_id#214))

(23) Project
Output [3]: [movie_id#213, info_type_id#214, info#215]
Input [4]: [movie_id#213, info_type_id#214, info#215, note#216]

(24) BroadcastHashJoin
Left keys [2]: [movie_id#33, id#39]
Right keys [2]: [movie_id#213, movie_id#213]
Join type: Inner
Join condition: None

(25) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#210, info#211]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,release dates), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(26) Filter
Input [2]: [id#210, info#211]
Condition : ((isnotnull(info#211) AND (info#211 = release dates)) AND isnotnull(id#210))

(27) Project
Output [1]: [id#210]
Input [2]: [id#210, info#211]

(28) BroadcastExchange
Input [1]: [id#210]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=6053]

(29) BroadcastHashJoin
Left keys [1]: [info_type_id#214]
Right keys [1]: [id#210]
Join type: Inner
Join condition: None

(30) Project
Output [5]: [movie_id#33, id#39, title#40, movie_id#213, info#215]
Input [7]: [movie_id#33, id#39, title#40, movie_id#213, info_type_id#214, info#215, id#210]

(31) BroadcastExchange
Input [5]: [movie_id#33, id#39, title#40, movie_id#213, info#215]
Arguments: HashedRelationBroadcastMode(List(input[0, int, true], input[3, int, true], input[1, int, true]),false), [plan_id=6057]

(32) Scan parquet spark_catalog.imdb_10x.aka_title
Output [1]: [movie_id#452]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/aka_title]
PushedFilters: [IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int>

(33) Filter
Input [1]: [movie_id#452]
Condition : isnotnull(movie_id#452)

(34) BroadcastHashJoin
Left keys [3]: [movie_id#33, movie_id#213, id#39]
Right keys [3]: [movie_id#452, movie_id#452, movie_id#452]
Join type: Inner
Join condition: None

(35) BroadcastExchange
Input [6]: [movie_id#33, id#39, title#40, movie_id#213, info#215, movie_id#452]
Arguments: HashedRelationBroadcastMode(List(input[3, int, true], input[0, int, true], input[5, int, false], input[1, int, true]),false), [plan_id=6060]

(36) Scan parquet spark_catalog.imdb_10x.movie_keyword
Output [2]: [movie_id#116, keyword_id#117]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_keyword]
PushedFilters: [IsNotNull(movie_id), IsNotNull(keyword_id)]
ReadSchema: struct<movie_id:int,keyword_id:int>

(37) Filter
Input [2]: [movie_id#116, keyword_id#117]
Condition : (isnotnull(movie_id#116) AND isnotnull(keyword_id#117))

(38) BroadcastHashJoin
Left keys [4]: [movie_id#213, movie_id#33, movie_id#452, id#39]
Right keys [4]: [movie_id#116, movie_id#116, movie_id#116, movie_id#116]
Join type: Inner
Join condition: None

(39) Project
Output [3]: [title#40, info#215, keyword_id#117]
Input [8]: [movie_id#33, id#39, title#40, movie_id#213, info#215, movie_id#452, movie_id#116, keyword_id#117]

(40) BroadcastExchange
Input [3]: [title#40, info#215, keyword_id#117]
Arguments: HashedRelationBroadcastMode(List(cast(input[2, int, true] as bigint)),false), [plan_id=6064]

(41) Scan parquet spark_catalog.imdb_10x.keyword
Output [1]: [id#110]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/keyword]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int>

(42) Filter
Input [1]: [id#110]
Condition : isnotnull(id#110)

(43) BroadcastHashJoin
Left keys [1]: [keyword_id#117]
Right keys [1]: [id#110]
Join type: Inner
Join condition: None

(44) Project
Output [2]: [info#215, title#40]
Input [4]: [title#40, info#215, keyword_id#117, id#110]

(45) SortAggregate
Input [2]: [info#215, title#40]
Keys: []
Functions [2]: [partial_min(info#215), partial_min(title#40)]
Aggregate Attributes [2]: [min#483, min#484]
Results [2]: [min#485, min#486]

(46) Exchange
Input [2]: [min#485, min#486]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=6069]

(47) SortAggregate
Input [2]: [min#485, min#486]
Keys: []
Functions [2]: [min(info#215), min(title#40)]
Aggregate Attributes [2]: [min(info#215)#481, min(title#40)#482]
Results [2]: [min(info#215)#481 AS release_date#474, min(title#40)#482 AS youtube_movie#475]

(48) AdaptiveSparkPlan
Output [2]: [release_date#474, youtube_movie#475]
Arguments: isFinalPlan=false
Execution Time: 19.128
