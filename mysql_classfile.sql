select * from classicmodels.products;
-- 1
select city 
		from classicmodels.offices 
order by city; 

-- 2 
select employeenumber, lastname, firstname, extension  
		from classicmodels.employees 
		where officecode = 4;
        
-- 3 
select ProductCode, ProductName, ProductVendor, quantityinstock, productline 
		from classicmodels.products  
		where quantityinstock between 200 and 1200; 
        
-- 4
select Productcode, ProductName,  productvendor, 
			buyprice, MSRP   
		from classicmodels.products  
		where MSRP = ( 
 		select min(msrp) from classicmodels.products);
        
-- 5
select ProductName, (MSRP-  BuyPrice) as PROFIT   
		from classicmodels.products  
	order by profit desc limit 1;
    
-- 6
Select distinct country, count(*) as customers
		from classicmodels.customers
		group by country
			having count(*) = 2 
order by 1 asc; 

-- 7
Select p.productcode, productname, 
			count(ordernumber) as OrderCount  	
		from classicmodels.products p join classicmodels.orderdetails o on p.productcode = o.productcode     
group by productcode, productname 
having OrderCount = 25;

-- 8 
Select employeenumber, 
			concat(firstname," ",lastname) as name 
 	from classicmodels.employees 
    where reportsto in ('1002', '1102');
    
-- 9
Select employeenumber, lastname, firstname 
		from classicmodels.employees 
		where reportsto is null; 
        
-- 10
Select productname, productline  
	      from classicmodels.products 
	      where productline = "Classic Cars"  
	         and productname like "195%" 
order by productname;

-- 11
select count(ordernumber),  
			monthname(orderdate) as ordermonth  
		from  classicmodels.orders  
		where extract(year from orderdate) = '2004' group by ordermonth 
order by 1 desc limit 1;

-- 12
select lastname, firstname 
		from classicmodels.employees e left outer join classicmodels.customers c on e.employeenumber = c.salesrepemployeenumber 
where customername is null  
		and jobtitle = "Sales Rep";

-- 13
select customername , country 
		from classicmodels.customers c left outer join classicmodels.orders o on c.customernumber = o.customernumber 
where o.customernumber is null    
	  and country = 'Switzerland';
      
-- 14
select customername, sum(quantityordered) as totalq 
		from classicmodels.customers c  
			join classicmodels.orders o on c.customernumber = o.customernumber 
          join classicmodels.orderdetails d on o.ordernumber = d.ordernumber 
group by customername  
having totalq > 1650;

-- DDL/DML
-- 1
create table if not exists classicmodels.TopCustomers( 
 	Customernumber int not null,  
	ContactDate    DATE not null, 
	OrderTotal 	decimal(9,2) not null default 0, 
     constraint PKTopCustomers primary key(CustomerNumber) 
 );
 
 -- 2
 insert into classicmodels.TopCustomers 
	select c.customernumber, CURRENT_date, 
			  SUM(priceEach * Quantityordered) 
 	   	from classicmodels.Customers c, classicmodels.Orders o, classicmodels.OrderDetails d  	 	
			where c.Customernumber = o.Customernumber  
      	  and o.Ordernumber = d.Ordernumber 
 	group by c.Customernumber 
 	having SUM(priceEach * Quantityordered) > 140000;
    
-- 3
select * from classicmodels.topcustomers order by 3 desc; 

-- 4
alter table classicmodels.topcustomers 
		add column OrderCount integer ; 
        
-- 5
update classicmodels.topcustomers 
		set ordercount = rand()*10;
        
-- 6
select * 
		from classicmodels.topcustomers 
		order by 4 desc;
        
-- Final Project
-- Q1
select country, sum(quantityordered*priceeach) as "Total Price"
from classicmodels.customers C join classicmodels.orders O
on C.customernumber = O.customerNumber join classicmodels.orderdetails D
on O.ordernumber = D.ordernumber
group by country
order by sum(quantityordered*priceeach) desc limit 5;

-- Q2
select O.city, count(customernumber) as "Total Customers"
from classicmodels.offices O join classicmodels.employees E
on O.officecode = E.officecode join classicmodels.customers C
on E.employeeNumber = C.salesrepemployeenumber
group by O.city
order by count(customernumber) desc;

-- Q3
select P.productname, count(O.ordernumber)
from classicmodels.products P join classicmodels.orderdetails D on
P.productcode = D.productcode join classicmodels.orders O
on D.ordernumber = O.ordernumber
where productline = 'Motorcycles' and orderdate
between '2003/12/21' and '2004/03/21'
group by P.productname;

