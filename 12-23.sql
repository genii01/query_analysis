with monthly_user_action as(
	select 
		distinct u.user_id
		, substring(u.register_date, 1,7) as register_month
		, substring(l.stamp,1,7) as action_month
		, substring(cast(l.stamp::date - interval '1 month' as text), 1,7) as action_month_priv
	from mst_users as u 
	join action_log as l 
	on u.user_id= l.user_id)

, monthly_user_with_type as(
	select 
		action_month
		, user_id
		, register_month
		, case 	
			when register_month = action_month then 'new_user'
			when action_month_priv = lag(action_month) over(partition by user_id order by action_month) then 'repeat_user'
			else 'comeback_user'
		  end as c
		, action_month_priv
	from monthly_user_action
	)
	
select
	action_month
	, count(user_id) as mau
	, count(case when c= 'new_user' then 1 end) as new_users
	, count(case when c= 'comeback_user' then 1 end) as comeback_users
	, count(case when c= 'repeat_user' then 1 end) as repeat_users
from monthly_user_with_type
group by action_month
order by action_month;