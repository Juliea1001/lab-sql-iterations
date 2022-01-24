# Lab | SQL Iterations

#In this lab, we will continue working on the [Sakila](https://dev.mysql.com/doc/sakila/en/) database of movie
# rentals. 

### Instructions

#Write queries to answer the following questions:

#- Write a query to find what is the total business done by each store.
#- Convert the previous query into a stored procedure.
#- Convert the previous query into a stored procedure that takes the input for `store_id` and displays the 
#*total sales for that store*.


select * from sakila.payment;
select * from sakila.store;
select * from sakila.staff;

select sum(amount) as total_business, store_id from sakila.payment
join sakila.staff using(staff_id)
group by store_id;

DELIMITER //
create procedure Total_Business()
begin
		select sum(amount) as total_business, store_id from sakila.payment
		join sakila.staff using(staff_id)
		group by store_id;
	
end //
DELIMITER ;
call Total_Business();



DELIMITER //
create procedure Total_Sales_by_Store(in param1 int)
begin
		select sum(amount) as total_sales, store_id from sakila.payment
		join sakila.staff using(staff_id)
		group by store_id
        having store_id = param1;
	
end //
DELIMITER ;
call Total_Sales_by_Store(2);

#- Update the previous query. Declare a variable `total_sales_value` of float type, that will store the 
#returned result (of the total sales amount for the store). Call the stored procedure and print the results.


DELIMITER //
create procedure Total_Sales_by_Store_(in param2 int, out param3 float)
begin
declare total_sale_value float default 0.00; #default 0.0;
		select sum(amount) into total_sale_value from sakila.payment
		join sakila.staff using(staff_id)
		group by store_id
        having store_id = param2;
        
        select total_sale_value into param3;
	
end //
DELIMITER ;
call Total_Sales_by_Store_(1, @total_sale_value_1);
select @total_sale_value_1;
call Total_Sales_by_Store_(2, @total_sale_value_2);
select @total_sale_value_2;


#- In the previous query, add another variable `flag`. If the total sales value for the store is over 30.000, 
#then label it as `green_flag`, otherwise label is as `red_flag`. Update the stored procedure that takes an 
#input as the `store_id` and returns total sales value for that store and flag value.
DELIMITER //
create procedure Total_Sales_Flagged(in param2 int)#, out param3 float)
begin
declare total_sale_value float default 0.00; 
declare flag varchar(20) default "";
		select sum(amount) into total_sale_value from sakila.payment
		join sakila.staff using(staff_id)
		group by store_id
        having store_id = param2;
        
        select total_sale_value;
        case
    when total_sale_value > 30000 then
      set flag = 'green_flag';
	else 
      set flag = 'red_flag';
  
  end case;

  select total_sale_value, flag;
	
end //
DELIMITER ;

call Total_Sales_Flagged(1);
