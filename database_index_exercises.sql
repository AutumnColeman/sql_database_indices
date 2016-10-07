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

# Optimize Sort Time
--
-- Write a query to find the top 10 reviewers based on karma. Run it and record the query run time.
1.9s
-- Re-run query with explain, and record the explain plan.
Limit  (cost=229886.35..229886.37 rows=10 width=23)
  ->  Sort  (cost=229886.35..244887.02 rows=6000269 width=23)
        Sort Key: karma DESC
        ->  Seq Scan on reviewer  (cost=0.00..100222.69 rows=6000269 width=23)
-- Create an index on a column (which column?) to make the above query faster.
karma column 14.2s

-- Re-run the query in step 1. Is performance improved? Record the new runtime.
Yep! 2ms

-- Re-run query with explain. Record the query plan. Compare the query plan before vs after the index. You should no longer see "Seq Scan" in the query plan.
Limit  (cost=0.43..0.96 rows=10 width=23)
  ->  Index Scan Backward using reviewer_karma_idx on reviewer  (cost=0.43..314541.72 rows=6000200 width=23)

-- Optimize Join Time
--
--1 Write a query to list the restaurant reviews for 'Nienow, Kiehn and DuBuque'. Run and record the query run time.
select restaurant.name "Restaurant", review.title "Review Title", review.content "Review Content" from restaurant, review where restaurant.name = 'Nienow, Kiehn and DuBuque';
 27.3s

--2 Re-run query with explain, and record the explain plan.
Nested Loop  (cost=4.79..3789713.68 rows=282011562 width=244)
  ->  Seq Scan on review  (cost=0.00..264382.46 rows=6000246 width=225)
  ->  Materialize  (cost=4.79..186.81 rows=47 width=19)
        ->  Bitmap Heap Scan on restaurant  (cost=4.79..186.57 rows=47 width=19)
              Recheck Cond: ((name)::text = 'Nienow, Kiehn and DuBuque'::text)
              ->  Bitmap Index Scan on restaurant_name_idx  (cost=0.00..4.78 rows=47 width=0)
                    Index Cond: ((name)::text = 'Nienow, Kiehn and DuBuque'::text)

--3 Write a query to find the average star rating for 'Nienow, Kiehn and DuBuque'. Run and record the query run time.
3.7s
--4 Re-run query with explain, and save the explain plan.
Aggregate  (cost=4494742.58..4494742.60 rows=1 width=32)
  ->  Nested Loop  (cost=4.79..3789713.68 rows=282011562 width=4)
        ->  Seq Scan on review  (cost=0.00..264382.46 rows=6000246 width=4)
        ->  Materialize  (cost=4.79..186.81 rows=47 width=0)
              ->  Bitmap Heap Scan on restaurant  (cost=4.79..186.57 rows=47 width=0)
                    Recheck Cond: ((name)::text = 'Nienow, Kiehn and DuBuque'::text)
                    ->  Bitmap Index Scan on restaurant_name_idx  (cost=0.00..4.78 rows=47 width=0)
                          Index Cond: ((name)::text = 'Nienow, Kiehn and DuBuque'::text)
--5 Create an index for the foreign key used in the join to make the above queries faster.
--6 Re-run the query you ran in step 1. Is performance improved? Record the query run time.
--7 Re-run the query you ran in step 3. Is performance improved? Record the query run time.
--8 With explain, compare the before and after query plan of both queries.
-- Bonus: Optimize Join Time 2
--
-- Write a query to list the names of the reviewers who have reviewed 'Nienow, Kiehn and DuBuque'. Note the query run time and save the query plan.
-- Write a query to find the average karma of the reviewers who have reviewed 'Nienow, Kiehn and DuBuque'. Note the query run time and save the query plan.
-- Is this slow? Does it use a "Seq Scan"? If it is, create an index to make the above queries faster.
-- Re-run queries. Compare query run times and compare explain's query plans.
