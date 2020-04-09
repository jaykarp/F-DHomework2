Drop view CurrentClubs;
Drop view NonCurrentClubs;
Drop view CurrentMembership;
Drop view NonCurrentMembership;
Drop trigger NCC_insert_trigger;
Drop trigger NCM_insert_trigger;
Drop trigger CC_update_trigger;
Drop trigger CM_update_trigger;
Drop trigger NCC_update_trigger;
Drop trigger NCM_update_trigger;
Drop trigger NCM_delete_trigger;

-- Current Clubs
    Create view CurrentClubs As
    Select * from clubs where END_DATE IS NULL;

-- Non-Current Clubs
    Create view NonCurrentClubs As
    select * from clubs where END_DATE IS NOT NULL;


-- Current Membership
    Create view CurrentMembership As
    Select membership.*
    from (membership
    inner join currentclubs
    on membership.club  = currentclubs.name)
	Where membership.END_DATE is NULL;

-- Non-Current Membership
    Create view NonCurrentMembership As
    Select membership.*
    from (membership
    inner join NonCurrentclubs
    on membership.club  = NonCurrentClubs.name)
	UNION ALL
	(select membership.* from membership where END_DATE is not null);

-- Current Clubs delete trigger
 CREATE TRIGGER CC_delete_trigger
	INSTEAD OF DELETE ON CurrentClubs
	FOR EACH ROW
	BEGIN
		update Clubs set end_date = sysdate where name= :old.name;
 	END;
/

-- Current Membership delete trigger
 CREATE TRIGGER CM_delete_trigger
	INSTEAD OF DELETE ON CurrentMembership
	FOR EACH ROW
	BEGIN
		update membership set end_date = sysdate where club= :old.club and nick = :old.nick;
 	END;
/

-- Non Current Clubs delete trigger

 CREATE TRIGGER NCC_delete_trigger
	INSTEAD OF DELETE ON NonCurrentClubs
	FOR EACH ROW
	BEGIN
		delete from candidates where club = :old.name;
		delete from proposals where club = :old.name;
		delete from comments where club = :old.name;
		update membership set club = null where mentor = :old.name;
		delete from Membership where club = :OLD.name;
		delete from clubs where name = :OLD.name;
 	END;
/


-- Non Current Membership delete trigger
 CREATE TRIGGER NCM_delete_trigger
	INSTEAD OF DELETE ON NonCurrentMembership
	FOR EACH ROW
	BEGIN
		delete from candidates where member = :old.nick;
		delete from proposals where member = :old.nick;
		delete from comments where nick = :old.nick;
		update membership set mentor = null where mentor = :old.nick;
		delete from Membership where nick = :OLD.nick and club = :OLD.club;

 	END;
/

-- Non Current Clubs insert trigger
 CREATE TRIGGER NCC_insert_trigger
	INSTEAD OF INSERT ON NonCurrentClubs
	FOR EACH ROW
	DECLARE insert_error EXCEPTION;
	BEGIN
		RAISE insert_error;
 	END;
/

-- Non Current Membership insert trigger
 CREATE TRIGGER NCM_insert_trigger
	INSTEAD OF INSERT ON NonCurrentMembership
	FOR EACH ROW
	DECLARE insert_error EXCEPTION;
	BEGIN
		RAISE insert_error;
 	END;
/

-- Non Current Membership update trigger
 CREATE TRIGGER NCM_update_trigger
	INSTEAD OF UPDATE ON NonCurrentMembership
	FOR EACH ROW
	DECLARE update_error EXCEPTION;
	BEGIN
		RAISE update_error;
 	END;
/

-- Non Current Clubs update trigger
 CREATE TRIGGER NCC_update_trigger
	INSTEAD OF UPDATE ON NonCurrentClubs
	FOR EACH ROW
	DECLARE update_error EXCEPTION;
	BEGIN
		RAISE update_error;
 	END;
/

-- Current Membership update trigger
 CREATE TRIGGER CM_update_trigger
	INSTEAD OF UPDATE ON CurrentMembership
	FOR EACH ROW
	DECLARE update_error EXCEPTION;
	BEGIN
		RAISE update_error;
 	END;
/

-- Current Clubs update trigger
 CREATE TRIGGER CC_update_trigger
	INSTEAD OF UPDATE ON CurrentClubs
	FOR EACH ROW
	DECLARE update_error EXCEPTION;
	BEGIN
		RAISE update_error;
 	END;
/


-- Testing
set termout off;
delete from users where nick = 'fsdb260';
delete from membership where nick = 'fsdb260';
delete from clubs where name like '%fsdb260%';

insert into users (nick, password, email, reg_date) values ('fsdb260', '123456789', 'fsdb260@gmail.com', '3-apr-18');
set termout on;

-- INSERTING
-- All inserts on current tables should be allowed, inserts on history tables should be blocked by triggers
insert into currentClubs (Name, Founder, cre_date, end_date, slogan, open)
values ('fsdb260_club', 'fsdb260', '19-JUL-19', NULL, NULL, 'O');
insert into nonCurrentClubs (Name, Founder, cre_date, end_date, slogan, open)
values ('Job Club', 'fsdb260', '19-JUL-19', NULL, NULL, 'O');

insert into currentMembership (Nick, club, mentor, type, req_date, inc_date, end_date, req_msg, acc_msg)
values ('fsdb260', 'Job Club', NULL, 'F', '19-JUL-19', '20-JUL-19', NULL, NULL, NULL);
insert into nonCurrentMembership
values ('fsdb260', 'Job Club', NULL, 'F', '19-JUL-19', '20-JUL-19', NULL, NULL, NULL);

-- DELETING
-- Each of these should show an entry in the first select statement and then no entry in the second
-- it can also be seen from these select queries that the clubs and memberships deleted from the 
-- current tables move into the history tables in the next select query. 
select * from currentClubs where name = 'fsdb260_club';
delete from currentClubs where name = 'fsdb260_club';
select * from currentClubs where name = 'fsdb260_club';

select * from nonCurrentClubs where name = 'fsdb260_club';
delete from nonCurrentClubs where name = 'fsdb260_club';
select * from nonCurrentClubs where name = 'fsdb260_club';

select * from currentMembership where nick = 'fsdb260';
delete from currentMembership where nick = 'fsdb260';
select * from currentMembership where nick = 'fsdb260';

select * from nonCurrentMembership where nick = 'fsdb260';
delete from nonCurrentMembership where nick = 'fsdb260';
select * from nonCurrentMembership where nick = 'fsdb260';

-- UPDATING
-- These should all immediately fail as no updates are allowed on these tables
update currentClubs set founder = 'fsdb260' where founder = 'ca';
update nonCurrentClubs set founder = 'fsdb260' where founder = 'eva6';

update currentMembership set nick = 'fsdb260' where nick = 'juan1';
update NonCurrentMembership set nic = 'fsdb260' where nick = 'betty';




