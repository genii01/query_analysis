select 
	substring(stamp, 1,10) as dt
	, count(distinct long_session) as access_users
	, count(distinct short_session) as access_count
	, count(*) as page_view
from
	access_log 
group by dt
order by dt;