--1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users,
--catalogs и products в таблицу logs помещается время и дата создания записи, название таблицы,
--идентификатор первичного ключа и содержимое поля name.

USE shop;

DROP TABLE IF EXISTS logs;

CREATE TABLE logs (
  created_at DATETIME NOT NULL,
  table_name VARCHAR(255) NOT NULL,
  primary_id INT NOT NULL,
  with_name VARCHAR(255)
) ENGINE = ARCHIVE;

DROP TRIGGER IF EXISTS logger_users;
--DELIMITER //
CREATE TRIGGER logger_users AFTER INSERT ON users
FOR EACH ROW
BEGIN
  INSERT INTO logs (created_at, table_name, primary_id, with_name)
  VALUES (
    NOW(),
    'users',
    NEW.id,
    NEW.name
  );
END; --;
--DELIMITER ;

DROP TRIGGER IF EXISTS logger_catalogs;
--DELIMITER //
CREATE TRIGGER logger_catalogs AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
  INSERT INTO logs (created_at, table_name, primary_id, with_name)
  VALUES (
    NOW(),
    'catalogs',
    NEW.id,
    NEW.name
  );
END; --;
--DELIMITER ;

DROP TRIGGER IF EXISTS logger_products;
--DELIMITER //
CREATE TRIGGER logger_products AFTER INSERT ON products
FOR EACH ROW
BEGIN
  INSERT INTO logs (created_at, table_name, primary_id, with_name)
  VALUES (
    NOW(),
    'products',
    NEW.id,
    NEW.name
  );
END; --;
--DELIMITER ;

--Добавим значения в таблицы users, catalogs, products и проверим, что таблица logs заполняется:
INSERT INTO users
  (name, birthday_at)
VALUES
  ('name1', '1970-01-01');

INSERT INTO catalogs
  (name)
VALUES
  ('Phones'),
  ('Cameras');

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Iphone 12 Pro', 'Phones', 110000, 1);

SELECT * FROM logs;

-- Удалим ранее внесенные записи в таблицы для чистоты эксперимента
DELETE FROM users WHERE name = 'name1';
DELETE FROM catalogs WHERE name LIKE '%s';
DELETE FROM products WHERE name = 'Iphone 12 Pro';

--2. (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.

-- Создадим временную таблицу mil_users

DROP TABLE IF EXISTS mil_users;

CREATE TEMPORARY TABLE mil_users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  birthday_at DATE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

--Добавим 1 миллион пользователей в таблицу test_users:
INSERT INTO mil_users
  (id, name, birthday_at)
SELECT
  N, CONCAT('user', N), NOW()
FROM
  (
  SELECT a.N + b.N * 10 + c.N * 100 + d.N * 1000 + e.N * 10000 + f.N * 100000 + 1 N
  FROM (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a
        , (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b
        , (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) c
        , (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) d
        , (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) e
        , (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) f
  ) t;

--Проверим 10 строк в таблице test_users для примера и убедимся, что количество записей равно 1 млн:
SELECT * FROM mil_users LIMIT 10;

SELECT COUNT(*) AS total FROM mil_users;
