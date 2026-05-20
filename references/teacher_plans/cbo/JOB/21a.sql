== Physical Plan ==
AdaptiveSparkPlan (49)
+- SortAggregate (48)
   +- Exchange (47)
      +- SortAggregate (46)
         +- Project (45)
            +- BroadcastHashJoin Inner BuildLeft (44)
               :- BroadcastExchange (31)
               :  +- Project (30)
               :     +- BroadcastHashJoin Inner BuildLeft (29)
               :        :- BroadcastExchange (25)
               :        :  +- Project (24)
               :        :     +- BroadcastHashJoin Inner BuildRight (23)
               :        :        :- BroadcastHashJoin Inner BuildLeft (18)
               :        :        :  :- BroadcastExchange (14)
               :        :        :  :  +- BroadcastHashJoin Inner BuildLeft (13)
               :        :        :  :     :- BroadcastExchange (9)
               :        :        :  :     :  +- Project (8)
               :        :        :  :     :     +- BroadcastHashJoin Inner BuildRight (7)
               :        :        :  :     :        :- Filter (2)
               :        :        :  :     :        :  +- Scan parquet spark_catalog.imdb_10x.movie_keyword (1)
               :        :        :  :     :        +- BroadcastExchange (6)
               :        :        :  :     :           +- Project (5)
               :        :        :  :     :              +- Filter (4)
               :        :        :  :     :                 +- Scan parquet spark_catalog.imdb_10x.keyword (3)
               :        :        :  :     +- Project (12)
               :        :        :  :        +- Filter (11)
               :        :        :  :           +- Scan parquet spark_catalog.imdb_10x.title (10)
               :        :        :  +- Project (17)
               :        :        :     +- Filter (16)
               :        :        :        +- Scan parquet spark_catalog.imdb_10x.movie_companies (15)
               :        :        +- BroadcastExchange (22)
               :        :           +- Project (21)
               :        :              +- Filter (20)
               :        :                 +- Scan parquet spark_catalog.imdb_10x.company_type (19)
               :        +- Project (28)
               :           +- Filter (27)
               :              +- Scan parquet spark_catalog.imdb_10x.company_name (26)
               +- Project (43)
                  +- BroadcastHashJoin Inner BuildRight (42)
                     :- BroadcastHashJoin Inner BuildLeft (38)
                     :  :- BroadcastExchange (35)
                     :  :  +- Project (34)
                     :  :     +- Filter (33)
                     :  :        +- Scan parquet spark_catalog.imdb_10x.movie_info (32)
                     :  +- Filter (37)
                     :     +- Scan parquet spark_catalog.imdb_10x.movie_link (36)
                     +- BroadcastExchange (41)
                        +- Filter (40)
                           +- Scan parquet spark_catalog.imdb_10x.link_type (39)


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
PushedFilters: [IsNotNull(keyword), EqualTo(keyword,sequel), IsNotNull(id)]
ReadSchema: struct<id:int,keyword:string>

