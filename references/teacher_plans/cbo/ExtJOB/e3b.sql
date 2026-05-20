26/04/18 03:14:19 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
26/04/18 03:14:20 WARN SparkConf: Note that spark.local.dir will be overridden by the value set by the cluster manager (via SPARK_LOCAL_DIRS in mesos/standalone/kubernetes and LOCAL_DIRS in YARN).
26/04/18 03:14:23 WARN HiveConf: HiveConf of name hive.stats.jdbc.timeout does not exist
26/04/18 03:14:23 WARN HiveConf: HiveConf of name hive.stats.retries.wait does not exist
26/04/18 03:14:25 WARN ObjectStore: Version information not found in metastore. hive.metastore.schema.verification is not enabled so recording the schema version 2.3.0
26/04/18 03:14:25 WARN ObjectStore: setMetaStoreSchemaVersion called but recording version is disabled: version = 2.3.0, comment = Set by MetaStore user@YOUR_HOST
26/04/18 03:14:26 WARN ObjectStore: Failed to get database global_temp, returning NoSuchObjectException
Spark Web UI available at http://YOUR_SPARK_MASTER_HOST:4040
Spark master: spark://YOUR_SPARK_MASTER_HOST:7077, Application Id: app-20260418031421-7158
== Physical Plan ==
AdaptiveSparkPlan (23)
+- SortAggregate (22)
   +- Exchange (21)
      +- SortAggregate (20)
         +- Project (19)
            +- BroadcastHashJoin Inner BuildLeft (18)
               :- BroadcastExchange (15)
               :  +- Project (14)
               :     +- BroadcastHashJoin Inner BuildLeft (13)
               :        :- BroadcastExchange (10)
               :        :  +- Project (9)
               :        :     +- BroadcastHashJoin Inner BuildRight (8)
               :        :        :- Project (3)
               :        :        :  +- Filter (2)
               :        :        :     +- Scan parquet spark_catalog.imdb_10x.title (1)
               :        :        +- BroadcastExchange (7)
               :        :           +- Project (6)
               :        :              +- Filter (5)
               :        :                 +- Scan parquet spark_catalog.imdb_10x.movie_info (4)
               :        +- Filter (12)
               :           +- Scan parquet spark_catalog.imdb_10x.movie_companies (11)
               +- Filter (17)
                  +- Scan parquet spark_catalog.imdb_10x.movie_info_idx (16)


(1) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#22, title#23, production_year#26]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(2) Filter
Input [3]: [id#22, title#23, production_year#26]
Condition : (((isnotnull(production_year#26) AND (cast(production_year#26 as int) >= 2005)) AND (cast(production_year#26 as int) <= 2010)) AND isnotnull(id#22))

(3) Project
Output [2]: [id#22, title#23]
Input [3]: [id#22, title#23, production_year#26]

(4) Scan parquet spark_catalog.imdb_10x.movie_info
Output [2]: [movie_id#13, info#15]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [In(info, [Drama,Family,Horror,Western]), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,info:string>

(5) Filter
Input [2]: [movie_id#13, info#15]
Condition : (info#15 IN (Drama,Horror,Western,Family) AND isnotnull(movie_id#13))

(6) Project
Output [1]: [movie_id#13]
Input [2]: [movie_id#13, info#15]

(7) BroadcastExchange
Input [1]: [movie_id#13]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=141]

(8) BroadcastHashJoin
Left keys [1]: [id#22]
Right keys [1]: [movie_id#13]
Join type: Inner
Join condition: None

(9) Project
Output [2]: [id#22, title#23]
Input [3]: [id#22, title#23, movie_id#13]

(10) BroadcastExchange
Input [2]: [id#22, title#23]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=145]

(11) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [1]: [movie_id#8]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int>

(12) Filter
Input [1]: [movie_id#8]
Condition : isnotnull(movie_id#8)

(13) BroadcastHashJoin
Left keys [1]: [id#22]
Right keys [1]: [movie_id#8]
Join type: Inner
Join condition: None

(14) Project
Output [2]: [id#22, title#23]
Input [3]: [id#22, title#23, movie_id#8]

(15) BroadcastExchange
Input [2]: [id#22, title#23]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=149]

(16) Scan parquet spark_catalog.imdb_10x.movie_info_idx
Output [2]: [movie_id#18, info#20]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info_idx]
PushedFilters: [IsNotNull(info), GreaterThan(info,5.0), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,info:string>

(17) Filter
Input [2]: [movie_id#18, info#20]
Condition : ((isnotnull(info#20) AND (info#20 > 5.0)) AND isnotnull(movie_id#18))

(18) BroadcastHashJoin
Left keys [1]: [id#22]
Right keys [1]: [movie_id#18]
Join type: Inner
Join condition: None

(19) Project
Output [2]: [info#20, title#23]
Input [4]: [id#22, title#23, movie_id#18, info#20]

(20) SortAggregate
Input [2]: [info#20, title#23]
Keys: []
Functions [2]: [partial_min(info#20), partial_min(title#23)]
Aggregate Attributes [2]: [min#40, min#41]
Results [2]: [min#42, min#43]

(21) Exchange
Input [2]: [min#42, min#43]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=154]

(22) SortAggregate
Input [2]: [min#42, min#43]
Keys: []
Functions [2]: [min(info#20), min(title#23)]
Aggregate Attributes [2]: [min(info#20)#38, min(title#23)#39]
Results [2]: [min(info#20)#38 AS rating#0, min(title#23)#39 AS mainstream_movie#1]

(23) AdaptiveSparkPlan
Output [2]: [rating#0, mainstream_movie#1]
Arguments: isFinalPlan=false


Time taken: 1.521 seconds, Fetched 1 row(s)
