-- Assessment_Q4.sql
-- Customer Lifetime Value (CLV) Estimation
-- This query estimates CLV based on transaction volume and tenure in months since signup.
-- Formula: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction

SELECT
    u.id AS customer_id,
    u.name,
    
    -- Tenure in full months since customer signup
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,

    -- Total number of transactions
    COUNT(s.id) AS total_transactions,

    -- Estimated CLV based on simplified model
    ROUND(
        (
            COUNT(s.id) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 0)
        ) * 12 * AVG(s.confirmed_amount * 0.001), 2
    ) AS estimated_clv

FROM
    users_customuser u

-- Join to savings transactions to access transaction data
JOIN
    savings_savingsaccount s ON u.id = s.owner_id

GROUP BY
    u.id, u.name, u.date_joined

ORDER BY
    estimated_clv DESC;
