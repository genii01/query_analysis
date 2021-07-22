with access_log_with_path as (
	select 
		*
		, substring(url from'//[^/]+([^?#]+)') as url_path 
	from access_log)
	
select 
	url_path
	, count(distinct short_session) as access_count
	, count(distinct long_session) as access_users
	, count(*) as page_view
from access_log_with_path
group by url_pat