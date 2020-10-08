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
    sql: ${TABLE}.response_label
     ;;
    html: <p style="font-size:90%;word-wrap:break-word;text-align:right;justify-content: center">{{ rendered_value }}</p> ;;
  }

  dimension: response_label_custom {
    group_label: "Developer Fields (not for use)"
    type: string
    sql: case ${response_label}
                WHEN 'Extremely satisfied' THEN 'Extremely / Moderately satisfied'
                WHEN 'Moderately satisfied' THEN 'Extremely / Moderately satisfied'
                WHEN 'More than once a day' THEN 'Use Google Pay at least once per day'
                WHEN 'About once a day' THEN 'Use Google Pay at least once per day'
                WHEN 'A few times a week' THEN 'Use Google Pay at least once per week'
                WHEN 'About once a week' THEN 'Use Google Pay at least once per week'
                WHEN 'A few times a month' THEN 'Use Google Pay monthly or less often'
                WHEN 'Once a month or less often' THEN 'Use Google Pay monthly or less often'
                ELSE ${response_label}
                END;;
  }

  measure: rank_order {
    # hidden: yes
    type: number
    description: "Used for Sorting Responses"
    group_label: "Developer Fields (not for use)"
    sql: RANK() OVER (ORDER BY sum(rldflat.wm3) DESC) ;;
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

  dimension: response_label_staples {
    group_label: "Developer Fields (not for use)"
    type: number
    sql:
    CASE ${response_label}
    WHEN 'Google Pay' THEN 1
    WHEN 'Paytm' THEN 2
    WHEN 'PhonePe' THEN 3
    WHEN 'PayPal' THEN 4
    WHEN 'Amazon Pay' THEN 5
    WHEN 'Mobikwik' THEN 6
    WHEN 'BHIM / UPI' THEN 7
    WHEN 'BHIM UPI' THEN 7
    WHEN 'Airtel Payments Bank' THEN 8
    WHEN 'HDFC PayZapp' THEN 9
    WHEN 'WhatsApp Pay' THEN 10
    WHEN 'Jio' THEN 11
    ELSE
    0
    END
    ;;
  }

  dimension: response_label_pbac {
    group_label: "Developer Fields (not for use)"
    type: number
    sql:
    CASE ${response_label}
    WHEN 'Google Pay' THEN 1
    WHEN 'Paytm' THEN 2
    WHEN 'PhonePe' THEN 3
    WHEN 'PayPal' THEN 4
    WHEN 'Amazon Pay' THEN 5
    WHEN 'BHIM / UPI' THEN 6
    WHEN 'BHIM UPI' THEN 6
    WHEN 'Tez' THEN 7
    WHEN 'Airtel Payments Bank' THEN 8
    WHEN 'HDFC PayZapp' THEN 9
    WHEN 'WhatsApp Pay' THEN 10
    WHEN 'Mobikwik' THEN 11
    WHEN 'Jio' THEN 12
    WHEN 'JioMoney' THEN 12
    ELSE
    0
    END
    ;;
  }

#   dimension: resp_custom_order {
#     group_label: "Developer Fields (not for use)"
#     type: number
#     sql: row_number() OVER (${response_label},1)
#       ;;
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
    group_label: "Developer Fields (not for use)"
    type: number
#     hidden: yes
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
