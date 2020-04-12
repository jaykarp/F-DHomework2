drop view openPub;
drop view Anyone_goes;
drop view report;

-- create view openPub
create view openPub
as
(
select
name,
numMembers,
MONTHS_BETWEEN((SYSDATE), cre_date) as activity,
totalProposals / MONTHS_BETWEEN((SYSDATE), cre_date) as propPerMonth,
avgComPerProp
from clubs c
inner join
(select
    club,
    count(*) as numMembers
    from membership group by club
) m
on m.club = c.name
inner join
(select
    club,
    count(*) as totalProposals
    from proposals
    group by club
) p
on p.club = c.name
inner join
(
select avg(comPerProp) as avgComPerProp, club
from
( select count(*) as comPerProp, p.club from
comments c
inner join
proposals p
on p.title = c.title and p.director = c.director and c.club = p.club
group by p.title, p.director, p.club
)
group by club
) pr
on pr.club = c.name
where c.open = 'O'
);

-- OpenPub Testing
 -- This test inserts a new club with one proposal and one comment. It htne shows that before inserting the table is blank, but afterwards,
-- the identification, number of mumbers, proposals per month and average comment per proposal all match with the insertions. Ie 
-- 1 member inserted, 1 comment per 1 proposal, 1 proposal per 1 day of existance and time since creation.
delete from users where nick = 'fsdb261';
delete from clubs where name = 'fsdb261_test';
delete from membership where nick = 'fsdb261';
delete from proposals where member = 'fsdb261';
delete from comments where nick = 'fsdb261';

select * from openPub where name = 'fsdb261_test';

set termout off;
insert into users (nick, password, email, reg_date) values ('fsdb261', '123456789', 'fsdb261@gmail.com', '3-apr-18');
insert into clubs (name, founder, cre_date, end_date, slogan, open)
values ('fsdb261_test', 'fsdb261', SYSDATE - 1, NULL, NULL, 'O');
insert into membership (nick, club, mentor, type, req_date, inc_date, end_date, req_msg, acc_msg)
values ('fsdb261', 'fsdb261_test', NULL, 'F', '18-JUL-19', '19-JUL-19', NULL, NULL, NULL);
insert into proposals (title, director, club, member, prop_date, slogan, message)
values ('The Rock', 'Michael Bay', 'fsdb261_test', 'fsdb261', '20-JUL-19', NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('fsdb261_test', 'fsdb261', '20-JUL-19', 'The Rock', 'Michael Bay', NULL, NULL, NULL);
set termout on;

select * from openPub where name = 'fsdb261_test';

-- create view Anyone_goes
create view Anyone_goes
as
(
    select club
    from (
        select club from membership where type = 'A' group by club order by count(*) desc
    )
    where rownum <= 5
);

-- Testing Anyone_goes
-- This test works by adding a new club with multiple members accepted and it can be seen
-- on the view after insertion
delete from users where password = 'pass';
delete from clubs where name='fsdbclub';
delete from membership where club = 'fsdbclub';

select * from Anyone_goes;

set termout off;

insert into users VALUES('fsdb259','pass','email',sysdate);
insert into users VALUES('user1','pass','email1',sysdate);
insert into users VALUES('user2','pass','email2',sysdate);
insert into users VALUES('user3','pass','email3',sysdate);
insert into users VALUES('user4','pass','email4',sysdate);
insert into users VALUES('user5','pass','email5',sysdate);
insert into users VALUES('user6','pass','email6',sysdate);

insert into clubs (NAME,FOUNDER, cre_date, slogan,open) VALUES('fsdbclub','fsdb259',sysdate,'hello','O');

insert into membership (nick, club, type, req_date,inc_date,req_msg,acc_msg) VALUES ('user1', 'fsdbclub', 'A', sysdate, sysdate + Interval '50' Second, 'pls', 'thanks');
insert into membership (nick, club, type, req_date,inc_date,req_msg,acc_msg) VALUES ('user2', 'fsdbclub', 'A', sysdate, sysdate + Interval '50' Second, 'pls', 'thanks');
insert into membership (nick, club, type, req_date,inc_date,req_msg,acc_msg) VALUES ('user3', 'fsdbclub', 'A', sysdate, sysdate + Interval '50' Second, 'pls', 'thanks');
insert into membership (nick, club, type, req_date,inc_date,req_msg,acc_msg) VALUES ('user4', 'fsdbclub', 'A', sysdate, sysdate + Interval '50' Second, 'pls', 'thanks');
insert into membership (nick, club, type, req_date,inc_date,req_msg,acc_msg) VALUES ('user5', 'fsdbclub', 'A', sysdate, sysdate + Interval '50' Second, 'pls', 'thanks');
insert into membership (nick, club, type, req_date,inc_date,req_msg,acc_msg) VALUES ('user6', 'fsdbclub', 'A', sysdate, sysdate + Interval '50' Second, 'pls', 'thanks');

set termout on;

select * from Anyone_goes;

-- create view report

create view report
as
(
    select club, type, results, start_date, end_date
    from
    (
    select
    c.nick,
    c.club,
    c.type,
    (
        select null from dual
    ) as start_date,
    (
        select null from dual
    ) as end_date,
    (
        select
        case
            when (select c.rej_date from candidates c where c.nick = sys_context('USERENV', 'CURRENT_USER')) is null
                and sys_context('USERENV', 'CURRENT_USER') not in (select nick from membership where club = c.club) then 'Pending'
            when (select c.rej_date from candidates c where c.nick = sys_context('USERENV', 'CURRENT_USER')) is not null then 'Rejected'
        end
        from candidates ca
        where ca.nick = c.nick and ca.club = c.club
    ) as results
    from
    candidates c
    union
    (
        select
        m.nick,
        m.club,
        m.type,
        m.inc_date as start_date,
        m.end_date as end_date,
        (
            select
            case
                when sys_context('USERENV', 'CURRENT_USER') in (select nick from membership) then 'Accepted'
            end
            from membership me
            where me.nick = m.nick and me.club = me.club
        ) as results
        from
        membership m
    )
    ) u
    where sys_context('USERENV', 'CURRENT_USER') = u.nick
);

-- Testing View report
delete from users where password = 'pass';
delete from clubs where name = 'fsdbclub';
delete from candidates where nick = sys_context('USERENV', 'CURRENT_USER');

select * from report;

insert into users values(sys_context('USERENV', 'CURRENT_USER'),'pass','email',sysdate);
insert into candidates values(sys_context('USERENV', 'CURRENT_USER'), 'Job Club', NULL, 'A', sysdate, 'oi', NULL, NULL);
insert into clubs (name, founder, cre_date, slogan, open) VALUES('fsdbclub', sys_context('USERENV', 'CURRENT_USER'), sysdate,'hello','O');
insert into membership (nick, club, type, req_date,inc_date,req_msg,acc_msg) VALUES (sys_context('USERENV', 'CURRENT_USER'), 'fsdbclub', 'I', sysdate, sysdate + Interval '50' Second, 'pls', 'thanks');

select * from report;
