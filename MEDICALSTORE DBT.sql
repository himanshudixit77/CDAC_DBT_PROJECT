Create table MedicineType
(
med_type_no int PRIMARY KEY,
med_type varchar(20),
campartment varchar(10)
);
insert into MedicineType values
(1,'FEVER', 'RACK A'),
(2,'DIABATIES', 'RACK B'),
(3,'HEART', 'RACK C'); 

CREATE TABLE Medicine
(
medicine_id int ,
med_name varchar(20) PRIMARY KEY ,
medi_price float,
mfg_date date,
med_type_no  int,
INITIALSTOCK int ,
STOCK_REMAIN int check(STOCK_REMAIN >0),
CONSTRAINT FK_MEDICINE FOREIGN KEY(med_type_no) references MedicineType(med_type_no) ON DELETE CASCADE ON UPDATE CASCADE
);
insert into Medicine values
(1000, 		'PARACETAMOL',100,	'2022-04-12'	,1,	 100,100),
(2000,   'CARVEDILOL'	,200,	'2022-04-15'	,2,	200,200	),
(3000,	   'COMBIFLAME',200,	'2022-04-15'	,1,	100,100),
(4000,		'DOLO 650'  	,100,	'2022-04-16',    1,	100,100),
(5000,	'PACEMAKER'	  ,200,		'2022-04-18'	,2,	200,200),
(6000,	'GLYCOGEN'	  ,300,		'2022-04-19'	,2,	300,300),
(7000,	'THYROXIN'	  ,500,		'2022-04-07'	,3,	200,200),
(8000,	'METROPOLOL'  	,650,	'2022-04-08'	,3,	200,200),
(9000,	'ATENOLOL'	  ,500,		'2022-04-25'	,3,	200,200),
(9500,	'ASPIRIN' , 500,		'2022-04-07'	,1,	200,200);

SELECT med_name,med_type from medicine,medicinetype;
delete from medicine where medicine_id=1000;

select * from medicine;
select * from medicinetype;

delete from medicinetype where  med_type_no=1;

create table CUSTOMER
(
billno int   primary key AUTO_INCREMENT,
customername varchar(20),
med_name varchar(20),
quantity int ,
bilingdate date,
billtime  time
);
insert into customer  (billno,customername,med_name,quantity,bilingdate,billtime) values
(1250,'GOPAL RAHNE','PARACETAMOL',20,current_date(), curtime());

insert into customer  (customername,med_name,quantity,bilingdate,billtime) values
('snehal','PARACETAMOL',50,current_date(), curtime()); 
insert into customer (customername,med_name,quantity,bilingdate,billtime) values
('ESHAN NIAGM','thyroxin',30,current_date(), curtime()),
('SNEHAL ','ASPIRIN',30,current_date(), curtime()),
('JAY BEDISKAR','thyroxin',50,current_date(), curtime()),
('SAMARTHYA MISHRA','GLYCOGEN',60,current_date(), curtime()),
('AKHIL DUBEY','PACEMAKER',21,current_date(), curtime());
select * from MEDICINE;

-- ========================================TRIGGERS=============================================
delimiter //
create trigger cust
 after insert on CUSTOMER  for each row
begin
update Medicine
set  STOCK_REMAIN=STOCK_REMAIN- new.quantity 
where Medicine.med_name=new.med_name;
CALL STOCKREFILL();    /*AUTOMATICALLY UPDATE THE  MEDICINE STOCK  IF STOCK OF MEDICINE IS LESS THAN 10 */
end ; //
delimiter ;
 DROP TRIGGER cust;
select * from medicine;
select * from customer;
select medicine.stock, customer.med_name,customer.quantity  from medicine, customer
where medicine.med_name=customer.med_name;

/*===================================================================UPDATETHE STOCK===============================================*/
delimiter //
create procedure STOCKREFILL()
BEGIN
declare finished int default 0;
declare s int ;
declare m varchar(20);
declare c1 cursor for select med_name, STOCK_REMAIN from medicine;
declare continue handler for not found set finished=1;
open c1;
c1_loop:loop
fetch c1 into m,s ;
if  finished=1 then
leave c1_loop;
end if ;
if s < 10  then
update medicine set STOCK_REMAIN=STOCK_REMAIN + 100 where med_name=m;
end if ;
end loop c1_loop;
close c1;
end ; //
delimiter ;

call STOCKREFILL();

SELECT * FROM MEDICINE;

insert into customer  (billno,customername,med_name,quantity,bilingdate,billtime) values
(1252,'GOPA','DOLO 650',95,current_date(), curtime());

SELECT * FROM CUSTOMER;

SELECT * FROM CUSTOMER WHERE BILLNO=1260;