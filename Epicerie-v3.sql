-- MySQL Script generated by MySQL Workbench
-- Sun Feb 15 11:20:10 2015
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema epicerie_a_rabais_v3
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema epicerie_a_rabais_v3
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `epicerie_a_rabais_v3` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `epicerie_a_rabais_v3` ;

-- -----------------------------------------------------
-- Table `epicerie_a_rabais_v3`.`website`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `epicerie_a_rabais_v3`.`website` (
  `website_id` INT NOT NULL AUTO_INCREMENT,
  `website_url` VARCHAR(255) NOT NULL,
  `website_name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`website_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `epicerie_a_rabais_v3`.`product_store`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `epicerie_a_rabais_v3`.`product_store` (
  `store_id` INT NOT NULL,
  `store_name` VARCHAR(100) NOT NULL,
  `store_slug` VARCHAR(100) NULL,
  `website_id` INT NOT NULL,
  PRIMARY KEY (`store_id`),
  INDEX `fk_website_id` (`website_id` ASC),
  CONSTRAINT `fk_website_id`
    FOREIGN KEY (`website_id`)
    REFERENCES `epicerie_a_rabais_v3`.`website` (`website_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `epicerie_a_rabais_v3`.`product_category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `epicerie_a_rabais_v3`.`product_category` (
  `category_id` INT NOT NULL AUTO_INCREMENT,
  `category_name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`category_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `epicerie_a_rabais_v3`.`product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `epicerie_a_rabais_v3`.`product` (
  `product_id` INT NOT NULL AUTO_INCREMENT,
  `product_description` VARCHAR(256) NOT NULL,
  `product_size` VARCHAR(100) NOT NULL,
  `product_origin` VARCHAR(100) NULL,
  `product_introducted` DATE NOT NULL,
  `product_thumbnail` VARCHAR(256) NOT NULL,
  `product_sku` INT NOT NULL,
  `product_store_id` INT NOT NULL,
  `product_category_id` INT NOT NULL,
  PRIMARY KEY (`product_id`),
  INDEX `fk_product_store_id` (`product_store_id` ASC),
  INDEX `fk_product_category_id` (`product_category_id` ASC),
  CONSTRAINT `fk_product_store_id`
    FOREIGN KEY (`product_store_id`)
    REFERENCES `epicerie_a_rabais_v3`.`product_store` (`store_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_product_category_id`
    FOREIGN KEY (`product_category_id`)
    REFERENCES `epicerie_a_rabais_v3`.`product_category` (`category_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `epicerie_a_rabais_v3`.`product_price`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `epicerie_a_rabais_v3`.`product_price` (
  `price_id` INT NOT NULL AUTO_INCREMENT,
  `price_price` DOUBLE NOT NULL,
  `price_rebate` DOUBLE NOT NULL,
  `price_rebate_percent` INT NOT NULL,
  `price_start` DATE NOT NULL,
  `price_end` DATE NOT NULL,
  `price_active` TINYINT(1) NOT NULL,
  `price_note` VARCHAR(256) NULL,
  `price_quantity` INT NOT NULL,
  `product_id` INT NOT NULL,
  PRIMARY KEY (`price_id`),
  INDEX `fk_product_id` (`product_id` ASC),
  CONSTRAINT `fk_product_price_product`
    FOREIGN KEY (`product_id`)
    REFERENCES `epicerie_a_rabais_v3`.`product` (`product_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `epicerie_a_rabais_v3`.`website_category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `epicerie_a_rabais_v3`.`website_category` (
  `category_id` INT NOT NULL AUTO_INCREMENT,
  `category_name` VARCHAR(100) NOT NULL,
  `category_slug` VARCHAR(100) NOT NULL,
  `website_id` INT NOT NULL,
  `product_category_id` INT NOT NULL,
  PRIMARY KEY (`category_id`),
  INDEX `fk_category_website_id` (`website_id` ASC),
  INDEX `fk_website_product_category_id` (`product_category_id` ASC),
  CONSTRAINT `fk_category_website_id`
    FOREIGN KEY (`website_id`)
    REFERENCES `epicerie_a_rabais_v3`.`website` (`website_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_website_product_category_id`
    FOREIGN KEY (`product_category_id`)
    REFERENCES `epicerie_a_rabais_v3`.`product_category` (`category_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `epicerie_a_rabais_v3` ;

-- -----------------------------------------------------
-- Placeholder table for view `epicerie_a_rabais_v3`.`active_product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `epicerie_a_rabais_v3`.`active_product` (`product_id` INT, `product_description` INT, `product_size` INT, `product_origin` INT, `product_introduced` INT, `product_thumbnail` INT, `product_sku` INT, `price_price` INT, `price_rebate` INT, `price_rebate_percent` INT, `price_start` INT, `price_end` INT, `price_note` INT, `price_quantity` INT, `store_name` INT, `category_name` INT);

-- -----------------------------------------------------
-- View `epicerie_a_rabais_v3`.`active_product`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `epicerie_a_rabais_v3`.`active_product`;
USE `epicerie_a_rabais_v3`;
CREATE  OR REPLACE VIEW `active_product` AS
    SELECT 
        product_id,
        product_description,
        product_size,
        product_origin,
        product_introduced,
        product_thumbnail,
        product_sku,
        price_price,
        price_rebate,
        price_rebate_percent,
        price_start,
        price_end,
        price_note,
        price_quantity,
        store_name,
        category_name
    FROM
        product
            INNER JOIN
        product_price ON product.product_id = product_price.product_id
            INNER JOIN
        product_category ON product_category_id = category_id
            INNER JOIN
        product_store ON product_store_id = store_id
	WHERE
		price_active = 1
;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;



