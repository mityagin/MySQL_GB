--Практическое задание теме «Агрегация данных»

--1. Подсчитайте средний возраст пользователей в таблице users.

USE shop;
--Проверяем поля таблицы users
SELECT * FROM users;

--Выведем средний возраст пользователей в таблице users.
SELECT FLOOR(AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW()))) AS average_age FROM users;

--2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
--Следует учесть, что необходимы дни недели текущего года, а не года рождения.

--Выведем количество дней рождения, которые приходятся на каждый из дней недели в 2021 году
SELECT
  DATE_FORMAT(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at)), '%W') AS week,
  COUNT(*) as quantity
FROM users
GROUP BY week
ORDER BY quantity DESC;

--3. (по желанию) Подсчитайте произведение чисел в столбце таблицы.

--Выведем поля какой-нибудь не пустой таблицы, например products
SELECT * FROM products;

--Значения id в таблице products представлены от 1 до 7 включительно
--Подсчитаем произведение чисел в столбце id таблицы products
SELECT EXP(SUM(LN(id))) AS multiply FROM products;






