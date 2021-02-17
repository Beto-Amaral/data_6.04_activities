-- Get when the last transactions was made by any of the previous customers

-- Get the customer intomation
select * from (
      select a.account_id, a.district_id, a.frequency, d.A2 as District,
        d.A3 as Region, l.loan_id, l.amount, l.payments, l.status
      from bank.account a
      join bank.district d
      on a.district_id = d.A1
        join bank.loan l
        on a.account_id = l.account_id
        where l.status = "B"
        order by a.account_id ) as sub1
      where sub1.amount > (
        select round(avg(amount),2)
        from bank.loan
        where status = "B")
order by amount desc;

-- Step 2: We store the results in in a CTE

with cte_1 as (
    select * from (
      select a.account_id, a.district_id, a.frequency, d.A2 as District,
        d.A3 as Region, l.loan_id, l.amount, l.payments, l.status
      from bank.account a
      join bank.district d
      on a.district_id = d.A1
        join bank.loan l
        on a.account_id = l.account_id
        where l.status = "B"
        order by a.account_id ) sub1
      where sub1.amount > (
        select round(avg(amount),2)
        from bank.loan
        where status = "B")
      order by amount desc)
select cte_1.account_id, cte_1.amount, max(date(t.date)) as Last_transaction from cte_1
join bank.trans as t 
on cte_1.account_id = t.account_id
group by cte_1.account_id, cte_1.amount
order by cte_1.amount desc;



-- Get all the customers payment is bigger than the average payments of all the customers
-- with the same loan in status "A"
select *
from bank.loan as l1
where l1.payments > (select round(avg(payments),2) from bank.loan as l2 where l1.duration = l2.duration)
and l1.status = "A"
order by account_id;