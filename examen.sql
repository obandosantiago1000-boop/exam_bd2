

-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema proyecto
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `proyecto`;

-- -----------------------------------------------------
-- Schema proyecto
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `proyecto` DEFAULT CHARACTER SET utf8;
USE `proyecto`;

-- -----------------------------------------------------
-- Table `proyecto`.`persona`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `proyecto`.`persona`;

CREATE TABLE IF NOT EXISTS `proyecto`.`persona` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `telefono` VARCHAR(45) NOT NULL,
  `direccion` VARCHAR(45) NOT NULL,
  `correo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`)
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `proyecto`.`cliente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `proyecto`.`cliente`;

CREATE TABLE IF NOT EXISTS `proyecto`.`cliente` (
  `id` INT NOT NULL,
  `clase` ENUM('preferencial', 'comun') NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `c_1_fk`
    FOREIGN KEY (`id`)
    REFERENCES `proyecto`.`persona` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `proyecto`.`repartidor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `proyecto`.`repartidor`;

CREATE TABLE IF NOT EXISTS `proyecto`.`repartidor` (
  `id` INT NOT NULL,
  `zona` VARCHAR(45) NOT NULL,
  `estado` ENUM('disponible', 'no disponible') NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `1_r_fk`
    FOREIGN KEY (`id`)
    REFERENCES `proyecto`.`persona` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `proyecto`.`pizza`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `proyecto`.`pizza`;

CREATE TABLE IF NOT EXISTS `proyecto`.`pizza` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `tamanio` ENUM('grande', 'mediana', 'chica') NOT NULL,
  `precio_base` DOUBLE NOT NULL,
  `tipo` ENUM('clasica', 'especial', 'vegetariana') NOT NULL,
  PRIMARY KEY (`id`)
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `proyecto`.`ingrediente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `proyecto`.`ingrediente`;

CREATE TABLE IF NOT EXISTS `proyecto`.`ingrediente` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `stock` DOUBLE NOT NULL,
  `unidad_medida` ENUM('kg', 'litros', 'unidades') NOT NULL,
  `stock_minimo` DOUBLE NOT NULL,
  `costo_unitario` DOUBLE NOT NULL,
  PRIMARY KEY (`id`)
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `proyecto`.`pizza_ingrediente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `proyecto`.`pizza_ingrediente`;

CREATE TABLE IF NOT EXISTS `proyecto`.`pizza_ingrediente` (
  `pizza_fk` INT NOT NULL,
  `ingrediente_fk` INT NOT NULL,
  `cantidad_ingrediente` DOUBLE NOT NULL,
  INDEX `1_pi_fk_idx` (`pizza_fk` ASC) VISIBLE,
  INDEX `2_pi_fk_idx` (`ingrediente_fk` ASC) VISIBLE,
  CONSTRAINT `1_pi_fk`
    FOREIGN KEY (`pizza_fk`)
    REFERENCES `proyecto`.`pizza` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `2_pi_fk`
    FOREIGN KEY (`ingrediente_fk`)
    REFERENCES `proyecto`.`ingrediente` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `proyecto`.`pedido`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `proyecto`.`pedido`;

CREATE TABLE IF NOT EXISTS `proyecto`.`pedido` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `cliente_fk` INT NOT NULL,
  `fecha_hora` DATETIME NOT NULL,
  `metodo_pago` ENUM('efectivo', 'tarjeta', 'sistecredito', 'cupon', 'cheque') NOT NULL,
  `estado` ENUM('pendiente', 'entregado') NOT NULL,
  `total` DOUBLE NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `1_pd_fk_idx` (`cliente_fk` ASC) VISIBLE,
  CONSTRAINT `1_pd_fk`
    FOREIGN KEY (`cliente_fk`)
    REFERENCES `proyecto`.`cliente` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `proyecto`.`detalle_pedido`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `proyecto`.`detalle_pedido`;

CREATE TABLE IF NOT EXISTS `proyecto`.`detalle_pedido` (
  `pedido_fk` INT NOT NULL,
  `pizza_fk` INT NOT NULL,
  `cantidad` INT NOT NULL,
  `precio_unitario` DOUBLE NOT NULL,
  `precio_mano_obra` DOUBLE NOT NULL,
  INDEX `1_dp_fk_idx` (`pedido_fk` ASC) VISIBLE,
  INDEX `2_dp_fk_idx` (`pizza_fk` ASC) VISIBLE,
  CONSTRAINT `1_dp_fk`
    FOREIGN KEY (`pedido_fk`)
    REFERENCES `proyecto`.`pedido` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `2_dp_fk`
    FOREIGN KEY (`pizza_fk`)
    REFERENCES `proyecto`.`pizza` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `proyecto`.`domicilio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `proyecto`.`domicilio`;

CREATE TABLE IF NOT EXISTS `proyecto`.`domicilio` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `pedido_fk` INT NOT NULL,
  `repartidor_fk` INT NOT NULL,
  `hora_salida` DATETIME NOT NULL,
  `hora_entrega` DATETIME NULL,
  `distancia_km` DOUBLE NOT NULL,
  `costo_envio` DOUBLE NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `1_d_fk_idx` (`pedido_fk` ASC) VISIBLE,
  INDEX `2_d_fk_idx` (`repartidor_fk` ASC) VISIBLE,
  CONSTRAINT `1_d_fk`
    FOREIGN KEY (`pedido_fk`)
    REFERENCES `proyecto`.`pedido` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `2_d_fk`
    FOREIGN KEY (`repartidor_fk`)
    REFERENCES `proyecto`.`repartidor` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `proyecto`.`historial_precios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `proyecto`.`historial_precios`;

CREATE TABLE IF NOT EXISTS `proyecto`.`historial_precios` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `pizza_fk` INT NOT NULL,
  `precio_anterior` DOUBLE NOT NULL,
  `precio_actual` DOUBLE NOT NULL,
  `fecha_cambio` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `1_hp_fk_idx` (`pizza_fk` ASC) VISIBLE,
  CONSTRAINT `1_hp_fk`
    FOREIGN KEY (`pizza_fk`)
    REFERENCES `proyecto`.`pizza` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


USE proyecto;

-- =========================================
-- PERSONAS
-- =========================================

INSERT INTO persona
(id, nombre, telefono, direccion, correo)
VALUES
(1, 'Carlos', '3001111111', 'Calle 10 #15-20', 'carlos@gmail.com'),
(2, 'Laura', '3002222222', 'Carrera 20 #30-15', 'laura@gmail.com'),
(3, 'Andres', '3003333333', 'Calle 25 #40-10', 'andres@gmail.com'),
(4, 'Miguel', '3004444444', 'Carrera 15 #20-30', 'miguel@gmail.com'),
(5, 'Sofia', '3005555555', 'Calle 50 #10-25', 'sofia@gmail.com');



-- =========================================
-- CLIENTES
-- =========================================

INSERT INTO cliente
(id, clase)
VALUES
(1, 'comun'),
(2, 'comun'),
(3, 'comun');



-- =========================================
-- REPARTIDORES
-- =========================================

INSERT INTO repartidor
(id, zona, estado)
VALUES
(4, 'Norte', 'disponible'),
(5, 'Sur', 'disponible');


-- =========================================
-- PIZZAS
-- =========================================

INSERT INTO pizza
(id, nombre, tamanio, precio_base, tipo)
VALUES
(1, 'Margarita', 'mediana', 25000, 'clasica'),
(2, 'Pepperoni', 'mediana', 30000, 'especial'),
(3, 'Hawaiana', 'grande', 38000, 'especial'),
(4, 'Vegetariana', 'mediana', 28000, 'vegetariana');




-- =========================================
-- INGREDIENTES
-- =========================================

INSERT INTO ingrediente
(id, nombre, stock, unidad_medida, stock_minimo, costo_unitario)
VALUES
(1, 'Harina', 20, 'kg', 8, 4000),
(2, 'Queso', 15, 'kg', 5, 18000),
(3, 'Salsa de tomate', 10, 'litros', 3, 7000),
(4, 'Pepperoni', 8, 'kg', 2, 22000),
(5, 'Jamon', 8, 'kg', 2, 16000),
(6, 'Piña', 6, 'kg', 2, 8000),
(7, 'Champiñones', 5, 'kg', 2, 12000),
(8, 'Pimenton', 5, 'kg', 2, 7000);




-- =========================================
-- PIZZA_INGREDIENTE
-- =========================================

-- Margarita
INSERT INTO pizza_ingrediente
(pizza_fk, ingrediente_fk, cantidad_ingrediente)
VALUES
(1, 1, 0.25),
(1, 2, 0.15),
(1, 3, 0.10);

-- Pepperoni
INSERT INTO pizza_ingrediente
(pizza_fk, ingrediente_fk, cantidad_ingrediente)
VALUES
(2, 1, 0.25),
(2, 2, 0.15),
(2, 3, 0.10),
(2, 4, 0.10);

-- Hawaiana
INSERT INTO pizza_ingrediente
(pizza_fk, ingrediente_fk, cantidad_ingrediente)
VALUES
(3, 1, 0.35),
(3, 2, 0.20),
(3, 3, 0.12),
(3, 5, 0.10),
(3, 6, 0.10);

-- Vegetariana
INSERT INTO pizza_ingrediente
(pizza_fk, ingrediente_fk, cantidad_ingrediente)
VALUES
(4, 1, 0.25),
(4, 2, 0.15),
(4, 3, 0.10),
(4, 7, 0.08),
(4, 8, 0.08);


-- =========================================
-- PEDIDOS
-- =========================================

INSERT INTO pedido
(id, cliente_fk, fecha_hora, metodo_pago, estado, total)
VALUES


(1, 1, '2026-09-01 12:00:00', 'efectivo', 'entregado', 80000),


(2, 1, '2026-09-03 13:00:00', 'tarjeta', 'entregado', 98000),


(3, 1, '2026-09-05 19:00:00', 'tarjeta', 'entregado', 76000),


(4, 1, '2026-09-08 20:00:00', 'efectivo', 'entregado', 81000),


(5, 1, '2026-09-10 18:30:00', 'cupon', 'entregado', 68000),


(6, 1, '2026-09-12 19:00:00', 'tarjeta', 'entregado', 50000),


(7, 2, '2026-09-04 13:30:00', 'efectivo', 'entregado', 56000),


(8, 2, '2026-09-15 20:00:00', 'tarjeta', 'pendiente', 98000),


(9, 3, '2026-09-20 19:30:00', 'efectivo', 'pendiente', 53000);






-- =========================================
-- DETALLE_PEDIDO
-- =========================================

INSERT INTO detalle_pedido
(pedido_fk, pizza_fk, cantidad, precio_unitario, precio_mano_obra)
VALUES

-- Pedido 1 - Carlos
(1, 1, 2, 25000, 5000),
(1, 2, 1, 30000, 5000),

-- Pedido 2 - Carlos
(2, 2, 2, 30000, 5000),
(2, 3, 1, 38000, 7000),

-- Pedido 3 - Carlos
(3, 3, 2, 38000, 7000),

-- Pedido 4 - Carlos
(4, 1, 1, 25000, 5000),
(4, 4, 2, 28000, 5000),

-- Pedido 5 - Carlos
(5, 2, 1, 30000, 5000),
(5, 3, 1, 38000, 7000),

-- Pedido 6 - Carlos
(6, 1, 2, 25000, 5000),

-- Pedido 7 - Laura
(7, 4, 2, 28000, 5000),

-- Pedido 8 - Laura
(8, 2, 2, 30000, 5000),
(8, 3, 1, 38000, 7000),

-- Pedido 9 - Andres
(9, 1, 1, 25000, 5000),
(9, 4, 1, 28000, 5000);






-- =========================================
-- DOMICILIOS
-- =========================================

INSERT INTO domicilio
(id, pedido_fk, repartidor_fk, hora_salida, hora_entrega, distancia_km, costo_envio)
VALUES

(1, 1, 4, '2026-09-01 12:20:00', '2026-09-01 12:55:00', 3.5, 5000),

(2, 2, 5, '2026-09-01 13:20:00', '2026-09-01 14:00:00', 5.0, 7000),

(3, 3, 4, '2026-09-05 19:20:00', '2026-09-05 20:00:00', 4.0, 6000),

(4, 4, 5, '2026-09-08 20:20:00', '2026-09-08 21:00:00', 6.5, 8000),

(5, 5, 4, '2026-09-10 18:50:00', '2026-09-10 19:30:00', 3.0, 5000),

(6, 6, 5, '2026-09-12 19:20:00', '2026-09-12 20:10:00', 7.0, 9000),

(7, 7, 4, '2026-09-04 13:50:00', '2026-09-04 14:25:00', 4.5, 6000),

(8, 8, 5, '2026-09-15 20:20:00', NULL, 8.0, 10000),

(9, 9, 4, '2026-09-20 19:50:00', NULL, 5.5, 7000);


use proyecto;

/*Consulta de entregas realizadas por cada repartidor
Mostrar el nombre del repartidor, cantidad de entregas realizadas (estado='entregado'), y total acumulado de pedidos entregados.*/

select p.nombre as nombre,count(d.repartidor_fk) as entregas_realizadas,sum(total)as pedidos_entregados from persona p join repartidor r on p.id=r.id 
join domicilio d on d.repartidor_fk=r.id join pedido pd on pd.id=d.pedido_fk where pd.estado='entregado' group by p.nombre;

/*Consulta de pedidos demorados
Mostrar los pedidos cuya entrega tomó más de 40 minutos entre hora_salida y hora_entrega
 (Usa TIMESTAMPDIFF(MINUTE, hora_salida, hora_entrega) > 40).*/
 
select p.id as id,TIMESTAMPDIFF(minute, d.hora_salida,d.hora_entrega) as tiempo from domicilio d join pedido p on d.pedido_fk=p.id where TIMESTAMPDIFF(minute, d.hora_salida,d.hora_entrega)>40;


/*Consulta de repartidores activos sin entregas
Mostrar los repartidores con estado 'activo' que no tienen domicilios asignados (usa LEFT JOIN y WHERE domicilio.id_domicilio IS NULL).*/

select r.id as id_repartidor from repartidor r left join domicilio d on r.id=d.repartidor_fk where r.estado='disponible' and d.id is null group by r.id;


/*Vista resumen de desempeño
Crear una vista vista_desempeno_repartidor que muestre:
nombre_repartidor
entregas_totales
promedio_minutos_entrega*/


create view desempenio as select p.nombre as repartidor_nombre,count(d.repartidor_fk) 
as entregas,round(avg(TIMESTAMPDIFF(minute, d.hora_salida,d.hora_entrega)))as tiempo_promedio from persona p
join repartidor r on p.id=r.id join domicilio d on r.id=d.repartidor_fk where d.hora_entrega is not null group by r.id;

select * from desempenio;