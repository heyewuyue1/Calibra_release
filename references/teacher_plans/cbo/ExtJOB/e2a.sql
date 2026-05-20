26/04/18 03:12:21 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
26/04/18 03:12:22 WARN SparkConf: Note that spark.local.dir will be overridden by the value set by the cluster manager (via SPARK_LOCAL_DIRS in mesos/standalone/kubernetes and LOCAL_DIRS in YARN).
26/04/18 03:12:24 WARN HiveConf: HiveConf of name hive.stats.jdbc.timeout does not exist
26/04/18 03:12:24 WARN HiveConf: HiveConf of name hive.stats.retries.wait does not exist
26/04/18 03:12:26 WARN ObjectStore: Version information not found in metastore. hive.metastore.schema.verification is not enabled so recording the schema version 2.3.0
26/04/18 03:12:26 WARN ObjectStore: setMetaStoreSchemaVersion called but recording version is disabled: version = 2.3.0, comment = Set by MetaStore user@YOUR_HOST
26/04/18 03:12:28 WARN ObjectStore: Failed to get database global_temp, returning NoSuchObjectException
Spark Web UI available at http://YOUR_SPARK_MASTER_HOST:4040
Spark master: spark://YOUR_SPARK_MASTER_HOST:7077, Application Id: app-20260418031223-7152
== Physical Plan ==
AdaptiveSparkPlan (34)
+- SortAggregate (33)
   +- Exchange (32)
      +- SortAggregate (31)
         +- BroadcastNestedLoopJoin Inner BuildRight (30)
            :- Project (27)
            :  +- SortMergeJoin Inner (26)
            :     :- Sort (21)
            :     :  +- Exchange (20)
            :     :     +- Project (19)
            :     :        +- SortMergeJoin Inner (18)
            :     :           :- Sort (12)
            :     :           :  +- Exchange (11)
            :     :           :     +- SortMergeJoin Inner (10)
            :     :           :        :- Sort (4)
            :     :           :        :  +- Exchange (3)
            :     :           :        :     +- Filter (2)
            :     :           :        :        +- Scan parquet spark_catalog.imdb_10x.movie_companies (1)
            :     :           :        +- Sort (9)
            :     :           :           +- Exchange (8)
            :     :           :              +- Project (7)
            :     :           :                 +- Filter (6)
            :     :           :                    +- Scan parquet spark_catalog.imdb_10x.title (5)
            :     :           +- Sort (17)
            :     :              +- Exchange (16)
            :     :                 +- Project (15)
            :     :                    +- Filter (14)
            :     :                       +- Scan parquet spark_catalog.imdb_10x.cast_info (13)
            :     +- Sort (25)
            :        +- Exchange (24)
            :           +- Filter (23)
            :              +- Scan parquet spark_catalog.imdb_10x.char_name (22)
            +- BroadcastExchange (29)
               +- Scan parquet spark_catalog.imdb_10x.role_type (28)


