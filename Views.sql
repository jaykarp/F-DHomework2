drop view Leaders;
drop view Captain_Aragna;

-- Captain_Aragna View
create view Captain_Aragna
as
select m.member, numNotComment / count(*) as percentage from
proposals p
inner join
(select p.member, count(*) as numNotComment
from
proposals p
left outer join
comments c
on p.title = c.title and p.director = c.director and p.member=c.nick
where c.nick is null
group by p.member) m
on p.member = m.member
group by m.member, numNotComment
order by percentage desc;

-- Captain_aragna testing
-- Inserting two users into the same club and then one makes a propsals while the other comments. Because there is only one comment not made by the original user their percentage is 1 and this can be seen in the change between the table.
delete from users where nick = 'fsdb260';
delete from membership where nick = 'fsdb260';
delete from proposals where member = 'fsdb260';
delete from users where nick = 'fsdb259';
delete from membership where nick = 'fsdb259';
delete from comments where nick = 'fsdb259';

select * from Captain_Aragna where percentage = 1;

set termout off;
insert into users (nick, password, email, reg_date) values ('fsdb260', '123456789', 'fsdb260@gmail.com', '3-apr-18');
insert into membership (nick, club, mentor, type, req_date, inc_date, end_date, req_msg, acc_msg)
values ('fsdb260', 'Job Club', NULL, 'F', '18-JUL-19', '19-JUL-19', NULL, NULL, NULL);
insert into proposals (title, director, club, member, prop_date, slogan, message)
values ('The Rock', 'Michael Bay', 'Job Club', 'fsdb260', '20-JUL-19', NULL, NULL);

insert into users (nick, password, email, reg_date) values ('fsdb259', '123456789', 'fsdb1@gmail.com', '3-apr-18');
insert into membership (nick, club, mentor, type, req_date, inc_date, end_date, req_msg, acc_msg)
values ('fsdb259', 'Job Club', NULL, 'F', '18-JUL-19', '19-JUL-19', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb259', '20-JUL-19', 'The Rock', 'Michael Bay', NULL, NULL, NULL);

set termout on;

select * from Captain_Aragna where percentage = 1;


select * from Captain_Aragna;

Leaders View

create view Leaders
as
select * from
(
    select member, club, avg(numcomments) from
    (
        select proposals.member, proposals.title, proposals.club, COUNT(*)
        as
            numComments from
            proposals inner join comments
            on
            proposals.title = comments.title and proposals.director = comments.director and proposals.club = comments.club
            group by (proposals.member, proposals.club, proposals.director, proposals.title)
    )
    group by (member, club)
    order by AVG(numcomments) desc)
    where rownum <= 10;

-- View testing
-- For this test we should see that fsdb260 becomes the most average commented user because they only have one proposal and 30 comments
delete from users where nick = 'fsdb260';
delete from membership where nick = 'fsdb260';
delete from proposals where member = 'fsdb260';
delete from comments where nick = 'fsdb260';

select * from leaders;

set termout off;

insert into users (nick, password, email, reg_date) values ('fsdb260', '123456789', 'fsdb260@gmail.com', '3-apr-18');
insert into membership (nick, club, mentor, type, req_date, inc_date, end_date, req_msg, acc_msg)
values ('fsdb260', 'Job Club', NULL, 'F', '18-JUL-19', '19-JUL-19', NULL, NULL, NULL);
insert into proposals (title, director, club, member, prop_date, slogan, message)
values ('The Rock', 'Michael Bay', 'Job Club', 'fsdb260', '20-JUL-19', NULL, NULL);

insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '20-JUL-19', 'The Rock', 'Michael Bay', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '21-JUL-19', 'The Rock', 'Michael Bay', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '22-JUL-19', 'The Rock', 'Michael Bay', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '23-JUL-19', 'The Rock', 'Michael Bay', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '24-JUL-19', 'The Rock', 'Michael Bay', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '25-JUL-19', 'The Rock', 'Michael Bay', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '26-JUL-19', 'The Rock', 'Michael Bay', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '27-JUL-19', 'The Rock', 'Michael Bay', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '28-JUL-19', 'The Rock', 'Michael Bay', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '29-JUL-19', 'The Rock', 'Michael Bay', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '1-AUG-19', 'The Rock', 'Michael Bay', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '2-AUG-19', 'The Rock', 'Michael Bay', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '3-AUG-19', 'The Rock', 'Michael Bay', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '4-AUG-19', 'The Rock', 'Michael Bay', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '5-AUG-19', 'The Rock', 'Michael Bay', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '6-AUG-19', 'The Rock', 'Michael Bay', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '7-AUG-19', 'The Rock', 'Michael Bay', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '8-AUG-19', 'The Rock', 'Michael Bay', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '9-AUG-19', 'The Rock', 'Michael Bay', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '10-AUG-19', 'The Rock', 'Michael Bay', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '11-AUG-19', 'The Rock', 'Michael Bay', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '12-AUG-19', 'The Rock', 'Michael Bay', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '13-AUG-19', 'The Rock', 'Michael Bay', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '14-AUG-19', 'The Rock', 'Michael Bay', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '15-AUG-19', 'The Rock', 'Michael Bay', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '16-AUG-19', 'The Rock', 'Michael Bay', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '17-AUG-19', 'The Rock', 'Michael Bay', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '18-AUG-19', 'The Rock', 'Michael Bay', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '19-AUG-19', 'The Rock', 'Michael Bay', NULL, NULL, NULL);
insert into comments (club, nick, msg_date, title, director, subject, message, valoration)
values ('Job Club', 'fsdb260', '20-AUG-19', 'The Rock', 'Michael Bay', NULL, NULL, NULL);

set termout on;

select * from leaders;
