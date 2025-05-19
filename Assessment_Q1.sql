-- High-Value Customers with Multiple Products
-- Identify customers with at least 1 funded savings and 1 funded investment plan.
-- Funding is inferred via presence of deposits in savings_savingsaccount.

SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COALESCE(savings.savings_count, 0) AS savings_count,
    COALESCE(investments.investment_count, 0) AS investment_count,
    ROUND(COALESCE(deposits.total_deposits, 0) / 100, 2) AS total_deposits
FROM users_customuser u

-- Count savings plans with deposits
LEFT JOIN (
    SELECT p.owner_id, COUNT(DISTINCT p.id) AS savings_count
    FROM plans_plan p
    JOIN savings_savingsaccount s ON s.plan_id = p.id
    WHERE p.is_regular_savings = 1
    GROUP BY p.owner_id
) savings ON u.id = savings.owner_id

-- Count investment plans with deposits
LEFT JOIN (
    SELECT p.owner_id, COUNT(DISTINCT p.id) AS investment_count
    FROM plans_plan p
    JOIN savings_savingsaccount s ON s.plan_id = p.id
    WHERE p.is_a_fund = 1
    GROUP BY p.owner_id
) investments ON u.id = investments.owner_id

-- Sum deposits for savings plans
LEFT JOIN (
    SELECT p.owner_id, SUM(s.confirmed_amount) AS total_deposits
    FROM savings_savingsaccount s
    JOIN plans_plan p ON s.plan_id = p.id
    WHERE p.is_regular_savings = 1
    GROUP BY p.owner_id
) deposits ON u.id = deposits.owner_id

-- Filter: must have both savings and investment plans
WHERE COALESCE(savings.savings_count, 0) >= 1
  AND COALESCE(investments.investment_count, 0) >= 1

ORDER BY total_deposits DESC
LIMIT 1000;
