with mst_intervals(interval_month) as (
	values   (1)
			,(2)
			,(3)
			,(4)
			,(5)
			,(6)
			,(7)
			,(8)
			,(9)
			,(10)
			,(11)
			,(12))

, mst_users_with_index_month as (
	select
		u.user_id
		, u.register_date
		, cast(u.register_date::date + i.interval_month * '1 month'::interval as date)
		, substring(u.register_date, 1,7) as register_month
		, substring(cast(u.register_date::date + i.interval_month*'1 month'::interval as text),1,7) as index_month
	from mst_users as u 
	cross join mst_intervals as i)
	
, action_log_in_month as(
	select 
		distinct user_id
		, substring(stamp,1,7) as action_month
	from action_log)
	
select
	u.register_month
	, u.index_month
	, sum(case when a.action_month is not null then 1 else 0 end) as users
	, avg(case when a.action_month is not null then 100.0 else 0.0 end) as retension_rate
from mst_users_with_index_month as u 
left join action_log_in_month as a 
on u.user_id = a.user_id
and u.index_month = a.action_month
group by u.register_month, u.index_month
order by u.register_month desc;