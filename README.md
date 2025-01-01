# data-analytics-power-bi-report815

## Importing the data into Power Bi 

### The dataset consists of 4 tables: An Orders fact table, and dimension tables for Products,Stores and Customers. 

The first stage of this project involved data loading and preparation.
- Firstly, a conncection was made to an Azure SQL database to import the orders_powerbi table.
- Then, the Products dimension table was iported as a csv file.
- Next, a conncection was made to an Azure storage account to import the Stores table.
- Finally, the customers file was unzipped and the 3 files were imported in combinationas the customers table.
- All these 4 tables were then transformed in the Power Query editor to remove any duplicates, unecessary columns, missing values and ensure the column names adhere to Power Bi naming conventions.

## 2: Creating the Data Model

The next stage involved constructing the data model for the project

### Task 1: Making the data table

First, a date table was made to make use of the time intelligence functions. This table runs from the start of the year containing the earliest date in the Orders['Order Date'] column to the end of the year containing the latest date in the Orders['Shipping Date'] column. The DAX formula used to make this table is shown below :

```dax 
Dates = CALENDAR(DATE(2010,1,27),DATE(2023,6,28))
```
Then DAX formulas were used to create the following columns in the date table:

  -Day of Week
  -Month Number 
  -Month Name
  -Quarter
  -Year
  -Start of Year
  -Start of Quarter
  -Start of Month
  -Start of Week

### Task 2: Building the star schema data model

The next step was creating relationships between the tables to form the start schema. The relationships made were:
  - Products[product_code] to Orders[product_code]
  - Stores[store code] to Orders[Store Code]
  - Customers[User UUID] to Orders[User ID]
  - Date[date] to Orders[Order Date]
  - Date[date] to Orders[Shipping Date]

Below is a screenshot of the star schema model from the Power BI file:
![Star Schema model](star_schema.png)

### Task 3: Creating a measures table

Creating a separate table for measures is a best practice that will help us keep our data model organized and easy to navigate. This table was created in the data Model view with the Power Query Editor.

### Task 4 : Creating the key measures

This step involves creating some of the key measures that will be used in this report. These are shown below:

- A measure called Total Orders that counts the number of orders in the Orders table
```dax
Total Orders = COUNTROWS(Orders)```


- A Measure called Total Revenue that multiplies the Orders[Product Quantity] column by the Products[Sale_Price] column for each row, and then sums the result
```dax
Total Revenue = SUMX(Orders,Orders[Product Quantity]*RELATED(Products[Sale Price]))```

- A measure called Total Profit that calculates the profit for each order and then sums the result for all rows :
```dax
Total Profit = SUMX(Orders,Orders[Product Quantity]*(RELATED(Products[Sale Price])-RELATED(Products[Cost Price])))```

- A measure called Total Customers that counts the number of unique customers in the Orders table. 
```dax
Total Customers = DISTINCTCOUNT(Orders[User ID])```

- A measure called Total Quantity that counts the number of items sold in the Orders table
```dax
Total Quantity = SUM(Orders[Product Quantity])```

- A measure called Profit YTD that calculates the total profit for the current year
```dax
Profit YTD = TOTALYTD([Total Profit],Orders[Order Date])```

- A measure called Revenue YTD that calculates the total revenue for the current year
```dax
Revenue YTD = TOTALYTD([Total Revenue],Orders[Order Date])```

### Task 5: Create Date and Geography Hierachies

A date hierachy was made with the following levels:
- Start of Year
- Start of Quarter
- Start of Month
- Start of Week
- Date

Additionally, a geography hierachy was made with the following levels:
- World Region
- Country
- Country Region
  