-- Question Set 1 
-- Q1: Who is the senior most employee based
-- on job title?


-- select title , last_name , first_name 
-- from employee
-- order by levels desc
-- limit 1;



-- Q2: Which countries have the most invoices?


-- select billing_country , count(*) as most_invoices from invoice
-- group by billing_country
-- order by most_invoices desc 
-- limit 5;



-- Q3: What are top 3 values of total invoice?



-- select total from invoice
-- order by total desc
-- limit 3;



/* Q4: Which city has the best customers? 
We would like to throw a promotional Music 
Festival int he city we made the most money. 
Write a query that returns one city that has 
the highest sum of invoce totals. Return both 
the city name & sum of all invoice total. */

-- select sum(total) as total_invoice , billing_city from invoice
-- group by billing_city
-- order by total_invoice
-- limit 1;


-- Q5: Who is the best customer? 
-- The customer who has spent the most 
-- money will be declared the best customer. 
-- Write a query that returns the person who 
-- has spent the most money?

-- select cust.customer_id, cust.first_name , 
-- cust.last_name , sum(inv.total) as total
-- from customer cust
-- join invoice inv
-- on cust.customer_id = inv.customer_id
-- group by cust.customer_id
-- order by total desc
-- limit 1;




-- Question Set 2 -----------------------------------------------------------------------------------------------------------------------------------------------------------

--Qno1:Write query to return the email , first_name ,
-- last_name & genre of all rock music listners.
--return  your list order, alphabetically by 
-- email starting with A.
	

-- select distinct ca.first_name , ca.last_name , 
-- ca.email from customer ca
-- join invoice inv on ca.customer_id = inv.customer_id
-- join invoice_line invl on inv.invoice_id = invl.invoice_id
-- where track_id in (
-- 	select track_id from track
-- 	join genre on genre.genre_id = track.genre_id
-- 	where genre.name like 'Rock'
-- )
-- order by email;

-- Qno2:let's invite 
-- the artist who have written the most rock 
-- music in our dataset. write a query that returns
-- the artist name and total track count of the
-- top 10 rock bands.



-- select artist.artist_id, artist.name, count(artist.artist_id) as number_of_songs
-- from track
	
-- join Album on album.album_id = track.album_id
-- join artist on artist.artist_id = album.artist_id
-- join genre on genre.genre_id = track.genre_id
	
-- where genre.name like 'Rock'
-- group by artist.artist_id
-- order by number_of_songs Desc 
-- limit 10;



/*--Qno3 Return all the track names that have a song length longer that 
the average song lenght. Return the Name and 
Milliseconds for each track. Order by the 
song lenght with the longest song listen first.*/

-- select name, milliseconds
-- from track
-- where milliseconds > ( select avg(milliseconds) from track
-- )
-- order by milliseconds desc



-- Question Set 3-------------------------------------

-- Qno1: Find how much amount 
-- spent by each customer on artists?
-- Write a query to return customer name , 
-- artist name and total spent.
/*

-- artist , customer , invoice

with best_selling_artist as (
    select 
	ar.artist_id as artist_id, 
	ar.name as artist_name, 
    sum(invl.unit_price * invl.quantity) as total_sales
    from invoice_line invl
    join 
        track tr on tr.track_id = invl.track_id
    join
        album al on al.album_id = tr.album_id
    join 
        artist ar on ar.artist_id = al.artist_id
    group by ar.artist_id, ar.name
    order by total_sales desc
    limit 1
)

select cus.customer_id,
    cus.first_name ||' '|| cus.last_name as customer_name,
    bsa.artist_name,
    sum(invl.unit_price * invl.quantity) as amount_spent
from 
    invoice inv 
join
    customer cus on inv.customer_id = cus.customer_id    
join
    invoice_line invl on inv.invoice_id = invl.invoice_id
join 
    track tr on invl.track_id = tr.track_id
join
    album al on tr.album_id = al.album_id
join
    best_selling_artist bsa on bsa.artist_id = al.artist_id
group by 
    cus.customer_id, cus.first_name, cus.last_name, bsa.artist_name
order by 
    amount_spent desc;*/


-- resolving
-- Qno1: Find how much amount 
-- spent by each customer on artists?
-- Write a query to return customer name , 
-- artist name and total spent.

-- select 
	-- first_name ||' '|| last_name as Customername,
	-- ar.name as artistname,
	-- sum(invl.unit_price * invl.quantity) as total_spent
-- from 
	-- customer cus
-- join
	-- invoice inv on cus.customer_id = inv.customer_id
-- join
	-- invoice_line invl on inv.invoice_id = invl.invoice_id
-- join 
	-- track tr on invl.track_id = tr.track_id
-- join
	-- album al on tr.album_id = al.album_id
-- join
	-- artist ar on al.artist_id = ar.artist_id
-- group by 
	-- customername,
	-- artistname
	-- 
-- order by total_spent desc
-- limit 1;







/*Qno2: We want to find out the most 
poular music Genre for each country.
We determine the most popular genre as the 
genre with the higest amount of purchases. 
Write a query that returns each country
along with the top Genre For countries where 
the maximum number of purchases 
is shared return all Genres.
*/

-- select  count(invl.quantity) as purchases , cu.country as country ,
-- genre.name as GenreName , genre.genre_id,
-- row_number() over(partition by cu.country  order by count(invl.quantity) desc) as RownO
-- from invoice_line invl
-- join invoice inv on invl.invoice_id = inv.invoice_id
-- join customer cu on inv.customer_id = cu.customer_id
-- join track tr on invl.track_id = tr.track_id 
-- join genre on tr.genre_id = genre.genre_id
-- group by 2,3,4
-- order by 2 asc, 1 desc


/* Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

select customer.customer_id,first_name || ' ' || last_name as CustomerName ,
billing_country,sum(total) as total_spending,
row_number() over(partition by billing_country order by sum(total) desc) as RowNo 
from invoice
join customer on customer.customer_id = invoice.customer_id
group by 1,2,3
order by 3 asc,4 desc


		
