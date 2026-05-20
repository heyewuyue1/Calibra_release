26/04/18 03:15:42 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
26/04/18 03:15:43 WARN SparkConf: Note that spark.local.dir will be overridden by the value set by the cluster manager (via SPARK_LOCAL_DIRS in mesos/standalone/kubernetes and LOCAL_DIRS in YARN).
26/04/18 03:15:45 WARN HiveConf: HiveConf of name hive.stats.jdbc.timeout does not exist
26/04/18 03:15:46 WARN HiveConf: HiveConf of name hive.stats.retries.wait does not exist
26/04/18 03:15:48 WARN ObjectStore: Version information not found in metastore. hive.metastore.schema.verification is not enabled so recording the schema version 2.3.0
26/04/18 03:15:48 WARN ObjectStore: setMetaStoreSchemaVersion called but recording version is disabled: version = 2.3.0, comment = Set by MetaStore user@YOUR_HOST
26/04/18 03:15:49 WARN ObjectStore: Failed to get database global_temp, returning NoSuchObjectException
Spark Web UI available at http://YOUR_SPARK_MASTER_HOST:4040
Spark master: spark://YOUR_SPARK_MASTER_HOST:7077, Application Id: app-20260418031544-7162
== Physical Plan ==
AdaptiveSparkPlan (34)
+- SortAggregate (33)
   +- Exchange (32)
      +- SortAggregate (31)
         +- Project (30)
            +- SortMergeJoin Inner (29)
               :- Project (24)
               :  +- SortMergeJoin Inner (23)
               :     :- Project (17)
               :     :  +- SortMergeJoin Inner (16)
               :     :     :- Project (11)
               :     :     :  +- SortMergeJoin Inner (10)
               :     :     :     :- Sort (4)
               :     :     :     :  +- Exchange (3)
               :     :     :     :     +- Filter (2)
               :     :     :     :        +- Scan parquet spark_catalog.imdb_10x.aka_title (1)
               :     :     :     +- Sort (9)
               :     :     :        +- Exchange (8)
               :     :     :           +- Project (7)
               :     :     :              +- Filter (6)
               :     :     :                 +- Scan parquet spark_catalog.imdb_10x.title (5)
               :     :     +- Sort (15)
               :     :        +- Exchange (14)
               :     :           +- Filter (13)
               :     :              +- Scan parquet spark_catalog.imdb_10x.movie_companies (12)
               :     +- Sort (22)
               :        +- Exchange (21)
               :           +- Project (20)
               :              +- Filter (19)
               :                 +- Scan parquet spark_catalog.imdb_10x.movie_info (18)
               +- Sort (28)
                  +- Exchange (27)
                     +- Filter (26)
                        +- Scan parquet spark_catalog.imdb_10x.movie_keyword (25)


