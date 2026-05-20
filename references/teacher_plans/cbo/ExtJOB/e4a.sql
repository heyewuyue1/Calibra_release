26/04/18 03:14:58 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
26/04/18 03:14:58 WARN SparkConf: Note that spark.local.dir will be overridden by the value set by the cluster manager (via SPARK_LOCAL_DIRS in mesos/standalone/kubernetes and LOCAL_DIRS in YARN).
26/04/18 03:15:01 WARN HiveConf: HiveConf of name hive.stats.jdbc.timeout does not exist
26/04/18 03:15:01 WARN HiveConf: HiveConf of name hive.stats.retries.wait does not exist
26/04/18 03:15:04 WARN ObjectStore: Version information not found in metastore. hive.metastore.schema.verification is not enabled so recording the schema version 2.3.0
26/04/18 03:15:04 WARN ObjectStore: setMetaStoreSchemaVersion called but recording version is disabled: version = 2.3.0, comment = Set by MetaStore user@YOUR_HOST
26/04/18 03:15:05 WARN ObjectStore: Failed to get database global_temp, returning NoSuchObjectException
Spark Web UI available at http://YOUR_SPARK_MASTER_HOST:4040
Spark master: spark://YOUR_SPARK_MASTER_HOST:7077, Application Id: app-20260418031459-7160
== Physical Plan ==
AdaptiveSparkPlan (46)
+- SortAggregate (45)
   +- Exchange (44)
      +- SortAggregate (43)
         +- Project (42)
            +- SortMergeJoin Inner (41)
               :- Sort (36)
               :  +- Exchange (35)
               :     +- Project (34)
               :        +- BroadcastHashJoin Inner BuildRight (33)
               :           :- BroadcastHashJoin Inner BuildLeft (28)
               :           :  :- BroadcastExchange (25)
               :           :  :  +- Project (24)
               :           :  :     +- BroadcastHashJoin Inner BuildRight (23)
               :           :  :        :- BroadcastHashJoin Inner BuildLeft (18)
               :           :  :        :  :- BroadcastExchange (15)
               :           :  :        :  :  +- Project (14)
               :           :  :        :  :     +- BroadcastHashJoin Inner BuildRight (13)
               :           :  :        :  :        :- Project (8)
               :           :  :        :  :        :  +- BroadcastHashJoin Inner BuildLeft (7)
               :           :  :        :  :        :     :- BroadcastExchange (4)
               :           :  :        :  :        :     :  +- Project (3)
               :           :  :        :  :        :     :     +- Filter (2)
               :           :  :        :  :        :     :        +- Scan parquet spark_catalog.imdb_10x.company_name (1)
               :           :  :        :  :        :     +- Filter (6)
               :           :  :        :  :        :        +- Scan parquet spark_catalog.imdb_10x.movie_companies (5)
               :           :  :        :  :        +- BroadcastExchange (12)
               :           :  :        :  :           +- Project (11)
               :           :  :        :  :              +- Filter (10)
               :           :  :        :  :                 +- Scan parquet spark_catalog.imdb_10x.company_type (9)
               :           :  :        :  +- Filter (17)
               :           :  :        :     +- Scan parquet spark_catalog.imdb_10x.title (16)
               :           :  :        +- BroadcastExchange (22)
               :           :  :           +- Project (21)
               :           :  :              +- Filter (20)
               :           :  :                 +- Scan parquet spark_catalog.imdb_10x.kind_type (19)
               :           :  +- Filter (27)
               :           :     +- Scan parquet spark_catalog.imdb_10x.movie_info_idx (26)
               :           +- BroadcastExchange (32)
               :              +- Project (31)
               :                 +- Filter (30)
               :                    +- Scan parquet spark_catalog.imdb_10x.info_type (29)
               +- Sort (40)
                  +- Exchange (39)
                     +- Filter (38)
                        +- Scan parquet spark_catalog.imdb_10x.movie_info (37)


