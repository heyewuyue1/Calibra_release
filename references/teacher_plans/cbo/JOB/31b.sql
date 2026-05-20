== Physical Plan ==
AdaptiveSparkPlan (60)
+- SortAggregate (59)
   +- Exchange (58)
      +- SortAggregate (57)
         +- Project (56)
            +- BroadcastHashJoin Inner BuildRight (55)
               :- BroadcastHashJoin Inner BuildRight (44)
               :  :- Project (34)
               :  :  +- BroadcastHashJoin Inner BuildRight (33)
               :  :     :- BroadcastHashJoin Inner BuildLeft (28)
               :  :     :  :- BroadcastExchange (25)
               :  :     :  :  +- Project (24)
               :  :     :  :     +- BroadcastHashJoin Inner BuildLeft (23)
               :  :     :  :        :- BroadcastExchange (19)
               :  :     :  :        :  +- BroadcastHashJoin Inner BuildLeft (18)
               :  :     :  :        :     :- BroadcastExchange (14)
               :  :     :  :        :     :  +- BroadcastHashJoin Inner BuildLeft (13)
               :  :     :  :        :     :     :- BroadcastExchange (9)
               :  :     :  :        :     :     :  +- Project (8)
               :  :     :  :        :     :     :     +- BroadcastHashJoin Inner BuildRight (7)
               :  :     :  :        :     :     :        :- Filter (2)
               :  :     :  :        :     :     :        :  +- Scan parquet spark_catalog.imdb_10x.movie_info (1)
               :  :     :  :        :     :     :        +- BroadcastExchange (6)
               :  :     :  :        :     :     :           +- Project (5)
               :  :     :  :        :     :     :              +- Filter (4)
               :  :     :  :        :     :     :                 +- Scan parquet spark_catalog.imdb_10x.info_type (3)
               :  :     :  :        :     :     +- Project (12)
               :  :     :  :        :     :        +- Filter (11)
               :  :     :  :        :     :           +- Scan parquet spark_catalog.imdb_10x.title (10)
               :  :     :  :        :     +- Project (17)
               :  :     :  :        :        +- Filter (16)
               :  :     :  :        :           +- Scan parquet spark_catalog.imdb_10x.movie_companies (15)
               :  :     :  :        +- Project (22)
               :  :     :  :           +- Filter (21)
               :  :     :  :              +- Scan parquet spark_catalog.imdb_10x.company_name (20)
               :  :     :  +- Filter (27)
               :  :     :     +- Scan parquet spark_catalog.imdb_10x.movie_info_idx (26)
               :  :     +- BroadcastExchange (32)
               :  :        +- Project (31)
               :  :           +- Filter (30)
               :  :              +- Scan parquet spark_catalog.imdb_10x.info_type (29)
               :  +- BroadcastExchange (43)
               :     +- Project (42)
               :        +- BroadcastHashJoin Inner BuildRight (41)
               :           :- Filter (36)
               :           :  +- Scan parquet spark_catalog.imdb_10x.movie_keyword (35)
               :           +- BroadcastExchange (40)
               :              +- Project (39)
               :                 +- Filter (38)
               :                    +- Scan parquet spark_catalog.imdb_10x.keyword (37)
               +- BroadcastExchange (54)
                  +- Project (53)
                     +- BroadcastHashJoin Inner BuildLeft (52)
                        :- BroadcastExchange (48)
                        :  +- Project (47)
                        :     +- Filter (46)
                        :        +- Scan parquet spark_catalog.imdb_10x.cast_info (45)
                        +- Project (51)
                           +- Filter (50)
                              +- Scan parquet spark_catalog.imdb_10x.name (49)


