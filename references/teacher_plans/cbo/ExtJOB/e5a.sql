26/04/18 03:16:19 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
26/04/18 03:16:19 WARN SparkConf: Note that spark.local.dir will be overridden by the value set by the cluster manager (via SPARK_LOCAL_DIRS in mesos/standalone/kubernetes and LOCAL_DIRS in YARN).
26/04/18 03:16:22 WARN HiveConf: HiveConf of name hive.stats.jdbc.timeout does not exist
26/04/18 03:16:22 WARN HiveConf: HiveConf of name hive.stats.retries.wait does not exist
26/04/18 03:16:24 WARN ObjectStore: Version information not found in metastore. hive.metastore.schema.verification is not enabled so recording the schema version 2.3.0
26/04/18 03:16:24 WARN ObjectStore: setMetaStoreSchemaVersion called but recording version is disabled: version = 2.3.0, comment = Set by MetaStore user@YOUR_HOST
26/04/18 03:16:26 WARN ObjectStore: Failed to get database global_temp, returning NoSuchObjectException
Spark Web UI available at http://YOUR_SPARK_MASTER_HOST:4040
Spark master: spark://YOUR_SPARK_MASTER_HOST:7077, Application Id: app-20260418031620-7164
== Physical Plan ==
AdaptiveSparkPlan (20)
+- SortAggregate (19)
   +- Exchange (18)
      +- SortAggregate (17)
         +- Project (16)
            +- SortMergeJoin Inner (15)
               :- Sort (10)
               :  +- Exchange (9)
               :     +- Project (8)
               :        +- BroadcastHashJoin Inner BuildLeft (7)
               :           :- BroadcastExchange (4)
               :           :  +- Project (3)
               :           :     +- Filter (2)
               :           :        +- Scan parquet spark_catalog.imdb_10x.company_type (1)
               :           +- Filter (6)
               :              +- Scan parquet spark_catalog.imdb_10x.movie_companies (5)
               +- Sort (14)
                  +- Exchange (13)
                     +- Filter (12)
                        +- Scan parquet spark_catalog.imdb_10x.title (11)


(1) Scan parquet spark_catalog.imdb_10x.company_type
Output [2]: [id#8, kind#9]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/company_type]
PushedFilters: [IsNotNull(kind), EqualTo(kind,production companies), IsNotNull(id)]
ReadSchema: struct<id:int,kind:string>

(2) Filter
Input [2]: [id#8, kind#9]
Condition : ((isnotnull(kind#9) AND (kind#9 = production companies)) AND isnotnull(id#8))

(3) Project
Output [1]: [id#8]
Input [2]: [id#8, kind#9]

(4) BroadcastExchange
Input [1]: [id#8]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=108]

(5) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [3]: [movie_id#11, company_type_id#13, note#14]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(note), Not(StringContains(note,(as Metro-Goldwyn-Mayer Pictures))), IsNotNull(company_type_id), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,company_type_id:int,note:string>

(6) Filter
Input [3]: [movie_id#11, company_type_id#13, note#14]
Condition : (((isnotnull(note#14) AND NOT Contains(note#14, (as Metro-Goldwyn-Mayer Pictures))) AND isnotnull(company_type_id#13)) AND isnotnull(movie_id#11))

(7) BroadcastHashJoin
Left keys [1]: [id#8]
Right keys [1]: [company_type_id#13]
Join type: Inner
Join condition: None

(8) Project
Output [2]: [movie_id#11, note#14]
Input [4]: [id#8, movie_id#11, company_type_id#13, note#14]

(9) Exchange
Input [2]: [movie_id#11, note#14]
Arguments: hashpartitioning(movie_id#11, 200), ENSURE_REQUIREMENTS, [plan_id=113]

(10) Sort
Input [2]: [movie_id#11, note#14]
Arguments: [movie_id#11 ASC NULLS FIRST], false, 0

(11) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#15, title#16, production_year#19]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(12) Filter
Input [3]: [id#15, title#16, production_year#19]
Condition : ((isnotnull(production_year#19) AND (cast(production_year#19 as int) > 2008)) AND isnotnull(id#15))

(13) Exchange
Input [3]: [id#15, title#16, production_year#19]
Arguments: hashpartitioning(id#15, 200), ENSURE_REQUIREMENTS, [plan_id=114]

(14) Sort
Input [3]: [id#15, title#16, production_year#19]
Arguments: [id#15 ASC NULLS FIRST], false, 0

(15) SortMergeJoin
Left keys [1]: [movie_id#11]
Right keys [1]: [id#15]
Join type: Inner
Join condition: None

(16) Project
Output [3]: [note#14, title#16, production_year#19]
Input [5]: [movie_id#11, note#14, id#15, title#16, production_year#19]

(17) SortAggregate
Input [3]: [note#14, title#16, production_year#19]
Keys: []
Functions [3]: [partial_min(note#14), partial_min(title#16), partial_min(production_year#19)]
Aggregate Attributes [3]: [min#33, min#34, min#35]
Results [3]: [min#36, min#37, min#38]

(18) Exchange
Input [3]: [min#36, min#37, min#38]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=121]

(19) SortAggregate
Input [3]: [min#36, min#37, min#38]
Keys: []
Functions [3]: [min(note#14), min(title#16), min(production_year#19)]
Aggregate Attributes [3]: [min(note#14)#30, min(title#16)#31, min(production_year#19)#32]
Results [3]: [min(note#14)#30 AS production_note#0, min(title#16)#31 AS movie_title#1, min(production_year#19)#32 AS movie_year#2]

(20) AdaptiveSparkPlan
Output [3]: [production_note#0, movie_title#1, movie_year#2]
Arguments: isFinalPlan=false


Time taken: 1.458 seconds, Fetched 1 row(s)
