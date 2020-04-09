-- Tragicomic Query

select distinct c.actor
from casts c
    inner join
    (
    select title, director
    from genres_movies
    where genre in ('Drama', 'Comedy')
    group by title, director
    having count(title) > 1
    ) m
on m.title = c.title and m.director = c.director;

-- Tragicomic Tests
-- this is tested by counting the number of actors in movies that are both comedy and drama, adding an entry,
-- and seeing the chane in the db state


delete from stars where name = 'fsdb260';
select count(distinct c.actor)
from casts c
    inner join
    (
    select title, director
    from genres_movies
    where genre in ('Drama', 'Comedy')
    group by title, director
    having count(title) > 1
    ) m
on m.title = c.title and m.director = c.director;

insert into stars (name) values ('fsdb260');

-- The second mother is a movie that is both a drama and a comedy
insert into casts (actor, title, director) values ('fsdb260', 'The Second Mother', 'Anna Muylaert');

select count(distinct c.actor)
from casts c
    inner join
    (
    select title, director
    from genres_movies
    where genre in ('Drama', 'Comedy')
    group by title, director
    having count(title) > 1
    ) m
on m.title = c.title and m.director = c.director;

-- Burden-User Query

select *
from users
    where REG_DATE <= add_months(sysdate,-6)
    and NICK not in (select NICK from membership)
    and NICK not in (select nick from profiles
join contracts on (profiles.citizenID = contracts.citizenID));

-- Burder-User Tests
-- This is tested by counting the number of users who meet the conditions in the question and have been registered for 
-- more than 6 months and then adds a single entry and looks for a change between the two numbers

delete from users where nick = 'fsdb260';
select count(*)
from users
    where REG_DATE <= add_months(sysdate,-6)
    and NICK not in (select NICK from membership)
    and NICK not in (select nick from profiles
join contracts on (profiles.citizenID = contracts.citizenID));

insert into users (nick, password, email, reg_date) values ('fsdb260', '123456789', 'fsdb@gmail.com', '11-MAY-19');

select count(*)
from users
    where REG_DATE <= add_months(sysdate,-6)
    and NICK not in (select NICK from membership)
    and NICK not in (select nick from profiles
join contracts on (profiles.citizenID = contracts.citizenID));

