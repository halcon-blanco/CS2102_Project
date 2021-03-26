/**
* cust_cc_trigger checks on the total participation constraint from Customers to CC.
* Cannot really prevent insertion into Customers w/o CC as deferrable trigger only works with
* after insert. :/ 
**/
create or replace function cust_cc_totalpart() returns trigger as $$
declare 
    cc_exist integer;
begin 
    cc_exist := -1;
    select 1 into cc_exist from Credit_Cards where cust_id = NEW.cust_id;
    if (cc_exist is NULL) then
        raise exception 'The customer % does not have a credit card.', NEW.name;
    end if;
    return null;
end;
$$ language plpgsql;

create constraint trigger cust_cc_trigger after insert or update on customers
deferrable initially deferred for each row execute function cust_cc_totalpart();


/**
* register_trigger checks if the registration is valid (i.e. customer can only register for at most one session from a course
* before its registration deadline AND course offering is available).
* Should this be in the register_session routine instead?
* TODO INCOMPLETE 
**/
create or replace function register_check() returns trigger as $$
declare 
    hasRegisteredSessCourse integer;
    registration_deadline date;
begin
    hasRegisteredSessCourse := -1;
    select 1 into hasRegisteredSessCourse from Registers where (number = NEW.number and course_id = NEW.course_id and launch_date = NEW.launch_date);
    /**To do: which table to get registration deadline from? Sessions or Courses?**/
    select registration_deadline from ______ where (course_id = NEW.course_id and launch_date = NEW.launch_id and sid = NEW.sid);
    /**To do: check if course offering is available -> I'm not sure how sessions/courses tables are implemented for now, once i know i will update here**/
    
    if (hasRegisteredSessCourse is not null or NEW.date > registration_deadline or courseOfferingNotAvailable) then
        return null;
    end if;

    return new; 
end;
$$ language plpgsql;

create trigger register_trigger before insert or update on Registers
for each row execute function register_check();

