-- Get the total transaction amount from all the customers in the first quarter of 1993
select account_id, round(sum(amount),2) as Amount, date_format(date, "%M") as Month from trans
where date_format(date, "%Y") = 1993 and date_format(date, "%m") <= 3
group by account_id, Month;

-- We would preffer to have for each account_id and month, the last transaction amount.

-- To get the month as columns, we need to include the month as columns in the select.
-- The only way to do this is using a 'case statement'
select account_id,
max( case when Month = 'January' Then Amount end) as January,
max( case when Month = 'February' Then Amount end) as February,
max( case when Month = 'March' Then Amount end) as March
from (
  select account_id, round(sum(amount),2) as Amount, date_format(date, "%M") as Month
  from trans
  where date_format(date, "%Y") = 1993 and date_format(date, "%m") <= 3
  group by account_id, Month) sub1
group by account_id
order by account_id;
