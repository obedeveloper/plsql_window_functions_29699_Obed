# SQL JOINs & Window Functions Project

## Problem Definition

### Business Context
**Company Type:** Online Clothing Rental Service  
**Department:** Marketing  
**Industry:** Fashion and E-commerce  

### Data Challenge
The marketing department struggles to effectively target customers due to insufficient insights into user preferences and rental patterns. The data available only provides general rental statistics, making it difficult to differentiate between high-value customers and occasional users.

### Expected Outcome
The objective is to analyze rental frequency, customer demographics, and garment preferences to identify key customer segments. This will enable the development of personalized marketing strategies aimed at increasing repeat rentals by 20% over the next six months.

## Success Criteria

### Measurable Goals

1. **Top 5 Products per Region or Quarter**  
   Use the **RANK()** window function to rank products based on rental frequency within each region or quarter. The goal is to identify the top 5 performing products in each category, helping to tailor inventory and marketing strategies.

2. **Running Monthly Sales Totals**  
   Implement **SUM() OVER()** to calculate running totals for monthly rental income. This will provide insights into sales trends over time, allowing the business to assess revenue performance continuously.

3. **Month-over-Month Growth Analysis**  
   Utilize the **LAG()** function to compare current month sales with the previous month’s sales. The goal is to quantify growth or decline, enabling the marketing department to adapt strategies based on performance insights.

4. **Customer Quartile Segmentation**  
   Leverage **NTILE(4)** to segment customers into four quartiles based on total rental spend. This segmentation will assist in identifying high-value customers for targeted marketing initiatives.

5. **Three-Month Moving Averages**  
   Apply **AVG() OVER()** for calculating three-month moving averages of rental transactions. The goal is to smooth out fluctuations in monthly rental data, providing a clearer picture of long-term trends and seasonality.

## Database Schema Design

### 1. **Customers Table**
This table stores information about the customers who rent clothing.

| Column Name          | Data Type       | Constraints                          |
|----------------------|------------------|--------------------------------------|
| **customer_id**      | INT              | PRIMARY KEY, AUTO_INCREMENT           |
| **name**             | VARCHAR(255)     | NOT NULL                             |
| **email**            | VARCHAR(255)     | UNIQUE, NOT NULL                     |
| **phone**            | VARCHAR(15)      | NULL                                 |
| **registration_date** | DATE             | NOT NULL                             |

### 2. **Products Table**
This table contains details about the clothing items available for rent.

| Column Name        | Data Type       | Constraints                          |
|--------------------|------------------|--------------------------------------|
| **product_id**     | INT              | PRIMARY KEY, AUTO_INCREMENT           |
| **product_name**   | VARCHAR(255)     | NOT NULL                             |
| **category**       | VARCHAR(100)     | NOT NULL                             |
| **rental_price**   | DECIMAL(10, 2)   | NOT NULL                             |
| **stock_quantity** | INT              | NOT NULL                             |

### 3. **Rentals Table**
This table records individual rental transactions made by customers.

| Column Name         | Data Type       | Constraints                          |
|---------------------|------------------|--------------------------------------|
| **rental_id**       | INT              | PRIMARY KEY, AUTO_INCREMENT           |
| **customer_id**     | INT              | FOREIGN KEY REFERENCES Customers(customer_id) |
| **product_id**      | INT              | FOREIGN KEY REFERENCES Products(product_id)   |
| **rental_date**     | DATE             | NOT NULL                             |
| **return_date**     | DATE             | NULL                                 |
| **rental_status**   | VARCHAR(50)      | NOT NULL                             |

### Relationships

- **Customers** to **Rentals**: One-to-Many relationship (one customer can have multiple rentals).
- **Products** to **Rentals**: One-to-Many relationship (one product can be rented multiple times).
  
<img width="3208" height="2404" alt="image" src="https://github.com/user-attachments/assets/07743808-9f4d-4192-9a12-ec74b8621ff8" />

## SQL Joins Implementation

