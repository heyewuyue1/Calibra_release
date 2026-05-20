26/04/18 03:06:54 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
26/04/18 03:06:54 WARN SparkConf: Note that spark.local.dir will be overridden by the value set by the cluster manager (via SPARK_LOCAL_DIRS in mesos/standalone/kubernetes and LOCAL_DIRS in YARN).
26/04/18 03:06:57 WARN HiveConf: HiveConf of name hive.stats.jdbc.timeout does not exist
26/04/18 03:06:57 WARN HiveConf: HiveConf of name hive.stats.retries.wait does not exist
26/04/18 03:07:00 WARN ObjectStore: Version information not found in metastore. hive.metastore.schema.verification is not enabled so recording the schema version 2.3.0
26/04/18 03:07:00 WARN ObjectStore: setMetaStoreSchemaVersion called but recording version is disabled: version = 2.3.0, comment = Set by MetaStore user@YOUR_HOST
26/04/18 03:07:01 WARN ObjectStore: Failed to get database global_temp, returning NoSuchObjectException
Spark Web UI available at http://YOUR_SPARK_MASTER_HOST:4040
Spark master: spark://YOUR_SPARK_MASTER_HOST:7077, Application Id: app-20260418030655-7138
== Physical Plan ==
AdaptiveSparkPlan (48)
+- SortAggregate (47)
   +- Exchange (46)
      +- SortAggregate (45)
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
               :           :     :        +- BroadcastHashJoin Inner BuildLeft (8)
               :           :     :           :- BroadcastExchange (4)
               :           :     :           :  +- Project (3)
               :           :     :           :     +- Filter (2)
               :           :     :           :        +- Scan parquet spark_catalog.imdb_10x.info_type (1)
               :           :     :           +- Project (7)
               :           :     :              +- Filter (6)
               :           :     :                 +- Scan parquet spark_catalog.imdb_10x.movie_info_idx (5)
               :           :     +- Sort (15)
               :           :        +- Exchange (14)
               :           :           +- Filter (13)
               :           :              +- Scan parquet spark_catalog.imdb_10x.title (12)
               :           +- Sort (21)
               :              +- Exchange (20)
               :                 +- Filter (19)
               :                    +- Scan parquet spark_catalog.imdb_10x.cast_info (18)
               +- Project (42)
                  +- SortMergeJoin Inner (41)
                     :- Sort (36)
                     :  +- Exchange (35)
                     :     +- Project (34)
                     :        +- BroadcastHashJoin Inner BuildRight (33)
                     :           :- Project (28)
                     :           :  +- Filter (27)
                     :           :     +- Scan parquet spark_catalog.imdb_10x.person_info (26)
                     :           +- BroadcastExchange (32)
                     :              +- Project (31)
                     :                 +- Filter (30)
                     :                    +- Scan parquet spark_catalog.imdb_10x.info_type (29)
                     +- Sort (40)
                        +- Exchange (39)
                           +- Filter (38)
                              +- Scan parquet spark_catalog.imdb_10x.name (37)


