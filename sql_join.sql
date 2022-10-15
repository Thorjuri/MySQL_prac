------------join 기능 = 테이블끼리 붙이는것. 실무에서 무조건 씀 (특히 left join,  inner join)
join을 할려면 테이블끼리 붙일 기준이 한가지 반드시 필요하다 
join 이란 여러 테이블의 공통된 정보. key 값을 통해서 붙인다. 
left join = 왼쪽에 있는 테이블을 기준으로 오른쪽에 붙인다. = 테이블끼리 순서가 중요!!
inner join = 공통으로 있는 기준이 되는 필드인 key를 정하고, 그 key가 null 값이 아닌 데이터만 불러온다!!
 즉 key가 user_id 이면, A테이블과 B테이블 모두 user_id가 null이 아닌 데이터를 갖고있는 행만 가져와서 붙인다. 
그러니깐 결국 A, B 테이블이 각기 갖고있는 겹치지 않는 필드도 가져오는것. 필드의 교집합이 아닌, key필드의 데이터가 겹치는것을 말함!!

select * FROM users u  -- 'users 테이블을 기준으로~ ' //그리고 별칭을 붙여준다. 그래야 마지막 on 줄에서 부르기 편한다.
left join point_users pu  -- 'point_users 테이블을 오른쪽에 붙여라`'
on u.user_id = pu.user_id -- 공통 key 값은 user의 user_id 와 point_users 의 user_id 
-- 이렇게 하면 왼쪽(처음)이 users, 오른쪽에 point_users 가 붙는다.


select * FROM users u
inner join point_users pu
on u.user_id = pu.user_id  -


SELECT * from orders o
inner join users u 
on o.user_id = u.user_id 


select * FROM  checkins c 
inner join users u 
on c.user_id = u.user_id 


SELECT * from enrolleds e 
inner join courses c 
on e.course_id = c.course_id 




-----------------------join 과 다른 문법 응용하기 
select c2.title, count(comment) as cnt FROM checkins c 
inner join courses c2 
on c.course_id = c2.course_id 
group by c2.title   -- 체크인테이블과 코스테이블을 묶은 뒤 같은 강의제목 별로 댓글 수 보기


SELECT pu.user_id, u.name, u.email, pu.point from point_users pu 
inner join users u 
on pu.user_id = u.user_id
order by pu.point desc   -- 포인트유저 테이블과 유저테이블은 묶은 뒤 포인트 많은 순서대로 정렬


select u.email, u.name, count(*) FROM orders o 
inner join users u 
on o.user_id = u.user_id 
where u.email like '%naver.com'
group by u.name


select* FROM orders o 
inner join users u 
on o.user_id = u.user_id 
where u.email like '%naver.com'



SELECT o.payment_method, round(avg(pu.point),0) FROM point_users pu 
inner join orders o 
on pu.user_id = o.user_id 
group by o.payment_method 


SELECT u.name, count(*) FROM enrolleds e 
inner join users u 
on e.user_id = u.user_id 
where e.is_registered = 0
group by u.name 
ORDER by count(*) DESC 

select c.course_id , c.title, count(*) FROM courses c 
inner join enrolleds e 
on c.course_id = e.course_id  
where e.is_registered = 0
group by title

SELECT c.created_at, c2.week, c.title, count(c2.checkin_id) from courses c 
inner join checkins c2
on c.course_id = c2.course_id
inner join orders o 
on c2.user_id  = o.user_id  
where o.created_at  >= '2020-08-01'
group by c.title, c2.week
ORDER by c.title, c2.week 


--------------------------------left join

SELECT  u.name , count(*) FROM users u 
left join point_users pu 
on u.user_id = pu.user_id 
where pu.point_user_id is not NULL
group by u.name 
order by count(*) desc 

select count(pu.point_user_id) as pnt_user_cnt, 
       count(u.user_id) as tot_user_cnt ,
       round(count(pu.point_user_id)/count(u.user_id),2) as ratio
   FROM users u
left join point_users pu 
on u.user_id = pu.user_id 
where u.created_at BETWEEN '2020-07-10' and '2020-07-20'

-------** count는 NULL값은 세지 않는다. 자동으로 NULL 빼고 센다


---------------------------UNION
 (
select '7월' as month, c1.title, c2.week, count(*) as cnt from courses c1
inner join checkins c2 on c1.course_id = c2.course_id
inner join orders o on c2.user_id = o.user_id
where o.created_at < '2020-08-01'
group by c1.title, c2.week
order by c1.title, c2.week
)
	union all  --union은 각각 테이블에서 order 준 것은 적용 안됨 (union 한 다음에 다시 정렬줘야함. 뒷부분 진도에 나옴)
(
select '8월' as month, c1.title, c2.week, count(*) as cnt from courses c1
inner join checkins c2 on c1.course_id = c2.course_id
inner join orders o on c2.user_id = o.user_id
where o.created_at >= '2020-08-01'
group by c1.title, c2.week
order by c1.title, c2.week
)



SELECT e.user_id, 
       e.enrolled_id, 
       count(*) as cnt_done 
   FROM enrolleds e 
left join enrolleds_detail ed 
on e.enrolled_id = ed.enrolled_id 
where ed.done = 1
group by e.enrolled_id , e.user_id 
order by cnt_done desc



