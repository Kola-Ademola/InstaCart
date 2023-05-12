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
I used advanced SQL functions to import the dataset and normalized it all in PostgreSQL.  

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


