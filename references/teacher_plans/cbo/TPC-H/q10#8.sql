== Physical Plan ==
AdaptiveSparkPlan (30)
+- TakeOrderedAndProject (29)
   +- HashAggregate (28)
      +- Exchange (27)
         +- HashAggregate (26)
            +- Project (25)
               +- SortMergeJoin Inner (24)
                  :- Sort (18)
                  :  +- Exchange (17)
                  :     +- Project (16)
                  :        +- SortMergeJoin Inner (15)
                  :           :- Sort (9)
                  :           :  +- Exchange (8)
                  :           :     +- Project (7)
                  :           :        +- BroadcastHashJoin Inner BuildRight (6)
                  :           :           :- Filter (2)
                  :           :           :  +- Scan parquet spark_catalog.tpch_sf100.customer (1)
                  :           :           +- BroadcastExchange (5)
                  :           :              +- Filter (4)
                  :           :                 +- Scan parquet spark_catalog.tpch_sf100.nation (3)
                  :           +- Sort (14)
                  :              +- Exchange (13)
                  :                 +- Project (12)
                  :                    +- Filter (11)
                  :                       +- Scan parquet spark_catalog.tpch_sf100.orders (10)
                  +- Sort (23)
                     +- Exchange (22)
                        +- Project (21)
                           +- Filter (20)
                              +- Scan parquet spark_catalog.tpch_sf100.lineitem (19)


