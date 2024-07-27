USE DB84;

CREATE TABLE category(
	catcode INT PRIMARY KEY,
	title VARCHAR(100),
	description VARCHAR(1000)
);

CREATE TABLE product(
	prcode INT PRIMARY KEY,
	name VARCHAR(100),
	description VARCHAR(1000),
	price DECIMAL(38,8),
	stock INT,
	catcode INT FOREIGN KEY REFERENCES category(catcode) ON DELETE SET NULL
);

CREATE TABLE geoArea(
	geocode INT PRIMARY KEY,
	name VARCHAR(100),
	population INT
);

CREATE TABLE supplier(
	supcode INT PRIMARY KEY,
	SSN INT,
	brand VARCHAR(100),
	phone VARCHAR(50),
	street VARCHAR(100),
	number INT,
	city VARCHAR(100),
	ZIP INT,
	geocode INT FOREIGN KEY REFERENCES geoArea(geocode)
);

CREATE TABLE purchase(
	purcode INT PRIMARY KEY,
	date DATE,
	quantity INT,
	prcode INT FOREIGN KEY REFERENCES product(prcode) ON DELETE SET NULL,
	supcode INT FOREIGN KEY REFERENCES supplier(supcode) ON DELETE SET NULL
);

CREATE TABLE customer(
	custcode INT PRIMARY KEY,
	brand VARCHAR(100),
	SSN INT,
	phone VARCHAR(50),
	street VARCHAR(100),
	number INT,
	city VARCHAR(100),
	ZIP INT,
	geocode INT FOREIGN KEY REFERENCES geoArea(geocode)
);

CREATE TABLE regular(
	creditlimit INT,
	balance INT,
	custcode INT FOREIGN KEY REFERENCES customer(custcode) ON DELETE CASCADE
);

CREATE TABLE payment(
	paydate DATETIME PRIMARY KEY,
	amount INT,
	custcode INT FOREIGN KEY REFERENCES customer(custcode) ON DELETE CASCADE
);

CREATE TABLE orders(
	ordcode INT PRIMARY KEY,
	orderDate DATE,
	shipDate DATE,
	prcode INT FOREIGN KEY REFERENCES product(prcode) ON DELETE SET NULL,
	custcode INT FOREIGN KEY REFERENCES customer(custcode) ON DELETE SET NULL
);

CREATE TABLE quantity(
	quantity INT,
	ordcode INT FOREIGN KEY REFERENCES orders(ordcode),
	prcode INT FOREIGN KEY REFERENCES product(prcode)
);

