Create Database PhonePe_Analysis;

use PhonePe_Analysis;

-- 1. What is the total number of registered users by region for each year and quarter?

SELECT State, Year, Quarter, Region, SUM(Registered_users) AS Total_Registered_Users
FROM (
    SELECT State, Year, Quarter, Region, Registered_users FROM top_user_pin
    UNION ALL
    SELECT State, Year, Quarter, Region, Registered_users FROM top_user_dist
) AS users
GROUP BY State, Year, Quarter, Region
ORDER BY Year, Quarter, Region;


-- 2. What is the total transaction count and amount by district, year, and quarter?

SELECT State, Year, Quarter, District, SUM(Transaction_count) AS Total_Transaction_Count, 
       SUM(Transaction_amount) AS Total_Transaction_Amount
FROM (
    SELECT State, Year, Quarter, District, Transaction_count, Transaction_amount FROM top_trans_dist
    UNION ALL
    SELECT State, Year, Quarter, District, Transaction_count, Transaction_amount FROM map_trans
) AS transactions
GROUP BY State, Year, Quarter, District
ORDER BY Year, Quarter, District;


-- 3. How do the registered users compare to the transaction count at the district level by year and quarter?

SELECT u.State, u.Year, u.Quarter, u.District, u.Registered_users, t.Transaction_count
FROM (
    SELECT State, Year, Quarter, District, Registered_users FROM map_user
) AS u
LEFT JOIN (
    SELECT State, Year, Quarter, District, Transaction_count FROM map_trans
) AS t
ON u.State = t.State AND u.Year = t.Year AND u.Quarter = t.Quarter AND u.District = t.District
ORDER BY u.Year, u.Quarter, u.District;


-- 4. Which districts have the highest and lowest transaction amounts over time?

SELECT District, Year, Quarter, SUM(Transaction_amount) AS Total_Transaction_Amount
FROM top_trans_dist
GROUP BY District, Year, Quarter
ORDER BY Total_Transaction_Amount DESC;


-- 5. What is the total transaction count by brand (from agg_user table) for each year and quarter?

SELECT State, Year, Quarter, Brand, SUM(Transaction_count) AS Total_Transaction_Count
FROM agg_user
GROUP BY State, Year, Quarter, Brand
ORDER BY Year, Quarter, Brand;


-- 6. What is the breakdown of transaction types (from agg_trans) for each region over time?

SELECT State, Year, Quarter, Region, Transaction_type, SUM(Transaction_count) AS Total_Transaction_Count
FROM agg_trans
GROUP BY State, Year, Quarter, Region, Transaction_type
ORDER BY Year, Quarter, Region, Transaction_type;


-- 7. What is the relationship between registered users and app opens at the district level?

SELECT u.State, u.Year, u.Quarter, u.District, u.Registered_users, m.App_opens
FROM map_user AS u
LEFT JOIN map_user AS m
ON u.State = m.State AND u.Year = m.Year AND u.Quarter = m.Quarter AND u.District = m.District
ORDER BY u.Year, u.Quarter, u.District;


-- 8. What is the percentage growth in registered users compared to transaction amounts by region?

SELECT users.State, users.Year, users.Quarter, users.Region, 
       SUM(users.Registered_users) AS Total_Registered_Users, 
       SUM(transactions.Transaction_amount) AS Total_Transaction_Amount,
       (SUM(transactions.Transaction_amount) / SUM(users.Registered_users)) AS Avg_Transaction_Per_User
FROM (
    SELECT State, Year, Quarter, Region, Registered_users FROM top_user_pin
    UNION ALL
    SELECT State, Year, Quarter, Region, Registered_users FROM top_user_dist
) AS users
LEFT JOIN (
    SELECT State, Year, Quarter, Region, Transaction_amount FROM top_trans_pin
    UNION ALL
    SELECT State, Year, Quarter, Region, Transaction_amount FROM top_trans_dist
) AS transactions
ON users.State = transactions.State 
   AND users.Year = transactions.Year 
   AND users.Quarter = transactions.Quarter 
   AND users.Region = transactions.Region
GROUP BY users.State, users.Year, users.Quarter, users.Region
ORDER BY users.Year, users.Quarter, users.Region;


-- 9. How do the transaction amounts correlate with the user registration at the pin code level over time?

SELECT p.State, p.Year, p.Quarter, p.Pincode, SUM(p.Registered_users) AS Total_Registered_Users,
       SUM(t.Transaction_amount) AS Total_Transaction_Amount
FROM top_user_pin AS p
LEFT JOIN top_trans_pin AS t
ON p.State = t.State AND p.Year = t.Year AND p.Quarter = t.Quarter AND p.Pincode = t.Pincode
GROUP BY p.State, p.Year, p.Quarter, p.Pincode
ORDER BY Year, Quarter, Pincode;


-- 10. Which regions have the highest user engagement (app opens vs. registered users)?

SELECT State, Year, Quarter, Region, SUM(App_opens) AS Total_App_Opens, SUM(Registered_users) AS Total_Registered_Users,
       (SUM(App_opens) / SUM(Registered_users)) AS Engagement_Rate
FROM map_user
GROUP BY State, Year, Quarter, Region
ORDER BY Engagement_Rate DESC;




