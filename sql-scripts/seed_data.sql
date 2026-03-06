INSERT INTO public.clients(
	business_name, inn, contact_phone, email) VALUES 
	('Бест Кофе', '123456789012', '+79991234567', 'ceo@coffee.ru'),
	('ТехноПром', '892322114522', '+79635489185', 'tech@prom.ru'),
	('БьютиЛайн', '256987452365', '+79554785212', 'beauty@line.ru');


INSERT INTO public.lawyers(
	full_name, license_number, experience_years, spesialization, hourly_rate) VALUES
	('Мария Непреклонная', 'LAW-555', 8, 'Трудовые споры', 4000),
	('Иван Быстрый', 'LAW-333', 3, 'Налоги', 2500),
	('Александр Стальной', 'LAW-777', 15, 'Арбитраж', 5000);


INSERT INTO orders (client_id, lawyer_id, price, status) VALUES
(1, 1, 15000, 'in_progress'),
(2, 2, 990, 'completed'),
(3, 1, 5000, 'in_progress'),
(1, 3, 2500, 'completed');
