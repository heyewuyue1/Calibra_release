== Physical Plan ==
AdaptiveSparkPlan (65)
+- SortAggregate (64)
   +- Exchange (63)
      +- SortAggregate (62)
         +- Project (61)
            +- BroadcastHashJoin Inner BuildLeft (60)
               :- BroadcastExchange (45)
               :  +- BroadcastHashJoin Inner BuildRight (44)
               :     :- Project (22)
               :     :  +- BroadcastHashJoin Inner BuildRight (21)
               :     :     :- BroadcastHashJoin Inner BuildLeft (17)
               :     :     :  :- BroadcastExchange (14)
               :     :     :  :  +- BroadcastHashJoin Inner BuildLeft (13)
               :     :     :  :     :- BroadcastExchange (9)
               :     :     :  :     :  +- Project (8)
               :     :     :  :     :     +- BroadcastHashJoin Inner BuildRight (7)
               :     :     :  :     :        :- Filter (2)
               :     :     :  :     :        :  +- Scan parquet spark_catalog.imdb_10x.movie_keyword (1)
               :     :     :  :     :        +- BroadcastExchange (6)
               :     :     :  :     :           +- Project (5)
               :     :     :  :     :              +- Filter (4)
               :     :     :  :     :                 +- Scan parquet spark_catalog.imdb_10x.keyword (3)
               :     :     :  :     +- Project (12)
               :     :     :  :        +- Filter (11)
               :     :     :  :           +- Scan parquet spark_catalog.imdb_10x.title (10)
               :     :     :  +- Filter (16)
               :     :     :     +- Scan parquet spark_catalog.imdb_10x.movie_link (15)
               :     :     +- BroadcastExchange (20)
               :     :        +- Filter (19)
               :     :           +- Scan parquet spark_catalog.imdb_10x.link_type (18)
               :     +- BroadcastExchange (43)
               :        +- Project (42)
               :           +- BroadcastHashJoin Inner BuildLeft (41)
               :              :- BroadcastExchange (37)
               :              :  +- Project (36)
               :              :     +- BroadcastHashJoin Inner BuildRight (35)
               :              :        :- BroadcastHashJoin Inner BuildRight (30)
               :              :        :  :- Project (25)
               :              :        :  :  +- Filter (24)
               :              :        :  :     +- Scan parquet spark_catalog.imdb_10x.movie_companies (23)
               :              :        :  +- BroadcastExchange (29)
               :              :        :     +- Project (28)
               :              :        :        +- Filter (27)
               :              :        :           +- Scan parquet spark_catalog.imdb_10x.movie_info (26)
               :              :        +- BroadcastExchange (34)
               :              :           +- Project (33)
               :              :              +- Filter (32)
               :              :                 +- Scan parquet spark_catalog.imdb_10x.company_type (31)
               :              +- Project (40)
               :                 +- Filter (39)
               :                    +- Scan parquet spark_catalog.imdb_10x.company_name (38)
               +- Project (59)
                  +- BroadcastHashJoin Inner BuildRight (58)
                     :- Project (53)
                     :  +- BroadcastHashJoin Inner BuildRight (52)
                     :     :- Filter (47)
                     :     :  +- Scan parquet spark_catalog.imdb_10x.complete_cast (46)
                     :     +- BroadcastExchange (51)
                     :        +- Project (50)
                     :           +- Filter (49)
                     :              +- Scan parquet spark_catalog.imdb_10x.comp_cast_type (48)
                     +- BroadcastExchange (57)
                        +- Project (56)
                           +- Filter (55)
                              +- Scan parquet spark_catalog.imdb_10x.comp_cast_type (54)


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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=22536]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=22540]

(10) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#39, title#40, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(11) Filter
Input [3]: [id#39, title#40, production_year#43]
Condition : (((isnotnull(production_year#43) AND (cast(production_year#43 as int) >= 1950)) AND (cast(production_year#43 as int) <= 2010)) AND isnotnull(id#39))

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
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[1, int, true] as bigint) & 4294967295))),false), [plan_id=22543]

