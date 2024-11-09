-- Task 1
SELECT 
	STR_TO_DATE(t.date_new, '%d/%m/%Y') AS 'Date', 
	ci.Id_client as 'CLient', 
    COUNT(t.Id_check) AS 'Total transactions',
    AVG(t.Sum_payment) AS 'Avegage receipt',
    (SUM(t.Sum_payment) / COUNT(DISTINCT STR_TO_DATE(t.date_new, '%d/%m/%Y') BETWEEN '2015-06-01' AND '2016-06-01')) AS 'Average monthly payment'
FROM customer_info ci
join transactions_info t
on ci.Id_client = t.ID_client
WHERE STR_TO_DATE(t.date_new, '%d/%m/%Y') BETWEEN '2015-06-01' AND '2016-06-01'
group by STR_TO_DATE(t.date_new, '%d/%m/%Y'), ci.Id_client 
order by STR_TO_DATE(t.date_new, '%d/%m/%Y') ASC, ci.Id_client ASC;
-- Task 2
SELECT 
    DATE_FORMAT(STR_TO_DATE(t.date_new, '%d/%m/%Y'), '%Y-%m') AS month,   
    AVG(t.Sum_payment) AS avg_receipt_per_month,
    COUNT(t.Id_check) AS total_operations,    
    COUNT(DISTINCT t.Id_client) AS num_clients,
    COUNT(t.Id_check) / (SELECT COUNT(*) FROM transactions_info WHERE STR_TO_DATE(date_new, '%d/%m/%Y') BETWEEN '2015-06-01' AND '2016-06-01') * 100 AS share_of_total_transactions,
    SUM(t.Sum_payment) / (SELECT SUM(Sum_payment) FROM transactions_info WHERE STR_TO_DATE(date_new, '%d/%m/%Y') BETWEEN '2015-06-01' AND '2016-06-01') * 100 AS share_of_total_amount,
    SUM(CASE WHEN ci.Gender = 'M' THEN t.Sum_payment ELSE 0 END) AS total_male_costs,
    SUM(CASE WHEN ci.Gender = 'F' THEN t.Sum_payment ELSE 0 END) AS total_female_costs,
    SUM(CASE WHEN ci.Gender NOT IN ('M', 'F') THEN t.Sum_payment ELSE 0 END) AS total_na_costs,
    COUNT(CASE WHEN ci.Gender = 'M' THEN 1 END) / COUNT(*) * 100 AS male_ratio,
    COUNT(CASE WHEN ci.Gender = 'F' THEN 1 END) / COUNT(*) * 100 AS female_ratio,
    COUNT(CASE WHEN ci.Gender NOT IN ('M', 'F') THEN 1 END) / COUNT(*) * 100 AS na_ratio
FROM 
    customer_info ci
JOIN 
    transactions_info t 
ON 
    ci.Id_client = t.Id_client
WHERE 
    STR_TO_DATE(t.date_new, '%d/%m/%Y') BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY 
    month
ORDER BY 
    month;
-- Task 3
SELECT 
    CASE 
        WHEN ci.Age IS NULL THEN 'No Age Info'
        WHEN ci.Age BETWEEN 0 AND 9 THEN '0-9'
        WHEN ci.Age BETWEEN 10 AND 19 THEN '10-19'
        WHEN ci.Age BETWEEN 20 AND 29 THEN '20-29'
        WHEN ci.Age BETWEEN 30 AND 39 THEN '30-39'
        WHEN ci.Age BETWEEN 40 AND 49 THEN '40-49'
        WHEN ci.Age BETWEEN 50 AND 59 THEN '50-59'
        WHEN ci.Age BETWEEN 60 AND 69 THEN '60-69'
        WHEN ci.Age BETWEEN 70 AND 79 THEN '70-79'
        WHEN ci.Age BETWEEN 80 AND 89 THEN '80-89'
        ELSE '90+'
    END AS age_group,
    SUM(t.Sum_payment) AS total_amount,
    COUNT(t.Id_check) AS total_transactions,
    AVG(CASE WHEN QUARTER(STR_TO_DATE(t.date_new, '%d/%m/%Y')) = 1 THEN t.Sum_payment ELSE NULL END) AS avg_q1_amount,
    AVG(CASE WHEN QUARTER(STR_TO_DATE(t.date_new, '%d/%m/%Y')) = 2 THEN t.Sum_payment ELSE NULL END) AS avg_q2_amount,
    AVG(CASE WHEN QUARTER(STR_TO_DATE(t.date_new, '%d/%m/%Y')) = 3 THEN t.Sum_payment ELSE NULL END) AS avg_q3_amount,
    AVG(CASE WHEN QUARTER(STR_TO_DATE(t.date_new, '%d/%m/%Y')) = 4 THEN t.Sum_payment ELSE NULL END) AS avg_q4_amount,
    (COUNT(t.Id_check) / (SELECT COUNT(*) FROM transactions_info WHERE STR_TO_DATE(date_new, '%d/%m/%Y') BETWEEN '2015-06-01' AND '2016-06-01')) * 100 AS share_of_total_transactions,
    (SUM(t.Sum_payment) / (SELECT SUM(Sum_payment) FROM transactions_info WHERE STR_TO_DATE(date_new, '%d/%m/%Y') BETWEEN '2015-06-01' AND '2016-06-01')) * 100 AS share_of_total_amount
FROM 
    customer_info ci
JOIN 
    transactions_info t 
ON 
    ci.Id_client = t.Id_client
WHERE 
    STR_TO_DATE(t.date_new, '%d/%m/%Y') BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY 
    age_group
ORDER BY 
    age_group;