(1) Scan parquet spark_catalog.imdb_10x.aka_title
Output [1]: [movie_id#8]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/aka_title]
PushedFilters: [IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int>

(2) Filter
Input [1]: [movie_id#8]
Condition : isnotnull(movie_id#8)

(3) Exchange
Input [1]: [movie_id#8]
Arguments: hashpartitioning(movie_id#8, 200), ENSURE_REQUIREMENTS, [plan_id=179]

(4) Sort
Input [1]: [movie_id#8]
Arguments: [movie_id#8 ASC NULLS FIRST], false, 0

(5) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#32, title#33, production_year#36]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(6) Filter
Input [3]: [id#32, title#33, production_year#36]
Condition : ((isnotnull(production_year#36) AND (cast(production_year#36 as int) > 2000)) AND isnotnull(id#32))

(7) Project
Output [2]: [id#32, title#33]
Input [3]: [id#32, title#33, production_year#36]

(8) Exchange
Input [2]: [id#32, title#33]
Arguments: hashpartitioning(id#32, 200), ENSURE_REQUIREMENTS, [plan_id=180]

(9) Sort
Input [2]: [id#32, title#33]
Arguments: [id#32 ASC NULLS FIRST], false, 0

(10) SortMergeJoin
Left keys [1]: [movie_id#8]
Right keys [1]: [id#32]
Join type: Inner
Join condition: None

(11) Project
Output [2]: [id#32, title#33]
Input [3]: [movie_id#8, id#32, title#33]

(12) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [1]: [movie_id#20]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int>

(13) Filter
Input [1]: [movie_id#20]
Condition : isnotnull(movie_id#20)

(14) Exchange
Input [1]: [movie_id#20]
Arguments: hashpartitioning(movie_id#20, 200), ENSURE_REQUIREMENTS, [plan_id=187]

(15) Sort
Input [1]: [movie_id#20]
Arguments: [movie_id#20 ASC NULLS FIRST], false, 0

(16) SortMergeJoin
Left keys [1]: [id#32]
Right keys [1]: [movie_id#20]
Join type: Inner
Join condition: None

(17) Project
Output [2]: [id#32, title#33]
Input [3]: [id#32, title#33, movie_id#20]

(18) Scan parquet spark_catalog.imdb_10x.movie_info
Output [3]: [movie_id#25, info#27, note#28]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [IsNotNull(note), StringContains(note,internet), IsNotNull(info), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,info:string,note:string>

(19) Filter
Input [3]: [movie_id#25, info#27, note#28]
Condition : ((((isnotnull(note#28) AND Contains(note#28, internet)) AND isnotnull(info#27)) AND (info#27 LIKE USA:% 199% OR info#27 LIKE USA:% 200%)) AND isnotnull(movie_id#25))

(20) Project
Output [2]: [movie_id#25, info#27]
Input [3]: [movie_id#25, info#27, note#28]

(21) Exchange
Input [2]: [movie_id#25, info#27]
Arguments: hashpartitioning(movie_id#25, 200), ENSURE_REQUIREMENTS, [plan_id=193]

(22) Sort
Input [2]: [movie_id#25, info#27]
Arguments: [movie_id#25 ASC NULLS FIRST], false, 0

(23) SortMergeJoin
Left keys [1]: [id#32]
Right keys [1]: [movie_id#25]
Join type: Inner
Join condition: None

(24) Project
Output [3]: [id#32, title#33, info#27]
Input [4]: [id#32, title#33, movie_id#25, info#27]

(25) Scan parquet spark_catalog.imdb_10x.movie_keyword
Output [1]: [movie_id#30]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_keyword]
PushedFilters: [IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int>

(26) Filter
Input [1]: [movie_id#30]
Condition : isnotnull(movie_id#30)

(27) Exchange
Input [1]: [movie_id#30]
Arguments: hashpartitioning(movie_id#30, 200), ENSURE_REQUIREMENTS, [plan_id=199]

(28) Sort
Input [1]: [movie_id#30]
Arguments: [movie_id#30 ASC NULLS FIRST], false, 0

(29) SortMergeJoin
Left keys [1]: [id#32]
Right keys [1]: [movie_id#30]
Join type: Inner
Join condition: None

(30) Project
Output [2]: [info#27, title#33]
Input [4]: [id#32, title#33, info#27, movie_id#30]

(31) SortAggregate
Input [2]: [info#27, title#33]
Keys: []
Functions [2]: [partial_min(info#27), partial_min(title#33)]
Aggregate Attributes [2]: [min#51, min#52]
Results [2]: [min#53, min#54]

(32) Exchange
Input [2]: [min#53, min#54]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=205]

(33) SortAggregate
Input [2]: [min#53, min#54]
Keys: []
Functions [2]: [min(info#27), min(title#33)]
Aggregate Attributes [2]: [min(info#27)#49, min(title#33)#50]
Results [2]: [min(info#27)#49 AS release_date#0, min(title#33)#50 AS modern_internet_movie#1]

(34) AdaptiveSparkPlan
Output [2]: [release_date#0, modern_internet_movie#1]
Arguments: isFinalPlan=false


Time taken: 1.787 seconds, Fetched 1 row(s)
