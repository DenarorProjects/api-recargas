-- borra la bd si existe
DROP DATABASE IF EXISTS db_recargas;
-- creamos la bd
CREATE DATABASE db_recargas;
-- activamos la bd
USE db_recargas;

CREATE TABLE user(
	dni				CHAR(8)			NOT NULL	PRIMARY KEY,
    name			VARCHAR(30)		NOT NULL,
    lastname		VARCHAR(150)	NOT NULL
);

CREATE TABLE plan(
	id				INT				NOT NULL	PRIMARY KEY,
    description		VARCHAR(20)		NOT NULL
);

CREATE TABLE phone_number(
	id				CHAR(9)			NOT NULL	PRIMARY KEY,
    user_id			CHAR(8)			NOT NULL,
    saldo			DECIMAL(4,2)	NOT NULL DEFAULT 0,
    plan_id			INT				NOT NULL DEFAULT 0,
    		FOREIGN KEY(user_id) REFERENCES	user(dni),
			FOREIGN KEY(plan_id) REFERENCES	plan(id)
);


CREATE TABLE history_recarga(
	id				INT				NOT NULL	PRIMARY KEY	AUTO_INCREMENT,
    phone_number_id	CHAR(9)			NOT NULL,
    register_day	DATETIME		NOT NULL,
    amount			DECIMAL(4,2)	NOT NULL,
			FOREIGN KEY(phone_number_id) REFERENCES	phone_number(id)
);
ALTER TABLE history_recarga AUTO_INCREMENT = 1000;

# INSERT DATA

INSERT INTO user VALUES ('12345678', 'Juanito', 'Perez');
INSERT INTO user VALUES ('87654321', 'Claudia', 'Ramirez');

INSERT INTO plan VALUES (1, 'prepago');
INSERT INTO plan VALUES (2, 'postpago');

INSERT INTO phone_number VALUES ('913456787', '12345678', default, 1);
INSERT INTO phone_number VALUES ('913456788', '87654321', 30.00, 2);

DROP PROCEDURE IF EXISTS recargar_telefono;
DELIMiTER $$
CREATE PROCEDURE recargar_telefono(
	v_number_phone		CHAR(9),
    v_date				DATETIME,
    v_amount			DECIMAL(4,2),
    OUT p_result 		INT
)
BEGIN
	IF (SELECT count(*) FROM phone_number WHERE id = v_number_phone) < 1 THEN
		SET p_result = 0;
	ELSE 
		BEGIN
			UPDATE phone_number
				SET saldo = saldo + v_amount
			WHERE id = v_number_phone;
            
			INSERT INTO history_recarga VALUES (DEFAULT, v_number_phone, v_date, v_amount);
            SET p_result = 1;
		END;        
    END IF;
END$$
DELIMiTER ;

DROP PROCEDURE IF EXISTS agregar_telefono;
DELIMiTER $$
CREATE PROCEDURE agregar_telefono(
	v_user				CHAR(8),
    v_saldo_initial		DECIMAL(4,2),
    v_plan_id			INT,
    OUT p_result 		INT,
    OUT p_new_number	CHAR(9)
)
BEGIN
	IF (SELECT count(*) FROM user WHERE dni = v_user) < 1 THEN
		SET p_result = 0;
	ELSE 
		BEGIN
			SET p_new_number = (SELECT max(id) + 1 FROM phone_number);
			INSERT INTO phone_number VALUES (p_new_number, v_user, v_saldo_initial, v_plan_id);
			SET p_result = 1;
		END;        
    END IF;
END$$
DELIMiTER ;

DROP PROCEDURE IF EXISTS agregar_usuario;
DELIMiTER $$
CREATE PROCEDURE agregar_usuario(
	v_dni				CHAR(8),
    v_name				VARCHAR(30),
    v_lastname			VARCHAR(150),
    v_amount			DECIMAL(4,2),
    OUT p_result 		INT,
    OUT p_new_number	CHAR(9)
)
BEGIN
	IF (SELECT count(*) FROM user WHERE dni = v_dni) > 0 THEN
		SET p_result = 0;
	ELSE 
		BEGIN
			SET p_result = 1;
            SET p_new_number = '0';
			INSERT INTO user VALUES (v_dni, v_name, v_lastname);
            CALL agregar_telefono(v_dni, v_amount, 1, p_result, p_new_number);
            IF(p_result = 0) THEN
				SET p_result = -2;
            END IF;
			
		END;        
    END IF;
END$$
DELIMiTER ;

DROP PROCEDURE IF EXISTS obtener_telefonos_por_usuario;
DELIMiTER $$
CREATE PROCEDURE obtener_telefonos_por_usuario(v_user CHAR(8))
BEGIN
	SELECT
		u.dni,
		concat(u.name,' ', u.lastname) 'Nombre cliente',
		pn.id 'phone number',
		pn.saldo,
		p.description 'plan'
	FROM user u
	INNER JOIN phone_number pn
		ON u.dni = pn.user_id
	INNER JOIN plan p
		ON p.id = pn.plan_id
	WHERE u.dni = v_user;
END$$
DELIMiTER ;

DROP PROCEDURE IF EXISTS obtener_telefono_por_num_telefono;
DELIMiTER $$
CREATE PROCEDURE obtener_telefono_por_num_telefono(v_numb_phone CHAR(9))
BEGIN
	SELECT
		pn.id 'phone number',
        concat(u.name,' ', u.lastname) 'Nombre cliente',
		u.dni,
		pn.saldo,
		p.description 'plan'
	FROM user u
	INNER JOIN phone_number pn
		ON u.dni = pn.user_id
	INNER JOIN plan p
		ON p.id = pn.plan_id
	WHERE pn.id = v_numb_phone;
END$$
DELIMiTER ;

# CALL PROCEDURES
CALL obtener_telefonos_por_usuario('76231293');

CALL agregar_usuario('76231293', 'Dennis', 'Villagaray', 0.0, @out_value, @phone);
SELECT @out_value, @phone;

CALL agregar_telefono('87654321', 10.05, 1, @out_value, @phone);
SELECT @out_value, @phone;

CALL recargar_telefono('913456787', '2022-06-19', 20.0512213, @out_value);
SELECT @out_value;

SELECT
	u.dni,
    concat(u.name,' ', u.lastname) 'Nombre cliente',
    pn.id 'phone number',
    pn.saldo,
    p.description 'plan'
FROM user u
INNER JOIN phone_number pn
	ON u.dni = pn.user_id
INNER JOIN plan p
	ON p.id = pn.plan_id;
    

DB_HOST=localhost
DB_USER=root
DB_PORT=3306
DB_PASSWORD=Forever_hi5.
DB_DATABASE=db_recargas
TOKEN=C)NUrB-2yPTbFppP=7Z:8-[2e}M_D
