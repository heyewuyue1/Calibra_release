== Physical Plan ==
AdaptiveSparkPlan (57)
+- SortAggregate (56)
   +- Exchange (55)
      +- SortAggregate (54)
         +- Project (53)
            +- BroadcastHashJoin Inner BuildRight (52)
               :- BroadcastHashJoin Inner BuildRight (32)
               :  :- Project (22)
               :  :  +- BroadcastHashJoin Inner BuildRight (21)
               :  :     :- BroadcastHashJoin Inner BuildLeft (16)
               :  :     :  :- BroadcastExchange (13)
               :  :     :  :  +- BroadcastHashJoin Inner BuildLeft (12)
               :  :     :  :     :- BroadcastExchange (9)
               :  :     :  :     :  +- Project (8)
               :  :     :  :     :     +- BroadcastHashJoin Inner BuildRight (7)
               :  :     :  :     :        :- Filter (2)
               :  :     :  :     :        :  +- Scan parquet spark_catalog.imdb_10x.movie_info (1)
               :  :     :  :     :        +- BroadcastExchange (6)
               :  :     :  :     :           +- Project (5)
               :  :     :  :     :              +- Filter (4)
               :  :     :  :     :                 +- Scan parquet spark_catalog.imdb_10x.info_type (3)
               :  :     :  :     +- Filter (11)
               :  :     :  :        +- Scan parquet spark_catalog.imdb_10x.title (10)
               :  :     :  +- Filter (15)
               :  :     :     +- Scan parquet spark_catalog.imdb_10x.movie_info_idx (14)
               :  :     +- BroadcastExchange (20)
               :  :        +- Project (19)
               :  :           +- Filter (18)
               :  :              +- Scan parquet spark_catalog.imdb_10x.info_type (17)
               :  +- BroadcastExchange (31)
               :     +- Project (30)
               :        +- BroadcastHashJoin Inner BuildRight (29)
               :           :- Filter (24)
               :           :  +- Scan parquet spark_catalog.imdb_10x.movie_keyword (23)
               :           +- BroadcastExchange (28)
               :              +- Project (27)
               :                 +- Filter (26)
               :                    +- Scan parquet spark_catalog.imdb_10x.keyword (25)
               +- BroadcastExchange (51)
                  +- Project (50)
                     +- BroadcastHashJoin Inner BuildLeft (49)
                        :- BroadcastExchange (45)
                        :  +- BroadcastHashJoin Inner BuildLeft (44)
                        :     :- BroadcastExchange (41)
                        :     :  +- Project (40)
                        :     :     +- BroadcastHashJoin Inner BuildLeft (39)
                        :     :        :- BroadcastExchange (36)
                        :     :        :  +- Project (35)
                        :     :        :     +- Filter (34)
                        :     :        :        +- Scan parquet spark_catalog.imdb_10x.cast_info (33)
                        :     :        +- Filter (38)
                        :     :           +- Scan parquet spark_catalog.imdb_10x.name (37)
                        :     +- Filter (43)
                        :        +- Scan parquet spark_catalog.imdb_10x.movie_companies (42)
                        +- Project (48)
                           +- Filter (47)
                              +- Scan parquet spark_catalog.imdb_10x.company_name (46)


