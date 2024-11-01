{{
    config(
        materialized='table'
    )
}}

/* general dataset notes and observations
- this dataset has a very low rate of missing values; less than 1% of the field values are missing, empty, or null
- columns are given long descriptive names in plain english, with few abbreviations
- most string values are in all caps, with the exception of the 'contribution_purpose_descrip' and 'memo_text_description'
- there is no unique identifier for contributor
*/ 

SELECT 
  fec_report_id
, date_report_received  
, transaction_id
, contributor_last_name
, contributor_first_name
, contributor_street_1
, contributor_city
, contributor_state as state_code
/*  the 'contributor_state' field contains 19 distinct two-letter code values that do not actually represent US States
    these values appear to be codes for US territories, Canadian provinces, country-level ISO codes, or just 'ZZ'
    for our analysis, we want to distinguish between US states and foreign contributions, so I am adding a boolean flag for 'is_us_state'
*/
, CASE 
     WHEN contributor_state IN ('AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA', 
                             'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD', 
                             'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 
                             'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC', 
                             'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY', 'DC') 
        THEN 1 
        ELSE 0 
    END AS is_us_state
, contributor_zip_code    
, contribution_date
, contribution_amount
, contribution_aggregate
, contribution_purpose_descrip
, memo_text_description
/*  when a contribution is earmarked for a specific committee, the committee id number is given at the end of the
    'memo_text_description' value.  these ids are usually in parentheses, but in many cases the closing parenthesis in missing
    we need to extract these ids to use as a foreign key to join with the committee data
    this regex pattern will match any string that starts with the letter C followed by exactly 8 digits
*/
, REGEXP_EXTRACT(memo_text_description, r'C\d{8}') AS earmarked_committee_id
FROM {{ source('actblue_tech_assess_may_2024', 'raw_FEC_Filing_Sample') }}


/* fields I did not include in my staging query because they contained only one unique value
- form_type (SA11AI)
- filer_committee_id_number (C00401224)
- entity_type (IND)
*/




