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


SELECT * 
FROM contribs
JOIN committees ON committees.id=contribs.earmarked_committee_id