(1) Scan parquet spark_catalog.imdb_10x.company_name
Output [2]: [id#8, country_code#10]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_name]
PushedFilters: [IsNotNull(country_code), EqualTo(country_code,[hk]), IsNotNull(id)]
ReadSchema: struct<id:int,country_code:string>

(2) Filter
Input [2]: [id#8, country_code#10]
Condition : ((isnotnull(country_code#10) AND (country_code#10 = [hk])) AND isnotnull(id#8))

(3) Project
Output [1]: [id#8]
Input [2]: [id#8, country_code#10]

(4) BroadcastExchange
Input [1]: [id#8]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=269]

(5) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [3]: [movie_id#22, company_id#23, company_type_id#24]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(company_id), IsNotNull(company_type_id), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,company_id:int,company_type_id:int>

(6) Filter
Input [3]: [movie_id#22, company_id#23, company_type_id#24]
Condition : ((isnotnull(company_id#23) AND isnotnull(company_type_id#24)) AND isnotnull(movie_id#22))

(7) BroadcastHashJoin
Left keys [1]: [id#8]
Right keys [1]: [company_id#23]
Join type: Inner
Join condition: None

(8) Project
Output [2]: [movie_id#22, company_type_id#24]
Input [4]: [id#8, movie_id#22, company_id#23, company_type_id#24]

(9) Scan parquet spark_catalog.imdb_10x.company_type
Output [2]: [id#15, kind#16]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_type]
PushedFilters: [IsNotNull(kind), EqualTo(kind,production companies), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(10) Filter
Input [2]: [id#15, kind#16]
Condition : ((isnotnull(kind#16) AND (kind#16 = production companies)) AND isnotnull(id#15))

(11) Project
Output [1]: [id#15]
Input [2]: [id#15, kind#16]

(12) BroadcastExchange
Input [1]: [id#15]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=273]

(13) BroadcastHashJoin
Left keys [1]: [company_type_id#24]
Right keys [1]: [id#15]
Join type: Inner
Join condition: None

(14) Project
Output [1]: [movie_id#22]
Input [3]: [movie_id#22, company_type_id#24, id#15]

(15) BroadcastExchange
Input [1]: [movie_id#22]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=277]

(16) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#36, title#37, kind_id#39]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(id), IsNotNull(kind_id)]
ReadSchema: struct<id:int,title:string,kind_id:int>

(17) Filter
Input [3]: [id#36, title#37, kind_id#39]
Condition : (isnotnull(id#36) AND isnotnull(kind_id#39))

(18) BroadcastHashJoin
Left keys [1]: [movie_id#22]
Right keys [1]: [id#36]
Join type: Inner
Join condition: None

(19) Scan parquet spark_catalog.imdb_10x.kind_type
Output [2]: [id#19, kind#20]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/kind_type]
PushedFilters: [IsNotNull(kind), EqualTo(kind,movie), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(20) Filter
Input [2]: [id#19, kind#20]
Condition : ((isnotnull(kind#20) AND (kind#20 = movie)) AND isnotnull(id#19))

(21) Project
Output [1]: [id#19]
Input [2]: [id#19, kind#20]

(22) BroadcastExchange
Input [1]: [id#19]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=280]

(23) BroadcastHashJoin
Left keys [1]: [kind_id#39]
Right keys [1]: [id#19]
Join type: Inner
Join condition: None

(24) Project
Output [3]: [movie_id#22, id#36, title#37]
Input [5]: [movie_id#22, id#36, title#37, kind_id#39, id#19]

(25) BroadcastExchange
Input [3]: [movie_id#22, id#36, title#37]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[1, int, true] as bigint) & 4294967295))),false), [plan_id=284]

(26) Scan parquet spark_catalog.imdb_10x.movie_info_idx
Output [3]: [movie_id#32, info_type_id#33, info#34]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info_idx]
PushedFilters: [IsNotNull(movie_id), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(27) Filter
Input [3]: [movie_id#32, info_type_id#33, info#34]
Condition : (isnotnull(movie_id#32) AND isnotnull(info_type_id#33))

(28) BroadcastHashJoin
Left keys [2]: [movie_id#22, id#36]
Right keys [2]: [movie_id#32, movie_id#32]
Join type: Inner
Join condition: None

(29) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#17, info#18]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), EqualTo(info,rating), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(30) Filter
Input [2]: [id#17, info#18]
Condition : ((isnotnull(info#18) AND (info#18 = rating)) AND isnotnull(id#17))

(31) Project
Output [1]: [id#17]
Input [2]: [id#17, info#18]

(32) BroadcastExchange
Input [1]: [id#17]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=287]

(33) BroadcastHashJoin
Left keys [1]: [info_type_id#33]
Right keys [1]: [id#17]
Join type: Inner
Join condition: None

(34) Project
Output [5]: [movie_id#22, id#36, title#37, movie_id#32, info#34]
Input [7]: [movie_id#22, id#36, title#37, movie_id#32, info_type_id#33, info#34, id#17]

(35) Exchange
Input [5]: [movie_id#22, id#36, title#37, movie_id#32, info#34]
Arguments: hashpartitioning(movie_id#22, movie_id#32, id#36, 200), ENSURE_REQUIREMENTS, [plan_id=292]

(36) Sort
Input [5]: [movie_id#22, id#36, title#37, movie_id#32, info#34]
Arguments: [movie_id#22 ASC NULLS FIRST, movie_id#32 ASC NULLS FIRST, id#36 ASC NULLS FIRST], false, 0

(37) Scan parquet spark_catalog.imdb_10x.movie_info
Output [2]: [movie_id#27, info#29]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,info:string>

(38) Filter
Input [2]: [movie_id#27, info#29]
Condition : isnotnull(movie_id#27)

(39) Exchange
Input [2]: [movie_id#27, info#29]
Arguments: hashpartitioning(movie_id#27, movie_id#27, movie_id#27, 200), ENSURE_REQUIREMENTS, [plan_id=293]

(40) Sort
Input [2]: [movie_id#27, info#29]
Arguments: [movie_id#27 ASC NULLS FIRST, movie_id#27 ASC NULLS FIRST, movie_id#27 ASC NULLS FIRST], false, 0

(41) SortMergeJoin
Left keys [3]: [movie_id#22, movie_id#32, id#36]
Right keys [3]: [movie_id#27, movie_id#27, movie_id#27]
Join type: Inner
Join condition: None

(42) Project
Output [3]: [info#29, info#34, title#37]
Input [7]: [movie_id#22, id#36, title#37, movie_id#32, info#34, movie_id#27, info#29]

(43) SortAggregate
Input [3]: [info#29, info#34, title#37]
Keys: []
Functions [3]: [partial_min(info#29), partial_min(info#34), partial_min(title#37)]
Aggregate Attributes [3]: [min#59, min#60, min#61]
Results [3]: [min#62, min#63, min#64]

(44) Exchange
Input [3]: [min#62, min#63, min#64]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=300]

(45) SortAggregate
Input [3]: [min#62, min#63, min#64]
Keys: []
Functions [3]: [min(info#29), min(info#34), min(title#37)]
Aggregate Attributes [3]: [min(info#29)#48, min(info#34)#49, min(title#37)#50]
Results [3]: [min(info#29)#48 AS release_date#0, min(info#34)#49 AS rating#1, min(title#37)#50 AS hongkong_movie#2]

(46) AdaptiveSparkPlan
Output [3]: [release_date#0, rating#1, hongkong_movie#2]
Arguments: isFinalPlan=false


Time taken: 1.86 seconds, Fetched 1 row(s)
