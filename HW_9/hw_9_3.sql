--Практическое задание по теме “Хранимые процедуры и функции, триггеры"

--1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток.
--С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна
--возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

DROP PROCEDURE IF EXISTS hello;
--DELIMITER //
CREATE PROCEDURE hello ()
BEGIN
  CASE
    WHEN CURRENT_TIME() BETWEEN '06:00:00' AND '11:59:59'
      THEN SELECT 'Доброе утро';
    WHEN CURRENT_TIME() BETWEEN '12:00:00' AND '17:59:59'
      THEN SELECT 'Добрый день';
    WHEN CURRENT_TIME() BETWEEN '18:00:00' AND '23:59:59'
      THEN SELECT 'Добрый вечер';
    WHEN CURRENT_TIME() BETWEEN '00:00:00' AND '05:59:59'
      THEN SELECT 'Доброй ночи';
  END CASE;
END; --//
--DELIMITER ;

CALL hello();

--2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием.
--Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают
--неопределенное значение NULL неприемлема. Используя триггеры, добейтесь того,
--чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить
--полям NULL-значение необходимо отменить операцию.

USE shop;

DROP TRIGGER IF EXISTS check_products_insert;
--DELIMITER //
CREATE TRIGGER check_products_insert BEFORE INSERT ON products
FOR EACH ROW
BEGIN
  IF NEW.`name` IS NULL OR NEW.description IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT: Both or one of the fields: name, description - must be filled';
  END IF;
END; --//
--DELIMITER ;

DROP TRIGGER IF EXISTS check_products_update;
--DELIMITER //
CREATE TRIGGER check_products_update BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
  IF NEW.`name` IS NULL OR NEW.description IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UPDATE: Both or one of the fields: name, description - must be filled';
  END IF;
END; --//
--DELIMITER ;


--3. (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи.
--Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел.
--Вызов функции FIBONACCI(10) должен возвращать число 55.

DROP FUNCTION IF EXISTS FIBONACCI;
--DELIMITER //
CREATE FUNCTION FIBONACCI (num INT)
RETURNS INT DETERMINISTIC
BEGIN
  DECLARE fibo_sum INT DEFAULT 0;
  DECLARE fibo_1 INT DEFAULT 1;
  DECLARE fibo_2 INT DEFAULT 1;
  DECLARE i INT DEFAULT 0;
  WHILE i < num - 2 DO
    SET fibo_sum = fibo_1 + fibo_2;
    SET fibo_1 = fibo_2;
    SET fibo_2 = fibo_sum;
    SET i = i + 1;
  END WHILE;
  RETURN fibo_2;
END; --//
--DELIMITER ;

SELECT FIBONACCI(10);


