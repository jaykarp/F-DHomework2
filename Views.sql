drop view Leaders;

-- Leaders View

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
