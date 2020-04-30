view: rldeav_filter1 {
  label: "EAV Filter view 1"
  derived_table: {
    datagroup_trigger: ipsosna_v7_default_datagroup
    partition_keys: ["dummydate"]
    cluster_keys: ["metric_code","response_code"]
    sql: SELECT DISTINCT respondent_serial,metric_code, metric_label, metric_order,metricID,response_code, response_label,response_order,
    cast('2000-01-01' as date) as dummydate
    FROM GPay.RLDeav ;;
  }

  dimension: respondent_serial {
    group_label: "Filter Dimensions set 1"
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.respondent_serial ;;
  }

  dimension: metric_code {
    order_by_field: metric_order
    group_label: "Filter Dimensions set 1"
    label: "Metric Code 1"
    type: string
    sql: ${TABLE}.metric_code ;;
  }

#   filter: metric_code_1 {
#     type: string
#     suggestable: yes
#     suggest_dimension: metric_code
#     suggest_explore: gpay_crosstab
#     sql: ${TABLE}.metric_code ;;
#     group_label: "Filter Dimensions set 1"
#     label: "Metric Code 1"
#   }

  dimension: metric_label {
    order_by_field: metric_order
    group_label: "Filter Dimensions set 1"
    label: "Metric Label 1"
    type: string
    sql: ${TABLE}.metric_label ;;
  }

  dimension: metric_order {
    group_label: "Filter Dimensions set 1"
    type: number
    hidden: yes
    sql: ${TABLE}.metric_order ;;
  }

  dimension: metric_id {
    group_label: "Filter Dimensions set 1"
    type: number
    label: "Metric Id 1"
    sql: ${TABLE}.metricID ;;
  }

  dimension: response_code {
    order_by_field: response_code
    group_label: "Filter Dimensions set 1"
    type: string
    label: "Response Code 1"
    sql: ${TABLE}.response_code ;;
  }

  dimension: response_label {
    order_by_field: response_order
    group_label: "Filter Dimensions set 1"
    type: string
    label: "Response Label 1"
    sql: ${TABLE}.response_label ;;
  }

  dimension: response_order {
    group_label: "Filter Dimensions set 1"
    type: number
    hidden: yes
    sql: ${TABLE}.response_order ;;
  }
}
