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

  dimension: looker_image {
    label: "Response Label (with image)"
    group_label: "Developer Fields (not for use)"
    type: string
    sql: ${TABLE}.response_label;;
    html:
    {% if value == 'Google Pay' or value == 'Gpay' %}
         <p><img src="https://pay.google.com/about/static_kcs/images/logos/google-pay-logo.svg" height=50 width=50> {{ rendered_value }}</p>
      {% elsif value == 'Amazon Pay' %}
        <p><img src="https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/032018/untitled-1_160.png" height=50 width=50 > {{ rendered_value }}</p>
      {% elsif value == 'BHIM UPI' or value == 'BHIM / UPI' %}
        <p><img src="https://www.bhimupi.org.in/sites/default/files/Bhim-UPI_1.png" height=50 width=50> {{ rendered_value }}</p>
      {% else %}
        <p><img src="https://logo-core.clearbit.com/{{response_label}}.com" height=30 width=30 /> {{ rendered_value }}</p>
      {% endif %} ;;
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
