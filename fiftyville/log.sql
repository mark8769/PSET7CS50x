-- Keep a log of any SQL queries you execute as you solve the mystery.

/*
sqlite> .tables
airports              crime_scene_reports   people              
atm_transactions      flights               phone_calls         
bakery_security_logs  interviews          
bank_accounts         passengers   
*/

/*
CREATE TABLE crime_scene_reports (
    id INTEGER,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    street TEXT,
    description TEXT,
    PRIMARY KEY(id)
);
CREATE TABLE interviews (
    id INTEGER,
    name TEXT,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    transcript TEXT,
    PRIMARY KEY(id)
);
CREATE TABLE atm_transactions (
    id INTEGER,
    account_number INTEGER,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    atm_location TEXT,
    transaction_type TEXT,
    amount INTEGER,
    PRIMARY KEY(id)
);
CREATE TABLE bank_accounts (
    account_number INTEGER,
    person_id INTEGER,
    creation_year INTEGER,
    FOREIGN KEY(person_id) REFERENCES people(id)
);
CREATE TABLE airports (
    id INTEGER,
    abbreviation TEXT,
    full_name TEXT,
    city TEXT,
    PRIMARY KEY(id)
);
CREATE TABLE flights (
    id INTEGER,
    origin_airport_id INTEGER,
    destination_airport_id INTEGER,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    hour INTEGER,
    minute INTEGER,
    PRIMARY KEY(id),
    FOREIGN KEY(origin_airport_id) REFERENCES airports(id),
    FOREIGN KEY(destination_airport_id) REFERENCES airports(id)
);
CREATE TABLE passengers (
    flight_id INTEGER,
    passport_number INTEGER,
    seat TEXT,
    FOREIGN KEY(flight_id) REFERENCES flights(id)
);
CREATE TABLE phone_calls (
    id INTEGER,
    caller TEXT,
    receiver TEXT,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    duration INTEGER,
    PRIMARY KEY(id)
);
CREATE TABLE people (
    id INTEGER,
    name TEXT,
    phone_number TEXT,
    passport_number INTEGER,
    license_plate TEXT,
    PRIMARY KEY(id)
);
CREATE TABLE bakery_security_logs (
    id INTEGER,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    hour INTEGER,
    minute INTEGER,
    activity TEXT,
    license_plate TEXT,
    PRIMARY KEY(id)
);


*/

/*// look at crime scene report for July 28, 2021, that took place on Humphrey Street 

SELECT description 
FROM crime_scene_reports
WHERE month = 7 AND day = 28 AND year = 2021
AND street = "Humphrey Street";

--> Theft of the CS50 duck took place at 10:15am at the Humphrey Street bakery. 
Interviews were conducted today with three witnesses who were present at the time – each 
of their interview transcripts mentions the bakery.
Littering took place at 16:36. No known witnesses.


ADDTIONAL INFORMATION FROM QUERY:

- theft took place at 10:15 AM on Humphrey Street bakery
- Three witnessed, each interview transcript mentions bakery
	- look at interviews table: SELECT transcript FROM interviews WHERE transcript LIKE "%bakery%";
	- using bottom line to confirm there are 4 transcripts and not 3, messy output in terminal
	- there are 4 transcripts not 3 SELECT COUNT(transcript) FROM interviews WHERE transcript LIKE "%bakery%"; 
	
		- Sometime within ten minutes of the theft, I saw the thief get into a car in the bakery 
		  parking lot and drive away. 
		  If you have security footage from the bakery parking lot, you might want to look for cars that 
		  left the parking lot in that time frame.
		  
		  	- SELECT activity, hour, minute FROM bakery_security_logs WHERE year = 2021 AND month = 7 AND day = 28;
		  	- ALternatively which is better
		  	- SELECT activity, hour, minute ,license_plate FROM bakery_security_logs WHERE year = 2021 AND month = 7 AND day = 28 AND hour = 10 AND minute < 26 AND minute > 14;
		  	- returns results as entrance or exit | hour | minute
		  	- want to look for an exit at around 10 minutes after or before 10:15 AM
		  	- 	entrance|9|14  
				entrance|9|15
				entrance|9|20
				entrance|9|28
				entrance|10|8
				entrance|10|14
				// only look at license plate for up to 10 minutes after theft
				// get additional details from people table. Id, name, phone_number, passport_number, license_plate
				// SELECT * FROM people WHERE license_plate IN (SELECT license_plate FROM bakery_security_logs WHERE year = 2021 AND month = 7 AND day = 28 AND hour = 10 AND minute < 26 AND minute > 14);
				exit|10|16|5P2BI95  221103|Vanessa|(725) 555-4692|2963008352|5P2BI95
				exit|10|18|94KL13X	686048|Bruce|(367) 555-5533|5773159633|94KL13X
				exit|10|18|6P58WS2	243696|Barry|(301) 555-4174|7526138472|6P58WS2
				exit|10|19|4328GD8	467400|Luca|(389) 555-5198|8496433585|4328GD8
				exit|10|20|G412CB7	398010|Sofia|(130) 555-0289|1695452385|G412CB7
				exit|10|21|L93JTIZ	396669|Iman|(829) 555-5269|7049073643|L93JTIZ
				exit|10|23|322W7JE	514354|Diana|(770) 555-1861|3592750733|322W7JE
				exit|10|23|0NTHK55	560886|Kelsey|(499) 555-9472|8294398571|0NTHK55
				exit|10|35|1106N58	449774|Taylor|(286) 555-6063|1988161715|1106N58
	
		
		- I don't know the thief's name, but it was someone I recognized. 
		  Earlier this morning, before I arrived at Emma's bakery, 
		  I was walking by the ATM on Leggett Street and saw the thief there withdrawing some money.
		 
		- As the thief was leaving the bakery, they called someone who talked to them for less than a minute. 
		  In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville 
		  tomorrow. The thief then asked the person on the other end of the phone to purchase the flight ticket.
		  
		  	- conflicting details here, did the person get in the car first or go make the phone call?
		  	- check for calls made withing 10 minutes of robbery, need names first though, so look deeper into license plates^^
		  
		- I saw Richard take a bite out of his pastry at the bakery before his pastry was stolen from him.
		
			- look for RICHARD in license plate security logs if he drove
			- Check what time he got there at, to confirm time of the robbery
				- query: SELECT * FROM people WHERE name = "Richard"; 
				         SELECT * FROM people WHERE name LIKE  "Richard"; /I guess this works better in case theres case sensitivity
				- only one richard in the database: 710572|Richard||7894166154|20Q418R
				- check logs
					- SELECT * FROM bakery_security_logs WHERE license_plate = "20Q418R";
		 
- Someone littered at 16:36, but no witnesses
	- look at bakery security logs: 
		SELECT activity 
		FROM bakery_security_logs 
		WHERE month = 7 
		AND day = 28 
		AND year = 2021 
		AND hour = 16
		AND minute = 36;
		// copy paste
		SELECT activity FROM bakery_security_logs WHERE month = 7 AND day = 28 AND hour = 16 AND minute = 36;


*/