(1) Scan parquet spark_catalog.imdb_10x.movie_info
Output [3]: [movie_id#213, info_type_id#214, info#215]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [In(info, [Action,Crime,Horror,Sci-Fi,Thriller,War]), IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(2) Filter
Input [3]: [movie_id#213, info_type_id#214, info#215]
Condition : ((info#215 IN (Horror,Action,Sci-Fi,Thriller,Crime,War) AND isnotnull(movie_id#213)) AND isnotnull(info_type_id#214))

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=29436]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=29440]

(10) Scan parquet spark_catalog.imdb_10x.title
Output [2]: [id#39, title#40]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int,title:string>

(11) Filter
Input [2]: [id#39, title#40]
Condition : isnotnull(id#39)

(12) BroadcastHashJoin
Left keys [1]: [movie_id#213]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(13) BroadcastExchange
Input [4]: [movie_id#213, info#215, id#39, title#40]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[2, int, false] as bigint) & 4294967295))),false), [plan_id=29443]

(14) Scan parquet spark_catalog.imdb_10x.movie_info_idx
Output [3]: [movie_id#218, info_type_id#219, info#220]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info_idx]
PushedFilters: [IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(15) Filter
Input [3]: [movie_id#218, info_type_id#219, info#220]
Condition : (isnotnull(movie_id#218) AND isnotnull(info_type_id#219))

(16) BroadcastHashJoin
Left keys [2]: [movie_id#213, id#39]
Right keys [2]: [movie_id#218, movie_id#218]
Join type: Inner
Join condition: None

(17) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#1842, info#1843]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,votes), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(18) Filter
Input [2]: [id#1842, info#1843]
Condition : ((isnotnull(info#1843) AND (info#1843 = votes)) AND isnotnull(id#1842))

(19) Project
Output [1]: [id#1842]
Input [2]: [id#1842, info#1843]

(20) BroadcastExchange
Input [1]: [id#1842]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=29446]

(21) BroadcastHashJoin
Left keys [1]: [info_type_id#219]
Right keys [1]: [id#1842]
Join type: Inner
Join condition: None

(22) Project
Output [6]: [movie_id#213, info#215, id#39, title#40, movie_id#218, info#220]
Input [8]: [movie_id#213, info#215, id#39, title#40, movie_id#218, info_type_id#219, info#220, id#1842]

(23) Scan parquet spark_catalog.imdb_10x.movie_keyword
Output [2]: [movie_id#116, keyword_id#117]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_keyword]
PushedFilters: [IsNotNull(movie_id), IsNotNull(keyword_id)]
ReadSchema: struct<movie_id:int,keyword_id:int>

(24) Filter
Input [2]: [movie_id#116, keyword_id#117]
Condition : (isnotnull(movie_id#116) AND isnotnull(keyword_id#117))

(25) Scan parquet spark_catalog.imdb_10x.keyword
Output [2]: [id#110, keyword#111]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/keyword]
PushedFilters: [In(keyword, [blood,death,female-nudity,gore,hospital,murder,violence]), IsNotNull(id)]
ReadSchema: struct<id:int,keyword:string>

(26) Filter
Input [2]: [id#110, keyword#111]
Condition : (keyword#111 IN (murder,violence,blood,gore,death,female-nudity,hospital) AND isnotnull(id#110))

(27) Project
Output [1]: [id#110]
Input [2]: [id#110, keyword#111]

(28) BroadcastExchange
Input [1]: [id#110]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=29449]

(29) BroadcastHashJoin
Left keys [1]: [keyword_id#117]
Right keys [1]: [id#110]
Join type: Inner
Join condition: None

(30) Project
Output [1]: [movie_id#116]
Input [3]: [movie_id#116, keyword_id#117, id#110]

(31) BroadcastExchange
Input [1]: [movie_id#116]
Arguments: HashedRelationBroadcastMode(List(input[0, int, true], input[0, int, true], input[0, int, true]),false), [plan_id=29453]

(32) BroadcastHashJoin
Left keys [3]: [movie_id#213, movie_id#218, id#39]
Right keys [3]: [movie_id#116, movie_id#116, movie_id#116]
Join type: Inner
Join condition: None

(33) Scan parquet spark_catalog.imdb_10x.cast_info
Output [3]: [person_id#17, movie_id#18, note#20]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/cast_info]
PushedFilters: [In(note, [(head writer),(story editor),(story),(writer),(written by)]), IsNotNull(movie_id), IsNotNull(person_id)]
ReadSchema: struct<person_id:int,movie_id:int,note:string>

(34) Filter
Input [3]: [person_id#17, movie_id#18, note#20]
Condition : ((note#20 IN ((writer),(head writer),(written by),(story),(story editor)) AND isnotnull(movie_id#18)) AND isnotnull(person_id#17))

(35) Project
Output [2]: [person_id#17, movie_id#18]
Input [3]: [person_id#17, movie_id#18, note#20]

(36) BroadcastExchange
Input [2]: [person_id#17, movie_id#18]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=29455]

(37) Scan parquet spark_catalog.imdb_10x.name
Output [2]: [id#540, name#541]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/name]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int,name:string>

(38) Filter
Input [2]: [id#540, name#541]
Condition : isnotnull(id#540)

(39) BroadcastHashJoin
Left keys [1]: [person_id#17]
Right keys [1]: [id#540]
Join type: Inner
Join condition: None

(40) Project
Output [2]: [movie_id#18, name#541]
Input [4]: [person_id#17, movie_id#18, id#540, name#541]

(41) BroadcastExchange
Input [2]: [movie_id#18, name#541]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=29459]

(42) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [2]: [movie_id#33, company_id#34]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(movie_id), IsNotNull(company_id)]
ReadSchema: struct<movie_id:int,company_id:int>

(43) Filter
Input [2]: [movie_id#33, company_id#34]
Condition : (isnotnull(movie_id#33) AND isnotnull(company_id#34))

(44) BroadcastHashJoin
Left keys [1]: [movie_id#18]
Right keys [1]: [movie_id#33]
Join type: Inner
Join condition: None

(45) BroadcastExchange
Input [4]: [movie_id#18, name#541, movie_id#33, company_id#34]
Arguments: HashedRelationBroadcastMode(List(cast(input[3, int, false] as bigint)),false), [plan_id=29462]

(46) Scan parquet spark_catalog.imdb_10x.company_name
Output [2]: [id#23, name#24]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(name), StringStartsWith(name,Lionsgate), IsNotNull(id)]
ReadSchema: struct<id:int,name:string>

(47) Filter
Input [2]: [id#23, name#24]
Condition : ((isnotnull(name#24) AND StartsWith(name#24, Lionsgate)) AND isnotnull(id#23))

(48) Project
Output [1]: [id#23]
Input [2]: [id#23, name#24]

(49) BroadcastHashJoin
Left keys [1]: [company_id#34]
Right keys [1]: [id#23]
Join type: Inner
Join condition: None

(50) Project
Output [3]: [movie_id#18, name#541, movie_id#33]
Input [5]: [movie_id#18, name#541, movie_id#33, company_id#34, id#23]

(51) BroadcastExchange
Input [3]: [movie_id#18, name#541, movie_id#33]
Arguments: HashedRelationBroadcastMode(List(input[0, int, true], input[2, int, true], input[0, int, true], input[2, int, true], input[0, int, true], input[2, int, true], input[0, int, true], input[2, int, true]),false), [plan_id=29466]

(52) BroadcastHashJoin
Left keys [8]: [movie_id#213, movie_id#213, movie_id#218, movie_id#218, movie_id#116, movie_id#116, id#39, id#39]
Right keys [8]: [movie_id#18, movie_id#33, movie_id#18, movie_id#33, movie_id#18, movie_id#33, movie_id#18, movie_id#33]
Join type: Inner
Join condition: None

(53) Project
Output [4]: [info#215, info#220, name#541, title#40]
Input [10]: [movie_id#213, info#215, id#39, title#40, movie_id#218, info#220, movie_id#116, movie_id#18, name#541, movie_id#33]

(54) SortAggregate
Input [4]: [info#215, info#220, name#541, title#40]
Keys: []
Functions [4]: [partial_min(info#215), partial_min(info#220), partial_min(name#541), partial_min(title#40)]
Aggregate Attributes [4]: [min#1849, min#1850, min#1851, min#1852]
Results [4]: [min#1853, min#1854, min#1855, min#1856]

(55) Exchange
Input [4]: [min#1853, min#1854, min#1855, min#1856]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=29471]

(56) SortAggregate
Input [4]: [min#1853, min#1854, min#1855, min#1856]
Keys: []
Functions [4]: [min(info#215), min(info#220), min(name#541), min(title#40)]
Aggregate Attributes [4]: [min(info#215)#1844, min(info#220)#1845, min(name#541)#1846, min(title#40)#1847]
Results [4]: [min(info#215)#1844 AS movie_budget#1833, min(info#220)#1845 AS movie_votes#1834, min(name#541)#1846 AS writer#1835, min(title#40)#1847 AS violent_liongate_movie#1836]

(57) AdaptiveSparkPlan
Output [4]: [movie_budget#1833, movie_votes#1834, writer#1835, violent_liongate_movie#1836]
Arguments: isFinalPlan=false
Execution Time: 68.884
