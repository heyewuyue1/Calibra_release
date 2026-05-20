== Physical Plan ==
AdaptiveSparkPlan (46)
+- Sort (45)
   +- Exchange (44)
      +- HashAggregate (43)
         +- Exchange (42)
            +- HashAggregate (41)
               +- Project (40)
                  +- SortMergeJoin Inner (39)
                     :- Sort (34)
                     :  +- Exchange (33)
                     :     +- Project (32)
                     :        +- SortMergeJoin Inner (31)
                     :           :- Sort (21)
                     :           :  +- Exchange (20)
                     :           :     +- Project (19)
                     :           :        +- SortMergeJoin Inner (18)
                     :           :           :- Sort (12)
                     :           :           :  +- Exchange (11)
                     :           :           :     +- Project (10)
                     :           :           :        +- SortMergeJoin Inner (9)
                     :           :           :           :- Sort (4)
                     :           :           :           :  +- Exchange (3)
                     :           :           :           :     +- Filter (2)
                     :           :           :           :        +- Scan parquet spark_catalog.tpch_sf100.lineitem (1)
                     :           :           :           +- Sort (8)
                     :           :           :              +- Exchange (7)
                     :           :           :                 +- Filter (6)
                     :           :           :                    +- Scan parquet spark_catalog.tpch_sf100.orders (5)
                     :           :           +- Sort (17)
                     :           :              +- Exchange (16)
                     :           :                 +- Project (15)
                     :           :                    +- Filter (14)
                     :           :                       +- Scan parquet spark_catalog.tpch_sf100.part (13)
                     :           +- Sort (30)
                     :              +- Exchange (29)
                     :                 +- Project (28)
                     :                    +- BroadcastHashJoin Inner BuildRight (27)
                     :                       :- Filter (23)
                     :                       :  +- Scan parquet spark_catalog.tpch_sf100.supplier (22)
                     :                       +- BroadcastExchange (26)
                     :                          +- Filter (25)
                     :                             +- Scan parquet spark_catalog.tpch_sf100.nation (24)
                     +- Sort (38)
                        +- Exchange (37)
                           +- Filter (36)
                              +- Scan parquet spark_catalog.tpch_sf100.partsupp (35)


