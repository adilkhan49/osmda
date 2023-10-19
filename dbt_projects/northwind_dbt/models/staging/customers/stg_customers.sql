
with clean_customers as (
    select 
        *,
        current_timestamp() as STAGED_AT
    from northwind.`Customers`
)

select *
from clean_customers