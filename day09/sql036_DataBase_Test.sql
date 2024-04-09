-- 1. 회원 테이블에서 이메일, 모바일, 이름, 주소 순으로 나오도록 검색하시오.
SELECT Email AS 'email'
	 , Mobile AS 'mobile'
	 , Names AS 'name'
	 , Addr AS 'addr'
  FROM membertbl
 ORDER BY Addr DESC, email ASC

-- 2. 함수를 사용하여 아래와 같은 결과가 나오도록 쿼리를 작성하시오.
SELECT Names AS '도서명'
	 , Author AS '저자'
	 , ISBN
	 , Price AS '정가'
  FROM bookstbl
 ORDER BY Price DESC  

-- 3. 다음과 같은 결과가 나오도록 SQL 문을 작성하시오(책을 한번도 빌린적이 없는 회원을 뜻합니다)
SELECT m.Names '회원명'
	 , m.Levels '회원등급'
	 , m.Addr '주소'
	 , r.rentalDate '대여일'
  FROM membertbl AS m LEFT OUTER JOIN rentaltbl AS r
  ON m.memberIdx = r.memberIdx
WHERE rentalDate is null
 ORDER BY Levels ASC
SELECT *
  FROM membertbl
 

-- 4. 다음과 같은 결과가 나오도록 SQL 문을 작성하시오
SELECT d.Names AS '책 장르'
	 , FORMAT(SUM(b.price), '#,#') + '원' AS '총 합계'
  FROM bookstbl AS b, divtbl AS d
 WHERE b.Division = d.Division
GROUP BY d.Names

SELECT *
  FROM divtbl

SELECT *
  FROM bookstbl
-- 5. 다음과 같은 결과가 나오도록 SQL 문을 작성하시오
SELECT ISNULL(d.Names, '--합계--' )AS '책 장르'
	 , COUNT(b.division) AS '권수'
	 , FORMAT(SUM(b.price), '#,#') + '원' AS '총 합계'
  FROM bookstbl AS b, divtbl AS d
  WHERE b.Division = d.Division
GROUP BY d.Names WITH ROLLUP