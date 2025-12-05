USE testing_system;

-- Question 1
SELECT 
    a.user_name, d.department_name
FROM
    account a
        JOIN
    department d ON a.department_id = d.department_id;

-- Question 2
SELECT 
    *
FROM
    account
WHERE
    create_date > '2010-12-20';
    
-- Question 3
SELECT 
    a.full_name, p.position_name
FROM
    account a
        JOIN
    position p ON a.position_id = p.position_id and position_name = 'Dev';

-- Question 4
SELECT 
    d.department_id, department_name, COUNT(a.account_id)
FROM
    account a
        JOIN
    department d ON a.department_id = d.department_id
GROUP BY department_name , department_id
HAVING COUNT(a.account_id) >= 3
;

-- Question 5
SELECT 
    question_id, COUNT(exam_id)
FROM
    exam_question
GROUP BY question_id
LIMIT 1;

-- Question 6
SELECT 
    a.category_name, COUNT(q.question_id)
FROM
    category_question a
        JOIN
    question q ON a.category_id = q.category_id
GROUP BY a.category_name
;

-- Question 7
SELECT 
    question_id, COUNT(exam_id)
FROM
    exam_question
GROUP BY question_id;

-- Question 8
SELECT 
    q.question_id, COUNT(a.answer_id)
FROM
    question q
        JOIN
    answer a ON q.question_id = a.question_id
GROUP BY q.question_id
LIMIT 1;

-- Question 9
SELECT 
    group_id, COUNT(account_id)
FROM
    group_account
GROUP BY group_id;

-- Question 10
SELECT 
    p.position_id, COUNT(a.account_id)
FROM
    position p
        JOIN
    account a ON a.position_id = p.position_id
GROUP BY p.position_id
ORDER BY COUNT(a.account_id)
LIMIT 1;

-- Question 11
SELECT 
    d.department_name, COUNT(p.position_name)
FROM
    account a
        INNER JOIN
    department d ON d.department_id = a.department_id
        INNER JOIN
    position p ON a.position_id = p.position_id
GROUP BY d.department_name;

-- Question 12
SELECT 
    q.question_id,
    q.content,
    t.type_name,
    c.category_name,
    a.full_name,
    an.answer_id
FROM
    question q
        JOIN
    category_question c ON q.category_id = q.category_id
        JOIN
    type_question t ON q.type_id = t.type_id
        JOIN
    account a ON a.account_id = q.creator_id
        JOIN
    answer an ON an.question_id = q.question_id;
    
-- Question 13
    SELECT 
    t.type_name, COUNT(question_id)
FROM
    question q
        JOIN
    type_question t ON q.type_id = t.type_id
GROUP BY type_name;

-- Question 14
SELECT 
    g.*
FROM
    `group` g
        LEFT JOIN
    group_account ga ON g.group_id = ga.group_id
WHERE
    ga.account_id IS NULL;
;

-- Question 16
SELECT 
    q.question_id, q.content
FROM
    question q
        LEFT JOIN
    answer a ON q.question_id = a.question_id
WHERE
    a.answer_id IS NULL;
-- Question 17
SELECT 
    a.account_id,
    a.email,
    a.user_name,
    a.full_name,
    a.department_id,
    a.position_id,
    a.create_date
FROM
    account a
        JOIN
    group_account ga ON a.account_id = ga.account_id
WHERE
    ga.group_id = 1 
UNION SELECT 
    a.account_id,
    a.email,
    a.user_name,
    a.full_name,
    a.department_id,
    a.position_id,
    a.create_date
FROM
    account a
        JOIN
    group_account ga ON a.account_id = ga.account_id
WHERE
    ga.group_id = 2;
 
-- Question 18

SELECT 
    g.group_id, g.group_name, COUNT(ga.account_id)
FROM
    `group` g
        LEFT JOIN
    group_account ga ON g.group_id = ga.group_id
GROUP BY g.group_id , g.group_name
HAVING COUNT(ga.account_id) > 5 
UNION SELECT 
    g.group_id, g.group_name, COUNT(ga.account_id)
FROM
    `group` g
        LEFT JOIN
    group_account ga ON g.group_id = ga.group_id
GROUP BY g.group_id , g.group_name
HAVING COUNT(ga.account_id) < 7;
