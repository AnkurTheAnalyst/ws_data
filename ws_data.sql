--Hi, This is just part of my analysis using SQL. As all the data is in 1 table. Joins have not been used. 
-- Most are simply count, min, max, average functions. 

-- Sample Data Check
SELECT TOP 5 * FROM ws_data

-- Checks for total number of records in this table
SELECT COUNT(*) FROM ws_data

-- Checks for unique business_unit_product and its count
SELECT COUNT(*) as business_unit_product_count,business_unit_product FROM ws_data group by business_unit_product

-- SChecks for unique account_canonical_id and its count
SELECT COUNT(*) as account_type_count,account_canonical_id FROM ws_data group by account_canonical_id order by 1 desc

-- Checks for unique automation_status and its count
SELECT COUNT(*) as automation_status_count,automation_status FROM ws_data group by automation_status order by 1 desc

-- Checks for unique parent_institution and its count
SELECT COUNT(*) as _count,parent_institution FROM ws_data group by parent_institution order by 1 desc

-- Checks for unique sending_method and its count
SELECT COUNT(*) as _count,sending_method FROM ws_data group by sending_method order by 1 desc

-- Check for SLA breaches.
SELECT * FROM ws_data WHERE sla_due_at IS NOT NULL AND completed_at > sla_due_at

--Within SLA, the details were as below:
SELECT COUNT(*), automation_status from ws_data where sla_due_at IS NOT NULL AND completed_at > sla_due_at group by automation_status

--What were the sending methods when SLA breached?
SELECT COUNT(*),sending_method from ws_data where sla_due_at IS NOT NULL AND completed_at > sla_due_at group by sending_method

-- Who were the top 5 instutes when the breaches happened?
SELECT top 5 COUNT(*),parent_institution from ws_data where sla_due_at IS NOT NULL AND completed_at > sla_due_at group by parent_institution
order by 1 desc

-- What were the error details majority of the time? 
SELECT TOP 5 COUNT(*),error_details FROM ws_data WHERE error_details IS NOT NULL GROUP BY error_details order by 1 desc

--Lets analyze the cause of manual errors
SELECT TOP 5 COUNT(*),error_details FROM ws_data WHERE automation_status LIKE ('%ERROR%') AND error_details IS NOT NULL
GROUP BY error_details order by 1 desc


--Average, min and max total time in hours
--min_time	max_time	avg_time
--4	4145	393.9
SELECT MIN(total_time_in_hours)as min_time,MAX(total_time_in_hours) as max_time, round(AVG(total_time_in_hours),1) as avg_time FROM ws_data

--Average, min and max processing time in hours
--min_time	max_time	avg_time
--0	0.95	0.07
SELECT MIN(processing_time_in_hours)as min_time,MAX(processing_time_in_hours) as max_time, round(AVG(processing_time_in_hours),2) as avg_time 
FROM ws_data where processing_time_in_hours is not null

--Number of cancellations and Which institues was part of maximum cancellations?
SELECT COUNT(*) FROM ws_data WHERE automation_status  LIKE ('%CANC%')
SELECT TOP 5 COUNT(*),parent_institution FROM ws_data WHERE automation_status LIKE ('%CANC%') AND parent_institution IS NOT NULL
GROUP BY parent_institution order by 1 desc

