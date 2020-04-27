view: rldflat {
  label: "Demographics"
  sql_table_name: `GPay.RLDflat`
    ;;

#Defining parameters for Dynamic column selection in Cross tab charts
  parameter: attribute_selector1 {
    label: "Banner Selector 1"
    description: "Banner selector for crosstabs"
    type: unquoted

    allowed_value: {
      label: "Age"
      value: "resp_age"
    }

    allowed_value: {
      label: "Gender"
      value: "resp_gender"
    }

    allowed_value: {
      label: "Wave"
      value: "wave_sid"
    }

    allowed_value: {
      label: "Smartphone Usage"
      value: "qsmartphone_usage"
    }

    allowed_value: {
      label: "Quota Range"
      value: "quotagerange"
    }

    allowed_value: {
      label: "in01_sg"
      value: "in01_sg"
    }

    allowed_value: {
      label: "Region 1"
      value: "in02_region1"
    }

    allowed_value: {
      label: "Region 2"
      value: "in02_stdregion"
    }
  }

  parameter: attribute_selector2 {
    description: "Banner selector for crosstabs"
    label: "Banner Selector 2"
    type: unquoted

    allowed_value: {
      label: "Age"
      value: "resp_age"
    }

    allowed_value: {
      label: "Gender"
      value: "resp_gender"
    }

    allowed_value: {
      label: "Wave"
      value: "wave_sid"
    }

    allowed_value: {
      label: "Smartphone Usage"
      value: "qsmartphone_usage"
    }

    allowed_value: {
      label: "Quota Range"
      value: "quotagerange"
    }

    allowed_value: {
      label: "in01_sg"
      value: "in01_sg"
    }

    allowed_value: {
      label: "Region 1"
      value: "in02_region1"
    }

    allowed_value: {
      label: "Region 2"
      value: "in02_stdregion"
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
    {% if attribute_selector1._parameter_value == 'wave_sid' %}
      ${wave_sid}
    {% else %}
      ${attribute_selector1_dim}
    {% endif %};;
  }

  dimension: attribute_selector2_sort {
    hidden: yes
    sql:
    {% if attribute_selector2._parameter_value == 'wave_sid' %}
      ${wave_sid}
    {% else %}
      ${attribute_selector2_dim}
    {% endif %};;
  }

  dimension: in01_sg {
    group_label: "Demographic Fields"
    type: string
    sql: ${TABLE}.IN01SG ;;
  }

  dimension: in02_region1 {
    group_label: "Demographic Fields"
    type: string
    sql: ${TABLE}.IN02REGION1 ;;
  }

  dimension: in02_stdregion {
    group_label: "Demographic Fields"
    type: string
    sql: ${TABLE}.IN02STDREGION ;;
  }

  dimension: qsmartphone_usage {
    group_label: "Demographic Fields"
    type: string
    sql: ${TABLE}.QSMARTPHONE_USAGE ;;
  }

  dimension: quotagerange {
    group_label: "Demographic Fields"
    type: string
    sql: ${TABLE}.QUOTAGERANGE ;;
  }

  dimension: resp_age {
    group_label: "Demographic Fields"
    type: string
    sql: ${TABLE}.resp_age ;;
  }

  dimension: resp_gender {
    group_label: "Demographic Fields"
    type: string
    sql: ${TABLE}.resp_gender ;;
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
    sql: ${TABLE}.WaveSID ;;
  }

  dimension: wm3 {
    hidden: yes
    type: number
    sql: ${TABLE}.wm3 ;;
  }

  measure: wtct {
    group_label: "Weight Metrics"
    description: "The weighted count of respondents"
    label: "Weighted Count"
    type: sum
    sql: ${wm3} ;;
    value_format_name: decimal_2
    drill_fields: [detail*]
  }

  measure: sum_wtct_subtotal {
    type: number
    hidden: yes
    sql:  sum(${wtct}) OVER ( PARTITION BY
          -- all rldmetrics fields
              {% if rldmetrics.metric_id._is_selected %} ${rldmetrics.metric_id} , {% endif %}
              {% if rldmetrics.metric_code._is_selected %} ${rldmetrics.metric_code} , {% endif %}
              {% if rldmetrics.metric_label._is_selected %} ${rldmetrics.metric_label} , {% endif %}

          -- all rldflat fields
              {% if attribute_selector1._parameter_value == 'in01_sg' and attribute_selector1_dim._is_selected %}
                      ${in01_sg} ,
              {% elsif attribute_selector2._parameter_value == 'in01_sg' and attribute_selector2_dim._is_selected %}
                      ${in01_sg} ,
              {% elsif in01_sg._is_selected %}
                      ${in01_sg} ,
              {% endif %}

              {% if attribute_selector1._parameter_value == 'in02_region1' and attribute_selector1_dim._is_selected %}
                      ${in02_region1} ,
              {% elsif attribute_selector2._parameter_value == 'in02_region1' and attribute_selector2_dim._is_selected %}
                      ${in02_region1} ,
              {% elsif in02_region1._is_selected %}
                      ${in02_region1} ,
              {% endif %}

              {% if attribute_selector1._parameter_value == 'in02_stdregion' and attribute_selector1_dim._is_selected %}
                      ${in02_stdregion} ,
              {% elsif attribute_selector2._parameter_value == 'in02_stdregion' and attribute_selector2_dim._is_selected %}
                      ${in02_stdregion} ,
              {% elsif in02_stdregion._is_selected %}
                      ${in02_stdregion} ,
              {% endif %}

              {% if attribute_selector1._parameter_value == 'resp_age' and attribute_selector1_dim._is_selected %}
                      ${resp_age} ,
              {% elsif attribute_selector2._parameter_value == 'resp_age' and attribute_selector2_dim._is_selected %}
                      ${resp_age} ,
              {% elsif resp_age._is_selected %}
                      ${resp_age} ,
              {% endif %}

              {% if attribute_selector1._parameter_value == 'resp_gender' and attribute_selector1_dim._is_selected %}
                      ${resp_gender} ,
              {% elsif attribute_selector2._parameter_value == 'resp_gender' and attribute_selector2_dim._is_selected %}
                      ${resp_gender} ,
              {% elsif resp_gender._is_selected %}
                      ${resp_gender} ,
              {% endif %}

              {% if attribute_selector1._parameter_value == 'qsmartphone_usage' and attribute_selector1_dim._is_selected %}
                      ${qsmartphone_usage} ,
              {% elsif attribute_selector2._parameter_value == 'qsmartphone_usage' and attribute_selector2_dim._is_selected %}
                      ${qsmartphone_usage} ,
              {% elsif qsmartphone_usage._is_selected %}
                      ${qsmartphone_usage} ,
              {% endif %}

              {% if attribute_selector1._parameter_value == 'quotagerange' and attribute_selector1_dim._is_selected %}
                      ${quotagerange} ,
              {% elsif attribute_selector2._parameter_value == 'quotagerange' and attribute_selector2_dim._is_selected %}
                      ${quotagerange} ,
              {% elsif quotagerange._is_selected %}
                      ${quotagerange} ,
              {% endif %}

              {% if attribute_selector1._parameter_value == 'wave_sid' and attribute_selector1_dim._is_selected %}
                      ${wave_sid} ,
              {% elsif attribute_selector2._parameter_value == 'wave_sid' and attribute_selector2_dim._is_selected %}
                      ${wave_sid} ,
              {% elsif wave_sid._is_selected %}
                      ${wave_sid} ,
              {% endif %}

              1)
              ;;
  }

  measure: percent_weight {
    type: number
    group_label: "Weight Metrics"
    label: "Percent of Base"
    sql: ${wtct}/${sum_wtct_subtotal} ;;
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
#     hidden: yes
  label: "Significance"
  group_label: "Parameters"
  type: string
  sql: {% parameter significance_dropdown  %};;
  #
}

parameter: confidence_interval {
  label: "Confidence Interval Parameter"
  description: "Choose Confidence % for crosstabs"
#     hidden: yes
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
#     hidden: yes
  type: string
  sql:  {% parameter confidence_interval  %};;
}

set: detail {
  fields: [in01_sg,in02_region1,in02_stdregion,resp_age,resp_gender,respondent_serial,wtct]
}

  dimension: wm3_comp_incomp {
    type: number
    hidden: yes
    sql: ${TABLE}.wm3_comp_incomp ;;
  }
}
