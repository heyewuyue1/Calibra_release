26/04/18 03:20:37 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
26/04/18 03:20:38 WARN SparkConf: Note that spark.local.dir will be overridden by the value set by the cluster manager (via SPARK_LOCAL_DIRS in mesos/standalone/kubernetes and LOCAL_DIRS in YARN).
26/04/18 03:20:41 WARN HiveConf: HiveConf of name hive.stats.jdbc.timeout does not exist
26/04/18 03:20:41 WARN HiveConf: HiveConf of name hive.stats.retries.wait does not exist
26/04/18 03:20:43 WARN ObjectStore: Version information not found in metastore. hive.metastore.schema.verification is not enabled so recording the schema version 2.3.0
26/04/18 03:20:43 WARN ObjectStore: setMetaStoreSchemaVersion called but recording version is disabled: version = 2.3.0, comment = Set by MetaStore user@YOUR_HOST
26/04/18 03:20:45 WARN ObjectStore: Failed to get database global_temp, returning NoSuchObjectException
Spark Web UI available at http://YOUR_SPARK_MASTER_HOST:4040
Spark master: spark://YOUR_SPARK_MASTER_HOST:7077, Application Id: app-20260418032039-7176
== Physical Plan ==
AdaptiveSparkPlan (31)
+- HashAggregate (30)
   +- Exchange (29)
      +- HashAggregate (28)
         +- Project (27)
            +- BroadcastHashJoin Inner BuildRight (26)
               :- Project (22)
               :  +- SortMergeJoin Inner (21)
               :     :- Sort (15)
               :     :  +- Exchange (14)
               :     :     +- Project (13)
               :     :        +- BroadcastHashJoin Inner BuildLeft (12)
               :     :           :- BroadcastExchange (9)
               :     :           :  +- Project (8)
               :     :           :     +- BroadcastHashJoin Inner BuildRight (7)
               :     :           :        :- Filter (2)
               :     :           :        :  +- Scan parquet spark_catalog.imdb_10x.title (1)
               :     :           :        +- BroadcastExchange (6)
               :     :           :           +- Project (5)
               :     :           :              +- Filter (4)
               :     :           :                 +- Scan parquet spark_catalog.imdb_10x.movie_info (3)
               :     :           +- Filter (11)
               :     :              +- Scan parquet spark_catalog.imdb_10x.movie_keyword (10)
               :     +- Sort (20)
               :        +- Exchange (19)
               :           +- Project (18)
               :              +- Filter (17)
               :                 +- Scan parquet spark_catalog.imdb_10x.keyword (16)
               +- BroadcastExchange (25)
                  +- Filter (24)
                     +- Scan parquet spark_catalog.imdb_10x.info_type (23)


(1) Scan parquet spark_catalog.imdb_10x.title
Output [1]: [id#6]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int>

(2) Filter
Input [1]: [id#6]
Condition : isnotnull(id#6)

(3) Scan parquet spark_catalog.imdb_10x.movie_info
Output [3]: [movie_id#27, info_type_id#28, info#29]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [IsNotNull(info), IsNotNull(movie_id), EqualTo(info_type_id,3), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(4) Filter
Input [3]: [movie_id#27, info_type_id#28, info#29]
Condition : ((((isnotnull(info#29) AND Contains(lower(info#29), romance)) AND isnotnull(movie_id#27)) AND (info_type_id#28 = 3)) AND isnotnull(info_type_id#28))

(5) Project
Output [2]: [movie_id#27, info_type_id#28]
Input [3]: [movie_id#27, info_type_id#28, info#29]

(6) BroadcastExchange
Input [2]: [movie_id#27, info_type_id#28]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=178]

(7) BroadcastHashJoin
Left keys [1]: [id#6]
Right keys [1]: [movie_id#27]
Join type: Inner
Join condition: None

(8) Project
Output [2]: [id#6, info_type_id#28]
Input [3]: [id#6, movie_id#27, info_type_id#28]

(9) BroadcastExchange
Input [2]: [id#6, info_type_id#28]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=182]

(10) Scan parquet spark_catalog.imdb_10x.movie_keyword
Output [2]: [movie_id#19, keyword_id#20]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_keyword]
PushedFilters: [IsNotNull(movie_id), IsNotNull(keyword_id)]
ReadSchema: struct<movie_id:int,keyword_id:int>

(11) Filter
Input [2]: [movie_id#19, keyword_id#20]
Condition : (isnotnull(movie_id#19) AND isnotnull(keyword_id#20))

(12) BroadcastHashJoin
Left keys [1]: [id#6]
Right keys [1]: [movie_id#19]
Join type: Inner
Join condition: None

(13) Project
Output [2]: [info_type_id#28, keyword_id#20]
Input [4]: [id#6, info_type_id#28, movie_id#19, keyword_id#20]

(14) Exchange
Input [2]: [info_type_id#28, keyword_id#20]
Arguments: hashpartitioning(keyword_id#20, 200), ENSURE_REQUIREMENTS, [plan_id=187]

(15) Sort
Input [2]: [info_type_id#28, keyword_id#20]
Arguments: [keyword_id#20 ASC NULLS FIRST], false, 0

(16) Scan parquet spark_catalog.imdb_10x.keyword
Output [2]: [id#21, keyword#22]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/keyword]
PushedFilters: [IsNotNull(keyword), IsNotNull(id)]
ReadSchema: struct<id:int,keyword:string>

(17) Filter
Input [2]: [id#21, keyword#22]
Condition : ((isnotnull(keyword#22) AND Contains(lower(keyword#22), love)) AND isnotnull(id#21))

(18) Project
Output [1]: [id#21]
Input [2]: [id#21, keyword#22]

(19) Exchange
Input [1]: [id#21]
Arguments: hashpartitioning(id#21, 200), ENSURE_REQUIREMENTS, [plan_id=188]

(20) Sort
Input [1]: [id#21]
Arguments: [id#21 ASC NULLS FIRST], false, 0

(21) SortMergeJoin
Left keys [1]: [keyword_id#20]
Right keys [1]: [id#21]
Join type: Inner
Join condition: None

(22) Project
Output [1]: [info_type_id#28]
Input [3]: [info_type_id#28, keyword_id#20, id#21]

(23) Scan parquet spark_catalog.imdb_10x.info_type
Output [1]: [id#24]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(id), EqualTo(id,3)]
ReadSchema: struct<id:int>

(24) Filter
Input [1]: [id#24]
Condition : (isnotnull(id#24) AND (id#24 = 3))

(25) BroadcastExchange
Input [1]: [id#24]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, false] as bigint)),false), [plan_id=194]

(26) BroadcastHashJoin
Left keys [1]: [info_type_id#28]
Right keys [1]: [id#24]
Join type: Inner
Join condition: None

(27) Project
Output: []
Input [2]: [info_type_id#28, id#24]

(28) HashAggregate
Input: []
Keys: []
Functions [1]: [partial_count(1)]
Aggregate Attributes [1]: [count#37L]
Results [1]: [count#38L]

(29) Exchange
Input [1]: [count#38L]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=199]

(30) HashAggregate
Input [1]: [count#38L]
Keys: []
Functions [1]: [count(1)]
Aggregate Attributes [1]: [count(1)#5L]
Results [1]: [count(1)#5L AS count(1)#31L]

(31) AdaptiveSparkPlan
Output [1]: [count(1)#31L]
Arguments: isFinalPlan=false


Time taken: 1.715 seconds, Fetched 1 row(s)
