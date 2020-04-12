Drop trigger NO_COMMENT_PROPOSALS;
Drop trigger NO_COMMENT_COMMENTS;
Drop trigger REJECT_ON_CLOSURE;
Drop TRIGGER ACCESSIBLE_CLIENTS_PROFILES;
Drop trigger ACCESSIBLE_CLIENTS_CONTRACTS;

---alter session set nls_date_format='DD-MON-RR HH24.MI.SS';

CREATE OR REPLACE TRIGGER APPLICATION
	BEFORE INSERT ON CANDIDATES
	FOR EACH ROW
	DECLARE
	state CHAR(1);
	BEGIN
	select open into state from (select open from clubs where name = :new.club) where rownum < 2;
	IF state = 'C'
		THEN
			:new.rej_date := sysdate + interval '1' second;
		END IF;
	END;
/

CREATE OR REPLACE TRIGGER OVERWRITE
	BEFORE INSERT ON COMMENTS
	FOR EACH ROW
	BEGIN
	delete from COMMENTS where nick=:new.nick and club=:new.club and director =:new.director and title=:new.title;
	END;
/


 CREATE OR REPLACE TRIGGER NO_COMMENT_PROPOSALS
	BEFORE INSERT ON Proposals
	FOR EACH ROW
	DECLARE 
	num number;
	BEGIN
	select count(*) into num from proposals where (PROP_DATE = :new.prop_Date);
	WHILE NUM > 0
	LOOP
		:new.prop_Date := :new.prop_date + interval '1' second;
		select count(*) into num from proposals where (PROP_DATE = :new.prop_Date);
	END LOOP;
	END;

/



 CREATE OR REPLACE TRIGGER NO_COMMENT_COMMENTS
	BEFORE INSERT ON Comments
	FOR EACH ROW
	DECLARE 
	num number;
	BEGIN
	select count(*) into num from comments where (msg_DATE = :new.msg_Date);
	WHILE NUM > 0
	LOOP
		:new.msg_Date := :new.msg_date + interval '1' second;
		select count(*) into num from comments where (msg_DATE = :new.msg_Date);
	END LOOP;
	END;

/


CREATE OR REPLACE TRIGGER THE_KING_IS_DEAD
	BEFORE UPDATE ON CLUBS
	FOR EACH ROW
	DECLARE
	oldest VARCHAR(35);
	BEGIN
		if :new.founder is null
		then
			select nick into oldest from (select * from membership where club = :new.name order by inc_date) where rownum <2;
			if oldest is null
			then
				:new.end_date := sysdate;
			end if;
			:new.founder := oldest;
		end if;
	END;
/


CREATE OR REPLACE TRIGGER REJECT_ON_CLOSURE
	BEFORE UPDATE ON CLUBS
	FOR EACH ROW
	DECLARE
	username varchar2(50);
	user_error EXCEPTION;
	BEGIN
		DBMS_output.put_line(username);
		SELECT LOWER(sys_context('USERENV','CURRENT_USER')) into username from dual;
		if :new.open = 'C' and :old.open = 'O'
		Then
    		if username != LOWER(:old.founder)
    		Then
    			raise user_error;
    		end if;
			update candidates set rej_date = sysdate where (club = :new.name and rej_date is NULL);
		end if;
	END;
/

CREATE OR REPLACE TRIGGER ACCESSIBLE_CLIENTS_CONTRACTS
	BEFORE INSERT OR UPDATE ON Contracts
	FOR EACH ROW
	DECLARE
	mobile_num number(12);
	user_error EXCEPTION;
	BEGIN
		SELECT mobile into mobile_num from profiles where (citizenID = :new.citizenID);
		if mobile_num is null
		Then
			raise user_error;
		end if;
	END;
/

CREATE TRIGGER ACCESSIBLE_CLIENTS_PROFILES
	BEFORE UPDATE ON profiles
	FOR EACH ROW
	DECLARE
	num number;
	phone_error EXCEPTION;
	BEGIN
		select count(*) into num from Contracts where (citizenID = :new.citizenID);
		if num > 0
		Then
			if :new.mobile is null
			Then
				raise phone_error;
			end if;
		end if;
	END;
/


