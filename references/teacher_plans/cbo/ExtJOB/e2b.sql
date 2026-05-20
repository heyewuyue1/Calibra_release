26/04/18 03:13:00 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
26/04/18 03:13:01 WARN SparkConf: Note that spark.local.dir will be overridden by the value set by the cluster manager (via SPARK_LOCAL_DIRS in mesos/standalone/kubernetes and LOCAL_DIRS in YARN).
26/04/18 03:13:04 WARN HiveConf: HiveConf of name hive.stats.jdbc.timeout does not exist
26/04/18 03:13:04 WARN HiveConf: HiveConf of name hive.stats.retries.wait does not exist
26/04/18 03:13:06 WARN ObjectStore: Version information not found in metastore. hive.metastore.schema.verification is not enabled so recording the schema version 2.3.0
26/04/18 03:13:06 WARN ObjectStore: setMetaStoreSchemaVersion called but recording version is disabled: version = 2.3.0, comment = Set by MetaStore user@YOUR_HOST
26/04/18 03:13:07 WARN ObjectStore: Failed to get database global_temp, returning NoSuchObjectException
Spark Web UI available at http://YOUR_SPARK_MASTER_HOST:4040
Spark master: spark://YOUR_SPARK_MASTER_HOST:7077, Application Id: app-20260418031302-7154
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
Output [1]: [movie_id#21]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_companies]
PushedFilters: [IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int>

(2) Filter
Input [1]: [movie_id#21]
Condition : isnotnull(movie_id#21)

(3) Exchange
Input [1]: [movie_id#21]
Arguments: hashpartitioning(movie_id#21, 200), ENSURE_REQUIREMENTS, [plan_id=151]

(4) Sort
Input [1]: [movie_id#21]
Arguments: [movie_id#21 ASC NULLS FIRST], false, 0

(5) Scan parquet spark_catalog.imdb_10x.title
Output [3]: [id#27, title#28, production_year#31]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(production_year), IsNotNull(id)]
ReadSchema: struct<id:int,title:string,production_year:string>

(6) Filter
Input [3]: [id#27, title#28, production_year#31]
Condition : ((isnotnull(production_year#31) AND (cast(production_year#31 as int) > 2010)) AND isnotnull(id#27))

(7) Project
Output [2]: [id#27, title#28]
Input [3]: [id#27, title#28, production_year#31]

(8) Exchange
Input [2]: [id#27, title#28]
Arguments: hashpartitioning(id#27, 200), ENSURE_REQUIREMENTS, [plan_id=152]

(9) Sort
Input [2]: [id#27, title#28]
Arguments: [id#27 ASC NULLS FIRST], false, 0

(10) SortMergeJoin
Left keys [1]: [movie_id#21]
Right keys [1]: [id#27]
Join type: Inner
Join condition: None

(11) Exchange
Input [3]: [movie_id#21, id#27, title#28]
Arguments: hashpartitioning(movie_id#21, movie_id#21, 200), ENSURE_REQUIREMENTS, [plan_id=159]

(12) Sort
Input [3]: [movie_id#21, id#27, title#28]
Arguments: [movie_id#21 ASC NULLS FIRST, id#27 ASC NULLS FIRST], false, 0

(13) Scan parquet spark_catalog.imdb_10x.cast_info
Output [3]: [movie_id#15, person_role_id#16, note#17]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/cast_info]
PushedFilters: [IsNotNull(note), Not(StringContains(note,(voice))), StringContains(note,(uncredited)), IsNotNull(person_role_id), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,person_role_id:string,note:string>

(14) Filter
Input [3]: [movie_id#15, person_role_id#16, note#17]
Condition : ((((isnotnull(note#17) AND NOT Contains(note#17, (voice))) AND Contains(note#17, (uncredited))) AND isnotnull(person_role_id#16)) AND isnotnull(movie_id#15))

(15) Project
Output [2]: [movie_id#15, person_role_id#16]
Input [3]: [movie_id#15, person_role_id#16, note#17]

(16) Exchange
Input [2]: [movie_id#15, person_role_id#16]
Arguments: hashpartitioning(movie_id#15, movie_id#15, 200), ENSURE_REQUIREMENTS, [plan_id=158]

(17) Sort
Input [2]: [movie_id#15, person_role_id#16]
Arguments: [movie_id#15 ASC NULLS FIRST, movie_id#15 ASC NULLS FIRST], false, 0

(18) SortMergeJoin
Left keys [2]: [movie_id#21, id#27]
Right keys [2]: [movie_id#15, movie_id#15]
Join type: Inner
Join condition: None

(19) Project
Output [2]: [title#28, person_role_id#16]
Input [5]: [movie_id#21, id#27, title#28, movie_id#15, person_role_id#16]

(20) Exchange
Input [2]: [title#28, person_role_id#16]
Arguments: hashpartitioning(cast(person_role_id#16 as int), 200), ENSURE_REQUIREMENTS, [plan_id=166]

(21) Sort
Input [2]: [title#28, person_role_id#16]
Arguments: [cast(person_role_id#16 as int) ASC NULLS FIRST], false, 0

(22) Scan parquet spark_catalog.imdb_10x.char_name
Output [2]: [id#6, name#7]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/char_name]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int,name:string>

(23) Filter
Input [2]: [id#6, name#7]
Condition : isnotnull(id#6)

(24) Exchange
Input [2]: [id#6, name#7]
Arguments: hashpartitioning(id#6, 200), ENSURE_REQUIREMENTS, [plan_id=167]

(25) Sort
Input [2]: [id#6, name#7]
Arguments: [id#6 ASC NULLS FIRST], false, 0

(26) SortMergeJoin
Left keys [1]: [cast(person_role_id#16 as int)]
Right keys [1]: [id#6]
Join type: Inner
Join condition: None

(27) Project
Output [2]: [name#7, title#28]
Input [4]: [title#28, person_role_id#16, id#6, name#7]

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
Input [2]: [name#7, title#28]
Keys: []
Functions [2]: [partial_min(name#7), partial_min(title#28)]
Aggregate Attributes [2]: [min#47, min#48]
Results [2]: [min#49, min#50]

(32) Exchange
Input [2]: [min#49, min#50]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=177]

(33) SortAggregate
Input [2]: [min#49, min#50]
Keys: []
Functions [2]: [min(name#7), min(title#28)]
Aggregate Attributes [2]: [min(name#7)#44, min(title#28)#45]
Results [2]: [min(name#7)#44 AS uncredited_voiced_character#0, min(title#28)#45 AS min(title)#46]

(34) AdaptiveSparkPlan
Output [2]: [uncredited_voiced_character#0, min(title)#46]
Arguments: isFinalPlan=false


Time taken: 1.718 seconds, Fetched 1 row(s)
