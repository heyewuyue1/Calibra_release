== Physical Plan ==
AdaptiveSparkPlan (43)
+- SortAggregate (42)
   +- Exchange (41)
      +- SortAggregate (40)
         +- Project (39)
            +- BroadcastHashJoin Inner BuildRight (38)
               :- Project (34)
               :  +- BroadcastHashJoin Inner BuildLeft (33)
               :     :- BroadcastExchange (30)
               :     :  +- Project (29)
               :     :     +- BroadcastHashJoin Inner BuildLeft (28)
               :     :        :- BroadcastExchange (24)
               :     :        :  +- Project (23)
               :     :        :     +- BroadcastHashJoin Inner BuildRight (22)
               :     :        :        :- BroadcastHashJoin Inner BuildLeft (17)
               :     :        :        :  :- BroadcastExchange (14)
               :     :        :        :  :  +- BroadcastHashJoin Inner BuildLeft (13)
               :     :        :        :  :     :- BroadcastExchange (9)
               :     :        :        :  :     :  +- Project (8)
               :     :        :        :  :     :     +- BroadcastHashJoin Inner BuildRight (7)
               :     :        :        :  :     :        :- Filter (2)
               :     :        :        :  :     :        :  +- Scan parquet spark_catalog.imdb_10x.movie_keyword (1)
               :     :        :        :  :     :        +- BroadcastExchange (6)
               :     :        :        :  :     :           +- Project (5)
               :     :        :        :  :     :              +- Filter (4)
               :     :        :        :  :     :                 +- Scan parquet spark_catalog.imdb_10x.keyword (3)
               :     :        :        :  :     +- Project (12)
               :     :        :        :  :        +- Filter (11)
               :     :        :        :  :           +- Scan parquet spark_catalog.imdb_10x.title (10)
               :     :        :        :  +- Filter (16)
               :     :        :        :     +- Scan parquet spark_catalog.imdb_10x.movie_companies (15)
               :     :        :        +- BroadcastExchange (21)
               :     :        :           +- Project (20)
               :     :        :              +- Filter (19)
               :     :        :                 +- Scan parquet spark_catalog.imdb_10x.company_type (18)
               :     :        +- Project (27)
               :     :           +- Filter (26)
               :     :              +- Scan parquet spark_catalog.imdb_10x.company_name (25)
               :     +- Filter (32)
               :        +- Scan parquet spark_catalog.imdb_10x.movie_link (31)
               +- BroadcastExchange (37)
                  +- Filter (36)
                     +- Scan parquet spark_catalog.imdb_10x.link_type (35)


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
PushedFilters: [In(keyword, [based-on-novel,revenge,sequel]), IsNotNull(id)]
ReadSchema: struct<id:int,keyword:string>

