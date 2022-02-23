-- Visualizzare nome e cognome di tutti gli attori

select 
  first_name, 
  last_name
from actor;

-- Visualizzare nome e cognome in un'unica colonna in UPPER CASE

select 
  upper(concat(first_name,' ',last_name)) as 'Actor Name' 
from actor;

-- Cercare tutti gli attori che si chiamano Joe

select 
  *
from actor
where first_name = "Joe";

-- Cercare tutti i congnomi che contengono le lettere Gen

select 
  *
from 
  actor
where 
  last_name like '%Gen%';

-- Cercare i country "Afghanistan, Bangladesh, China" con un'unica query

select 
  * 
from 
  country 
where 
  country in ('Afghanistan', 'Bangladesh','China');

-- Elenca i cognomi degli attori e quanti attori hanno quel cognome

select 
  last_name, 
  count(last_name) 
from 
  actor 
group by last_name;

-- Elenca i cognomi degli attori e quanti attori hanno quel cognome, ma solo quelli condivisi da più di 2 attori

select 
  last_name, 
  count(last_name) as 'Count of Last Name' 
from 
  actor  
group by last_name 
having count(last_name) > 2;

-- Elenca il totale pagato da ogni cliente

select 
  c.first_name, 
  c.last_name, 
  sum(coalesce(p.amount, 0))
from 
  customer as c
  join payment as p
    on c.customer_id = p.customer_id
group by c.first_name, c.last_name;

-- Elenca la durata media dei film per categoria
select 
  category.name, 
  avg(length)
from 
  film 
  join film_category using (film_id) 
  join category using (category_id)
group by category.name
order by avg(length) desc;

-- Elenca le copie disponibili del film 'Academy Dinosaur' nello Store 1?
select 
  inventory.inventory_id
from 
  inventory 
  join store using (store_id)
  join film using (film_id)
  join rental using (inventory_id)
where 
  film.title = 'Academy Dinosaur'
  and store.store_id = 1
  and not exists (select * from rental
                      where rental.inventory_id = inventory.inventory_id
                      and rental.return_date is null);
                      
-- Elenca i clienti che non hanno restituito un film e quali film non hanno restituito
SELECT 
    c.first_name, 
    c.last_name, 
    json_arrayagg(r.inventory_id) AS notReturn
FROM
    rental AS r
    INNER JOIN customer AS c ON (c.customer_id = r.customer_id)
    INNER JOIN payment p ON (p.customer_id = c.customer_id AND p.rental_id = r.rental_id)
WHERE
    return_date IS NULL
GROUP BY c.customer_id
ORDER BY notReturn DESC;
