# Animal Shelter Relational Database Management System (Oracle SQL)

## 📌 Project Overview
This project features a fully normalized relational database (3NF) designed to centralize and manage the daily operations, veterinary care, workforce scheduling, and financial transactions of a high-volume animal shelter. 

Transitioning away from manual record-keeping, this database architecture enforces strict data integrity and supports complex analytical queries to drive operational efficiency, track animal welfare, and audit financial contributions.

---

## 🏗️ Database Architecture & Business Rules
The relational schema consists of **14 interconnected tables** managing core shelter domains:

* **Animal & Veterinary Care:** `animal`, `veterinarian`, `vet_shift`, `health_check`, `treatment`
* **Workforce & Task Coordination:** `personnel`, `personnel_shift`, `task`, `duty`
* **Public Engagement & Financials:** `adopter`, `adoption`, `donor`, `donation`, `transaction`

### Data Integrity & Validation Highlights
* **Regex Pattern Matching (`REGEXP_LIKE`):** Enforces valid Malaysian Identity Card (IC) formats (`^\d{6}-\d{2}-\d{4}$`), mobile/landline phone numbers (`^(\+?60)?1[0-9]{8,9}$`), and standard email structures across personnel, vet, donor, and adopter records.
* **Domain & Range Constraints:** Restricts animal health ratings (`1` to `5`), working age limits (`15` to `65`), non-negative weights, and standardized status tracking (`Under Treatment`, `Available for Adoption`, `Deceased`).
* **Composite Primary Keys:** Implemented across junction tables (`duty`, `donation`, `health_check`, `treatment`, `adoption`, `vet_shift`, `personnel_shift`) to accurately model many-to-many relationships and prevent duplicate scheduling or double-adoptions.

---

## 📊 Key Analytical Queries
Beyond schema creation and data population, this project implements analytical SQL queries to answer critical operational and business questions:

### 1. Adoption Revenue & Adopter Activity (4-Table Join & Aggregation)
Calculates the total number of animals adopted and total transaction revenue generated per adopter to identify top contributors and assess financial health.
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
