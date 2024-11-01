{{
    config(
        materialized='table'
    )
}}

/* general dataset notes and observations
- this dataset has many missing values - 20.66% of all field values are missing or null
- the majority of missing values are in these fields: org_tp, cmte_st2, cand_id, cmt_pty_affilliation, connected_org_num
- excluding those fields, less than 1% of the remaining values are missing
- committee_id is a unique key
- the field names and values use abbreviations and codes that make the data hard to read for someone not familiar with the data
- to improve readibility, I am changing the names of the columns to use full words
- since all of this is committee data, I also have omitted the prefix 'cmte' in most cases, except where it is is needed to avoid confusion
- all string data is in all caps
*/ 

SELECT 
  bg_cycle as cycle
, cmte_id as id
, cmte_nm as name
, tres_nm as treasurer_name
, cmte_st1 as street_1
, cmte_st2 as street_2
, cmte_city as city
, cmte_st as state_code
/*  the 'cmte_st' field contains 9 distinct two-letter code values that do not actually represent US States
    these values appear to be codes for US territories, Canadian provinces, country-level ISO codes, or just 'ZZ' or '14'
    for our analysis, we want to distinguish between US states + DC and foreign contributions, so I am adding a boolean flag for 'is_us_state'
*/
, CASE 
     WHEN cmte_st IN ('AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA', 
                      'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD', 
                      'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 
                      'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC', 
                      'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY', 'DC') 
        THEN 1 
        ELSE 0 
    END as is_us_state
, cmte_dsgn as designation_code
, cmte_tp as committee_type -- used committee_ prefix to disambiguate from org_type
, cmte_pty_affiliation as party_affiliation
, cmte_filing_freq as filing_frequency
, org_tp as org_type
, connected_org_nm as connected_org_name
, cand_id as candidate_id
FROM {{ source('actblue_tech_assess_may_2024', 'raw_FEC_Committee_Data_2020') }}
