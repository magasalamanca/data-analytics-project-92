-- Запрос для получения топ-10 продавцов по суммарной выручке
SELECT 
    seller, 
    operations, 
    FLOOR(income) AS income
FROM 
    sellers
ORDER BY 
    income DESC
LIMIT 10;

-- Запрос для получения продавцов с низкой средней выручкой
WITH average_income_all AS (
    SELECT 
        FLOOR(AVG(income / operations)) AS avg_income_all
    FROM 
        sellers
)
SELECT 
    seller, 
    FLOOR(income / operations) AS average_income
FROM 
    sellers
WHERE 
    FLOOR(income / operations) < (SELECT avg_income_all FROM average_income_all)
ORDER BY 
    average_income ASC;

-- Запрос для получения выручки по дням недели
SELECT 
    seller, 
    TO_CHAR(date, 'day') AS day_of_week, 
    FLOOR(SUM(income)) AS income
FROM 
    sales
GROUP BY 
    seller, 
    TO_CHAR(date, 'day'), 
    EXTRACT(DOW FROM date)
ORDER BY 
    EXTRACT(DOW FROM date), 
    seller;