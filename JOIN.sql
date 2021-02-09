--INNER JOIN
SELECT 
	c.id candidate_id,
	c.fullname candidate_name,
	e.id employee_id,
	e.fullname employee_name
FROM candidates AS c INNER JOIN employees AS e
	ON (e.fullname=c.fullname);

--LEFT JOIN Inclusivo
SELECT 
	c.id candidate_id,
	c.fullname candidate_name,
	e.id employee_id,
	e.fullname employee_name
FROM candidates AS c LEFT JON employees AS e
	ON (e.fullname=c.fullname);

--LEFT JOIN Exclusivo
SELECT 
	c.id candidate_id,
	c.fullname candidate_name,
	e.id employee_id,
	e.fullname employee_name
FROM candidates AS c LEFT JOIN employees AS e
	ON (e.fullname=c.fullname);
	WHERE 
		e.id IS NOT NULL

--RIGHT JOIN Inclusivo
SELECT 
	c.id candidate_id,
	c.fullname candidate_name,
	e.id employee_id,
	e.fullname employee_name
FROM candidates AS c RIGHT JOIN employees AS e
	ON (e.fullname=c.fullname);

--RIGHT JOIN Exclusivo
SELECT 
	c.id candidate_id,
	c.fullname candidate_name,
	e.id employee_id,
	e.fullname employee_name
FROM candidates AS c RIGHT JOIN employees AS e
	ON (e.fullname=c.fullname);
	WHERE 
		c.id IS NOT NULL

--FULL OUTER JOINM or FULL JOIN Exclusiva
SELECT 
	c.id candidate_id,
	c.fullname candidate_name,
	e.id employee_id,
	e.fullname employee_name
FROM candidates AS c RIGHT JOIN employees AS e
	ON (e.fullname<>c.fullname);

SELECT 
	c.id candidate_id,
	c.fullname candidate_name,
	e.id employee_id,
	e.fullname employee_name
FROM candidates AS c RIGHT JOIN employees AS e
	ON (e.fullname<>c.fullname);
	WHERE 
		c.id IS NULL AND e.id IS NULL;


