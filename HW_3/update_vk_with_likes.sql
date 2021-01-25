-- MySQL Workbench Synchronization
-- Generated: 2021-01-25 14:43
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: v

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

ALTER TABLE `vk`.`profiles` 
DROP FOREIGN KEY `fk_profiles_media1`;

ALTER TABLE `vk`.`messages` 
DROP FOREIGN KEY `fk_messages_users1`,
DROP FOREIGN KEY `fk_messages_users2`;

ALTER TABLE `vk`.`friend_requests` 
DROP FOREIGN KEY `fk_friend_requests_users1`,
DROP FOREIGN KEY `fk_friend_requests_users2`;

ALTER TABLE `vk`.`media` 
DROP FOREIGN KEY `fk_media_media_types1`,
DROP FOREIGN KEY `fk_media_users1`;

ALTER TABLE `vk`.`communities` 
DROP FOREIGN KEY `fk_communities_users1`;

ALTER TABLE `vk`.`users_communities` 
DROP FOREIGN KEY `fk_users_communities_communities1`,
DROP FOREIGN KEY `fk_users_communities_users1`;

ALTER TABLE `vk`.`users` 
CHANGE COLUMN `phone` `phone` BIGINT(12) NOT NULL ;

ALTER TABLE `vk`.`friend_requests` 
CHANGE COLUMN `status` `status` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '-1 - отклонен\n0 - запрос\n1 - принят' ,
CHANGE COLUMN `updated_at` `updated_at` DATETIME NULL DEFAULT NULL ON UPDATE NOW() ;

ALTER TABLE `vk`.`media` 
CHANGE COLUMN `file` `file` VARCHAR(45) NULL DEFAULT NULL COMMENT '/files/folder/file.jpg\n\n' ;

CREATE TABLE IF NOT EXISTS `vk`.`users_likes` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `users_id` INT(10) UNSIGNED NOT NULL,
  `likes_types_id` INT(10) UNSIGNED NOT NULL,
  `like_target_id` INT(10) UNSIGNED NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  PRIMARY KEY (`id`),
  INDEX `fk_users_likes_users1_idx` (`users_id` ASC) VISIBLE,
  INDEX `fk_users_likes_likes_types1_idx` (`likes_types_id` ASC) VISIBLE,
  INDEX `fk_like_target_id_idx` (`like_target_id` ASC) VISIBLE,
  CONSTRAINT `fk_users_likes_users1`
    FOREIGN KEY (`users_id`)
    REFERENCES `vk`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_likes_likes_types1`
    FOREIGN KEY (`likes_types_id`)
    REFERENCES `vk`.`likes_types` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_like_target_id_messages`
    FOREIGN KEY (`like_target_id`)
    REFERENCES `vk`.`messages` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_like_target_id_media`
    FOREIGN KEY (`like_target_id`)
    REFERENCES `vk`.`media` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_like_target_id_users`
    FOREIGN KEY (`like_target_id`)
    REFERENCES `vk`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `vk`.`likes_types` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

ALTER TABLE `vk`.`profiles` 
DROP FOREIGN KEY `fk_profiles_users_users_id`;

ALTER TABLE `vk`.`profiles` ADD CONSTRAINT `fk_profiles_users_users_id`
  FOREIGN KEY (`users_id`)
  REFERENCES `vk`.`users` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_profiles_media1`
  FOREIGN KEY (`photo_id`)
  REFERENCES `vk`.`media` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `vk`.`messages` 
ADD CONSTRAINT `fk_messages_users1`
  FOREIGN KEY (`from_users_id`)
  REFERENCES `vk`.`users` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_messages_users2`
  FOREIGN KEY (`to_users_id`)
  REFERENCES `vk`.`users` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `vk`.`friend_requests` 
ADD CONSTRAINT `fk_friend_requests_users1`
  FOREIGN KEY (`from_users_id`)
  REFERENCES `vk`.`users` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_friend_requests_users2`
  FOREIGN KEY (`to_users_id`)
  REFERENCES `vk`.`users` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `vk`.`media` 
ADD CONSTRAINT `fk_media_media_types1`
  FOREIGN KEY (`media_types_id`)
  REFERENCES `vk`.`media_types` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_media_users1`
  FOREIGN KEY (`users_id`)
  REFERENCES `vk`.`users` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `vk`.`communities` 
ADD CONSTRAINT `fk_communities_users1`
  FOREIGN KEY (`admin_id`)
  REFERENCES `vk`.`users` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `vk`.`users_communities` 
ADD CONSTRAINT `fk_users_communities_communities1`
  FOREIGN KEY (`communities_id`)
  REFERENCES `vk`.`communities` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_users_communities_users1`
  FOREIGN KEY (`users_id`)
  REFERENCES `vk`.`users` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
