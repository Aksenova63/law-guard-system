# Структура данных

### Содержание:

05.1 Реестр пользователей (Users)

05.2  Профили Клиентов (Clients)

05.3 Профили Юристов (Lawyers)

05.4 Журнал заявок (Requests)

05.5 Таблица Счетов (invoices)

05.6 Таблица международных переводов international_payment

05.7 Спецификация API (JSON)

05.8 Типовые аналитические запросы (SQL)



05.1 Таблица Реестр пользователей (Users)

user_id (PK (Первичный ключ), Auto-increment, integer)

email (VARCHAR, UNIQUE, NOT NULL)

password_hash (Хэш пароля пользователя, string, (VARCHAR, UNIQUE, NOT NULL)

role (VARCHAR), Роль: client или lawyer

created_at (CURRENT_TIMESTAMP, Дата и время регистрации)

last_login (CURRENT_TIMESTAMP)



['steel.alex @gmail.com', hash_123, lawyer, '2025-05-15', '2025-06-11'];

['ivan_bystry@gmail.com', iv23_9,  lawyer, '2025-11-20', '2025-11-24'];

['maria_wise@ya.ru', m_01234,  lawyer, '2026-01-10', '2026-03-10'];

['ann_need@ya.ru', a3456,  client, '2026-03-01', '2026-03-11'];

['peter_vic@rambler.com', 23pet_1,  client, '2026-03-15', '2026-03-25'];

['elena_prot22@mail.ru', el_289, client, '2026-03-20', '2026-04-20'];



SQL запрос

CREATE TABLE users (

user_id SERIAL PRIMARY KEY, --  PK и Auto-increment одновременно

email VARCHAR(150) UNIQUE NOT NULL, -- Логин: уникально и обязательно

password_hash VARCHAR(255) NOT NULL, -- Хэш: безопасность превыше всего

role VARCHAR(20) NOT NULL

CHECK (role IN ('client', 'lawyer')), -- Клиент или юрист

created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Время регистрации

last_login TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Время последнего входа

);





05.2 Таблица Профили Юристов (Lawyers)

lawyer_id (PK, FK (ссылка на users.user_id), integer)

full_name (VARCHAR) — ФИО)

speciality (VARCHAR, UNIQUE)

