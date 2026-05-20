== Physical Plan ==
AdaptiveSparkPlan (44)
+- Sort (43)
   +- Exchange (42)
      +- HashAggregate (41)
         +- Exchange (40)
            +- HashAggregate (39)
               +- Project (38)
                  +- SortMergeJoin Inner (37)
                     :- Sort (21)
                     :  +- Exchange (20)
                     :     +- Project (19)
                     :        +- SortMergeJoin Inner (18)
                     :           :- Sort (13)
                     :           :  +- Exchange (12)
                     :           :     +- Project (11)
                     :           :        +- SortMergeJoin Inner (10)
                     :           :           :- Sort (4)
                     :           :           :  +- Exchange (3)
                     :           :           :     +- Filter (2)
                     :           :           :        +- Scan parquet spark_catalog.tpch_sf100.customer (1)
                     :           :           +- Sort (9)
                     :           :              +- Exchange (8)
                     :           :                 +- Project (7)
                     :           :                    +- Filter (6)
                     :           :                       +- Scan parquet spark_catalog.tpch_sf100.orders (5)
                     :           +- Sort (17)
                     :              +- Exchange (16)
                     :                 +- Filter (15)
                     :                    +- Scan parquet spark_catalog.tpch_sf100.lineitem (14)
                     +- Sort (36)
                        +- Exchange (35)
                           +- Project (34)
                              +- BroadcastHashJoin Inner BuildLeft (33)
                                 :- BroadcastExchange (30)
                                 :  +- Project (29)
                                 :     +- BroadcastHashJoin Inner BuildRight (28)
                                 :        :- Filter (23)
                                 :        :  +- Scan parquet spark_catalog.tpch_sf100.nation (22)
                                 :        +- BroadcastExchange (27)
                                 :           +- Project (26)
                                 :              +- Filter (25)
                                 :                 +- Scan parquet spark_catalog.tpch_sf100.region (24)
                                 +- Filter (32)
                                    +- Scan parquet spark_catalog.tpch_sf100.supplier (31)


