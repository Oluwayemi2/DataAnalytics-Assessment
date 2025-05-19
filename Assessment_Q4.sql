-- Assessment_Q4.sql
-- Customer Lifetime Value (CLV) Estimation
-- This query estimates CLV using transaction volume and account tenure in months.
-- Formula: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction

SELECT
    u.id AS customer_id,

    -- Combine first and last names to get the full customer name
    CONCAT(u.first_name, ' ', u.last_name) AS name,

    -- Calculate tenure in full months since the user joined
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,

    -- Total number of transactions linked to the user
    COUNT(s.id) AS total_transactions,

    -- Estimated CLV using the provided formula
    ROUND(
        (
            COUNT(s.id) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 0)
        ) * 12 * AVG(s.confirmed_amount * 0.001), 2
    ) AS estimated_clv

FROM
    users_customuser u

-- Join savings transactions with user table
JOIN
    savings_savingsaccount s ON u.id = s.owner_id

-- Group by necessary user fields
GROUP BY
    u.id, u.first_name, u.last_name, u.date_joined

-- Sort by estimated CLV in descending order
ORDER BY
    estimated_clv DESC;
