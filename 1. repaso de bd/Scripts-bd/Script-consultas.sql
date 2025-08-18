-- primera consulta
select * from product where category_id in (1, 5) and unit_price > 3.5;

-- segunda consulta
select p.product_name from product p where p.unit_price >= 3.5;

-- tercera consulta
select p.product_name, c.name as category_name from product p join category c on p.category_id = c.category_id;

-- cuarta consulta
select pi.purchase_id, p.product_name, pi.unit_price, pi.quantity from purchase_item pi 
join product p on p.product_id = pi.product_id order by pi.purchase_id asc;

-- quinta consulta
select pi.purchase_id, c.name as category_name from purchase_item pi 
join product p on pi.product_id = p.product_id 
join category c on p.category_id = c.category_id group by category_name, pi.purchase_id order by pi.purchase_id;

-- sexta consulta
select e.last_name, e.first_name, e.birth_date from employee e order by e.birth_date asc;

-- septima consulta
select c.city, count(c.city) as customers_quantity from customer c 
where c.city not in ('Knoxville', 'Stockton') group by c.city order by c.city asc


-- octava consulta
select c.name  as category_name, count(p.discontinued) as discontinued_products_number from product p 
join category c on p.category_id = c.category_id where p.discontinued = true group by c.name
having count(p.discontinued) >= 3 order by discontinued_products_number desc