(1) Scan parquet spark_catalog.imdb_10x.movie_info
Output [3]: [movie_id#213, info_type_id#214, info#215]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [In(info, [Horror,Thriller]), IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(2) Filter
Input [3]: [movie_id#213, info_type_id#214, info#215]
Condition : ((info#215 IN (Horror,Thriller) AND isnotnull(movie_id#213)) AND isnotnull(info_type_id#214))

(3) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#210, info#211]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,genres), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(4) Filter
Input [2]: [id#210, info#211]
Condition : ((isnotnull(info#211) AND (info#211 = genres)) AND isnotnull(id#210))

(5) Project
Output [1]: [id#210]
Input [2]: [id#210, info#211]

(6) BroadcastExchange
Input [1]: [id#210]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=29023]

(7) BroadcastHashJoin
Left keys [1]: [info_type_id#214]
Right keys [1]: [id#210]
Join type: Inner
Join condition: None

(8) Project
Output [2]: [movie_id#213, info#215]
Input [4]: [movie_id#213, info_type_id#214, info#215, id#210]

(9) BroadcastExchange
Input [2]: [movie_id#213, info#215]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=29027]

(10) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#39, title#40, production_year#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), Or(Or(StringContains(title,Freddy),StringContains(title,Jason)),StringStartsWith(title,Saw)), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(11) Filter
Input [3]: [id#39, title#40, production_year#43]
Condition : (((isnotnull(production_year#43) AND (cast(production_year#43 as int) > 2000)) AND ((Contains(title#40, Freddy) OR Contains(title#40, Jason)) OR StartsWith(title#40, Saw))) AND isnotnull(id#39))

(12) Project
Output [2]: [id#39, title#40]
Input [3]: [id#39, title#40, production_year#43]

(13) BroadcastHashJoin
Left keys [1]: [movie_id#213]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(14) BroadcastExchange
Input [4]: [movie_id#213, info#215, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[2, int, true] as bigint) & 4294967295))),false), [plan_id=29030]

(15) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [3]: [movie_id#33, company_id#34, note#36]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(note), StringContains(note,(Blu-ray)), IsNotNull(movie_id), IsNotNull(company_id)]
ReadSchema: struct<movie_id:int,company_id:int,note:string>

(16) Filter
Input [3]: [movie_id#33, company_id#34, note#36]
Condition : (((isnotnull(note#36) AND Contains(note#36, (Blu-ray))) AND isnotnull(movie_id#33)) AND isnotnull(company_id#34))

(17) Project
Output [2]: [movie_id#33, company_id#34]
Input [3]: [movie_id#33, company_id#34, note#36]

(18) BroadcastHashJoin
Left keys [2]: [movie_id#213, id#39]
Right keys [2]: [movie_id#33, movie_id#33]
Join type: Inner
Join condition: None

(19) BroadcastExchange
Input [6]: [movie_id#213, info#215, id#39, title#40, movie_id#33, company_id#34]
Arguments: HashedRelationBroadcastMode(List(cast(input[5, int, true] as bigint)),false), [plan_id=29033]

(20) Scan parquet spark_catalog.imdb_10x.company_name
Output [2]: [id#23, name#24]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(name), StringStartsWith(name,Lionsgate), IsNotNull(id)]
ReadSchema: struct<id:int,name:string>

(21) Filter
Input [2]: [id#23, name#24]
Condition : ((isnotnull(name#24) AND StartsWith(name#24, Lionsgate)) AND isnotnull(id#23))

(22) Project
Output [1]: [id#23]
Input [2]: [id#23, name#24]

(23) BroadcastHashJoin
Left keys [1]: [company_id#34]
Right keys [1]: [id#23]
Join type: Inner
Join condition: None

(24) Project
Output [5]: [movie_id#213, info#215, id#39, title#40, movie_id#33]
Input [7]: [movie_id#213, info#215, id#39, title#40, movie_id#33, company_id#34, id#23]

(25) BroadcastExchange
Input [5]: [movie_id#213, info#215, id#39, title#40, movie_id#33]
Arguments: HashedRelationBroadcastMode(List(input[0, int, true], input[4, int, true], input[2, int, true]),false), [plan_id=29037]

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
Left keys [3]: [movie_id#213, movie_id#33, id#39]
Right keys [3]: [movie_id#218, movie_id#218, movie_id#218]
Join type: Inner
Join condition: None

(29) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#1814, info#1815]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,votes), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(30) Filter
Input [2]: [id#1814, info#1815]
Condition : ((isnotnull(info#1815) AND (info#1815 = votes)) AND isnotnull(id#1814))

(31) Project
Output [1]: [id#1814]
Input [2]: [id#1814, info#1815]

(32) BroadcastExchange
Input [1]: [id#1814]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=29040]

(33) BroadcastHashJoin
Left keys [1]: [info_type_id#219]
Right keys [1]: [id#1814]
Join type: Inner
Join condition: None

(34) Project
Output [7]: [movie_id#213, info#215, id#39, title#40, movie_id#33, movie_id#218, info#220]
Input [9]: [movie_id#213, info#215, id#39, title#40, movie_id#33, movie_id#218, info_type_id#219, info#220, id#1814]

(35) Scan parquet spark_catalog.imdb_10x.movie_keyword
Output [2]: [movie_id#116, keyword_id#117]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_keyword]
PushedFilters: [IsNotNull(movie_id), IsNotNull(keyword_id)]
ReadSchema: struct<movie_id:int,keyword_id:int>

(36) Filter
Input [2]: [movie_id#116, keyword_id#117]
Condition : (isnotnull(movie_id#116) AND isnotnull(keyword_id#117))

(37) Scan parquet spark_catalog.imdb_10x.keyword
Output [2]: [id#110, keyword#111]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/keyword]
PushedFilters: [In(keyword, [blood,death,female-nudity,gore,hospital,murder,violence]), IsNotNull(id)]
ReadSchema: struct<id:int,keyword:string>

(38) Filter
Input [2]: [id#110, keyword#111]
Condition : (keyword#111 IN (murder,violence,blood,gore,death,female-nudity,hospital) AND isnotnull(id#110))

(39) Project
Output [1]: [id#110]
Input [2]: [id#110, keyword#111]

(40) BroadcastExchange
Input [1]: [id#110]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=29043]

(41) BroadcastHashJoin
Left keys [1]: [keyword_id#117]
Right keys [1]: [id#110]
Join type: Inner
Join condition: None

(42) Project
Output [1]: [movie_id#116]
Input [3]: [movie_id#116, keyword_id#117, id#110]

(43) BroadcastExchange
Input [1]: [movie_id#116]
Arguments: HashedRelationBroadcastMode(List(input[0, int, true], input[0, int, true], input[0, int, true], input[0, int, true]),false), [plan_id=29047]

(44) BroadcastHashJoin
Left keys [4]: [movie_id#213, movie_id#218, movie_id#33, id#39]
Right keys [4]: [movie_id#116, movie_id#116, movie_id#116, movie_id#116]
Join type: Inner
Join condition: None

(45) Scan parquet spark_catalog.imdb_10x.cast_info
Output [3]: [person_id#17, movie_id#18, note#20]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/cast_info]
PushedFilters: [In(note, [(head writer),(story editor),(story),(writer),(written by)]), IsNotNull(movie_id), IsNotNull(person_id)]
ReadSchema: struct<person_id:int,movie_id:int,note:string>

(46) Filter
Input [3]: [person_id#17, movie_id#18, note#20]
Condition : ((note#20 IN ((writer),(head writer),(written by),(story),(story editor)) AND isnotnull(movie_id#18)) AND isnotnull(person_id#17))

(47) Project
Output [2]: [person_id#17, movie_id#18]
Input [3]: [person_id#17, movie_id#18, note#20]

(48) BroadcastExchange
Input [2]: [person_id#17, movie_id#18]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=29049]

(49) Scan parquet spark_catalog.imdb_10x.name
Output [3]: [id#540, name#541, gender#544]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/name]
PushedFilters: [IsNotNull(gender), EqualTo(gender,m), IsNotNull(id)]
ReadSchema: struct<id:int,name:string,gender:string>

(50) Filter
Input [3]: [id#540, name#541, gender#544]
Condition : ((isnotnull(gender#544) AND (gender#544 = m)) AND isnotnull(id#540))

(51) Project
Output [2]: [id#540, name#541]
Input [3]: [id#540, name#541, gender#544]

(52) BroadcastHashJoin
Left keys [1]: [person_id#17]
Right keys [1]: [id#540]
Join type: Inner
Join condition: None

(53) Project
Output [2]: [movie_id#18, name#541]
Input [4]: [person_id#17, movie_id#18, id#540, name#541]

(54) BroadcastExchange
Input [2]: [movie_id#18, name#541]
Arguments: HashedRelationBroadcastMode(List(input[0, int, true], input[0, int, true], input[0, int, true], input[0, int, true], input[0, int, true]),false), [plan_id=29053]

(55) BroadcastHashJoin
Left keys [5]: [movie_id#33, movie_id#213, movie_id#218, movie_id#116, id#39]
Right keys [5]: [movie_id#18, movie_id#18, movie_id#18, movie_id#18, movie_id#18]
Join type: Inner
Join condition: None

(56) Project
Output [4]: [info#215, info#220, name#541, title#40]
Input [10]: [movie_id#213, info#215, id#39, title#40, movie_id#33, movie_id#218, info#220, movie_id#116, movie_id#18, name#541]

(57) SortAggregate
Input [4]: [info#215, info#220, name#541, title#40]
Keys: []
Functions [4]: [partial_min(info#215), partial_min(info#220), partial_min(name#541), partial_min(title#40)]
Aggregate Attributes [4]: [min#1821, min#1822, min#1823, min#1824]
Results [4]: [min#1825, min#1826, min#1827, min#1828]

(58) Exchange
Input [4]: [min#1825, min#1826, min#1827, min#1828]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=29058]

(59) SortAggregate
Input [4]: [min#1825, min#1826, min#1827, min#1828]
Keys: []
Functions [4]: [min(info#215), min(info#220), min(name#541), min(title#40)]
Aggregate Attributes [4]: [min(info#215)#1817, min(info#220)#1818, min(name#541)#1819, min(title#40)#1820]
Results [4]: [min(info#215)#1817 AS movie_budget#1805, min(info#220)#1818 AS movie_votes#1806, min(name#541)#1819 AS writer#1807, min(title#40)#1820 AS violent_liongate_movie#1808]

(60) AdaptiveSparkPlan
Output [4]: [movie_budget#1805, movie_votes#1806, writer#1807, violent_liongate_movie#1808]
Arguments: isFinalPlan=false
Execution Time: 41.863
