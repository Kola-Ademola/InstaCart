# InstaCart DB
# Denormalization of the InstaCart dataset &amp; Analysis
## by Kola Ademola
___
![](images/Instacart_Logo.jpg)
___
## INTRODUCTION
___
Instacart is an American delivery company that operates a grocery delivery and pick-up service in the United States and Canada. The company offers its services via a website and mobile app. The service allows customers to order groceries from participating retailers with the shopping being done by a personal shopper. This project is just focused on **DENORMALIZATION** of the Instacart orders dataset & some basic analysis
___
## SKILLS DEMONSTRATED
I used advanced SQL functions to import the dataset and normalized it, then I did some basic data analysis to query the database as well, all in PostgreSQL.  

### DENORMALIZATION PROCESS
For this project I started by creating a temporary table to hold the denormalized data first;
![](images/temp_table_query.png)
Then I imported the data from the **csv** into the temporary table I created.  
___QUERY___  
![](images/import_temp.png)
___RESULT___  
![](images/denormalized_data.png)
After importing the data I split it into 4 tables to acheive **3NF**
### AISLE TABLE
___QUERY___  
![](images/aisle_query.png)  
___RESULT___  
![](images/aisle_table.png)  
### DEPARTMENTS TABLE
___QUERY___  
![](images/departments_query.png)  
___RESULT___  
![](images/departments_table.png)  
### PRODUCTS TABLES
___QUERY___  
![](images/products_query.png)  
___RESULT___  
![](images/products_table.png)  
### ORDERS TABLE
___QUERY___  
![](images/orders_query.png)  
___RESULT___  
![](images/orders_table.png)  
___
## DATA MODELLING
___
The initial dataset is a denormalized dataset; I will be denormalizing it to **3NF** brfore analysis  
___DENORMALIZED DATASET___  
![](images/denormalized_data.png)
* The whole order details is in one table, I will break it down to 4 diffrent tables in the process of normalization or archieving **3NF**.   
* The result of normalization can be seen in this data model(**STAR SCHEMA**);  
___DATA MODEL___  
![](images/data_model.png)
___
## DATA ANALYSIS & VISUALIZATIONS
____
I'll be using this database to solve some business problems that the owner of **Instacart** is interested in knowing and solving..

### PROBLEM STATEMENT
* Q1 What are the top-selling products by revenue, and how much revenue have they generated?  
___QUERY___  
![](images/q1.png)
___RESULT___  
![](images/q1_table.png)
> INSIGHT:::The top-selling product is the **"Vanilla, Tangerine & Shortbread Ice Cream"** with a total revenue of **$11,184.00**.
___
* Q2 Which products have the highest profit margin, and how much profit have they generated?  
___QUERY___  
![](images/q2.png)
___RESULT___  
![](images/q2_table.png)
> INSIGHT:::The top products with the most generated profit all have the same profit margin, with **"Vanilla, Tangerine & Shortbread Ice Cream"** at the top of list with **"$1,118.40"** total profit.
___
* Q3 Which aisles have the highest sales volume, and how does this vary by department?  
___QUERY___  
![](images/q3.png)
___RESULT___  
![](images/q3_table.png)
> INSIGHT:::The **"missing"** aisle has the highest overall sales volume with over **147,000** items sold
___
* Q4 What is the average order size (in terms of quantity and total cost) per day of the week?  
___QUERY___  
![](images/q4.png)
___RESULT___  
![](images/q4_table.png)
> INSIGHT:::The average order size & value is almost the same for most days of the week, but Fridays come out on top with **"6 orders per day"** and an AOV of **"$151.36"**.
___
* Q5 Which products are most commonly purchased together, and what is the frequency of these combinations?  
___QUERY___  
![](images/q5.png)
___RESULT___  
![](images/q5_table.png)
>
___
* Q6 What is the average time between orders for each user, and how does this vary by product category?  
___QUERY___  
![](images/q6.png)
___RESULT___  
![](images/q6_table.png)
>
___
* Q7 Which products have the highest rate of returns or customer complaints, and what are the common reasons?  
___QUERY___  
![](images/q7.png)
___RESULT___  
![](images/q7_table.png)
>
___
* Q8 What is the average unit cost and unit price for each product category, and how does this compare to industry benchmarks?  
___QUERY___  
![](images/q8.png)
___RESULT___  
![](images/q8_table.png)
>
___
* Q9 How have sales and revenue changed over time for each product category, and what factors have contributed to these changes?  
___QUERY___  
![](images/q9.png)
___RESULT___  
![](images/q9_table.png)
>
___
* Q10 Which users have the highest lifetime value, and what are their common purchase patterns and preferences?  
___QUERY___  
![](images/q10.png)
___RESULT___  
![](images/q10_table.png)
>
___


