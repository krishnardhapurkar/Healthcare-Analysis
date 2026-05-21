Create database healthcare;
use healthcare;
select * from dr_table;
select * from lab_table;
select * from patient;
select * from treatment_table;
select * from visit_table;

# KPI

# 1) Total patients
select count(*) as total_patients
from patient;
create view total_patients as
select count(*) as total_patients
from patients;

# 2) Total doctors
select count(*) as total_doctors
from dr_table;
create view total_doctors as
select count(*) as total_doctors
from dr_table;


# 3) Total Visits
select count(*) as total_visits
from visit_table;
create view total_visits as
select count(*) as total_visits
from visit_table;

# 4) Average age of patients
select round( avg(age),2) as Avg_patient_age
from patient;
create view avg_patient_age as
select round(avg(age),2) as Avg_patient_age
from patient;


# 5) Top 5 diagnosed condition
select Diagnosis, count(*) as top_diagnosis
from visit_table
group by Diagnosis
order by top_diagnosis desc
limit 5;
create view top_diagnosis as
select diagnosis, count(*) as top_diagnosis
from visit_table
group by  diagnosis
order by top_diagnosis desc
limit 5;


# 6) Follow-up rate
SELECT 
ROUND(
    COUNT(CASE WHEN `Follow Up Required` = 'Yes' THEN 1 END) * 100.0 / COUNT(*), 2
) AS follow_up_rate
FROM visit_table;


# 7) Treatment cost per visit (avg)
SELECT 
    ROUND(AVG(Visit_Cost), 2) AS Treatment_Cost_Per_Visit
FROM (
    SELECT 
        `Visit ID`,
        SUM(`Treatment Cost`) AS Visit_Cost
    FROM treatment_table
    GROUP BY `Visit ID`
) t;

# 8) Total lab tests conducted
create view total_lab_tests as
SELECT COUNT(*) AS total_lab_tests
FROM lab_table;
select * from total_lab_tests ;

# 9) percentage of abnormal lab result
create view abnormal_lab_result as
SELECT 
    ROUND(
        COUNT(CASE WHEN LOWER(`Test Result`) = 'abnormal' THEN 1 END) * 100.0 
        / COUNT(*), 
    2) AS abnormal_lab_result
FROM lab_table;
select * from abnormal_lab_result

# 10) Doctor workload (avg patients per doctor)
create view doctor_workload as
SELECT 
    ROUND(
        COUNT(DISTINCT `Patient ID`) * 1.0 
        / COUNT(DISTINCT `Doctor ID`), 2) AS avg_patients_per_doctor
FROM visit_table;
select * from doctor_workload;

# 11) Total revenue - Sum(Treatment cost) + sum(visit charges)
create view total_revenue as
SELECT 
    ROUND(
        CAST(
            (SELECT SUM(`Treatment Cost`) FROM treatment_table) +
            (SELECT SUM(cost) FROM treatment_table)
        AS DECIMAL(15,2)) / 1000,2) AS total_revenue;
select * from total_revenue;



