-- Active: 1696521590670@@127.0.0.1@3306@PROJ2

#list the top 10 companies in descending order of positive change in stock value from 2015
SELECT a.name, b.change_in_close
	FROM ticker_symbols a, stock_change b 
	WHERE a.code = b.code
	AND year = 2015
	ORDER BY b.change_in_close DESC
	LIMIT 10;

#list the total revenue_22_23_e9 from the tech companies in our database by sector in 2022-2023
SELECT sector, SUM(revenue_22_23_e9)
	FROM company_info
	GROUP BY sector;

#During which years in the 21st century did each state have emissions per capita below the national average
#during the same period?
SELECT * FROM emissions
	WHERE emissions_per_cap < (SELECT AVG(emissions_per_cap) FROM emissions
									WHERE year BETWEEN 2000 and 2021)
	AND year BETWEEN 2000 and 2021;

#How many times in the 21st century did each state have emissions per capita below the national average 
#during that same time period?
SELECT COUNT (DISTINCT year), state FROM emissions
WHERE emissions_per_cap < (SELECT AVG(emissions_per_cap) FROM emissions
									WHERE year BETWEEN 2000 and 2021)
	AND year BETWEEN 2000 and 2021
	GROUP BY state
	ORDER BY COUNT (DISTINCT year);

#What was the average emissions per capita in Texas from 2013 to 2021?
SELECT AVG(emissions_per_cap) FROM emissions
	WHERE state = 'texas' AND
	year BETWEEN 2013 AND 2021;

#During which years did Tesla have an increase in stock value of at least $20 AND 
#the emissions in the state it’s headquartered in were greater than the average emissions per capita from 2013 to 2021?
SELECT DISTINCT(a.year), a.code, a.change_in_close, c.emissions_per_cap
	FROM stock_change a, company_info b, emissions c, ticker_symbols d
	WHERE a.change_in_close >= 20 AND 
	c.state = b.state AND
	b.name = d.name AND 
    d.code = 'tsla' AND
    d.code = a.code AND 
	c.year = a.year AND
    c.emissions_per_cap > (SELECT AVG(c. emissions_per_cap) 
							FROM emissions c, company_info b, ticker_symbols d, stock_change a
							WHERE c.state = b.state AND
							b.name = d.name AND 
							d.code = 'tsla' AND
							d.code = a.code AND 
							c.year BETWEEN 2013 AND 2021);