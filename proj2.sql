CREATE DATABASE PROJ2

CREATE TABLE company_info (
name VARCHAR(40),
revenue_22_23_e9 VARCHAR(100),
market_cap_e12 DOUBLE(4,3),
emp_num INTEGER,
founded YEAR,
incomeTax_22_23_USD_e9 DOUBLE(5,3),
sector VARCHAR(30),
state VARCHAR(15),
PRIMARY KEY (name)
);
LOAD DATA LOCAL INFILE '/Users/rpi11/Desktop/Code/COSC 3510/Databases_P2/data/3NF/companies.csv'
INTO TABLE company_info
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

CREATE TABLE stock_change (
code VARCHAR(5),
year YEAR,
high FLOAT,
low FLOAT,
change_in_close FLOAT,
PRIMARY KEY (code, year)
);
LOAD DATA LOCAL INFILE '/Users/rpi11/Desktop/Code/COSC 3510/Databases_P2/data/3NF/stocks.csv'
INTO TABLE stock_change
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

CREATE TABLE ticker_symbols (
name VARCHAR(40),
code VARCHAR(5),
FOREIGN KEY (name) references company_info (name),
FOREIGN KEY (code) references stock_change (code),
PRIMARY KEY (name)
);
LOAD DATA LOCAL INFILE '/Users/rpi11/Desktop/Code/COSC 3510/Databases_P2/data/3NF/name_code_map.csv'
INTO TABLE ticker_symbols
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

CREATE TABLE emissions (
state VARCHAR(15),
year YEAR,
emissions_per_cap DOUBLE(3,1),
PRIMARY KEY (state, year)
);
LOAD DATA LOCAL INFILE '/Users/rpi11/Desktop/Code/COSC 3510/Databases_P2/data/3NF/emissions.csv'
INTO TABLE emissions
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;