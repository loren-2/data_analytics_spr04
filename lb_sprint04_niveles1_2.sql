
-- Nivel 1
-- Creo una base de datos nueva y le llamo sales_track
CREATE DATABASE IF NOT EXISTS sales_track;
    USE sales_track;
  
-- creo estructura de tabla companies 
CREATE TABLE IF NOT EXISTS companies (
        company_id VARCHAR(15) PRIMARY KEY,
        company_name VARCHAR(255),
        phone VARCHAR(20),
        email VARCHAR(100),
        country VARCHAR(100),
        website VARCHAR(255)
    );
 
 -- Quiero importar la informacion del archivo 
 -- Primero, asegúrate de que MySQL está configurado para permitir la carga de archivos locales
 show global variables like 'local_infile';
 
 -- Si 'local_infile' está OFF, lo activo con esta línea de comandos:
 set global local_infile = 1;
 
 -- Renombro la tabla company como companies
 alter table company rename to companies;
 
 -- Importo la info del archivo companies.csv
load data local infile 'C:/Users/eniom/it_academy/da_sprint04'
into table companies
fields terminated by ',' 
lines terminated by '\n' 
ignore 1 rows; 

/* No me permite importar la info. Aparece este mensaje
Error Code: 2068. LOAD DATA LOCAL INFILE file request rejected due to restrictions on access.*/

-- Verifico si se trata de este problema con la linea de comandos de abajo
SHOW VARIABLES LIKE 'secure_file_priv';

-- Coloco archivos companies.csv en el directorio que me indica secure_file_priv: "C:\ProgramData\MySQL\MySQL Server 8.0\Uploads"
-- No usaré la instrucción "local data infile" sino solo "data infile"

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/companies.csv'
into table companies
fields terminated by ',' 
lines terminated by '\n' 
ignore 1 rows; 

select * from companies;

-- Creo tabla credit_cards 
CREATE TABLE IF NOT EXISTS credit_cards (
    id VARCHAR(15) PRIMARY KEY,
    user_id SMALLINT UNSIGNED, 
    iban VARCHAR(40),
    pan VARCHAR(20) UNIQUE,
    pin SMALLINT UNSIGNED,
    cvv  SMALLINT UNSIGNED,
    track1 VARCHAR(50),
    track2 VARCHAR(50),
    expiring_date VARCHAR (20)
);

-- Importo datos desde archivo credit_cards.csv
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/credit_cards.csv'
into table credit_cards
fields terminated by ',' 
lines terminated by '\n' 
ignore 1 rows; 

select * FROM credit_cards;

-- Creo tabla users
CREATE TABLE IF NOT EXISTS users (
    id SMALLINT UNSIGNED PRIMARY KEY,
    name VARCHAR (100 ), 
    surname VARCHAR(100),
    phone VARCHAR(50),
    email VARCHAR (100),
    birth_date  VARCHAR (50),
    country VARCHAR(50),
    city VARCHAR(50),
    postal_code VARCHAR (15),
    address VARCHAR (255)
);

describe users;

-- Importo la informacion de los archivos users_usa, users_uk, users_ca
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_usa.csv'
into table users
fields terminated by ',' 
enclosed by '"'
lines terminated by '\r\n' 
ignore 1 rows; 

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_uk.csv'
into table users
fields terminated by ',' 
enclosed by '"'
lines terminated by '\r\n' 
ignore 1 rows; 

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_ca.csv'
into table users
fields terminated by ',' 
enclosed by '"'
lines terminated by '\r\n' 
ignore 1 rows; 

select * from users;

-- Creo tabla transactions

