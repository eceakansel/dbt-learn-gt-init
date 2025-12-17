SELECT 
        ORDER_ID,
        SUM(AMOUNT) AS TOTAL_AMOUNT

FROM {{ ref('stg_stripe__payments') }}
group by ORDER_ID
having total_amount < 0