-- Question 1: Tạo store để người dùng nhập vào tên phòng ban và in ra tất cả các account thuộc phòng ban đó.

DROP PROCEDURE IF EXISTS get_account_in_department;
DELIMITER $$
CREATE PROCEDURE get_account_in_department(
    IN in_dept_name VARCHAR(50)
)
BEGIN
    SELECT 
        a.*
    FROM 
        department d
        JOIN account a 
            ON d.department_id = a.department_id
    WHERE 
        d.department_name = in_dept_name;
END $$
DELIMITER ;
CALL get_account_in_department('Sales');


-- Question 2: Tạo store để in ra số lượng account trong mỗi group.

DROP PROCEDURE IF EXISTS count_acc_in_group()
DELIMITER $$
CREATE PROCEDURE count_acc_in_group()
BEGIN
	SELECT 
		group_id, COUNT(account_id) total_account
	FROM
		group_account
	GROUP BY group_id;
END$$
DELIMITER ;
CALL count_acc_in_group();

-- Question 3: Tạo store để thống kê mỗi type question có bao nhiêu question được tạo trong tháng hiện tại.

DROP PROCEDURE IF EXISTS count_ques_in_month()
DELIMITER $$
CREATE PROCEDURE count_ques_in_month()
BEGIN
	SELECT 
    t.type_id, t.type_name, COUNT(q.question_id)
FROM
    type_question t
        JOIN
    question q ON t.type_id = q.type_id
WHERE
    MONTH(q.create_date) = MONTH(NOW())
GROUP BY t.type_id, t.type_name;
END$$
DELIMITER ;
CALL count_ques_in_month();

-- Question 4: Tạo store để trả ra id của type question có nhiều câu hỏi nhất.

DROP PROCEDURE IF EXISTS get_type_id_most_ques()
DELIMITER $$
CREATE PROCEDURE get_type_id_most_ques(OUT out_type_id INT)
BEGIN
	SELECT 
    type_id INTO out_type_id
FROM
    question
GROUP BY type_id
HAVING COUNT(question_id) = (SELECT 
        COUNT(question_id)
    FROM
        question
    GROUP BY type_id
    LIMIT 1);
END$$
DELIMITER ;
CALL  get_type_id_most_ques();

-- Question 5: Sử dụng store ở question 4 để tìm ra tên của type question.

DROP PROCEDURE IF EXISTS get_type_question_max_name;
DELIMITER $$
CREATE PROCEDURE get_type_question_max_name()
BEGIN
    DECLARE v_type_id INT;

    CALL get_type_id_most_ques(v_type_id);

    SELECT type_name
    FROM type_question
    WHERE type_id = v_type_id;
END $$
DELIMITER ;

-- Question 6: Viết 1 store cho phép người dùng nhập vào 1 chuỗi và trả về group có tên
-- chứa chuỗi của người dùng nhập vào hoặc trả về user có username chứa chuỗi của người dùng nhập vào.

DROP PROCEDURE IF EXISTS search_group_or_user;
DELIMITER $$
CREATE PROCEDURE search_group_or_user(IN in_text VARCHAR(50))
BEGIN
    SELECT *
    FROM `group`
    WHERE group_name LIKE CONCAT('%', in_text, '%')
    
    UNION ALL
    
    SELECT *
    FROM account
    WHERE user_name LIKE CONCAT('%', in_text, '%');
END $$
DELIMITER ;

-- Question 7: Viết 1 store cho phép người dùng nhập vào thông tin fullName, email và trong store sẽ tự động gán: 
-- username sẽ giống email nhưng bỏ phần @..mail đi
-- positionID: sẽ có default là developer
-- departmentID: sẽ được cho vào 1 phòng chờ
-- Sau đó in ra kết quả tạo thành công

DROP PROCEDURE IF EXISTS create_account_auto;
DELIMITER $$
CREATE PROCEDURE create_account_auto(
    IN in_fullname VARCHAR(50),
    IN in_email VARCHAR(50)
)
BEGIN
    DECLARE v_username VARCHAR(50);
    
    SET v_username = SUBSTRING_INDEX(in_email, '@', 1);
    
    INSERT INTO account(full_name, email, user_name, position_id, department_id)
    VALUES (in_fullname, in_email, v_username, 1, 1);

    SELECT 'Tạo tài khoản thành công!' AS message;
