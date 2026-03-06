-- БЛОК 1: Операционная аналитика продаж и сводный реестр сделок.

-- Детальный список всех сделок с именами участников
SELECT 
    o.order_id AS "ID Заказа",
    c.business_name AS "Клиент",
    l.full_name AS "Юрист",
    o.price AS "Сумма",
    o.status AS "Статус"
FROM orders o
JOIN clients c ON o.client_id = c.client_id
JOIN lawyers l ON o.lawyer_id = l.lawyer_id
ORDER BY o.order_id;


-- Отчет по общей выручке в разрезе юристов
SELECT 
    l.full_name AS "Юрист",
    SUM(o.price) AS "Общая выручка",
    COUNT(o.order_id) AS "Количество дел"
FROM lawyers l
JOIN orders o ON l.lawyer_id = o.lawyer_id
GROUP BY l.full_name
ORDER BY "Общая выручка" DESC;


-- БЛОК 2: Временной анализ и Продуктовые метрики (Daily Revenue, AOV)
SELECT 
    order_date::date AS "День", 
    SUM(price) AS "Выручка за день",
    COUNT(order_id) AS "Количество заказов"
FROM orders
GROUP BY "День"
ORDER BY "День" DESC;

-- БЛОК 2: Анализ динамики выручки и среднего чека
SELECT 
    order_date::date AS "Дата", 
    COUNT(order_id) AS "Заказов в день",
    SUM(price) AS "Дневная выручка",
    ROUND(AVG(price), 2) AS "Средний чек (AOV)"
FROM orders
GROUP BY "Дата"
ORDER BY "Дата" DESC;
