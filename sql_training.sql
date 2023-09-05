CREATE TABLE public.student
(
	student_id serial,
	first_name varchar,
	last_name varchar,
	birthday date,
	phone varchar
);

CREATE TABLE cathedra 
(
	cathedra_id serial,
	cathedra_name varchar,
	dean varchar
);

ALTER TABLE student
ADD COLUMN middle_name varchar;

ALTER TABLE student
ADD COLUMN rating float;

ALTER TABLE student
ADD COLUMN enrolled date;

ALTER TABLE student
DROP COLUMN middle_name;

ALTER TABLE cathedra
RENAME TO chair;

ALTER TABLE chair
RENAME cathedra_id TO chair_id;

ALTER TABLE chair
RENAME cathedra_name TO chair_name;

ALTER TABLE student
ALTER COLUMN first_name SET DATA TYPE varchar(64);

ALTER TABLE student
ALTER COLUMN last_name SET DATA TYPE varchar(64);

ALTER TABLE student
ALTER COLUMN phone SET DATA TYPE varchar(30);


CREATE TABLE faculty
(
	faculty_id serial,
	faculty_name varchar
);

INSERT INTO faculty (faculty_name)
VALUES 
('faculty 1'),
('faculty 2'),
('faculty 3');

SELECT * FROM faculty;

TRUNCATE TABLE faculty; --TRUNCATE TABLE faculty CONTINUE IDENTITY;

TRUNCATE TABLE faculty RESTART IDENTITY;

DROP TABLE faculty;

--------------------------------------------------------------------

CREATE TABLE teacher
(
	teacher_id serial,
	firstname varchar,
	last_name varchar,
	birthday date,
	phone varchar,
	title varchar
);

ALTER TABLE teacher
ADD COLUMN middle_name varchar;

ALTER TABLE teacher
DROP COLUMN middle_name;

ALTER TABLE teacher
RENAME birthday TO birth_day;

ALTER TABLE teacher
ALTER COLUMN phone SET DATA TYPE varchar(32);

CREATE TABLE exam
(
	exam_id serial,
	exam_name varchar(256),
	exam_date date
);

INSERT INTO exam(exam_name, exam_date)
VALUES
('russian', '2022-03-21'),
('english', '2022-03-21'),
('math', '2022-03-21');

SELECT * FROM exam;

TRUNCATE exam RESTART IDENTITY;

------------------------------------------------

CREATE TABLE chair
(
	chair_id serial, --PRIMARY KEY,
	chair_name varchar,
	dean varchar,
	
	--CONSTRAINT PK_chair_chair_id PRIMARY KEY(chair_id)
);

INSERT INTO chair 
VALUES
(1, 'name', 'dean');

SELECT * FROM chair;

INSERT INTO chair 
VALUES
(2, 'name2', 'dean2');

DROP TABLE chair;

CREATE TABLE chair
(
	chair_id serial UNIQUE NOT NULL,
	chair_name varchar,
	dean varchar
);

SELECT constraint_name
FROM information_schema.key_column_usage
WHERE table_name = 'chair'
	AND table_schema = 'public'
	AND column_name = 'chair_id';
	
ALTER TABLE chair
DROP CONSTRAINT chair_chair_id_key;

ALTER TABLE chair
ADD PRIMARY KEY(chair_id);

---------------------------------------------------

CREATE TABLE publisher
(
	publisher_id serial,
	publisher_name varchar(128) NOT NULL,
	address text,
	
	CONSTRAINT pk_publisher_publisher_id PRIMARY KEY(publisher_id) 
);

CREATE TABLE book
(
	book_id serial,
	title text NOT NULL,
	isbn varchar(32) NOT NULL,
	publisher_id int,
	
	CONSTRAINT pk_book_book_id PRIMARY KEY(book_id),
	CONSTRAINT fk_book_publisher_id FOREIGN KEY(publisher_id) REFERENCES publisher(publisher_id)
);

ALTER TABLE book
DROP CONSTRAINT fk_book_publisher_id;

INSERT INTO publisher
VALUES
(1, 'Everyman''s Library', 'NY'),
(2, 'Oxford University Press', 'NY'),
(3, 'Grand Central Publishing', 'Washington'),
(4, 'Simon & Schuster', 'Chicago');

INSERT INTO book
VALUES
(1, 'The Diary of a Young Girl', '0199535566', 10);