rating (Рейтинг юриста (DECIMAL(10, 2))

lawyer_status (pending/active, Default pending, VARCHAR)

experience_years (INT (стаж в годах))

diploma_url (ссылка на скан диплома юриста, лицензии и прочих документов, которые будут видны клиенту, (VARCHAR))

inn (VARCHAR(12), UNIQUE)



['Александр Стальной', 'Уголовное право', '4.9', 'active', 10, <diploma_url>, '726358748956'];

['Иван Быстрый',  'Арбитраж / ДТП', '4.7', 'active', 2, <diploma_url>, '721455681452'];

['Мария Мудрая', 'Семейное право', '5.0', 'active', 5, <diploma_url>, '723654859654'];



SQL запрос



CREATE TABLE lawyers (

lawyer_id INT PRIMARY KEY REFERENCES users(user_id), -- PK и FK одновременно

full_name VARCHAR(255) NOT NULL,

speciality VARCHAR(150) NOT NULL,

rating DECIMAL(3, 2) DEFAULT 0.00, -- 3 цифры всего, 2 после запятой (например 4.95)

lawyer_status VARCHAR(20) DEFAULT 'pending'

CHECK (lawyer_status IN ('pending', 'active')),

experience_years INT DEFAULT 0,

diploma_url VARCHAR(500),

inn VARCHAR(12) UNIQUE NOT NULL

);



05.3  Таблица Профили Клиентов (Clients)

user_id (FK (ссылка на users.user_id), integer)

client_id ((PK, Auto-increment, INT) — Личный ID клиента.)

client_name (Имя клиента, (VARCHAR, NOT NULL))

client_phone (Телефон для связи, (VARCHAR, UNIQUE, NOT NULL))

client_type (VARCHAR(25), NOT NULL physical, legal_entity, individual_entrepreneur)

inn (VARCHAR (12), NULLABLE)





['Анна Нужда',  +'79025544516', physical, NULL];

['Петр Пострадавший', '+79022254514', physical, NULL];

['Елена Защищенная', '+79577255817', physical, NULL];

['ООО Вектор', '+79991112233',  'legal_entity', '6316001122'];



SQL запрос



CREATE TABLE clients (

client_id SERIAL PRIMARY KEY, --  PK и Auto-increment

user_id INT UNIQUE NOT NULL REFERENCES users(user_id), -- Крюк к аккаунту

client_name VARCHAR(255) NOT NULL,

client_phone VARCHAR(20) UNIQUE NOT NULL,

client_type VARCHAR(30) NOT NULL

CHECK (client_type IN ('physical', 'legal_entity', 'individual_entrepreneur')),

inn VARCHAR(12) -- По умолчанию Nullable

);



05.4 Таблица Журнал заявок (Requests)

request_id (PK, Auto-increment, INT)

client_id (FK, INT) - Клиент

lawyer_id (FK, INT, NULL) - Юрист (пока не назначен на данном этапе)

service_type (VARCHAR) -Тип дела

cost (DECIMAL(10,2)) - Цена.

request_description (TEXT) —Описание проблемы

request_status (VARCHAR) - 'open' / 'in_progress' / 'closed'

tariff_plan (VARCHAR, NOT NULL) - 'Base' / 'Expert'

file_url (VARCHAR) - Сканы документов клиента

expired_at (TIMESTAMP) - Срок актуальности заявки

region (VARCHAR) - Регион

created_at (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP) — Дата и время публикации заявки.



[1, 101, 201, 'Развод', 25000.00, 'Муж скрывает доходы, ушел к другой, хочу отсудить долю в бизнесе. Срочно!', 'in_progress', 'Expert', 's3.link/dogovor_brak.pdf', '2026-03-30', 'Тюмень', '2026-03-23 09:15:00'];

[2, 102, NULL, 'Алименты', 5000.00, 'Нужна помощь в подаче заявления на твердую денежную сумму. Бывший не работает официально.', 'open', 'Base', NULL, '2026-04-10', 'Тольятти', '2026-03-23 14:30:25'];

[3, 103, 203, 'ДТП', 45000.00, 'Столкновение на перекрестке, виновник скрылся, есть запись с регистратора. Нужно взыскать ущерб.', 'open', 'Expert', 's3.link/video_dtp.mp4', '2026-03-25', 'Москва', '2026-03-23 23:10:12'];



SQL запрос



CREATE TABLE requests (

request_id SERIAL PRIMARY KEY,

client_id INT NOT NULL,

lawyer_id INT, -- Может быть NULL, пока юрист не выбран

service_type VARCHAR(100) NOT NULL,

cost DECIMAL(10,2) DEFAULT 0.00,

request_description TEXT,

request_status VARCHAR(20) DEFAULT 'open'

CHECK (request_status IN ('open', 'in_progress', 'closed')),

tariff_plan VARCHAR(20) NOT NULL

CHECK (tariff_plan IN ('Base', 'Expert')),

file_url VARCHAR(500),

expired_at TIMESTAMP,

region VARCHAR(100),

created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

CONSTRAINT fk_client FOREIGN KEY (client_id) REFERENCES clients(client_id),

CONSTRAINT fk_lawyer FOREIGN KEY (lawyer_id) REFERENCES lawyers(lawyer_id)

);



05.5 Таблица Счетов (invoices)

invoice_id: (PK, Auto-increment, INT) - Уникальный номер счета.

request_id: (FK, INT, NOT NULL) - ID заявки

amount: (DECIMAL(10,2), NOT NULL) - Сумма

client_type: (VARCHAR, NOT NULL) - physical / legal_entity/individual_entrepreneur

status: (VARCHAR, DEFAULT 'pending') - pending (выставлен), paid (оплачен), canceled (отменен)



[101, 15000.00, 'physical', 'paid'];

[102, 5000.00, 'physical', 'pending'] ;

[103, 50000.00, 'legal_entity', 'paid'] ;

[104, 25000.00, 'individual_entrepreneur', 'canceled'];



SQL запрос



CREATE TABLE invoices (

invoice_id SERIAL PRIMARY KEY,

request_id INT NOT NULL,

amount DECIMAL(10,2) NOT NULL CHECK (amount >= 0),

status VARCHAR(20) DEFAULT 'pending'

CHECK (status IN ('pending', 'paid', 'canceled')),

created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

CONSTRAINT fk_request FOREIGN KEY (request_id) REFERENCES requests(request_id)

);





05.6 Таблица международных переводов international_payment



CREATE TABLE international_payment (

payment_id BIGINT PRIMARY KEY,

currency VARCHAR(10) NOT NULL,

sender_name VARCHAR(100) NOT NULL,

sender_country VARCHAR(50) NOT NULL,

recipient_name VARCHAR(100) NOT NULL,

recipient_country VARCHAR(50) NOT NULL,

amount DECIMAL(15,2) NOT NULL CHECK (amount > 0),

commission DECIMAL(15,2) DEFAULT 0.00,

payment_status VARCHAR(20) DEFAULT 'initiated'

CHECK (payment_status IN ('initiated', 'verification', 'completed')),

payment_result VARCHAR(20)

CHECK (payment_result IN ('passed', 'in_progress', 'failed')),

responsible_department VARCHAR(50),

intermediary_bank VARCHAR(50),

execution_date DATE

);





05.7 Спецификация API (JSON)

Пример JSON-ответа для профиля юриста

```json

{

"lawyer_id": 1,

"full_name": "Александр Стальной",

"specialization": "Criminal Law",

"experience_years": 12,

"rating": 4.9,

"is_verified": true,

"contacts": {

"email": "steel.alex@lawguard.com",

"phone": "+79998887766"

},

"bio": "Упрямый как скала, надежный как код. Специализируюсь на защите сложных систем."

}

```



05.8 Типовые аналитические запросы (SQL)



Простая фильтрация (Выборка по условию)

SELECT * FROM lawyersWHERE status = 'active' AND rating > 4.5ORDER BY rating DESC;



Склейка данных (Клиент, юрист и общая заявка)

SELECT c.client_name AS cn, l.full_name AS fn, r.service_type AS stFROM requests AS rJOIN clients AS c ON r.client_id = c.client_idJOIN lawyers AS l ON r.lawyer_id = l.lawyer_id;



Финансовая агрегация

SELECT l.full_name, SUM(r.cost) AS total_sumFROM requests AS rJOIN lawyers AS l ON r.lawyer_id = l.lawyer_idGROUP BY l.full_nameHAVING SUM(r.cost) > 10000ORDER BY total_sum DESC;
