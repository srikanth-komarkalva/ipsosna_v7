view: rldeav {
  label: "EAV Fact"
  sql_table_name: `GPay.RLDeav`
    ;;

  dimension: metric_code {
    hidden: yes
    type: string
    sql: ${TABLE}.metric_code ;;
  }

  dimension: metric_id {
    type: number
    hidden: yes
    primary_key: yes
    sql: ${TABLE}.metricID ;;
  }

  dimension: metric_label {
    hidden: yes
    type: string
    sql: ${TABLE}.metric_label ;;
  }

  dimension: metric_order {
    hidden: yes
    type: number
    sql: ${TABLE}.metric_order ;;
  }

  dimension: respondent_serial {
#     primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}.respondent_serial ;;
  }

  dimension: response_code {
    type: string
    hidden: yes
    sql: ${TABLE}.response_code ;;
  }

  dimension: response_id {
    type: number
    hidden: yes
    sql: CAST(${TABLE}.responseID  AS INT64);;
  }

  dimension: response_label {
    type: string
    hidden: yes
    sql: ${TABLE}.response_label ;;
  }

  dimension: response_order {
    type: number
    hidden: yes
    sql: ${TABLE}.response_order ;;
  }

  dimension: vtype {
    type: string
    hidden: yes
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
