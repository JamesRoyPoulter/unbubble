-- CREATE TABLE friends(
-- 	id serial4 primary key,
-- 	name varchar(30),
-- 	gender varchar(10),
-- 	status text,
-- 	birthday date
-- )


CREATE TABLE unbubble (
    id        serial4 primary key,
    title         varchar(40) NOT NULL,
    content       text,
    creation_date   date
);