view: rldflat {
  label: "Demographics"
  derived_table: {
    datagroup_trigger: ipsosna_v7_default_datagroup
    partition_keys: ["dummydate"]
    cluster_keys: ["IN01SG","IN02REGION1"]
    sql:
    SELECT respondent_serial,
    wm3,
    wm3_comp_incomp,
    IN01SG,
    (SELECT DISTINCT response_label FROM `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDResponses` resp
    INNER JOIN `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDMetrics` metric ON resp.metricid= metric.metricid
    WHERE metric_code = 'IN01SG' AND resp.response_code = flat.IN01SG) AS IN01_SG_Label,
    IN02REGION1,
    (SELECT DISTINCT response_label FROM `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDResponses` resp
    INNER JOIN `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDMetrics` metric ON resp.metricid= metric.metricid
    WHERE metric_code = 'IN02REGION1' AND resp.response_code = flat.IN02REGION1) AS IN02REGION1_Label,
    IN02STDREGION,
    (SELECT DISTINCT response_label FROM `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDResponses` resp
    INNER JOIN `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDMetrics` metric ON resp.metricid= metric.metricid
    WHERE metric_code = 'IN02STDREGION' AND resp.response_code = flat.IN02STDREGION) AS IN02STDREGION_Label,
    QSMARTPHONE_USAGE,
    (SELECT DISTINCT response_label FROM `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDResponses` resp
    INNER JOIN `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDMetrics` metric ON resp.metricid= metric.metricid
    WHERE metric_code = 'QSMARTPHONE_USAGE' AND resp.response_code = flat.QSMARTPHONE_USAGE) AS QSMARTPHONE_USAGE_Label,
    QUOTAGERANGE,
    (SELECT DISTINCT response_label FROM `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDResponses` resp
    INNER JOIN `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDMetrics` metric ON resp.metricid= metric.metricid
    WHERE metric_code = 'QUOTAGERANGE' AND resp.response_code = flat.QUOTAGERANGE) AS QUOTAGERANGE_Label,
    resp_age,
    (SELECT DISTINCT response_label FROM `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDResponses` resp
    INNER JOIN `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDMetrics` metric ON resp.metricid= metric.metricid
    WHERE metric_code = 'resp_age' AND resp.response_code = flat.resp_age) AS resp_age_Label,
    resp_gender,
    (SELECT DISTINCT response_label FROM `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDResponses` resp
    INNER JOIN `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDMetrics` metric ON resp.metricid= metric.metricid
    WHERE metric_code = 'resp_gender' AND resp.response_code = flat.resp_gender) AS resp_gender_Label,
    WaveSID,
    (SELECT DISTINCT response_label FROM `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDResponses` resp
    INNER JOIN `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDMetrics` metric ON resp.metricid= metric.metricid
    WHERE metric_code = 'WaveSID' AND resp.response_code = flat.WaveSID) AS WaveSID_Label,
    cast('2000-01-01' as date) as dummydate
    FROM `mgcp-1192365-ipsos-gbht-srf617.GPay.RLDflat` flat ;;
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

  dimension: respondent_serial {
    hidden: yes
    group_label: "Demographic Fields"
    primary_key: yes
    type: number
    sql: ${TABLE}.respondent_serial ;;
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

  dimension: header_title {
    label: "Title USAT"
    group_label: "Developer Fields (not for use)"
    type: string
    sql: ${wave_sid_label} ;;
    html:
    <h1 style="color: black; font-size:250%; line-height: 38px; height:auto; text-align:center; font-family: Arial, Helvetica, sans-serif;">Ipsos Trends: USAT</h1>
    <br>
    </br>
    <h2 style="color: dimgrey; font-size:100%; line-height: 20px; height:auto; text-align:center;font-family: Arial, Helvetica, sans-serif;">Google Pay Tracking India Report - {{value}}</h2>
    ;;
  }

# <font color="#282828" size="1"><center>Ipsos Trends: USAT</center></font>
# <font color="#696969" size="3"><center>Google Pay Tracking India Report - {{value}} </center></font>
# <p style="color: black; font-size:100%; text-align:center">Google Pay Tracking India Report - {{value}}</p>

  dimension: header_title_1 {
    label: "Title Trust"
    group_label: "Developer Fields (not for use)"
    type: string
    sql: ${wave_sid_label} ;;
    html:
    <h1>
    <p style="color: black; font-size:225%;height:auto; text-align:center">Ipsos Trends: Trust</p>
    </h1>
    <p style="color: dimgrey; font-size:100%;height:auto; text-align:center">Google Pay Tracking India Report - {{value}}</p>
    ;;
  }

  dimension: header_title_2 {
    label: "Title Feature Awareness"
    group_label: "Developer Fields (not for use)"
    type: string
    sql: ${wave_sid_label} ;;
    html:
    <h1>
    <p style="color: black; font-size:200%; text-align:center">Ipsos Trends: Feature Awareness - Places to Pay</p>
    </h1>
    <p style="color: dimgrey; font-size:125%; text-align:center">Google Pay Tracking India Report - {{value}}</p>
    ;;
  }

  dimension: header_title_3 {
    label: "Title Staple Attributes"
    group_label: "Developer Fields (not for use)"
    type: string
    sql: ${wave_sid_label} ;;
    html:
    <h1>
    <p style="color: black; font-size:200%; text-align:center">Staples: Attributes</p>
    </h1>
    <p style="color: dimgrey; font-size:125%; text-align:center">Google Pay Tracking India Report - {{value}}</p>
    ;;
  }

  dimension: header_title_4 {
    label: "Title Marketing Funnel"
    group_label: "Developer Fields (not for use)"
    type: string
    sql: ${wave_sid_label} ;;
    html:
    <h1>
    <p style="color: black; font-size:200%; text-align:center">Ipsos Marketing Funnel Chart - Google Pay vs Others</p>
    </h1>
    <p style="color: dimgrey; font-size:125%; text-align:center">Google Pay Tracking India Report - {{value}}</p>
    ;;
  }

  dimension: header_title_5 {
    label: "Title Barriers"
    group_label: "Developer Fields (not for use)"
    type: string
    sql: ${wave_sid_label} ;;
    html:
    <h1>
    <p style="color: black; font-size:200%; text-align:center">Staples: Barriers and Motivations</p>
    </h1>
    <p style="color: dimgrey; font-size:125%; text-align:center">Google Pay Tracking India Report - {{value}}</p>
    ;;
  }

  dimension: header_title_6 {
    label: "Title Features Trend"
    group_label: "Developer Fields (not for use)"
    type: string
    sql: ${wave_sid_label} ;;
    html:
    <h1>
    <p style="color: black; font-size:200%; text-align:center">Staples: Feature Trends</p>
    </h1>
    <p style="color: dimgrey; font-size:125%; text-align:center">Google Pay Tracking India Report - {{value}}</p>
    ;;
  }

  dimension: header_title_7 {
    label: "Title Usage Personality"
    group_label: "Developer Fields (not for use)"
    type: string
    sql: ${wave_sid_label} ;;
    html:
    <h1>
    <p style="color: black; font-size:200%; text-align:center">Staples: Usage & Personality</p>
    </h1>
    <p style="color: dimgrey; font-size:125%; text-align:center">Google Pay Tracking India Report - {{value}}</p>
    ;;
  }

  dimension: header_title_8 {
    label: "Title Brand Funnel"
    group_label: "Developer Fields (not for use)"
    type: string
    sql: ${wave_sid_label} ;;
    html:
    <h1>
    <p style="color: black; font-size:200%; text-align:center">Ipsos Trends: Brand Funnel</p>
    </h1>
    <p style="color: dimgrey; font-size:125%; text-align:center">Google Pay Tracking India Report - {{value}}</p>
    ;;
  }

  dimension: header_title_9 {
    label: "Title Top Metrics"
    group_label: "Developer Fields (not for use)"
    type: string
    sql: ${wave_sid_label} ;;
    html:
    <h1 style="color: black; font-size:250%; text-align:center; font-family: Arial, Helvetica, sans-serif;">Google Pay Top Metrics Health Dashboard</h1>
    <br>
    </br>
    <h2 style="color: dimgrey; font-size:100%; text-align:center;font-family: Arial, Helvetica, sans-serif;">Google Pay Tracking India Report - {{value}}</h2>
    ;;
  }
  # <h1>
  # <p style="color: black; font-size:200%; text-align:center">Google Pay Top Metrics Health Dashboard</p>
  #   </h1>
  #   <p style="color: dimgrey; font-size:125%; text-align:center">Google Pay Tracking India Report - {{value}}</p>

  dimension: wave_sid_percent_chart {
    label: "Wave (custom)"
    group_label: "Developer Fields (not for use)"
    type: string
#     order_by_field: wave_date
    sql: ${TABLE}.WaveSID_Label ;;
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

  dimension: title {
    type: string
    sql: ${wave_sid_label};;
    html: <h1>Sales on {{ rendered_value }}</h1> ;;
  }

  dimension: wm3 {
#     hidden: yes
    type: number
    sql: ${TABLE}.wm3 ;;
  }

  measure: wtct {
    group_label: "Weight Metrics"
    description: "The weighted count of respondents"
    label: "Weighted Count"
    type: sum
    sql: NULLIF(${wm3},0) ;;
    value_format_name: decimal_0
    drill_fields: [detail*]
  }
  measure: eff_base {
    group_label: "Weight Metrics"
    label: "Effective Base"
    type: number
    sql: (SUM(${wm3})*SUM(${wm3}))/NULLIF(SUM(${wm3}*${wm3}),0);;
    value_format_name: decimal_2
#     drill_fields: [detail*]
  }

  measure: sum_wtct_subtotal {
    type: number
    hidden: yes
    sql:  sum(${wtct}) OVER ( PARTITION BY
          -- all rldeav fields
              {% if rldeav.metric_id._is_selected %} ${rldeav.metric_id} , {% endif %}
              --{% if rldeav.metric_code._is_selected %} ${rldeav.metric_code} , {% endif %}
              {% if rldeav.metric_label._is_selected %} ${rldeav.metric_label} , {% endif %}

          -- all rldflat fields
              {% if attribute_selector1._parameter_value == 'IN01_SG_Label' and attribute_selector1_dim._is_selected %}
                      ${in01_sg_label} ,
              {% elsif attribute_selector2._parameter_value == 'IN01_SG_Label' and attribute_selector2_dim._is_selected %}
                      ${in01_sg_label} ,
              {% elsif in01_sg_label._is_selected %}
                      ${in01_sg_label} ,
              {% endif %}

              {% if attribute_selector1._parameter_value == 'IN02REGION1_Label' and attribute_selector1_dim._is_selected %}
                      ${in02_region1_label} ,
              {% elsif attribute_selector2._parameter_value == 'IN02REGION1_Label' and attribute_selector2_dim._is_selected %}
                      ${in02_region1_label} ,
              {% elsif in02_region1_label._is_selected %}
                      ${in02_region1_label} ,
              {% endif %}

              {% if attribute_selector1._parameter_value == 'IN02STDREGION_Label' and attribute_selector1_dim._is_selected %}
                      ${in02_stdregion_label} ,
              {% elsif attribute_selector2._parameter_value == 'IN02STDREGION_Label' and attribute_selector2_dim._is_selected %}
                      ${in02_stdregion_label} ,
              {% elsif in02_stdregion_label._is_selected %}
                      ${in02_stdregion_label} ,
              {% endif %}

              {% if attribute_selector1._parameter_value == 'resp_age_Label' and attribute_selector1_dim._is_selected %}
                      ${resp_age_label} ,
              {% elsif attribute_selector2._parameter_value == 'resp_age_Label' and attribute_selector2_dim._is_selected %}
                      ${resp_age_label} ,
              {% elsif resp_age_label._is_selected %}
                      ${resp_age_label} ,
              {% endif %}

              {% if attribute_selector1._parameter_value == 'resp_gender_Label' and attribute_selector1_dim._is_selected %}
                      ${resp_gender_label} ,
              {% elsif attribute_selector2._parameter_value == 'resp_gender_Label' and attribute_selector2_dim._is_selected %}
                      ${resp_gender_label} ,
              {% elsif resp_gender_label._is_selected %}
                      ${resp_gender_label} ,
              {% endif %}

              {% if attribute_selector1._parameter_value == 'QSMARTPHONE_USAGE_Label' and attribute_selector1_dim._is_selected %}
                      ${qsmartphone_usage_label} ,
              {% elsif attribute_selector2._parameter_value == 'QSMARTPHONE_USAGE_Label' and attribute_selector2_dim._is_selected %}
                      ${qsmartphone_usage_label} ,
              {% elsif qsmartphone_usage_label._is_selected %}
                      ${qsmartphone_usage_label} ,
              {% endif %}

              {% if attribute_selector1._parameter_value == 'QUOTAGERANGE_Label' and attribute_selector1_dim._is_selected %}
                      ${quotagerange_label} ,
              {% elsif attribute_selector2._parameter_value == 'QUOTAGERANGE_Label' and attribute_selector2_dim._is_selected %}
                      ${quotagerange_label} ,
              {% elsif quotagerange_label._is_selected %}
                      ${quotagerange_label} ,
              {% endif %}

              {% if attribute_selector1._parameter_value == 'WaveSID_Label' and attribute_selector1_dim._is_selected %}
                      ${wave_sid_label} ,
              {% elsif attribute_selector2._parameter_value == 'WaveSID_Label' and attribute_selector2_dim._is_selected %}
                      ${wave_sid_label} ,
              {% elsif wave_sid_label._is_selected %}
                      ${wave_sid_label} ,
              {% endif %}

              {% if attribute_selector1._parameter_value == 'wave_date' and attribute_selector1_dim._is_selected %}
                      ${wave_date} ,
              {% elsif attribute_selector2._parameter_value == 'wave_date' and attribute_selector2_dim._is_selected %}
                      ${wave_date} ,
              {% elsif wave_date._is_selected %}
                      ${wave_date} ,
              {% endif %}
              1)
              ;;
  }

  measure: percent_weight {
    description: "Percent of Base"
    type: number
    group_label: "Weight Metrics"
    label: "Percent of Base"
    sql: ${wtct}/NULLIF(${sum_wtct_subtotal},0) ;;
    drill_fields: [detail*]
    value_format_name: percent_0
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

set: detail {
  fields: [in01_sg_label,in02_region1_label,in02_stdregion_label,resp_age_label,resp_gender_label,wtct]
}

  dimension: wm3_comp_incomp {
    type: number
    hidden: yes
    sql: ${TABLE}.wm3_comp_incomp ;;
  }
}
