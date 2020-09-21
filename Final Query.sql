#1
use employees;
SELECT 
    e.gender, d.dept_name, AVG(s.salary) AS avg_salary
FROM
    salaries s
        JOIN
    employees e ON s.emp_no = e.emp_no
        JOIN
    dept_emp de ON e.emp_no = de.emp_no
        JOIN
    departments d ON de.dept_no = d.dept_no
GROUP BY e.gender , d.dept_name;

#2
SELECT 
    MIN(dept_no), MAX(dept_no)
FROM
    dept_emp;
#3
SELECT 
    emp_no,
    (SELECT 
            MIN(dept_no)
        FROM
            dept_emp de
        WHERE
            e.emp_no = de.emp_no) dept_no,
    CASE
        WHEN emp_no <= 10020 THEN '110022'
        ELSE '110039'
    END AS manager
FROM
    employees e
WHERE
    emp_no <= 10040		
;	

SELECT 
    emp_no,
    (SELECT 
            MIN(dept_no)
        FROM
            dept_emp de
        WHERE
            e.emp_no = de.emp_no) dept_no,
    CASE
        WHEN emp_no <= 10020 THEN '110022'
        ELSE '110039'
    END AS manager
FROM
    employees e
WHERE
    emp_no <= 10040;

#4
SELECT 
    *
FROM
    employees
WHERE
    YEAR(hire_date) = 2000;

#5    
SELECT 
    *
FROM
    titles
WHERE
    title LIKE ('%engineer%'); 

#6
use employees;
delimiter //
create procedure emp_dept(in p_emp_no int)
begin 
	select de.emp_no, d.dept_no, d.dept_name
			from departments d
            join dept_emp de on d.dept_no = de.dept_no  
            where de.emp_no = p_emp_no
            and de.to_date = '9999-01-01';
	end //
delimiter ;

call employees.emp_dept(10010);

SELECT 
    COUNT(*)
FROM
    salaries
WHERE
    to_date - from_date > 10001
        AND salary >= 100000;
#7
SELECT 
    COUNT(*)
FROM
    salaries
WHERE
    salary >= 100000
        AND ((to_date - from_date) >= (60 * 60 * 24 * 7 * 52));
        

#8
delimiter // 

create trigger check_date
before insert on employees
for each row 
begin 
	if new.hire_date > sysdate() then
    set new.hire_date = date_format(sysdate(),'%y-%m-%d');
    end if;
    
end //
    
delimiter //    

#9
delimiter //
create function largest_salary(p_emp_no int)
returns integer 
deterministic
begin 
	declare max_salary int;
	select max(salary) into max_salary from salaries s 
    join employees e on s.emp_no = e.emp_no
    where e.emp_no = p_emp_no;
    return max_salary;
    end // 

delimiter //

select largest_salary(11356);

delimiter //

create function lowest_salary(p_emp_no int)
returns integer 
deterministic
begin 
	declare min_salary int;
	select min(salary) into min_salary from salaries s 
    join employees e on s.emp_no = e.emp_no
    where e.emp_no = p_emp_no;
    return min_salary;
    end // 

delimiter //
SELECT LOWEST_SALARY(11356);

#10
create function salary_finder(p_emp_no int, p_choose varchar(40))
returns integer 
deterministic 
begin 
declare emp_salary int;
	select
		case 
			when p_choose = 'max' then max(s.salary) 
			when p_choose = 'min' then min(s.salary) 
			else max(s.salary) - min(s.salary) 
			end as salary_info
	
	into emp_salary from salaries s 
	join 
	employees e on s.emp_no = e.emp_no
	where p_emp_no = e.emp_no;
	
    
return emp_salary;
end //


delimiter // 

SELECT SALARY_FINDER(11356, 'misafd')