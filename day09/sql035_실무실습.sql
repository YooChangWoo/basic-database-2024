-- 2024-04-09
-- p.555 부터 시작

/* 5. 현재의 날짜 타입을 날짜 함수를 통해 확인
      2006년 5월 20일부터 2007년 5월 20일 사이에 고용된 사원의 이름(FRIST + LAST), 사원번호, 고용일자
      단, 입사일 빠른 순으로 정렬하시오(18개 행) */
SELECT FIRST_NAME + ' ' + LAST_NAME AS 'name'
     , EMPLOYEE_ID
     , HIRE_DATE
  FROM employees
 WHERE HIRE_DATE BETWEEN '2006-05-20' AND '2007-05-20'
 ORDER BY HIRE_DATE ASC;

/* 6. 급여와 수당율에 대한 지출보고서. 수당을 받는 모든 사원의 이름, 급여, 업무, 
      수당율을 출력 (35개 행) 지금 수당율 테이블에 값이 안들어가져 있음.. */
SELECT FIRST_NAME + ' ' + LAST_NAME AS 'name'
     , SALARY
     , JOB_ID
     , COMMISSION_PCT
  FROM employees
 WHERE COMMISSION_PCT IS NOT NULL
 ORDER BY SALARY DESC, COMMISSION_PCT DESC;

-- 단일행 함수, 변환 함수
/* 샘플문제 : 60번 IT부서에 사원 급여를 12.3% 인상하기로 함. 정수만 반올림하여
              보고서를 작성하라. 사번, 이름, 급여, 인상된 급여(Increased Salary)(5개 행) */
SELECT EMPLOYEE_ID
     , FIRST_NAME + ' ' + LAST_NAME AS 'name'
     , SALARY
     , CONVERT(INT,ROUND(SALARY * 1.123, 0))  AS 'Increased Salary' -- SALARY + (SALARY * 0.123) 똑같음
  FROM employees
 WHERE DEPARTMENT_ID = 60;

/* 7. 사원의 성이 s로 끝나는 사원의 이름과 업무를 아래의 예시와 같이 출력(18개 행)
  Ex) Michael Rogers is a ST_CLERK */
SELECT FIRST_NAME + ' ' + LAST_NAME + ' is a ' +  JOB_ID AS 'Employee JOBS'
  FROM employees
 WHERE LAST_NAME LIKE '%s';

/* 8. 이름, 급여, 수당 여부에 따른 연봉을 포함하여 출력, Salary + Commission /
      Salary Only, 연봉이 높은 순 (107개 행) */


/* 9. 이름, 입사일, 입사일의 요일 출력, 일요일부터 토요일순으로 (107개 행) */
SELECT FIRST_NAME + ' ' + LAST_NAME AS 'name'
     , HIRE_DATE
    -- , DATENAME(WEEKDAY, DATEPART(DW, HIRE_DATE)) AS 'Day of the Week'
     , DATEPART(WEEKDAY, DATEPART(DW, HIRE_DATE))
     , DATEPART(DW, HIRE_DATE)
  FROM employees
 ORDER BY DATEPART(DW, HIRE_DATE);

SELECT DATEPART(DW, GETDATE())
     , DATENAME(WEEKDAY, DATEPART(DW, GETDATE()))

 -- 집계 함수, SUM, COUNT, AVG, MAX, MIN...
 /* 11. 사원들의 업무별 전체 급여 평균이 10,000$ 보다 큰 경우를 조회, 
        업무, 급여평균을 출력하시오, 단 사원(CLERK)이 포함된 경우는 제외, 전체 급여 내림차순으로(7개 행) */
SELECT JOB_ID
     , '$' + FORMAT(AVG(SALARY), '#,#') AS 'Avg Salary'
  FROM employees
 GROUP BY JOB_ID
HAVING AVG(SALARY) >= 10000
 ORDER BY 2 DESC;

-- JOIN
/* 12. Employees, Department 조인, 사원수가 5명 이상인 부서의 부서명, 사원수 출력 
       사원수를 내림차순으로 정렬*/
