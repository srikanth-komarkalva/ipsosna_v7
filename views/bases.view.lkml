include: "counts.view.lkml"
view: bases {
  derived_table: {
    datagroup_trigger: ipsosna_v7_default_datagroup
    partition_keys: ["dummydate"]
    cluster_keys: ["metricID"]
    sql: SELECT v.metricID, v.metric_code, v.metric_label, v.metric_order,f.WaveSID,COUNT(DISTINCT v.respondent_serial) AS UnBase, SUM(f.wm3) AS WtBase,
        cast('2000-01-01' as date) as dummydate
        FROM (SELECT DISTINCT respondent_serial, metricID, metric_code, metric_label, metric_order, vtype FROM GPay.RLDeav) v
        LEFT OUTER JOIN GPay.RLDflat f ON f.respondent_serial=v.respondent_serial
        WHERE v.vtype IN ('single','multi')
        GROUP BY v.metricID, v.metric_code, v.metric_label, v.metric_order,f.WaveSID
 ;;
  }

  dimension: wave_sid {
    type: string
    label: "Wave"
    sql: ${TABLE}.WaveSID ;;
  }

  dimension: metric_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.metricID ;;
  }

  dimension: metric_code {
    type: string
    order_by_field: metric_order
    sql: ${TABLE}.metric_code ;;
  }

  dimension: metric_code_label {
    type: string
    case: {
    when: {
      sql: ${TABLE}.metric_code = "Q2" ;;
      label: "Awareness"
    }
    when: {
      sql: ${TABLE}.metric_code = "Q3" ;;
      label: "Consideration"
    }
    when: {
      sql: ${TABLE}.metric_code = "Q4" ;;
      label: "Intent"
    }
    when: {
      sql: ${TABLE}.metric_code = "Q4_TRUST" ;;
      label: "Action"
    }
  }
  }

  dimension: metric_label {
    order_by_field: metric_order
    type: string
    sql: ${TABLE}.metric_label ;;
  }

  dimension: metric_order {
    type: number
    hidden: yes
    sql: ${TABLE}.metric_order ;;
  }

  dimension: un_base {
    label: "Un Weighted Base"
#     hidden: yes
    type: number
    sql: ${TABLE}.UnBase ;;
  }

  dimension: wt_base {
#     hidden: yes
    type: number
    label: "Weighted Base"
    value_format_name: decimal_0
    sql: ${TABLE}.WtBase ;;
  }

  measure: wt_pct {
    group_label: "Weight Metrics"
    label: "Weighted Pct"
    type: number
    value_format_name: percent_1
    sql: ${counts.wt_ct}/${wt_base} ;;
  }

  measure: un_pct {
    group_label: "Weight Metrics"
    label: "Un Weighted Pct"
    type: number
    value_format_name: percent_0
    sql: ${counts.un_ct}/${un_base} ;;
  }
}