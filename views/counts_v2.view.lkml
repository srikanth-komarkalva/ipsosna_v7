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
        WHERE v.vtype IN ('single','multi') ;;
  }

  dimension: metric_id {
    hidden: yes
    primary_key: yes
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

#   dimension: resp_custom_order {
#     group_label: "Developer Fields (not for use)"
#     type: number
#     sql: rownumber() group: ${response_label}
#     ;;
#   }

  dimension: looker_image {
    label: "Brand"
    group_label: "Developer Fields (not for use)"
    type: string
    sql: ${TABLE}.response_label;;
    html:
    {% if value == 'Google Pay' or value == 'Gpay' %}
         <p><img src="https://pay.google.com/about/static_kcs/images/logos/google-pay-logo.svg" height=50 width=50></p>
      {% elsif value == 'Amazon Pay' %}
        <p><img src="https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/032018/untitled-1_160.png" height=50 width=50 ></p>
      {% elsif value == 'BHIM UPI' or value == 'BHIM / UPI' %}
        <p><img src="https://sutrashome.files.wordpress.com/2019/04/bhim.jpg" height=30 width=50></p>
      {% elsif value == 'Samsung Pay' %}
        <p><img src="https://securecdn.pymnts.com/wp-content/uploads/2020/01/Screen-Shot-2020-01-31-at-3.54.58-PM.png" height=30 width=50></p>
      {% elsif value == 'Mastercard Masterpass' %}
        <p><img src="https://www.pymnts.com/wp-content/uploads/2016/09/Mastercard-Digital-.png" height=30 width=50></p>
      {% elsif value == 'Visa Checkout' %}
        <p><img src="https://www.merchant-accounts.ca/pics/VisaCheckoutLogo.jpg" height=30 width=50></p>
      {% elsif value == 'Airtel Payments Bank' %}
        <p><img src="https://upload.wikimedia.org/wikipedia/commons/9/9c/Airtel_payments_bank_logo.jpg" height=30 width=50></p>
      {% elsif value == 'HDFC PayZapp' %}
        <p><img src="https://s3.amazonaws.com/zaubatrademarks/49a573c7-b5d5-4edc-8f5e-7791dba1c3f8.png" height=30 width=50></p>
      {% elsif value == 'WhatsApp Pay' %}
        <p><img src="https://upload.wikimedia.org/wikipedia/commons/6/6b/WhatsApp.svg" height=30 width=50></p>
      {% elsif value == 'JioMoney' %}
        <p><img src="https://avatars0.githubusercontent.com/u/30654090?s=460&u=4992d663f76ee28a85b20f447b83c2856d06bad6&v=4" height=50 width=50></p>
      {% elsif value == 'Tez' %}
        <p><img src="https://icon2.cleanpng.com/20180328/zze/kisspng-tez-unified-payments-interface-google-apps-5abb75dc86eca2.9888044115222348445527.jpg" height=30 width=30></p>
      {% else %}
        <p><img src="https://logo-core.clearbit.com/{{response_label}}.com" height=30 width=50 /></p>
      {% endif %} ;;
  }

  dimension: response_order {
    type: number
    group_label: "Developer Fields (not for use)"
#     hidden: yes
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