END $$
DELIMITER ;

-- Question 8: Viết 1 store cho phép người dùng nhập vào Essay hoặc Multiple-Choice 
-- để thống kê câu hỏi essay hoặc multiple-choice nào có content dài nhất

DROP PROCEDURE IF EXISTS get_longest_question_by_type;
DELIMITER $$
CREATE PROCEDURE get_longest_question_by_type(IN in_type VARCHAR(50))
BEGIN
    SELECT q.*
    FROM question q
    JOIN type_question t ON q.type_id = t.type_id
    WHERE t.type_name = in_type
    ORDER BY CHAR_LENGTH(q.content) DESC
    LIMIT 1;
END $$
DELIMITER ;

-- Question 9: Viết 1 store cho phép người dùng xóa exam dựa vào ID

DROP PROCEDURE IF EXISTS delete_exam_by_id;
DELIMITER $$
CREATE PROCEDURE delete_exam_by_id(IN in_exam_id INT)
BEGIN
    DELETE FROM exam_question WHERE exam_id = in_exam_id;
    DELETE FROM exam WHERE exam_id = in_exam_id;
END $$
DELIMITER ;

-- Question 10: Tìm ra các exam được tạo từ 3 năm trước và xóa các exam đó đi (sử
-- dụng store ở câu 9 để xóa)
-- Sau đó in số lượng record đã remove từ các table liên quan trong khi removing

DROP PROCEDURE IF EXISTS delete_old_exams;
DELIMITER $$
CREATE PROCEDURE delete_old_exams()
BEGIN
    DECLARE removed_exam INT DEFAULT 0;
    DECLARE removed_exam_question INT DEFAULT 0;

    SELECT COUNT(*) INTO removed_exam
    FROM exam
    WHERE YEAR(create_date) = YEAR(CURDATE()) - 3;

    SELECT COUNT(*) INTO removed_exam_question
    FROM exam_question eq
    JOIN exam e ON eq.exam_id = e.exam_id
    WHERE YEAR(e.create_date) = YEAR(CURDATE()) - 3;

    DELETE eq 
    FROM exam_question eq
    JOIN exam e ON eq.exam_id = e.exam_id
    WHERE YEAR(e.create_date) = YEAR(CURDATE()) - 3;
    
    DELETE FROM exam
    WHERE YEAR(create_date) = YEAR(CURDATE()) - 3;

    SELECT removed_exam AS exam_deleted,
           removed_exam_question AS exam_question_deleted;
END $$
DELIMITER ;

-- Question 11: Viết store cho phép người dùng xóa phòng ban bằng cách người dùng nhập vào tên phòng ban và các
--  account thuộc phòng ban đó sẽ được chuyển về phòng ban default là phòng ban chờ việc.

DROP PROCEDURE IF EXISTS delete_department;
DELIMITER $$
CREATE PROCEDURE delete_department(IN in_dept_name VARCHAR(50))
BEGIN
    DECLARE v_dept_id INT;

    SELECT department_id INTO v_dept_id
    FROM department
    WHERE department_name = in_dept_name;

    UPDATE account
    SET department_id = 1
    WHERE department_id = v_dept_id;

    DELETE FROM department
    WHERE department_id = v_dept_id;
END $$
DELIMITER ;

-- Question 12: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong năm nay

DROP PROCEDURE IF EXISTS count_question_month_this_year;
DELIMITER $$
CREATE PROCEDURE count_question_month_this_year()
BEGIN
    SELECT MONTH(create_date) AS month,
           COUNT(question_id) AS total
    FROM question
    WHERE YEAR(create_date) = YEAR(CURDATE())
    GROUP BY MONTH(create_date)
    ORDER BY month;
END $$
DELIMITER ;

-- Question 13: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong 6 tháng gần đây nhất
-- (Nếu tháng nào không có thì sẽ in ra là "không có câu hỏi nào trong tháng")