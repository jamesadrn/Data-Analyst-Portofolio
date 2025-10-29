# 🛍️ Customer Shopping Behavior Analysis (Python + SQL + Power BI)

## 📘 Project Overview
This project analyzes **customer shopping behavior** using **Python, SQL, and Power BI**, inspired by [Amlan Mohanty’s YouTube project — *"COMPLETE Data Analytics Portfolio Project in 6 EASY Steps"*](https://youtu.be/5PrZvPeUw60?si=aLeK8SrQjb_Xd6ui).  

It demonstrates a **complete data analytics workflow** — from raw data cleaning in Python, SQL-based exploration, and business insights visualization in Power BI.

The goal of this project is to:
1. 🧹 Clean and prepare raw customer data for analysis  
2. 📊 Identify **key purchasing patterns** and **customer segments**  
3. 📈 Build an **interactive dashboard** to support data-driven business decisions  

---

## 🎯 Objective
Develop a **data analytics pipeline** that:
- Cleans raw shopping behavior data using Python (Pandas)
- Performs exploratory data analysis (EDA) and SQL-based insights generation  
- Builds a Power BI dashboard visualizing key customer insights  

---

## ⚙️ Data Cleaning & Analysis Workflow

The workflow follows these main steps:

| Step | Description |
|------|--------------|
| **Extract** | Import raw CSV files from `/data/raw` |
| **Transform** | Clean, rename columns, handle nulls, and correct data types using Python |
| **Load** | Save cleaned dataset to `/data/clean` |
| **Analyze (SQL)** | Use SQL queries to answer key business questions |
| **Visualize (Power BI)** | Connect cleaned data to Power BI and design interactive dashboards |

---

### 🧹 Python Data Cleaning (Jupyter Notebook)
All cleaning processes are done in Jupyter Notebook (`/notebooks`), including:
- Handling missing values
- Standardizing column names  
- Exporting the cleaned dataset to `../data/clean/customer_shopping_clean.csv`  

---

### 🧠 SQL Case Study (PostgreSQL)
Located in `/sql`, this stage focuses on:
- Spending behavior vary across gender
- Do purchase amounts differ significantly by gender or discount usage?
- Top rated products 
- Do subscribed cstomers spend more?
etc
---

## 📊 Dataset Information

Dataset: [Customer Shopping Behavior](https://github.com/amlanmohanty1/customer-trends-data-analysis-SQL-Python-PowerBI/blob/main/customer_shopping_behavior.csv)  
- Contains 3,900 retail transactions, detailing customer demographics, purchase details, and shopping preferences.
- Includes attributes such as gender, age, category, purchase amount, location, review rating, discount usage, payment method, and subscription status.
- Designed for data analytics and visualization practice, focusing on customer segmentation, purchase behavior, and sales trend insights.

---

## 📂 Folders in this Repository

| Folders | Description |
|------|--------------|
| `data` | Contains both raw (/raw) and cleaned (/clean) datasets used in the analysis |
| `notebooks` | Jupyter Notebooks for data cleaning, transformation, and exploratory analysis |
| `powerbi` | Dashboard Image |
| `sql` | SQL scripts for analytical case studies and business insights queries |
| `README.md` | Project documentation |

---

## ✍️ Author
**James**  
🎓 Computer Science Student — *Tarumanagara University (Indonesia)*  
📊 Passionate about Data Analytics, SQL Automation, and Business Intelligence  
📍 Jakarta, Indonesia