--Практическое задание по теме “Транзакции, переменные, представления”

--1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных.
--Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

-- Начинаем транзакцию
START TRANSACTION;
-- Проверяем есть ли такие строки в таблицах
SELECT * FROM shop.users WHERE id = 1;
SELECT * FROM sample.users WHERE id = 1;
-- Выполняем запрос на копирование данных из shop в sample
INSERT INTO sample.users SELECT * FROM shop.users WHERE id = 1;
-- Выполняем запрос на удаление данных из shop
DELETE FROM shop.users WHERE id = 1;
-- Проверяем, что данные в таблицу sample добавились
SELECT * FROM sample.users WHERE id = 1;
-- Проверяем, что данные из таблицы shop удалились
SELECT * FROM shop.users WHERE id = 1;
-- Коммитим изменения. Завершаем транзакцию успешно
COMMIT;

-- Возвращаем данные в базах shop и sample к первоначальному значению
INSERT INTO shop.users SELECT * FROM sample.users WHERE id = 1;
DELETE FROM sample.users WHERE id = 1;


--2. Создайте представление, которое выводит название name товарной позиции из таблицы products
--и соответствующее название каталога name из таблицы catalogs.

USE shop;
-- Создаем представление product_type
CREATE VIEW product_type AS
SELECT
  name 'product name',
  (SELECT name FROM catalogs WHERE id = products.catalog_id) 'product type'
FROM products;
-- Проверяем данные в представлении
SELECT * FROM product_type;
-- Удаляем представление для чистоты эксперимента
DROP VIEW IF EXISTS product_type;


--3. (по желанию) Пусть имеется таблица с календарным полем created_at.
--В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16'
--и 2018-08-17. Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1,
--если дата присутствует в исходном таблице и 0, если она отсутствует.

-- Создаем таблицу some_august_dates и заполняем ее разреженными календарными записями за август 2018 года:
-- '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17
DROP TABLE IF EXISTS some_august_dates;
CREATE TEMPORARY TABLE some_august_dates (
  created_at DATE
);

INSERT INTO some_august_dates
VALUES
  ('2018-08-01'),
  ('2018-08-04'),
  ('2018-08-16'),
  ('2018-08-17');

-- Вариант a) в нескольких запросах при помощи дополнительных таблиц
-- Создаем временные таблицы ids и dates с датами с полями id и created_at соответственно
DROP TABLE IF EXISTS ids;
DROP TABLE IF EXISTS dates;
CREATE TEMPORARY TABLE ids (id INT);
CREATE TEMPORARY TABLE dates (created_at DATE);

-- Наполням временную таблицу ids значениями id
INSERT INTO ids
VALUES
  (1), (2), (3), (4), (5), (6), (7), (8), (9), (10),
  (11), (12), (13), (14), (15), (16), (17), (18), (19), (20),
  (21), (22), (23), (24), (25), (26), (27), (28), (29), (30), (31);

-- Наполняем временную таблицу dates датами с 1 по 31 августа 2018
INSERT INTO dates
  SELECT '2018-08-01' + INTERVAL (id - 1) DAY FROM ids;

-- Удаляем временную уже ненужную таблицу ids
DROP TABLE IF EXISTS ids;

-- Выполняем запрос
SELECT
  d.created_at,
  IF (d.created_at = s.created_at, 1, 0) bool
FROM dates d
LEFT JOIN some_august_dates s ON d.created_at = s.created_at;


-- Вариант b) в одном запросе
SELECT
  d.august_dates,
  IF (d.august_dates = s.created_at, 1, 0) bool
FROM (SELECT * FROM
  (SELECT ADDDATE('2018-08-01', temp.i) august_dates FROM
    (SELECT 0 i UNION SELECT 1 UNION SELECT 2  UNION SELECT 3  UNION SELECT 4  UNION SELECT 5  UNION SELECT 6
     UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION SELECT 11 UNION SELECT 12 UNION SELECT 13
     UNION SELECT 14 UNION SELECT 15 UNION SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20
     UNION SELECT 21 UNION SELECT 22 UNION SELECT 23 UNION SELECT 24 UNION SELECT 25 UNION SELECT 26 UNION SELECT 27
     UNION SELECT 28 UNION SELECT 29 UNION SELECT 30) temp) vertical) d
LEFT JOIN some_august_dates s ON d.august_dates = s.created_at;


--4. (по желанию) Пусть имеется любая таблица с календарным полем created_at.
--Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.

-- Создаем таблицу с данными dates_new, копированием из временной таблицы dates, поскольку временная таблица
-- не подойдет для реализуемого запроса (в рамках одного запроса к ней нельзя обратиться дважды)
DROP TABLE IF EXISTS dates_new;
CREATE TABLE dates_new (
  created_at DATE
);

INSERT INTO dates_new SELECT * FROM dates;

-- Создаем запрос и удаляем устаревшие даты
DELETE
  dates_new
FROM
  dates_new
JOIN
  (SELECT created_at FROM dates_new ORDER BY created_at DESC LIMIT 5, 1) last_dates
ON dates_new.created_at <= last_dates.created_at;






