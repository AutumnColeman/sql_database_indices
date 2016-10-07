-- Database Index Exercises
--
-- You will restore the database in my_yelp.dump. To do that, first create a database called my_yelp, then run pg_restore -d my_yelp my_yelp.dump --no-owner.
--
-- Optimize Lookup Time
--
-- Write a query to find the restaurant with the name 'Nienow, Kiehn and DuBuque'. Run the query and record the query run time.
736ms

-- Re-run query with explain, and record the explain plan.
Seq Scan on restaurant  (cost=0.00..57675.28 rows=47 width=23)
  Filter: ((name)::text = 'Nienow, Kiehn and DuBuque'::text)

-- Create an index for the restaurant's name column. This may take a few minutes to run.
74.5s

-- Re-run the query. Is performance improved? Record the new run time.
Yes! 1ms

-- Re-run query with explain. Record the query plan. Compare the query plan before vs after the index. You should no longer see "Seq Scan" in the query plan.
Bitmap Heap Scan on restaurant  (cost=4.79..186.57 rows=47 width=23)
  Recheck Cond: ((name)::text = 'Nienow, Kiehn and DuBuque'::text)
  ->  Bitmap Index Scan on restaurant_name_idx  (cost=0.00..4.78 rows=47 width=0)
        Index Cond: ((name)::text = 'Nienow, Kiehn and DuBuque'::text)

-- Optimize Sort Time
--
-- Write a query to find the top 10 reviewers based on karma. Run it and record the query run time.
-- Re-run query with explain, and record the explain plan.
-- Create an index on a column (which column?) to make the above query faster.
-- Re-run the query in step 1. Is performance improved? Record the new runtime.
-- Re-run query with explain. Record the query plan. Compare the query plan before vs after the index. You should no longer see "Seq Scan" in the query plan.
-- Optimize Join Time
--
-- Write a query to list the restaurant reviews for 'Nienow, Kiehn and DuBuque'. Run and record the query run time.
-- Re-run query with explain, and record the explain plan.
-- Write a query to find the average star rating for 'Nienow, Kiehn and DuBuque'. Run and record the query run time.
-- Re-run query with explain, and save the explain plan.
-- Create an index for the foreign key used in the join to make the above queries faster.
-- Re-run the query you ran in step 1. Is performance improved? Record the query run time.
-- Re-run the query you ran in step 3. Is performance improved? Record the query run time.
-- With explain, compare the before and after query plan of both queries.
-- Bonus: Optimize Join Time 2
--
-- Write a query to list the names of the reviewers who have reviewed 'Nienow, Kiehn and DuBuque'. Note the query run time and save the query plan.
-- Write a query to find the average karma of the reviewers who have reviewed 'Nienow, Kiehn and DuBuque'. Note the query run time and save the query plan.
-- Is this slow? Does it use a "Seq Scan"? If it is, create an index to make the above queries faster.
-- Re-run queries. Compare query run times and compare explain's query plans.
