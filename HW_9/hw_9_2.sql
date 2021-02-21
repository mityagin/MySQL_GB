--Практическое задание по теме “Администрирование MySQL” (эта тема изучается по вашему желанию)

--1. Создайте двух пользователей которые имеют доступ к базе данных shop.
--Первому пользователю shop_read должны быть доступны только запросы на чтение данных,
--второму пользователю shop — любые операции в пределах базы данных shop.

USE shop;

CREATE USER IF NOT EXISTS 'shop_read'@'%' IDENTIFIED WITH sha256_password BY 'user_password@';
GRANT SELECT ON shop.* TO shop_read;

CREATE USER IF NOT EXISTS 'shop'@'%' IDENTIFIED WITH sha256_password BY 'user_password@';
GRANT ALL ON shop.* TO shop;

DROP USER IF EXISTS 'shop_read'@'%';
DROP USER IF EXISTS 'shop'@'%';

--2. (по желанию) Пусть имеется таблица accounts содержащая три столбца id, name, password,
--содержащие первичный ключ, имя пользователя и его пароль. Создайте представление username таблицы accounts,
--предоставляющий доступ к столбца id и name. Создайте пользователя user_read, который бы не имел доступа
--к таблице accounts, однако, мог бы извлекать записи из представления username.

DROP TABLE IF EXISTS accounts;
CREATE TABLE accounts (
  id SERIAL PRIMARY KEY,
  `name` VARCHAR(255) COMMENT 'Username',
  password CHAR(64) COMMENT 'Password',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Accounts';

INSERT INTO accounts
  (`name`, password)
VALUES
  ('user_1', SHA1('user_1_password@')),
  ('user_2', SHA1('user_2_password@')),
  ('user_3', SHA1('user_3_password@')),
  ('user_4', SHA1('user_4_password@')),
  ('user_5', SHA1('user_5_password@'));

DROP VIEW IF EXISTS username;
CREATE VIEW username (id, `name`) AS SELECT id, `name` FROM accounts;

CREATE USER IF NOT EXISTS 'user_read'@'%' IDENTIFIED WITH sha256_password BY 'user_password@';
GRANT SELECT ON shop.username TO user_read;

DROP USER IF EXISTS 'user_read'@'%';

