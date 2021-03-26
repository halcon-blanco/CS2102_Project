/**
* cust_id generated by system. To insert value: (DEFAULT, name, ...)
**/
create table Customers (
    cust_id serial primary key,
    name varchar(100) not null,
    address text,
    phone varchar(100),
    email varchar(100)
);

/**
* from_date means when the customer owns this card -> to get active card, find latest from_date
* For the update_cc function, we just insert a new record into Owns table and CC table respectively.
* Credit_Cards table enforces the key and total participation constraint to Customers.
**/
create table Credit_Cards (
    number varchar(100) primary key,
    CVV varchar(100) not null,
    expiry_date date not null,
    cust_id integer not null, 
    from_date date not null, /** when the cc is owned**/
    foreign key (cust_id) references Customers(cust_id)
);


/**
* Registers table stores the sessions that the customer registered for via CC-payment directly.
**/
create table Registers (
    date date, /** date of registration**/
    number varchar(100), /**CC number used to pay for the session**/
    sid integer,
    launch_date date,
    course_id integer,
    primary key(date, number, sid, launch_date, course_id),
    foreign key (sid, launch_date, course_id) references Sessions(sid, launch_date, course_id),
    foreign key (number) references Credit_Cards(number)
);

/**
* Buys table stores packages bought using the CC. Table is used for get_my_course_package func.
**/
create table Buys (
    date date,
    package_id integer,
    number varchar(100), /**cc used to buy packages**/
    num_remaining_redemptions integer,
    primary key(date, package_id, number),
    foreign key (package_id) references Course_packages(package_id),
    foreign key (number) references Credit_Cards(number)
);

create table Cancels (
    date date,
    refund_amt float,
    package_credit integer,
    cust_id integer,
    sid integer,
    launch_date date,
    course_id integer,
    primary key (date, cust_id, sid, launch_date, course_id),
    foreign key (cust_id) references Customers,
    foreign key(sid, launch_date, course_id) references Sessions(sid, launch_date, course_id)
);