SELECT * FROM book;

TRUNCATE book RESTART IDENTITY;

ALTER TABLE book
ADD CONSTRAINT fk_book_publisher_id FOREIGN KEY(publisher_id) REFERENCES publisher(publisher_id);

DROP TABLE book;

-------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS book;

CREATE TABLE book
(
	book_id serial,
	title text NOT NULL,
	isbn varchar(32) NOT NULL,
	publisher_id int,
	
	CONSTRAINT pk_book_book_id PRIMARY KEY(book_id)
);

ALTER TABLE book
ADD COLUMN price decimal CONSTRAINT CHK_book_price CHECK (price >= 0);

INSERT INTO book
VALUES
(1, 'The Diary of a Young Girl', '0199535566', 1, 1.5);

SELECT * FROM book;

----------------------------------------------------------------------

CREATE TABLE customer
(
	customer_id serial,
	full_name text,
	status char DEFAULT 'r',
	
	CONSTRAINT pk_customer_customer_id PRIMARY KEY(customer_id),
	CONSTRAINT chk_customer_status CHECK (status = 'r' OR status = 'p')
);

INSERT INTO customer (full_name)
VALUES
('name');

SELECT * FROM customer;

ALTER TABLE customer
ALTER COLUMN status DROP DEFAULT;

ALTER TABLE customer
ALTER COLUMN status SET DEFAULT 'r';

---------------------------------------------------------------------------

CREATE SEQUENCE seq1;

SELECT nextval('seq1');
SELECT currval('seq1');
SELECT lastval();

SELECT setval('seq1', 16, true); --SELECT setval('seq1', 16) по умолчанию с true
SELECT currval('seq1');
SELECT nextval('seq1');

SELECT setval('seq1', 16, false); --false оставляем в seq1 старое значение, потом пойдет счет с нового
SELECT currval('seq1');
SELECT nextval('seq1');

CREATE SEQUENCE IF NOT EXISTS seq2 INCREMENT 16;  --default start with 1
SELECT nextval('seq2');
SELECT nextval('seq2');

CREATE SEQUENCE IF NOT EXISTS seq3
INCREMENT 16 
MINVALUE 0
MAXVALUE 128
START WITH 0;

SELECT nextval('seq3');

ALTER SEQUENCE seq3 RENAME TO seq4;
ALTER SEQUENCE seq4 RESTART WITH 16;

SELECT nextval('seq4');

DROP SEQUENCE seq4;

----------------------------------------------------------

DROP TABLE IF EXISTS book;

CREATE TABLE book
(
	book_id int GENERATED ALWAYS AS IDENTITY (START WITH 10 INCREMENT BY 2), --int GENERATED BY DEFAULT
	title text NOT NULL,
	isbn varchar(32) NOT NULL,
	publisher_id int NOT NULL,
	
	CONSTRAINT pk_book_book_id PRIMARY KEY(book_id)
);

SELECT * FROM book;

CREATE SEQUENCE IF NOT EXISTS book_book_id_seq
START WITH 1 OWNED BY book.book_id;

INSERT INTO book (title, isbn, publisher_id)
VALUES ('title', 'isbn', 1);

INSERT INTO book -- problem with sequence
OVERRIDING SYSTEM VALUE
VALUES (3, 'title', 'isbn', 1);

ALTER TABLE book
ALTER COLUMN book_id SET DEFAULT nextval('book_book_id_seq');

-------------------------------------------------------------------------

CREATE TABLE author
(
	author_id serial PRIMARY KEY,
	full_name text NOT NULL,
	rating real
);

INSERT INTO author
VALUES (10, 'John Silver', 4.5);

INSERT INTO author (author_id, full_name)
VALUES (11, 'Bob Gray');

INSERT INTO author (author_id, full_name)
VALUES 
(12, 'Name 1'),
(13, 'Name 2'),
(14, 'Name 3');

SELECT *
INTO best_authors
FROM author
WHERE rating >= 4.5;

SELECT *
INTO best_authors
FROM author
WHERE rating > 5;

SELECT * FROM best_authors;

SELECT * FROM author;

INSERT INTO best_authors
SELECT *
FROM author
WHERE rating < 5;

----------------------------------------------------

SELECT * FROM author;

UPDATE author
SET full_name = 'Elias', rating = 5
WHERE author_id = 11;

