26/04/18 03:22:13 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
26/04/18 03:22:14 WARN SparkConf: Note that spark.local.dir will be overridden by the value set by the cluster manager (via SPARK_LOCAL_DIRS in mesos/standalone/kubernetes and LOCAL_DIRS in YARN).
26/04/18 03:22:16 WARN HiveConf: HiveConf of name hive.stats.jdbc.timeout does not exist
26/04/18 03:22:16 WARN HiveConf: HiveConf of name hive.stats.retries.wait does not exist
26/04/18 03:22:19 WARN ObjectStore: Version information not found in metastore. hive.metastore.schema.verification is not enabled so recording the schema version 2.3.0
26/04/18 03:22:19 WARN ObjectStore: setMetaStoreSchemaVersion called but recording version is disabled: version = 2.3.0, comment = Set by MetaStore user@YOUR_HOST
26/04/18 03:22:20 WARN ObjectStore: Failed to get database global_temp, returning NoSuchObjectException
Spark Web UI available at http://YOUR_SPARK_MASTER_HOST:4040
Spark master: spark://YOUR_SPARK_MASTER_HOST:7077, Application Id: app-20260418032215-7182
== Physical Plan ==
AdaptiveSparkPlan (42)
+- SortAggregate (41)
   +- Exchange (40)
      +- SortAggregate (39)
         +- Project (38)
            +- SortMergeJoin Inner (37)
               :- Project (26)
               :  +- BroadcastHashJoin Inner BuildRight (25)
               :     :- Project (21)
               :     :  +- SortMergeJoin Inner (20)
               :     :     :- Sort (15)
               :     :     :  +- Exchange (14)
               :     :     :     +- Project (13)
               :     :     :        +- BroadcastHashJoin Inner BuildLeft (12)
               :     :     :           :- BroadcastExchange (9)
               :     :     :           :  +- Project (8)
               :     :     :           :     +- BroadcastHashJoin Inner BuildRight (7)
               :     :     :           :        :- Filter (2)
               :     :     :           :        :  +- Scan parquet spark_catalog.imdb_10x.title (1)
               :     :     :           :        +- BroadcastExchange (6)
               :     :     :           :           +- Project (5)
               :     :     :           :              +- Filter (4)
               :     :     :           :                 +- Scan parquet spark_catalog.imdb_10x.movie_info (3)
               :     :     :           +- Filter (11)
               :     :     :              +- Scan parquet spark_catalog.imdb_10x.cast_info (10)
               :     :     +- Sort (19)
               :     :        +- Exchange (18)
               :     :           +- Filter (17)
               :     :              +- Scan parquet spark_catalog.imdb_10x.name (16)
               :     +- BroadcastExchange (24)
               :        +- Filter (23)
               :           +- Scan parquet spark_catalog.imdb_10x.info_type (22)
               +- Sort (36)
                  +- Exchange (35)
                     +- Project (34)
                        +- BroadcastHashJoin Inner BuildRight (33)
                           :- Filter (28)
                           :  +- Scan parquet spark_catalog.imdb_10x.person_info (27)
                           +- BroadcastExchange (32)
                              +- Project (31)
                                 +- Filter (30)
                                    +- Scan parquet spark_catalog.imdb_10x.info_type (29)


