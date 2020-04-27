view: rldmetrics {
  label: "Metrics Master"
  sql_table_name: `GPay.RLDMetrics`
    ;;

  dimension: metric_code {
    group_label: "Question Information"
    type: string
#     order_by_field: metric_order
    sql: ${TABLE}.metric_code ;;
  }

  dimension: metric_id {
    primary_key: yes
    group_label: "Question Information"
    type: number
    order_by_field: metric_order
    sql: ${TABLE}.metricID ;;
  }

  dimension: metric_label {
    group_label: "Question Information"
    type: string
#     order_by_field: metric_order
    sql: ${TABLE}.metric_label ;;
  }

  dimension: metric_order {
    group_label: "Question Information"
    type: number
    hidden: yes
    sql: ${TABLE}.metric_order ;;
  }

  dimension: vtype {
    hidden: yes
    group_label: "Question Information"
    type: string
    sql: ${TABLE}.vtype ;;
  }
}
