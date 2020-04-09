Drop trigger NO_COMMENT_PROPOSALS;
Drop trigger NO_COMMENT_COMMENTS;
Drop trigger REJECT_ON_CLOSURE;
Drop trigger ACCESSIBLE_CLIENTS;

---alter session set nls_date_format='DD-MON-RR HH24.MI.SS';

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
    		if username != LOWER(:new.founder)
    		Then
    			raise user_error;
    		end if;
			update candidates set rej_date = sysdate where (club = :new.name and rej_date is NULL);
		end if;
	END;
/

CREATE OR REPLACE TRIGGER ACCESSIBLE_CLIENTS
	BEFORE INSERT ON Contracts
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

-- insert into contracts (idcontract, citizenid, contract_type, startdate, enddate, address, town, zipcode, country) select '45/48498020/122T', '65303675M', contract_type, startdate, enddate, address, town, zipcode, country from contracts where rownum <=1;
-- insert into contracts (idcontract, citizenid, contract_type, startdate, enddate, address, town, zipcode, country) select '45/48498020/122T', '21864549J', contract_type, startdate, enddate, address, town, zipcode, country from contracts where rownum <=1;
