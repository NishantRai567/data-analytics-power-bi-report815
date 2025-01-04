# data-analytics-power-bi-report815

## Importing the data into Power Bi 

### The dataset consists of 4 tables: An Orders fact table, and dimension tables for Products,Stores and Customers. 

The first stage of this project involved data loading and preparation.
- Firstly, a conncection was made to an Azure SQL database to import the orders_powerbi table.
- Then, the Products dimension table was iported as a csv file.
- Next, a conncection was made to an Azure storage account to import the Stores table.
- Finally, the customers file was unzipped and the 3 files were imported in combinationas the customers table.
- All these 4 tables were then transformed in the Power Query editor to remove any duplicates, unecessary columns, missing values and ensure the column names adhere to Power Bi naming conventions.

## Creating the Data Model

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
![Star Schema model](image.png)

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

## Building the Customer Details Page

In this step, a report page was created to focus on customer-level analysis.

### Task 1:Creating Headline Card Visuals

Card Visuals were created for total distinct customers and revenue per customer:

- Firstly, two rectangle shaped were inserted as the bacground for the visuals.
- A card visual was then created for the [Total Customers] measure. This was renamed as 'Unique Customers'.
- Next, a new measure called [Revenue per Customer] was added to the Measures Table and a card visual was created for this

### Task 2: Creating the Summary Charts

- A Donut Chart visual showing the total customers for each country was made. This was done by using the Customers[Country] column to filter the [Total Customers] measure

- A second Donut Chart visual was made, using the Products[Category] column to filter the [Total Customers] measure. This shows the number of customers who purchased each product category.

### Creating a line chart of the weekly distinct customers

-Here, a Line Chart visual was added to the top of the page. It shows [Total Customers] on the Y axis, and uses the Date Hierarchy for the X axis. It allow users to drill down to the month level, but not to weeks or individual dates.

-A trend line was added, in additon to a forecast line for the next 10 periods with a 95% confidence interval

### Task 4: Creating the Top 20 Customers Table

-A new table was created, which displays the top 20 customers, filtered by revenue. The table shows each customer's full name, revenue, and number of orders.

- Additional conditional formatting was added to the revenue column, in order to display data bars for the revenue values

### Task 5: Creating the Top Customer Cards

- New measures were created for the [Name of the Top Customer],[Orders made by Top Customer] and [Revenue made by Top Customer]. The DAX formula is shown below:

```dax 
Name of Top Customer = TOPN(1, VALUES(Customers[Full Name]), [Total Revenue], DESC),
Orders made by Top Customer = CALCULATE([Total Orders],TOPN(1,VALUES(Customers[Full Name]),[Total Revenue],DESC)),
Revenue made by Top Customer = CALCULATE([Total Revenue],TOPN(1,VALUES(Customers[Full Name]),[Total Revenue],DESC))
```

- A set of three card visuals were added.These provide insights into the top customer by revenue. They display the top customer's name, the number of orders made by the customer, and the total revenue generated by the customer.

### Task 6: Add a Date Slicer

Finally, a date slicer was added to allow users to filter the page by year.

Below is a screenshot of the finished report page:

![customer-details page](image-1.png)

## Building the Executive Summary Page

A report page was created for the high-level executive summary. The purpose of this page is to give a n overview of the company's performance as a whole, so that C-suite exceutives can quickly gather insights and check outcomes against key targets.

### Task 1: Creating card Visuals

- Card visuals were made for the Total Revenue, Total Orders and Total Profit measures. 
- The Callout values were formatted so that only 2 decimals places are shown for the Total Profits and revenue and 1 decimal place for the Total Orders.
- The 3 Card Visuals were arranged so they span half the width of the page

### Task 2: Adding a Revenue Trending Line Chart

- A line chart was made with the x-axis set to the date hierachy and y-axis set to the Total Revenue. 
- This chart was positioned below the card visuals.

### Task 3: Adding Donut Charts for Revenue by Country and Store Type

- A pair of donut charts were cretaed, showing Total Revenue broken down by Store[Country] and Store[Store Type] respectively.

### Task 4: Adding a Bar Chart of Orders by Product Category

- A clustered bar chart was made with Total Orders on the x axis and Product Category on the y axis.
- The chart was then formatted with an approriate colour theme

### Task 5: Adding KPI Visuals

- New measures were created for:
  - Previous Quarter Profit
    ```dax
    Previous Quarter Profit = CALCULATE([Total Profit],PREVIOUSQUARTER(Dates[Date]))
    ```
  - Previous Quarter Revenue
    ```dax
    Previous Quarter Revenue = CALCULATE([Total Revenue],PREVIOUSQUARTER(Dates[Date]))
  - Previous Quarter Orders
   ```dax
   Previous Quarter Orders = CALCULATE([Total Orders],PREVIOUSQUARTER(Dates[Date]))
   ```
  - Targets, equal to 5% growth in each measure compared to the previous quarter

- A KPI was then made for the revenue:
  - The Value field was set to the Total Revenue
  - The Trend Axis was set to the Start of Quarter
  - The Target was set to the Target Revenue

- In the Format pane, with the Trend axis set to On, the following values were set:
  - Direction : High is Good
  - Bad Colour : red
  - Transparency : 15%

- This was repeated for the Profit and Orders cards with the approriate values

- The 3 KPI visuals were then arranged below the revenue trending line Chart

-A screenshot of the finished report page is shown below:

![Executive Summary Page](image-2.png)


