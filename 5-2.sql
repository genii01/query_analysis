select 
	stamp
	, substring(referrer from 'https?://([^/]*)') as referrer_host 
from access_log;