(1) Scan parquet spark_catalog.tpch_sf100.customer
Output [2]: [c_custkey#8L, c_nationkey#11L]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/customer]
PushedFilters: [IsNotNull(c_custkey), IsNotNull(c_nationkey)]
ReadSchema: struct<c_custkey:bigint,c_nationkey:bigint>

(2) Filter
Input [2]: [c_custkey#8L, c_nationkey#11L]
Condition : (isnotnull(c_custkey#8L) AND isnotnull(c_nationkey#11L))

(3) Exchange
Input [2]: [c_custkey#8L, c_nationkey#11L]
Arguments: hashpartitioning(c_custkey#8L, 200), ENSURE_REQUIREMENTS, [plan_id=7422]

(4) Sort
Input [2]: [c_custkey#8L, c_nationkey#11L]
Arguments: [c_custkey#8L ASC NULLS FIRST], false, 0

(5) Scan parquet spark_catalog.tpch_sf100.orders
Output [3]: [o_orderkey#16L, o_custkey#17L, o_orderdate#20]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/orders]
PushedFilters: [IsNotNull(o_orderdate), GreaterThanOrEqual(o_orderdate,1993-01-01), LessThan(o_orderdate,1994-01-01), IsNotNull(o_custkey), IsNotNull(o_orderkey)]
ReadSchema: struct<o_orderkey:bigint,o_custkey:bigint,o_orderdate:date>

(6) Filter
Input [3]: [o_orderkey#16L, o_custkey#17L, o_orderdate#20]
Condition : ((((isnotnull(o_orderdate#20) AND (o_orderdate#20 >= 1993-01-01)) AND (o_orderdate#20 < 1994-01-01)) AND isnotnull(o_custkey#17L)) AND isnotnull(o_orderkey#16L))

(7) Project
Output [2]: [o_orderkey#16L, o_custkey#17L]
Input [3]: [o_orderkey#16L, o_custkey#17L, o_orderdate#20]

(8) Exchange
Input [2]: [o_orderkey#16L, o_custkey#17L]
Arguments: hashpartitioning(o_custkey#17L, 200), ENSURE_REQUIREMENTS, [plan_id=7423]

(9) Sort
Input [2]: [o_orderkey#16L, o_custkey#17L]
Arguments: [o_custkey#17L ASC NULLS FIRST], false, 0

(10) SortMergeJoin
Left keys [1]: [c_custkey#8L]
Right keys [1]: [o_custkey#17L]
Join type: Inner
Join condition: None

(11) Project
Output [2]: [c_nationkey#11L, o_orderkey#16L]
Input [4]: [c_custkey#8L, c_nationkey#11L, o_orderkey#16L, o_custkey#17L]

(12) Exchange
Input [2]: [c_nationkey#11L, o_orderkey#16L]
Arguments: hashpartitioning(o_orderkey#16L, 200), ENSURE_REQUIREMENTS, [plan_id=7430]

(13) Sort
Input [2]: [c_nationkey#11L, o_orderkey#16L]
Arguments: [o_orderkey#16L ASC NULLS FIRST], false, 0

(14) Scan parquet spark_catalog.tpch_sf100.lineitem
Output [4]: [l_orderkey#25L, l_suppkey#27L, l_extendedprice#30, l_discount#31]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/lineitem]
PushedFilters: [IsNotNull(l_orderkey), IsNotNull(l_suppkey)]
ReadSchema: struct<l_orderkey:bigint,l_suppkey:bigint,l_extendedprice:decimal(10,0),l_discount:decimal(10,0)>

(15) Filter
Input [4]: [l_orderkey#25L, l_suppkey#27L, l_extendedprice#30, l_discount#31]
Condition : (isnotnull(l_orderkey#25L) AND isnotnull(l_suppkey#27L))

(16) Exchange
Input [4]: [l_orderkey#25L, l_suppkey#27L, l_extendedprice#30, l_discount#31]
Arguments: hashpartitioning(l_orderkey#25L, 200), ENSURE_REQUIREMENTS, [plan_id=7431]

(17) Sort
Input [4]: [l_orderkey#25L, l_suppkey#27L, l_extendedprice#30, l_discount#31]
Arguments: [l_orderkey#25L ASC NULLS FIRST], false, 0

(18) SortMergeJoin
Left keys [1]: [o_orderkey#16L]
Right keys [1]: [l_orderkey#25L]
Join type: Inner
Join condition: None

(19) Project
Output [4]: [c_nationkey#11L, l_suppkey#27L, l_extendedprice#30, l_discount#31]
Input [6]: [c_nationkey#11L, o_orderkey#16L, l_orderkey#25L, l_suppkey#27L, l_extendedprice#30, l_discount#31]

(20) Exchange
Input [4]: [c_nationkey#11L, l_suppkey#27L, l_extendedprice#30, l_discount#31]
Arguments: hashpartitioning(l_suppkey#27L, c_nationkey#11L, 200), ENSURE_REQUIREMENTS, [plan_id=7445]

(21) Sort
Input [4]: [c_nationkey#11L, l_suppkey#27L, l_extendedprice#30, l_discount#31]
Arguments: [l_suppkey#27L ASC NULLS FIRST, c_nationkey#11L ASC NULLS FIRST], false, 0

(22) Scan parquet spark_catalog.tpch_sf100.nation
Output [3]: [n_nationkey#41L, n_name#42, n_regionkey#43L]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/nation]
PushedFilters: [IsNotNull(n_nationkey), IsNotNull(n_regionkey)]
ReadSchema: struct<n_nationkey:bigint,n_name:string,n_regionkey:bigint>

(23) Filter
Input [3]: [n_nationkey#41L, n_name#42, n_regionkey#43L]
Condition : (isnotnull(n_nationkey#41L) AND isnotnull(n_regionkey#43L))

(24) Scan parquet spark_catalog.tpch_sf100.region
Output [2]: [r_regionkey#220L, r_name#221]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/region]
PushedFilters: [IsNotNull(r_name), EqualTo(r_name,AMERICA), IsNotNull(r_regionkey)]
ReadSchema: struct<r_regionkey:bigint,r_name:string>

(25) Filter
Input [2]: [r_regionkey#220L, r_name#221]
Condition : ((isnotnull(r_name#221) AND (r_name#221 = AMERICA)) AND isnotnull(r_regionkey#220L))

(26) Project
Output [1]: [r_regionkey#220L]
Input [2]: [r_regionkey#220L, r_name#221]

(27) BroadcastExchange
Input [1]: [r_regionkey#220L]
Arguments: HashedRelationBroadcastMode(List(input[0, bigint, true]),false), [plan_id=7436]

(28) BroadcastHashJoin
Left keys [1]: [n_regionkey#43L]
Right keys [1]: [r_regionkey#220L]
Join type: Inner
Join condition: None

(29) Project
Output [2]: [n_nationkey#41L, n_name#42]
Input [4]: [n_nationkey#41L, n_name#42, n_regionkey#43L, r_regionkey#220L]

(30) BroadcastExchange
Input [2]: [n_nationkey#41L, n_name#42]
Arguments: HashedRelationBroadcastMode(List(input[0, bigint, true]),false), [plan_id=7440]

(31) Scan parquet spark_catalog.tpch_sf100.supplier
Output [2]: [s_suppkey#208L, s_nationkey#211L]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/supplier]
PushedFilters: [IsNotNull(s_suppkey), IsNotNull(s_nationkey)]
ReadSchema: struct<s_suppkey:bigint,s_nationkey:bigint>

(32) Filter
Input [2]: [s_suppkey#208L, s_nationkey#211L]
Condition : (isnotnull(s_suppkey#208L) AND isnotnull(s_nationkey#211L))

(33) BroadcastHashJoin
Left keys [1]: [n_nationkey#41L]
Right keys [1]: [s_nationkey#211L]
Join type: Inner
Join condition: None

(34) Project
Output [3]: [n_name#42, s_suppkey#208L, s_nationkey#211L]
Input [4]: [n_nationkey#41L, n_name#42, s_suppkey#208L, s_nationkey#211L]

(35) Exchange
Input [3]: [n_name#42, s_suppkey#208L, s_nationkey#211L]
Arguments: hashpartitioning(s_suppkey#208L, s_nationkey#211L, 200), ENSURE_REQUIREMENTS, [plan_id=7446]

(36) Sort
Input [3]: [n_name#42, s_suppkey#208L, s_nationkey#211L]
Arguments: [s_suppkey#208L ASC NULLS FIRST, s_nationkey#211L ASC NULLS FIRST], false, 0

(37) SortMergeJoin
Left keys [2]: [l_suppkey#27L, c_nationkey#11L]
Right keys [2]: [s_suppkey#208L, s_nationkey#211L]
Join type: Inner
Join condition: None

(38) Project
Output [3]: [l_extendedprice#30, l_discount#31, n_name#42]
Input [7]: [c_nationkey#11L, l_suppkey#27L, l_extendedprice#30, l_discount#31, n_name#42, s_suppkey#208L, s_nationkey#211L]

(39) HashAggregate
Input [3]: [l_extendedprice#30, l_discount#31, n_name#42]
Keys [1]: [n_name#42]
Functions [1]: [partial_sum((l_extendedprice#30 * (1 - l_discount#31)))]
Aggregate Attributes [2]: [sum#708, isEmpty#709]
Results [3]: [n_name#42, sum#710, isEmpty#711]

(40) Exchange
Input [3]: [n_name#42, sum#710, isEmpty#711]
Arguments: hashpartitioning(n_name#42, 200), ENSURE_REQUIREMENTS, [plan_id=7453]

(41) HashAggregate
Input [3]: [n_name#42, sum#710, isEmpty#711]
Keys [1]: [n_name#42]
Functions [1]: [sum((l_extendedprice#30 * (1 - l_discount#31)))]
Aggregate Attributes [1]: [sum((l_extendedprice#30 * (1 - l_discount#31)))#707]
Results [2]: [n_name#42, sum((l_extendedprice#30 * (1 - l_discount#31)))#707 AS revenue#701]

(42) Exchange
Input [2]: [n_name#42, revenue#701]
Arguments: rangepartitioning(revenue#701 DESC NULLS LAST, 200), ENSURE_REQUIREMENTS, [plan_id=7456]

(43) Sort
Input [2]: [n_name#42, revenue#701]
Arguments: [revenue#701 DESC NULLS LAST], true, 0

(44) AdaptiveSparkPlan
Output [2]: [n_name#42, revenue#701]
Arguments: isFinalPlan=false
Execution Time: 42.88
