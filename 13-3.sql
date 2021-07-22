with purchase_log(user_id, product_id, purchase_date) as (
 values
 	('u001','1','2016-09-01')
 	,('u001','2','2016-09-20')
 	,('u002','3','2016-09-30')
 	,('u001','4','2016-10-01')
 	,('u002','5','2016-11-01')
 	)
 select  
 	user_id
 	, purchase_date
 	, cast(purchase_date as date) - lag(cast(purchase_date as date)) over(partition by user_id order by purchase_date asc) as lead_date

 from purchase_log;