(15) Scan parquet spark_catalog.imdb_10x.movie_link
Output [2]: [movie_id#119, link_type_id#121]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_link]
PushedFilters: [IsNotNull(movie_id), IsNotNull(link_type_id)]
ReadSchema: struct<movie_id:int,link_type_id:int>

(16) Filter
Input [2]: [movie_id#119, link_type_id#121]
Condition : (isnotnull(movie_id#119) AND isnotnull(link_type_id#121))

(17) BroadcastHashJoin
Left keys [2]: [movie_id#116, id#39]
Right keys [2]: [movie_id#119, movie_id#119]
Join type: Inner
Join condition: None

(18) Scan parquet spark_catalog.imdb_10x.link_type
Output [2]: [id#113, link#114]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/link_type]
PushedFilters: [IsNotNull(link), StringContains(link,follow), IsNotNull(id)]
ReadSchema: struct<id:int,link:string>

(19) Filter
Input [2]: [id#113, link#114]
Condition : ((isnotnull(link#114) AND Contains(link#114, follow)) AND isnotnull(id#113))

(20) BroadcastExchange
Input [2]: [id#113, link#114]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, false] as bigint)),false), [plan_id=22546]

(21) BroadcastHashJoin
Left keys [1]: [link_type_id#121]
Right keys [1]: [id#113]
Join type: Inner
Join condition: None

(22) Project
Output [5]: [movie_id#116, id#39, title#40, movie_id#119, link#114]
Input [7]: [movie_id#116, id#39, title#40, movie_id#119, link_type_id#121, id#113, link#114]

(23) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [4]: [movie_id#33, company_id#34, company_type_id#35, note#36]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNull(note), IsNotNull(movie_id), IsNotNull(company_type_id), IsNotNull(company_id)]
ReadSchema: struct<movie_id:int,company_id:int,company_type_id:int,note:string>

(24) Filter
Input [4]: [movie_id#33, company_id#34, company_type_id#35, note#36]
Condition : (((isnull(note#36) AND isnotnull(movie_id#33)) AND isnotnull(company_type_id#35)) AND isnotnull(company_id#34))

(25) Project
Output [3]: [movie_id#33, company_id#34, company_type_id#35]
Input [4]: [movie_id#33, company_id#34, company_type_id#35, note#36]

(26) Scan parquet spark_catalog.imdb_10x.movie_info
Output [2]: [movie_id#213, info#215]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [In(info, [Denish,Denmark,English,German,Germany,Norway,Norwegian,Sweden,Swedish]), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,info:string>

(27) Filter
Input [2]: [movie_id#213, info#215]
Condition : (info#215 IN (Sweden,Norway,Germany,Denmark,Swedish,Denish,Norwegian,German,English) AND isnotnull(movie_id#213))

(28) Project
Output [1]: [movie_id#213]
Input [2]: [movie_id#213, info#215]

(29) BroadcastExchange
Input [1]: [movie_id#213]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=22549]

(30) BroadcastHashJoin
Left keys [1]: [movie_id#33]
Right keys [1]: [movie_id#213]
Join type: Inner
Join condition: None

(31) Scan parquet spark_catalog.imdb_10x.company_type
Output [2]: [id#30, kind#31]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_type]
PushedFilters: [IsNotNull(kind), EqualTo(kind,production companies), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(32) Filter
Input [2]: [id#30, kind#31]
Condition : ((isnotnull(kind#31) AND (kind#31 = production companies)) AND isnotnull(id#30))

(33) Project
Output [1]: [id#30]
Input [2]: [id#30, kind#31]

(34) BroadcastExchange
Input [1]: [id#30]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=22552]

(35) BroadcastHashJoin
Left keys [1]: [company_type_id#35]
Right keys [1]: [id#30]
Join type: Inner
Join condition: None

(36) Project
Output [3]: [movie_id#33, company_id#34, movie_id#213]
Input [5]: [movie_id#33, company_id#34, company_type_id#35, movie_id#213, id#30]

(37) BroadcastExchange
Input [3]: [movie_id#33, company_id#34, movie_id#213]
Arguments: HashedRelationBroadcastMode(List(cast(input[1, int, true] as bigint)),false), [plan_id=22556]

(38) Scan parquet spark_catalog.imdb_10x.company_name
Output [3]: [id#23, name#24, country_code#25]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(country_code), Not(EqualTo(country_code,[pl])), Or(StringContains(name,Film),StringContains(name,Warner)), IsNotNull(id)]
ReadSchema: struct<id:int,name:string,country_code:string>

(39) Filter
Input [3]: [id#23, name#24, country_code#25]
Condition : (((isnotnull(country_code#25) AND NOT (country_code#25 = [pl])) AND (Contains(name#24, Film) OR Contains(name#24, Warner))) AND isnotnull(id#23))

(40) Project
Output [2]: [id#23, name#24]
Input [3]: [id#23, name#24, country_code#25]

(41) BroadcastHashJoin
Left keys [1]: [company_id#34]
Right keys [1]: [id#23]
Join type: Inner
Join condition: None

(42) Project
Output [3]: [movie_id#33, movie_id#213, name#24]
Input [5]: [movie_id#33, company_id#34, movie_id#213, id#23, name#24]

(43) BroadcastExchange
Input [3]: [movie_id#33, movie_id#213, name#24]
Arguments: HashedRelationBroadcastMode(List(input[0, int, true], input[1, int, true], input[0, int, true], input[1, int, true], input[0, int, true], input[1, int, true]),false), [plan_id=22560]

(44) BroadcastHashJoin
Left keys [6]: [movie_id#116, movie_id#116, movie_id#119, movie_id#119, id#39, id#39]
Right keys [6]: [movie_id#33, movie_id#213, movie_id#33, movie_id#213, movie_id#33, movie_id#213]
Join type: Inner
Join condition: None

(45) BroadcastExchange
Input [8]: [movie_id#116, id#39, title#40, movie_id#119, link#114, movie_id#33, movie_id#213, name#24]
Arguments: HashedRelationBroadcastMode(List(input[5, int, true], input[6, int, true], input[0, int, true], input[3, int, true], input[1, int, true]),false), [plan_id=22570]

(46) Scan parquet spark_catalog.imdb_10x.complete_cast
Output [3]: [movie_id#927, subject_id#928, status_id#929]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/complete_cast]
PushedFilters: [IsNotNull(subject_id), IsNotNull(status_id), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:string,subject_id:int,status_id:int>

(47) Filter
Input [3]: [movie_id#927, subject_id#928, status_id#929]
Condition : ((isnotnull(subject_id#928) AND isnotnull(status_id#929)) AND isnotnull(movie_id#927))

(48) Scan parquet spark_catalog.imdb_10x.comp_cast_type
Output [2]: [id#930, kind#931]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/comp_cast_type]
PushedFilters: [IsNotNull(kind), EqualTo(kind,cast), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(49) Filter
Input [2]: [id#930, kind#931]
Condition : ((isnotnull(kind#931) AND (kind#931 = cast)) AND isnotnull(id#930))

(50) Project
Output [1]: [id#930]
Input [2]: [id#930, kind#931]

(51) BroadcastExchange
Input [1]: [id#930]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=22562]

(52) BroadcastHashJoin
Left keys [1]: [subject_id#928]
Right keys [1]: [id#930]
Join type: Inner
Join condition: None

(53) Project
Output [2]: [movie_id#927, status_id#929]
Input [4]: [movie_id#927, subject_id#928, status_id#929, id#930]

(54) Scan parquet spark_catalog.imdb_10x.comp_cast_type
Output [2]: [id#1448, kind#1449]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/comp_cast_type]
PushedFilters: [IsNotNull(kind), StringStartsWith(kind,complete), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(55) Filter
Input [2]: [id#1448, kind#1449]
Condition : ((isnotnull(kind#1449) AND StartsWith(kind#1449, complete)) AND isnotnull(id#1448))

(56) Project
Output [1]: [id#1448]
Input [2]: [id#1448, kind#1449]

(57) BroadcastExchange
Input [1]: [id#1448]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=22566]

(58) BroadcastHashJoin
Left keys [1]: [status_id#929]
Right keys [1]: [id#1448]
Join type: Inner
Join condition: None

(59) Project
Output [1]: [movie_id#927]
Input [3]: [movie_id#927, status_id#929, id#1448]

(60) BroadcastHashJoin
Left keys [5]: [movie_id#33, movie_id#213, movie_id#116, movie_id#119, id#39]
Right keys [5]: [cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int), cast(movie_id#927 as int)]
Join type: Inner
Join condition: None

(61) Project
Output [3]: [name#24, link#114, title#40]
Input [9]: [movie_id#116, id#39, title#40, movie_id#119, link#114, movie_id#33, movie_id#213, name#24, movie_id#927]

(62) SortAggregate
Input [3]: [name#24, link#114, title#40]
Keys: []
Functions [3]: [partial_min(name#24), partial_min(link#114), partial_min(title#40)]
Aggregate Attributes [3]: [min#1454, min#1455, min#1456]
Results [3]: [min#1457, min#1458, min#1459]

(63) Exchange
Input [3]: [min#1457, min#1458, min#1459]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=22575]

(64) SortAggregate
Input [3]: [min#1457, min#1458, min#1459]
Keys: []
Functions [3]: [min(name#24), min(link#114), min(title#40)]
Aggregate Attributes [3]: [min(name#24)#1451, min(link#114)#1452, min(title#40)#1453]
Results [3]: [min(name#24)#1451 AS producing_company#1440, min(link#114)#1452 AS link_type#1441, min(title#40)#1453 AS complete_western_sequel#1442]

(65) AdaptiveSparkPlan
Output [3]: [producing_company#1440, link_type#1441, complete_western_sequel#1442]
Arguments: isFinalPlan=false
Execution Time: 47.139
