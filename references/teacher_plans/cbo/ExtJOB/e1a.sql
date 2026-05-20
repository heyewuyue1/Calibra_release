26/04/18 03:11:09 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
26/04/18 03:11:10 WARN SparkConf: Note that spark.local.dir will be overridden by the value set by the cluster manager (via SPARK_LOCAL_DIRS in mesos/standalone/kubernetes and LOCAL_DIRS in YARN).
26/04/18 03:11:12 WARN HiveConf: HiveConf of name hive.stats.jdbc.timeout does not exist
26/04/18 03:11:12 WARN HiveConf: HiveConf of name hive.stats.retries.wait does not exist
26/04/18 03:11:15 WARN ObjectStore: Version information not found in metastore. hive.metastore.schema.verification is not enabled so recording the schema version 2.3.0
26/04/18 03:11:15 WARN ObjectStore: setMetaStoreSchemaVersion called but recording version is disabled: version = 2.3.0, comment = Set by MetaStore user@YOUR_HOST
26/04/18 03:11:16 WARN ObjectStore: Failed to get database global_temp, returning NoSuchObjectException
Spark Web UI available at http://YOUR_SPARK_MASTER_HOST:4040
Spark master: spark://YOUR_SPARK_MASTER_HOST:7077, Application Id: app-20260418031111-7148
== Physical Plan ==
AdaptiveSparkPlan (24)
+- SortAggregate (23)
   +- Exchange (22)
      +- SortAggregate (21)
         +- Project (20)
            +- SortMergeJoin Inner (19)
               :- Sort (14)
               :  +- Exchange (13)
               :     +- Project (12)
               :        +- SortMergeJoin Inner (11)
               :           :- Sort (5)
               :           :  +- Exchange (4)
               :           :     +- Project (3)
               :           :        +- Filter (2)
               :           :           +- Scan parquet spark_catalog.imdb_10x.cast_info (1)
               :           +- Sort (10)
               :              +- Exchange (9)
               :                 +- Project (8)
               :                    +- Filter (7)
               :                       +- Scan parquet spark_catalog.imdb_10x.title (6)
               +- Sort (18)
                  +- Exchange (17)
                     +- Filter (16)
                        +- Scan parquet spark_catalog.imdb_10x.char_name (15)


(1) Scan parquet spark_catalog.imdb_10x.cast_info
Output [3]: [movie_id#7, person_role_id#8, role_id#11]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/cast_info]
PushedFilters: [IsNotNull(role_id), EqualTo(role_id,2), IsNotNull(movie_id), IsNotNull(person_role_id)]
ReadSchema: struct<movie_id:int,person_role_id:string,role_id:int>

(2) Filter
Input [3]: [movie_id#7, person_role_id#8, role_id#11]
Condition : (((isnotnull(role_id#11) AND (role_id#11 = 2)) AND isnotnull(movie_id#7)) AND isnotnull(person_role_id#8))

(3) Project
Output [2]: [movie_id#7, person_role_id#8]
Input [3]: [movie_id#7, person_role_id#8, role_id#11]

(4) Exchange
Input [2]: [movie_id#7, person_role_id#8]
Arguments: hashpartitioning(movie_id#7, 200), ENSURE_REQUIREMENTS, [plan_id=107]

(5) Sort
Input [2]: [movie_id#7, person_role_id#8]
Arguments: [movie_id#7 ASC NULLS FIRST], false, 0

(6) Scan parquet spark_catalog.imdb_10x.title
Output [4]: [id#12, title#13, kind_id#15, production_year#16]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(kind_id), EqualTo(kind_id,1), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,kind_id:int,production_year:string>

(7) Filter
Input [4]: [id#12, title#13, kind_id#15, production_year#16]
Condition : ((isnotnull(kind_id#15) AND (kind_id#15 = 1)) AND isnotnull(id#12))

(8) Project
Output [3]: [id#12, title#13, production_year#16]
Input [4]: [id#12, title#13, kind_id#15, production_year#16]

(9) Exchange
Input [3]: [id#12, title#13, production_year#16]
Arguments: hashpartitioning(id#12, 200), ENSURE_REQUIREMENTS, [plan_id=108]

(10) Sort
Input [3]: [id#12, title#13, production_year#16]
Arguments: [id#12 ASC NULLS FIRST], false, 0

(11) SortMergeJoin
Left keys [1]: [movie_id#7]
Right keys [1]: [id#12]
Join type: Inner
Join condition: None

(12) Project
Output [3]: [person_role_id#8, title#13, production_year#16]
Input [5]: [movie_id#7, person_role_id#8, id#12, title#13, production_year#16]

(13) Exchange
Input [3]: [person_role_id#8, title#13, production_year#16]
Arguments: hashpartitioning(cast(person_role_id#8 as int), 200), ENSURE_REQUIREMENTS, [plan_id=115]

(14) Sort
Input [3]: [person_role_id#8, title#13, production_year#16]
Arguments: [cast(person_role_id#8 as int) ASC NULLS FIRST], false, 0

(15) Scan parquet spark_catalog.imdb_10x.char_name
Output [2]: [id#24, name#25]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/char_name]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int,name:string>

(16) Filter
Input [2]: [id#24, name#25]
Condition : isnotnull(id#24)

(17) Exchange
Input [2]: [id#24, name#25]
Arguments: hashpartitioning(id#24, 200), ENSURE_REQUIREMENTS, [plan_id=116]

(18) Sort
Input [2]: [id#24, name#25]
Arguments: [id#24 ASC NULLS FIRST], false, 0

(19) SortMergeJoin
Left keys [1]: [cast(person_role_id#8 as int)]
Right keys [1]: [id#24]
Join type: Inner
Join condition: None

(20) Project
Output [3]: [title#13, production_year#16, name#25]
Input [5]: [person_role_id#8, title#13, production_year#16, id#24, name#25]

(21) SortAggregate
Input [3]: [title#13, production_year#16, name#25]
Keys: []
Functions [3]: [partial_min(title#13), partial_min(production_year#16), partial_min(name#25)]
Aggregate Attributes [3]: [min#40, min#41, min#42]
Results [3]: [min#43, min#44, min#45]

(22) Exchange
Input [3]: [min#43, min#44, min#45]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=123]

(23) SortAggregate
Input [3]: [min#43, min#44, min#45]
Keys: []
Functions [3]: [min(title#13), min(production_year#16), min(name#25)]
Aggregate Attributes [3]: [min(title#13)#34, min(production_year#16)#35, min(name#25)#36]
Results [3]: [min(title#13)#34 AS min(title)#37, min(production_year#16)#35 AS min(production_year)#38, min(name#25)#36 AS min(name)#39]

(24) AdaptiveSparkPlan
Output [3]: [min(title)#37, min(production_year)#38, min(name)#39]
Arguments: isFinalPlan=false


Time taken: 1.549 seconds, Fetched 1 row(s)