(4) Filter
Input [2]: [id#110, keyword#111]
Condition : ((isnotnull(keyword#111) AND (keyword#111 = sequel)) AND isnotnull(id#110))

(5) Project
Output [1]: [id#110]
Input [2]: [id#110, keyword#111]

(6) BroadcastExchange
Input [1]: [id#110]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=14314]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=14318]

(10) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#39, title#40, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(11) Filter
Input [3]: [id#39, title#40, production_year#43]
Condition : (((isnotnull(production_year#43) AND (cast(production_year#43 as int) >= 1950)) AND (cast(production_year#43 as int) <= 2000)) AND isnotnull(id#39))

(12) Project
Output [2]: [id#39, title#40]
Input [3]: [id#39, title#40, production_year#43]

(13) BroadcastHashJoin
Left keys [1]: [movie_id#116]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(14) BroadcastExchange
Input [3]: [movie_id#116, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[1, int, true] as bigint) & 4294967295))),false), [plan_id=14321]

(15) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [4]: [movie_id#33, company_id#34, company_type_id#35, note#36]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNull(note), IsNotNull(company_id), IsNotNull(company_type_id), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,company_id:int,company_type_id:int,note:string>

(16) Filter
Input [4]: [movie_id#33, company_id#34, company_type_id#35, note#36]
Condition : (((isnull(note#36) AND isnotnull(company_id#34)) AND isnotnull(company_type_id#35)) AND isnotnull(movie_id#33))

(17) Project
Output [3]: [movie_id#33, company_id#34, company_type_id#35]
Input [4]: [movie_id#33, company_id#34, company_type_id#35, note#36]

(18) BroadcastHashJoin
Left keys [2]: [movie_id#116, id#39]
Right keys [2]: [movie_id#33, movie_id#33]
Join type: Inner
Join condition: None

(19) Scan parquet spark_catalog.imdb_10x.company_type
Output [2]: [id#30, kind#31]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_type]
PushedFilters: [IsNotNull(kind), EqualTo(kind,production companies), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(20) Filter
Input [2]: [id#30, kind#31]
Condition : ((isnotnull(kind#31) AND (kind#31 = production companies)) AND isnotnull(id#30))

(21) Project
Output [1]: [id#30]
Input [2]: [id#30, kind#31]

(22) BroadcastExchange
Input [1]: [id#30]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=14324]

(23) BroadcastHashJoin
Left keys [1]: [company_type_id#35]
Right keys [1]: [id#30]
Join type: Inner
Join condition: None

(24) Project
Output [5]: [movie_id#116, id#39, title#40, movie_id#33, company_id#34]
Input [7]: [movie_id#116, id#39, title#40, movie_id#33, company_id#34, company_type_id#35, id#30]

(25) BroadcastExchange
Input [5]: [movie_id#116, id#39, title#40, movie_id#33, company_id#34]
Arguments: HashedRelationBroadcastMode(List(cast(input[4, int, true] as bigint)),false), [plan_id=14328]

(26) Scan parquet spark_catalog.imdb_10x.company_name
Output [3]: [id#23, name#24, country_code#25]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(country_code), Not(EqualTo(country_code,[pl])), Or(StringContains(name,Film),StringContains(name,Warner)), IsNotNull(id)]
ReadSchema: struct<id:int,name:string,country_code:string>

(27) Filter
Input [3]: [id#23, name#24, country_code#25]
Condition : (((isnotnull(country_code#25) AND NOT (country_code#25 = [pl])) AND (Contains(name#24, Film) OR Contains(name#24, Warner))) AND isnotnull(id#23))

(28) Project
Output [2]: [id#23, name#24]
Input [3]: [id#23, name#24, country_code#25]

(29) BroadcastHashJoin
Left keys [1]: [company_id#34]
Right keys [1]: [id#23]
Join type: Inner
Join condition: None

(30) Project
Output [5]: [movie_id#116, id#39, title#40, movie_id#33, name#24]
Input [7]: [movie_id#116, id#39, title#40, movie_id#33, company_id#34, id#23, name#24]

(31) BroadcastExchange
Input [5]: [movie_id#116, id#39, title#40, movie_id#33, name#24]
Arguments: HashedRelationBroadcastMode(List(input[3, int, true], input[0, int, true], input[0, int, true], input[3, int, true], input[1, int, true], input[1, int, true]),false), [plan_id=14338]

(32) Scan parquet spark_catalog.imdb_10x.movie_info
Output [2]: [movie_id#213, info#215]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [In(info, [Denish,Denmark,German,Germany,Norway,Norwegian,Sweden,Swedish]), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,info:string>

(33) Filter
Input [2]: [movie_id#213, info#215]
Condition : (info#215 IN (Sweden,Norway,Germany,Denmark,Swedish,Denish,Norwegian,German) AND isnotnull(movie_id#213))

(34) Project
Output [1]: [movie_id#213]
Input [2]: [movie_id#213, info#215]

(35) BroadcastExchange
Input [1]: [movie_id#213]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=14331]

(36) Scan parquet spark_catalog.imdb_10x.movie_link
Output [2]: [movie_id#119, link_type_id#121]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_link]
PushedFilters: [IsNotNull(movie_id), IsNotNull(link_type_id)]
ReadSchema: struct<movie_id:int,link_type_id:int>

(37) Filter
Input [2]: [movie_id#119, link_type_id#121]
Condition : (isnotnull(movie_id#119) AND isnotnull(link_type_id#121))

(38) BroadcastHashJoin
Left keys [1]: [movie_id#213]
Right keys [1]: [movie_id#119]
Join type: Inner
Join condition: None

(39) Scan parquet spark_catalog.imdb_10x.link_type
Output [2]: [id#113, link#114]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/link_type]
PushedFilters: [IsNotNull(link), StringContains(link,follow), IsNotNull(id)]
ReadSchema: struct<id:int,link:string>

(40) Filter
Input [2]: [id#113, link#114]
Condition : ((isnotnull(link#114) AND Contains(link#114, follow)) AND isnotnull(id#113))

(41) BroadcastExchange
Input [2]: [id#113, link#114]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, false] as bigint)),false), [plan_id=14334]

(42) BroadcastHashJoin
Left keys [1]: [link_type_id#121]
Right keys [1]: [id#113]
Join type: Inner
Join condition: None

(43) Project
Output [3]: [movie_id#213, movie_id#119, link#114]
Input [5]: [movie_id#213, movie_id#119, link_type_id#121, id#113, link#114]

(44) BroadcastHashJoin
Left keys [6]: [movie_id#33, movie_id#116, movie_id#116, movie_id#33, id#39, id#39]
Right keys [6]: [movie_id#213, movie_id#213, movie_id#119, movie_id#119, movie_id#119, movie_id#213]
Join type: Inner
Join condition: None

(45) Project
Output [3]: [name#24, link#114, title#40]
Input [8]: [movie_id#116, id#39, title#40, movie_id#33, name#24, movie_id#213, movie_id#119, link#114]

(46) SortAggregate
Input [3]: [name#24, link#114, title#40]
Keys: []
Functions [3]: [partial_min(name#24), partial_min(link#114), partial_min(title#40)]
Aggregate Attributes [3]: [min#991, min#992, min#993]
Results [3]: [min#994, min#995, min#996]

(47) Exchange
Input [3]: [min#994, min#995, min#996]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=14343]

(48) SortAggregate
Input [3]: [min#994, min#995, min#996]
Keys: []
Functions [3]: [min(name#24), min(link#114), min(title#40)]
Aggregate Attributes [3]: [min(name#24)#988, min(link#114)#989, min(title#40)#990]
Results [3]: [min(name#24)#988 AS company_name#980, min(link#114)#989 AS link_type#981, min(title#40)#990 AS western_follow_up#982]

(49) AdaptiveSparkPlan
Output [3]: [company_name#980, link_type#981, western_follow_up#982]
Arguments: isFinalPlan=false
Execution Time: 19.142
