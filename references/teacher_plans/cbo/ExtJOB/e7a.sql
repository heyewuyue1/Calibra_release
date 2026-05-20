26/04/18 03:18:34 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
26/04/18 03:18:34 WARN SparkConf: Note that spark.local.dir will be overridden by the value set by the cluster manager (via SPARK_LOCAL_DIRS in mesos/standalone/kubernetes and LOCAL_DIRS in YARN).
26/04/18 03:18:37 WARN HiveConf: HiveConf of name hive.stats.jdbc.timeout does not exist
26/04/18 03:18:37 WARN HiveConf: HiveConf of name hive.stats.retries.wait does not exist
26/04/18 03:18:40 WARN ObjectStore: Version information not found in metastore. hive.metastore.schema.verification is not enabled so recording the schema version 2.3.0
26/04/18 03:18:40 WARN ObjectStore: setMetaStoreSchemaVersion called but recording version is disabled: version = 2.3.0, comment = Set by MetaStore user@YOUR_HOST
26/04/18 03:18:41 WARN ObjectStore: Failed to get database global_temp, returning NoSuchObjectException
Spark Web UI available at http://YOUR_SPARK_MASTER_HOST:4040
Spark master: spark://YOUR_SPARK_MASTER_HOST:7077, Application Id: app-20260418031835-7172
== Physical Plan ==
AdaptiveSparkPlan (59)
+- SortAggregate (58)
   +- Exchange (57)
      +- SortAggregate (56)
         +- Project (55)
            +- BroadcastHashJoin Inner BuildRight (54)
               :- BroadcastHashJoin Inner BuildRight (49)
               :  :- Project (39)
               :  :  +- BroadcastHashJoin Inner BuildRight (38)
               :  :     :- BroadcastHashJoin Inner BuildLeft (33)
               :  :     :  :- BroadcastExchange (30)
               :  :     :  :  +- Project (29)
               :  :     :  :     +- BroadcastHashJoin Inner BuildLeft (28)
               :  :     :  :        :- BroadcastExchange (24)
               :  :     :  :        :  +- BroadcastHashJoin Inner BuildLeft (23)
               :  :     :  :        :     :- BroadcastExchange (19)
               :  :     :  :        :     :  +- Project (18)
               :  :     :  :        :     :     +- BroadcastHashJoin Inner BuildRight (17)
               :  :     :  :        :     :        :- BroadcastHashJoin Inner BuildLeft (13)
               :  :     :  :        :     :        :  :- BroadcastExchange (9)
               :  :     :  :        :     :        :  :  +- Project (8)
               :  :     :  :        :     :        :  :     +- BroadcastHashJoin Inner BuildRight (7)
               :  :     :  :        :     :        :  :        :- Filter (2)
               :  :     :  :        :     :        :  :        :  +- Scan parquet spark_catalog.imdb_10x.movie_info (1)
               :  :     :  :        :     :        :  :        +- BroadcastExchange (6)
               :  :     :  :        :     :        :  :           +- Project (5)
               :  :     :  :        :     :        :  :              +- Filter (4)
               :  :     :  :        :     :        :  :                 +- Scan parquet spark_catalog.imdb_10x.info_type (3)
               :  :     :  :        :     :        :  +- Project (12)
               :  :     :  :        :     :        :     +- Filter (11)
               :  :     :  :        :     :        :        +- Scan parquet spark_catalog.imdb_10x.title (10)
               :  :     :  :        :     :        +- BroadcastExchange (16)
               :  :     :  :        :     :           +- Filter (15)
               :  :     :  :        :     :              +- Scan parquet spark_catalog.imdb_10x.kind_type (14)
               :  :     :  :        :     +- Project (22)
               :  :     :  :        :        +- Filter (21)
               :  :     :  :        :           +- Scan parquet spark_catalog.imdb_10x.movie_companies (20)
               :  :     :  :        +- Project (27)
               :  :     :  :           +- Filter (26)
               :  :     :  :              +- Scan parquet spark_catalog.imdb_10x.company_name (25)
               :  :     :  +- Filter (32)
               :  :     :     +- Scan parquet spark_catalog.imdb_10x.movie_info_idx (31)
               :  :     +- BroadcastExchange (37)
               :  :        +- Project (36)
               :  :           +- Filter (35)
               :  :              +- Scan parquet spark_catalog.imdb_10x.info_type (34)
               :  +- BroadcastExchange (48)
               :     +- Project (47)
               :        +- BroadcastHashJoin Inner BuildRight (46)
               :           :- Filter (41)
               :           :  +- Scan parquet spark_catalog.imdb_10x.movie_keyword (40)
               :           +- BroadcastExchange (45)
               :              +- Project (44)
               :                 +- Filter (43)
               :                    +- Scan parquet spark_catalog.imdb_10x.keyword (42)
               +- BroadcastExchange (53)
                  +- Project (52)
                     +- Filter (51)
                        +- Scan parquet spark_catalog.imdb_10x.cast_info (50)


