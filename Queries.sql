-- Tragicomic Query

-- select distinct c.actor
-- from casts c
    -- inner join
    -- (
    -- select title, director
    -- from genres_movies
    -- where genre in ('Drama', 'Comedy')
    -- group by title, director
    -- having count(title) > 1
    -- ) m
-- on m.title = c.title and m.director = c.director;

-- -- Tragicomic Tests
-- -- this is tested by counting the number of actors in movies that are both comedy and drama, adding an entry,
-- -- and seeing the chane in the db state

-- delete from stars where name = 'fsdb260';
-- select count(distinct c.actor)
-- from casts c
    -- inner join
    -- (
    -- select title, director
    -- from genres_movies
    -- where genre in ('Drama', 'Comedy')
    -- group by title, director
    -- having count(title) > 1
    -- ) m
-- on m.title = c.title and m.director = c.director;

-- insert into stars (name) values ('fsdb260');

-- -- The second mother is a movie that is both a drama and a comedy
-- insert into casts (actor, title, director) values ('fsdb260', 'The Second Mother', 'Anna Muylaert');

-- select count(distinct c.actor)
-- from casts c
    -- inner join
    -- (
    -- select title, director
    -- from genres_movies
    -- where genre in ('Drama', 'Comedy')
    -- group by title, director
    -- having count(title) > 1
    -- ) m
-- on m.title = c.title and m.director = c.director;

-- -- Burden-User Query

-- select *
-- from users
    -- where REG_DATE <= add_months(sysdate,-6)
    -- and NICK not in (select NICK from membership)
    -- and NICK not in (select nick from profiles
-- join contracts on (profiles.citizenID = contracts.citizenID));

-- -- Burder-User Tests
-- -- This is tested by counting the number of users who meet the conditions in the question and have been registered for 
-- -- more than 6 months and then adds a single entry and looks for a change between the two numbers

-- delete from users where nick = 'fsdb260';
-- select count(*)
-- from users
    -- where REG_DATE <= add_months(sysdate,-6)
    -- and NICK not in (select NICK from membership)
    -- and NICK not in (select nick from profiles
-- join contracts on (profiles.citizenID = contracts.citizenID));

-- insert into users (nick, password, email, reg_date) values ('fsdb260', '123456789', 'fsdb@gmail.com', '11-MAY-19');

-- select count(*)
-- from users
    -- where REG_DATE <= add_months(sysdate,-6)
    -- and NICK not in (select NICK from membership)
    -- and NICK not in (select nick from profiles
-- join contracts on (profiles.citizenID = contracts.citizenID));

-- -- FilmMaster Query
delete from users where nick = 'fsdb260';
delete from membership where nick = 'fsdb260';
delete from proposals where member = 'fsdb260';
delete from comments where nick = 'fsdb260';

select *
from
(
select avg(numComments), director
from
(
select count(*) as numComments, m.director, m.title
from movies m
join comments c on (c.director = m.director and c.title = m.title)
group by m.director, m.title
)
group by (director)
order by avg(numComments) desc
)
where rownum = 1;

-- FilmMaster Tests
-- At first the director with the most comments average comments per film is Joshua Michael Stern, however after adding comments to a Caryn Waechter movie, she then becomes the filmMaster
select *
from
(
select avg(numComments), director
from
(
select count(*) as numComments, m.director, m.title
from movies m
join comments c on (c.director = m.director and c.title = m.title)
group by m.director, m.title
)
group by (director)
order by avg(numComments) desc
)
where rownum <= 2;


set termout off;

insert into users (nick, password, email, reg_date) values ('fsdb260', '123456789', 'fsdb260@gmail.com', '3-apr-18');
insert into membership (nick, club, mentor, type, req_date, inc_date, end_date, req_msg, acc_msg)
values ('fsdb260', 'Job Club', NULL, 'F', '18-JUL-19', '19-JUL-19', NULL, NULL, NULL);
insert into proposals (title, director, club, member, prop_date, slogan, message)
values ('The Sisterhood of Night', 'Caryn Waechter', 'Job Club', 'fsdb260', '20-JUL-19', NULL, NULL);

insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '20-JUL-19', 'The Sisterhood of Night', 'Caryn Waechter', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '20-JUL-19', 'The Sisterhood of Night', 'Caryn Waechter', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '20-JUL-19', 'The Sisterhood of Night', 'Caryn Waechter', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '20-JUL-19', 'The Sisterhood of Night', 'Caryn Waechter', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '20-JUL-19', 'The Sisterhood of Night', 'Caryn Waechter', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '20-JUL-19', 'The Sisterhood of Night', 'Caryn Waechter', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '20-JUL-19', 'The Sisterhood of Night', 'Caryn Waechter', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '20-JUL-19', 'The Sisterhood of Night', 'Caryn Waechter', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '20-JUL-19', 'The Sisterhood of Night', 'Caryn Waechter', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '20-JUL-19', 'The Sisterhood of Night', 'Caryn Waechter', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '20-JUL-19', 'The Sisterhood of Night', 'Caryn Waechter', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '20-JUL-19', 'The Sisterhood of Night', 'Caryn Waechter', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '20-JUL-19', 'The Sisterhood of Night', 'Caryn Waechter', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '20-JUL-19', 'The Sisterhood of Night', 'Caryn Waechter', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '20-JUL-19', 'The Sisterhood of Night', 'Caryn Waechter', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '20-JUL-19', 'The Sisterhood of Night', 'Caryn Waechter', NULL, NULL, NULL);

set termout on;

select *
from
(
select avg(numComments), director
from
(
select count(*) as numComments, m.director, m.title
from movies m
join comments c on (c.director = m.director and c.title = m.title)
group by m.director, m.title
)
group by (director)
order by avg(numComments) desc
)
where rownum <= 2;