CREATE TABLE IF NOT EXISTS transactions (
        id VARCHAR(40) PRIMARY KEY,
        card_id VARCHAR(15),
        business_id VARCHAR(15), 
        timestamp TIMESTAMP,
        amount DECIMAL(10, 2),
        declined TINYINT NOT NULL DEFAULT 0,
        product_ids VARCHAR(150),
        user_id SMALLINT UNSIGNED,
        lat DECIMAL(15,10),
        longitude DECIMAL(15,10),
        FOREIGN KEY (business_id) REFERENCES companies(company_id),      
        FOREIGN KEY (card_id) REFERENCES credit_cards(id),
        FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Inserto datos en tabla transactions
load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\transactions.csv'
into table transactions
fields terminated by ';' 
lines terminated by '\r\n' 
ignore 1 rows; 

select * from transactions;

-- Nivel 1
-- Ejercicio 1
-- Realiza una subconsulta que muestre a todos los usuarios con más de 30 transacciones utilizando al menos 2 tablas.

-- esta 1ª subconsulta la realizo para tener una idea de cuales usuarios han tenido mas transacciones
select id as transactions,
user_id, 
(select u.name from users as u where u.id = user_id) as user_name, 
(select u.surname from users as u where u.id = user_id) as user_surname
from transactions
group by user_id, user_name, user_surname, id;

/* Esta consulta me muestra cuantas transacciones tiene cada usuario en orden descendente:
select count(id) as transaction_count, 
user_id, 
(select u.name from users as u where u.id = user_id) as user_name, 
(select u.surname from users as u where u.id = user_id) as user_surname
from transactions
group by user_id, user_name, user_surname
order by count(id) desc;*/

-- Esta consulta ya muestra todos los usuarios que tienen mas de 30 transacciones
select count(id) as transaction_count, 
user_id, 
(select u.name from users as u where u.id = user_id) as user_name, 
(select u.surname from users as u where u.id = user_id) as user_surname
from transactions
group by user_id
having count(id) > 30
order by count(id) desc;

--  Ejercicio 2
-- Muestra la media de amount por IBAN de las tarjetas de crédito en la compañía Donec Ltd., utiliza por lo menos 2 tablas.
-- Busco en la tabla companies cual es el id de la empresa Donec: Es el b-2242
select * from companies 
where company_name like 'Donec%';

/*De la tabla transactions, muestro todas las transacciones que hizo la empresa Donec Ltd, así tengo una idea de cuáles
han sido las transacciones realizadas. Veo que solo hay 2, una de ellas declinada*/
select * from transactions
where business_id = 'b-2242';

-- Muestro la media de amount por IBAN de las tarjetas de crédito en la compañía Donec Ltd
select company_id, company_name, round(avg(amount),2) as average_order, card_id, iban
from companies
join transactions on business_id = company_id
join credit_cards as cc on cc.id = card_id
where company_name = 'Donec Ltd' and declined = 0
group by company_id, company_name, card_id, iban;

-- NIVEL 2
/*Crea una nueva tabla que refleje el estado de las tarjetas de crédito basado en si las últimas 
tres transacciones fueron declinadas y genera la siguiente consulta:

Ejercicio 1
-- ¿Cuántas tarjetas están activas?*/
 -- Hago esta consulta para tener una idea de cuales tarjetas han sido declinadas. 
 -- A primera vista, no hay tarjetas que hayan sido declinadas 3 veces
select card_id, pan, iban, timestamp, count(declined) as declined_count
from transactions as t
join credit_cards as cc on cc.id = card_id
where declined = 1
group by card_id, pan, iban, timestamp
order by timestamp desc;

-- Creo una vista ranked_transactions en la que todas las transacciones están ordenadas por card_id y rankeadas 
-- por timestamp
create view ranked_transactions as 
select card_id, pan, iban, timestamp, declined, 
row_number() over (partition by card_id order by timestamp desc) as ranked_declined_transactions
from transactions 
join credit_cards as cc on cc.id = card_id;

select * from ranked_transactions;

-- Creo una tabla credit_card_status haciendo una consulta a la view ranked_transactions 
create table credit_card_status as
select card_id, pan, iban, 
case 
	when sum(declined) >= 3 then 'Blocked'
    else 'Active'
    end as card_status
from ranked_transactions
where ranked_declined_transactions <= 3
group by card_id, pan, iban;

select * from credit_card_status;

-- Hago consulta de cuantas tarjetas están activas
select count(*) from credit_card_status
where card_status = 'Active';


 
























 
 
 
 
