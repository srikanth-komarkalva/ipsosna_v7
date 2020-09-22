view: rldeav_filter2 {
  label: "EAV Filter view 2"
  derived_table: {
    datagroup_trigger: ipsosna_v7_default_datagroup
    partition_keys: ["dummydate"]
    cluster_keys: ["metric_code","response_label"]
    sql: SELECT DISTINCT respondent_serial,metric_code, metric_label, metric_order,metricID,response_code, response_label,response_order,
    cast('2000-01-01' as date) as dummydate
    FROM GPay.Z_RLDeav
       ;;
  }

  dimension: respondent_serial {
    group_label: "Filter Dimensions set 2"
    type: number
    hidden: yes
    primary_key: yes
    sql: ${TABLE}.respondent_serial ;;
  }

  dimension: metric_code {
    order_by_field: metric_order
    group_label: "Filter Dimensions set 2"
    type: string
    label: "Metric Code 2"
    sql: ${TABLE}.metric_code ;;
  }

  dimension: metric_label {
    order_by_field: metric_order
    group_label: "Filter Dimensions set 2"
    type: string
    label: "Metric Label 2"
    sql: ${TABLE}.metric_label ;;
  }

  dimension: metric_order {
    label: "Metric Order 2"
    hidden: yes
    group_label: "Filter Dimensions set 2"
    type: number
    sql: ${TABLE}.metric_order ;;
  }

  dimension: metric_id {
    label: "Metric Id 2"
    group_label: "Filter Dimensions set 2"
    type: number
    sql: ${TABLE}.metricID ;;
  }

  dimension: response_code {
    label: "Response Code 2"
    group_label: "Filter Dimensions set 2"
    type: string
    order_by_field: response_order
    sql: ${TABLE}.response_code ;;
  }

  dimension: response_label {
    label: "Response Label 2"
    group_label: "Filter Dimensions set 2"
    type: string
    order_by_field: response_order
    sql: ${TABLE}.response_label ;;
  }

  dimension: response_order {
    hidden: yes
    group_label: "Filter Dimensions set 2"
    type: number
    sql: ${TABLE}.response_order ;;
  }
}