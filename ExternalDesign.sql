drop table administer_pub;
drop table favorite_genres;
drop table pending;


-- THESE NEED TO BE VIEWS AND ALSO PRIVILEDGES
create table administer_pub
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
    where founder = 'zavi' -- for testing
    -- where LOWER(founder) = (
        -- select LOWER(sys_context('USERENV', 'CURRENT_USER'))
        -- from dual
    -- )
)
);

create table favorite_genres
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
        where founder = 'zavi' -- for testing
        -- where LOWER(founder) = (
            -- select LOWER(sys_context('USERENV', 'CURRENT_USER'))
            -- from dual
            -- )
    )
    group by g.genre, c.club
)
order by c.club, avg_rating desc;

create table pending
as
(
    select nick, club, member, type, req_date, req_msg
    from candidates
    where rej_date is null and rej_msg is null and
    club in
    (
        select name
        from clubs
        where founder = 'zavi' -- for testing
        -- where LOWER(founder) = (
            -- select LOWER(sys_context('USERENV', 'CURRENT_USER'))
            -- from dual
            -- )
    )
);