(1) Scan parquet spark_catalog.imdb_10x.movie_companies
Output [1]: [movie_id#22]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int>

(2) Filter
Input [1]: [movie_id#22]
Condition : isnotnull(movie_id#22)

(3) Exchange
Input [1]: [movie_id#22]
Arguments: hashpartitioning(movie_id#22, 200), ENSURE_REQUIREMENTS, [plan_id=151]

(4) Sort
Input [1]: [movie_id#22]
Arguments: [movie_id#22 ASC NULLS FIRST], false, 0

(5) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#28, title#29, production_year#32]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(6) Filter
Input [3]: [id#28, title#29, production_year#32]
Condition : ((isnotnull(production_year#32) AND (cast(production_year#32 as int) > 2003)) AND isnotnull(id#28))

(7) Project
Output [2]: [id#28, title#29]
Input [3]: [id#28, title#29, production_year#32]

(8) Exchange
Input [2]: [id#28, title#29]
Arguments: hashpartitioning(id#28, 200), ENSURE_REQUIREMENTS, [plan_id=152]

(9) Sort
Input [2]: [id#28, title#29]
Arguments: [id#28 ASC NULLS FIRST], false, 0

(10) SortMergeJoin
Left keys [1]: [movie_id#22]
Right keys [1]: [id#28]
Join type: Inner
Join condition: None

(11) Exchange
Input [3]: [movie_id#22, id#28, title#29]
Arguments: hashpartitioning(movie_id#22, movie_id#22, 200), ENSURE_REQUIREMENTS, [plan_id=159]

(12) Sort
Input [3]: [movie_id#22, id#28, title#29]
Arguments: [movie_id#22 ASC NULLS FIRST, id#28 ASC NULLS FIRST], false, 0

(13) Scan parquet spark_catalog.imdb_10x.cast_info
Output [3]: [movie_id#16, person_role_id#17, note#18]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/cast_info]
PushedFilters: [IsNotNull(note), StringContains(note,(voice)), StringContains(note,(uncredited)), IsNotNull(person_role_id), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,person_role_id:string,note:string>

(14) Filter
Input [3]: [movie_id#16, person_role_id#17, note#18]
Condition : ((((isnotnull(note#18) AND Contains(note#18, (voice))) AND Contains(note#18, (uncredited))) AND isnotnull(person_role_id#17)) AND isnotnull(movie_id#16))

(15) Project
Output [2]: [movie_id#16, person_role_id#17]
Input [3]: [movie_id#16, person_role_id#17, note#18]

(16) Exchange
Input [2]: [movie_id#16, person_role_id#17]
Arguments: hashpartitioning(movie_id#16, movie_id#16, 200), ENSURE_REQUIREMENTS, [plan_id=158]

(17) Sort
Input [2]: [movie_id#16, person_role_id#17]
Arguments: [movie_id#16 ASC NULLS FIRST, movie_id#16 ASC NULLS FIRST], false, 0

(18) SortMergeJoin
Left keys [2]: [movie_id#22, id#28]
Right keys [2]: [movie_id#16, movie_id#16]
Join type: Inner
Join condition: None

(19) Project
Output [2]: [title#29, person_role_id#17]
Input [5]: [movie_id#22, id#28, title#29, movie_id#16, person_role_id#17]

(20) Exchange
Input [2]: [title#29, person_role_id#17]
Arguments: hashpartitioning(cast(person_role_id#17 as int), 200), ENSURE_REQUIREMENTS, [plan_id=166]

(21) Sort
Input [2]: [title#29, person_role_id#17]
Arguments: [cast(person_role_id#17 as int) ASC NULLS FIRST], false, 0

(22) Scan parquet spark_catalog.imdb_10x.char_name
Output [2]: [id#7, name#8]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/char_name]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int,name:string>

(23) Filter
Input [2]: [id#7, name#8]
Condition : isnotnull(id#7)

(24) Exchange
Input [2]: [id#7, name#8]
Arguments: hashpartitioning(id#7, 200), ENSURE_REQUIREMENTS, [plan_id=167]

(25) Sort
Input [2]: [id#7, name#8]
Arguments: [id#7 ASC NULLS FIRST], false, 0

(26) SortMergeJoin
Left keys [1]: [cast(person_role_id#17 as int)]
Right keys [1]: [id#7]
Join type: Inner
Join condition: None

(27) Project
Output [2]: [name#8, title#29]
Input [4]: [title#29, person_role_id#17, id#7, name#8]

(28) Scan parquet spark_catalog.imdb_10x.role_type
Output: []
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/role_type]
ReadSchema: struct<>

(29) BroadcastExchange
Input: []
Arguments: IdentityBroadcastMode, [plan_id=173]

(30) BroadcastNestedLoopJoin
Join type: Inner
Join condition: None

(31) SortAggregate
Input [2]: [name#8, title#29]
Keys: []
Functions [2]: [partial_min(name#8), partial_min(title#29)]
Aggregate Attributes [2]: [min#47, min#48]
Results [2]: [min#49, min#50]

(32) Exchange
Input [2]: [min#49, min#50]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=177]

(33) SortAggregate
Input [2]: [min#49, min#50]
Keys: []
Functions [2]: [min(name#8), min(title#29)]
Aggregate Attributes [2]: [min(name#8)#45, min(title#29)#46]
Results [2]: [min(name#8)#45 AS uncredited_voiced_character#0, min(title#29)#46 AS russian_movie#1]

(34) AdaptiveSparkPlan
Output [2]: [uncredited_voiced_character#0, russian_movie#1]
Arguments: isFinalPlan=false


Time taken: 1.873 seconds, Fetched 1 row(s)