(1) Scan parquet spark_catalog.tpch_sf100.customer
Output [7]: [c_custkey#8L, c_name#9, c_address#10, c_nationkey#11L, c_phone#12, c_acctbal#13, c_comment#15]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/customer]
PushedFilters: [IsNotNull(c_custkey), IsNotNull(c_nationkey)]
ReadSchema: struct<c_custkey:bigint,c_name:string,c_address:string,c_nationkey:bigint,c_phone:string,c_acctbal:decimal(10,0),c_comment:string>

(2) Filter
Input [7]: [c_custkey#8L, c_name#9, c_address#10, c_nationkey#11L, c_phone#12, c_acctbal#13, c_comment#15]
Condition : (isnotnull(c_custkey#8L) AND isnotnull(c_nationkey#11L))

(3) Scan parquet spark_catalog.tpch_sf100.nation
Output [2]: [n_nationkey#41L, n_name#42]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/nation]
PushedFilters: [IsNotNull(n_nationkey)]
ReadSchema: struct<n_nationkey:bigint,n_name:string>

(4) Filter
Input [2]: [n_nationkey#41L, n_name#42]
Condition : isnotnull(n_nationkey#41L)

(5) BroadcastExchange
Input [2]: [n_nationkey#41L, n_name#42]
Arguments: HashedRelationBroadcastMode(List(input[0, bigint, false]),false), [plan_id=1672]

(6) BroadcastHashJoin
Left keys [1]: [c_nationkey#11L]
Right keys [1]: [n_nationkey#41L]
Join type: Inner
Join condition: None

(7) Project
Output [7]: [c_custkey#8L, c_name#9, c_address#10, c_phone#12, c_acctbal#13, c_comment#15, n_name#42]
Input [9]: [c_custkey#8L, c_name#9, c_address#10, c_nationkey#11L, c_phone#12, c_acctbal#13, c_comment#15, n_nationkey#41L, n_name#42]

(8) Exchange
Input [7]: [c_custkey#8L, c_name#9, c_address#10, c_phone#12, c_acctbal#13, c_comment#15, n_name#42]
Arguments: hashpartitioning(c_custkey#8L, 200), ENSURE_REQUIREMENTS, [plan_id=1677]

(9) Sort
Input [7]: [c_custkey#8L, c_name#9, c_address#10, c_phone#12, c_acctbal#13, c_comment#15, n_name#42]
Arguments: [c_custkey#8L ASC NULLS FIRST], false, 0

(10) Scan parquet spark_catalog.tpch_sf100.orders
Output [3]: [o_orderkey#16L, o_custkey#17L, o_orderdate#20]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/orders]
PushedFilters: [IsNotNull(o_orderdate), GreaterThanOrEqual(o_orderdate,1993-03-01), LessThan(o_orderdate,1993-06-01), IsNotNull(o_custkey), IsNotNull(o_orderkey)]
ReadSchema: struct<o_orderkey:bigint,o_custkey:bigint,o_orderdate:date>

(11) Filter
Input [3]: [o_orderkey#16L, o_custkey#17L, o_orderdate#20]
Condition : ((((isnotnull(o_orderdate#20) AND (o_orderdate#20 >= 1993-03-01)) AND (o_orderdate#20 < 1993-06-01)) AND isnotnull(o_custkey#17L)) AND isnotnull(o_orderkey#16L))

(12) Project
Output [2]: [o_orderkey#16L, o_custkey#17L]
Input [3]: [o_orderkey#16L, o_custkey#17L, o_orderdate#20]

(13) Exchange
Input [2]: [o_orderkey#16L, o_custkey#17L]
Arguments: hashpartitioning(o_custkey#17L, 200), ENSURE_REQUIREMENTS, [plan_id=1678]

(14) Sort
Input [2]: [o_orderkey#16L, o_custkey#17L]
Arguments: [o_custkey#17L ASC NULLS FIRST], false, 0

(15) SortMergeJoin
Left keys [1]: [c_custkey#8L]
Right keys [1]: [o_custkey#17L]
Join type: Inner
Join condition: None

(16) Project
Output [8]: [c_custkey#8L, c_name#9, c_address#10, c_phone#12, c_acctbal#13, c_comment#15, n_name#42, o_orderkey#16L]
Input [9]: [c_custkey#8L, c_name#9, c_address#10, c_phone#12, c_acctbal#13, c_comment#15, n_name#42, o_orderkey#16L, o_custkey#17L]

(17) Exchange
Input [8]: [c_custkey#8L, c_name#9, c_address#10, c_phone#12, c_acctbal#13, c_comment#15, n_name#42, o_orderkey#16L]
Arguments: hashpartitioning(o_orderkey#16L, 200), ENSURE_REQUIREMENTS, [plan_id=1685]

(18) Sort
Input [8]: [c_custkey#8L, c_name#9, c_address#10, c_phone#12, c_acctbal#13, c_comment#15, n_name#42, o_orderkey#16L]
Arguments: [o_orderkey#16L ASC NULLS FIRST], false, 0

(19) Scan parquet spark_catalog.tpch_sf100.lineitem
Output [4]: [l_orderkey#25L, l_extendedprice#30, l_discount#31, l_returnflag#33]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/lineitem]
PushedFilters: [IsNotNull(l_returnflag), EqualTo(l_returnflag,R), IsNotNull(l_orderkey)]
ReadSchema: struct<l_orderkey:bigint,l_extendedprice:decimal(10,0),l_discount:decimal(10,0),l_returnflag:string>

(20) Filter
Input [4]: [l_orderkey#25L, l_extendedprice#30, l_discount#31, l_returnflag#33]
Condition : ((isnotnull(l_returnflag#33) AND (l_returnflag#33 = R)) AND isnotnull(l_orderkey#25L))

(21) Project
Output [3]: [l_orderkey#25L, l_extendedprice#30, l_discount#31]
Input [4]: [l_orderkey#25L, l_extendedprice#30, l_discount#31, l_returnflag#33]

(22) Exchange
Input [3]: [l_orderkey#25L, l_extendedprice#30, l_discount#31]
Arguments: hashpartitioning(l_orderkey#25L, 200), ENSURE_REQUIREMENTS, [plan_id=1686]

(23) Sort
Input [3]: [l_orderkey#25L, l_extendedprice#30, l_discount#31]
Arguments: [l_orderkey#25L ASC NULLS FIRST], false, 0

(24) SortMergeJoin
Left keys [1]: [o_orderkey#16L]
Right keys [1]: [l_orderkey#25L]
Join type: Inner
Join condition: None

(25) Project
Output [9]: [c_custkey#8L, c_name#9, c_address#10, c_phone#12, c_acctbal#13, c_comment#15, l_extendedprice#30, l_discount#31, n_name#42]
Input [11]: [c_custkey#8L, c_name#9, c_address#10, c_phone#12, c_acctbal#13, c_comment#15, n_name#42, o_orderkey#16L, l_orderkey#25L, l_extendedprice#30, l_discount#31]

(26) HashAggregate
Input [9]: [c_custkey#8L, c_name#9, c_address#10, c_phone#12, c_acctbal#13, c_comment#15, l_extendedprice#30, l_discount#31, n_name#42]
Keys [7]: [c_custkey#8L, c_name#9, c_acctbal#13, c_phone#12, n_name#42, c_address#10, c_comment#15]
Functions [1]: [partial_sum((l_extendedprice#30 * (1 - l_discount#31)))]
Aggregate Attributes [2]: [sum#170, isEmpty#171]
Results [9]: [c_custkey#8L, c_name#9, c_acctbal#13, c_phone#12, n_name#42, c_address#10, c_comment#15, sum#172, isEmpty#173]

(27) Exchange
Input [9]: [c_custkey#8L, c_name#9, c_acctbal#13, c_phone#12, n_name#42, c_address#10, c_comment#15, sum#172, isEmpty#173]
Arguments: hashpartitioning(c_custkey#8L, c_name#9, c_acctbal#13, c_phone#12, n_name#42, c_address#10, c_comment#15, 200), ENSURE_REQUIREMENTS, [plan_id=1693]

(28) HashAggregate
Input [9]: [c_custkey#8L, c_name#9, c_acctbal#13, c_phone#12, n_name#42, c_address#10, c_comment#15, sum#172, isEmpty#173]
Keys [7]: [c_custkey#8L, c_name#9, c_acctbal#13, c_phone#12, n_name#42, c_address#10, c_comment#15]
Functions [1]: [sum((l_extendedprice#30 * (1 - l_discount#31)))]
Aggregate Attributes [1]: [sum((l_extendedprice#30 * (1 - l_discount#31)))#169]
Results [8]: [c_custkey#8L, c_name#9, sum((l_extendedprice#30 * (1 - l_discount#31)))#169 AS revenue#163, c_acctbal#13, n_name#42, c_address#10, c_phone#12, c_comment#15]

(29) TakeOrderedAndProject
Input [8]: [c_custkey#8L, c_name#9, revenue#163, c_acctbal#13, n_name#42, c_address#10, c_phone#12, c_comment#15]
Arguments: 20, [revenue#163 DESC NULLS LAST], [c_custkey#8L, c_name#9, revenue#163, c_acctbal#13, n_name#42, c_address#10, c_phone#12, c_comment#15]

(30) AdaptiveSparkPlan
Output [8]: [c_custkey#8L, c_name#9, revenue#163, c_acctbal#13, n_name#42, c_address#10, c_phone#12, c_comment#15]
Arguments: isFinalPlan=false
Execution Time: 30.066
