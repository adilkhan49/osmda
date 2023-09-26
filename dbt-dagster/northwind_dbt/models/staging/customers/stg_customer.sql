
with clean_customer as (
    select 
        *,
        current_timestamp() as STAGED_AT
    from northwind.`Customers`
)

select *
from clean_customer