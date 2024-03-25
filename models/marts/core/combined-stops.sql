with clinton as (

    select * from {{ ref ('clinton-star-2') }}

),

 trump as (

    select * from {{ ref ('trump-star-2') }}

)

select * from clinton
union all
select * from trump