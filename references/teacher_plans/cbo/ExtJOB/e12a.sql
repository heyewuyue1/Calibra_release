26/04/18 03:09:50 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
26/04/18 03:09:50 WARN SparkConf: Note that spark.local.dir will be overridden by the value set by the cluster manager (via SPARK_LOCAL_DIRS in mesos/standalone/kubernetes and LOCAL_DIRS in YARN).
26/04/18 03:09:54 WARN HiveConf: HiveConf of name hive.stats.jdbc.timeout does not exist
26/04/18 03:09:54 WARN HiveConf: HiveConf of name hive.stats.retries.wait does not exist
26/04/18 03:09:56 WARN ObjectStore: Version information not found in metastore. hive.metastore.schema.verification is not enabled so recording the schema version 2.3.0
26/04/18 03:09:56 WARN ObjectStore: setMetaStoreSchemaVersion called but recording version is disabled: version = 2.3.0, comment = Set by MetaStore user@YOUR_HOST
26/04/18 03:09:57 WARN ObjectStore: Failed to get database global_temp, returning NoSuchObjectException
Spark Web UI available at http://YOUR_SPARK_MASTER_HOST:4040
Spark master: spark://YOUR_SPARK_MASTER_HOST:7077, Application Id: app-20260418030952-7144
== Physical Plan ==
AdaptiveSparkPlan (46)
+- Project (45)
   +- Sort (44)
      +- Exchange (43)
         +- HashAggregate (42)
            +- Exchange (41)
               +- HashAggregate (40)
                  +- Project (39)
                     +- SortMergeJoin Inner (38)
                        :- Project (26)
                        :  +- SortMergeJoin Inner (25)
                        :     :- Sort (20)
                        :     :  +- Exchange (19)
                        :     :     +- Project (18)
                        :     :        +- BroadcastHashJoin Inner BuildLeft (17)
                        :     :           :- BroadcastExchange (14)
                        :     :           :  +- Project (13)
                        :     :           :     +- BroadcastHashJoin Inner BuildRight (12)
                        :     :           :        :- Project (8)
                        :     :           :        :  +- BroadcastHashJoin Inner BuildRight (7)
                        :     :           :        :     :- Filter (2)
                        :     :           :        :     :  +- Scan parquet spark_catalog.imdb_10x.title (1)
                        :     :           :        :     +- BroadcastExchange (6)
                        :     :           :        :        +- Project (5)
                        :     :           :        :           +- Filter (4)
                        :     :           :        :              +- Scan parquet spark_catalog.imdb_10x.movie_info (3)
                        :     :           :        +- BroadcastExchange (11)
                        :     :           :           +- Filter (10)
                        :     :           :              +- Scan parquet spark_catalog.imdb_10x.info_type (9)
                        :     :           +- Filter (16)
                        :     :              +- Scan parquet spark_catalog.imdb_10x.cast_info (15)
                        :     +- Sort (24)
                        :        +- Exchange (23)
                        :           +- Filter (22)
                        :              +- Scan parquet spark_catalog.imdb_10x.name (21)
                        +- Sort (37)
                           +- Exchange (36)
                              +- Project (35)
                                 +- BroadcastHashJoin Inner BuildRight (34)
                                    :- Project (29)
                                    :  +- Filter (28)
                                    :     +- Scan parquet spark_catalog.imdb_10x.person_info (27)
                                    +- BroadcastExchange (33)
                                       +- Project (32)
                                          +- Filter (31)
                                             +- Scan parquet spark_catalog.imdb_10x.info_type (30)


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
Output [3]: [movie_id#35, info_type_id#36, info#37]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/movie_info]
PushedFilters: [IsNotNull(movie_id), EqualTo(info_type_id,3), IsNotNull(info_type_id)]
ReadSchema: struct<movie_id:int,info_type_id:int,info:string>

(4) Filter
Input [3]: [movie_id#35, info_type_id#36, info#37]
Condition : ((((Contains(lower(info#37), romance) OR Contains(lower(info#37), action)) AND isnotnull(movie_id#35)) AND (info_type_id#36 = 3)) AND isnotnull(info_type_id#36))

(5) Project
Output [2]: [movie_id#35, info_type_id#36]
Input [3]: [movie_id#35, info_type_id#36, info#37]

(6) BroadcastExchange
Input [2]: [movie_id#35, info_type_id#36]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=260]

(7) BroadcastHashJoin
Left keys [1]: [id#6]
Right keys [1]: [movie_id#35]
Join type: Inner
Join condition: None

(8) Project
Output [2]: [id#6, info_type_id#36]
Input [3]: [id#6, movie_id#35, info_type_id#36]

(9) Scan parquet spark_catalog.imdb_10x.info_type
Output [1]: [id#39]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(id), EqualTo(id,3)]
ReadSchema: struct<id:int>

(10) Filter
Input [1]: [id#39]
Condition : (isnotnull(id#39) AND (id#39 = 3))

(11) BroadcastExchange
Input [1]: [id#39]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, false] as bigint)),false), [plan_id=264]

(12) BroadcastHashJoin
Left keys [1]: [info_type_id#36]
Right keys [1]: [id#39]
Join type: Inner
Join condition: None

(13) Project
Output [1]: [id#6]
Input [3]: [id#6, info_type_id#36, id#39]

(14) BroadcastExchange
Input [1]: [id#6]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=268]

(15) Scan parquet spark_catalog.imdb_10x.cast_info
Output [2]: [person_id#28, movie_id#29]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/cast_info]
PushedFilters: [IsNotNull(movie_id), IsNotNull(person_id)]
ReadSchema: struct<person_id:int,movie_id:int>

(16) Filter
Input [2]: [person_id#28, movie_id#29]
Condition : (isnotnull(movie_id#29) AND isnotnull(person_id#28))

(17) BroadcastHashJoin
Left keys [1]: [id#6]
Right keys [1]: [movie_id#29]
Join type: Inner
Join condition: None

(18) Project
Output [1]: [person_id#28]
Input [3]: [id#6, person_id#28, movie_id#29]

(19) Exchange
Input [1]: [person_id#28]
Arguments: hashpartitioning(person_id#28, 200), ENSURE_REQUIREMENTS, [plan_id=273]

(20) Sort
Input [1]: [person_id#28]
Arguments: [person_id#28 ASC NULLS FIRST], false, 0

(21) Scan parquet spark_catalog.imdb_10x.name
Output [2]: [id#18, name#19]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/name]
PushedFilters: [IsNotNull(id)]
ReadSchema: struct<id:int,name:string>

(22) Filter
Input [2]: [id#18, name#19]
Condition : isnotnull(id#18)

(23) Exchange
Input [2]: [id#18, name#19]
Arguments: hashpartitioning(id#18, 200), ENSURE_REQUIREMENTS, [plan_id=274]

(24) Sort
Input [2]: [id#18, name#19]
Arguments: [id#18 ASC NULLS FIRST], false, 0

(25) SortMergeJoin
Left keys [1]: [person_id#28]
Right keys [1]: [id#18]
Join type: Inner
Join condition: None

(26) Project
Output [2]: [id#18, name#19]
Input [3]: [person_id#28, id#18, name#19]

(27) Scan parquet spark_catalog.imdb_10x.person_info
Output [3]: [person_id#42, info_type_id#43, info#44]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/person_info]
PushedFilters: [IsNotNull(info), IsNotNull(person_id), IsNotNull(info_type_id)]
ReadSchema: struct<person_id:int,info_type_id:int,info:string>

(28) Filter
Input [3]: [person_id#42, info_type_id#43, info#44]
Condition : (((isnotnull(info#44) AND Contains(lower(info#44), usa)) AND isnotnull(person_id#42)) AND isnotnull(info_type_id#43))

(29) Project
Output [2]: [person_id#42, info_type_id#43]
Input [3]: [person_id#42, info_type_id#43, info#44]

(30) Scan parquet spark_catalog.imdb_10x.info_type
Output [2]: [id#46, info#47]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/imdb_10x_parquet/info_type]
PushedFilters: [IsNotNull(info), IsNotNull(id)]
ReadSchema: struct<id:int,info:string>

(31) Filter
Input [2]: [id#46, info#47]
Condition : ((isnotnull(info#47) AND Contains(lower(info#47), birth)) AND isnotnull(id#46))

(32) Project
Output [1]: [id#46]
Input [2]: [id#46, info#47]

(33) BroadcastExchange
Input [1]: [id#46]
Arguments: HashedRelationBroadcastMode(List(cast(input[0, int, true] as bigint)),false), [plan_id=279]

(34) BroadcastHashJoin
Left keys [1]: [info_type_id#43]
Right keys [1]: [id#46]
Join type: Inner
Join condition: None

(35) Project
Output [1]: [person_id#42]
Input [3]: [person_id#42, info_type_id#43, id#46]

(36) Exchange
Input [1]: [person_id#42]
Arguments: hashpartitioning(person_id#42, 200), ENSURE_REQUIREMENTS, [plan_id=284]

(37) Sort
Input [1]: [person_id#42]
Arguments: [person_id#42 ASC NULLS FIRST], false, 0

(38) SortMergeJoin
Left keys [1]: [id#18]
Right keys [1]: [person_id#42]
Join type: Inner
Join condition: None

(39) Project
Output [1]: [name#19]
Input [3]: [id#18, name#19, person_id#42]

(40) HashAggregate
Input [1]: [name#19]
Keys [1]: [name#19]
Functions [1]: [partial_count(1)]
Aggregate Attributes [1]: [count#56L]
Results [2]: [name#19, count#57L]

(41) Exchange
Input [2]: [name#19, count#57L]
Arguments: hashpartitioning(name#19, 200), ENSURE_REQUIREMENTS, [plan_id=290]

(42) HashAggregate
Input [2]: [name#19, count#57L]
Keys [1]: [name#19]
Functions [1]: [count(1)]
Aggregate Attributes [1]: [count(1)#5L]
Results [2]: [name#19, count(1)#5L AS count(1)#48L]

(43) Exchange
Input [2]: [name#19, count(1)#48L]
Arguments: rangepartitioning(count(1)#48L DESC NULLS LAST, 200), ENSURE_REQUIREMENTS, [plan_id=293]

(44) Sort
Input [2]: [name#19, count(1)#48L]
Arguments: [count(1)#48L DESC NULLS LAST], true, 0

(45) Project
Output [1]: [name#19]
Input [2]: [name#19, count(1)#48L]

(46) AdaptiveSparkPlan
Output [1]: [name#19]
Arguments: isFinalPlan=false


Time taken: 1.742 seconds, Fetched 1 row(s)
