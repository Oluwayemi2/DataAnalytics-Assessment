# DataAnalytics-Assessment

This repository contains SQL solutions to a multi-question data analytics assessment. The tasks simulate business scenarios involving savings, investment plans, customer behavior, and transaction analysis. Each SQL script is structured to provide clear, well-documented answers optimized for accuracy, performance, and readability.

---

## Questions & Solutions

---

### Assessment_Q1.sql – High-Value Customers with Multiple Products

**Problem Understanding:**  
Identify customers who have both a funded savings plan and a funded investment plan. Funding is inferred by the presence of deposits in `savings_savingsaccount`.

**Approach:**  
- Filter `plans_plan` for `is_regular_savings = 1` and `is_a_fund = 1`.
- Join with `savings_savingsaccount` to count plans with deposits.
- Group and count distinct funded plans per user.
- Aggregate total deposits and convert from kobo to naira.
- Return only users with at least 1 savings and 1 investment plan.

**SQL Techniques Used:**  
- Subqueries with JOINs  
- `COUNT(DISTINCT ...)`, `SUM()`, `COALESCE()`  
- Monetary normalization (divided by 100)  

**Challenges:**  
- Ensuring accuracy when customers have plans but no deposits.  
- Handled with `LEFT JOIN` and `COALESCE()` to count only funded plans.
- `name` column was returning `NULL` — resolved by using `CONCAT(first_name, ' ', last_name)` instead.

---

### Assessment_Q2.sql – Transaction Frequency Analysis

**Problem Understanding:**  
Classify customers based on monthly transaction volume into High, Medium, or Low frequency users.

**Approach:**  
- Count total transactions and distinct active months per customer.
- Calculate average transactions per active month.
- Categorize using a `CASE` expression.
- Aggregate to show number of users and average frequency per group.

**SQL Techniques Used:**  
- Subquery with aggregate functions  
- `DATE_FORMAT()`, `NULLIF()` for safe division  
- `CASE`, `ROUND()`, `FIELD()` for category sorting  

**Challenges:**  
- Division-by-zero risk when a user has zero active months—resolved using `NULLIF()`.  
- Defined frequency based on actual active months, not calendar months, for accuracy.

---

### Assessment_Q3.sql – Account Inactivity Alert

**Problem Understanding:**  
Identify savings or investment plans with no transactions in the past 365 days.

**Approach:**  
- Filter active plans using `is_regular_savings` and `is_a_fund`.
- Join with `savings_savingsaccount` to find the last transaction date.
- Use `DATEDIFF()` to calculate inactivity days.
- Filter plans with over 365 days of inactivity.

**SQL Techniques Used:**  
- `LEFT JOIN`, `MAX()` for last transaction  
- `DATEDIFF()` with `HAVING` clause  

**Challenges:**  
- Some plans may have no transaction history—resolved using `LEFT JOIN`.  
- Account type labeling handled using `CASE` expression.

---

### Assessment_Q4.sql – Customer Lifetime Value (CLV) Estimation

**Problem Understanding:**  
Estimate CLV using the formula:  
\[
CLV = \left(\frac{\text{total transactions}}{\text{tenure in months}}\right) \times 12 \times \text{avg profit per transaction}
\]  
Profit per transaction = 0.1% of transaction value.

**Approach:**  
- Calculate tenure using `TIMESTAMPDIFF(MONTH, date_joined, CURDATE())`
- Count total transactions per user.
- Estimate average profit using `AVG(confirmed_amount * 0.001)`
- Use `ROUND()` to return CLV to 2 decimal places.

**SQL Techniques Used:**  
- `JOIN`, `COUNT()`, `AVG()`, `ROUND()`  
- `NULLIF()` to prevent division-by-zero  
- `CONCAT()` to display full user names

**Challenges:**  
- `name` column was returning `NULL` — resolved by using `CONCAT(first_name, ' ', last_name)` instead.  
- Kobo to naira conversion handled inside the profit calculation.

---

## Repository Structure

