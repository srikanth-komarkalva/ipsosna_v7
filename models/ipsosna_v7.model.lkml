connection: "gpay"

# include all the views
include: "/views/**/*.view"

datagroup: ipsosna_v7_default_datagroup {
  sql_trigger: SELECT TIMESTAMP_TRUNC(CURRENT_TIMESTAMP(),hour) ;;
  max_cache_age: "24 hours"
}

persist_with: ipsosna_v7_default_datagroup

explore: gpay_crosstab {
  label: "Crosstab for Google Pay"
  view_name: rldeav
  view_label: "Crosstab for Google Pay"
  sql_always_where: ${rldeav.vtype} IN ('single','multi');;

  join: rldresponses {
    view_label: "Crosstab for Google Pay"
    relationship: many_to_one
    type: left_outer
    sql_on: ${rldresponses.response_id} = ${rldeav.response_id} ;;
  }

  join: rldmetrics {
    view_label: "Crosstab for Google Pay"
    relationship: many_to_one
    type: left_outer
    sql_on: ${rldmetrics.metric_id} = ${rldeav.metric_id} ;;
  }

  join: rldflat {
    view_label: "Crosstab for Google Pay"
    relationship: one_to_one
    type: inner
    sql_on: ${rldflat.respondent_serial} = ${rldeav.respondent_serial} ;;
  }
}