-- insert into contracts (idcontract, citizenid, contract_type, startdate, enddate, address, town, zipcode, country) select '45/48498020/122T', '65303675M', contract_type, startdate, enddate, address, town, zipcode, country from contracts where rownum <=1;
-- insert into contracts (idcontract, citizenid, contract_type, startdate, enddate, address, town, zipcode, country) select '45/48498020/122T', '21864549J', contract_type, startdate, enddate, address, town, zipcode, country from contracts where rownum <=1;

--TESTS FOR APPLCIATION
select * from clubs where name ='Club of Melody';
insert into candidates (Nick, club, type,req_date,req_msg) VALUES ('fsdb259','Club of Melody','I',sysdate,'hello');
select rej_date,nick from candidates where nick = 'fsdb259';
select * from clubs where name ='The Club of Latin';
insert into candidates (Nick, club, type,req_date,req_msg) VALUES ('fsdb259','The Club of Latin','I',sysdate,'hello');
select rej_date,nick from candidates where nick = 'fsdb259' and club = 'The Club of Latin';


--TESTS FOR OVERWRITE
select title,director,nick,message from comments where title = 'Circle' and nick = 'alvarez2';
insert into comments (nick, club, director, title,msg_date,message) VALUES ('alvarez2', 'Collective of Essential', 'Aaron Hann','Circle',sysdate,'new message');
select title,director,nick,message from comments where title = 'Circle' and nick = 'alvarez2';


--TESTS FOR THE KING IS DEAD
select founder, name from clubs where name ='Group of Coyote';
select nick from membership where club = 'Group of Coyote' order by inc_date;
update clubs set founder = null where name = 'Group of Coyote';
select name,founder from clubs where name = 'Group of Coyote';
delete from proposals where member='alvarez';
delete from comments where nick='alvarez';
update membership set mentor = null where mentor = 'alvarez';
delete from candidates where member = 'alvarez';
delete from membership where nick = 'alvarez';
select name,founder from clubs where name = 'Group of Coyote';
update clubs set founder = null where name = 'Group of Coyote';
select name,founder from clubs where name = 'Group of Coyote';

--TEST FOR REJECT ON CLOSURE
select * from clubs where name='fsdbclub';
select nick,rej_date from candidates where club = 'fsdbclub';
update clubs set open='C' where name='fsdbclub';
select * from clubs where name='fsdbclub';
select nick,rej_date from candidates where club = 'fsdbclub';

--TEST FOR NO COMMENT
alter session set nls_date_format = 'yyyy/mm/dd hh24:mi:ss';
insert into comments (club,nick,title,director,msg_date,message) Values ('fsdbclub','fsdb259','#Horror','Tara Subkoff',to_date('2003/04/04 12:12:12', 'yyyy/mm/dd hh24:mi:ss'),'hello');
insert into comments (club,nick,title,director,msg_date,message) Values ('fsdbclub','user1','#Horror','Tara Subkoff',to_date('2003/04/04 12:12:12', 'yyyy/mm/dd hh24:mi:ss'),'hello');
insert into comments (club,nick,title,director,msg_date,message) Values ('fsdbclub','user2','#Horror','Tara Subkoff',to_date('2003/04/04 12:12:12', 'yyyy/mm/dd hh24:mi:ss'),'hello');
select nick,msg_date from comments where club = 'fsdbclub' and title = '#Horror';


--TESTS FOR ACCESSIBLE CLIENTS
select * from profiles where nick = 'robert1';
insert into contracts (idcontract,citizenID,contract_type,startdate,address,town,ZIPcode,country) VALUES ('12jdsf', '79944591H', 'Low Cost Rate', sysdate, '1234','134','1234','1324');
select * from profiles where nick = 'zenobia';
delete from contracts where citizenID = '49072245C';
insert into contracts (idcontract,citizenID,contract_type,startdate,address,town,ZIPcode,country) VALUES ('12jdsf', '49072245C', 'Low Cost Rate', sysdate, '1234','134','1234','1324');
select zipcode,startdate from contracts where citizenID = '49072245C';
update profiles set mobile= null where nick = 'zenobia';
delete from contracts  where citizenID = '49072245C';
update profiles set mobile= null where nick = 'zenobia';
select * from profiles where nick = 'zenobia';
update profiles set mobile= '10232' where nick = 'zenobia';