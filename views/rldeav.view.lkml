view: rldeav {
  label: "EAV Fact"
  sql_table_name: `GPay.RLDeav`
    ;;

  dimension: metric_code {
    order_by_field: metric_order
    group_label: "Question Information"
    type: string
    sql: ${TABLE}.metric_code ;;
  }

  dimension: metric_id {
    order_by_field: metric_order
    group_label: "Question Information"
    type: number
    sql: ${TABLE}.metricID ;;
  }

  dimension: metric_label {
    order_by_field: metric_order
    group_label: "Question Information"
    type: string
    sql: ${TABLE}.metric_label ;;
  }

  dimension: metric_order {
    group_label: "Question Information"
    hidden: yes
    type: number
    sql: ${TABLE}.metric_order ;;
  }

  dimension: respondent_serial {
    group_label: "Question Information"
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}.respondent_serial ;;
  }

  dimension: response_code {
    order_by_field: response_order
    group_label: "Question Information"
    type: string
    sql: ${TABLE}.response_code ;;
  }

  dimension: response_id {
    order_by_field: response_order
    group_label: "Question Information"
    type: number
    sql: CAST(${TABLE}.responseID  AS INT64);;
  }

  dimension: response_label {
    order_by_field: response_order
    group_label: "Question Information"
    type: string
    sql: ${TABLE}.response_label ;;
  }

  dimension: response_order {
    group_label: "Question Information"
    type: number
    hidden: yes
    sql: ${TABLE}.response_order ;;
  }

  dimension: vtype {
    group_label: "Question Information"
    type: string
    label: "V Type"
    sql: ${TABLE}.vtype ;;
  }

  measure: unwtct {
    group_label: "Weight Metrics"
    description: "The count of respondents"
    label: "Unweighted Count"
    type: count_distinct
    sql: ${respondent_serial};;
  }
}
