-- Question 1: Tạo view có chứa danh sách nhân viên thuộc phòng ban sale

CREATE VIEW v_employee_sale AS
    SELECT 
        a.*
    FROM
        account a
            JOIN
        department d ON a.department_id = d.department_id
    WHERE
        department_name = 'Sales';
        
-- Question 2: Tạo view có chứa thông tin các account tham gia vào nhiều group nhất

CREATE VIEW v_account_most_groups AS
    SELECT 
        a.*
    FROM
        account a
            JOIN
        group_account g ON a.account_id = g.account_id
    GROUP BY a.account_id
    HAVING COUNT(g.group_id) = (SELECT 
            MAX(cg)
        FROM
            (SELECT 
                COUNT(g.group_id) AS cg
            FROM
                account a
            JOIN group_account g ON a.account_id = g.account_id
            GROUP BY a.account_id) AS t);
            
-- Question 3: Tạo view có chứa câu hỏi có những content quá dài (content quá 300 từ được coi là quá dài) và xóa nó đi

CREATE VIEW v_content_question_over_300 AS
    SELECT 
        *
    FROM
        question
    WHERE
        CHAR_LENGTH(content) > 300;
        
DROP VIEW v_content_question_over_300;

-- Question 4: Tạo view có chứa danh sách các phòng ban có nhiều nhân viên nhất

CREATE VIEW v_department_most_employee AS
    SELECT 
        d.*
    FROM
        account a
            JOIN
        department d ON a.department_id = d.department_id
    GROUP BY d.department_id
    HAVING COUNT(a.account_id) = (SELECT 
            MAX(ca)
        FROM
            (SELECT 
                COUNT(a.account_id) ca
            FROM
                account a
            JOIN department d ON a.department_id = d.department_id
            GROUP BY d.department_id) AS t);
            
-- Question 5: Tạo view có chứa tất các các câu hỏi do user họ Nguyễn.

CREATE VIEW v_user_nguyen AS
    SELECT 
        q.*, a.full_name
    FROM
        question q
            JOIN
        account a ON q.creator_id = a.account_id
    WHERE
        a.full_name LIKE 'Nguyễn%';
