USE testing_system;

-- Question 2
SELECT 
    *
FROM
    department;

-- Question 3
SELECT 
    department_id
FROM
    department
WHERE
    department_name = 'Sale';

-- Question 4
SELECT 
    *
FROM
    account
ORDER BY LENGTH(full_name) DESC
LIMIT 1;

-- Question 5
SELECT 
    *
FROM
    account
WHERE
    department_id = 3
ORDER BY LENGTH(full_name) DESC
LIMIT 1;

-- Question 6
SELECT 
    group_name
FROM
    `group`
WHERE
    group_id IN (SELECT 
            group_id
        FROM
            group_account
        WHERE
            join_date < '2019-12-20');

-- Question 7
SELECT 
    question_id
FROM
    answer
GROUP BY question_id
HAVING COUNT(answer_id) >= 4;

-- Question 8
SELECT 
    code
FROM
    exam
WHERE
    duration >= 60
        AND create_date < '2019-12-20';

-- Question 9
SELECT 
    *
FROM
    `group`
ORDER BY create_date DESC
LIMIT 5;

-- Question 10
SELECT 
    COUNT(*)
FROM
    account
WHERE
    department_id = 2;

-- Question 11
SELECT 
    *
FROM
    account
WHERE
    full_name LIKE 'D%o';
    
-- Question 12
DELETE FROM exam 
WHERE
    create_date < '2019-12-20';

-- Question 13
DELETE FROM question 
WHERE
    content LIKE 'câu hỏi%';

-- Question 14
UPDATE account 
SET 
    full_name = 'Nguyễn Bá Lộc',
    email = 'loc.nguyenba@vti.com.vn'
WHERE
    account_id = 5;

-- Question 15
UPDATE group_account 
SET 
    group_id = 4
WHERE
    account_id = 5;

















