== Physical Plan ==
AdaptiveSparkPlan (21)
+- TakeOrderedAndProject (20)
   +- HashAggregate (19)
      +- HashAggregate (18)
         +- Project (17)
            +- SortMergeJoin Inner (16)
               :- Sort (10)
               :  +- Exchange (9)
               :     +- Project (8)
               :        +- BroadcastHashJoin Inner BuildLeft (7)
               :           :- BroadcastExchange (4)
               :           :  +- Project (3)
               :           :     +- Filter (2)
               :           :        +- Scan parquet spark_catalog.tpch_sf100.customer (1)
               :           +- Filter (6)
               :              +- Scan parquet spark_catalog.tpch_sf100.orders (5)
               +- Sort (15)
                  +- Exchange (14)
                     +- Project (13)
                        +- Filter (12)
                           +- Scan parquet spark_catalog.tpch_sf100.lineitem (11)


(1) Scan parquet spark_catalog.tpch_sf100.customer
Output [2]: [c_custkey#8L, c_mktsegment#14]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/customer]
PushedFilters: [IsNotNull(c_mktsegment), EqualTo(c_mktsegment,FURNITURE), IsNotNull(c_custkey)]
ReadSchema: struct<c_custkey:bigint,c_mktsegment:string>

(2) Filter
Input [2]: [c_custkey#8L, c_mktsegment#14]
Condition : ((isnotnull(c_mktsegment#14) AND (c_mktsegment#14 = FURNITURE)) AND isnotnull(c_custkey#8L))

(3) Project
Output [1]: [c_custkey#8L]
Input [2]: [c_custkey#8L, c_mktsegment#14]

(4) BroadcastExchange
Input [1]: [c_custkey#8L]
Arguments: HashedRelationBroadcastMode(List(input[0, bigint, true]),false), [plan_id=6019]

(5) Scan parquet spark_catalog.tpch_sf100.orders
Output [4]: [o_orderkey#16L, o_custkey#17L, o_orderdate#20, o_shippriority#23]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/orders]
PushedFilters: [IsNotNull(o_orderdate), LessThan(o_orderdate,1995-03-11), IsNotNull(o_custkey), IsNotNull(o_orderkey)]
ReadSchema: struct<o_orderkey:bigint,o_custkey:bigint,o_orderdate:date,o_shippriority:int>

(6) Filter
Input [4]: [o_orderkey#16L, o_custkey#17L, o_orderdate#20, o_shippriority#23]
Condition : (((isnotnull(o_orderdate#20) AND (o_orderdate#20 < 1995-03-11)) AND isnotnull(o_custkey#17L)) AND isnotnull(o_orderkey#16L))

(7) BroadcastHashJoin
Left keys [1]: [c_custkey#8L]
Right keys [1]: [o_custkey#17L]
Join type: Inner
Join condition: None

(8) Project
Output [3]: [o_orderkey#16L, o_orderdate#20, o_shippriority#23]
Input [5]: [c_custkey#8L, o_orderkey#16L, o_custkey#17L, o_orderdate#20, o_shippriority#23]

(9) Exchange
Input [3]: [o_orderkey#16L, o_orderdate#20, o_shippriority#23]
Arguments: hashpartitioning(o_orderkey#16L, 200), ENSURE_REQUIREMENTS, [plan_id=6024]

(10) Sort
Input [3]: [o_orderkey#16L, o_orderdate#20, o_shippriority#23]
Arguments: [o_orderkey#16L ASC NULLS FIRST], false, 0

(11) Scan parquet spark_catalog.tpch_sf100.lineitem
Output [4]: [l_orderkey#25L, l_extendedprice#30, l_discount#31, l_shipdate#35]
Batched: true
Location: InMemoryFileIndex [file:/path/to/datasets/tpch_sf100_parquet/lineitem]
PushedFilters: [IsNotNull(l_shipdate), GreaterThan(l_shipdate,1995-03-11), IsNotNull(l_orderkey)]
ReadSchema: struct<l_orderkey:bigint,l_extendedprice:decimal(10,0),l_discount:decimal(10,0),l_shipdate:date>

(12) Filter
Input [4]: [l_orderkey#25L, l_extendedprice#30, l_discount#31, l_shipdate#35]
Condition : ((isnotnull(l_shipdate#35) AND (l_shipdate#35 > 1995-03-11)) AND isnotnull(l_orderkey#25L))

(13) Project
Output [3]: [l_orderkey#25L, l_extendedprice#30, l_discount#31]
Input [4]: [l_orderkey#25L, l_extendedprice#30, l_discount#31, l_shipdate#35]

(14) Exchange
Input [3]: [l_orderkey#25L, l_extendedprice#30, l_discount#31]
Arguments: hashpartitioning(l_orderkey#25L, 200), ENSURE_REQUIREMENTS, [plan_id=6025]

(15) Sort
Input [3]: [l_orderkey#25L, l_extendedprice#30, l_discount#31]
Arguments: [l_orderkey#25L ASC NULLS FIRST], false, 0

(16) SortMergeJoin
Left keys [1]: [o_orderkey#16L]
Right keys [1]: [l_orderkey#25L]
Join type: Inner
Join condition: None

(17) Project
Output [5]: [o_orderdate#20, o_shippriority#23, l_orderkey#25L, l_extendedprice#30, l_discount#31]
Input [6]: [o_orderkey#16L, o_orderdate#20, o_shippriority#23, l_orderkey#25L, l_extendedprice#30, l_discount#31]

(18) HashAggregate
Input [5]: [o_orderdate#20, o_shippriority#23, l_orderkey#25L, l_extendedprice#30, l_discount#31]
Keys [3]: [l_orderkey#25L, o_orderdate#20, o_shippriority#23]
Functions [1]: [partial_sum((l_extendedprice#30 * (1 - l_discount#31)))]
Aggregate Attributes [2]: [sum#573, isEmpty#574]
Results [5]: [l_orderkey#25L, o_orderdate#20, o_shippriority#23, sum#575, isEmpty#576]

(19) HashAggregate
Input [5]: [l_orderkey#25L, o_orderdate#20, o_shippriority#23, sum#575, isEmpty#576]
Keys [3]: [l_orderkey#25L, o_orderdate#20, o_shippriority#23]
Functions [1]: [sum((l_extendedprice#30 * (1 - l_discount#31)))]
Aggregate Attributes [1]: [sum((l_extendedprice#30 * (1 - l_discount#31)))#572]
Results [4]: [l_orderkey#25L, sum((l_extendedprice#30 * (1 - l_discount#31)))#572 AS revenue#566, o_orderdate#20, o_shippriority#23]

(20) TakeOrderedAndProject
Input [4]: [l_orderkey#25L, revenue#566, o_orderdate#20, o_shippriority#23]
Arguments: 10, [revenue#566 DESC NULLS LAST, o_orderdate#20 ASC NULLS FIRST], [l_orderkey#25L, revenue#566, o_orderdate#20, o_shippriority#23]

(21) AdaptiveSparkPlan
Output [4]: [l_orderkey#25L, revenue#566, o_orderdate#20, o_shippriority#23]
Arguments: isFinalPlan=false
Execution Time: 30.187
