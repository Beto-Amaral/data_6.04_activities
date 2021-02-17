use bank;

/*
Getting finding information about clients such as their:
account numbers,
District,
Region, 
loan_id,
amount,
payments 
status "B"
*/

select a.account_id, a.district_id, a.frequency, d.A2 as District, d.A3 as Region,
l.loan_id, l.amount, l.payments, l.status from bank.account as a
join bank.district as d
on a.district_id = d.A1
join bank.loan as l
on a.account_id = l.account_id
where l.status = "B";

/*
We are interested in finding about only those default customers whose amount borrowed
 was more than the average amount borrowed by all the customers who defaulted.
 */
 
 -- Step1: Compute the average amount borrowed by those customers, using the
 -- previous results as a subquery.

select round(avg(amount),2) as Average from ( 
select a.account_id, a.district_id, a.frequency, d.A2 as District, d.A3 as Region,
l.loan_id, l.amount, l.payments, l.status from bank.account as a
join bank.district as d
on a.district_id = d.A1
join bank.loan as l
on a.account_id = l.account_id
where l.status = "B") as sub1;

-- Step 2: Get the customers for whose borrowed amount was bigger than the previous value

select * from bank.loan
where amount > (select round(avg(amount),2) as Average from ( 
select a.account_id, a.district_id, a.frequency, d.A2 as District, d.A3 as Region,
l.loan_id, l.amount, l.payments, l.status from bank.account as a
join bank.district as d
on a.district_id = d.A1
join bank.loan as l
on a.account_id = l.account_id
where l.status = "B") as sub1 ) 
and status = "B"
order by amount desc;

-- Another way:
select * from (
  select a.account_id, a.district_id, a.frequency, d.A2 as District,
    d.A3 as Region, l.loan_id, l.amount, l.payments, l.status
  from bank.account a join bank.district d
  on a.district_id = d.A1
  join bank.loan l
  on a.account_id = l.account_id
  where l.status = "B"
order by a.account_id) as sub1
where sub1.amount > (
  select round(avg(amount),2)
  from bank.loan
  where status = "B")
order by amount desc;