drop view administer_pub;
drop view favorite_genres;
drop view pending;

-- drop user fsdb259_test;
-- create user fsdb259_test identified by 123456789;
-- grant select on administer_pub to fsdb259_test;
-- grant select on favorite_genres to fsdb259_test;
-- grant select on pending to fsdb259_test;

delete from users where nick = 'JAY';
delete from users where nick = 'jay';
delete from users where nick = 'fsdb259_test1';
delete from candidates where nick = 'fsdb259_test1';
delete from membership where nick = 'JAY';
delete from membership where nick = 'jay';
delete from clubs where name like '%fsdb259%';


-- THESE NEED TO BE VIEWS AND ALSO PRIVILEDGES
create view administer_pub
as
(
select commentcount/propcount as commentpercent, c.nick as member, c.lastcomment
from
(
    select club, count(*) as propcount
    from proposals
    group by club
) p
inner join
(
    select count(*) as commentcount, nick, club, max(msg_date) as lastcomment
    from comments
    group by club, nick
)
c on c.club = p.club
where c.club in
(
    select name
    from clubs
    where LOWER(founder) = (
        select LOWER(sys_context('USERENV', 'CURRENT_USER'))
        from dual
    )
)
);

create view favorite_genres
as
(
    select c.club, g.genre, avg(valoration) as avg_rating
    from
    comments c
    inner join
    genres_movies g
    on c.title = g.title and c.director = g.director
    where c.club in
    (
        select name
        from clubs
        where LOWER(founder) = (
            select LOWER(sys_context('USERENV', 'CURRENT_USER'))
            from dual
            )
    )
    group by g.genre, c.club
)
order by c.club, avg_rating desc;

create view pending
as
(
    select nick, club, member, type, req_date, req_msg
    from candidates
    where rej_date is null and rej_msg is null and
    club in
    (
        select name
        from clubs
        where LOWER(founder) = (
            select LOWER(sys_context('USERENV', 'CURRENT_USER'))
            from dual
            )
    )
);

-- Testing
-- Select from administer_pub shows that there are no clubs for the current user,
-- however after adding the user club proposals and comments you can see the query on administer_pub
-- has changed

-- Selecting from favorite_genres shows that there are no ratings because there are no prosols or comments for movies. Once these are made you can see that each ganre has an avergae rating of 5.

-- Selecting from pending shows no rows, however after you add a new user and add them to the candidates list, they are automatically put onto the pending if they dont have a rej dat or msg

select * from administer_pub;

select * from favorite_genres;

-- set termout off;
insert into users (nick, password, email, reg_date) values (
    (select sys_context('USERENV', 'CURRENT_USER') from dual)
    , '123456789', 'fsdb259@gmail.com', '3-apr-18');
insert into clubs (Name, Founder, cre_date, end_date, slogan, open) values ('fsdb259_club',
    (select sys_context('USERENV', 'CURRENT_USER') from dual)
, '19-JUL-19', NULL, NULL, 'O');
insert into membership (Nick, club, mentor, type, req_date, inc_date, end_date, req_msg, acc_msg)
values (
    (select sys_context('USERENV', 'CURRENT_USER') from dual)
    , 'fsdb259_club', NULL, 'F', '19-JUL-19', '20-JUL-19', NULL, NULL, NULL);
insert into proposals (title, director, club, member, prop_date, slogan, message)
values ('The Rock', 'Michael Bay', 'fsdb259_club',
    (select sys_context('USERENV', 'CURRENT_USER') from dual)
    , '20-JUL-19', NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('fsdb259_club',
    (select sys_context('USERENV', 'CURRENT_USER') from dual)
    , '20-JUL-19', 'The Rock', 'Michael Bay', NULL, NULL, 5);

-- set termout on;

select * from administer_pub;

select * from favorite_genres;

select * from pending;

set termout off;
insert into users (nick, password, email, reg_date)
values ('fsdb259_test1', '123456789', 'fsdb259_test1@gmail.com', '3-apr-18');
insert into candidates (nick, club, member, type, req_date, req_msg, rej_date, rej_msg)
values ('fsdb259_test1', 'fsdb259_club',
    (select sys_context('USERENV', 'CURRENT_USER') from dual)
    , 'I', '20-JUL-19', 'YO', NULL, NULL);
set termout on;

select * from pending;
