CREATE DATABASE testing_system;

USE testing_system;

CREATE TABLE department (
    department_id 	INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL
);

CREATE TABLE position (
    position_id 	INT AUTO_INCREMENT PRIMARY KEY,
    position_name 	ENUM('Dev', 'Test', 'Scrum Master', 'PM') NOT NULL
);

CREATE TABLE account (
    account_id 		INT AUTO_INCREMENT PRIMARY KEY,
    email 			VARCHAR(50) NOT NULL,
    user_name 		VARCHAR(50) NOT NULL,
    full_name 		VARCHAR(50) NOT NULL,
    department_id 	INT NOT NULL,
    position_id 	INT NOT NULL,
    create_date 	DATE NOT NULL,
    FOREIGN KEY (department_id)
        REFERENCES department (department_id),
    FOREIGN KEY (position_id)
        REFERENCES position (position_id)
);
CREATE TABLE `group` (
    group_id 	INT AUTO_INCREMENT PRIMARY KEY,
    group_name 	VARCHAR(50) NOT NULL,
    creator_id 	INT NOT NULL,
    create_date DATE NOT NULL,
    FOREIGN KEY (creator_id)
        REFERENCES account (account_id)
);

CREATE TABLE group_account (
    group_id 	INT NOT NULL,
    account_id 	INT NOT NULL,
    join_date	DATE NOT NULL,
	PRIMARY KEY (group_id, account_id),
    FOREIGN KEY (group_id)
        REFERENCES `group` (group_id),
    FOREIGN KEY (account_id)
        REFERENCES account (account_id)
);

CREATE TABLE type_question (
    type_id 	INT AUTO_INCREMENT PRIMARY KEY,
    type_name 	ENUM('Essay', 'Multiple-Choice') NOT NULL
);

CREATE TABLE category_question (
    category_id 	INT AUTO_INCREMENT PRIMARY KEY,
    category_name 	VARCHAR(50) NOT NULL
);

CREATE TABLE question (
    question_id INT AUTO_INCREMENT PRIMARY KEY,
    content 	TEXT NOT NULL,
    category_id INT NOT NULL,
    type_id 	INT NOT NULL,
    creator_id 	INT NOT NULL,
    create_date DATE NOT NULL,
    FOREIGN KEY (category_id)
        REFERENCES category_question (category_id),
    FOREIGN KEY (type_id)
        REFERENCES type_question (type_id),
    FOREIGN KEY (creator_id)
        REFERENCES account (account_id)
);

CREATE TABLE answer (
    answer_id 	INT AUTO_INCREMENT PRIMARY KEY,
    content 	TEXT NOT NULL,
    question_id INT NOT NULL,
    is_correct 	BOOLEAN NOT NULL,
    FOREIGN KEY (question_id)
        REFERENCES question (question_id)
);

CREATE TABLE exam (
    exam_id 	INT AUTO_INCREMENT PRIMARY KEY,
    code 		VARCHAR(50) NOT NULL,
    title 		VARCHAR(50) NOT NULL,
    category_id INT NOT NULL,
    duration 	INT NOT NULL,
    creator_id 	INT NOT NULL,
    create_date DATE NOT NULL,
    FOREIGN KEY (category_id)
        REFERENCES category_question (category_id),
    FOREIGN KEY (creator_id)
        REFERENCES account (account_id)
);

CREATE TABLE exam_question (
    exam_id 	INT NOT NULL,
    question_id INT NOT NULL,
    PRIMARY KEY (exam_id, question_id),
    FOREIGN KEY (exam_id)
        REFERENCES exam (exam_id),
    FOREIGN KEY (question_id)
        REFERENCES question (question_id)
);

INSERT INTO department (department_id, department_name) 
VALUE	(1, 'Marketting'),
		(2, 'R&D'),
		(3, 'HR'),
		(4,	N'Kế Toán'),
		(5,	N'Thư Kí');

INSERT INTO position (position_id, position_name)
VALUE	(1, 'Dev'),
		(2, 'Test'),
        (3, 'Scrum Master'),
        (4, 'PM'),
        (5, 'Dev');
        
INSERT INTO account (account_id, email, user_name, full_name, department_id, position_id, create_date)
VALUE 	(1, 'duc@gmail.com', 'Duc', 'Nguyen Ba Minh Duc', 1, 1, '2025-07-06'),
		(2, 'tai@gmail.com', 'Tai', 'Nguyen Ba Minh Tai', 2, 2, '2025-07-08'),
        (3, 'tam@gamil.com', 'Tam', 'Nguyen My Minh Tam', 3, 3, '2021-09-03'),
        (4, 'a@gmail.com', 'A', 'Nguyen Van A', 4, 4, '2024-09-09'),
        (5, 'b@gmail.com', 'B', 'Nguyen Van B', 5, 5, '2003-02-04');

INSERT INTO `group` (group_id, group_name, creator_id, create_date)
VALUE	(1, 'group1', 1, '2025-07-06'),
		(2,'group2', 2, '2025-07-04'),
		(3,'group3', 3, '2025-07-08'),
        (4,'group4', 4, '2025-07-01'),
        (5,'group5', 5, '2025-07-02');

INSERT INTO group_account (group_id, account_id, join_date)
VALUE	(1, 1, '2021-07-06'),
		(2, 2, '2021-07-04'),
		(3, 3, '2022-07-08'),
        (4, 4, '2023-07-01'),
        (5, 5, '2021-07-02');

INSERT INTO type_question (type_id, type_name)
VALUE	(1, 'Essay'),
		(2, 'Essay'),
        (3, 'Multiple-Choice'),
        (4, 'Multiple-Choice'),
        (5, 'Essay');

INSERT INTO category_question (category_id , category_name)
VALUE	(1, 'Java'),
		(2, '.NET'),
        (3, 'SQL'),
        (4, 'Postman'),
        (5, 'Ruby');

INSERT INTO question (question_id, content, category_id, type_id, creator_id, create_date)
VALUE	(1, 'content 1', 1, 1, 1, '2021-07-02'),
		(2, 'content 2', 2, 2, 2, '2022-07-02'),
        (3, 'content 3', 3, 3, 3, '2023-07-02'),
        (4, 'content 4', 4, 4, 4, '2024-07-02'),
        (5, 'content 5', 5, 5, 5, '2025-07-02');

INSERT INTO answer (answer_id, content, question_id, is_correct)
VALUES	(1, 'content 1', 1, TRUE),
		(2, 'content 2', 2, TRUE),
        (3, 'content 3', 3, FALSE),
        (4, 'content 4', 4, TRUE),
        (5, 'content 5', 5, FALSE);

INSERT INTO exam (exam_id, code, title, category_id, duration, creator_id, create_date)
VALUES	(1, 1, 'title 1', 1, 60, 1, '2025-07-02'),
		(2, 2, 'title 2', 2, 60, 1, '2025-07-02'),
        (3, 3, 'title 3', 3, 60, 1, '2025-07-02'),
        (4, 4, 'title 4', 4, 60, 1, '2025-07-02'),
        (5, 5, 'title 5', 5, 60, 1, '2025-07-02');

INSERT INTO exam_question (exam_id, question_id)
VALUES	(1, 1),
		(2, 2),
        (3, 3),
        (4, 4),
        (5, 5);
		

