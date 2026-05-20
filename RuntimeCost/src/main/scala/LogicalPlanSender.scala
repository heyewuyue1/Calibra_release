package cn.edu.ruc

import org.apache.spark.sql.SparkSession
import org.apache.spark.sql.catalyst.plans.logical.LogicalPlan
import org.apache.spark.sql.catalyst.rules.Rule
import org.apache.logging.log4j.LogManager
import org.apache.spark.sql.SparkSessionExtensions
import org.apache.spark.sql.execution.adaptive.{LogicalQueryStage, QueryStageExec}


class LogicalPlanSender(session: SparkSession, runTime: Boolean) extends Rule[LogicalPlan] {
    val logger = LogManager.getLogger(this.getClass)


    override def apply(plan: LogicalPlan): LogicalPlan = {
        if (!runTime) {
          logger.warn(s"Sending logical plan:\n${plan.toString()}")
          val req = CostRequest(
            `type` = 0,
            candidates = List(
              PlanInfo(
                plan = plan.toString(),
                queryStages = Map.empty,
                card = -1L,
                size = -1L
              )
            ),
            advisoryChoose = 0
          )
          WebUtils.sendCostRequest(req)
        } else {
          val executedStages = plan.collect {
            case lqs@LogicalQueryStage(_, stage: QueryStageExec) =>
              logger.warn(s"Stage String: ${stage.plan.toString()}")
              lqs.toString.trim -> (
                stage.isMaterialized,
                stage.getRuntimeStatistics.rowCount, // rowCount
                stage.getRuntimeStatistics.sizeInBytes, // sizeInBytes
                stage.plan.toString() // plan
              )
          }.toMap
          logger.warn(s"Sending Partially Executed Plan:\n${plan.toString()}")
          val req = CostRequest(
            `type` = 2,
            candidates = List(
              PlanInfo(
                plan = plan.toString(),
                queryStages = executedStages.map { case (k, v) =>
                  k -> QueryStageInfo(
                    materialized = v._1,
                    card = v._2.map(_.toLong).getOrElse(-1L),
                    size = v._3.toLong,
                    stagePlan = v._4
                  )
                },
                card = -1L,
                size = -1L
              )
            ),
            advisoryChoose = 0
          )
          WebUtils.sendCostRequest(req)
        }
        plan
    }
}

class LogicalPlanSenderInjector extends (SparkSessionExtensions => Unit) {
  private val logger = LogManager.getLogger(this.getClass)

  override def apply(extensions: SparkSessionExtensions): Unit = {
    extensions.injectRuntimeOptimizerRule { session =>
      new LogicalPlanSender(session, runTime = true)
    }
    extensions.injectOptimizerRule { session =>
      new LogicalPlanSender(session, runTime = false)
    }
    logger.warn("LogicalPlanSender is injected")
    if (System.getProperty("spark.sql.adaptive.ssa.enabled", "false") != "false" ||
        System.getProperty("spark.sql.adaptive.lssa.enabled", "false") != "false") {
      extensions.injectRuntimeOptimizerRule { _ =>
        new SubquerySelection()
      }
      logger.warn("SubquerySelection is injected")
    }
  }
}