/* 13번 문제도 풀수 있음 */
SELECT D.department_name
     , COUNT(*) AS '사원수'
  FROM employees AS e, departments AS d
 WHERE e.DEPARTMENT_ID = d.department_id
 GROUP BY d.department_name
HAVING COUNT(*) >= 5
 ORDER BY COUNT(*) DESC;

 -- 서브쿼리
 /* 사원의 급여 정보중 업무별 최소 급여를 받는 사원의 이름을, 업무, 급여, 입사일 출력(21) */
SELECT e.FIRST_NAME +' '+ e.LAST_NAME as 'name'
     , e.JOB_ID
     , e.SALARY
     , e.HIRE_DATE
  FROM employees AS e
 WHERE SALARY <= (SELECT MIN(SALARY) AS salary
                    FROM employees
                   WHERE JOB_ID = e.JOB_ID
                   GROUP BY JOB_ID);

-- CASE 연산자(프로그래밍적인)
/* 107명의 직원중 HR_REP(10%), MK_REP(12%), PR_REP(15%), SA_REP(18%), IT_PROG(20%) */
SELECT *
  FROM employees

SELECT EMPLOYEE_ID
     , FIRST_NAME +' '+ LAST_NAME as 'NAME'
     , JOB_ID
     , SALARY
     , CASE job_id WHEN 'HR_REP' THEN SALARY * 1.10
                   WHEN 'MK_REP' THEN SALARY * 1.12 
                   WHEN 'PR_REP' THEN SALARY * 1.15
                   WHEN 'SA_REP' THEN SALARY * 1.18
                   WHEN 'SA_REPG' THEN SALARY * 1.20 
       ELSE SALARY END AS 'New Salary'
  FROM employees;

-- ROLLUP, CUBE - GROUP BY 제일 마지막에 WITH ROLLUP.
-- 부서와 업무별 급여합계를 구하여 신년 급여수준레벨을 지정하고자 함
-- 부서번호, 업무를 기준으로 그룹별로 나누고 급여합계와 인원수를 출력(20개행)
-- CUBE 보다 
SELECT DEPARTMENT_ID
     , JOB_ID 
     , COUNT(EMPLOYEE_ID) AS 'count EMPs'
     , '$' + FORMAT(SUM(SALARY), '#,#') AS 'Salary SUM'
  FROM employees
 GROUP BY DEPARTMENT_ID, JOB_ID
 ORDER BY DEPARTMENT_ID

 SELECT DEPARTMENT_ID
     , ISNULL(JOB_ID, '--합계--') AS JOB_ID 
     , COUNT(EMPLOYEE_ID) AS 'count EMPs'
     , '$' + FORMAT(SUM(SALARY), '#,#') AS 'Salary SUM'
  FROM employees
 GROUP BY DEPARTMENT_ID, JOB_ID WITH ROLLUP

SELECT DEPARTMENT_ID
     , JOB_ID 
     , COUNT(EMPLOYEE_ID) AS 'count EMPs'
     , '$' + FORMAT(SUM(SALARY), '#,#') AS 'Salary SUM'
  FROM employees
 GROUP BY ROLLUP(DEPARTMENT_ID, JOB_ID);

-- RANK, ROW_NUMBER, FIRST_VALUE

-- 사원들의 부서별 급여 기준으로 내림차순으로 정렬, 순위를 표시하시오.(107개행)
SELECT EMPLOYEE_ID
     , LAST_NAME
     , SALARY
     , DEPARTMENT_ID
     , RANK() OVER(ORDER BY SALARY DESC) -- 동등순위 중복증가 타입
     , DENSE_RANK() OVER (ORDER BY SALARY DESC) -- 동승순위 순차증가타입
  FROM employees
 ORDER BY SALARY DESC;

-- 각 행의 번호를 가져오는 함수
SELECT ROW_NUMBER() OVER(ORDER BY employees_id dasc)
      , *
  FROM employees
 ORDER BY EMPLOYEE_ID ASC;