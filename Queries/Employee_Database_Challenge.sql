Select e.emp_no
,e.first_name
,e.last_name
,et.title
,et.from_date
,et.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as et ON e.emp_no=et.emp_no
WHERE e.birth_date BETWEEN '1952-01-01' AND '1955-12-31'
ORDER BY emp_no asc;

SELECT DISTINCT ON (emp_no) r.emp_no,
r.first_name,
r.last_name,
r.title
INTO unique_titles
FROM retirement_titles as r
WHERE (r.to_date = '9999-01-01')
ORDER BY r.emp_no asc,
r.title desc;

SELECT count(emp_no),
title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count(emp_no) desc;

Select DISTINCT ON (e.emp_no) e.emp_no
,e.first_name
,e.last_name
,e.birth_date
,de.from_date
,de.to_date
,et.title
INTO mentorship_eligibility
FROM employees AS e
INNER JOIN dept_emp AS de ON e.emp_no=de.emp_no
INNER JOIN titles AS et ON e.emp_no=et.emp_no
WHERE (de.to_date = '9999-01-01')
AND e.birth_date BETWEEN '1965-01-01' AND '1965-12-31'
ORDER BY emp_no asc;

SELECT DISTINCT ON (emp_no) r.emp_no,
r.first_name,
r.last_name,
r.title,
d.dept_name
INTO unique_titles_dept
FROM retirement_titles AS r
INNER JOIN dept_emp AS de ON r.emp_no=de.emp_no
INNER JOIN departments AS d ON de.dept_no=d.dept_no
WHERE (r.to_date = '9999-01-01')
ORDER BY r.emp_no asc,
r.title desc;

SELECT dept_name
,count(emp_no)
FROM unique_titles_dept
GROUP BY dept_name
ORDER BY count(emp_no)desc;

Select e.emp_no
,e.first_name
,e.last_name
,et.title
,et.from_date
,et.to_date
INTO non_retirement_titles
FROM employees as e
INNER JOIN titles as et ON e.emp_no=et.emp_no
WHERE e.birth_date > '1955-12-31'
ORDER BY emp_no asc;

SELECT DISTINCT ON (emp_no) r.emp_no,
r.first_name,
r.last_name,
r.title,
d.dept_name,
r.from_date,
extract(year from r.from_date) as title_year,
extract(year from CURRENT_DATE) as current_year,
(extract(year from CURRENT_DATE))-(extract(year from r.from_date)) as years_in_title
INTO non_retirement_unique_titles
FROM non_retirement_titles as r
INNER JOIN dept_emp AS de ON r.emp_no=de.emp_no
INNER JOIN departments AS d ON de.dept_no=d.dept_no
WHERE (r.to_date = '9999-01-01')
ORDER BY r.emp_no asc,
r.title desc;

SELECT dept_name
,title
,count(emp_no) AS emp_count
,ROUND(AVG(years_in_title)) AS averge_years
,PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY years_in_title) AS Median
INTO non_retirement_average_years
FROM non_retirement_unique_titles
GROUP BY dept_name, title
ORDER BY Dept_name ASC,
count(emp_no) DESC;