(1) Scan parquet spark_catalog.tpch_sf100.lineitem
Output [6]: [l_orderkey#25L, l_partkey#26L, l_suppkey#27L, l_quantity#29, l_extendedprice#30, l_discount#31]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/lineitem]
PushedFilters: [IsNotNull(l_partkey), IsNotNull(l_suppkey), IsNotNull(l_orderkey)]
ReadSchema: struct<l_orderkey:bigint,l_partkey:bigint,l_suppkey:bigint,l_quantity:decimal(10,0),l_extendedprice:decimal(10,0),l_discount:decimal(10,0)>

(2) Filter
Input [6]: [l_orderkey#25L, l_partkey#26L, l_suppkey#27L, l_quantity#29, l_extendedprice#30, l_discount#31]
Condition : ((isnotnull(l_partkey#26L) AND isnotnull(l_suppkey#27L)) AND isnotnull(l_orderkey#25L))

(3) Exchange
Input [6]: [l_orderkey#25L, l_partkey#26L, l_suppkey#27L, l_quantity#29, l_extendedprice#30, l_discount#31]
Arguments: hashpartitioning(l_orderkey#25L, 200), ENSURE_REQUIREMENTS, [plan_id=17697]

(4) Sort
Input [6]: [l_orderkey#25L, l_partkey#26L, l_suppkey#27L, l_quantity#29, l_extendedprice#30, l_discount#31]
Arguments: [l_orderkey#25L ASC NULLS FIRST], false, 0

(5) Scan parquet spark_catalog.tpch_sf100.orders
Output [2]: [o_orderkey#16L, o_orderdate#20]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/orders]
PushedFilters: [IsNotNull(o_orderkey)]
ReadSchema: struct<o_orderkey:bigint,o_orderdate:date>

(6) Filter
Input [2]: [o_orderkey#16L, o_orderdate#20]
Condition : isnotnull(o_orderkey#16L)

(7) Exchange
Input [2]: [o_orderkey#16L, o_orderdate#20]
Arguments: hashpartitioning(o_orderkey#16L, 200), ENSURE_REQUIREMENTS, [plan_id=17698]

(8) Sort
Input [2]: [o_orderkey#16L, o_orderdate#20]
Arguments: [o_orderkey#16L ASC NULLS FIRST], false, 0

(9) SortMergeJoin
Left keys [1]: [l_orderkey#25L]
Right keys [1]: [o_orderkey#16L]
Join type: Inner
Join condition: None

(10) Project
Output [6]: [l_partkey#26L, l_suppkey#27L, l_quantity#29, l_extendedprice#30, l_discount#31, o_orderdate#20]
Input [8]: [l_orderkey#25L, l_partkey#26L, l_suppkey#27L, l_quantity#29, l_extendedprice#30, l_discount#31, o_orderkey#16L, o_orderdate#20]

(11) Exchange
Input [6]: [l_partkey#26L, l_suppkey#27L, l_quantity#29, l_extendedprice#30, l_discount#31, o_orderdate#20]
Arguments: hashpartitioning(l_partkey#26L, 200), ENSURE_REQUIREMENTS, [plan_id=17705]

(12) Sort
Input [6]: [l_partkey#26L, l_suppkey#27L, l_quantity#29, l_extendedprice#30, l_discount#31, o_orderdate#20]
Arguments: [l_partkey#26L ASC NULLS FIRST], false, 0

(13) Scan parquet spark_catalog.tpch_sf100.part
Output [2]: [p_partkey#199L, p_name#200]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/part]
PushedFilters: [IsNotNull(p_name), StringContains(p_name,papaya), IsNotNull(p_partkey)]
ReadSchema: struct<p_partkey:bigint,p_name:string>

(14) Filter
Input [2]: [p_partkey#199L, p_name#200]
Condition : ((isnotnull(p_name#200) AND Contains(p_name#200, papaya)) AND isnotnull(p_partkey#199L))

(15) Project
Output [1]: [p_partkey#199L]
Input [2]: [p_partkey#199L, p_name#200]

(16) Exchange
Input [1]: [p_partkey#199L]
Arguments: hashpartitioning(p_partkey#199L, 200), ENSURE_REQUIREMENTS, [plan_id=17706]

(17) Sort
Input [1]: [p_partkey#199L]
Arguments: [p_partkey#199L ASC NULLS FIRST], false, 0

(18) SortMergeJoin
Left keys [1]: [l_partkey#26L]
Right keys [1]: [p_partkey#199L]
Join type: Inner
Join condition: None

(19) Project
Output [6]: [l_partkey#26L, l_suppkey#27L, l_quantity#29, l_extendedprice#30, l_discount#31, o_orderdate#20]
Input [7]: [l_partkey#26L, l_suppkey#27L, l_quantity#29, l_extendedprice#30, l_discount#31, o_orderdate#20, p_partkey#199L]

(20) Exchange
Input [6]: [l_partkey#26L, l_suppkey#27L, l_quantity#29, l_extendedprice#30, l_discount#31, o_orderdate#20]
Arguments: hashpartitioning(l_suppkey#27L, 200), ENSURE_REQUIREMENTS, [plan_id=17716]

(21) Sort
Input [6]: [l_partkey#26L, l_suppkey#27L, l_quantity#29, l_extendedprice#30, l_discount#31, o_orderdate#20]
Arguments: [l_suppkey#27L ASC NULLS FIRST], false, 0

(22) Scan parquet spark_catalog.tpch_sf100.supplier
Output [2]: [s_suppkey#208L, s_nationkey#211L]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/supplier]
PushedFilters: [IsNotNull(s_suppkey), IsNotNull(s_nationkey)]
ReadSchema: struct<s_suppkey:bigint,s_nationkey:bigint>

(23) Filter
Input [2]: [s_suppkey#208L, s_nationkey#211L]
Condition : (isnotnull(s_suppkey#208L) AND isnotnull(s_nationkey#211L))

(24) Scan parquet spark_catalog.tpch_sf100.nation
Output [2]: [n_nationkey#41L, n_name#42]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/nation]
PushedFilters: [IsNotNull(n_nationkey)]
ReadSchema: struct<n_nationkey:bigint,n_name:string>

(25) Filter
Input [2]: [n_nationkey#41L, n_name#42]
Condition : isnotnull(n_nationkey#41L)

(26) BroadcastExchange
Input [2]: [n_nationkey#41L, n_name#42]
Arguments: HashedRelationBroadcastMode(List(input[0, bigint, false]),false), [plan_id=17711]

(27) BroadcastHashJoin
Left keys [1]: [s_nationkey#211L]
Right keys [1]: [n_nationkey#41L]
Join type: Inner
Join condition: None

(28) Project
Output [2]: [s_suppkey#208L, n_name#42]
Input [4]: [s_suppkey#208L, s_nationkey#211L, n_nationkey#41L, n_name#42]

(29) Exchange
Input [2]: [s_suppkey#208L, n_name#42]
Arguments: hashpartitioning(s_suppkey#208L, 200), ENSURE_REQUIREMENTS, [plan_id=17717]

(30) Sort
Input [2]: [s_suppkey#208L, n_name#42]
Arguments: [s_suppkey#208L ASC NULLS FIRST], false, 0

(31) SortMergeJoin
Left keys [1]: [l_suppkey#27L]
Right keys [1]: [s_suppkey#208L]
Join type: Inner
Join condition: None

(32) Project
Output [7]: [l_partkey#26L, l_suppkey#27L, l_quantity#29, l_extendedprice#30, l_discount#31, o_orderdate#20, n_name#42]
Input [8]: [l_partkey#26L, l_suppkey#27L, l_quantity#29, l_extendedprice#30, l_discount#31, o_orderdate#20, s_suppkey#208L, n_name#42]

(33) Exchange
Input [7]: [l_partkey#26L, l_suppkey#27L, l_quantity#29, l_extendedprice#30, l_discount#31, o_orderdate#20, n_name#42]
Arguments: hashpartitioning(l_suppkey#27L, l_partkey#26L, 200), ENSURE_REQUIREMENTS, [plan_id=17725]

(34) Sort
Input [7]: [l_partkey#26L, l_suppkey#27L, l_quantity#29, l_extendedprice#30, l_discount#31, o_orderdate#20, n_name#42]
Arguments: [l_suppkey#27L ASC NULLS FIRST, l_partkey#26L ASC NULLS FIRST], false, 0

(35) Scan parquet spark_catalog.tpch_sf100.partsupp
Output [3]: [ps_partkey#215L, ps_suppkey#216L, ps_supplycost#218]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/partsupp]
PushedFilters: [IsNotNull(ps_suppkey), IsNotNull(ps_partkey)]
ReadSchema: struct<ps_partkey:bigint,ps_suppkey:bigint,ps_supplycost:decimal(10,0)>

(36) Filter
Input [3]: [ps_partkey#215L, ps_suppkey#216L, ps_supplycost#218]
Condition : (isnotnull(ps_suppkey#216L) AND isnotnull(ps_partkey#215L))

(37) Exchange
Input [3]: [ps_partkey#215L, ps_suppkey#216L, ps_supplycost#218]
Arguments: hashpartitioning(ps_suppkey#216L, ps_partkey#215L, 200), ENSURE_REQUIREMENTS, [plan_id=17724]

(38) Sort
Input [3]: [ps_partkey#215L, ps_suppkey#216L, ps_supplycost#218]
Arguments: [ps_suppkey#216L ASC NULLS FIRST, ps_partkey#215L ASC NULLS FIRST], false, 0

(39) SortMergeJoin
Left keys [2]: [l_suppkey#27L, l_partkey#26L]
Right keys [2]: [ps_suppkey#216L, ps_partkey#215L]
Join type: Inner
Join condition: None

(40) Project
Output [3]: [n_name#42 AS nation#1461, year(o_orderdate#20) AS o_year#1462, ((l_extendedprice#30 * (1 - l_discount#31)) - (ps_supplycost#218 * l_quantity#29)) AS amount#1463]
Input [10]: [l_partkey#26L, l_suppkey#27L, l_quantity#29, l_extendedprice#30, l_discount#31, o_orderdate#20, n_name#42, ps_partkey#215L, ps_suppkey#216L, ps_supplycost#218]

(41) HashAggregate
Input [3]: [nation#1461, o_year#1462, amount#1463]
Keys [2]: [nation#1461, o_year#1462]
Functions [1]: [partial_sum(amount#1463)]
Aggregate Attributes [2]: [sum#1471, isEmpty#1472]
Results [4]: [nation#1461, o_year#1462, sum#1473, isEmpty#1474]

(42) Exchange
Input [4]: [nation#1461, o_year#1462, sum#1473, isEmpty#1474]
Arguments: hashpartitioning(nation#1461, o_year#1462, 200), ENSURE_REQUIREMENTS, [plan_id=17732]

(43) HashAggregate
Input [4]: [nation#1461, o_year#1462, sum#1473, isEmpty#1474]
Keys [2]: [nation#1461, o_year#1462]
Functions [1]: [sum(amount#1463)]
Aggregate Attributes [1]: [sum(amount#1463)#1470]
Results [3]: [nation#1461, o_year#1462, sum(amount#1463)#1470 AS sum_profit#1464]

(44) Exchange
Input [3]: [nation#1461, o_year#1462, sum_profit#1464]
Arguments: rangepartitioning(nation#1461 ASC NULLS FIRST, o_year#1462 DESC NULLS LAST, 200), ENSURE_REQUIREMENTS, [plan_id=17735]

(45) Sort
Input [3]: [nation#1461, o_year#1462, sum_profit#1464]
Arguments: [nation#1461 ASC NULLS FIRST, o_year#1462 DESC NULLS LAST], true, 0

(46) AdaptiveSparkPlan
Output [3]: [nation#1461, o_year#1462, sum_profit#1464]
Arguments: isFinalPlan=false
Execution Time: 91.956
