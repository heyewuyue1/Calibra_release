== Physical Plan ==
AdaptiveSparkPlan (58)
+- SortAggregate (57)
   +- Exchange (56)
      +- SortAggregate (55)
         +- Project (54)
            +- BroadcastHashJoin Inner BuildRight (53)
               :- BroadcastHashJoin Inner BuildRight (42)
               :  :- Project (32)
               :  :  +- BroadcastHashJoin Inner BuildRight (31)
               :  :     :- BroadcastHashJoin Inner BuildLeft (26)
               :  :     :  :- BroadcastExchange (23)
               :  :     :  :  +- Project (22)
               :  :     :  :     +- BroadcastHashJoin Inner BuildLeft (21)
               :  :     :  :        :- BroadcastExchange (17)
               :  :     :  :        :  +- BroadcastHashJoin Inner BuildLeft (16)
               :  :     :  :        :     :- BroadcastExchange (13)
               :  :     :  :        :     :  +- BroadcastHashJoin Inner BuildLeft (12)
               :  :     :  :        :     :     :- BroadcastExchange (9)
               :  :     :  :        :     :     :  +- Project (8)
               :  :     :  :        :     :     :     +- BroadcastHashJoin Inner BuildRight (7)
               :  :     :  :        :     :     :        :- Filter (2)
               :  :     :  :        :     :     :        :  +- Scan parquet spark_catalog.imdb_10x.movie_info (1)
               :  :     :  :        :     :     :        +- BroadcastExchange (6)
               :  :     :  :        :     :     :           +- Project (5)
               :  :     :  :        :     :     :              +- Filter (4)
               :  :     :  :        :     :     :                 +- Scan parquet spark_catalog.imdb_10x.info_type (3)
               :  :     :  :        :     :     +- Filter (11)
               :  :     :  :        :     :        +- Scan parquet spark_catalog.imdb_10x.title (10)
               :  :     :  :        :     +- Filter (15)
               :  :     :  :        :        +- Scan parquet spark_catalog.imdb_10x.movie_companies (14)
               :  :     :  :        +- Project (20)
               :  :     :  :           +- Filter (19)
               :  :     :  :              +- Scan parquet spark_catalog.imdb_10x.company_name (18)
               :  :     :  +- Filter (25)
               :  :     :     +- Scan parquet spark_catalog.imdb_10x.movie_info_idx (24)
               :  :     +- BroadcastExchange (30)
               :  :        +- Project (29)
               :  :           +- Filter (28)
               :  :              +- Scan parquet spark_catalog.imdb_10x.info_type (27)
               :  +- BroadcastExchange (41)
               :     +- Project (40)
               :        +- BroadcastHashJoin Inner BuildRight (39)
               :           :- Filter (34)
               :           :  +- Scan parquet spark_catalog.imdb_10x.movie_keyword (33)
               :           +- BroadcastExchange (38)
               :              +- Project (37)
               :                 +- Filter (36)
               :                    +- Scan parquet spark_catalog.imdb_10x.keyword (35)
               +- BroadcastExchange (52)
                  +- Project (51)
                     +- BroadcastHashJoin Inner BuildLeft (50)
                        :- BroadcastExchange (46)
                        :  +- Project (45)
                        :     +- Filter (44)
                        :        +- Scan parquet spark_catalog.imdb_10x.cast_info (43)
                        +- Project (49)
                           +- Filter (48)
                              +- Scan parquet spark_catalog.imdb_10x.name (47)


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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=28612]

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
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=28616]

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
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[2, int, false] as bigint) & 4294967295))),false), [plan_id=28619]

