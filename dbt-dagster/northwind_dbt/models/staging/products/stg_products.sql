
with clean_products as (
    select 
        *,
        current_timestamp() as STAGED_AT
    from northwind.`Products`
)

select *
from clean_products