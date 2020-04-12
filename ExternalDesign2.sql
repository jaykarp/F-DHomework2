drop view openPub;
drop view Anyone_goes;
drop view report;


-- create view openPub
-- as
-- (
-- select
-- name,
-- numMembers,
-- MONTHS_BETWEEN((select current_date from dual), cre_date) as activity,
-- totalProposals / MONTHS_BETWEEN((select current_date from dual), cre_date) as propPerMonth,
-- avgComPerProp
-- from clubs c
-- inner join
-- (select
    -- club,
    -- count(*) as numMembers
    -- from membership group by club
-- ) m
-- on m.club = c.name
-- inner join
-- (select
    -- club,
    -- count(*) as totalProposals
    -- from proposals
    -- group by club
-- ) p
-- on p.club = c.name
-- inner join
-- (
-- select avg(comPerProp) as avgComPerProp, club
-- from
-- ( select count(*) as comPerProp, p.club from
-- comments c
-- inner join
-- proposals p
-- on p.title = c.title and p.director = c.director and c.club = p.club
-- group by p.title, p.director, p.club
-- )
-- group by club
-- ) pr
-- on pr.club = c.name
-- );

-- create view Anyone_goes
-- as
-- (
    -- select club
    -- from (
        -- select club from membership where type = 'A' group by club order by count(*) desc
    -- )
    -- where rownum <= 5
-- );

-- create view report
create view report
as
(
select
u.club,
u.type,
(
    select
    case
        when (select c.rej_date from candidates c where c.nick = u.nick) is null
            and u.nick not in (select nick from membership) then 'Pending'
        when u.nick in (select nick from membership) then 'Accepted'
        when (select c.rej_date from candidates c where c.nick = u.nick) is not null then 'Rejected'
    end
    from
    (
    select c.nick, c.club, c.type
    from
    candidates c
    union
    (
        select m.nick, m.club, m.type
        from
        membership m
    )
    ) ub
    where ub.nick = u.nick
) results,
(
    select
    case
        when u.nick in (select m.nick from membership m) then m.inc_date
    else
        null
    end
    from membership m
    where u.nick = m.nick) start_date,
(
    select
    case
        when u.nick in (select m.nick from membership m) then m.end_date
    else
        null
    end
    from membership m
    where u.nick = m.nick) end_date
from
(
    select c.nick, c.club, c.type
    from
    candidates c
    union
    (
        select m.nick, m.club, m.type
        from
        membership m
    )
) u
where (sys_context('USERENV', 'CURRENT_USER')) = u.nick
);

