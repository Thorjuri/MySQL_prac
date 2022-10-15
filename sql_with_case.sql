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



---------------------------실전에서 유용한 SQL 문법 

-- 1. 이메일 추출하기
-- SUBSTRING_INDEX(추출할 필드, 쪼갤 기준스트링, 최종 가져올 문자열 인덱스) 
select user_id, email, SUBSTRING_INDEX(email, '@', -1)  FROM users u 

-- 2. 문자열의 특정 부분만 추출하기 
-- substring(추출할 필드, 시작인덱스, 글자수)
select substring(created_at,1,10) as date, count(*)  FROM orders o 
group by date


select pu.user_id , pu.point, count(*),
	   (case when pu.point > 10000 then '잘 하고 있어요'
	   	    when pu.point > 5000 then '거의 다 왔네요'
	   	    when pu.point > 3000 then '조금만 더 파이팅!'
	   else '분발하세요!' end) as lv
	FROM point_users pu 
	group by msg


	
-- 위에서 만든 case를 subquery로 활용하기. from절의 subquery + with 활용
	
with table1 as (
	select pu.user_id , pu.point, 
		   (case when pu.point > 10000 then '잘 하고 있어요'
		   	    when pu.point > 5000 then '거의 다 왔네요'
		   	    when pu.point > 3000 then '조금만 더 파이팅!'
		 		  else '분발하세요!' end) as lv
	FROM point_users pu 
)

select a.lv, count(*) as cnt FROM table1 a 
group by a.lv
	


-- 퀴즈1. 평균이상 포인트를 갖고 있으면 잘하고 있어요, 아니면 열심히 합시다. (case + subquery)
select user_id , point, 
	(case when pu.point >(
		select round(avg(pu.point),0) as avg from point_users pu
	) then '잘 하고 있어요'
	else '조금 더 힘내요' end) as msg
FROM point_users pu 
order by point


-- 퀴즈2. 이메일 도메인별 유저의 수 세어보기 (2가지 방법)
select user_id , email, SUBSTRING_INDEX(email, '@', -1 ) as domain, count(*),
	(case when email like '%naver%' then '네이버'
		 when email like '%yahoo%' then '야후'
		 when email like '%gmail%' then '구글'
		 else '스파르타' end) as 도메인
FROM users u
group by 도메인



select user_id , email, count(*),
	(case when  SUBSTRING_INDEX(email, '@', -1 ) like 'naver%' then '네이버'
		 when  SUBSTRING_INDEX(email, '@', -1 ) like 'yahoo%' then '야후'
		 when  SUBSTRING_INDEX(email, '@', -1 ) like 'gmail%' then '구글'
		 else '스파르타' end) as domain
FROM users u
group by domain


-- 퀴즈3. 화이팅이 포함된 오늘의 다짐 출력
select * FROM checkins c 
where comment like '%화이팅%'




-- 퀴즈 4. 수강등록정보 (enrolled_id)별 전체 강의 수와 들은 강의 수 출력해보기
SELECT ed.enrolled_id , count(*) as total, a.done FROM enrolleds_detail ed  
inner join (
	select  enrolled_id , count(*)as done FROM enrolleds_detail ed 
	where done = 1
	group by enrolled_id 
) a on ed.enrolled_id = a.enrolled_id
group by enrolled_id 
 




-- 퀴즈 5. 수강등록정보 (enrolled_id)별 전체 강의 수와 들은 강의 수, 진도율까지 출력해보기
with table1 as (
	select  enrolled_id , count(*)as done FROM enrolleds_detail ed 
	where done = 1
	group by enrolled_id 
)

SELECT ed.enrolled_id , 
	   count(*) as total, 
	   a.done, 
	   round(a.done/count(*), 2) as ratio 
FROM enrolleds_detail ed  
inner join table1 a on ed.enrolled_id = a.enrolled_id
group by enrolled_id 
