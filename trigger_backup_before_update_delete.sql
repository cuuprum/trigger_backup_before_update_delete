
/*
*
* REQUIRE MySQL 5.7 OR ABOVE
*
*/

/* RECORD TO JSON */

SELECT JSON_OBJECT('id', id, 'nama', nama, 'email', email, 'telp', telp, 'alamat', alamat, 'status', status, 'created_at', created_at, 'updated_at', updated_at) AS content FROM customer

-----------------------


/* TABLE ACHIVE LOG - Menyimpan record yang di backup */

CREATE TABLE archive_log
(
	id INTEGER NOT NULL PRIMARY KEY UNIQUE AUTO_INCREMENT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    operation ENUM('UPDATE','DELETE','','') NOT NULL,
    from_table VARCHAR(100),
    content TEXT,
    CHECK (content IS NULL OR JSON_VALID(content))
)

/*
	ALTER TABLE archive_log
	MODIFY created_at DATETIME DEFAULT CURRENT_TIMESTAMP
*/
----------------------


/* TRIGGER BACKUP RECORD BEFORE DELETE */

DELIMITER $$

CREATE TRIGGER before_delete_customer
BEFORE DELETE
ON customer FOR EACH ROW
BEGIN
	
    SET @record_content = (SELECT JSON_OBJECT('id', OLD.id, 'nama', OLD.nama, 'email', OLD.email, 'telp', OLD.telp, 'alamat', OLD.alamat, 'status', OLD.status, 'created_at', OLD.created_at, 'updated_at', OLD.updated_at) FROM customer WHERE id = OLD.id);
	INSERT INTO archive_log(`operation`, `from_table`, `content`)
    VALUES('DELETE','customer', @record_content);
END$$

DELIMITER ;

------------------


/* TRIGGER BACKUP RECORD BEFORE UPDATE */

DELIMITER $$

CREATE TRIGGER before_update_customer
BEFORE UPDATE
ON customer FOR EACH ROW
BEGIN
	
    SET @record_content = (SELECT JSON_OBJECT('id', OLD.id, 'nama', OLD.nama, 'email', OLD.email, 'telp', OLD.telp, 'alamat', OLD.alamat, 'status', OLD.status, 'created_at', OLD.created_at, 'updated_at', OLD.updated_at) FROM customer WHERE id = OLD.id);
	INSERT INTO archive_log(`operation`, `from_table`, `content`)
    VALUES('UPDATE','customer', @record_content);
END$$

DELIMITER ;

---------------------

-- get column names

SELECT `COLUMN_NAME` 
FROM `INFORMATION_SCHEMA`.`COLUMNS` 
WHERE `TABLE_SCHEMA`='gatokoco_sop' 
    AND `TABLE_NAME`='customer'


--------------------





query list database
query list table 
query list kolom

$string kolom -> {'nama', 'email'} -> 'id', OLD.id, 'nama', OLD.nama, 'email', OLD.email, 'telp', OLD.telp, 'alamat', OLD.alamat, 'status', OLD.status, 'created_at', OLD.created_at, 'updated_at', OLD.updated_at) FROM customer WHERE id = OLD.id

masukin ke triger ->
 - updated
 - delete







/* TRIGGER BACKUP RECORD BEFORE DELETE  V2 - belum oke */

DELIMITER $$

CREATE TRIGGER before_delete_customer
BEFORE DELETE
ON customer FOR EACH ROW
BEGIN
	
	-- EDIT HERE! 
	SET @database_name = 'gatokoco_sop';
	SET @table_name = 'customer';
	
	-- Declare cursor & variable untuk tampung nama kolom
	DECLARE done INT DEFAULT FALSE;
	DECLARE columnName VARCHAR(255);
	DECLARE cursorColumns CURSOR FOR SELECT `COLUMN_NAME` FROM `INFORMATION_SCHEMA`.`COLUMNS` WHERE `TABLE_SCHEMA` = @database_name AND `TABLE_NAME`= @table_name;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	DECLARE prepared_json TEXT;
	
	-- Looping untuk bikin struktur JSON
	
	SET columnName = CONCAT(columnName, '''');
	
	OPEN cursorColumns;
	
	read_loop: LOOP
		FETCH cursorColumns INTO columnName;
		SET columnName = CONCAT('"', cursorColumns, '", OLD.', cursorColumns,);
	END LOOP;
	
	CLOSE cursorColumns;
	
	SELECT columnName;
	
	
    SET @record_content = (SELECT JSON_OBJECT('id', OLD.id, 'nama', OLD.nama, 'email', OLD.email, 'telp', OLD.telp, 'alamat', OLD.alamat, 'status', OLD.status, 'created_at', OLD.created_at, 'updated_at', OLD.updated_at) FROM customer WHERE id = OLD.id);
	INSERT INTO archive_log(`operation`, `from_table`, `content`)
    VALUES('DELETE','customer', @record_content);
END$$

DELIMITER ;








/* tak coba2 melempar manggis */

	
	----------------
	
--	LOOPS
	
	CREATE PROCEDURE curdemo()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE a CHAR(16);
  DECLARE b, c INT;
  DECLARE cur1 CURSOR FOR SELECT id,data FROM test.t1;
  DECLARE cur2 CURSOR FOR SELECT i FROM test.t2;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur1;
  OPEN cur2;

  read_loop: LOOP
    FETCH cur1 INTO a, b;
    FETCH cur2 INTO c;
    IF done THEN
      LEAVE read_loop;
    END IF;
    IF b < c THEN
      INSERT INTO test.t3 VALUES (a,b);
    ELSE
      INSERT INTO test.t3 VALUES (a,c);
    END IF;
  END LOOP;

  CLOSE cur1;
  CLOSE cur2;
END;

---------------

SELECT json_arrayagg(JSON_OBJECT('id', id, 'nama', nama, 'email', email, 'telp', telp, 'alamat', alamat, 'status', status, 'created_at', created_at, 'updated_at', updated_at)) FROM customer;

SELECT CONCAT(
	'[',
		GROUP_CONCAT(JSON_OBJECT('id', id, 'nama', nama, 'email', email, 'telp', telp, 'alamat', alamat, 'status', status, 'created_at', created_at, 'updated_at', updated_at)),
	']') AS content FROM customer;
	
	
	-----------------------------------
	
	21 / 1 / 2020
	
	-----------------
	
	SELECT IFNULL((SELECT `nomor_spm` FROM kontrak WHERE id = 26), "a")
	
	
	
	BEGIN
	
    SET @record_content = concat_ws("{'id':'",OLD.id,"','nomor_spm':'",IFNULL(OLD.nomor_spm, "kosong"),"','tanggal_kontrak':'",IFNULL(OLD.tanggal_kontrak, "kosong"),"','nama_vendor':'",IFNULL(OLD.nama_vendor, "kosong"),"','nilai_bast':'",IFNULL(OLD.nilai_bast, "kosong"),"'}");
	INSERT INTO archive_log(`operation`, `from_table`, `content`)
    VALUES('UPDATE','kontrak', @record_content);
END

{'id':'32','nomor_spm':'kosong','tanggal_kontrak':'2019-02-04','nama_vendor':'kosong','nilai_bast':'0'}
