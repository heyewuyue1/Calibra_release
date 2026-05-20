26/04/18 03:18:00 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
26/04/18 03:18:01 WARN SparkConf: Note that spark.local.dir will be overridden by the value set by the cluster manager (via SPARK_LOCAL_DIRS in mesos/standalone/kubernetes and LOCAL_DIRS in YARN).
26/04/18 03:18:03 WARN HiveConf: HiveConf of name hive.stats.jdbc.timeout does not exist
26/04/18 03:18:03 WARN HiveConf: HiveConf of name hive.stats.retries.wait does not exist
26/04/18 03:18:06 WARN ObjectStore: Version information not found in metastore. hive.metastore.schema.verification is not enabled so recording the schema version 2.3.0
26/04/18 03:18:06 WARN ObjectStore: setMetaStoreSchemaVersion called but recording version is disabled: version = 2.3.0, comment = Set by MetaStore user@YOUR_HOST
26/04/18 03:18:07 WARN ObjectStore: Failed to get database global_temp, returning NoSuchObjectException
Spark Web UI available at http://YOUR_SPARK_MASTER_HOST:4040
Spark master: spark://YOUR_SPARK_MASTER_HOST:7077, Application Id: app-20260418031802-7170
== Physical Plan ==
AdaptiveSparkPlan (22)
+- SortAggregate (21)
   +- Exchange (20)
      +- SortAggregate (19)
         +- Project (18)
            +- SortMergeJoin Inner (17)
               :- Sort (12)
               :  +- Exchange (11)
               :     +- SortMergeJoin Inner (10)
               :        :- Sort (4)
               :        :  +- Exchange (3)
               :        :     +- Filter (2)
               :        :        +- Scan parquet spark_catalog.imdb_10x.movie_info_idx (1)
               :        +- Sort (9)
               :           +- Exchange (8)
               :              +- Project (7)
               :                 +- Filter (6)
               :                    +- Scan parquet spark_catalog.imdb_10x.title (5)
               +- Sort (16)
                  +- Exchange (15)
                     +- Filter (14)
                        +- Scan parquet spark_catalog.imdb_10x.movie_keyword (13)


(1) Scan parquet spark_catalog.imdb_10x.movie_info_idx
Output [2]: [movie_id#8, info#10]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info_idx]
PushedFilters: [IsNotNull(info), GreaterThan(info,3.0), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,info:string>

(2) Filter
Input [2]: [movie_id#8, info#10]
Condition : ((isnotnull(info#10) AND (info#10 > 3.0)) AND isnotnull(movie_id#8))

(3) Exchange
Input [2]: [movie_id#8, info#10]
Arguments: hashpartitioning(movie_id#8, 200), ENSURE_REQUIREMENTS, [plan_id=102]

(4) Sort
Input [2]: [movie_id#8, info#10]
Arguments: [movie_id#8 ASC NULLS FIRST], false, 0

(5) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#15, title#16, production_year#19]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(6) Filter
Input [3]: [id#15, title#16, production_year#19]
Condition : ((isnotnull(production_year#19) AND (cast(production_year#19 as int) > 2008)) AND isnotnull(id#15))

(7) Project
Output [2]: [id#15, title#16]
Input [3]: [id#15, title#16, production_year#19]

(8) Exchange
Input [2]: [id#15, title#16]
Arguments: hashpartitioning(id#15, 200), ENSURE_REQUIREMENTS, [plan_id=103]

(9) Sort
Input [2]: [id#15, title#16]
Arguments: [id#15 ASC NULLS FIRST], false, 0

(10) SortMergeJoin
Left keys [1]: [movie_id#8]
Right keys [1]: [id#15]
Join type: Inner
Join condition: None

(11) Exchange
Input [4]: [movie_id#8, info#10, id#15, title#16]
Arguments: hashpartitioning(movie_id#8, movie_id#8, 200), ENSURE_REQUIREMENTS, [plan_id=110]

(12) Sort
Input [4]: [movie_id#8, info#10, id#15, title#16]
Arguments: [movie_id#8 ASC NULLS FIRST, id#15 ASC NULLS FIRST], false, 0

(13) Scan parquet spark_catalog.imdb_10x.movie_keyword
Output [1]: [movie_id#13]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_keyword]
PushedFilters: [IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int>

(14) Filter
Input [1]: [movie_id#13]
Condition : isnotnull(movie_id#13)

(15) Exchange
Input [1]: [movie_id#13]
Arguments: hashpartitioning(movie_id#13, movie_id#13, 200), ENSURE_REQUIREMENTS, [plan_id=109]

(16) Sort
Input [1]: [movie_id#13]
Arguments: [movie_id#13 ASC NULLS FIRST, movie_id#13 ASC NULLS FIRST], false, 0

(17) SortMergeJoin
Left keys [2]: [movie_id#8, id#15]
Right keys [2]: [movie_id#13, movie_id#13]
Join type: Inner
Join condition: None

(18) Project
Output [2]: [info#10, title#16]
Input [5]: [movie_id#8, info#10, id#15, title#16, movie_id#13]

(19) SortAggregate
Input [2]: [info#10, title#16]
Keys: []
Functions [2]: [partial_min(info#10), partial_min(title#16)]
Aggregate Attributes [2]: [min#32, min#33]
Results [2]: [min#34, min#35]

(20) Exchange
Input [2]: [min#34, min#35]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=117]

(21) SortAggregate
Input [2]: [min#34, min#35]
Keys: []
Functions [2]: [min(info#10), min(title#16)]
Aggregate Attributes [2]: [min(info#10)#30, min(title#16)#31]
Results [2]: [min(info#10)#30 AS rating#0, min(title#16)#31 AS movie_title#1]

(22) AdaptiveSparkPlan
Output [2]: [rating#0, movie_title#1]
Arguments: isFinalPlan=false


Time taken: 1.455 seconds, Fetched 1 row(s)