(1) Scan parquet spark_catalog.imdb_10x.title
Output [2]: [id#28, title#29]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/title]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int,title:string>

(2) Filter
Input [2]: [id#28, title#29]
Condition : isnotnull(id#28)

(3) Scan parquet spark_catalog.imdb_10x.movie_info
Output [3]: [movie_id#41, info_type_id#42, info#43]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [IsNotNull(info), IsNotNull(movie_id), EqualTo(info_type_id,3), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(4) Filter
Input [3]: [movie_id#41, info_type_id#42, info#43]
Condition : ((((isnotnull(info#43) AND Contains(lower(info#43), documentary)) AND isnotnull(movie_id#41)) AND (info_type_id#42 = 3)) AND isnotnull(info_type_id#42))

(5) Project
Output [2]: [movie_id#41, info_type_id#42]
Input [3]: [movie_id#41, info_type_id#42, info#43]

(6) BroadcastExchange
Input [2]: [movie_id#41, info_type_id#42]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=248]

(7) BroadcastHashJoin
Left keys [1]: [id#28]
Right keys [1]: [movie_id#41]
Join type: Inner
Join condition: None

(8) Project
Output [3]: [id#28, title#29, info_type_id#42]
Input [4]: [id#28, title#29, movie_id#41, info_type_id#42]

(9) BroadcastExchange
Input [3]: [id#28, title#29, info_type_id#42]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=252]

(10) Scan parquet spark_catalog.imdb_10x.cast_info
Output [2]: [person_id#22, movie_id#23]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/cast_info]
PushedFilters: [IsNotNull(person_id), IsNotNull(movie_id)]
ReadSchema: struct<person_id:int,movie_id:int>

(11) Filter
Input [2]: [person_id#22, movie_id#23]
Condition : (isnotnull(person_id#22) AND isnotnull(movie_id#23))

(12) BroadcastHashJoin
Left keys [1]: [id#28]
Right keys [1]: [movie_id#23]
Join type: Inner
Join condition: None

(13) Project
Output [3]: [title#29, info_type_id#42, person_id#22]
Input [5]: [id#28, title#29, info_type_id#42, person_id#22, movie_id#23]

(14) Exchange
Input [3]: [title#29, info_type_id#42, person_id#22]
Arguments: hashpartitioning(person_id#22, 200), ENSURE_REQUIREMENTS, [plan_id=257]

(15) Sort
Input [3]: [title#29, info_type_id#42, person_id#22]
Arguments: [person_id#22 ASC NULLS FIRST], false, 0

(16) Scan parquet spark_catalog.imdb_10x.name
Output [1]: [id#12]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/name]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int>

(17) Filter
Input [1]: [id#12]
Condition : isnotnull(id#12)

(18) Exchange
Input [1]: [id#12]
Arguments: hashpartitioning(id#12, 200), ENSURE_REQUIREMENTS, [plan_id=258]

(19) Sort
Input [1]: [id#12]
Arguments: [id#12 ASC NULLS FIRST], false, 0

(20) SortMergeJoin
Left keys [1]: [person_id#22]
Right keys [1]: [id#12]
Join type: Inner
Join condition: None

(21) Project
Output [3]: [title#29, info_type_id#42, id#12]
Input [4]: [title#29, info_type_id#42, person_id#22, id#12]

(22) Scan parquet spark_catalog.imdb_10x.info_type
Output [1]: [id#45]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(id), EqualTo(id,3)]
ReadSchema: struct<id:int>

(23) Filter
Input [1]: [id#45]
Condition : (isnotnull(id#45) AND (id#45 = 3))

(24) BroadcastExchange
Input [1]: [id#45]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, false] as bigint)),false), [plan_id=264]

(25) BroadcastHashJoin
Left keys [1]: [info_type_id#42]
Right keys [1]: [id#45]
Join type: Inner
Join condition: None

(26) Project
Output [2]: [title#29, id#12]
Input [4]: [title#29, info_type_id#42, id#12, id#45]

(27) Scan parquet spark_catalog.imdb_10x.person_info
Output [3]: [person_id#6, info_type_id#7, info#8]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/person_info]
PushedFilters: [IsNotNull(info_type_id), IsNotNull(person_id)]
ReadSchema: struct<person_id:int,info_type_id:int,info:string>

(28) Filter
Input [3]: [person_id#6, info_type_id#7, info#8]
Condition : (((((Contains(lower(info#8), 189) OR StartsWith(lower(info#8), 188)) OR StartsWith(lower(info#8), 187)) OR ((StartsWith(lower(info#8), 186) OR StartsWith(lower(info#8), 185)) OR StartsWith(lower(info#8), 184))) AND isnotnull(info_type_id#7)) AND isnotnull(person_id#6))

(29) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#10, info#11]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(30) Filter
Input [2]: [id#10, info#11]
Condition : ((isnotnull(info#11) AND (lower(info#11) = birth date)) AND isnotnull(id#10))

(31) Project
Output [1]: [id#10]
Input [2]: [id#10, info#11]

(32) BroadcastExchange
Input [1]: [id#10]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=267]

(33) BroadcastHashJoin
Left keys [1]: [info_type_id#7]
Right keys [1]: [id#10]
Join type: Inner
Join condition: None

(34) Project
Output [2]: [person_id#6, info#8]
Input [4]: [person_id#6, info_type_id#7, info#8, id#10]

(35) Exchange
Input [2]: [person_id#6, info#8]
Arguments: hashpartitioning(person_id#6, 200), ENSURE_REQUIREMENTS, [plan_id=272]

(36) Sort
Input [2]: [person_id#6, info#8]
Arguments: [person_id#6 ASC NULLS FIRST], false, 0

(37) SortMergeJoin
Left keys [1]: [id#12]
Right keys [1]: [person_id#6]
Join type: Inner
Join condition: None

(38) Project
Output [2]: [info#8, title#29]
Input [4]: [title#29, id#12, person_id#6, info#8]

(39) SortAggregate
Input [2]: [info#8, title#29]
Keys: []
Functions [2]: [partial_min(title#29), partial_min(info#8)]
Aggregate Attributes [2]: [min#58, min#59]
Results [2]: [min#60, min#61]

(40) Exchange
Input [2]: [min#60, min#61]
Arguments: SinglePartition, ENSURE_REQUIREMENTS, [plan_id=278]

(41) SortAggregate
Input [2]: [min#60, min#61]
Keys: []
Functions [2]: [min(title#29), min(info#8)]
Aggregate Attributes [2]: [min(title#29)#47, min(info#8)#48]
Results [2]: [min(title#29)#47 AS min(title)#49, min(info#8)#48 AS min(info)#50]

(42) AdaptiveSparkPlan
Output [2]: [min(title)#49, min(info)#50]
Arguments: isFinalPlan=false


Time taken: 1.913 seconds, Fetched 1 row(s)
