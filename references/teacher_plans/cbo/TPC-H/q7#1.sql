== Physical Plan ==
AdaptiveSparkPlan (41)
+- Sort (40)
   +- Exchange (39)
      +- HashAggregate (38)
         +- Exchange (37)
            +- HashAggregate (36)
               +- Project (35)
                  +- SortMergeJoin Inner (34)
                     :- Sort (29)
                     :  +- Exchange (28)
                     :     +- Project (27)
                     :        +- SortMergeJoin Inner (26)
                     :           :- Sort (21)
                     :           :  +- Exchange (20)
                     :           :     +- Project (19)
                     :           :        +- SortMergeJoin Inner (18)
                     :           :           :- Sort (13)
                     :           :           :  +- Exchange (12)
                     :           :           :     +- Project (11)
                     :           :           :        +- BroadcastHashJoin Inner BuildLeft (10)
                     :           :           :           :- BroadcastExchange (7)
                     :           :           :           :  +- BroadcastNestedLoopJoin Inner BuildRight (6)
                     :           :           :           :     :- Filter (2)
                     :           :           :           :     :  +- Scan parquet spark_catalog.tpch_sf100.nation (1)
                     :           :           :           :     +- BroadcastExchange (5)
                     :           :           :           :        +- Filter (4)
                     :           :           :           :           +- Scan parquet spark_catalog.tpch_sf100.nation (3)
                     :           :           :           +- Filter (9)
                     :           :           :              +- Scan parquet spark_catalog.tpch_sf100.supplier (8)
                     :           :           +- Sort (17)
                     :           :              +- Exchange (16)
                     :           :                 +- Filter (15)
                     :           :                    +- Scan parquet spark_catalog.tpch_sf100.customer (14)
                     :           +- Sort (25)
                     :              +- Exchange (24)
                     :                 +- Filter (23)
                     :                    +- Scan parquet spark_catalog.tpch_sf100.orders (22)
                     +- Sort (33)
                        +- Exchange (32)
                           +- Filter (31)
                              +- Scan parquet spark_catalog.tpch_sf100.lineitem (30)


