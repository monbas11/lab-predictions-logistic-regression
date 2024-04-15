-- LAB Making predictions with logistic regression
-- Create a query or queries to extract the information you think may be relevant 
-- for building the prediction model. It should include some film features and some rental features.
WITH times_rented AS 
    (SELECT i.film_id, COUNT(*) AS times_rented
    FROM rental AS r
    JOIN inventory AS i USING (inventory_id)
    WHERE r.rental_date BETWEEN '2005-07-01' AND '2005-07-31'
    GROUP BY i.film_id)
SELECT f.film_id, f.length, f.rating, c.name as category, f.rental_rate, f.rental_duration, rc.times_rented,
    CASE 
        WHEN rc.times_rented > AVG(rc.times_rented) OVER () THEN 'high'
        WHEN rc.times_rented <= AVG(rc.times_rented) OVER () THEN 'low'
        ELSE 'unknow'
    END AS probability_of_rented
FROM film AS f
    JOIN film_category AS fc USING (film_id)
    JOIN category AS c USING (category_id)
    JOIN times_rented AS rc USING (film_id)
ORDER BY f.film_id ASC;

