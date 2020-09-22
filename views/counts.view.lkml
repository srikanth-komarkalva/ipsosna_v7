include: "rldflat.view.lkml"
view: counts {
  derived_table: {
    datagroup_trigger: ipsosna_v7_default_datagroup
    partition_keys: ["dummydate"]
    cluster_keys: ["metricID"]
    sql: SELECT v.metricID, v.response_code, v.response_label,v.response_order,f.WaveSID,COUNT(DISTINCT v.respondent_serial) AS UnCt, SUM(f.wm3) AS WtCt,
        cast('2000-01-01' as date) as dummydate
        FROM GPay.Z_RLDeav v
        LEFT OUTER JOIN GPay.Z_RLDflat f ON f.respondent_serial=v.respondent_serial
        WHERE v.vtype IN ('single','multi') and
        {% condition gender %} f.resp_gender {% endcondition %}
        GROUP BY  v.metricID, v.response_code, v.response_label, v.response_order,f.WaveSID
 ;;
  }

  filter: gender {
    type: string
    suggest_dimension: rldflat.resp_gender
  }

  dimension: wave_sid {
    type: string
    hidden: yes
    label: "Wave"
    sql: ${TABLE}.WaveSID ;;
  }

  dimension: metric_id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.metricID ;;
  }

  dimension: response_code {
    order_by_field: response_order
    type: string
    sql: ${TABLE}.response_code ;;
  }

  dimension: response_label {
    type: string
    order_by_field: response_order
    sql: ${TABLE}.response_label ;;
  }

  dimension: response_label_ {
    type: string
    label: "Response Label New"
    order_by_field: response_order
    sql: CASE ${response_label}
          WHEN 'Gpay' THEN 'Google Pay'
          ELSE ${response_label}
          END;;
  }

  dimension: response_order {
    type: number
    hidden: yes
    sql: ${TABLE}.response_order ;;
  }

  dimension: un_ct {
    type: number
    value_format_name: decimal_0
    label: "Un Weighted Count"
#     hidden: yes
    sql: ${TABLE}.UnCt ;;
  }

  dimension: wt_ct {
    type: number
    value_format_name: decimal_1
    label: "Weighted Count"
#     hidden: yes
    sql: ${TABLE}.WtCt ;;
  }
}