(4) Filter
Input [2]: [id#110, keyword#111]
Condition : (keyword#111 IN (sequel,revenge,based-on-novel) AND isnotnull(id#110))

(5) Project
Output [1]: [id#110]
Input [2]: [id#110, keyword#111]

(6) BroadcastExchange
Input [1]: [id#110]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=2061]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=2065]

(10) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#39, title#40, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(11) Filter
Input [3]: [id#39, title#40, production_year#43]
Condition : ((isnotnull(production_year#43) AND (cast(production_year#43 as int) > 1950)) AND isnotnull(id#39))

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
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[1, int, true] as bigint) & 4294967295))),false), [plan_id=2068]

(15) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [4]: [movie_id#33, company_id#34, company_type_id#35, note#36]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(note), IsNotNull(company_id), IsNotNull(company_type_id), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,company_id:int,company_type_id:int,note:string>

(16) Filter
Input [4]: [movie_id#33, company_id#34, company_type_id#35, note#36]
Condition : (((isnotnull(note#36) AND isnotnull(company_id#34)) AND isnotnull(company_type_id#35)) AND isnotnull(movie_id#33))

(17) BroadcastHashJoin
Left keys [2]: [movie_id#116, id#39]
Right keys [2]: [movie_id#33, movie_id#33]
Join type: Inner
Join condition: None

(18) Scan parquet spark_catalog.imdb_10x.company_type
Output [2]: [id#30, kind#31]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_type]
PushedFilters: [Not(EqualTo(kind,production companies)), IsNotNull(kind), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(19) Filter
Input [2]: [id#30, kind#31]
Condition : ((NOT (kind#31 = production companies) AND isnotnull(kind#31)) AND isnotnull(id#30))

(20) Project
Output [1]: [id#30]
Input [2]: [id#30, kind#31]

(21) BroadcastExchange
Input [1]: [id#30]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=2071]

(22) BroadcastHashJoin
Left keys [1]: [company_type_id#35]
Right keys [1]: [id#30]
Join type: Inner
Join condition: None

(23) Project
Output [6]: [movie_id#116, id#39, title#40, movie_id#33, company_id#34, note#36]
Input [8]: [movie_id#116, id#39, title#40, movie_id#33, company_id#34, company_type_id#35, note#36, id#30]

(24) BroadcastExchange
Input [6]: [movie_id#116, id#39, title#40, movie_id#33, company_id#34, note#36]
Arguments: HashedRelationBroadcastMode(List(cast(input[4, int, true] as bigint)),false), [plan_id=2075]

(25) Scan parquet spark_catalog.imdb_10x.company_name
Output [3]: [id#23, name#24, country_code#25]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(country_code), Not(EqualTo(country_code,[pl])), IsNotNull(id)]
ReadSchema: struct<id:int,name:string,country_code:string>

(26) Filter
Input [3]: [id#23, name#24, country_code#25]
Condition : ((isnotnull(country_code#25) AND NOT (country_code#25 = [pl])) AND isnotnull(id#23))

(27) Project
Output [2]: [id#23, name#24]
Input [3]: [id#23, name#24, country_code#25]

(28) BroadcastHashJoin
Left keys [1]: [company_id#34]
Right keys [1]: [id#23]
Join type: Inner
Join condition: None

(29) Project
Output [6]: [movie_id#116, id#39, title#40, movie_id#33, note#36, name#24]
Input [8]: [movie_id#116, id#39, title#40, movie_id#33, company_id#34, note#36, id#23, name#24]

(30) BroadcastExchange
Input [6]: [movie_id#116, id#39, title#40, movie_id#33, note#36, name#24]
Arguments: HashedRelationBroadcastMode(List(input[0, int, true], input[3, int, true], input[1, int, true]),false), [plan_id=2079]

(31) Scan parquet spark_catalog.imdb_10x.movie_link
Output [2]: [movie_id#119, link_type_id#121]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_link]
PushedFilters: [IsNotNull(movie_id), IsNotNull(link_type_id)]
ReadSchema: struct<movie_id:int,link_type_id:int>

(32) Filter
Input [2]: [movie_id#119, link_type_id#121]
Condition : (isnotnull(movie_id#119) AND isnotnull(link_type_id#121))

(33) BroadcastHashJoin
Left keys [3]: [movie_id#116, movie_id#33, id#39]
Right keys [3]: [movie_id#119, movie_id#119, movie_id#119]
Join type: Inner
Join condition: None

(34) Project
Output [4]: [title#40, note#36, name#24, link_type_id#121]
Input [8]: [movie_id#116, id#39, title#40, movie_id#33, note#36, name#24, movie_id#119, link_type_id#121]

(35) Scan parquet spark_catalog.imdb_10x.link_type
Output [1]: [id#113]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/link_type]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int>

(36) Filter
Input [1]: [id#113]
Condition : isnotnull(id#113)

(37) BroadcastExchange
Input [1]: [id#113]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, false] as bigint)),false), [plan_id=2083]

(38) BroadcastHashJoin
Left keys [1]: [link_type_id#121]
Right keys [1]: [id#113]
Join type: Inner
Join condition: None

(39) Project
Output [3]: [name#24, note#36, title#40]
Input [5]: [title#40, note#36, name#24, link_type_id#121, id#113]

(40) SortAggregate
Input [3]: [name#24, note#36, title#40]
Keys: []
Functions [3]: [partial_min(name#24), partial_min(note#36), partial_min(title#40)]
Aggregate Attributes [3]: [min#192, min#193, min#194]
Results [3]: [min#195, min#196, min#197]

(41) Exchange
Input [3]: [min#195, min#196, min#197]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=2088]

(42) SortAggregate
Input [3]: [min#195, min#196, min#197]
Keys: []
Functions [3]: [min(name#24), min(note#36), min(title#40)]
Aggregate Attributes [3]: [min(name#24)#189, min(note#36)#190, min(title#40)#191]
Results [3]: [min(name#24)#189 AS from_company#181, min(note#36)#190 AS production_note#182, min(title#40)#191 AS movie_based_on_book#183]

(43) AdaptiveSparkPlan
Output [3]: [from_company#181, production_note#182, movie_based_on_book#183]
Arguments: isFinalPlan=false
Execution Time: 17.908
