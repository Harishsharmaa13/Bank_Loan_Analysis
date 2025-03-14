-- 1. Retrieve All Records from Bank Loan Table
SELECT * FROM bank_loan;

-- 2. Total Count of Records
SELECT COUNT(*) AS Total_Loan_Records FROM bank_loan;

-- 3. Disable Safe Updates to Allow Data Modification
SET SQL_SAFE_UPDATES = 0;

-- 4. Convert String Dates to MySQL DATE Format
UPDATE bank_loan
SET 
    issue_date = STR_TO_DATE(issue_date, '%d-%m-%Y'),
    last_credit_pull_date = STR_TO_DATE(last_credit_pull_date, '%d-%m-%Y'),
    last_payment_date = STR_TO_DATE(last_payment_date, '%d-%m-%Y'),
    next_payment_date = STR_TO_DATE(next_payment_date, '%d-%m-%Y');

-- 5. Alter Columns to Ensure Proper Data Type
ALTER TABLE bank_loan
MODIFY issue_date DATE,
MODIFY last_credit_pull_date DATE,
MODIFY last_payment_date DATE,
MODIFY next_payment_date DATE;

-- 6. Check for Duplicate Records Based on ID
SELECT id, COUNT(*) AS Duplicate_Count 
FROM bank_loan
GROUP BY id 
HAVING COUNT(*) > 1;

-- 7. Table Structure Verification
DESC bank_loan;
DESC customers;

-- 8. Find the Latest Issue Date
SELECT MAX(issue_date) AS Latest_Issue_Date FROM bank_loan;

-- 9. Calculate Total Loan Applications
SELECT COUNT(id) AS Total_Loan_Applications FROM bank_loan;

-- 10. Calculate Month-to-Date (MTD) Loan Applications (December 2021)
SELECT COUNT(id) AS MTD_Total_Loan_Applications 
FROM bank_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- 11. Calculate Previous Month-to-Date (PMTD) Loan Applications (November 2021)
SELECT COUNT(id) AS PMTD_Total_Loan_Applications 
FROM bank_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- 12. Month-over-Month (MoM) Loan Application Growth
WITH MTD AS (
    SELECT COUNT(id) AS MTD_Applications FROM bank_loan
    WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
),
PMTD AS (
    SELECT COUNT(id) AS PMTD_Applications FROM bank_loan
    WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021
)
SELECT ((MTD.MTD_Applications - PMTD.PMTD_Applications) / PMTD.PMTD_Applications) * 100 AS MoM_Loan_Growth
FROM MTD, PMTD;

-- 13. Total Funded Loan Amount
SELECT SUM(loan_amount) AS Total_Funded_Amount FROM bank_loan;

-- 14. Month-to-Date (MTD) Funded Amount
SELECT SUM(loan_amount) AS MTD_Funded_Amount FROM bank_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- 15. Previous Month-to-Date (PMTD) Funded Amount
SELECT SUM(loan_amount) AS PMTD_Funded_Amount FROM bank_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- 16. Month-over-Month (MoM) Funded Amount Growth
WITH MTD AS (
    SELECT SUM(loan_amount) AS MTD_Funded FROM bank_loan
    WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
),
PMTD AS (
    SELECT SUM(loan_amount) AS PMTD_Funded FROM bank_loan
    WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021
)
SELECT ((MTD.MTD_Funded - PMTD.PMTD_Funded) / PMTD.PMTD_Funded) * 100 AS MoM_Funded_Growth
FROM MTD, PMTD;

-- 17. Total Payment Received
SELECT SUM(total_payment) AS Total_Received_Amount FROM bank_loan;

-- 18. Month-to-Date (MTD) Payment Received
SELECT SUM(total_payment) AS MTD_Total_Received FROM bank_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- 19. Previous Month-to-Date (PMTD) Payment Received
SELECT SUM(total_payment) AS PMTD_Total_Received FROM bank_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- 20. Month-over-Month (MoM) Payment Growth
WITH MTD AS (
    SELECT SUM(total_payment) AS MTD_Payment FROM bank_loan
    WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
),
PMTD AS (
    SELECT SUM(total_payment) AS PMTD_Payment FROM bank_loan
    WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021
)
SELECT ((MTD.MTD_Payment - PMTD.PMTD_Payment) / PMTD.PMTD_Payment) * 100 AS MoM_Payment_Growth
FROM MTD, PMTD;

-- 21. Average Interest Rate
SELECT AVG(int_rate) * 100 AS Avg_Int_Rate FROM bank_loan;

-- 22. Average Debt-to-Income Ratio (DTI)
SELECT AVG(dti) * 100 AS Avg_DTI FROM bank_loan;

-- 23. Loan Status Breakdown
SELECT 
    loan_status, 
    COUNT(id) AS Loan_Count, 
    SUM(total_payment) AS Total_Amount_Received,
    SUM(loan_amount) AS Total_Funded_Amount,
    AVG(int_rate * 100) AS Avg_Int_Rate,
    AVG(dti * 100) AS Avg_DTI
FROM bank_loan
GROUP BY loan_status;

-- 24. Loan Analysis by State
SELECT 
    address_state AS State, 
    COUNT(id) AS Total_Applications, 
    SUM(loan_amount) AS Total_Funded, 
    SUM(total_payment) AS Total_Received
FROM bank_loan
GROUP BY address_state
ORDER BY address_state;

-- 25. Loan Analysis by Term
SELECT 
    term, 
    COUNT(id) AS Total_Applications, 
    SUM(loan_amount) AS Total_Funded, 
    SUM(total_payment) AS Total_Received
FROM bank_loan
GROUP BY term
ORDER BY term;

-- 26. Loan Analysis by Employee Length
SELECT 
    emp_length AS Employee_Length, 
    COUNT(id) AS Total_Applications, 
    SUM(loan_amount) AS Total_Funded, 
    SUM(total_payment) AS Total_Received
FROM bank_loan
GROUP BY emp_length
ORDER BY emp_length;

-- 27. Loan Analysis by Purpose
SELECT 
    purpose AS Loan_Purpose, 
    COUNT(id) AS Total_Applications, 
    SUM(loan_amount) AS Total_Funded, 
    SUM(total_payment) AS Total_Received
FROM bank_loan
GROUP BY purpose
ORDER BY purpose;

-- 28. Loan Analysis by Home Ownership 
SELECT 
    home_ownership AS Home_Ownership, 
    COUNT(id) AS Total_Applications, 
    SUM(loan_amount) AS Total_Funded, 
    SUM(total_payment) AS Total_Received
FROM bank_loan
GROUP BY home_ownership
ORDER BY home_ownership;

