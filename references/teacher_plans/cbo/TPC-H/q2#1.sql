== Physical Plan ==
AdaptiveSparkPlan (62)
+- TakeOrderedAndProject (61)
   +- Project (60)
      +- SortMergeJoin Inner (59)
         :- Sort (43)
         :  +- Exchange (42)
         :     +- Project (41)
         :        +- SortMergeJoin Inner (40)
         :           :- Sort (35)
         :           :  +- Exchange (34)
         :           :     +- Project (33)
         :           :        +- SortMergeJoin Inner (32)
         :           :           :- Sort (5)
         :           :           :  +- Exchange (4)
         :           :           :     +- Project (3)
         :           :           :        +- Filter (2)
         :           :           :           +- Scan parquet spark_catalog.tpch_sf100.part (1)
         :           :           +- Sort (31)
         :           :              +- Filter (30)
         :           :                 +- HashAggregate (29)
         :           :                    +- Exchange (28)
         :           :                       +- HashAggregate (27)
         :           :                          +- Project (26)
         :           :                             +- SortMergeJoin Inner (25)
         :           :                                :- Sort (20)
         :           :                                :  +- Exchange (19)
         :           :                                :     +- Project (18)
         :           :                                :        +- BroadcastHashJoin Inner BuildLeft (17)
         :           :                                :           :- BroadcastExchange (14)
         :           :                                :           :  +- Project (13)
         :           :                                :           :     +- BroadcastHashJoin Inner BuildRight (12)
         :           :                                :           :        :- Filter (7)
         :           :                                :           :        :  +- Scan parquet spark_catalog.tpch_sf100.nation (6)
         :           :                                :           :        +- BroadcastExchange (11)
         :           :                                :           :           +- Project (10)
         :           :                                :           :              +- Filter (9)
         :           :                                :           :                 +- Scan parquet spark_catalog.tpch_sf100.region (8)
         :           :                                :           +- Filter (16)
         :           :                                :              +- Scan parquet spark_catalog.tpch_sf100.supplier (15)
         :           :                                +- Sort (24)
         :           :                                   +- Exchange (23)
         :           :                                      +- Filter (22)
         :           :                                         +- Scan parquet spark_catalog.tpch_sf100.partsupp (21)
         :           +- Sort (39)
         :              +- Exchange (38)
         :                 +- Filter (37)
         :                    +- Scan parquet spark_catalog.tpch_sf100.partsupp (36)
         +- Sort (58)
            +- Exchange (57)
               +- Project (56)
                  +- BroadcastHashJoin Inner BuildLeft (55)
                     :- BroadcastExchange (52)
                     :  +- Project (51)
                     :     +- BroadcastHashJoin Inner BuildRight (50)
                     :        :- Filter (45)
                     :        :  +- Scan parquet spark_catalog.tpch_sf100.nation (44)
                     :        +- BroadcastExchange (49)
                     :           +- Project (48)
                     :              +- Filter (47)
                     :                 +- Scan parquet spark_catalog.tpch_sf100.region (46)
                     +- Filter (54)
                        +- Scan parquet spark_catalog.tpch_sf100.supplier (53)


