---------------------------------------subquery: 원하는 데이터를 더 쉽게

select u.user_id , u.name , u.email  FROM users u 
inner join orders o 
on u.user_id = o.user_id 
where o.payment_method  = 'kakaopay'  -- join을 이용해서 하던 기존 방식

------------------where절에 들어가는 subquery
select u.user_id , u.name , u.email FROM users u 
where user_id in (
	select user_id  from orders o 
	where payment_method = 'kakaopay'  -- subquery를 사용한 위에거랑 같은 것
)  
어떻게 보면 원리는 join과 같으나, 각각의 테이블에서 조건 취한 뒤, 한 테이블 밑으로 subquery 넣어줌
subquery는 줄을 아주 잘 맞춰야함!!!!!! tab 하여 들여쓰기 중요!!
즉, subquery란 = 큰 query문 안에 있는 모든 query문들
안에서부터, 즉 subquery문 부터 처리한 후 밖으로 나가면서 순서대로 처리
위 처럼 where절에 들어갈 수도 있고, from절에 들어갈 수도 있고, select절에 들어갈 수도 있다.


--------------select절에 들어가는 subquery
select c.checkin_id,
       c.user_id , 
       c.likes, 
       (
	SELECT avg(likes) FROM checkins c 
	where user_id = c.user_id 
		)  
from checkins c 


----------------------from절에 들어가는 subquery (**가장많이 사용!!!!!)
select pu.user_id , pu.point, a.avg_likes FROM point_users pu 
inner join (
	select user_id , round(avg(likes),2) as avg_likes from checkins c 
	group by user_id 
) a on a.user_id = pu.user_id  -- subquery문으로 만든 조각 테이블을, 원래 있던 필드처럼 사용하는게 핵심



 
select * FROM point_users pu 
where point > (
	SELECT floor(avg(point)) FROM point_users pu
)


select * FROM point_users pu 
where point > (
	select round(avg(pu.point),0) FROM point_users pu 
	inner join users u 
	on pu.user_id = u.user_id 
	where u.name = '이**' 
)
order by point 
--


SELECT * FROM point_users pu 
where point > (
				SELECT round(avg(pu.point),0) 
				FROM point_users pu 
			   )



select * FROM point_users pu
where point > (
	select round(avg(point),0) FROM point_users pu2 
	inner join users u 
	on pu2.user_id = u.user_id 
	where u.name = '이**'
)



SELECT course_id, (
	select round(avg(likes),1) FROM checkins c2 
	where c.course_id = c2.course_id 
)
FROM checkins c 

select c.title, (
	select round(avg(likes),1) FROM checkins c2 
	where c.course_id = c2.course_id 
) as avg
FROM courses c 




-- ---------------------------from절 안의 subquery는 with 활용하면 깔금하다
with table1 as (
	select course_id, count(distinct(user_id)) as cnt_checkins from checkins
	group by course_id
), table2 as (
	select course_id, count(*) as cnt_total from orders
	group by course_id 
)
 -- with는 일종의 alias 원리와 같다. subquery를 임시 테이블로 명명해서 해당자리에 별칭처럼 쓸 수 있다.
 -- 대신 with는 항상 제일 위에 써줘야 한다.

select c.title,
       a.cnt_checkins,
       b.cnt_total,
       (a.cnt_checkins/b.cnt_total) as ratio
from table1 a
inner join table2 b on a.course_id = b.course_id
inner join courses c on a.course_id = c.course_id