DELETE FROM author
WHERE rating IS NULL;

DELETE FROM author;

TRUNCATE TABLE author;

DROP TABLE book;

CREATE TABLE book
(
	book_id serial,
	title text NOT NULL,
	isbn varchar(32) NOT NULL,
	publisher_id integer NOT NULL,
	
	CONSTRAINT pk_book_book_id PRIMARY KEY(book_id)
);

INSERT INTO book (title, isbn, publisher_id)
VALUES ('title', 'isbn', 3)
RETURNING book_id;

INSERT INTO book (title, isbn, publisher_id)
VALUES 
('title', 'isbn', 3),
('title', 'isbn', 3)
RETURNING book_id;

INSERT INTO book (title, isbn, publisher_id)
VALUES ('title', 'isbn', 3)
RETURNING *;

SELECT * FROM author;

INSERT INTO author
VALUES (1, 'full_name', 4);

UPDATE author
SET full_name = 'Walter', rating = 5
WHERE author_id = 1
RETURNING author_id;

DELETE FROM author
WHERE rating = 5
RETURNING *;

-----------------------------------------------------

CREATE TABLE exam
(
	exam_id int GENERATED ALWAYS AS IDENTITY,
	exam_name varchar,
	exam_date date,
	
	CONSTRAINT pk_exam_exam_id PRIMARY KEY (exam_id)
);

DROP TABLE exam;

ALTER TABLE exam
DROP CONSTRAINT pk_exam_exam_id;

ALTER TABLE exam
DROP CONSTRAINT exam_exam_id_key;

ALTER TABLE exam
ADD CONSTRAINT pk_exam_exam_id PRIMARY KEY (exam_id);

INSERT INTO exam (exam_name, exam_date)
VALUES ('exam', '2020-07-01');

SELECT * FROM exam;

CREATE TABLE person
(
	person_id int,
	first_name varchar,
	last_name varchar,
	
	CONSTRAINT pk_person_person_id PRIMARY KEY(person_id)
);

CREATE TABLE passport
(
	passport_id int,
	passport_number int NOT NULL,
	registration text,
	person_id int,
	
	CONSTRAINT pk_passport_passport_id PRIMARY KEY(passport_id),
	CONSTRAINT fk_passport_person_person_id FOREIGN KEY(person_id) REFERENCES person(person_id)
);

ALTER TABLE book
ADD COLUMN weight int; 

ALTER TABLE book
ADD CONSTRAINT chk_book_weight CHECK (weight > 0 AND weight < 100);

ALTER TABLE book
ADD COLUMN weight int CONSTRAINT chk_book_weight CHECK (weight > 0 AND weight < 100); 

INSERT INTO book 
VALUES (5, 'title', 'isbn', 1, 150);

INSERT INTO book 
VALUES (5, 'title', 'isbn', 1, 50);

SELECT * FROM book;

ALTER TABLE products
ADD CONSTRAINT chk_products_unit_price CHECK (unit_price > 0);

DROP TABLE student;

CREATE TABLE student
(
	student_id int GENERATED ALWAYS AS IDENTITY,
	full_name varchar,
	course int DEFAULT 1,
	
	CONSTRAINT pk_student_student_id PRIMARY KEY (student_id)
);

SELECT * FROM student;

INSERT INTO student (full_name)
VALUES
('name'),
('name2');

INSERT INTO student (full_name, course)
VALUES('name3', 2);

ALTER TABLE student
ALTER COLUMN course DROP DEFAULT;

INSERT INTO student (full_name)
VALUES('name4');

SELECT MAX(product_id)
FROM products;

CREATE SEQUENCE IF NOT EXISTS products_product_id_seq
START WITH 78 OWNED BY products.product_id;

ALTER TABLE products
ALTER COLUMN product_id SET DEFAULT nextval('products_product_id_seq');

INSERT INTO products (product_name, supplier_id, category_id, quantity_per_unit,
					 unit_price, units_in_stock, units_on_order, reorder_level, discontinued)
VALUES ('prod', 1, 1, 10, 
		20, 20, 10, 1, 0)
RETURNING product_id;

DELETE FROM products
WHERE product_id = 78;

----------------------------------------------------------------------------------------------

CREATE VIEW products_suppliers_categories AS
SELECT product_name, quantity_per_unit, unit_price, units_in_stock, 
		company_name, contact_name, phone, category_name, description
