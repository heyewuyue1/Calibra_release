== Physical Plan ==
AdaptiveSparkPlan (54)
+- Sort (53)
   +- Exchange (52)
      +- HashAggregate (51)
         +- Exchange (50)
            +- HashAggregate (49)
               +- Project (48)
                  +- SortMergeJoin Inner (47)
                     :- Sort (37)
                     :  +- Exchange (36)
                     :     +- Project (35)
                     :        +- SortMergeJoin Inner (34)
                     :           :- Sort (23)
                     :           :  +- Exchange (22)
                     :           :     +- Project (21)
                     :           :        +- SortMergeJoin Inner (20)
                     :           :           :- Sort (15)
                     :           :           :  +- Exchange (14)
                     :           :           :     +- Project (13)
                     :           :           :        +- BroadcastHashJoin Inner BuildLeft (12)
                     :           :           :           :- BroadcastExchange (9)
                     :           :           :           :  +- Project (8)
                     :           :           :           :     +- BroadcastHashJoin Inner BuildRight (7)
                     :           :           :           :        :- Filter (2)
                     :           :           :           :        :  +- Scan parquet spark_catalog.tpch_sf100.nation (1)
                     :           :           :           :        +- BroadcastExchange (6)
                     :           :           :           :           +- Project (5)
                     :           :           :           :              +- Filter (4)
                     :           :           :           :                 +- Scan parquet spark_catalog.tpch_sf100.region (3)
                     :           :           :           +- Filter (11)
                     :           :           :              +- Scan parquet spark_catalog.tpch_sf100.customer (10)
                     :           :           +- Sort (19)
                     :           :              +- Exchange (18)
                     :           :                 +- Filter (17)
                     :           :                    +- Scan parquet spark_catalog.tpch_sf100.orders (16)
                     :           +- Sort (33)
                     :              +- Exchange (32)
                     :                 +- Project (31)
                     :                    +- BroadcastHashJoin Inner BuildLeft (30)
                     :                       :- BroadcastExchange (27)
                     :                       :  +- Project (26)
                     :                       :     +- Filter (25)
                     :                       :        +- Scan parquet spark_catalog.tpch_sf100.part (24)
                     :                       +- Filter (29)
                     :                          +- Scan parquet spark_catalog.tpch_sf100.lineitem (28)
                     +- Sort (46)
                        +- Exchange (45)
                           +- Project (44)
                              +- BroadcastHashJoin Inner BuildRight (43)
                                 :- Filter (39)
                                 :  +- Scan parquet spark_catalog.tpch_sf100.supplier (38)
                                 +- BroadcastExchange (42)
                                    +- Filter (41)
                                       +- Scan parquet spark_catalog.tpch_sf100.nation (40)


