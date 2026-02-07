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