FROM products
JOIN suppliers USING(supplier_id)
JOIN categories USING(category_id);

SELECT * FROM products_suppliers_categories;

SELECT *
FROM products_suppliers_categories
WHERE unit_price > 20;

DROP VIEW IF EXISTS products_suppliers_categories;

-----------------------------------------------------------------------------------------------

SELECT * FROM orders;

CREATE VIEW heavy_orders AS
SELECT *
FROM orders
WHERE freight > 50;

SELECT * 
FROM heavy_orders
ORDER BY freight;

CREATE OR REPLACE VIEW heavy_orders AS
SELECT *
FROM orders
WHERE freight > 100;


DROP VIEW products_suppliers_categories;

CREATE OR REPLACE VIEW products_suppliers_categories AS
SELECT product_name, quantity_per_unit, unit_price, units_in_stock, discontinued, 
		company_name, contact_name, phone, country, category_name, description
FROM products
JOIN suppliers USING(supplier_id)
JOIN categories USING(category_id);

SELECT *
FROM products_suppliers_categories
WHERE discontinued = 1;

ALTER VIEW products_suppliers_categories RENAME TO psc_old;

SELECT * 
FROM heavy_orders
ORDER BY freight;

SELECT MAX(order_id)
FROM orders;

INSERT INTO heavy_orders
VALUES (11078, 'VINET', 5, '2019-12-10', '2019-12-15', '2019-12-14', 1, 120,
	   'Hanari Carnes', 'Rua do Paco', 'Bern', null, 3012, 'Switzerland');
	   
SELECT * 
FROM heavy_orders
ORDER BY order_id DESC;

SELECT MIN(freight)
FROM orders;

DELETE FROM heavy_orders
WHERE freight < 0.05;

SELECT MIN(freight)
FROM heavy_orders;

DELETE FROM heavy_orders
WHERE freight < 100.25;

DELETE FROM order_details
WHERE order_id = 10854;

-------------------------------------------------------------------------------

SELECT * 
FROM heavy_orders
ORDER BY freight;

INSERT INTO heavy_orders
VALUES (11900, 'FOLIG', 1, '2000-01-01', '2000-01-05', '2000-01-04', 1, 80, 'Folies gourmades', '184, chaussée de Tournai',
	   'Lille', null, 59000, 'FRANCE');
	   
SELECT * 
FROM heavy_orders
WHERE order_id = 11900;

SELECT * 
FROM orders
WHERE order_id = 11900;

CREATE OR REPLACE VIEW heavy_orders AS
SELECT *
FROM orders
WHERE freight > 100
WITH LOCAL CHECK OPTION;

INSERT INTO heavy_orders
VALUES (11901, 'FOLIG', 1, '2000-01-01', '2000-01-05', '2000-01-04', 1, 80, 'Folies gourmades', '184, chaussée de Tournai',
	   'Lille', null, 59000, 'FRANCE');
	   
CREATE OR REPLACE VIEW heavy_orders AS
SELECT *
FROM orders
WHERE freight > 100
WITH CASCADE CHECK OPTION; --? Dont work! Why?

--------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW my_view AS
SELECT order_date, required_date, shipped_date, ship_postal_code, company_name, 
	   contact_name, phone, last_name, first_name, title
FROM orders
JOIN customers USING(customer_id)
JOIN employees USING(employee_id);

SELECT *
FROM my_view
WHERE order_date > '1997-01-01';

ALTER VIEW my_view RENAME TO another_name_view; 

CREATE OR REPLACE VIEW my_view AS
SELECT order_date, required_date, shipped_date, ship_postal_code, ship_country, 
	   company_name, contact_name, phone, customers.postal_code
	   last_name, first_name, title, reports_to
FROM orders
JOIN customers USING (customer_id)
JOIN employees USING (employee_id);

DROP VIEW another_name_view;

CREATE VIEW active_products AS
SELECT *
FROM products
WHERE discontinued <> 1
WITH LOCAL CHECK OPTION;

SELECT * FROM active_products;

INSERT INTO active_products
VALUES (79, 'abc', 1, 1, 'abc', 1, 1, 1, 1, 1); -- ERROR: ОШИБКА:  новая строка нарушает ограничение-проверку для представления "active_products"
-- DETAIL:  Ошибочная строка содержит (79, abc, 1, 1, abc, 1, 1, 1, 1, 1).