(1) Scan parquet spark_catalog.tpch_sf100.part
Output [4]: [p_partkey#199L, p_mfgr#201, p_type#203, p_size#204]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/part]
PushedFilters: [IsNotNull(p_size), IsNotNull(p_type), EqualTo(p_size,28), StringEndsWith(p_type,BRASS), IsNotNull(p_partkey)]
ReadSchema: struct<p_partkey:bigint,p_mfgr:string,p_type:string,p_size:int>

(2) Filter
Input [4]: [p_partkey#199L, p_mfgr#201, p_type#203, p_size#204]
Condition : ((((isnotnull(p_size#204) AND isnotnull(p_type#203)) AND (p_size#204 = 28)) AND EndsWith(p_type#203, BRASS)) AND isnotnull(p_partkey#199L))

(3) Project
Output [2]: [p_partkey#199L, p_mfgr#201]
Input [4]: [p_partkey#199L, p_mfgr#201, p_type#203, p_size#204]

(4) Exchange
Input [2]: [p_partkey#199L, p_mfgr#201]
Arguments: hashpartitioning(p_partkey#199L, 200), ENSURE_REQUIREMENTS, [plan_id=2628]

(5) Sort
Input [2]: [p_partkey#199L, p_mfgr#201]
Arguments: [p_partkey#199L ASC NULLS FIRST], false, 0

(6) Scan parquet spark_catalog.tpch_sf100.nation
Output [2]: [n_nationkey#274L, n_regionkey#276L]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/nation]
PushedFilters: [IsNotNull(n_nationkey), IsNotNull(n_regionkey)]
ReadSchema: struct<n_nationkey:bigint,n_regionkey:bigint>

(7) Filter
Input [2]: [n_nationkey#274L, n_regionkey#276L]
Condition : (isnotnull(n_nationkey#274L) AND isnotnull(n_regionkey#276L))

(8) Scan parquet spark_catalog.tpch_sf100.region
Output [2]: [r_regionkey#278L, r_name#279]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/region]
PushedFilters: [IsNotNull(r_name), EqualTo(r_name,AMERICA), IsNotNull(r_regionkey)]
ReadSchema: struct<r_regionkey:bigint,r_name:string>

(9) Filter
Input [2]: [r_regionkey#278L, r_name#279]
Condition : ((isnotnull(r_name#279) AND (r_name#279 = AMERICA)) AND isnotnull(r_regionkey#278L))

(10) Project
Output [1]: [r_regionkey#278L]
Input [2]: [r_regionkey#278L, r_name#279]

(11) BroadcastExchange
Input [1]: [r_regionkey#278L]
Arguments: HashedRelationBroadcastMode(List(input[0, bigint, true]),false), [plan_id=2606]

(12) BroadcastHashJoin
Left keys [1]: [n_regionkey#276L]
Right keys [1]: [r_regionkey#278L]
Join type: Inner
Join condition: None

(13) Project
Output [1]: [n_nationkey#274L]
Input [3]: [n_nationkey#274L, n_regionkey#276L, r_regionkey#278L]

(14) BroadcastExchange
Input [1]: [n_nationkey#274L]
Arguments: HashedRelationBroadcastMode(List(input[0, bigint, true]),false), [plan_id=2610]

(15) Scan parquet spark_catalog.tpch_sf100.supplier
Output [2]: [s_suppkey#267L, s_nationkey#270L]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/supplier]
PushedFilters: [IsNotNull(s_suppkey), IsNotNull(s_nationkey)]
ReadSchema: struct<s_suppkey:bigint,s_nationkey:bigint>

(16) Filter
Input [2]: [s_suppkey#267L, s_nationkey#270L]
Condition : (isnotnull(s_suppkey#267L) AND isnotnull(s_nationkey#270L))

(17) BroadcastHashJoin
Left keys [1]: [n_nationkey#274L]
Right keys [1]: [s_nationkey#270L]
Join type: Inner
Join condition: None

(18) Project
Output [1]: [s_suppkey#267L]
Input [3]: [n_nationkey#274L, s_suppkey#267L, s_nationkey#270L]

(19) Exchange
Input [1]: [s_suppkey#267L]
Arguments: hashpartitioning(s_suppkey#267L, 200), ENSURE_REQUIREMENTS, [plan_id=2615]

(20) Sort
Input [1]: [s_suppkey#267L]
Arguments: [s_suppkey#267L ASC NULLS FIRST], false, 0

(21) Scan parquet spark_catalog.tpch_sf100.partsupp
Output [3]: [ps_partkey#262L, ps_suppkey#263L, ps_supplycost#265]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/partsupp]
PushedFilters: [IsNotNull(ps_suppkey), IsNotNull(ps_partkey)]
ReadSchema: struct<ps_partkey:bigint,ps_suppkey:bigint,ps_supplycost:decimal(10,0)>

(22) Filter
Input [3]: [ps_partkey#262L, ps_suppkey#263L, ps_supplycost#265]
Condition : (isnotnull(ps_suppkey#263L) AND isnotnull(ps_partkey#262L))

(23) Exchange
Input [3]: [ps_partkey#262L, ps_suppkey#263L, ps_supplycost#265]
Arguments: hashpartitioning(ps_suppkey#263L, 200), ENSURE_REQUIREMENTS, [plan_id=2616]

(24) Sort
Input [3]: [ps_partkey#262L, ps_suppkey#263L, ps_supplycost#265]
Arguments: [ps_suppkey#263L ASC NULLS FIRST], false, 0

(25) SortMergeJoin
Left keys [1]: [s_suppkey#267L]
Right keys [1]: [ps_suppkey#263L]
Join type: Inner
Join condition: None

(26) Project
Output [2]: [ps_partkey#262L, ps_supplycost#265]
Input [4]: [s_suppkey#267L, ps_partkey#262L, ps_suppkey#263L, ps_supplycost#265]

(27) HashAggregate
Input [2]: [ps_partkey#262L, ps_supplycost#265]
Keys [1]: [ps_partkey#262L]
Functions [1]: [partial_min(ps_supplycost#265)]
Aggregate Attributes [1]: [min#281]
Results [2]: [ps_partkey#262L, min#282]

(28) Exchange
Input [2]: [ps_partkey#262L, min#282]
Arguments: hashpartitioning(ps_partkey#262L, 200), ENSURE_REQUIREMENTS, [plan_id=2623]

(29) HashAggregate
Input [2]: [ps_partkey#262L, min#282]
Keys [1]: [ps_partkey#262L]
Functions [1]: [min(ps_supplycost#265)]
Aggregate Attributes [1]: [min(ps_supplycost#265)#260]
Results [2]: [min(ps_supplycost#265)#260 AS min(ps_supplycost)#261, ps_partkey#262L]

(30) Filter
Input [2]: [min(ps_supplycost)#261, ps_partkey#262L]
Condition : isnotnull(min(ps_supplycost)#261)

(31) Sort
Input [2]: [min(ps_supplycost)#261, ps_partkey#262L]
Arguments: [ps_partkey#262L ASC NULLS FIRST], false, 0

(32) SortMergeJoin
Left keys [1]: [p_partkey#199L]
Right keys [1]: [ps_partkey#262L]
Join type: Inner
Join condition: None

(33) Project
Output [3]: [p_partkey#199L, p_mfgr#201, min(ps_supplycost)#261]
Input [4]: [p_partkey#199L, p_mfgr#201, min(ps_supplycost)#261, ps_partkey#262L]

(34) Exchange
Input [3]: [p_partkey#199L, p_mfgr#201, min(ps_supplycost)#261]
Arguments: hashpartitioning(p_partkey#199L, min(ps_supplycost)#261, 200), ENSURE_REQUIREMENTS, [plan_id=2636]

(35) Sort
Input [3]: [p_partkey#199L, p_mfgr#201, min(ps_supplycost)#261]
Arguments: [p_partkey#199L ASC NULLS FIRST, min(ps_supplycost)#261 ASC NULLS FIRST], false, 0

(36) Scan parquet spark_catalog.tpch_sf100.partsupp
Output [3]: [ps_partkey#215L, ps_suppkey#216L, ps_supplycost#218]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/partsupp]
PushedFilters: [IsNotNull(ps_partkey), IsNotNull(ps_supplycost), IsNotNull(ps_suppkey)]
ReadSchema: struct<ps_partkey:bigint,ps_suppkey:bigint,ps_supplycost:decimal(10,0)>

(37) Filter
Input [3]: [ps_partkey#215L, ps_suppkey#216L, ps_supplycost#218]
Condition : ((isnotnull(ps_partkey#215L) AND isnotnull(ps_supplycost#218)) AND isnotnull(ps_suppkey#216L))

(38) Exchange
Input [3]: [ps_partkey#215L, ps_suppkey#216L, ps_supplycost#218]
Arguments: hashpartitioning(ps_partkey#215L, ps_supplycost#218, 200), ENSURE_REQUIREMENTS, [plan_id=2635]

(39) Sort
Input [3]: [ps_partkey#215L, ps_suppkey#216L, ps_supplycost#218]
Arguments: [ps_partkey#215L ASC NULLS FIRST, ps_supplycost#218 ASC NULLS FIRST], false, 0

(40) SortMergeJoin
Left keys [2]: [p_partkey#199L, min(ps_supplycost)#261]
Right keys [2]: [ps_partkey#215L, ps_supplycost#218]
Join type: Inner
Join condition: None

(41) Project
Output [3]: [p_partkey#199L, p_mfgr#201, ps_suppkey#216L]
Input [6]: [p_partkey#199L, p_mfgr#201, min(ps_supplycost)#261, ps_partkey#215L, ps_suppkey#216L, ps_supplycost#218]

(42) Exchange
Input [3]: [p_partkey#199L, p_mfgr#201, ps_suppkey#216L]
Arguments: hashpartitioning(ps_suppkey#216L, 200), ENSURE_REQUIREMENTS, [plan_id=2650]

(43) Sort
Input [3]: [p_partkey#199L, p_mfgr#201, ps_suppkey#216L]
Arguments: [ps_suppkey#216L ASC NULLS FIRST], false, 0

(44) Scan parquet spark_catalog.tpch_sf100.nation
Output [3]: [n_nationkey#41L, n_name#42, n_regionkey#43L]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/nation]
PushedFilters: [IsNotNull(n_nationkey), IsNotNull(n_regionkey)]
ReadSchema: struct<n_nationkey:bigint,n_name:string,n_regionkey:bigint>

(45) Filter
Input [3]: [n_nationkey#41L, n_name#42, n_regionkey#43L]
Condition : (isnotnull(n_nationkey#41L) AND isnotnull(n_regionkey#43L))

(46) Scan parquet spark_catalog.tpch_sf100.region
Output [2]: [r_regionkey#220L, r_name#221]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/region]
PushedFilters: [IsNotNull(r_name), EqualTo(r_name,AMERICA), IsNotNull(r_regionkey)]
ReadSchema: struct<r_regionkey:bigint,r_name:string>

(47) Filter
Input [2]: [r_regionkey#220L, r_name#221]
Condition : ((isnotnull(r_name#221) AND (r_name#221 = AMERICA)) AND isnotnull(r_regionkey#220L))

(48) Project
Output [1]: [r_regionkey#220L]
Input [2]: [r_regionkey#220L, r_name#221]

(49) BroadcastExchange
Input [1]: [r_regionkey#220L]
Arguments: HashedRelationBroadcastMode(List(input[0, bigint, true]),false), [plan_id=2641]

(50) BroadcastHashJoin
Left keys [1]: [n_regionkey#43L]
Right keys [1]: [r_regionkey#220L]
Join type: Inner
Join condition: None

(51) Project
Output [2]: [n_nationkey#41L, n_name#42]
Input [4]: [n_nationkey#41L, n_name#42, n_regionkey#43L, r_regionkey#220L]

(52) BroadcastExchange
Input [2]: [n_nationkey#41L, n_name#42]
Arguments: HashedRelationBroadcastMode(List(input[0, bigint, true]),false), [plan_id=2645]

(53) Scan parquet spark_catalog.tpch_sf100.supplier
Output [7]: [s_suppkey#208L, s_name#209, s_address#210, s_nationkey#211L, s_phone#212, s_acctbal#213, s_comment#214]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/supplier]
PushedFilters: [IsNotNull(s_suppkey), IsNotNull(s_nationkey)]
ReadSchema: struct<s_suppkey:bigint,s_name:string,s_address:string,s_nationkey:bigint,s_phone:string,s_acctbal:decimal(10,0),s_comment:string>

(54) Filter
Input [7]: [s_suppkey#208L, s_name#209, s_address#210, s_nationkey#211L, s_phone#212, s_acctbal#213, s_comment#214]
Condition : (isnotnull(s_suppkey#208L) AND isnotnull(s_nationkey#211L))

(55) BroadcastHashJoin
Left keys [1]: [n_nationkey#41L]
Right keys [1]: [s_nationkey#211L]
Join type: Inner
Join condition: None

(56) Project
Output [7]: [n_name#42, s_suppkey#208L, s_name#209, s_address#210, s_phone#212, s_acctbal#213, s_comment#214]
Input [9]: [n_nationkey#41L, n_name#42, s_suppkey#208L, s_name#209, s_address#210, s_nationkey#211L, s_phone#212, s_acctbal#213, s_comment#214]

(57) Exchange
Input [7]: [n_name#42, s_suppkey#208L, s_name#209, s_address#210, s_phone#212, s_acctbal#213, s_comment#214]
Arguments: hashpartitioning(s_suppkey#208L, 200), ENSURE_REQUIREMENTS, [plan_id=2651]

(58) Sort
Input [7]: [n_name#42, s_suppkey#208L, s_name#209, s_address#210, s_phone#212, s_acctbal#213, s_comment#214]
Arguments: [s_suppkey#208L ASC NULLS FIRST], false, 0

(59) SortMergeJoin
Left keys [1]: [ps_suppkey#216L]
Right keys [1]: [s_suppkey#208L]
Join type: Inner
Join condition: None

(60) Project
Output [8]: [s_acctbal#213, s_name#209, n_name#42, p_partkey#199L, p_mfgr#201, s_address#210, s_phone#212, s_comment#214]
Input [10]: [p_partkey#199L, p_mfgr#201, ps_suppkey#216L, n_name#42, s_suppkey#208L, s_name#209, s_address#210, s_phone#212, s_acctbal#213, s_comment#214]

(61) TakeOrderedAndProject
Input [8]: [s_acctbal#213, s_name#209, n_name#42, p_partkey#199L, p_mfgr#201, s_address#210, s_phone#212, s_comment#214]
Arguments: 100, [s_acctbal#213 DESC NULLS LAST, n_name#42 ASC NULLS FIRST, s_name#209 ASC NULLS FIRST, p_partkey#199L ASC NULLS FIRST], [s_acctbal#213, s_name#209, n_name#42, p_partkey#199L, p_mfgr#201, s_address#210, s_phone#212, s_comment#214]

(62) AdaptiveSparkPlan
Output [8]: [s_acctbal#213, s_name#209, n_name#42, p_partkey#199L, p_mfgr#201, s_address#210, s_phone#212, s_comment#214]
Arguments: isFinalPlan=false
Execution Time: 22.695
