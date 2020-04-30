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
  view_name: rldflat
  view_label: "Crosstab for Google Pay"
  sql_always_where: ${rldeav.vtype} IN ('single','multi');;

  join: rldeav {
    view_label: "Crosstab for Google Pay"
    relationship: many_to_one
    type: left_outer
    sql_on: ${rldeav.respondent_serial} = ${rldflat.respondent_serial} ;;
  }

  join: rldeav_filter1 {
    view_label: "Crosstab for Google Pay"
    relationship: one_to_one
    type: inner
    sql_on: ${rldeav_filter1.respondent_serial} = ${rldflat.respondent_serial} ;;
  }

  join: rldeav_filter2 {
    view_label: "Crosstab for Google Pay"
    relationship: one_to_one
    type: inner
    sql_on: ${rldeav_filter2.respondent_serial} = ${rldflat.respondent_serial} ;;
  }

  join: rldeav_filter3 {
    view_label: "Crosstab for Google Pay"
    relationship: one_to_one
    type: inner
    sql_on: ${rldeav_filter3.respondent_serial} = ${rldflat.respondent_serial} ;;
  }
}