INSERT INTO active_products
VALUES (79, 'abc', 1, 1, 'abc', 1, 1, 1, 1, 0); -- insert is successful

--------------------------------------------------------------------------------

SELECT product_name, unit_price, units_in_stock,
	CASE WHEN units_in_stock >= 100 THEN 'lots of'
		 WHEN units_in_stock >= 50 AND units_in_stock <= 100 THEN 'average'
		 WHEN units_in_stock < 50 THEN 'low number'
		 ELSE 'unknown'
	END AS amount
FROM products
ORDER BY units_in_stock DESC;

SELECT order_id, order_date, 
		CASE WHEN date_part('month', order_date) BETWEEN 3 AND 5 THEN 'spring'
			 WHEN date_part('month', order_date) BETWEEN 6 AND 8 THEN 'summer'
			 WHEN date_part('month', order_date) BETWEEN 3 AND 5 THEN 'autumn'
			 ELSE 'winter'
		END AS season
FROM orders;

SELECT product_name, unit_price,
		CASE WHEN unit_price >= 30 THEN 'expensive'
			 ELSE 'inexpensive'
		END AS price_description
FROM products;
			
------------------------------------------------------------------------------

SELECT *
FROM orders
LIMIT 10;

SELECT order_id, order_date, COALESCE(ship_region, 'unknow') AS ship_region
FROM orders
LIMIT 10;

SELECT *
FROM employees;

SELECT last_name, first_name, COALESCE(region, 'N/A') AS region
FROM employees;

SELECT *
FROM customers;

SELECT contact_name, COALESCE(NULLIF(city, ''), 'Unknown') AS city
FROM customers;

-----------------------------------------------------------------------------

insert into customers(customer_id, contact_name, city, country, company_name)
values 
('AAAAA', 'Alfred Mann', NULL, 'USA', 'fake_company'),
('BBBBB', 'Alfred Mann', NULL, 'Austria','fake_company');

insert into customers(customer_id, contact_name, city, country, company_name)
values 
('AAAAAB', 'John Mann', 'abc', 'USA', 'fake_company'),
('BBBBBV', 'John Mann', 'acd', 'Austria','fake_company');

SELECT * FROM customers;

SELECT contact_name, city, country FROM customers;

SELECT contact_name, city, country
FROM customers
ORDER BY contact_name, 
(
	CASE 
		WHEN city IS NULL THEN country 
		ELSE city 
	END
);

SELECT product_name, unit_price,
	CASE WHEN unit_price >= 100 THEN 'too expensive'
		 WHEN unit_price >= 50 AND unit_price < 100 THEN 'average'
		 WHEN unit_price < 50 THEN 'low price'
		 ELSE 'unknown'
	END AS price
FROM products
ORDER BY unit_price DESC;

