26/04/18 03:08:54 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
26/04/18 03:08:54 WARN SparkConf: Note that spark.local.dir will be overridden by the value set by the cluster manager (via SPARK_LOCAL_DIRS in mesos/standalone/kubernetes and LOCAL_DIRS in YARN).
26/04/18 03:08:57 WARN HiveConf: HiveConf of name hive.stats.jdbc.timeout does not exist
26/04/18 03:08:57 WARN HiveConf: HiveConf of name hive.stats.retries.wait does not exist
26/04/18 03:08:59 WARN ObjectStore: Version information not found in metastore. hive.metastore.schema.verification is not enabled so recording the schema version 2.3.0
26/04/18 03:08:59 WARN ObjectStore: setMetaStoreSchemaVersion called but recording version is disabled: version = 2.3.0, comment = Set by MetaStore user@YOUR_HOST
26/04/18 03:09:01 WARN ObjectStore: Failed to get database global_temp, returning NoSuchObjectException
Spark Web UI available at http://YOUR_SPARK_MASTER_HOST:4040
Spark master: spark://YOUR_SPARK_MASTER_HOST:7077, Application Id: app-20260418030855-7142
== Physical Plan ==
AdaptiveSparkPlan (48)
+- HashAggregate (47)
   +- Exchange (46)
      +- HashAggregate (45)
         +- Project (44)
            +- SortMergeJoin Inner (43)
               :- Sort (25)
               :  +- Exchange (24)
               :     +- Project (23)
               :        +- SortMergeJoin Inner (22)
               :           :- Project (17)
               :           :  +- SortMergeJoin Inner (16)
               :           :     :- Sort (11)
               :           :     :  +- Exchange (10)
               :           :     :     +- Project (9)
               :           :     :        +- BroadcastHashJoin Inner BuildRight (8)
               :           :     :           :- Project (3)
               :           :     :           :  +- Filter (2)
               :           :     :           :     +- Scan parquet spark_catalog.imdb_10x.person_info (1)
               :           :     :           +- BroadcastExchange (7)
               :           :     :              +- Project (6)
               :           :     :                 +- Filter (5)
               :           :     :                    +- Scan parquet spark_catalog.imdb_10x.info_type (4)
               :           :     +- Sort (15)
               :           :        +- Exchange (14)
               :           :           +- Filter (13)
               :           :              +- Scan parquet spark_catalog.imdb_10x.name (12)
               :           +- Sort (21)
               :              +- Exchange (20)
               :                 +- Filter (19)
               :                    +- Scan parquet spark_catalog.imdb_10x.cast_info (18)
               +- Project (42)
                  +- SortMergeJoin Inner (41)
                     :- Sort (36)
                     :  +- Exchange (35)
                     :     +- Project (34)
                     :        +- BroadcastHashJoin Inner BuildLeft (33)
                     :           :- BroadcastExchange (29)
                     :           :  +- Project (28)
                     :           :     +- Filter (27)
                     :           :        +- Scan parquet spark_catalog.imdb_10x.info_type (26)
                     :           +- Project (32)
                     :              +- Filter (31)
                     :                 +- Scan parquet spark_catalog.imdb_10x.movie_info (30)
                     +- Sort (40)
                        +- Exchange (39)
                           +- Filter (38)
                              +- Scan parquet spark_catalog.imdb_10x.title (37)