(1) Scan parquet spark_catalog.imdb_10x.movie_info
Output [3]: [movie_id#34, info_type_id#35, info#36]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [In(info, [Horror,Thriller]), IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(2) Filter
Input [3]: [movie_id#34, info_type_id#35, info#36]
Condition : ((info#36 IN (Horror,Thriller) AND isnotnull(movie_id#34)) AND isnotnull(info_type_id#35))

(3) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#23, info#24]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,genres), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(4) Filter
Input [2]: [id#23, info#24]
Condition : ((isnotnull(info#24) AND (info#24 = genres)) AND isnotnull(id#23))

(5) Project
Output [1]: [id#23]
Input [2]: [id#23, info#24]

(6) BroadcastExchange
Input [1]: [id#23]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=350]

(7) BroadcastHashJoin
Left keys [1]: [info_type_id#35]
Right keys [1]: [id#23]
Join type: Inner
Join condition: None

(8) Project
Output [2]: [movie_id#34, info#36]
Input [4]: [movie_id#34, info_type_id#35, info#36, id#23]

(9) BroadcastExchange
Input [2]: [movie_id#34, info#36]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=354]

(10) Scan parquet spark_catalog.imdb_10x.title
Output [4]: [id#46, title#47, kind_id#49, production_year#50]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id), IsNotNull(kind_id)]
ReadSchema: struct<id:int,title:string,kind_id:int,production_year:string>

(11) Filter
Input [4]: [id#46, title#47, kind_id#49, production_year#50]
Condition : (((isnotnull(production_year#50) AND (cast(production_year#50 as int) > 2000)) AND isnotnull(id#46)) AND isnotnull(kind_id#49))

(12) Project
Output [3]: [id#46, title#47, kind_id#49]
Input [4]: [id#46, title#47, kind_id#49, production_year#50]

(13) BroadcastHashJoin
Left keys [1]: [movie_id#34]
Right keys [1]: [id#46]
Join type: Inner
Join condition: None

(14) Scan parquet spark_catalog.imdb_10x.kind_type
Output [2]: [id#58, kind#59]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/kind_type]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(15) Filter
Input [2]: [id#58, kind#59]
Condition : isnotnull(id#58)

(16) BroadcastExchange
Input [2]: [id#58, kind#59]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, false] as bigint)),false), [plan_id=357]

(17) BroadcastHashJoin
Left keys [1]: [kind_id#49]
Right keys [1]: [id#58]
Join type: Inner
Join condition: None

(18) Project
Output [5]: [movie_id#34, info#36, id#46, title#47, kind#59]
Input [7]: [movie_id#34, info#36, id#46, title#47, kind_id#49, id#58, kind#59]

(19) BroadcastExchange
Input [5]: [movie_id#34, info#36, id#46, title#47, kind#59]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[2, int, true] as bigint) & 4294967295))),false), [plan_id=361]

(20) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [3]: [movie_id#29, company_id#30, note#32]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(note), StringContains(note,(Blu-ray)), IsNotNull(movie_id), IsNotNull(company_id)]
ReadSchema: struct<movie_id:int,company_id:int,note:string>

(21) Filter
Input [3]: [movie_id#29, company_id#30, note#32]
Condition : (((isnotnull(note#32) AND Contains(note#32, (Blu-ray))) AND isnotnull(movie_id#29)) AND isnotnull(company_id#30))

(22) Project
Output [2]: [movie_id#29, company_id#30]
Input [3]: [movie_id#29, company_id#30, note#32]

(23) BroadcastHashJoin
Left keys [2]: [movie_id#34, id#46]
Right keys [2]: [movie_id#29, movie_id#29]
Join type: Inner
Join condition: None

(24) BroadcastExchange
Input [7]: [movie_id#34, info#36, id#46, title#47, kind#59, movie_id#29, company_id#30]
Arguments: HashedRelationBroadcastMode(List(cast(input[6, int, true] as bigint)),false), [plan_id=364]

(25) Scan parquet spark_catalog.imdb_10x.company_name
Output [2]: [id#16, country_code#18]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(country_code), EqualTo(country_code,[hk]), IsNotNull(id)]
ReadSchema: struct<id:int,country_code:string>

(26) Filter
Input [2]: [id#16, country_code#18]
Condition : ((isnotnull(country_code#18) AND (country_code#18 = [hk])) AND isnotnull(id#16))

(27) Project
Output [1]: [id#16]
Input [2]: [id#16, country_code#18]

(28) BroadcastHashJoin
Left keys [1]: [company_id#30]
Right keys [1]: [id#16]
Join type: Inner
Join condition: None

(29) Project
Output [6]: [movie_id#34, info#36, id#46, title#47, kind#59, movie_id#29]
Input [8]: [movie_id#34, info#36, id#46, title#47, kind#59, movie_id#29, company_id#30, id#16]

(30) BroadcastExchange
Input [6]: [movie_id#34, info#36, id#46, title#47, kind#59, movie_id#29]
Arguments: HashedRelationBroadcastMode(List(input[0, int, true], input[5, int, true], input[2, int, true]),false), [plan_id=368]

(31) Scan parquet spark_catalog.imdb_10x.movie_info_idx
Output [3]: [movie_id#39, info_type_id#40, info#41]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info_idx]
PushedFilters: [IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(32) Filter
Input [3]: [movie_id#39, info_type_id#40, info#41]
Condition : (isnotnull(movie_id#39) AND isnotnull(info_type_id#40))

(33) BroadcastHashJoin
Left keys [3]: [movie_id#34, movie_id#29, id#46]
Right keys [3]: [movie_id#39, movie_id#39, movie_id#39]
Join type: Inner
Join condition: None

(34) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#60, info#61]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,votes), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(35) Filter
Input [2]: [id#60, info#61]
Condition : ((isnotnull(info#61) AND (info#61 = votes)) AND isnotnull(id#60))

(36) Project
Output [1]: [id#60]
Input [2]: [id#60, info#61]

(37) BroadcastExchange
Input [1]: [id#60]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=371]

(38) BroadcastHashJoin
Left keys [1]: [info_type_id#40]
Right keys [1]: [id#60]
Join type: Inner
Join condition: None

(39) Project
Output [8]: [movie_id#34, info#36, id#46, title#47, kind#59, movie_id#29, movie_id#39, info#41]
Input [10]: [movie_id#34, info#36, id#46, title#47, kind#59, movie_id#29, movie_id#39, info_type_id#40, info#41, id#60]

(40) Scan parquet spark_catalog.imdb_10x.movie_keyword
Output [2]: [movie_id#44, keyword_id#45]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_keyword]
PushedFilters: [IsNotNull(movie_id), IsNotNull(keyword_id)]
ReadSchema: struct<movie_id:int,keyword_id:int>

(41) Filter
Input [2]: [movie_id#44, keyword_id#45]
Condition : (isnotnull(movie_id#44) AND isnotnull(keyword_id#45))

(42) Scan parquet spark_catalog.imdb_10x.keyword
Output [2]: [id#25, keyword#26]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/keyword]
PushedFilters: [In(keyword, [blood,death,female-nudity,gore,hospital,murder,violence]), IsNotNull(id)]
ReadSchema: struct<id:int,keyword:string>

(43) Filter
Input [2]: [id#25, keyword#26]
Condition : (keyword#26 IN (murder,violence,blood,gore,death,female-nudity,hospital) AND isnotnull(id#25))

(44) Project
Output [1]: [id#25]
Input [2]: [id#25, keyword#26]

(45) BroadcastExchange
Input [1]: [id#25]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=374]

(46) BroadcastHashJoin
Left keys [1]: [keyword_id#45]
Right keys [1]: [id#25]
Join type: Inner
Join condition: None

(47) Project
Output [1]: [movie_id#44]
Input [3]: [movie_id#44, keyword_id#45, id#25]

(48) BroadcastExchange
Input [1]: [movie_id#44]
Arguments: HashedRelationBroadcastMode(List(input[0, int, true], input[0, int, true], input[0, int, true], input[0, int, true]),false), [plan_id=378]

(49) BroadcastHashJoin
Left keys [4]: [movie_id#34, movie_id#39, movie_id#29, id#46]
Right keys [4]: [movie_id#44, movie_id#44, movie_id#44, movie_id#44]
Join type: Inner
Join condition: None

(50) Scan parquet spark_catalog.imdb_10x.cast_info
Output [2]: [movie_id#11, note#13]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/cast_info]
PushedFilters: [In(note, [(head writer),(story editor),(story),(writer),(written by)]), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,note:string>

(51) Filter
Input [2]: [movie_id#11, note#13]
Condition : (note#13 IN ((writer),(head writer),(written by),(story),(story editor)) AND isnotnull(movie_id#11))

(52) Project
Output [1]: [movie_id#11]
Input [2]: [movie_id#11, note#13]

(53) BroadcastExchange
Input [1]: [movie_id#11]
Arguments: HashedRelationBroadcastMode(List(input[0, int, true], input[0, int, true], input[0, int, true], input[0, int, true], input[0, int, true]),false), [plan_id=381]

(54) BroadcastHashJoin
Left keys [5]: [movie_id#29, movie_id#34, movie_id#39, movie_id#44, id#46]
Right keys [5]: [movie_id#11, movie_id#11, movie_id#11, movie_id#11, movie_id#11]
Join type: Inner
Join condition: None

(55) Project
Output [4]: [info#36, info#41, title#47, kind#59]
Input [10]: [movie_id#34, info#36, id#46, title#47, kind#59, movie_id#29, movie_id#39, info#41, movie_id#44, movie_id#11]

(56) SortAggregate
Input [4]: [info#36, info#41, title#47, kind#59]
Keys: []
Functions [4]: [partial_min(info#36), partial_min(info#41), partial_min(kind#59), partial_min(title#47)]
Aggregate Attributes [4]: [min#77, min#78, min#79, min#80]
Results [4]: [min#81, min#82, min#83, min#84]

(57) Exchange
Input [4]: [min#81, min#82, min#83, min#84]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=386]

(58) SortAggregate
Input [4]: [min#81, min#82, min#83, min#84]
Keys: []
Functions [4]: [min(info#36), min(info#41), min(kind#59), min(title#47)]
Aggregate Attributes [4]: [min(info#36)#73, min(info#41)#74, min(kind#59)#75, min(title#47)#76]
Results [4]: [min(info#36)#73 AS movie_budget#0, min(info#41)#74 AS movie_votes#1, min(kind#59)#75 AS movie_type#2, min(title#47)#76 AS violent_movie#3]

(59) AdaptiveSparkPlan
Output [4]: [movie_budget#0, movie_votes#1, movie_type#2, violent_movie#3]
Arguments: isFinalPlan=false


Time taken: 4.185 seconds, Fetched 1 row(s)
