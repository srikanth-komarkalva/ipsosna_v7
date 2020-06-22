view: wave_labels {
  derived_table: {
    sql: SELECT DISTINCT response_label, response_code FROM `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDResponses` resp
        INNER JOIN `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDMetrics` metric ON resp.metricid= metric.metricid
        WHERE metric_code = 'WaveSID'
 ;;
  }

  dimension: response_label {
    type: string
    label: "Wave"
    order_by_field: wave_date
    sql: ${TABLE}.response_label ;;
  }

  dimension: wave_year {
    hidden: yes
    group_label: "Demographic Fields"
    type: number
    sql: CAST(SUBSTR(${response_label},5,4) AS INT64);;
  }

  dimension: wave_month_part {
    hidden: yes
    group_label: "Demographic Fields"
    type: string
    sql: SUBSTR(${response_label},1,3);;
  }

  dimension: wave_month {
    hidden: yes
    group_label: "Demographic Fields"
    type: number
    sql: CAST(
          CASE ${wave_month_part}
          WHEN 'Jan' THEN 1
          WHEN 'Feb' THEN 2
          WHEN 'Mar' THEN 3
          WHEN 'Apr' THEN 4
          WHEN 'May' THEN 5
          WHEN 'Jun' THEN 6
          WHEN 'Jul' THEN 7
          WHEN 'Aug' THEN 8
          WHEN 'Sep' THEN 9
          WHEN 'Oct' THEN 10
          WHEN 'Nov' THEN 11
          WHEN 'Dec' THEN 12
          ELSE 1
          END
          AS INT64) ;;
  }

  dimension: wave_day_part {
    hidden: yes
    group_label: "Demographic Fields"
    type: string
    sql: SUBSTR(${response_label},12,2);;
  }

  dimension: wave_day {
    hidden: yes
    group_label: "Demographic Fields"
    type: number
    sql: CAST(CASE ${wave_day_part}
          WHEN 'W1' THEN 1
          WHEN 'W2' THEN 15
          WHEN 'Ne' THEN 1
          WHEN 'Pa' THEN 1
          ELSE 1
          END AS INT64) ;;
  }

  dimension: wave_date {
    label: "Wave (Date)"
    group_label: "Demographic Fields"
    type: date
    sql: CAST(date(${wave_year},${wave_month},${wave_day}) as DATE) ;;
  }


  dimension: response_code {
    type: string
    hidden: yes
    sql: ${TABLE}.response_code ;;
  }
}