(14) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [2]: [movie_id#33, company_id#34]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(movie_id), IsNotNull(company_id)]
ReadSchema: struct<movie_id:int,company_id:int>

(15) Filter
Input [2]: [movie_id#33, company_id#34]
Condition : (isnotnull(movie_id#33) AND isnotnull(company_id#34))

(16) BroadcastHashJoin
Left keys [2]: [movie_id#213, id#39]
Right keys [2]: [movie_id#33, movie_id#33]
Join type: Inner
Join condition: None

(17) BroadcastExchange
Input [6]: [movie_id#213, info#215, id#39, title#40, movie_id#33, company_id#34]
Arguments: HashedRelationBroadcastMode(List(cast(input[5, int, false] as bigint)),false), [plan_id=28622]

(18) Scan parquet spark_catalog.imdb_10x.company_name
Output [2]: [id#23, name#24]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(name), StringStartsWith(name,Lionsgate), IsNotNull(id)]
ReadSchema: struct<id:int,name:string>

(19) Filter
Input [2]: [id#23, name#24]
Condition : ((isnotnull(name#24) AND StartsWith(name#24, Lionsgate)) AND isnotnull(id#23))

(20) Project
Output [1]: [id#23]
Input [2]: [id#23, name#24]

(21) BroadcastHashJoin
Left keys [1]: [company_id#34]
Right keys [1]: [id#23]
Join type: Inner
Join condition: None

(22) Project
Output [5]: [movie_id#213, info#215, id#39, title#40, movie_id#33]
Input [7]: [movie_id#213, info#215, id#39, title#40, movie_id#33, company_id#34, id#23]

(23) BroadcastExchange
Input [5]: [movie_id#213, info#215, id#39, title#40, movie_id#33]
Arguments: HashedRelationBroadcastMode(List(input[0, int, true], input[4, int, true], input[2, int, true]),false), [plan_id=28626]

(24) Scan parquet spark_catalog.imdb_10x.movie_info_idx
Output [3]: [movie_id#218, info_type_id#219, info#220]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info_idx]
PushedFilters: [IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(25) Filter
Input [3]: [movie_id#218, info_type_id#219, info#220]
Condition : (isnotnull(movie_id#218) AND isnotnull(info_type_id#219))

(26) BroadcastHashJoin
Left keys [3]: [movie_id#213, movie_id#33, id#39]
Right keys [3]: [movie_id#218, movie_id#218, movie_id#218]
Join type: Inner
Join condition: None

(27) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#1786, info#1787]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,votes), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(28) Filter
Input [2]: [id#1786, info#1787]
Condition : ((isnotnull(info#1787) AND (info#1787 = votes)) AND isnotnull(id#1786))

(29) Project
Output [1]: [id#1786]
Input [2]: [id#1786, info#1787]

(30) BroadcastExchange
Input [1]: [id#1786]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=28629]

(31) BroadcastHashJoin
Left keys [1]: [info_type_id#219]
Right keys [1]: [id#1786]
Join type: Inner
Join condition: None

(32) Project
Output [7]: [movie_id#213, info#215, id#39, title#40, movie_id#33, movie_id#218, info#220]
Input [9]: [movie_id#213, info#215, id#39, title#40, movie_id#33, movie_id#218, info_type_id#219, info#220, id#1786]

(33) Scan parquet spark_catalog.imdb_10x.movie_keyword
Output [2]: [movie_id#116, keyword_id#117]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_keyword]
PushedFilters: [IsNotNull(movie_id), IsNotNull(keyword_id)]
ReadSchema: struct<movie_id:int,keyword_id:int>

(34) Filter
Input [2]: [movie_id#116, keyword_id#117]
Condition : (isnotnull(movie_id#116) AND isnotnull(keyword_id#117))

(35) Scan parquet spark_catalog.imdb_10x.keyword
Output [2]: [id#110, keyword#111]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/keyword]
PushedFilters: [In(keyword, [blood,death,female-nudity,gore,hospital,murder,violence]), IsNotNull(id)]
ReadSchema: struct<id:int,keyword:string>

(36) Filter
Input [2]: [id#110, keyword#111]
Condition : (keyword#111 IN (murder,violence,blood,gore,death,female-nudity,hospital) AND isnotnull(id#110))

(37) Project
Output [1]: [id#110]
Input [2]: [id#110, keyword#111]

(38) BroadcastExchange
Input [1]: [id#110]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=28632]

(39) BroadcastHashJoin
Left keys [1]: [keyword_id#117]
Right keys [1]: [id#110]
Join type: Inner
Join condition: None

(40) Project
Output [1]: [movie_id#116]
Input [3]: [movie_id#116, keyword_id#117, id#110]

(41) BroadcastExchange
Input [1]: [movie_id#116]
Arguments: HashedRelationBroadcastMode(List(input[0, int, true], input[0, int, true], input[0, int, true], input[0, int, true]),false), [plan_id=28636]

(42) BroadcastHashJoin
Left keys [4]: [movie_id#213, movie_id#218, movie_id#33, id#39]
Right keys [4]: [movie_id#116, movie_id#116, movie_id#116, movie_id#116]
Join type: Inner
Join condition: None

(43) Scan parquet spark_catalog.imdb_10x.cast_info
Output [3]: [person_id#17, movie_id#18, note#20]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/cast_info]
PushedFilters: [In(note, [(head writer),(story editor),(story),(writer),(written by)]), IsNotNull(movie_id), IsNotNull(person_id)]
ReadSchema: struct<person_id:int,movie_id:int,note:string>

(44) Filter
Input [3]: [person_id#17, movie_id#18, note#20]
Condition : ((note#20 IN ((writer),(head writer),(written by),(story),(story editor)) AND isnotnull(movie_id#18)) AND isnotnull(person_id#17))

(45) Project
Output [2]: [person_id#17, movie_id#18]
Input [3]: [person_id#17, movie_id#18, note#20]

(46) BroadcastExchange
Input [2]: [person_id#17, movie_id#18]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=28638]

(47) Scan parquet spark_catalog.imdb_10x.name
Output [3]: [id#540, name#541, gender#544]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/name]
PushedFilters: [IsNotNull(gender), EqualTo(gender,m), IsNotNull(id)]
ReadSchema: struct<id:int,name:string,gender:string>

(48) Filter
Input [3]: [id#540, name#541, gender#544]
Condition : ((isnotnull(gender#544) AND (gender#544 = m)) AND isnotnull(id#540))

(49) Project
Output [2]: [id#540, name#541]
Input [3]: [id#540, name#541, gender#544]

(50) BroadcastHashJoin
Left keys [1]: [person_id#17]
Right keys [1]: [id#540]
Join type: Inner
Join condition: None

(51) Project
Output [2]: [movie_id#18, name#541]
Input [4]: [person_id#17, movie_id#18, id#540, name#541]

(52) BroadcastExchange
Input [2]: [movie_id#18, name#541]
Arguments: HashedRelationBroadcastMode(List(input[0, int, true], input[0, int, true], input[0, int, true], input[0, int, true], input[0, int, true]),false), [plan_id=28642]

(53) BroadcastHashJoin
Left keys [5]: [movie_id#33, movie_id#213, movie_id#218, movie_id#116, id#39]
Right keys [5]: [movie_id#18, movie_id#18, movie_id#18, movie_id#18, movie_id#18]
Join type: Inner
Join condition: None

(54) Project
Output [4]: [info#215, info#220, name#541, title#40]
Input [10]: [movie_id#213, info#215, id#39, title#40, movie_id#33, movie_id#218, info#220, movie_id#116, movie_id#18, name#541]

(55) SortAggregate
Input [4]: [info#215, info#220, name#541, title#40]
Keys: []
Functions [4]: [partial_min(info#215), partial_min(info#220), partial_min(name#541), partial_min(title#40)]
Aggregate Attributes [4]: [min#1793, min#1794, min#1795, min#1796]
Results [4]: [min#1797, min#1798, min#1799, min#1800]

(56) Exchange
Input [4]: [min#1797, min#1798, min#1799, min#1800]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=28647]

(57) SortAggregate
Input [4]: [min#1797, min#1798, min#1799, min#1800]
Keys: []
Functions [4]: [min(info#215), min(info#220), min(name#541), min(title#40)]
Aggregate Attributes [4]: [min(info#215)#1788, min(info#220)#1789, min(name#541)#1790, min(title#40)#1791]
Results [4]: [min(info#215)#1788 AS movie_budget#1777, min(info#220)#1789 AS movie_votes#1778, min(name#541)#1790 AS writer#1779, min(title#40)#1791 AS violent_liongate_movie#1780]

(58) AdaptiveSparkPlan
Output [4]: [movie_budget#1777, movie_votes#1778, writer#1779, violent_liongate_movie#1780]
Arguments: isFinalPlan=false
Execution Time: 43.33
