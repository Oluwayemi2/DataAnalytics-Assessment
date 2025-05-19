-- Assessment_Q2.sql
-- Transaction Frequency Analysis
-- This query calculates the average number of transactions per customer per month
-- and categorizes customers into High, Medium, or Low frequency segments.

SELECT
    CASE
        WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
        WHEN avg_txn_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 1) AS avg_transactions_per_month
FROM (
    SELECT
        owner_id,
        -- Total number of transactions for the customer
        COUNT(*) AS total_transactions,
        
        -- Number of unique months the customer was active
        COUNT(DISTINCT DATE_FORMAT(transaction_date, '%Y-%m')) AS active_months,
        
        -- Average number of transactions per active month
        COUNT(*) * 1.0 / NULLIF(COUNT(DISTINCT DATE_FORMAT(transaction_date, '%Y-%m')), 0) AS avg_txn_per_month
    FROM
        savings_savingsaccount
    GROUP BY
        owner_id
) AS customer_avg_txns
GROUP BY
    frequency_category
ORDER BY
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
