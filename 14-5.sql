
with access_log_with_parse_info as (
	select *
		, substring(url from 'https?://([^/]*)') as url_domain
		, substring(url from 'utm_source=([^&]*)') as url_utm_source
		, substring(url from 'utm_medium=([^&]*)') as url_utm_medium 
		, substring(referrer from 'https?://([^/]*)') as referrer_domain
		
	from access_log )
, access_log_with_via_info as(
	select
		row_number() over(order by stamp) as log_id
		, case 
			when url_utm_source <> '' and url_utm_medium <> ''
				then concat(url_utm_source, '-', url_utm_medium)
			when referrer_domain in ('search.yahoo.co.jp', 'www.google.co.jp') then 'search'
			when referrer_domain in ('twitter.com','ww.facebook.com') then 'social'
			else 'others' end as via
			
	from access_log_with_parse_info
	where coalesce(referrer, '') not in ('', url_domain))

select 
	via
	, count(1) as access_count
from access_log_with_via_info
group by via
order by access_count desc;