(1) Scan parquet spark_catalog.imdb_10x.person_info
Output [3]: [person_id#42, info_type_id#43, info#44]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/person_info]
PushedFilters: [IsNotNull(info), IsNotNull(person_id), IsNotNull(info_type_id)]
ReadSchema: struct<person_id:int,info_type_id:int,info:string>

(2) Filter
Input [3]: [person_id#42, info_type_id#43, info#44]
Condition : (((isnotnull(info#44) AND Contains(lower(info#44), india)) AND isnotnull(person_id#42)) AND isnotnull(info_type_id#43))

(3) Project
Output [2]: [person_id#42, info_type_id#43]
Input [3]: [person_id#42, info_type_id#43, info#44]

(4) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#46, info#47]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(5) Filter
Input [2]: [id#46, info#47]
Condition : ((isnotnull(info#47) AND Contains(lower(info#47), birth)) AND isnotnull(id#46))

(6) Project
Output [1]: [id#46]
Input [2]: [id#46, info#47]

(7) BroadcastExchange
Input [1]: [id#46]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=244]

(8) BroadcastHashJoin
Left keys [1]: [info_type_id#43]
Right keys [1]: [id#46]
Join type: Inner
Join condition: None

(9) Project
Output [1]: [person_id#42]
Input [3]: [person_id#42, info_type_id#43, id#46]

(10) Exchange
Input [1]: [person_id#42]
Arguments: hashpartitioning(person_id#42, 200), ENSURE_REQUIREMENTS, [plan_id=249]

(11) Sort
Input [1]: [person_id#42]
Arguments: [person_id#42 ASC NULLS FIRST], false, 0

(12) Scan parquet spark_catalog.imdb_10x.name
Output [1]: [id#32]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/name]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int>

(13) Filter
Input [1]: [id#32]
Condition : isnotnull(id#32)

(14) Exchange
Input [1]: [id#32]
Arguments: hashpartitioning(id#32, 200), ENSURE_REQUIREMENTS, [plan_id=250]

(15) Sort
Input [1]: [id#32]
Arguments: [id#32 ASC NULLS FIRST], false, 0

(16) SortMergeJoin
Left keys [1]: [person_id#42]
Right keys [1]: [id#32]
Join type: Inner
Join condition: None

(17) Project
Output [1]: [id#32]
Input [2]: [person_id#42, id#32]

(18) Scan parquet spark_catalog.imdb_10x.cast_info
Output [2]: [person_id#26, movie_id#27]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/cast_info]
PushedFilters: [IsNotNull(movie_id), IsNotNull(person_id)]
ReadSchema: struct<person_id:int,movie_id:int>

(19) Filter
Input [2]: [person_id#26, movie_id#27]
Condition : (isnotnull(movie_id#27) AND isnotnull(person_id#26))

(20) Exchange
Input [2]: [person_id#26, movie_id#27]
Arguments: hashpartitioning(person_id#26, 200), ENSURE_REQUIREMENTS, [plan_id=257]

(21) Sort
Input [2]: [person_id#26, movie_id#27]
Arguments: [person_id#26 ASC NULLS FIRST], false, 0

(22) SortMergeJoin
Left keys [1]: [id#32]
Right keys [1]: [person_id#26]
Join type: Inner
Join condition: None

(23) Project
Output [1]: [movie_id#27]
Input [3]: [id#32, person_id#26, movie_id#27]

(24) Exchange
Input [1]: [movie_id#27]
Arguments: hashpartitioning(movie_id#27, 200), ENSURE_REQUIREMENTS, [plan_id=274]

(25) Sort
Input [1]: [movie_id#27]
Arguments: [movie_id#27 ASC NULLS FIRST], false, 0

(26) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#6, info#7]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(27) Filter
Input [2]: [id#6, info#7]
Condition : ((isnotnull(info#7) AND Contains(lower(info#7), count)) AND isnotnull(id#6))

(28) Project
Output [1]: [id#6]
Input [2]: [id#6, info#7]

(29) BroadcastExchange
Input [1]: [id#6]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=261]

(30) Scan parquet spark_catalog.imdb_10x.movie_info
Output [3]: [movie_id#21, info_type_id#22, info#23]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [IsNotNull(info), IsNotNull(info_type_id), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(31) Filter
Input [3]: [movie_id#21, info_type_id#22, info#23]
Condition : (((isnotnull(info#23) AND Contains(lower(info#23), usa)) AND isnotnull(info_type_id#22)) AND isnotnull(movie_id#21))

(32) Project
Output [2]: [movie_id#21, info_type_id#22]
Input [3]: [movie_id#21, info_type_id#22, info#23]

(33) BroadcastHashJoin
Left keys [1]: [id#6]
Right keys [1]: [info_type_id#22]
Join type: Inner
Join condition: None

(34) Project
Output [1]: [movie_id#21]
Input [3]: [id#6, movie_id#21, info_type_id#22]

(35) Exchange
Input [1]: [movie_id#21]
Arguments: hashpartitioning(movie_id#21, 200), ENSURE_REQUIREMENTS, [plan_id=266]

(36) Sort
Input [1]: [movie_id#21]
Arguments: [movie_id#21 ASC NULLS FIRST], false, 0

(37) Scan parquet spark_catalog.imdb_10x.title
Output [1]: [id#8]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int>

(38) Filter
Input [1]: [id#8]
Condition : isnotnull(id#8)

(39) Exchange
Input [1]: [id#8]
Arguments: hashpartitioning(id#8, 200), ENSURE_REQUIREMENTS, [plan_id=267]

(40) Sort
Input [1]: [id#8]
Arguments: [id#8 ASC NULLS FIRST], false, 0

(41) SortMergeJoin
Left keys [1]: [movie_id#21]
Right keys [1]: [id#8]
Join type: Inner
Join condition: None

(42) Project
Output [1]: [id#8]
Input [2]: [movie_id#21, id#8]

(43) SortMergeJoin
Left keys [1]: [movie_id#27]
Right keys [1]: [id#8]
Join type: Inner
Join condition: None

(44) Project
Output: []
Input [2]: [movie_id#27, id#8]

(45) HashAggregate
Input: []
Keys: []
Functions [1]: [partial_count(1)]
Aggregate Attributes [1]: [count#56L]
Results [1]: [count#57L]

(46) Exchange
Input [1]: [count#57L]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=280]

(47) HashAggregate
Input [1]: [count#57L]
Keys: []
Functions [1]: [count(1)]
Aggregate Attributes [1]: [count(1)#5L]
Results [1]: [count(1)#5L AS count(1)#48L]

(48) AdaptiveSparkPlan
Output [1]: [count(1)#48L]
Arguments: isFinalPlan=false


Time taken: 1.788 seconds, Fetched 1 row(s)
