--1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
USE shop;

SELECT
  u.name,
  COUNT(o.user_id) total
FROM users u JOIN orders o ON u.id = o.user_id
GROUP BY u.id
ORDER BY total DESC;

--2. Выведите список товаров products и разделов catalogs, который соответствует товару.
SELECT p.name, c.name product_type FROM products p JOIN catalogs c ON p.catalog_id = c.id;

--3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name).
--Поля from, to и label содержат английские названия городов, поле name — русское.
--Выведите список рейсов flights с русскими названиями городов.

--Создаем таблицы
CREATE TABLE IF NOT EXISTS flights (
  id SERIAL PRIMARY KEY,
  `from` VARCHAR(255) COMMENT 'Город вылета',
  `to` VARCHAR(255) COMMENT 'Город прибытия'
) COMMENT = 'Полеты';

CREATE TABLE IF NOT EXISTS cities (
  label VARCHAR(255) COMMENT 'Английское название города',
  name VARCHAR(255) COMMENT 'Русское название города'
) COMMENT = 'Города';

--Заполняем таблицы данными из примера
INSERT INTO flights
  (`from`, `to`)
VALUES
  ('moscow', 'omsk'),
  ('novgorod', 'kazan'),
  ('irkutsk', 'moscow'),
  ('omsk', 'irkutsk'),
  ('moscow', 'kazan');

INSERT INTO cities
  (label, name)
VALUES
  ('moscow', 'Москва'),
  ('irkutsk', 'Иркутск'),
  ('novgorod', 'Новгород'),
  ('kazan', 'Казань'),
  ('omsk', 'Омск');

--Выводим список рейсов flights с русскими названиями городов.
SELECT
  c.name from_city,
  c1.name to_city
FROM flights f
JOIN cities c ON c.label = f.`from`
JOIN cities c1 ON c1.label = f.`to`
ORDER BY f.id;

--Удаляем таблицы flights и cities
DROP TABLE IF EXISTS flights;
DROP TABLE IF EXISTS cities;


