include: "counts_v2.view.lkml"
view: bases_v2 {
  derived_table: {
    datagroup_trigger: ipsosna_v7_default_datagroup
    partition_keys: ["dummydate"]
    cluster_keys: ["metricID","resp_gender","WaveSID"]
    sql: SELECT v.metricID, v.metric_code, v.metric_label, v.metric_order,v.respondent_serial,
        f.wm3,
        (SELECT DISTINCT response_label FROM `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDResponses` resp
        INNER JOIN `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDMetrics` metric ON resp.metricid= metric.metricid
        WHERE metric_code = 'IN01SG' AND resp.response_code = f.IN01SG) AS IN01_SG_Label,
        f.IN02REGION1,
        (SELECT DISTINCT response_label FROM `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDResponses` resp
        INNER JOIN `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDMetrics` metric ON resp.metricid= metric.metricid
        WHERE metric_code = 'IN02REGION1' AND resp.response_code = f.IN02REGION1) AS IN02REGION1_Label,
        f.IN02STDREGION,
        (SELECT DISTINCT response_label FROM `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDResponses` resp
        INNER JOIN `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDMetrics` metric ON resp.metricid= metric.metricid
        WHERE metric_code = 'IN02STDREGION' AND resp.response_code = f.IN02STDREGION) AS IN02STDREGION_Label,
        f.QSMARTPHONE_USAGE,
        (SELECT DISTINCT response_label FROM `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDResponses` resp
        INNER JOIN `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDMetrics` metric ON resp.metricid= metric.metricid
        WHERE metric_code = 'QSMARTPHONE_USAGE' AND resp.response_code = f.QSMARTPHONE_USAGE) AS QSMARTPHONE_USAGE_Label,
        f.QUOTAGERANGE,
        (SELECT DISTINCT response_label FROM `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDResponses` resp
        INNER JOIN `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDMetrics` metric ON resp.metricid= metric.metricid
        WHERE metric_code = 'QUOTAGERANGE' AND resp.response_code = f.QUOTAGERANGE) AS QUOTAGERANGE_Label,
        f.resp_age,
        (SELECT DISTINCT response_label FROM `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDResponses` resp
        INNER JOIN `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDMetrics` metric ON resp.metricid= metric.metricid
        WHERE metric_code = 'resp_age' AND resp.response_code = f.resp_age) AS resp_age_Label,
        f.resp_gender,
        (SELECT DISTINCT response_label FROM `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDResponses` resp
        INNER JOIN `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDMetrics` metric ON resp.metricid= metric.metricid
        WHERE metric_code = 'resp_gender' AND resp.response_code = f.resp_gender) AS resp_gender_Label,
        f.WaveSID,
        (SELECT DISTINCT response_label FROM `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDResponses` resp
        INNER JOIN `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDMetrics` metric ON resp.metricid= metric.metricid
        WHERE metric_code = 'WaveSID' AND resp.response_code = f.WaveSID) AS WaveSID_Label,
        cast('2000-01-01' as date) as dummydate
        FROM (SELECT DISTINCT respondent_serial, metricID, metric_code, metric_label, metric_order, vtype FROM GPay.RLDeav) v
        LEFT OUTER JOIN GPay.RLDflat f ON f.respondent_serial=v.respondent_serial
        WHERE v.vtype IN ('single','multi')
        ;;
  }

  dimension: wm3 {
    hidden: yes
    type: number
    sql: ${TABLE}.wm3 ;;
  }

  dimension: in01_sg {
    group_label: "Demographic Fields"
    type: string
    hidden: yes
    sql: ${TABLE}.IN01SG ;;
  }

  dimension: in01_sg_label {
    label: "Sg Zone"
    group_label: "Demographic Fields"
    type: string
    sql: ${TABLE}.IN01_SG_Label ;;
  }

  dimension: in02_region1 {
    group_label: "Demographic Fields"
    type: string
    hidden: yes
    sql: ${TABLE}.IN02REGION1 ;;
  }

  dimension: in02_region1_label {
    label: "Region"
    group_label: "Demographic Fields"
    type: string
    sql: ${TABLE}.IN02REGION1_Label ;;
  }

  dimension: in02_stdregion {
    group_label: "Demographic Fields"
    type: string
    hidden: yes
    sql: ${TABLE}.IN02STDREGION ;;
  }

  dimension: in02_stdregion_label {
    label: "STD Region"
    group_label: "Demographic Fields"
    type: string
    sql: ${TABLE}.IN02STDREGION_Label ;;
  }

  dimension: qsmartphone_usage {
    group_label: "Demographic Fields"
    type: string
    hidden: yes
    sql: ${TABLE}.QSMARTPHONE_USAGE ;;
  }

  dimension: qsmartphone_usage_label {
    label: "Smartphone Usage"
    group_label: "Demographic Fields"
    type: string
    sql: ${TABLE}.QSMARTPHONE_USAGE_Label ;;
  }

  dimension: quotagerange {
    group_label: "Demographic Fields"
    type: string
    hidden: yes
    sql: ${TABLE}.QUOTAGERANGE ;;
  }

  dimension: quotagerange_label {
    label: "Quota Age Range"
    group_label: "Demographic Fields"
    type: string
    sql: ${TABLE}.QUOTAGERANGE_Label ;;
  }

  dimension: resp_age {
    group_label: "Demographic Fields"
    type: string
    hidden: yes
    sql: ${TABLE}.resp_age ;;
  }

  dimension: resp_age_label {
    label: "Age"
    group_label: "Demographic Fields"
    type: string
    sql: ${TABLE}.resp_age_Label ;;
  }

  dimension: resp_gender {
    group_label: "Demographic Fields"
    type: string
    hidden: yes
    sql: ${TABLE}.resp_gender ;;
  }

  dimension: resp_gender_label {
    label: "Gender"
    group_label: "Demographic Fields"
    type: string
    sql: ${TABLE}.resp_gender_Label ;;
  }

  dimension: wave_sid {
    group_label: "Demographic Fields"
    type: string
    hidden: yes
    sql: ${TABLE}.WaveSID ;;
  }

  dimension: wave_sid_label {
    label: "Wave"
    group_label: "Demographic Fields"
    type: string
    order_by_field: wave_date
    sql: ${TABLE}.WaveSID_Label ;;
  }

  dimension: wave_sid_percent_chart {
    label: "Wave (custom)"
    group_label: "Developer Fields (not for use)"
    type: string
#     order_by_field: wave_date
    sql: ${TABLE}.WaveSID_Label;;
  }

  dimension: wave_year {
    hidden: yes
    group_label: "Demographic Fields"
    type: number
    sql: CAST(SUBSTR(${wave_sid_label},5,4) AS INT64);;
  }

  dimension: wave_month_part {
    hidden: yes
    group_label: "Demographic Fields"
    type: string
    sql: SUBSTR(${wave_sid_label},1,3);;
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
    sql: SUBSTR(${wave_sid_label},12,2);;
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
    sql: CAST(date(${wave_year},${wave_month},${wave_day}) as TIMESTAMP) ;;
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

  dimension: respondent_serial {
    hidden: yes
    group_label: "Demographic Fields"
#     primary_key: yes
    type: number
    sql: ${TABLE}.respondent_serial ;;
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

  measure: un_base {
    label: "Un Weighted Base"
    type: count_distinct
    sql: ${respondent_serial} ;;
  }

  measure: wt_base {
  type: sum_distinct
  sql_distinct_key: ${respondent_serial} ;;
  label: "Weighted Base"
  value_format_name: decimal_1
  sql: NULLIF(${wm3},0) ;;
}

measure: wt_pct {
  group_label: "Weight Metrics"
  label: "Weighted Pct"
  type: number
  value_format_name: percent_0
  sql: ${counts_v2.wt_ct}/${wt_base} ;;
}

measure: un_pct {
  group_label: "Weight Metrics"
  label: "Un Weighted Pct"
  type: number
  value_format_name: percent_0
  sql: ${counts_v2.un_ct}/${un_base} ;;
}

#Defining parameters for Dynamic column selection in Cross tab charts
  parameter: attribute_selector1 {
    label: "Banner Selector 1"
    description: "Banner selector for crosstabs"
    type: unquoted

    allowed_value: {
      label: "Age"
      value: "resp_age_Label"
    }

    allowed_value: {
      label: "Gender"
      value: "resp_gender_Label"
    }

    allowed_value: {
      label: "Wave"
      value: "WaveSID_Label"
    }

    allowed_value: {
      label: "Smartphone Usage"
      value: "QSMARTPHONE_USAGE_Label"
    }

    allowed_value: {
      label: "Quota Age Range"
      value: "QUOTAGERANGE_Label"
    }

    allowed_value: {
      label: "Sg Zone"
      value: "IN01_SG_Label"
    }

    allowed_value: {
      label: "Region"
      value: "IN02REGION1_Label"
    }

    allowed_value: {
      label: "STD Region"
      value: "IN02STDREGION_Label"
    }
  }

  parameter: attribute_selector2 {
    description: "Banner selector for crosstabs"
    label: "Banner Selector 2"
    type: unquoted

    allowed_value: {
      label: "Age"
      value: "resp_age_Label"
    }

    allowed_value: {
      label: "Gender"
      value: "resp_gender_Label"
    }

    allowed_value: {
      label: "Wave"
      value: "WaveSID_Label"
    }

    allowed_value: {
      label: "Smartphone Usage"
      value: "QSMARTPHONE_USAGE_Label"
    }

    allowed_value: {
      label: "Quota Age Range"
      value: "QUOTAGERANGE_Label"
    }

    allowed_value: {
      label: "Sg Zone"
      value: "IN01_SG_Label"
    }

    allowed_value: {
      label: "Region"
      value: "IN02REGION1_Label"
    }

    allowed_value: {
      label: "STD Region"
      value: "IN02STDREGION_Label"
    }
  }

  dimension: attribute_selector1_dim {
    group_label: "Banner Analysis"
    label: "Banner Selector 1"
    order_by_field: attribute_selector1_sort
    description: "To be used with the Banner Selector filters"
    label_from_parameter: attribute_selector1
    sql: ${TABLE}.{% parameter attribute_selector1 %};;
  }

  dimension: attribute_selector2_dim {
    group_label: "Banner Analysis"
    label: "Banner Selector 2"
    order_by_field: attribute_selector2_sort
    description: "To be used with the Banner Selector filters"
    label_from_parameter: attribute_selector2
    sql: ${TABLE}.{% parameter attribute_selector2 %};;
  }

  dimension: attribute_selector1_sort {
    hidden: yes
    sql:
    {% if attribute_selector1._parameter_value == 'WaveSID_Label' %}
      ${wave_date}
    {% else %}
      ${attribute_selector1_dim}
    {% endif %};;
  }

  dimension: attribute_selector2_sort {
    hidden: yes
    sql:
    {% if attribute_selector2._parameter_value == 'WaveSID_Label' %}
      ${wave_date}
    {% else %}
      ${attribute_selector2_dim}
    {% endif %};;
  }

  parameter: significance_dropdown {
    label: "Significance"
#     hidden: yes
    description: "Choose Significance for crosstabs"
    type: string
    allowed_value: {
      label: "Yes"
      value: "yes"
    }
    allowed_value: {
      label: "No"
      value: "no"
    }
  }

  #Significance Filter
  dimension: significance_dropdown_dim {
    label: "Significance"
    group_label: "Parameters"
    type: string
    sql: {% parameter significance_dropdown  %};;
  }

  parameter: confidence_interval {
    label: "Confidence Interval Parameter"
    description: "Choose Confidence % for crosstabs"
    type: string
    allowed_value: {
      label: "85%"
      value: "1.44"
    }
    allowed_value: {
      label: "90%"
      value: "1.65"
    }
    allowed_value: {
      label: "95%"
      value: "1.96"
    }
    allowed_value: {
      label: "99%"
      value: "2.58"
    }
  }

#Confidence Interval Filter
  dimension: confidence_interval_dim {
    label: "Confidence Interval"
    group_label: "Parameters"
    type: string
    sql:  {% parameter confidence_interval  %};;
  }


}
