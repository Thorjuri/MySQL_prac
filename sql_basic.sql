select * from orders o 
where created_at BETWEEN '2020-07-13' and '2020-07-15'  //특정 날짜 사이의 데이터만

SELECT  * FROM  checkins c 
where week in (1,3)  //week가 1 또는 3 인것 (배개변수 여러개 쓸 수 있음)

SELECT * FROM users u 
where email like '%daum.net' // '%'는 압이나 뒤나 중간에 에 뭐가 있든 해당 단어로 끝나는 걸 찾으란 뜻. like와 자주 쓰인다

SELECT * FROM orders o 
where payment_method != 'CARD'

SELECT  * from point_users pu 
where point BETWEEN 20000 and 30000

SELECT * FROM users u 
where email like 's%com' and name = '이**' // 이메일이 s로 시작하고 com 으로 끝나는 성이 이 씨인 유저 

SELECT  * FROM  orders o 
where payment_method = 'kakaopay'
limit 5 //아주 양이 방대한 테이블이 어떻게 생겼나 확인만 해야할때, 몇 개만 정해서 보는 방법 limit 숫자

SELECT DISTINCT (payment_method) from orders o  // 중복 제거하고 보기 

select count(*) FROM orders o  //데이터의 갯수를 볼때 count(*). where과 같이 쓸 수 있음
where payment_method = 'kakaopay' 

SELECT count(DISTINCT (name)) from users u // 조건 중첩시키기!! 중복을 제거한 데이터의 갯수 = distinct와 count 중첩

select count(*) FROM users u  // 유저 데이터 갯수
where email like '%gmail.com'  // 이메일이 gmail 을 사용하는
and created_at BETWEEN '2020-07-12' and '2020-07-14' // 가입일이 이 날짜 사이인

SELECT  * FROM orders 
where course_title = '웹개발 종합반' 
and payment_method = 'kakaopay'
and email like '%naver.com'

-------------------------group by 해주면 반드시 select 로 뽑아낼때 그 항목도 같이 출력해줘야한다!!

select name, count(*) FROM users u  // 해당 그룹 가져오고, 숫자도 세서 가져와라 
group by name  //이름별로 묶어라.
실행 순서는 *로 전체 테이블 불러오기 --> name별로 그룹 짓기 --> 그룹별로 갯수 세기

SELECT email,name, count(*) from users u // 3. 이름별로 몇 명인지 보고싶다. 추가로 이메일도 함께
where email like '%naver.com'  //1. 이메일을 네이버 쓰는 사람 중에서 (가장 기초 조건)
GROUP by name  // 2. 이름별로 나눠서 

SELECT week, min(likes) FROM checkins  // 2. likes의 최솟값 구하기 (min)
group by week  // 1.주차별로 나눠서ㅏ

SELECT week, max(likes) FROM checkins //최댓값 구하기
group by week  

SELECT week, round(avg(likes), 2) FROM checkins //평균값 구하기 & 소숫점 2째 자리까지 반올림
group by week  

SELECT week, sum(likes) FROM checkins //합계 구하기
group by week  





----------------------- order by




SELECT name, count(*) FROM users u 
group by name
order by count(*) // 정렬은 항상 데이더 다 뽑고나서 마지막에 한다. 그리고 아무것도 안 쓰면 오름차순 (asc 써줘도 된다.)


SELECT name, count(*) FROM users u 
group by name
order by count(*) desc // 내림차순은 desc 붙이기 
 

select * FROM  checkins c 
order by likes desc

select course_title, payment_method, count(*) FROM orders o 
where course_title = '웹개발 종합반'
group by payment_method 
order by count(*)

SELECT * FROM users u
order by created_at 

SELECT payment_method, count(*) FROM orders o 
where course_title = '앱개발 종합반'
GROUP by payment_method
order by count(*)

SELECT name, count(*) FROM users u 
where email like '%gmail.com'
group by name 
order by count(*)
 

SELECT course_id , round(avg(likes),2) FROM checkins c  
group by course_id   //course_id 별로 좋아요 갯수 평균 구하기 (반올린 소숫점 2번째 자리까지)


-----------------별칭 기능: Alias (알리아스)

SELECT * FROM  orders o 
where o.course_title = '앱개발 종합반'  //별칭을 앞에 붙여서 어느 테이블의 필드인지 한 눈에 알아보기 쉽게 함


SELECT payment_method , count(*) as cnt FROM orders o  // as 별칭  이런식으로도 별칭 붙이기 가능 
where o.course_title = '앱개발 종합반'
GROUP by payment_method 


SELECT payment_method, count(*) as cnt from orders o 
where email like '%naver.com' 
and course_title = '앱개발 종합반'
group by payment_method 
order by count(*)  //네이버 메일을 사용하여 앱개발 종합반을 신청한 주문의 결제수단별 주문건수 























