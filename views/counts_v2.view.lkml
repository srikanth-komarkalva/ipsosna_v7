include: "bases_v2.view.lkml"
include: "rldeav_filter1.view.lkml"
include: "rldeav_filter2.view.lkml"
include: "rldeav_filter3.view.lkml"
view: counts_v2 {
  derived_table: {
    datagroup_trigger: ipsosna_v7_default_datagroup
    partition_keys: ["dummydate"]
    cluster_keys: ["metricID"]
    sql: SELECT v.metricID, v.metric_code, v.response_code, v.response_label,v.response_order,v.respondent_serial,
        f.wm3,f.QuotAgeRange,f.resp_gender,
        cast('2000-01-01' as date) as dummydate FROM GPay.RLDeav v
        LEFT OUTER JOIN GPay.RLDflat f ON f.respondent_serial=v.respondent_serial
        WHERE v.vtype IN ('single','multi');;
  }
#   AND f.resp_gender='male' and f.QuotAgeRange ='_18_24'
# INNER JOIN (SELECT DISTINCT respondent_serial FROM GPay.RLDeav WHERE metric_code='IN02REGION1' AND response_label IN('MAHARASHTRA')) f2 ON f2.respondent_serial=v.respondent_serial
# INNER JOIN (SELECT DISTINCT respondent_serial FROM GPay.RLDeav WHERE metric_code='Q3A_P3M[{_4}].Q3A_P3M_scale' AND response_label IN('In the last month','In the last 2 months','In the last 3 months')) f3 ON f3.respondent_serial=v.respondent_serial

# INNER JOIN (SELECT DISTINCT respondent_serial FROM GPay.RLDeav WHERE {% condition metric_code %} rldeav_filter1.metric_code {% endcondition %}
# AND {% condition response_label %} rldeav_filter1.response_label {% endcondition %}) f2 ON f2.respondent_serial=v.respondent_serial
# INNER JOIN (SELECT DISTINCT respondent_serial FROM GPay.RLDeav WHERE {% condition metric_code %} rldeav_filter2.metric_code {% endcondition %}
# AND {% condition response_label %} rldeav_filter2.response_label {% endcondition %}) f3 ON f3.respondent_serial=v.respondent_serial

# AND {% condition resp_gender %} bases_v2.resp_gender {% endcondition %}
# AND {% condition QuotAgeRange %} bases_v2.QuotAgeRange {% endcondition %}

  dimension: metric_id {
    hidden: yes
#     primary_key: yes
    type: number
    sql: ${TABLE}.metricID ;;
  }

# #   filter: metric_code_1 {
# #     full_suggestions: yes
# #     suggest_dimension: rldeav_filter1.metric_code
# #     type: string
# #     sql: {% condition metric_code_1 %} ${rldeav_filter1.metric_code} {% endcondition %}
# #     ;;
# #   }
# #   filter: response_label_1 {
# #     full_suggestions: yes
# #     suggest_dimension: rldeav_filter1.response_label
# #     type: string
# #     sql: {% condition response_label_1 %} ${rldeav_filter1.response_label} {% endcondition %}
# #      ;;
# #   }
# #   filter: metric_code_2 {
# #     full_suggestions: yes
# #     suggest_dimension: rldeav_filter2.metric_code
# #     type: string
# #     sql: {% condition metric_code_2 %} ${rldeav_filter2.metric_code} {% endcondition %}
# #      ;;
# #   }
# #   filter: response_label_2 {
# #     full_suggestions: yes
# #     suggest_dimension: rldeav_filter2.response_label
# #     type: string
# #     sql: {% condition response_label_2 %} ${rldeav_filter2.response_label} {% endcondition %}
# #      ;;
# #   }
# #
#
#   dimension: metric_code_1 {
#     full_suggestions: yes
#     suggest_dimension: rldeav_filter1.metric_code
#     type: string
#     sql: ${rldeav_filter1.metric_code}
#       ;;
#   }
#   dimension: response_label_1 {
#     full_suggestions: yes
#     suggest_dimension: rldeav_filter1.response_label
#     type: string
#     sql: ${rldeav_filter1.response_label}
#       ;;
#   }
#   dimension: metric_code_2 {
#     full_suggestions: yes
#     suggest_dimension: rldeav_filter2.metric_code
#     type: string
#     sql: ${rldeav_filter2.metric_code}
#       ;;
#   }
#   dimension: response_label_2 {
#     full_suggestions: yes
#     suggest_dimension: rldeav_filter2.response_label
#     type: string
#     sql:  ${rldeav_filter2.response_label}
#       ;;
#   }


  dimension: metric_code {
    hidden: yes
    type: string
    sql: ${TABLE}.metric_code ;;
  }

  dimension: respondent_serial {
    hidden: yes
    type: number
    sql: ${TABLE}.respondent_serial ;;
  }

  dimension: wm3 {
    hidden: yes
    type: number
    sql: ${TABLE}.wm3 ;;
  }

  dimension: QuotAgeRange {
    hidden: yes
    type: string
    sql: ${TABLE}.QuotAgeRange ;;
  }

  dimension: resp_gender {
    hidden: yes
    type: string
    sql: ${TABLE}.resp_gender ;;
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

  dimension: response_order {
    type: number
    hidden: yes
    sql: ${TABLE}.response_order ;;
  }

  measure: un_ct {
    type: count_distinct
    value_format_name: decimal_0
    label: "Un Weighted Count"
    sql: ${respondent_serial} ;;
  }

  measure: wt_ct {
    type: sum_distinct
    sql_distinct_key: ${respondent_serial} ;;
    value_format_name: decimal_1
    label: "Weighted Count"
    sql: ${wm3} ;;
  }
}
