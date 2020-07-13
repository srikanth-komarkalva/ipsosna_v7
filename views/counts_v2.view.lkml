include: "bases_v2.view.lkml"
include: "rldeav_filter1.view.lkml"
include: "rldeav_filter2.view.lkml"
include: "rldeav_filter3.view.lkml"
view: counts_v2 {
  derived_table: {
    datagroup_trigger: ipsosna_v7_default_datagroup
    partition_keys: ["dummydate"]
    cluster_keys: ["metricID","response_label"]
    sql: SELECT v.metricID, v.metric_code, v.response_code, v.response_label,v.response_order,v.respondent_serial,
        f.wm3,f.QuotAgeRange,f.resp_gender,
        cast('2000-01-01' as date) as dummydate FROM GPay.RLDeav v
        LEFT OUTER JOIN GPay.RLDflat f ON f.respondent_serial=v.respondent_serial
        WHERE v.vtype IN ('single','multi')

        ;;
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
    sql: ${TABLE}.response_label
     ;;
    html: <p style="font-size:90%;word-wrap:break-word;justify-content: center;text-align:right">{{ rendered_value }}</p> ;;
  }

  dimension: response_label_order {
    group_label: "Developer Fields (not for use)"
    type: number
    sql:
    CASE ${response_label}
    WHEN 'Not sure' THEN 12
    WHEN 'Pay at a local store (including QR code)' THEN 6
    WHEN 'Pay on apps and/or websites (e.g. food delivery, cabs/taxi, movies, travel)' THEN 7
    WHEN 'Earn rewards, scratch cards or discounts' THEN 4
    WHEN 'Pay for daily transportation (e.g. bus, auto, metro)' THEN 9
    WHEN 'Transfer money to other people (e.g. splitting a bill)' THEN 3
    WHEN 'Pay monthly bills (e.g. electricity, DTH, gas, water, FASTag)' THEN 2
    WHEN 'Recharge their mobile' THEN 1
    WHEN 'Book train tickets on IRCTC' THEN 8
    WHEN 'Buy and sell gold' THEN 11
    WHEN 'Pay to any bank account, even those not with the same app' THEN 5
    WHEN 'Pay for petrol/diesel' THEN 10
    END
    ;;
  }

  dimension: looker_image {
    label: "Response Label Image"
    group_label: "Developer Fields (not for use)"
    type: string
    sql: ${TABLE}.response_label;;
    html:
    {% if value == 'Google Pay' or value == 'Gpay' %}
         <p><img src="https://pay.google.com/about/static_kcs/images/logos/google-pay-logo.svg" height=50 width=50></p>
      {% elsif value == 'Amazon Pay' %}
        <p><img src="https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/032018/untitled-1_160.png" height=50 width=50 ></p>
      {% elsif value == 'BHIM UPI' or value == 'BHIM / UPI' %}
        <p><img src="https://www.bhimupi.org.in/sites/default/files/Bhim-UPI_1.png" height=50 width=50></p>
      {% else %}
        <p><img src="https://logo-core.clearbit.com/{{response_label}}.com" height=30 width=30 /></p>
      {% endif %} ;;
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