I have created required tables and I have aslo insterted sample data, check out this [SQL script](https://github.com/obedeveloper/plsql_window_functions_29699_Obed/blob/a9c6725a7f9d344e076ab9663902745a3eddca4d/sql-scripts/01-create-tables-and-insert-sample-data.sql) for more info.

### 1. INNER JOIN: Retrieve transactions with valid customers and products

```sql
-- Inner Join to retrieve transactions with valid customers and products
SELECT 
    Rentals.rental_id, 
    Customers.name AS customer_name, 
    Products.product_name, 
    Rentals.rental_date, 
    Rentals.return_date 
FROM 
    Rentals
INNER JOIN 
    Customers ON Rentals.customer_id = Customers.customer_id
INNER JOIN 
    Products ON Rentals.product_id = Products.product_id;
```

<img width="1005" height="509" alt="image" src="https://github.com/user-attachments/assets/0076934f-d5f5-41fb-8bef-279799b53fee" />

**Business Interpretation:** This query reveals all transactions linked to actual customers and products. By identifying valid transactions, the business can analyze customers' preferences and product performance effectively.

### 2. LEFT JOIN: Identify customers who have never made a transaction

```sql
-- Left Join to identify customers who have never made a transaction
SELECT 
    Customers.name AS customer_name, 
    Customers.email, 
    Rentals.rental_id 
FROM 
    Customers
LEFT JOIN 
    Rentals ON Customers.customer_id = Rentals.customer_id
WHERE 
    Rentals.rental_id IS NULL;
```

<img width="984" height="365" alt="image" src="https://github.com/user-attachments/assets/82287e34-473b-4b47-9313-961ee9391876" />

**Business Interpretation:** This query identifies customers who have not yet initiated any transactions. Targeting these customers with tailored marketing can help convert them into active users.

### 3. RIGHT JOIN: Detect products with no sales activity

```sql
-- Right Join to detect products with no sales activity
SELECT 
    Products.product_name, 
    Rentals.rental_id 
FROM 
    Products
RIGHT JOIN 
    Rentals ON Products.product_id = Rentals.product_id
WHERE 
    Rentals.rental_id IS NULL;
```

<img width="946" height="321" alt="image" src="https://github.com/user-attachments/assets/581b72dc-fc75-4359-bf30-29c23ae00057" />

**Business Interpretation:** This query shows products that have not been rented out. Knowing which products have no sales activity allows the business to consider promotions or adjustments in inventory.

### 4. FULL OUTER JOIN: Compare customers and products including unmatched records

```sql
-- Full Outer Join to compare customers and products including unmatched records
SELECT 
    Customers.name AS customer_name, 
    Products.product_name, 
    Rentals.rental_id 
FROM 
    Customers
FULL OUTER JOIN 
    Rentals ON Customers.customer_id = Rentals.customer_id
FULL OUTER JOIN 
    Products ON Rentals.product_id = Products.product_id;
```

<img width="992" height="483" alt="image" src="https://github.com/user-attachments/assets/6cb3d940-ee35-40a9-8349-e0e798bf057d" />

**Business Interpretation:** This query provides a comprehensive view, showcasing both customers with transactions and those without, alongside products involved in these transactions. This is valuable for understanding overall engagement in the rental service.

### 5. SELF JOIN: Compare customers within the same region or transactions within the same time period

```sql
-- Self Join to compare customers with the same rental dates
SELECT 
    C1.name AS customer_name_1, 
    C2.name AS customer_name_2, 
    A.rental_date 
FROM 
    Rentals A
JOIN 
    Rentals B ON A.rental_date = B.rental_date AND A.customer_id != B.customer_id
JOIN 
    Customers C1 ON A.customer_id = C1.customer_id
JOIN 
    Customers C2 ON B.customer_id = C2.customer_id;
```

<img width="1282" height="403" alt="image" src="https://github.com/user-attachments/assets/aa2195b2-04f3-4094-91c0-bdb2362d9b42" />

**Business Interpretation:** This query compares customers who made rentals on the same date, allowing analysis of user behavior patterns. Identifying simultaneous renters can inform promotional strategies aimed at increasing rental frequency.

## Window Functions Implementation

### 1. Ranking Functions

```sql
-- Ranking customers by total rental amount
SELECT 
    C.customer_id, 
    C.name, 
    SUM(P.rental_price) AS total_revenue,
    RANK() OVER (ORDER BY SUM(P.rental_price) DESC) AS revenue_rank
FROM 
    Rentals R
JOIN 
    Customers C ON R.customer_id = C.customer_id
JOIN 
    Products P ON R.product_id = P.product_id
GROUP BY 
    C.customer_id
ORDER BY 
    revenue_rank;
```

<img width="1109" height="554" alt="image" src="https://github.com/user-attachments/assets/16db7641-6722-4d5a-9ef6-4ec07c28f233" />

**Business Interpretation:** This query ranks customers based on their total revenue from rentals. Understanding which customers contribute the most can help in formulating loyalty programs and targeted marketing strategies.

### 2. Aggregate Window Functions

```sql
-- Running total of rental revenue per month
SELECT 
    DATE_TRUNC('month', R.rental_date) AS rental_month,
    SUM(P.rental_price) AS monthly_revenue,
    SUM(SUM(P.rental_price)) OVER (ORDER BY DATE_TRUNC('month', R.rental_date)
                                   ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM 
    Rentals R
JOIN 
    Products P ON R.product_id = P.product_id
GROUP BY 
    rental_month
ORDER BY 
    rental_month;
```

<img width="1447" height="504" alt="image" src="https://github.com/user-attachments/assets/e653fe64-2add-48b0-a596-1a255cf0e10c" />

**Business Interpretation:** This query calculates the monthly revenue and provides a running total over these months, allowing the business to track financial performance trends over time and adjust strategies accordingly.

### 3. Navigation Functions

```sql
-- Period-to-period comparison of monthly revenue growth
WITH monthly_revenue AS (
    SELECT 
        DATE_TRUNC('month', R.rental_date) AS rental_month,
        SUM(P.rental_price) AS monthly_revenue
    FROM 
        Rentals R
    JOIN 
        Products P ON R.product_id = P.product_id
    GROUP BY 
        rental_month
)
SELECT 
    rental_month,
    monthly_revenue,
    LAG(monthly_revenue) OVER (ORDER BY rental_month) AS previous_month_revenue,
    monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY rental_month) AS growth
FROM 
    monthly_revenue;
```

<img width="1297" height="606" alt="image" src="https://github.com/user-attachments/assets/0575a028-51b6-40b2-b9e9-5553fb9149d0" />

**Business Interpretation:** This query calculates the revenue growth by comparing each month's revenue to the previous month. Understanding these trends will help the business identify periods of growth or decline and make data-driven decisions.

### 4. Distribution Functions

```sql
-- Customer segmentation into quartiles based on total spending
SELECT 
    C.customer_id, 
    C.name, 
    SUM(P.rental_price) AS total_spending,
    NTILE(4) OVER (ORDER BY SUM(P.rental_price)) AS spending_quartile
FROM 
    Rentals R
JOIN 
    Customers C ON R.customer_id = C.customer_id
JOIN 
    Products P ON R.product_id = P.product_id
GROUP BY 
    C.customer_id
ORDER BY 
    spending_quartile;
```

<img width="1126" height="548" alt="image" src="https://github.com/user-attachments/assets/1a66dacc-4340-414f-a73c-6b0a52ae38cc" />

**Business Interpretation:** This query segments customers into quartiles based on their total spending. This segmentation allows the business to target marketing efforts to different customer groups based on their spending behavior.

## Insights

1. **Customer-Product Relationships from FULL OUTER JOIN:**
   - The query results show that **Alice Johnson** rented multiple items, including a Winter Jacket and an Evening Gown, while **Bob Smith** rented Jeans and **Charlie Brown** rented a Summer Dress and a Tuxedo.
   - The FULL OUTER JOIN indicates that there are customers and products without direct associations, highlighting areas for potential marketing efforts aimed at products with no rental history or customers who haven't rented any items.

2. **Revenue Ranking from Ranking Functions:**
   - The revenue ranking shows that **Alice Johnson** has generated **$119.98** through rentals, followed closely by **Charlie Brown** at **$19.99** and **Bob Smith** at **$19.99**.
   - This ranking allows the business to identify high-value customers, which can lead to personalized marketing strategies, such as loyalty rewards or targeted promotions to increase spending.

3. **Monthly Revenue Trends:**
   - The monthly revenue data shows a total of **$139.97** for the month of **February 2022**, with a comparison to the previous month.
   - A significant revenue increase from the prior month provides insight into customer engagement and rental activity, suggesting successful marketing campaigns or seasonal demand dynamics, which can be critical for future business planning.

## References

1. **PostgreSQL Official Documentation**
   - URL: [PostgreSQL Documentation](https://www.postgresql.org/docs/)

2. **W3Schools SQL Tutorial**
   - URL: [W3Schools SQL Tutorial](https://www.w3schools.com/sql/)

3. **PostgreSQL Tutorial**
   - URL: [PostgreSQL Tutorial](https://www.postgresqltutorial.com/)

4. **LeetCode SQL Challenges**
   - URL: [LeetCode SQL Problems](https://leetcode.com/problemset/all/?filters=tag%3ASQL)
  
## Integrity

All sources were properly cited. Implementations and analysis represent original work. No AI-
generated content was copied without attribution or adaptation.