(1) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#5, info#6]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(2) Filter
Input [2]: [id#5, info#6]
Condition : ((isnotnull(info#6) AND (lower(info#6) = rating)) AND isnotnull(id#5))

(3) Project
Output [1]: [id#5]
Input [2]: [id#5, info#6]

(4) BroadcastExchange
Input [1]: [id#5]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=244]

(5) Scan parquet spark_catalog.imdb_10x.movie_info_idx
Output [3]: [movie_id#8, info_type_id#9, info#10]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info_idx]
PushedFilters: [IsNotNull(info_type_id), IsNotNull(movie_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(6) Filter
Input [3]: [movie_id#8, info_type_id#9, info#10]
Condition : ((((StartsWith(lower(info#10), 0) OR StartsWith(lower(info#10), 1)) OR StartsWith(lower(info#10), 2)) AND isnotnull(info_type_id#9)) AND isnotnull(movie_id#8))

(7) Project
Output [2]: [movie_id#8, info_type_id#9]
Input [3]: [movie_id#8, info_type_id#9, info#10]

(8) BroadcastHashJoin
Left keys [1]: [id#5]
Right keys [1]: [info_type_id#9]
Join type: Inner
Join condition: None

(9) Project
Output [1]: [movie_id#8]
Input [3]: [id#5, movie_id#8, info_type_id#9]

(10) Exchange
Input [1]: [movie_id#8]
Arguments: hashpartitioning(movie_id#8, 200), ENSURE_REQUIREMENTS, [plan_id=249]

(11) Sort
Input [1]: [movie_id#8]
Arguments: [movie_id#8 ASC NULLS FIRST], false, 0

(12) Scan parquet spark_catalog.imdb_10x.title
Output [2]: [id#12, title#13]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int,title:string>

(13) Filter
Input [2]: [id#12, title#13]
Condition : isnotnull(id#12)

(14) Exchange
Input [2]: [id#12, title#13]
Arguments: hashpartitioning(id#12, 200), ENSURE_REQUIREMENTS, [plan_id=250]

(15) Sort
Input [2]: [id#12, title#13]
Arguments: [id#12 ASC NULLS FIRST], false, 0

(16) SortMergeJoin
Left keys [1]: [movie_id#8]
Right keys [1]: [id#12]
Join type: Inner
Join condition: None

(17) Project
Output [2]: [id#12, title#13]
Input [3]: [movie_id#8, id#12, title#13]

(18) Scan parquet spark_catalog.imdb_10x.cast_info
Output [2]: [person_id#25, movie_id#26]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/cast_info]
PushedFilters: [IsNotNull(movie_id), IsNotNull(person_id)]
ReadSchema: struct<person_id:int,movie_id:int>

(19) Filter
Input [2]: [person_id#25, movie_id#26]
Condition : (isnotnull(movie_id#26) AND isnotnull(person_id#25))

(20) Exchange
Input [2]: [person_id#25, movie_id#26]
Arguments: hashpartitioning(movie_id#26, 200), ENSURE_REQUIREMENTS, [plan_id=257]

(21) Sort
Input [2]: [person_id#25, movie_id#26]
Arguments: [movie_id#26 ASC NULLS FIRST], false, 0

(22) SortMergeJoin
Left keys [1]: [id#12]
Right keys [1]: [movie_id#26]
Join type: Inner
Join condition: None

(23) Project
Output [2]: [title#13, person_id#25]
Input [4]: [id#12, title#13, person_id#25, movie_id#26]

(24) Exchange
Input [2]: [title#13, person_id#25]
Arguments: hashpartitioning(person_id#25, 200), ENSURE_REQUIREMENTS, [plan_id=274]

(25) Sort
Input [2]: [title#13, person_id#25]
Arguments: [person_id#25 ASC NULLS FIRST], false, 0

(26) Scan parquet spark_catalog.imdb_10x.person_info
Output [3]: [person_id#41, info_type_id#42, info#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/person_info]
PushedFilters: [IsNotNull(info), IsNotNull(person_id), IsNotNull(info_type_id)]
ReadSchema: struct<person_id:int,info_type_id:int,info:string>

(27) Filter
Input [3]: [person_id#41, info_type_id#42, info#43]
Condition : (((isnotnull(info#43) AND Contains(lower(info#43), usa)) AND isnotnull(person_id#41)) AND isnotnull(info_type_id#42))

(28) Project
Output [2]: [person_id#41, info_type_id#42]
Input [3]: [person_id#41, info_type_id#42, info#43]

(29) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#45, info#46]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(30) Filter
Input [2]: [id#45, info#46]
Condition : ((isnotnull(info#46) AND Contains(lower(info#46), birth)) AND isnotnull(id#45))

(31) Project
Output [1]: [id#45]
Input [2]: [id#45, info#46]

(32) BroadcastExchange
Input [1]: [id#45]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=261]

(33) BroadcastHashJoin
Left keys [1]: [info_type_id#42]
Right keys [1]: [id#45]
Join type: Inner
Join condition: None

(34) Project
Output [1]: [person_id#41]
Input [3]: [person_id#41, info_type_id#42, id#45]

(35) Exchange
Input [1]: [person_id#41]
Arguments: hashpartitioning(person_id#41, 200), ENSURE_REQUIREMENTS, [plan_id=266]

(36) Sort
Input [1]: [person_id#41]
Arguments: [person_id#41 ASC NULLS FIRST], false, 0

(37) Scan parquet spark_catalog.imdb_10x.name
Output [2]: [id#31, name#32]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/name]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int,name:string>

(38) Filter
Input [2]: [id#31, name#32]
Condition : isnotnull(id#31)

(39) Exchange
Input [2]: [id#31, name#32]
Arguments: hashpartitioning(id#31, 200), ENSURE_REQUIREMENTS, [plan_id=267]

(40) Sort
Input [2]: [id#31, name#32]
Arguments: [id#31 ASC NULLS FIRST], false, 0

(41) SortMergeJoin
Left keys [1]: [person_id#41]
Right keys [1]: [id#31]
Join type: Inner
Join condition: None

(42) Project
Output [2]: [id#31, name#32]
Input [3]: [person_id#41, id#31, name#32]

(43) SortMergeJoin
Left keys [1]: [person_id#25]
Right keys [1]: [id#31]
Join type: Inner
Join condition: None

(44) Project
Output [2]: [title#13, name#32]
Input [4]: [title#13, person_id#25, id#31, name#32]

(45) SortAggregate
Input [2]: [title#13, name#32]
Keys: []
Functions [2]: [partial_min(name#32), partial_min(title#13)]
Aggregate Attributes [2]: [min#58, min#59]
Results [2]: [min#60, min#61]

(46) Exchange
Input [2]: [min#60, min#61]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=280]

(47) SortAggregate
Input [2]: [min#60, min#61]
Keys: []
Functions [2]: [min(name#32), min(title#13)]
Aggregate Attributes [2]: [min(name#32)#47, min(title#13)#48]
Results [2]: [min(name#32)#47 AS min(name)#49, min(title#13)#48 AS min(title)#50]

(48) AdaptiveSparkPlan
Output [2]: [min(name)#49, min(title)#50]
Arguments: isFinalPlan=false


Time taken: 1.689 seconds, Fetched 1 row(s)