(1) Scan parquet spark_catalog.tpch_sf100.nation
Output [2]: [n_nationkey#41L, n_regionkey#43L]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/nation]
PushedFilters: [IsNotNull(n_nationkey), IsNotNull(n_regionkey)]
ReadSchema: struct<n_nationkey:bigint,n_regionkey:bigint>

(2) Filter
Input [2]: [n_nationkey#41L, n_regionkey#43L]
Condition : (isnotnull(n_nationkey#41L) AND isnotnull(n_regionkey#43L))

(3) Scan parquet spark_catalog.tpch_sf100.region
Output [2]: [r_regionkey#220L, r_name#221]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/region]
PushedFilters: [IsNotNull(r_name), EqualTo(r_name,AMERICA), IsNotNull(r_regionkey)]
ReadSchema: struct<r_regionkey:bigint,r_name:string>

(4) Filter
Input [2]: [r_regionkey#220L, r_name#221]
Condition : ((isnotnull(r_name#221) AND (r_name#221 = AMERICA)) AND isnotnull(r_regionkey#220L))

(5) Project
Output [1]: [r_regionkey#220L]
Input [2]: [r_regionkey#220L, r_name#221]

(6) BroadcastExchange
Input [1]: [r_regionkey#220L]
Arguments: HashedRelationBroadcastMode(List(input[0, bigint, true]),false), [plan_id=14281]

(7) BroadcastHashJoin
Left keys [1]: [n_regionkey#43L]
Right keys [1]: [r_regionkey#220L]
Join type: Inner
Join condition: None

(8) Project
Output [1]: [n_nationkey#41L]
Input [3]: [n_nationkey#41L, n_regionkey#43L, r_regionkey#220L]

(9) BroadcastExchange
Input [1]: [n_nationkey#41L]
Arguments: HashedRelationBroadcastMode(List(input[0, bigint, true]),false), [plan_id=14285]

(10) Scan parquet spark_catalog.tpch_sf100.customer
Output [2]: [c_custkey#8L, c_nationkey#11L]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/customer]
PushedFilters: [IsNotNull(c_custkey), IsNotNull(c_nationkey)]
ReadSchema: struct<c_custkey:bigint,c_nationkey:bigint>

(11) Filter
Input [2]: [c_custkey#8L, c_nationkey#11L]
Condition : (isnotnull(c_custkey#8L) AND isnotnull(c_nationkey#11L))

(12) BroadcastHashJoin
Left keys [1]: [n_nationkey#41L]
Right keys [1]: [c_nationkey#11L]
Join type: Inner
Join condition: None

(13) Project
Output [1]: [c_custkey#8L]
Input [3]: [n_nationkey#41L, c_custkey#8L, c_nationkey#11L]

(14) Exchange
Input [1]: [c_custkey#8L]
Arguments: hashpartitioning(c_custkey#8L, 200), ENSURE_REQUIREMENTS, [plan_id=14290]

(15) Sort
Input [1]: [c_custkey#8L]
Arguments: [c_custkey#8L ASC NULLS FIRST], false, 0

(16) Scan parquet spark_catalog.tpch_sf100.orders
Output [3]: [o_orderkey#16L, o_custkey#17L, o_orderdate#20]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/orders]
PushedFilters: [IsNotNull(o_orderdate), GreaterThanOrEqual(o_orderdate,1995-01-01), LessThanOrEqual(o_orderdate,1996-12-31), IsNotNull(o_orderkey), IsNotNull(o_custkey)]
ReadSchema: struct<o_orderkey:bigint,o_custkey:bigint,o_orderdate:date>

(17) Filter
Input [3]: [o_orderkey#16L, o_custkey#17L, o_orderdate#20]
Condition : ((((isnotnull(o_orderdate#20) AND (o_orderdate#20 >= 1995-01-01)) AND (o_orderdate#20 <= 1996-12-31)) AND isnotnull(o_orderkey#16L)) AND isnotnull(o_custkey#17L))

(18) Exchange
Input [3]: [o_orderkey#16L, o_custkey#17L, o_orderdate#20]
Arguments: hashpartitioning(o_custkey#17L, 200), ENSURE_REQUIREMENTS, [plan_id=14291]

(19) Sort
Input [3]: [o_orderkey#16L, o_custkey#17L, o_orderdate#20]
Arguments: [o_custkey#17L ASC NULLS FIRST], false, 0

(20) SortMergeJoin
Left keys [1]: [c_custkey#8L]
Right keys [1]: [o_custkey#17L]
Join type: Inner
Join condition: None

(21) Project
Output [2]: [o_orderkey#16L, o_orderdate#20]
Input [4]: [c_custkey#8L, o_orderkey#16L, o_custkey#17L, o_orderdate#20]

(22) Exchange
Input [2]: [o_orderkey#16L, o_orderdate#20]
Arguments: hashpartitioning(o_orderkey#16L, 200), ENSURE_REQUIREMENTS, [plan_id=14301]

(23) Sort
Input [2]: [o_orderkey#16L, o_orderdate#20]
Arguments: [o_orderkey#16L ASC NULLS FIRST], false, 0

(24) Scan parquet spark_catalog.tpch_sf100.part
Output [2]: [p_partkey#199L, p_type#203]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/part]
PushedFilters: [IsNotNull(p_type), EqualTo(p_type,ECONOMY PLATED TIN), IsNotNull(p_partkey)]
ReadSchema: struct<p_partkey:bigint,p_type:string>

(25) Filter
Input [2]: [p_partkey#199L, p_type#203]
Condition : ((isnotnull(p_type#203) AND (p_type#203 = ECONOMY PLATED TIN)) AND isnotnull(p_partkey#199L))

(26) Project
Output [1]: [p_partkey#199L]
Input [2]: [p_partkey#199L, p_type#203]

(27) BroadcastExchange
Input [1]: [p_partkey#199L]
Arguments: HashedRelationBroadcastMode(List(input[0, bigint, true]),false), [plan_id=14296]

(28) Scan parquet spark_catalog.tpch_sf100.lineitem
Output [5]: [l_orderkey#25L, l_partkey#26L, l_suppkey#27L, l_extendedprice#30, l_discount#31]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/lineitem]
PushedFilters: [IsNotNull(l_partkey), IsNotNull(l_suppkey), IsNotNull(l_orderkey)]
ReadSchema: struct<l_orderkey:bigint,l_partkey:bigint,l_suppkey:bigint,l_extendedprice:decimal(10,0),l_discount:decimal(10,0)>

(29) Filter
Input [5]: [l_orderkey#25L, l_partkey#26L, l_suppkey#27L, l_extendedprice#30, l_discount#31]
Condition : ((isnotnull(l_partkey#26L) AND isnotnull(l_suppkey#27L)) AND isnotnull(l_orderkey#25L))

(30) BroadcastHashJoin
Left keys [1]: [p_partkey#199L]
Right keys [1]: [l_partkey#26L]
Join type: Inner
Join condition: None

(31) Project
Output [4]: [l_orderkey#25L, l_suppkey#27L, l_extendedprice#30, l_discount#31]
Input [6]: [p_partkey#199L, l_orderkey#25L, l_partkey#26L, l_suppkey#27L, l_extendedprice#30, l_discount#31]

(32) Exchange
Input [4]: [l_orderkey#25L, l_suppkey#27L, l_extendedprice#30, l_discount#31]
Arguments: hashpartitioning(l_orderkey#25L, 200), ENSURE_REQUIREMENTS, [plan_id=14302]

(33) Sort
Input [4]: [l_orderkey#25L, l_suppkey#27L, l_extendedprice#30, l_discount#31]
Arguments: [l_orderkey#25L ASC NULLS FIRST], false, 0

(34) SortMergeJoin
Left keys [1]: [o_orderkey#16L]
Right keys [1]: [l_orderkey#25L]
Join type: Inner
Join condition: None

(35) Project
Output [4]: [o_orderdate#20, l_suppkey#27L, l_extendedprice#30, l_discount#31]
Input [6]: [o_orderkey#16L, o_orderdate#20, l_orderkey#25L, l_suppkey#27L, l_extendedprice#30, l_discount#31]

(36) Exchange
Input [4]: [o_orderdate#20, l_suppkey#27L, l_extendedprice#30, l_discount#31]
Arguments: hashpartitioning(l_suppkey#27L, 200), ENSURE_REQUIREMENTS, [plan_id=14312]

(37) Sort
Input [4]: [o_orderdate#20, l_suppkey#27L, l_extendedprice#30, l_discount#31]
Arguments: [l_suppkey#27L ASC NULLS FIRST], false, 0

(38) Scan parquet spark_catalog.tpch_sf100.supplier
Output [2]: [s_suppkey#208L, s_nationkey#211L]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/supplier]
PushedFilters: [IsNotNull(s_suppkey), IsNotNull(s_nationkey)]
ReadSchema: struct<s_suppkey:bigint,s_nationkey:bigint>

(39) Filter
Input [2]: [s_suppkey#208L, s_nationkey#211L]
Condition : (isnotnull(s_suppkey#208L) AND isnotnull(s_nationkey#211L))

(40) Scan parquet spark_catalog.tpch_sf100.nation
Output [2]: [n_nationkey#1212L, n_name#1213]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/nation]
PushedFilters: [IsNotNull(n_nationkey)]
ReadSchema: struct<n_nationkey:bigint,n_name:string>

(41) Filter
Input [2]: [n_nationkey#1212L, n_name#1213]
Condition : isnotnull(n_nationkey#1212L)

(42) BroadcastExchange
Input [2]: [n_nationkey#1212L, n_name#1213]
Arguments: HashedRelationBroadcastMode(List(input[0, bigint, false]),false), [plan_id=14307]

(43) BroadcastHashJoin
Left keys [1]: [s_nationkey#211L]
Right keys [1]: [n_nationkey#1212L]
Join type: Inner
Join condition: None

(44) Project
Output [2]: [s_suppkey#208L, n_name#1213]
Input [4]: [s_suppkey#208L, s_nationkey#211L, n_nationkey#1212L, n_name#1213]

(45) Exchange
Input [2]: [s_suppkey#208L, n_name#1213]
Arguments: hashpartitioning(s_suppkey#208L, 200), ENSURE_REQUIREMENTS, [plan_id=14313]

(46) Sort
Input [2]: [s_suppkey#208L, n_name#1213]
Arguments: [s_suppkey#208L ASC NULLS FIRST], false, 0

(47) SortMergeJoin
Left keys [1]: [l_suppkey#27L]
Right keys [1]: [s_suppkey#208L]
Join type: Inner
Join condition: None

(48) Project
Output [3]: [year(o_orderdate#20) AS o_year#1203, (l_extendedprice#30 * (1 - l_discount#31)) AS volume#1204, n_name#1213 AS nation#1205]
Input [6]: [o_orderdate#20, l_suppkey#27L, l_extendedprice#30, l_discount#31, s_suppkey#208L, n_name#1213]

(49) HashAggregate
Input [3]: [o_year#1203, volume#1204, nation#1205]
Keys [1]: [o_year#1203]
Functions [2]: [partial_sum(CASE WHEN (nation#1205 = PERU) THEN volume#1204 ELSE 0 END), partial_sum(volume#1204)]
Aggregate Attributes [4]: [sum#1219, isEmpty#1220, sum#1221, isEmpty#1222]
Results [5]: [o_year#1203, sum#1223, isEmpty#1224, sum#1225, isEmpty#1226]

(50) Exchange
Input [5]: [o_year#1203, sum#1223, isEmpty#1224, sum#1225, isEmpty#1226]
Arguments: hashpartitioning(o_year#1203, 200), ENSURE_REQUIREMENTS, [plan_id=14320]

(51) HashAggregate
Input [5]: [o_year#1203, sum#1223, isEmpty#1224, sum#1225, isEmpty#1226]
Keys [1]: [o_year#1203]
Functions [2]: [sum(CASE WHEN (nation#1205 = PERU) THEN volume#1204 ELSE 0 END), sum(volume#1204)]
Aggregate Attributes [2]: [sum(CASE WHEN (nation#1205 = PERU) THEN volume#1204 ELSE 0 END)#1218, sum(volume#1204)#1217]
Results [2]: [o_year#1203, (sum(CASE WHEN (nation#1205 = PERU) THEN volume#1204 ELSE 0 END)#1218 / sum(volume#1204)#1217) AS mkt_share#1206]

(52) Exchange
Input [2]: [o_year#1203, mkt_share#1206]
Arguments: rangepartitioning(o_year#1203 ASC NULLS FIRST, 200), ENSURE_REQUIREMENTS, [plan_id=14323]

(53) Sort
Input [2]: [o_year#1203, mkt_share#1206]
Arguments: [o_year#1203 ASC NULLS FIRST], true, 0

(54) AdaptiveSparkPlan
Output [2]: [o_year#1203, mkt_share#1206]
Arguments: isFinalPlan=false
Execution Time: 25.592
