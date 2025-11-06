# 🌍 Global Layoffs Analysis (2020–2023)

**Objective:** Analyze worldwide company layoffs between 2020 and 2023 using SQL for data processing and Power BI for visualization.

---

## 📑 Contents
1. [Project Overview](#-project-overview)
2. [Dataset](#-dataset)
3. [How to Use This Project](#-how-to-use-this-project)
4. [Key Insights](#-key-insights)
5. [Skills Demonstrated](#-skills-demonstrated)
6. [File Access](#-file-access)

---

## 🧾 Project Overview

This project analyzes global company layoffs from **2020 to 2023** using **MySQL** for data preparation and **Power BI** for visualization.  
The goal was to identify patterns in workforce reductions across industries, countries, and time, and highlight which companies were most affected.  
The final dashboard provides a clear overview of global layoff trends, industry-level impacts, and cumulative workforce changes over time.

---

## 🗂 Dataset

**Source:** Kaggle — *Global Layoffs Dataset*  
**Period Covered:** 2020–2023  
**Rows:** ~3,000 (depending on updates)  
**Main Columns:**
- `company` — Company name  
- `industry` — Industry sector  
- `country` — Country of headquarters  
- `date` — Layoff date  
- `total_laid_off` — Number of employees laid off  
- `percentage_laid_off` — Proportion of total workforce affected  
- `funds_raised_millions` — Capital raised (if applicable)

---

## 🧭 How to Use This Project

### ⚙️ Running the SQL Scripts
1. Open **MySQL Workbench** (or another SQL client).  
2. Run `layoffs_cleaning.sql` → cleans and prepares the raw dataset.  
3. Run `layoffs_exploratory_analysis.sql` → performs exploratory analysis and aggregations.  
4. Run `layoffs_views_for_powerbi.sql` → creates summary views for Power BI.  
5. Verify the views (e.g., `layoffs_over_time`, `layoffs_by_country`, etc.) appear in your schema.

### 📊 Using the Power BI Dashboard
1. Open `Global_Layoffs_Dashboard.pbix` in **Power BI Desktop**.  
2. Refresh the MySQL data source connection (use your credentials).  
3. Explore visuals including:
   - **Total Layoffs (KPI cards)**  
   - **Layoffs Over Time (Line Chart)**  
   - **Layoffs by Industry (Bar Chart)**  
   - **Layoffs by Country (Map)**  
   - **Top 5 Companies by Year (Bar Chart)**  
4. Use slicers (Year / Industry) for interactivity.

---

## 🔍 Key Insights

- **Layoff Surge in 2022:** Major global increase following post-pandemic market shifts.  
- **Tech Industry Impact:** Technology and finance sectors recorded the largest layoffs.  
- **Regional Patterns:** North America and Europe saw the highest concentrations of job cuts.  
- **Top Companies:** A few major firms accounted for the majority of layoffs each year.  
- **Cumulative Trend:** Layoffs grew consistently from early 2020 through 2023.

---

## 💡 Skills Demonstrated

- **SQL:** Data cleaning, aggregation, CTEs, and window functions for trend analysis.  
- **Power BI:** Dashboard design, data modeling, DAX calculations, and KPI visualization.  
- **Data Storytelling:** Turning raw data into actionable business insights.  
- **Analytical Thinking:** Identifying trends and drivers behind global workforce changes.

---

## 📁 File Access

- 📊 **[Download Power BI Dashboard (.pbix)](PowerBI/Global_Layoffs_Dashboard.pbix)**  
- 💾 **[View SQL Scripts](SQL/)**  
- 🖼 **[Dashboard Preview](Images/dashboard_preview.png)**  

---

### ✨ Author
**Leon Miller**  

🧠 Data Analyst | SQL | Power BI | Data Storytelling


