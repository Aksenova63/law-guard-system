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
