-- Запрос для получения количества покупателей в разных возрастных группах
SELECT 
    CASE
        WHEN age BETWEEN 16 AND 25 THEN '16-25'
        WHEN age BETWEEN 26 AND 40 THEN '26-40'
        ELSE '40+'
    END AS age_category,
    COUNT(*) AS age_count
FROM 
    customers
GROUP BY 
    age_category
ORDER BY 
    age_category;

-- Запрос для получения количества уникальных покупателей и выручки по месяцам
SELECT 
    TO_CHAR(sale_date, 'YYYY-MM') AS date,
    COUNT(DISTINCT customer_id) AS total_customers,
    FLOOR(SUM(income)) AS income
FROM 
    sales
GROUP BY 
    TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY 
    date ASC;

-- Запрос для получения покупателей, первая покупка которых была во время акций
WITH first_purchase AS (
    SELECT 
        customer_id,
        MIN(sale_date) AS first_sale_date
    FROM 
        sales
    WHERE 
        price = 0
    GROUP BY 
        customer_id
)
SELECT 
    c.first_name || ' ' || c.last_name AS customer,
    fp.first_sale_date AS sale_date,
    s.seller_first_name || ' ' || s.seller_last_name AS seller
FROM 
    first_purchase fp
JOIN 
    customers c ON fp.customer_id = c.customer_id
JOIN 
    sales s ON fp.customer_id = s.customer_id AND fp.first_sale_date = s.sale_date
ORDER BY 
    c.customer_id;