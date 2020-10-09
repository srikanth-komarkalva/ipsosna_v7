include: "counts.view.lkml"
include: "rldflat.view.lkml"
include: "rldeav_filter1.view.lkml"
view: bases {
  derived_table: {
    datagroup_trigger: ipsosna_v7_default_datagroup
    partition_keys: ["dummydate"]
    cluster_keys: ["metricID"]
    sql: SELECT v.metricID, v.metric_code, v.metric_label, v.metric_order,f.WaveSID,
        (SELECT DISTINCT response_label FROM `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDResponses` resp
        INNER JOIN `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDMetrics` metric ON resp.metricid= metric.metricid
        WHERE metric_code = 'WaveSID' AND resp.response_code = f.WaveSID) AS WaveSID_Label,
        COUNT(DISTINCT v.respondent_serial) AS UnBase, SUM(f.wm3) AS WtBase,
        cast('2000-01-01' as date) as dummydate
        FROM (SELECT DISTINCT respondent_serial, metricID, metric_code, metric_label, metric_order, vtype FROM GPay.RLDeav) v
        LEFT OUTER JOIN GPay.RLDflat f ON f.respondent_serial=v.respondent_serial
        WHERE v.vtype IN ('single','multi')
        {% if gender._is_selected %} {% condition gender %} f.resp_gender {% endcondition %} {% endif %}

        GROUP BY v.metricID, v.metric_code, v.metric_label, v.metric_order,f.WaveSID
 ;;
  }

  filter: gender {
    type: string
    suggest_dimension: rldflat.resp_gender
  }

  dimension: wave_sid {
    type: string
#     hidden: yes
    label: "Wave from Bases"
    sql: ${TABLE}.WaveSID ;;
  }

  dimension: wave_sid_label {
    label: "Wave Label"
    group_label: "Demographic Fields"
    type: string
    sql: ${TABLE}.WaveSID_Label ;;
  }

  dimension: resp_gender {
    type: string
#     hidden: yes
    label: "Gender"
    sql: ${TABLE}.resp_gender ;;
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
      label: "Awareness (Q2)"
    }
    when: {
      sql: ${TABLE}.metric_code = "Q3" ;;
      label: "Consideration (Q3)"
    }
    when: {
      sql: ${TABLE}.metric_code = "Q4" ;;
      label: "Intent (Q4)"
    }
    when: {
      sql: ${TABLE}.metric_code = "Q4_TRUST" ;;
      label: "Trust (Q4)"
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
    value_format_name: percent_0
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
