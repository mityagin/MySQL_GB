--Практическое задание по теме «Операторы, фильтрация, сортировка и ограничение»

--1. Пусть в таблице users поля created_at и updated_at оказались незаполненными.
--Заполните их текущими датой и временем.

USE shop;
--Проверяем необходимые поля таблицы
SELECT created_at, updated_at FROM users;

--Удаляем данные если поля заполнены
UPDATE users
SET
  created_at = NULL,
  updated_at = NULL
WHERE
  created_at IS NOT NULL AND updated_at IS NOT NULL
FROM users;

--Проверяем необходимые поля таблицы
SELECT created_at, updated_at FROM users;

--Заполняем текущими датой и временем
UPDATE users
SET
  created_at = NOW(),
  updated_at = NOW()
WHERE
  created_at IS NULL AND updated_at IS NULL
FROM users;

--Проверяем поля таблицы
SELECT * FROM users;


--2. Таблица users была неудачно спроектирована.
--Записи created_at и updated_at были заданы типом VARCHAR
--и в них долгое время помещались значения в формате 20.10.2017 8:10.
--Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.

--Проверяем тип необходимых для изменения полей
SELECT
  COLUMN_NAME, DATA_TYPE
FROM
  information_schema.`COLUMNS`
WHERE
  TABLE_SCHEMA = 'shop' AND TABLE_NAME = 'users' AND COLUMN_NAME LIKE '%ed_at';

--Меняем тип необходимых для изменения полей на VARCHAR
ALTER TABLE users CHANGE created_at created_at VARCHAR(255);
ALTER TABLE users CHANGE updated_at updated_at VARCHAR(255);

--Снова проверяем тип необходимых для изменения полей
SELECT
  COLUMN_NAME, DATA_TYPE
FROM
  information_schema.`COLUMNS`
WHERE
  TABLE_SCHEMA = 'shop' AND TABLE_NAME = 'users' AND COLUMN_NAME LIKE '%ed_at';

--Проверяем поля таблицы
SELECT * FROM users;

--Преобразовываем необходимые поля к типу DATETIME
ALTER TABLE users CHANGE created_at created_at DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE users CHANGE updated_at updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

--Снова проверяем тип необходимых для изменения полей
SELECT
  COLUMN_NAME, DATA_TYPE
FROM
  information_schema.`COLUMNS`
WHERE
  TABLE_SCHEMA = 'shop' AND TABLE_NAME = 'users' AND COLUMN_NAME LIKE '%ed_at';

--Проверяем поля таблицы
SELECT * FROM users;

--3. В таблице складских запасов storehouses_products в поле value
--могут встречаться самые разные цифры: 0, если товар закончился и выше нуля,
--если на складе имеются запасы. Необходимо отсортировать записи таким образом,
--чтобы они выводились в порядке увеличения значения value.
--Однако нулевые запасы должны выводиться в конце, после всех записей.

--Проверяем поля таблицы
SELECT * FROM storehouses_products;

--Таблица пустая. Заполним ее некоторыми данными
INSERT INTO storehouses_products (storehouse_id, product_id, `value`)
VALUES
  (1, 2354, 489),
  (1, 827, 42),
  (1, 93, 0),
  (1, 7831, 167),
  (1, 73, 0),
  (1, 123, 8576),
  (1, 384, 0);

--Снова проверяем поля таблицы
SELECT * FROM storehouses_products;

--Выполняем запрос с сортировкой
SELECT * FROM storehouses_products ORDER BY IF(`value` > 0, 0, 1), `value`;

--Удаляем данные из таблицы
DELETE FROM storehouses_products;

--Снова проверяем поля таблицы. Таблица пуста
SELECT * FROM storehouses_products;

--4. (по желанию) Из таблицы users необходимо извлечь пользователей,
--родившихся в августе и мае. Месяцы заданы в виде списка английских названий (may, august)

--Проверяем поля таблицы
SELECT * FROM users;

--Выполняем запрос с условием
SELECT * FROM users WHERE DATE_FORMAT(birthday_at, '%M') IN ('may', 'august');

--5. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса.
--SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке,
--заданном в списке IN.

--Проверяем поля таблицы
SELECT * FROM catalogs;

--Выполняем запрос с условием и сортировкой
SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY FIELD(id, 5, 1, 2);