SELECT contact_name, COALESCE(order_id::text, 'no orders') --COALESCE(TO_CHAR(order_id, 'FM999999'),
FROM customers
LEFT JOIN orders USING(customer_id)
WHERE order_id IS NULL;

SELECT CONCAT(first_name, ' ', last_name) AS full_name, COALESCE(NULLIF(title, 'Sales Representative'), 'Sales Stuff') AS title
FROM employees;

-------------------------------------------------------------------------

SELECT *
FROM customers;

SELECT *
INTO tmp_customers
FROM customers;

SELECT * FROM tmp_customers;
DROP TABLE tmp_customers;



CREATE OR REPLACE FUNCTION fix_customer_region() RETURNS void AS $$
	UPDATE tmp_customers
	SET region = 'unkown'
	WHERE region IS NULL
$$ LANGUAGE SQL;

SELECT fix_customer_region();

---------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION get_total_number_of_goods() RETURNS bigint AS $$
	SELECT SUM (units_in_stock)
	FROM products
$$ LANGUAGE SQL;

SELECT get_total_number_of_goods() AS total_goods;

CREATE OR REPLACE FUNCTION get_avg_price() RETURNS float8 AS $$
	SELECT AVG (unit_price)
	FROM products
$$ LANGUAGE SQL;

SELECT get_avg_price() AS avg_price;

-----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION get_product_price_by_name(prod_name varchar) RETURNS real AS $$
	SELECT unit_price
	FROM products
	WHERE product_name = prod_name
$$ LANGUAGE SQL;

SELECT get_product_price_by_name('Chocolade') AS price;

SELECT * FROM products;


CREATE OR REPLACE FUNCTION get_price_boundaries(OUT max_price real, OUT min_price real) AS $$
	SELECT MAX(unit_price), MIN(unit_price)
	FROM products
$$ LANGUAGE SQL;

SELECT get_price_boundaries();
SELECT * FROM get_price_boundaries();

CREATE OR REPLACE FUNCTION get_price_boundaries_by_discontinued
	(IN is_discontinued int DEFAULT 1, OUT max_price real, OUT min_price real) AS $$
		SELECT MAX(unit_price), MIN(unit_price)
		FROM products
		WHERE discontinued = is_discontinued;
$$ LANGUAGE SQL;

SELECT get_price_boundaries_by_discontinued(1);
SELECT * FROM get_price_boundaries_by_discontinued(1);

--SELECT get_price_boundaries_by_discontinued(0);
SELECT * FROM get_price_boundaries_by_discontinued(1);
SELECT * FROM get_price_boundaries_by_discontinued(0);
SELECT * FROM get_price_boundaries_by_discontinued();

---------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION get_average_prices_by_prod_categories()
		RETURNS SETOF double precision AS $$
	SELECT AVG(unit_price)
	FROM products
	GROUP BY category_id
$$ LANGUAGE SQL;	

SELECT * FROM get_average_prices_by_prod_categories() AS average_prices;


DROP FUNCTION get_avg_prices_by_prod_categories();
CREATE OR REPLACE FUNCTION get_avg_prices_by_prod_categories(OUT sum_price real, OUT avg_price float8)
	RETURNS SETOF RECORD AS $$ --without RETURNS SETOF RECORD print one row
	SELECT SUM(unit_price), AVG(unit_price)
	FROM products
	GROUP BY category_id
$$ LANGUAGE SQL; 

SELECT sum_price FROM get_avg_prices_by_prod_categories();
SELECT sum_price, avg_price FROM get_avg_prices_by_prod_categories();

SELECT sum_price AS sum_of FROM get_avg_prices_by_prod_categories();

CREATE OR REPLACE FUNCTION get_avg_prices_by_prod_categories()
	RETURNS SETOF RECORD AS $$
	SELECT SUM(unit_price), AVG(unit_price)
	FROM products
	GROUP BY category_id
$$ LANGUAGE SQL; 


SELECT sum_price FROM get_avg_prices_by_prod_categories(); -- dont work
SELECT sum_price, avg_price FROM get_avg_prices_by_prod_categories(); -- dont work
SELECT sum_price AS sum_of FROM get_avg_prices_by_prod_categories(); -- dont work
SELECT * FROM get_avg_prices_by_prod_categories(); -- dont work

SELECT * FROM get_avg_prices_by_prod_categories() AS (sum_price real, avg_price float8); -- its works!

SELECT * FROM customers;
CREATE OR REPLACE FUNCTION get_customers_by_country(customer_country varchar)
		RETURNS TABLE(char_code char, company_name varchar) AS $$
		
	SELECT customer_id, company_name	
	FROM customers
	WHERE country = customer_country
	
$$ LANGUAGE SQL;

SELECT * FROM get_customers_by_country('USA');
SELECT company_name FROM get_customers_by_country('USA');
SELECT char_code, company_name FROM get_customers_by_country('USA');

DROP FUNCTION get_customers_by_country;
CREATE OR REPLACE FUNCTION get_customers_by_country(customer_country varchar)
		RETURNS SETOF customers AS $$
	
	--wont work SELECT company_name, contact_name
	SELECT *	
	FROM customers
	WHERE country = customer_country
	
$$ LANGUAGE SQL;

SELECT * FROM get_customers_by_country('USA');
SELECT company_name FROM get_customers_by_country('USA');
SELECT contact_name AS contact, company_name FROM get_customers_by_country('USA');

------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION get_total_number_of_goods() RETURNS bigint AS $$
BEGIN
	RETURN SUM(units_in_stock)
	FROM products;
END
$$ LANGUAGE plpgsql;

SELECT get_total_number_of_goods();

CREATE OR REPLACE FUNCTION get_max_price_from_discontinued() RETURNS real AS $$
BEGIN
	RETURN MAX(unit_price)
	FROM products
	WHERE discontinued = 1;
END
$$ LANGUAGE plpgsql;

SELECT get_max_price_from_discontinued();

CREATE OR REPLACE FUNCTION get_price_boundaries(OUT max_price real, OUT min_price real) AS $$
BEGIN
	--max_price := MAX (unit_price) FROM products;
	--min_price := MIN (unit_price) FROM products;
	SELECT MAX(unit_price), MIN(unit_price)
	INTO max_price, min_price
	FROM products;
END
$$ LANGUAGE plpgsql;

SELECT get_price_boundaries();
SELECT * FROM get_price_boundaries();


CREATE OR REPLACE FUNCTION get_sum(x int, y int, OUT result int) AS $$
BEGIN
	result := x + y; -- result = x + y its works
	--RETURN;
END
$$ LANGUAGE plpgsql;

SELECT * FROM get_sum(2, 3);

DROP FUNCTION IF EXISTS get_customers_by_country();
CREATE OR REPLACE FUNCTION get_customers_by_country(customer_country varchar) RETURNS SETOF customers AS $$
BEGIN
	RETURN QUERY
	SELECT *
	FROM customers
	WHERE country = customer_country;
END
$$ LANGUAGE plpgsql;

SELECT * FROM get_customers_by_country('USA');

-----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION get_square(ab real, bc real, ac real) RETURNS real AS $$
DECLARE
	perimeter real;
BEGIN
	perimeter = (ab + bc + ac) / 2;
	return sqrt(perimeter * (perimeter - ab) * (perimeter - ac) * (perimeter - bc));
END
$$ LANGUAGE plpgsql;

SELECT get_square(6, 6, 6);


CREATE OR REPLACE FUNCTION calc_middle_price() RETURNS SETOF products AS $$
DECLARE
	avg_price real;
	low_price real;
	high_price real;
BEGIN
	SELECT AVG(unit_price) INTO avg_price
	FROM products;
	
	low_price = avg_price * 0.75;
	high_price = avg_price * 1.25;
	
	RETURN QUERY
	SELECT *
	FROM products
	WHERE unit_price BETWEEN low_price AND high_price;
END
$$ LANGUAGE plpgsql;

SELECT * FROM calc_middle_price();

--------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION convert_temp_to(temperature real, isCelsius bool DEFAULT true) RETURNS real AS $$
DECLARE
	result_temp real;
BEGIN
	IF isCelsius THEN 
		result_temp = (5.0/9.0) * (temperature - 32);
	ELSE result_temp = (9 * temperature + (32 * 5)) / 5.0;
	END IF;
	
	RETURN result_temp;
END
$$ LANGUAGE plpgsql;


SELECT convert_temp_to(80);
SELECT convert_temp_to(26.7, false);


CREATE FUNCTION get_season(month_number int) RETURNS text AS $$
DECLARE
	season text;
BEGIN
	IF month_number BETWEEN 3 AND 5 THEN
		season = 'Spring';
	ELSEIF month_number BETWEEN 6 AND 8 THEN
		season = 'Summer';
	ELSEIF month_number BETWEEN 9 AND 11 THEN
		season = 'Autumn';
	ELSE
		season = 'Winter';
	END IF;
	
	RETURN season;
END
$$ LANGUAGE plpgsql;


SELECT get_season(12);
SELECT get_season(6);
SELECT get_season(3);
SELECT get_season(9);

----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fib(n int) RETURNS int AS $$
DECLARE
	counter int = 0;
	i int = 0;
	j int = 1;
BEGIN
	IF n < 1 THEN
		RETURN 0;
	END IF;
	
	WHILE counter < n
	LOOP
		counter = counter + 1;
		SELECT j, i + j INTO i, j;
	END LOOP;
	
	RETURN i; -- ?
END
$$ LANGUAGE plpgsql;

SELECT fib(4);


CREATE OR REPLACE FUNCTION fib(n int) RETURNS int AS $$
DECLARE
	counter int = 0;
	i int = 0;
	j int = 1;
BEGIN
	IF n < 1 THEN
		RETURN 0;
	END IF;
	
	LOOP
		EXIT WHEN counter > n;
		counter = counter + 1;
		SELECT j, i + j INTO i, j;
	END LOOP;
	
	RETURN i; -- ?
END
$$ LANGUAGE plpgsql;


DO $$
BEGIN
	FOR counter IN 1..5
	LOOP
		RAISE NOTICE 'Counter: %', counter;
	END LOOP;
END$$;

DO $$
BEGIN
	FOR counter IN REVERSE 5..1
	LOOP
		RAISE NOTICE 'Counter: %', counter;
	END LOOP;
END$$;

DO $$
BEGIN
	FOR counter IN 1..10 BY 2
	LOOP
		RAISE NOTICE 'Counter: %', counter;
	END LOOP;
END$$;

------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION return_ints() RETURNS SETOF int AS $$
BEGIN
	RETURN NEXT 1;
	RETURN NEXT 2;
	RETURN NEXT 3;
	--RETURN;
END
$$ LANGUAGE plpgsql;

SELECT * FROM return_ints();


CREATE OR REPLACE FUNCTION after_christmas_sale() RETURNS SETOF products AS $$
DECLARE
	product record;	
BEGIN
	FOR product IN SELECT * FROM products
	LOOP
		IF product.category_id IN (1, 4, 8) THEN
			product.unit_price = product.unit_price * 0.8;
		ELSEIF product.category_id IN (2, 3, 7) THEN
			product.unit_price = product.unit_price * 0.75;
		ELSE product.unit_price = product.unit_price * 1.1;
		END IF;
		
		RETURN NEXT product;
	END LOOP;
END
$$ LANGUAGE plpgsql;


SELECT * FROM products;
SELECT * FROM after_christmas_sale();

---------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION backup_customers() RETURNS void AS $$
	DROP TABLE IF EXISTS backedup_customers;
	
	--SELECT * INTO backedup_customers FROM customers;
	CREATE TABLE backedup_customers AS
	SELECT * FROM customers;
$$ LANGUAGE SQL;


SELECT backup_customers();
SELECT COUNT(*) FROM backedup_customers;
SELECT COUNT(*) FROM customers;


CREATE OR REPLACE FUNCTION get_avg_freight() RETURNS float8 AS $$
	SELECT AVG(freight)
	FROM orders;
$$ LANGUAGE SQL;

SELECT * FROM get_avg_freight();


CREATE OR REPLACE FUNCTION random_between(low int, high int) RETURNS int AS $$
BEGIN
	RETURN floor(random() * (high - low) + low);	
END
$$ LANGUAGE plpgsql;


SELECT random_between(1, 8)
FROM generate_series(1, 10);



CREATE OR REPLACE FUNCTION get_salary_by_city(emp_city varchar, OUT min_salary numeric, OUT max_salary numeric) AS $$
	SELECT MIN(salary), MAX(salary)
	FROM employees
	WHERE city = emp_city;
$$ LANGUAGE SQL;

SELECT * FROM get_salary_by_city('London');
SELECT * FROM employees;


CREATE OR REPLACE FUNCTION correct_salary(upper_boundary numeric DEFAULT 70, 
										  correction_rate numeric DEFAULT 0.15) RETURNS void AS 
$$
	UPDATE employees
	SET salary = salary + (salary * correction_rate)
	WHERE salary <= upper_boundary;
$$ LANGUAGE SQL;

SELECT correct_salary();
SELECT salary FROM employees ORDER BY salary;

DROP FUNCTION IF EXISTS correct_salary;
CREATE OR REPLACE FUNCTION correct_salary(upper_boundary numeric DEFAULT 70, 
										  correction_rate numeric DEFAULT 0.15) RETURNS SETOF employees AS 
$$
	UPDATE employees
	SET salary = salary + (salary * correction_rate)
	WHERE salary <= upper_boundary
	RETURNING *;
$$ LANGUAGE SQL;

SELECT * FROM correct_salary();
SELECT salary FROM employees ORDER BY salary;


DROP FUNCTION IF EXISTS correct_salary;
CREATE OR REPLACE FUNCTION correct_salary(upper_boundary numeric DEFAULT 70, 
										  correction_rate numeric DEFAULT 0.15) 
										  RETURNS TABLE(last_name text, first_name text, title text, salary numeric) AS 
$$
	UPDATE employees
	SET salary = salary + (salary * correction_rate)
	WHERE salary <= upper_boundary
	RETURNING last_name, first_name, title, salary;
$$ LANGUAGE SQL;

SELECT * FROM correct_salary();





