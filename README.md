# DataAnalytics-Assessment
Completed a multi-step SQL assessment analyzing customer transactions and plans. Built optimized queries for frequency segmentation, inactivity alerts, and CLV estimation using joins, date functions, and aggregations. Ensured accuracy by following schema hints and business rules, with clean, well-structured SQL solutions.

## Assessment_Q1.sql – High-Value Customers with Multiple Products

**Objective**: Identify users who have both a funded savings plan and a funded investment plan, and rank them by total deposits.

**Approach**:
- A "funded" plan is inferred by the presence of at least one deposit in `savings_savingsaccount`.
- Used `plans_plan` to count distinct funded savings and investment plans (via joins).
- Used `savings_savingsaccount` to calculate total confirmed deposits per user.
- Returned users who have both at least one savings and one investment plan.

**Challenges**:
- The table did not have a direct `is_funded` field, so funding was determined indirectly.
- Name fields had to be built by concatenating `first_name` and `last_name`.
