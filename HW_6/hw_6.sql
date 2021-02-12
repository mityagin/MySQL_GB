--1. Проанализировать запросы, которые выполнялись на занятии, определить возможные
--корректировки и/или улучшения (JOIN пока не применять).

--На уроке был представлен следующий запрос:
SELECT
  media_types_id,
  (SELECT name FROM media_types WHERE media_types.id = media.media_types_id) AS media_type_name,
  COUNT(*)
FROM media
GROUP BY media_types_id;

--Есть предложение его оптимизировать следующим образом (ниже:) и не использовать в данном случае группировку GROUP BY
SELECT
  id,
  name,
  (SELECT COUNT(media_types_id) FROM media WHERE media.media_types_id = media_types.id) AS count
FROM media_types;

--2. Пусть задан некоторый пользователь.
--Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
USE vk_new;
--Пусть задан пользователь с id = 66
SELECT
  id user_id,
  (SELECT
    from_users_id
  FROM messages
  WHERE to_users_id = users.id AND from_users_id IN (SELECT IF(from_users_id = users.id, to_users_id, from_users_id) FROM friend_requests WHERE status = 1)
  GROUP BY from_users_id
  ORDER BY COUNT(from_users_id) DESC LIMIT 1) friend_id_with_a_lot_of_messages
FROM users WHERE id = 66;

--3. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.
--N.B.: Не предусматривали в схемах лайки самих пользователей, поэтому по договоренности:
--Можно сделать подсчёт кол-ва лайков от пользователя, либо если это легко, то посчитать все лайки к медиа,
--постам и сообщениям пользователя

--подсчёт кол-ва лайков от пользователя
SELECT
  users_id,
  COUNT(media_id) media_likes,
  COUNT(messages_id) messages_likes,
  COUNT(posts_id) posts_likes,
  (COUNT(media_id) + COUNT(messages_id) + COUNT(posts_id)) total
FROM likes WHERE users_id = 86;

--посчитать все лайки к медиа, постам и сообщениям пользователя
SELECT
  (SELECT COUNT(users_id) FROM likes WHERE messages_id IN (SELECT id FROM messages WHERE from_users_id = users.id)) user_messages_likes,
  (SELECT COUNT(users_id) FROM likes WHERE media_id IN (SELECT id FROM media WHERE users_id = users.id)) user_media_likes,
  (SELECT COUNT(users_id) FROM likes WHERE posts_id IN (SELECT id FROM posts WHERE users_id = users.id)) user_posts_likes
FROM users WHERE id = 17;

--4. Определить кто больше поставил лайков (всего) - мужчины или женщины?
SELECT (SELECT gender FROM profiles WHERE users_id = likes.users_id) gender, COUNT(users_id) likes_count FROM likes GROUP BY gender;

--5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.
SELECT
  id,
  (SELECT COUNT(users_id) FROM likes WHERE users_id = users.id) likes_activity,
  (SELECT COUNT(id) FROM posts WHERE users_id = users.id) posts_activity,
  (SELECT COUNT(id) FROM media WHERE users_id = users.id) media_activity,
  (SELECT COUNT(id) FROM messages WHERE from_users_id = users.id) messages_activity
FROM users ORDER BY (likes_activity + posts_activity + media_activity + messages_activity) LIMIT 10;

