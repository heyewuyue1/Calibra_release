26/04/18 03:16:50 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
26/04/18 03:16:51 WARN SparkConf: Note that spark.local.dir will be overridden by the value set by the cluster manager (via SPARK_LOCAL_DIRS in mesos/standalone/kubernetes and LOCAL_DIRS in YARN).
26/04/18 03:16:53 WARN HiveConf: HiveConf of name hive.stats.jdbc.timeout does not exist
26/04/18 03:16:53 WARN HiveConf: HiveConf of name hive.stats.retries.wait does not exist
26/04/18 03:16:56 WARN ObjectStore: Version information not found in metastore. hive.metastore.schema.verification is not enabled so recording the schema version 2.3.0
26/04/18 03:16:56 WARN ObjectStore: setMetaStoreSchemaVersion called but recording version is disabled: version = 2.3.0, comment = Set by MetaStore user@YOUR_HOST
26/04/18 03:16:57 WARN ObjectStore: Failed to get database global_temp, returning NoSuchObjectException
Spark Web UI available at http://YOUR_SPARK_MASTER_HOST:4040
Spark master: spark://YOUR_SPARK_MASTER_HOST:7077, Application Id: app-20260418031652-7166
== Physical Plan ==
AdaptiveSparkPlan (23)
+- SortAggregate (22)
   +- Exchange (21)
      +- SortAggregate (20)
         +- Project (19)
            +- BroadcastHashJoin Inner BuildLeft (18)
               :- BroadcastExchange (14)
               :  +- Project (13)
               :     +- BroadcastHashJoin Inner BuildLeft (12)
               :        :- BroadcastExchange (9)
               :        :  +- BroadcastHashJoin Inner BuildLeft (8)
               :        :     :- BroadcastExchange (4)
               :        :     :  +- Project (3)
               :        :     :     +- Filter (2)
               :        :     :        +- Scan parquet spark_catalog.imdb_10x.movie_info (1)
               :        :     +- Project (7)
               :        :        +- Filter (6)
               :        :           +- Scan parquet spark_catalog.imdb_10x.title (5)
               :        +- Filter (11)
               :           +- Scan parquet spark_catalog.imdb_10x.movie_keyword (10)
               +- Project (17)
                  +- Filter (16)
                     +- Scan parquet spark_catalog.imdb_10x.keyword (15)


(1) Scan parquet spark_catalog.imdb_10x.movie_info
Output [2]: [movie_id#10, info#12]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [In(info, [Denish,Denmark,German,Germany,Norway,Norwegian,Sweden,Swedish]), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,info:string>

(2) Filter
Input [2]: [movie_id#10, info#12]
Condition : (info#12 IN (Sweden,Norway,Germany,Denmark,Swedish,Denish,Norwegian,German) AND isnotnull(movie_id#10))

(3) Project
Output [1]: [movie_id#10]
Input [2]: [movie_id#10, info#12]

(4) BroadcastExchange
Input [1]: [movie_id#10]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=135]

(5) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#17, title#18, production_year#21]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(6) Filter
Input [3]: [id#17, title#18, production_year#21]
Condition : ((isnotnull(production_year#21) AND (cast(production_year#21 as int) > 2005)) AND isnotnull(id#17))

(7) Project
Output [2]: [id#17, title#18]
Input [3]: [id#17, title#18, production_year#21]

(8) BroadcastHashJoin
Left keys [1]: [movie_id#10]
Right keys [1]: [id#17]
Join type: Inner
Join condition: None

(9) BroadcastExchange
Input [3]: [movie_id#10, id#17, title#18]
Arguments: HashedRelationBroadcastMode(List((shiftleft(cast(input[0, int, true] as bigint), 32) | (cast(input[1, int, true] as bigint) & 4294967295))),false), [plan_id=138]

(10) Scan parquet spark_catalog.imdb_10x.movie_keyword
Output [2]: [movie_id#15, keyword_id#16]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_keyword]
PushedFilters: [IsNotNull(keyword_id), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,keyword_id:int>

(11) Filter
Input [2]: [movie_id#15, keyword_id#16]
Condition : (isnotnull(keyword_id#16) AND isnotnull(movie_id#15))

(12) BroadcastHashJoin
Left keys [2]: [movie_id#10, id#17]
Right keys [2]: [movie_id#15, movie_id#15]
Join type: Inner
Join condition: None

(13) Project
Output [2]: [title#18, keyword_id#16]
Input [5]: [movie_id#10, id#17, title#18, movie_id#15, keyword_id#16]

(14) BroadcastExchange
Input [2]: [title#18, keyword_id#16]
Arguments: HashedRelationBroadcastMode(List(cast(input[1, int, true] as bigint)),false), [plan_id=142]

(15) Scan parquet spark_catalog.imdb_10x.keyword
Output [2]: [id#6, keyword#7]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/keyword]
PushedFilters: [IsNotNull(keyword), StringContains(keyword,sequel), IsNotNull(id)]
ReadSchema: struct<id:int,keyword:string>

(16) Filter
Input [2]: [id#6, keyword#7]
Condition : ((isnotnull(keyword#7) AND Contains(keyword#7, sequel)) AND isnotnull(id#6))

(17) Project
Output [1]: [id#6]
Input [2]: [id#6, keyword#7]

(18) BroadcastHashJoin
Left keys [1]: [keyword_id#16]
Right keys [1]: [id#6]
Join type: Inner
Join condition: None

(19) Project
Output [1]: [title#18]
Input [3]: [title#18, keyword_id#16, id#6]

(20) SortAggregate
Input [1]: [title#18]
Keys: []
Functions [1]: [partial_min(title#18)]
Aggregate Attributes [1]: [min#34]
Results [1]: [min#35]

(21) Exchange
Input [1]: [min#35]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=147]

(22) SortAggregate
Input [1]: [min#35]
Keys: []
Functions [1]: [min(title#18)]
Aggregate Attributes [1]: [min(title#18)#33]
Results [1]: [min(title#18)#33 AS movie_title#0]

(23) AdaptiveSparkPlan
Output [1]: [movie_title#0]
Arguments: isFinalPlan=false


Time taken: 1.43 seconds, Fetched 1 row(s)