(1) Scan parquet spark_catalog.tpch_sf100.nation
Output [2]: [n_nationkey#41L, n_name#42]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/nation]
PushedFilters: [IsNotNull(n_nationkey), Or(EqualTo(n_name,ROMANIA),EqualTo(n_name,INDIA))]
ReadSchema: struct<n_nationkey:bigint,n_name:string>

(2) Filter
Input [2]: [n_nationkey#41L, n_name#42]
Condition : (isnotnull(n_nationkey#41L) AND ((n_name#42 = ROMANIA) OR (n_name#42 = INDIA)))

(3) Scan parquet spark_catalog.tpch_sf100.nation
Output [2]: [n_nationkey#885L, n_name#886]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/nation]
PushedFilters: [IsNotNull(n_nationkey), Or(EqualTo(n_name,INDIA),EqualTo(n_name,ROMANIA))]
ReadSchema: struct<n_nationkey:bigint,n_name:string>

(4) Filter
Input [2]: [n_nationkey#885L, n_name#886]
Condition : (isnotnull(n_nationkey#885L) AND ((n_name#886 = INDIA) OR (n_name#886 = ROMANIA)))

(5) BroadcastExchange
Input [2]: [n_nationkey#885L, n_name#886]
Arguments: IdentityBroadcastMode, [plan_id=10410]

(6) BroadcastNestedLoopJoin
Join type: Inner
Join condition: (((n_name#42 = ROMANIA) AND (n_name#886 = INDIA)) OR ((n_name#42 = INDIA) AND (n_name#886 = ROMANIA)))

(7) BroadcastExchange
Input [4]: [n_nationkey#41L, n_name#42, n_nationkey#885L, n_name#886]
Arguments: HashedRelationBroadcastMode(List(input[0, bigint, false]),false), [plan_id=10413]

(8) Scan parquet spark_catalog.tpch_sf100.supplier
Output [2]: [s_suppkey#208L, s_nationkey#211L]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/supplier]
PushedFilters: [IsNotNull(s_suppkey), IsNotNull(s_nationkey)]
ReadSchema: struct<s_suppkey:bigint,s_nationkey:bigint>

(9) Filter
Input [2]: [s_suppkey#208L, s_nationkey#211L]
Condition : (isnotnull(s_suppkey#208L) AND isnotnull(s_nationkey#211L))

(10) BroadcastHashJoin
Left keys [1]: [n_nationkey#41L]
Right keys [1]: [s_nationkey#211L]
Join type: Inner
Join condition: None

(11) Project
Output [4]: [n_name#42, n_nationkey#885L, n_name#886, s_suppkey#208L]
Input [6]: [n_nationkey#41L, n_name#42, n_nationkey#885L, n_name#886, s_suppkey#208L, s_nationkey#211L]

(12) Exchange
Input [4]: [n_name#42, n_nationkey#885L, n_name#886, s_suppkey#208L]
Arguments: hashpartitioning(n_nationkey#885L, 200), ENSURE_REQUIREMENTS, [plan_id=10418]

(13) Sort
Input [4]: [n_name#42, n_nationkey#885L, n_name#886, s_suppkey#208L]
Arguments: [n_nationkey#885L ASC NULLS FIRST], false, 0

(14) Scan parquet spark_catalog.tpch_sf100.customer
Output [2]: [c_custkey#8L, c_nationkey#11L]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/customer]
PushedFilters: [IsNotNull(c_custkey), IsNotNull(c_nationkey)]
ReadSchema: struct<c_custkey:bigint,c_nationkey:bigint>

(15) Filter
Input [2]: [c_custkey#8L, c_nationkey#11L]
Condition : (isnotnull(c_custkey#8L) AND isnotnull(c_nationkey#11L))

(16) Exchange
Input [2]: [c_custkey#8L, c_nationkey#11L]
Arguments: hashpartitioning(c_nationkey#11L, 200), ENSURE_REQUIREMENTS, [plan_id=10419]

(17) Sort
Input [2]: [c_custkey#8L, c_nationkey#11L]
Arguments: [c_nationkey#11L ASC NULLS FIRST], false, 0

(18) SortMergeJoin
Left keys [1]: [n_nationkey#885L]
Right keys [1]: [c_nationkey#11L]
Join type: Inner
Join condition: None

(19) Project
Output [4]: [n_name#42, n_name#886, s_suppkey#208L, c_custkey#8L]
Input [6]: [n_name#42, n_nationkey#885L, n_name#886, s_suppkey#208L, c_custkey#8L, c_nationkey#11L]

(20) Exchange
Input [4]: [n_name#42, n_name#886, s_suppkey#208L, c_custkey#8L]
Arguments: hashpartitioning(c_custkey#8L, 200), ENSURE_REQUIREMENTS, [plan_id=10426]

(21) Sort
Input [4]: [n_name#42, n_name#886, s_suppkey#208L, c_custkey#8L]
Arguments: [c_custkey#8L ASC NULLS FIRST], false, 0

(22) Scan parquet spark_catalog.tpch_sf100.orders
Output [2]: [o_orderkey#16L, o_custkey#17L]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/orders]
PushedFilters: [IsNotNull(o_orderkey), IsNotNull(o_custkey)]
ReadSchema: struct<o_orderkey:bigint,o_custkey:bigint>

(23) Filter
Input [2]: [o_orderkey#16L, o_custkey#17L]
Condition : (isnotnull(o_orderkey#16L) AND isnotnull(o_custkey#17L))

(24) Exchange
Input [2]: [o_orderkey#16L, o_custkey#17L]
Arguments: hashpartitioning(o_custkey#17L, 200), ENSURE_REQUIREMENTS, [plan_id=10427]

(25) Sort
Input [2]: [o_orderkey#16L, o_custkey#17L]
Arguments: [o_custkey#17L ASC NULLS FIRST], false, 0

(26) SortMergeJoin
Left keys [1]: [c_custkey#8L]
Right keys [1]: [o_custkey#17L]
Join type: Inner
Join condition: None

(27) Project
Output [4]: [n_name#42, n_name#886, s_suppkey#208L, o_orderkey#16L]
Input [6]: [n_name#42, n_name#886, s_suppkey#208L, c_custkey#8L, o_orderkey#16L, o_custkey#17L]

(28) Exchange
Input [4]: [n_name#42, n_name#886, s_suppkey#208L, o_orderkey#16L]
Arguments: hashpartitioning(s_suppkey#208L, o_orderkey#16L, 200), ENSURE_REQUIREMENTS, [plan_id=10434]

(29) Sort
Input [4]: [n_name#42, n_name#886, s_suppkey#208L, o_orderkey#16L]
Arguments: [s_suppkey#208L ASC NULLS FIRST, o_orderkey#16L ASC NULLS FIRST], false, 0

(30) Scan parquet spark_catalog.tpch_sf100.lineitem
Output [5]: [l_orderkey#25L, l_suppkey#27L, l_extendedprice#30, l_discount#31, l_shipdate#35]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/lineitem]
PushedFilters: [IsNotNull(l_shipdate), GreaterThanOrEqual(l_shipdate,1995-01-01), LessThanOrEqual(l_shipdate,1996-12-31), IsNotNull(l_suppkey), IsNotNull(l_orderkey)]
ReadSchema: struct<l_orderkey:bigint,l_suppkey:bigint,l_extendedprice:decimal(10,0),l_discount:decimal(10,0),l_shipdate:date>

(31) Filter
Input [5]: [l_orderkey#25L, l_suppkey#27L, l_extendedprice#30, l_discount#31, l_shipdate#35]
Condition : ((((isnotnull(l_shipdate#35) AND (l_shipdate#35 >= 1995-01-01)) AND (l_shipdate#35 <= 1996-12-31)) AND isnotnull(l_suppkey#27L)) AND isnotnull(l_orderkey#25L))

(32) Exchange
Input [5]: [l_orderkey#25L, l_suppkey#27L, l_extendedprice#30, l_discount#31, l_shipdate#35]
Arguments: hashpartitioning(l_suppkey#27L, l_orderkey#25L, 200), ENSURE_REQUIREMENTS, [plan_id=10435]

(33) Sort
Input [5]: [l_orderkey#25L, l_suppkey#27L, l_extendedprice#30, l_discount#31, l_shipdate#35]
Arguments: [l_suppkey#27L ASC NULLS FIRST, l_orderkey#25L ASC NULLS FIRST], false, 0

(34) SortMergeJoin
Left keys [2]: [s_suppkey#208L, o_orderkey#16L]
Right keys [2]: [l_suppkey#27L, l_orderkey#25L]
Join type: Inner
Join condition: None

(35) Project
Output [4]: [n_name#42 AS supp_nation#875, n_name#886 AS cust_nation#876, year(l_shipdate#35) AS l_year#877, (l_extendedprice#30 * (1 - l_discount#31)) AS volume#878]
Input [9]: [n_name#42, n_name#886, s_suppkey#208L, o_orderkey#16L, l_orderkey#25L, l_suppkey#27L, l_extendedprice#30, l_discount#31, l_shipdate#35]

(36) HashAggregate
Input [4]: [supp_nation#875, cust_nation#876, l_year#877, volume#878]
Keys [3]: [supp_nation#875, cust_nation#876, l_year#877]
Functions [1]: [partial_sum(volume#878)]
Aggregate Attributes [2]: [sum#891, isEmpty#892]
Results [5]: [supp_nation#875, cust_nation#876, l_year#877, sum#893, isEmpty#894]

(37) Exchange
Input [5]: [supp_nation#875, cust_nation#876, l_year#877, sum#893, isEmpty#894]
Arguments: hashpartitioning(supp_nation#875, cust_nation#876, l_year#877, 200), ENSURE_REQUIREMENTS, [plan_id=10442]

(38) HashAggregate
Input [5]: [supp_nation#875, cust_nation#876, l_year#877, sum#893, isEmpty#894]
Keys [3]: [supp_nation#875, cust_nation#876, l_year#877]
Functions [1]: [sum(volume#878)]
Aggregate Attributes [1]: [sum(volume#878)#890]
Results [4]: [supp_nation#875, cust_nation#876, l_year#877, sum(volume#878)#890 AS revenue#879]

(39) Exchange
Input [4]: [supp_nation#875, cust_nation#876, l_year#877, revenue#879]
Arguments: rangepartitioning(supp_nation#875 ASC NULLS FIRST, cust_nation#876 ASC NULLS FIRST, l_year#877 ASC NULLS FIRST, 200), ENSURE_REQUIREMENTS, [plan_id=10445]

(40) Sort
Input [4]: [supp_nation#875, cust_nation#876, l_year#877, revenue#879]
Arguments: [supp_nation#875 ASC NULLS FIRST, cust_nation#876 ASC NULLS FIRST, l_year#877 ASC NULLS FIRST], true, 0

(41) AdaptiveSparkPlan
Output [4]: [supp_nation#875, cust_nation#876, l_year#877, revenue#879]
Arguments: isFinalPlan=false
Execution Time: 300.0
