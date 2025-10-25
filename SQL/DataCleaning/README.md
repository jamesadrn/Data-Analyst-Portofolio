# 🧹 Nashville Housing Data Cleaning (PostgreSQL Project)

## 📘 Project Overview
This project focuses on **cleaning and standardizing the Nashville Housing dataset**  
using **PostgreSQL (pgAdmin)**.  
The goal is to ensure data consistency, accuracy, and usability for analysis or visualization.

Inspired by the *Alex The Analyst* data cleaning project,  
this version is written and optimized specifically for **PostgreSQL** syntax.

---

## 🎯 Objectives
- Convert and standardize date formats  
- Populate missing property addresses using self-join logic  
- Split address columns into separate address, city, and state  
- Normalize categorical values (Y/N → Yes/No)  
- Identify and remove duplicate records safely  
- Drop unused columns for a clean final table  

---

## 💾 Dataset Source
📚 **Dataset:** Nashville Housing Data  
📄 **Source:** [Alex The Analyst – Nashville Housing Dataset](https://github.com/AlexTheAnalyst/SQL-Data-Cleaning)  
👤 **Author:** Alexander Freberg  
🗃️ **Modified:** Adapted for PostgreSQL by *James Anderson*

---

## 🧠 Key Cleaning Steps
| Step | Description |
|------|--------------|
| 1️⃣ | Standardized `SaleDate` column format |
| 2️⃣ | Filled missing property addresses using self-join |
| 3️⃣ | Split address fields into city/state components |
| 4️⃣ | Normalized “SoldAsVacant” column values |
| 5️⃣ | Removed duplicates using CTE and ROW_NUMBER() |
| 6️⃣ | Dropped unused columns to finalize dataset |

---

## 🧰 Tools Used
- **PostgreSQL (pgAdmin)** — Data Cleaning and Transformation  
- **SQL Window Functions** — ROW_NUMBER for duplicate detection  
- **Transactions (BEGIN, COMMIT, ROLLBACK)** — Safe deletion process  

---

## 📂 Files in This Folder
| File | Description |
|------|--------------|
| `NashvilleHousing_DataCleaning.sql` | Main SQL script for data cleaning |
| `README.md` | Project documentation |

---

## ✍️ Author
**James Anderson**  
🎓 Tarumanagara University — Computer Science  
📍 Jakarta, Indonesia  
📊 Data Analytics & SQL Development Enthusiast
