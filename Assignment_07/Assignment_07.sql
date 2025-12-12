
-- Question 1: Tạo trigger không cho phép người dùng nhập vào Group có ngày tạo trước 1 năm trước.

DROP TRIGGER IF EXISTS trg_group_date;
DELIMITER $$
CREATE TRIGGER trg_group_date
BEFORE INSERT ON `group`
FOR EACH ROW
BEGIN
    IF NEW.create_date < DATE_SUB(CURDATE(), INTERVAL 1 YEAR) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Khống được nhập vào Group tạo 1 năm trước';
    END IF;
END$$
DELIMITER ;



-- Question 2: Tạo trigger Không cho phép người dùng thêm bất kỳ user nào vào
-- department "Sale" nữa, khi thêm thì hiện ra thông báo "Department
-- "Sale" cannot add more user"

DROP TRIGGER IF EXISTS trg_no_add_sale;
DELIMITER $$
CREATE TRIGGER trg_no_add_sale
BEFORE INSERT ON account
FOR EACH ROW
BEGIN
    IF (SELECT department_name FROM department 
        WHERE department_id = NEW.department_id) = 'Sale' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Department "Sale" cannot add more user';
    END IF;
END$$
DELIMITER ;

-- Question 3: Cấu hình 1 group có nhiều nhất là 5 user

DROP TRIGGER IF EXISTS trg_group_max_user;
DELIMITER $$
CREATE TRIGGER trg_group_max_user
BEFORE INSERT ON group_account
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM group_account 
        WHERE group_id = NEW.group_id) >= 5 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Một nhóm chỉ được tối đa 5 user.';
    END IF;
END$$
DELIMITER ;

-- Question 4: Cấu hình 1 bài thi có nhiều nhất là 10 Question

DROP TRIGGER IF EXISTS trg_exam_max_question;
DELIMITER $$
CREATE TRIGGER trg_exam_max_question
BEFORE INSERT ON exam_question
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM exam_question 
        WHERE exam_id = NEW.exam_id) >= 10 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Một bài thi chỉ được tối đa 10 câu hỏi.';
    END IF;
END$$
DELIMITER ;

-- Question 5: Tạo trigger không cho phép người dùng xóa tài khoản có email là
-- admin@gmail.com (đây là tài khoản admin, không cho phép user xóa), 
-- còn lại các tài khoản khác thì sẽ cho phép xóa và sẽ xóa tất cả các thông tin liên quan tới user đó

DROP TRIGGER IF EXISTS trg_no_delete_admin;
DELIMITER $$
CREATE TRIGGER trg_no_delete_admin
BEFORE DELETE ON account
FOR EACH ROW
BEGIN
    IF OLD.email = 'admin@gmail.com' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Không được phép xóa tài khoản admin.';
    END IF;
END$$
DELIMITER ;

-- Question 6: Không sử dụng cấu hình default cho field DepartmentID của table
-- Account, hãy tạo trigger cho phép người dùng khi tạo account không điền
-- vào departmentID thì sẽ được phân vào phòng ban "waiting Department"

DROP TRIGGER IF EXISTS trg_default_department;
DELIMITER $$
CREATE TRIGGER trg_default_department
BEFORE INSERT ON account
FOR EACH ROW
BEGIN
    IF NEW.department_id IS NULL THEN
        SET NEW.department_id = 
            (SELECT department_id 
             FROM department 
             WHERE department_name = 'waiting Department');
    END IF;
END$$
DELIMITER ;

-- Question 7: Cấu hình 1 bài thi chỉ cho phép user tạo tối đa 4 answers cho mỗi
-- question, trong đó có tối đa 2 đáp án đúng.
-- Question 8: Viết trigger sửa lại dữ liệu cho đúng:
-- Nếu người dùng nhập vào gender của account là nam, nữ, chưa xác định
-- Thì sẽ đổi lại thành M, F, U cho giống với cấu hình ở database
-- Question 9: Viết trigger không cho phép người dùng xóa bài thi mới tạo được 2 ngày

DROP TRIGGER IF EXISTS trg_no_delete_exam_2days;
DELIMITER $$
CREATE TRIGGER trg_no_delete_exam_2days
BEFORE DELETE ON exam
FOR EACH ROW
BEGIN
    IF OLD.create_date >= DATE_SUB(NOW(), INTERVAL 2 DAY) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Không thể xóa bài thi mới tạo trong 2 ngày.';
    END IF;
END$$
DELIMITER ;

-- Question 10: Viết trigger chỉ cho phép người dùng chỉ được update, delete các
-- question khi question đó chưa nằm trong exam nào

DROP TRIGGER IF EXISTS trg_question_no_update;
DELIMITER $$
CREATE TRIGGER trg_question_no_update
BEFORE UPDATE ON question
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT * FROM exam_question 
               WHERE question_id = OLD.question_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Câu hỏi đã nằm trong bài thi — không được phép sửa.';
    END IF;
END$$
DELIMITER ;

-- Question 12: Lấy ra thông tin exam trong đó:
-- Duration <= 30 thì sẽ đổi thành giá trị "Short time"
-- 30 < Duration <= 60 thì sẽ đổi thành giá trị "Medium time"
-- Duration > 60 thì sẽ đổi thành giá trị "Long time"

SELECT exam_id,
       title,
       CASE 
         WHEN duration <= 30 THEN 'Short time'
         WHEN duration <= 60 THEN 'Medium time'
         ELSE 'Long time'
       END AS duration_type
FROM exam;

-- Question 13: Thống kê số account trong mỗi group và in ra thêm 1 column nữa có tên
-- là the_number_user_amount và mang giá trị được quy định như sau:
-- Nếu số lượng user trong group =< 5 thì sẽ có giá trị là few
-- Nếu số lượng user trong group <= 20 và > 5 thì sẽ có giá trị là normal
-- Nếu số lượng user trong group > 20 thì sẽ có giá trị là higher

SELECT 
    g.group_id,
    g.group_name,
    COUNT(ga.account_id) AS total_user,
    CASE 
        WHEN COUNT(ga.account_id) <= 5 THEN 'few'
        WHEN COUNT(ga.account_id) <= 20 THEN 'normal'
        ELSE 'higher'
    END AS the_number_user_amount
FROM `group` g
LEFT JOIN group_account ga ON g.group_id = ga.group_id
GROUP BY g.group_id;

-- Question 14: Thống kê số mỗi phòng ban có bao nhiêu user, nếu phòng ban nào
-- không có user thì sẽ thay đổi giá trị 0 thành "Không có User"

SELECT 
    d.department_name,
    CASE 
        WHEN COUNT(a.account_id) = 0 THEN 'Không có User'
        ELSE COUNT(a.account_id)
    END AS total_user
FROM department d
LEFT JOIN account a ON d.department_id = a.department_id
GROUP BY d.department_id;
