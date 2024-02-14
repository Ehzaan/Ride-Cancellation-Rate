DROP TABLE IF EXISTS Trips;
CREATE TABLE Trips
(   id serial PRIMARY KEY ,
    client_id FLOAT NOT NULL,
    driver_id FLOAT NOT NULL,
    city_id   INT NOT NULL, 
    status VARCHAR(50),
    request_at date NOT NULL );
    

INSERT INTO trips
(    client_id,driver_id,city_id,status,request_at)
VALUES(1,10,1,'Completed','2023-07-12'),(2,11,1,'Cancelled_by_driver','2023-07-12'),(3,12,6,'Completed','2023-07-12'),(4,13,6,'Cancelled_by_client','2023-07-12'),(1,10,1,'Completed','2023-07-13'),(2,11,6,'Completed','2023-07-13'),(3,12,6,'Completed','2023-07-13'),(2,12,12,'Completed','2023-07-14'),(3,10,12,'Completed','2023-07-14'),(4,13,12,'Cancelled_by_driver','2023-07-14');

DROP TABLE IF EXISTS Users;
CREATE TABLE Users
(    user_id FLOAT NOT NULL,
     banned VARCHAR(15), 
     ROLE VARCHAR(15));
     
INSERT INTO Users
VALUES(1,'No','client'),(2,'Yes','client'),(3,'No','client'),(4,'No','client'),(10,'No','Driver'),(11,'No','Driver'),(12,'No','Driver'),(13,'No','Driver');

SELECT request_at AS DAY,(count::FLOAT/total::FLOAT) AS cancellation_rate  FROM (
SELECT DISTINCT(request_at),total,count(CASE WHEN status = 'Cancelled_by_client' THEN 'Cancelled_by_client'
WHEN status = 'Cancelled_by_driver' THEN 'Cancelled_by_driver' ELSE NULL END  ) FROM  (SELECT *,count(id) OVER(PARTITION BY request_at)  AS total FROM "public"."trips" AS T
JOIN "public"."users" AS U1
ON T.client_id = U1.user_id
JOIN "public"."users" AS U2
ON T.driver_id = U2.user_id
WHERE U1.banned = 'No' AND U2.banned = 'No'
ORDER BY request_at) AS a 
GROUP BY request_at,total ) AS b 

-- 



