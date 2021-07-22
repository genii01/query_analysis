select 
	url
	, count(distinct short_session) as access_count
	, count(distinct long_session) as access_users
	, count(*) as page_view
from access_log 
group by url;