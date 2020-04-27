view: rldresponses {
  label: "Responses Labels"
  sql_table_name: `GPay.RLDResponses`
    ;;

  dimension: metric_id {
    hidden: yes
    type: number
    sql: ${TABLE}.metricID ;;
  }

  dimension: response_code {
    group_label: "Question Information"
    order_by_field: response_order
    type: string
    sql: ${TABLE}.response_code ;;
  }

  dimension: response_id {
    group_label: "Question Information"
    primary_key: yes
    order_by_field: response_order
    type: number
    sql: ${TABLE}.responseID ;;
  }

  dimension: response_label {
    group_label: "Question Information"
    type: string
    order_by_field: response_order
    sql: ${TABLE}.response_label ;;
  }

  dimension: response_order {
    group_label: "Question Information"
    type: number
#     hidden: yes
    sql: ${TABLE}.response_order ;;
  }
}
