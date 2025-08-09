# EcommerceCustomerChurnAnalysis
This project presents a comprehensive SQL-based data analytics pipeline for performing customer churn analysis on e-commerce data. It covers the entire workflow from database creation and raw data import, through data cleaning and feature engineering, to in-depth business intelligence queries revealing key churn drivers.
# Ecommerce Customer Churn Analysis Using MySQL

##  Project Overview

This project demonstrates a complete customer churn analysis workflow for a fictional e-commerce platform using MySQL. It covers **data cleaning, feature engineering, and advanced business analytics** through detailed SQL queries applied on customer transactional and demographic data.

**Goal:**  
- Identify key factors influencing customer churn  
- Extract actionable business insights for retention  
- Prepare data for future predictive modeling (e.g., machine learning)

***

##  Project Workflow

### 1. Database & Table Setup
- Created a dedicated MySQL database `EcommerceChurnDB` with a detailed table schema for storing customer, transaction, and churn-related data.

### 2. Data Import
- Imported the CSV dataset (`ecommerce_churn.csv`) using MySQL Workbench’s Table Data Import Wizard into the predefined `ecommercechurn` table, ensuring data integrity.

### 3. Data Cleaning
- Handled missing values by replacing nulls with column averages.
- Standardized categorical text fields for consistency.
- Corrected data entry errors and fixed outliers.
- Added user-friendly labels for churn status and complaints.

### 4. Feature Engineering
- Created categorical "buckets" for warehouse distance, tenure range, and cashback amount to facilitate better segmentation and machine learning feature preparation.

### 5. Business Analytics & Insights
- Launched 17 key analytical SQL queries to uncover trends and relationships related to churn, including device usage, city tier, tenure, payment modes, customer complaints, and more.
- These insights help guide marketing, customer retention, and business strategy.

***

##  Data Model Summary

| Column                   | Description                                         |
|--------------------------|-----------------------------------------------------|
| CustomerID               | Unique customer identifier                          |
| Churn                    | 1=Churned, 0=Stayed                                 |
| Tenure                   | Customer lifespan in months                         |
| PreferredLoginDevice     | Device most used for login                          |
| CityTier                 | Customer's city tier (1/2/3)                        |
| WarehouseToHome          | Distance from warehouse to home                     |
| PreferredPaymentMode     | Payment mode preference                             |
| Gender                   | Customer gender                                     |
| HourSpendOnApp           | Avg hours spent on app                              |
| NumberOfDeviceRegistered | Total devices registered per customer               |
| PreferedOrderCat         | Favorite order category                             |
| SatisfactionScore        | Service satisfaction score (1–5)                    |
| MaritalStatus            | Customer marital status                             |
| NumberOfAddress          | Total addresses on file                             |
| Complain                 | 1=Complaint received, 0=No complaint                |
| OrderAmountHikeFromLastYear | Year-over-year order amount change              |
| CouponUsed               | Number of coupons used                              |
| OrderCount               | Total orders                                        |
| DaySinceLastOrder        | Days since last order                               |
| CashbackAmount           | Total cashback received                             |

***

##  Key Business Questions Covered

1. What is the overall customer churn rate?  
2. How does churn vary by preferred login device?  
3. Distribution of churn across city tiers.  
4. Is there a correlation between warehouse-to-home distance and churn?  
5. Which payment modes are linked with higher churn?  
6. What are typical tenure ranges of churned customers?  
7. Churn differences by gender.  
8. Average app usage by churn status.  
9. Impact of registered devices on churn.  
10. Popular order categories among churned customers.  
11. Relationship between satisfaction scores and churn.  
12. Influence of marital status on churn.  
13. Average number of addresses churned customers have.  
14. Effect of customer complaints on churn behavior.  
15. Coupon usage comparison between churned and non-churned customers.  
16. Average days since last order for churned customers.  
17. Correlation between cashback amount ranges and churn rates.

***

##  Summary of Insights

- Customers living farther from warehouses are more likely to churn.  
- Cash on Delivery payment users have higher churn rates.  
- Most churn occurs within the first six months of customer tenure.  
- Customers with complaints tend to churn more frequently.  
- More registered devices per customer correlate with higher churn.  
- Coupon use and cashback incentives positively impact customer retention.

***

## 📊 Visuals

### Entity-Relationship (ER) Diagram  
*(Include your ER diagram image here to show database structure: customer, transactions, churn attributes.)*

### Workflow Flowchart  
*(Include this flowchart that illustrates data import → cleaning → feature engineering → analysis workflow.)*

### Sample Query Output  
*(Insert screenshots or sample outputs of key SQL queries showing churn rate, device impact, tenure analysis, etc.)*

***

## 🛠️ Tools & Technologies

- MySQL & MySQL Workbench for database management and SQL querying  
- CSV data import via MySQL Workbench’s Table Data Import Wizard  
- SQL for data cleaning, feature engineering, and business analytics  

***

***

## 📈 Next Steps & Extensions

- Export cleaned data for churn prediction machine learning models with Python or R.  
- Create visual dashboards using Tableau or Power BI for enhanced reporting.  
- Conduct cohort or survival analysis to deepen retention understanding.

***

## Author

Bushra Ayyub Shivani Kachhi
Email: bushrashivani13@gmail.com

***

## License

MIT License

***

This README provides a comprehensive, professional description for your Ecommerce Customer Churn Analysis SQL project, ready to be included in your portfolio or GitHub repository to attract academic or professional attention.
