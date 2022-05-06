-- Keep a log of any SQL queries you execute as you solve the mystery.
-- USE control+shift+upArrow/downArrow to do multi cursor on lines and make file nice looking

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
				
				// cross reference these names with bank accounts since we got to a dead end with Richard
				
				(SELECT * FROM bank_accounts INNER JOIN people ON bank_accounts.person_id = people.id); // joined table from people and bank accounts based on personal id numbe 
				
				SELECT * FROM 
			    (SELECT * FROM bank_accounts 
			    INNER JOIN people ON bank_accounts.person_id = people.id) 
			    WHERE license_plate IN 
			    (SELECT license_plate FROM bakery_security_logs WHERE year = 2021 AND month = 7 AND day = 28 AND hour = 10 AND minute < 26 AND minute > 14); 
					- /account_number/person_id/creation_year/id/name/phone_number/passport_number/license_plate
					
					- 49610011|686048|2010|686048|Bruce|(367) 555-5533|5773159633|94KL13X
					
							SELECT * FROM atm_transactions WHERE account_number = 49610011;
							39|49610011|2021|7|26|Leggett Street|withdraw|10
							267|49610011|2021|7|28|Leggett Street|withdraw|50
							
					- 26013199|514354|2012|514354|Diana|(770) 555-1861|3592750733|322W7JE
							
							17|26013199|2021|7|26|Leggett Street|deposit|55
							336|26013199|2021|7|28|Leggett Street|withdraw|35
							
					- 25506511|396669|2014|396669|Iman|(829) 555-5269|7049073643|L93JTIZ  PROBABLY NOT IMAN EITHER
							29|25506511|2021|7|26|Leggett Street|deposit|55
							288|25506511|2021|7|28|Leggett Street|withdraw|20
							
					- 28500762|467400|2014|467400|Luca|(389) 555-5198|8496433585|4328GD8
							7|28500762|2021|7|26|Leggett Street|deposit|75
							246|28500762|2021|7|28|Leggett Street|withdraw|48
							
					- 56171033|243696|2018|243696|Barry|(301) 555-4174|7526138472|6P58WS2 PROBABLY NOT BARRY
							48|56171033|2021|7|26|Leggett Street|deposit|50
							183|56171033|2021|7|27|Blumberg Boulevard|deposit|20
							292|56171033|2021|7|28|Daboin Sanchez Drive|deposit|70    CANT BE BARRY BECASUE PERSON WITHDREW MONEY?
							386|56171033|2021|7|29|Blumberg Boulevard|withdraw|85
							391|56171033|2021|7|29|Daboin Sanchez Drive|withdraw|20
							441|56171033|2021|7|29|Humphrey Lane|withdraw|90
							759|56171033|2021|7|30|Humphrey Lane|withdraw|55
							778|56171033|2021|7|30|Blumberg Boulevard|withdraw|40
							844|56171033|2021|7|31|Daboin Sanchez Drive|deposit|80
							909|56171033|2021|7|31|Carvalho Road|withdraw|75
							1295|56171033|2021|8|1|Carvalho Road|withdraw|55
					
					//check these account numbers with atm_transactions, change last query to only get account_numbers
				SELECT account_number FROM (SELECT account_number,license_plate INNER JOIN people ON bank_accounts.person_id = people.id) WHERE license

							
		- I don't know the thief's name, but it was someone I recognized. 
		  Earlier this morning, before I arrived at Emma's bakery, 
		  I was walking by the ATM on Leggett Street and saw the thief there withdrawing some money.
		 
		- As the thief was leaving the bakery, they called someone who talked to them for less than a minute. 
		  In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville 
		  tomorrow. The thief then asked the person on the other end of the phone to purchase the flight ticket.
		  
		  	- conflicting details here, did the person get in the car first or go make the phone call?
		  	- check for calls made withing 10 minutes of robbery, need names first though, so look deeper into license plates^^
		  	
		  		- 221|(130) 555-0289|(996) 555-8899|2021|7|28|51
				- 224|(499) 555-9472|(892) 555-8872|2021|7|28|36
				- 233|(367) 555-5533|(375) 555-8161|2021|7|28|45   THIS IS BRUCE MAKING A PHONE CALL FIRST COLUMN, WITHDREW MONEY ON DAY OF ROBBERY
				- 234|(609) 555-5876|(389) 555-5198|2021|7|28|60   THIS IS LUCA RECEIVING A CALL SECOND COLUMN, WITHDREW MONEY ON DAY OF ROBBERY
				 CANT BE ROBBER SINCE THEY CALLED THE PERSON NOT RECEIVED
				- 251|(499) 555-9472|(717) 555-1342|2021|7|28|50
				- 254|(286) 555-6063|(676) 555-6554|2021|7|28|43
				- 255|(770) 555-1861|(725) 555-3243|2021|7|28|49   THIS IS DIANA MAKING A CALL FIRST COLUMN, WITHDREW MONEY ON DAY OF ROBBERY
				- 261|(031) 555-6622|(910) 555-3251|2021|7|28|38
				- 279|(826) 555-1652|(066) 555-9701|2021|7|28|55
				- 281|(338) 555-6650|(704) 555-2131|2021|7|28|54
				
				
				/* CHECK FOR AIRPORTS AND SEE IF THIS NARROWED DOWN LIFT OF DIANA AND BRUCE ARE ON THERE, check people they made calls too also
				/ 864400|Robin|(375) 555-8161||4V16VO0 bruce made a call to this person
				/ 847116|Philip|(725) 555-3243|3391710505|GW362R6 diana made a call to this person
				
				/CHECK FOR FLIGHTS ON 7/29
				SELECT * FROM flights WHERE month = 7 AND day = 29;
					id/origin_airport_id/destination_airport_id/year/month/day/hour/minute
					18|8|6|2021|7|29|16|0
					23|8|11|2021|7|29|12|15
					36|8|4|2021|7|29|8|20
					43|8|1|2021|7|29|9|30
					53|8|9|2021|7|29|15|20

				
					  
		- I saw Richard take a bite out of his pastry at the bakery before his pastry was stolen from him.
		
			- look for RICHARD in license plate security logs if he drove
			- Check what time he got there at, to confirm time of the robbery
				- query: SELECT * FROM people WHERE name = "Richard"; 
				         SELECT * FROM people WHERE name LIKE  "Richard"; /I guess this works better in case theres case sensitivity
				- only one richard in the database: 710572|Richard||7894166154|20Q418R
				- check logs
					- SELECT * FROM bakery_security_logs WHERE license_plate = "20Q418R";
		 				- 168|2021|7|27|10|54|entrance|20Q418R
						- 190|2021|7|27|13|38|exit|20Q418R
						
						- theft does not correspond to the day Richard was there? Maybe we grabbed the wrong richard?
						- Only one person in the database with Richard name in people table though
						- Unless Richard is some spy which probably not
						
						- Hmmm someone saw him eating a pastry before it was stolen from him, someone else said they recognized the thieft
						- Maybe richard comes all the time? Check for phone logs where his number appears
						
						- Check Richards phone records, and see if he made any calls on the day of the robbery, need to use his id from previous query
						 
							- SELECT * FROM phone_calls WHERE receiver OR caller = 7894166154;
							
							- He did not make any phone calls, so maybe he could be the robber?
							
						
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