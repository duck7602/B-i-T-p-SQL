-- Question 1: Viết lệnh để lấy ra danh sách nhân viên và thông tin phòng ban của họ

SELECT 
    a.*, d.department_name
FROM
    account a
        LEFT JOIN
    department d ON a.department_id = d.department_id;
    
-- Question 2: Viết lệnh để lấy ra thông tin các account được tạo sau ngày 20/12/2010
-- Question 3: Viết lệnh để lấy ra tất cả các developer

SELECT 
    a.account_id, a.user_name
FROM
    account a
        JOIN
    position p ON a.position_id = p.position_id
WHERE
    position_name = 'Dev';
    
-- Question 4: Viết lệnh để lấy ra danh sách các phòng ban có >3 nhân viên

SELECT 
    d.department_id,
    d.department_name,
    COUNT(a.account_id) AS ca
FROM
    account a
        JOIN
    department d ON a.department_id = d.department_id
GROUP BY d.department_id
HAVING ca > 3;

-- Question 5: Viết lệnh để lấy ra danh sách câu hỏi được sử dụng trong đề thi nhiều nhất

SELECT 
    question_id, COUNT(exam_id)
FROM
    exam_question
GROUP BY question_id
HAVING COUNT(exam_id) = (SELECT 
        MAX(ce)
    FROM
        (SELECT 
            COUNT(exam_id) AS ce
        FROM
            exam_question
        GROUP BY question_id) AS t);

-- Question 6: Thông kê mỗi category Question được sử dụng trong bao nhiêu Question

SELECT 
    c.category_id,
    c.category_name,
    COUNT(q.question_id) AS total_question
FROM
    category_question c
        LEFT JOIN
    question q ON c.category_id = q.category_id
GROUP BY c.category_id , c.category_name;

-- Question 7: Thông kê mỗi Question được sử dụng trong bao nhiêu Exam

SELECT 
    q.question_id, COUNT(e.exam_id) AS total_exam
FROM
    question q
        LEFT JOIN
    exam_question e ON q.question_id = e.question_id
GROUP BY q.question_id;

-- Question 8: Lấy ra Question có nhiều câu trả lời nhất

SELECT 
    q.question_id, COUNT(a.answer_id)
FROM
    question q
        JOIN
    answer a ON q.question_id = a.question_id
GROUP BY q.question_id
HAVING COUNT(a.answer_id) = (SELECT 
        MAX(ca)
    FROM
        (SELECT 
            COUNT(answer_id) AS ca
        FROM
            question q
        JOIN answer a ON q.question_id = a.question_id
        GROUP BY q.question_id) AS t);
        
        
-- Question 9: Thống kê số lượng account trong mỗi group

SELECT 
    g.group_id, COUNT(a.account_id)
FROM
    group_account g
        LEFT JOIN
    account a ON g.account_id = a.account_id
GROUP BY g.group_id;

-- Question 10: Tìm chức vụ có ít người nhất

SELECT 
    p.position_id,
    p.position_name,
    COUNT(a.account_id) AS total_account
FROM
    position p
        LEFT JOIN
    account a ON p.position_id = a.position_id
GROUP BY p.position_id
HAVING total_account = (SELECT 
        MIN(ca)
    FROM
        (SELECT 
            COUNT(a.account_id) AS ca
        FROM
            position p
        LEFT JOIN account a ON p.position_id = a.position_id
        GROUP BY p.position_id) AS t);
        
-- Question 11: Thống kê mỗi phòng ban có bao nhiêu dev, test, scrum master, PM
-- Question 12: Lấy thông tin chi tiết của câu hỏi bao gồm: thông tin cơ bản của
-- question, loại câu hỏi, ai là người tạo ra câu hỏi, câu trả lời là gì, …
-- Question 13: Lấy ra số lượng câu hỏi của mỗi loại tự luận hay trắc nghiệm
-- Question 14:Lấy ra group không có account nào

SELECT 
    *
FROM
    `group` g
        LEFT JOIN
    group_account ga ON g.group_id = ga.group_id
WHERE
    ga.account_id IS NULL;
    
-- Question 15: Lấy ra group không có account nào
-- Question 16: Lấy ra question không có answer nào.

SELECT 
    *
FROM
    question q
        LEFT JOIN
    answer a ON q.question_id = a.question_id
WHERE
    a.answer_id IS NULL;
    
-- Question 17:
-- a) Lấy các account thuộc nhóm thứ 1
-- b) Lấy các account thuộc nhóm thứ 2
-- c) Ghép 2 kết quả từ câu a) và câu b) sao cho không có record nào trùng nhau

SELECT 
    *
FROM
    account a
        JOIN
    group_account ga ON a.account_id = ga.account_id
    where ga.group_id = 1;
-- Question 18:
-- a) Lấy các group có lớn hơn 5 thành viên
-- b) Lấy các group có nhỏ hơn 7 thành viên
-- c) Ghép 2 kết quả từ câu a) và câu b).
