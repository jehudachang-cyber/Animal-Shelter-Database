# Animal Shelter Relational Database Management System (Oracle SQL)

## 📌 Project Overview
This project features a fully normalized relational database designed to centralize and manage the daily operations, veterinary care, workforce scheduling, and financial transactions of a high-volume animal shelter[cite: 10, 11, 14]. 

Transitioning away from manual paper-based record-keeping, this database architecture eliminates data redundancy, enforces strict data integrity, and supports complex analytical queries to drive operational efficiency, track animal welfare, and audit financial contributions[cite: 10, 11, 14, 15, 29].

---

## 🏗️ Database Architecture & Business Rules
The relational schema consists of **14 interconnected tables** managing core shelter domains[cite: 36]:

* **Animal & Veterinary Care:** `animal`, `veterinarian`, `vet_shift`, `health_check`, `treatment`[cite: 36]
* **Workforce & Task Coordination:** `personnel`, `personnel_shift`, `task`, `duty`[cite: 36]
* **Public Engagement & Financials:** `adopter`, `adoption`, `donor`, `donation`, `transaction`[cite: 36]

### Data Integrity & Validation Highlights
* **Regex Pattern Matching (`REGEXP_LIKE`):** Enforces valid Malaysian Identity Card (IC) formats (`^\d{6}-\d{2}-\d{4}$`), mobile and landline phone numbers (`^(\+?60)?(1[0-9]{8,9}|[3-9][0-9]{7,8})$`), and standard email structures across personnel, vet, donor, and adopter records[cite: 23, 24, 25, 26, 36].
* **Domain & Range Constraints:** Restricts animal health ratings (`1` to `5`), animal ages (`0` to `30`), personnel working age limits (`15` to `65`), non-negative weights (`>= 0`), and standardized status tracking (`Under Treatment`, `Available for Adoption`, `Deceased`)[cite: 26, 27, 28, 36].
* **Composite Primary Keys:** Implemented across junction and operational tables (`duty`, `donation`, `health_check`, `treatment`, `adoption`, `vet_shift`, `personnel_shift`) to accurately model many-to-many relationships and prevent duplicate shift scheduling or double-adoptions[cite: 12, 13, 14, 15, 16, 36].

---

## 📊 Key Analytical Queries
Beyond schema creation and data population, this project implements analytical SQL queries to answer critical operational and business questions[cite: 29, 30, 31, 32, 33, 34]:

### 1. Comprehensive Adoption Status Audit (Outer Join)
Provides staff with a complete roster of all shelter animals alongside their adoption status and adopter contact details, highlighting both adopted and currently available animals[cite: 29].
```sql
SELECT 
    a.AnimalID AS "Animal ID",
    a.Animal_Name AS "Animal Name",
    adp.AdopterID AS "Adopter ID",
    adp.Adopter_Name AS "Adopter Name",
    adp.Adopter_ContactNumber AS "Contact Number of adopter",
    ad.Adoption_Date AS "Adoption date"
FROM Animal a
LEFT JOIN Adoption ad ON a.AnimalID = ad.AnimalID
LEFT JOIN Adopter adp ON ad.AdopterID = adp.AdopterID
ORDER BY "Animal ID";
```

### 2. Adoption Revenue & Adopter Activity (4-Table Join & Aggregation)
Calculates the total number of animals adopted and total transaction revenue generated per adopter to identify top contributors and evaluate financial health[cite: 30].
```sql
SELECT 
    adp.AdopterID AS "Adopter ID",
    adp.Adopter_Name AS "Adopter Name",
    COUNT(a.AnimalID) AS "Number of animals adopted",
    SUM(tr.Amount) AS "Transaction amount"
FROM Animal a
JOIN Adoption ad ON a.AnimalID = ad.AnimalID
JOIN Transaction tr ON ad.TransactionID = tr.TransactionID
JOIN Adopter adp ON ad.AdopterID = adp.AdopterID
GROUP BY adp.AdopterID, adp.Adopter_Name
ORDER BY adp.AdopterID;
```

### 3. Annual Monetary Donation Tracking (String Pattern Matching & Date Functions)
Filters financial contributions using case-insensitive string matching and date formatting to isolate monetary donations received within a specific calendar year (2025)[cite: 30, 31].
```sql
SELECT * 
FROM donation
WHERE LOWER(donation_type) LIKE 'monetary%'
  AND TO_CHAR(donation_date, 'YYYY') = '2025';
```

### 4. Medical Diagnosis & Check-up Audit (Compound Logical Operators)
Retrieves specific veterinary treatment records by combining partial string matching (`LIKE`) with `AND`/`OR` logic to audit diagnostic and check-up procedures performed in 2024[cite: 31, 32].
```sql
SELECT * 
FROM treatment
WHERE (treatment_type LIKE '%Check%' OR treatment_type LIKE '%Diagnosis%')
  AND TO_CHAR(treatment_date, 'YYYY') = '2024';
```

### 5. Unadopted High-Care Animals (Nested Subqueries & Left Join)
Identifies animals that have never been adopted despite receiving more than the shelter's average number of health checkups—helping management prioritize long-term residents for targeted adoption drives[cite: 32, 33].
```sql
SELECT a.AnimalID, a.Animal_Name, a.Species, hc.NumChecks
FROM animal a
JOIN (
    SELECT AnimalID, COUNT(*) AS NumChecks
    FROM health_check
    GROUP BY AnimalID
) hc ON a.AnimalID = hc.AnimalID
LEFT JOIN adoption ad ON a.AnimalID = ad.AnimalID
WHERE ad.AnimalID IS NULL
  AND hc.NumChecks > (
      SELECT AVG(NumChecks)
      FROM (
          SELECT AnimalID, COUNT(*) AS NumChecks
          FROM health_check
          GROUP BY AnimalID
      )
  )
ORDER BY hc.NumChecks DESC;
```

### 6. Long-Term Healthy Residents (Date Arithmetic & Filtering)
Finds animals residing in the shelter for over a year (`SYSDATE - 365`) that consistently achieve the highest health rating (`5`), identifying ideal candidates for sponsorship programs or health studies[cite: 33, 34].
```sql
SELECT 
    a.AnimalID, 
    a.Animal_Name, 
    a.Species, 
    a.Intake_Date, 
    COUNT(hc.Health_Rating) AS Positive_Rating_Count
FROM animal a
JOIN health_check hc ON a.AnimalID = hc.AnimalID
WHERE a.Intake_Date <= SYSDATE - 365
  AND hc.Health_Rating = 5
GROUP BY a.AnimalID, a.Animal_Name, a.Species, a.Intake_Date
ORDER BY Positive_Rating_Count DESC;
```

---

## 🛠️ Technical Stack
* **Database Dialect:** Oracle SQL (APEX / SQL*Plus compatible)[cite: 29]
* **Core Competencies:** Relational Data Modeling (ERD), Database Normalization, DDL & DML Scripting, Regex Data Validation, Multi-Table Joins, Nested Subqueries, Aggregate Reporting[cite: 4, 17, 23, 29, 30, 32, 36].

## 📁 Repository Contents
* `animal_shelter_db.sql`: Complete DDL and DML script to drop/create tables, enforce constraints, and populate the database with realistic sample records[cite: 29, 36].
* `README.md`: Documentation of system architecture, business rules, and analytical SQL queries[cite: 9, 16, 29].
