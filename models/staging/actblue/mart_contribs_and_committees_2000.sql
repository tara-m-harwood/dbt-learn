{{
    config(
        materialized='table'
    )
}}

WITH contribs as (
    SELECT *
    FROM {{ ref('stg_contribs') }}
),
committees as (
    SELECT *
    FROM {{ ref('stg_committees') }}
)

SELECT
   contribs.transaction_id
    , contribs.contributor_last_name
    , contribs.contributor_first_name
    , contribs.contributor_street_1
    , contribs.contributor_city
    , contribs.state_code AS contrib_state_code
    , contribs.is_us_state AS contrib_is_us_state
    , contribs.contributor_zip_code
    , contribs.contribution_date
    , contribs.contribution_amount
    , contribs.contribution_aggregate
    , contribs.contribution_purpose_descrip
    , contribs.memo_text_description
    , committees.name
    , committees.treasurer_name
    , committees.street_1
    , committees.street_2
    , committees.city AS committee_city
    , committees.state_code AS committee_state_code
    , committees.is_us_state AS committee_is_us_state
    , committees.designation_code
    , committees.committee_type
    , committees.party_affiliation
    , committees.filing_frequency
    , committees.org_type
    , committees.connected_org_name
    , committees.candidate_id
FROM contribs
JOIN committees on (committees.id=contribs.earmarked_committee_id)