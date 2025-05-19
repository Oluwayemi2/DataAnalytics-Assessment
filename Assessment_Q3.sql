-- Assessment_Q3.sql
-- Account Inactivity Alert
-- This query identifies active savings or investment plans that have had no transactions
-- in the last 365 days, to help flag inactive accounts for follow-up.

SELECT
    p.id AS plan_id,
    p.owner_id,
    
    -- Determine the plan type based on flags
    CASE
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,

    MAX(s.transaction_date) AS last_transaction_date,

    -- Days since last transaction
    DATEDIFF(CURDATE(), MAX(s.transaction_date)) AS inactivity_days

FROM
    plans_plan p

-- Join with savings transactions to get transaction dates
LEFT JOIN savings_savingsaccount s
    ON p.id = s.plan_id

-- Consider only savings or investment plans
WHERE
    (p.is_regular_savings = 1 OR p.is_a_fund = 1)

-- Group by plan to get latest transaction per plan
GROUP BY
    p.id, p.owner_id, p.is_regular_savings, p.is_a_fund

-- Inactivity condition: more than 365 days since last transaction
HAVING
    DATEDIFF(CURDATE(), MAX(s.transaction_date)) > 365
ORDER BY
    inactivity_days DESC;
