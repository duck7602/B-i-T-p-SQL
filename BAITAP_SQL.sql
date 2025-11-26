CREATE DATABASE testing_system;

USE testing_system;

CREATE TABLE department(
	department_id	INT AUTO_INCREMENT PRIMARY KEY,
	department_name	VARCHAR(50)
);

CREATE TABLE position_1(
	position_id   INT AUTO_INCREMENT PRIMARY KEY,
	position_name VARCHAR(50)
);

CREATE TABLE account(
	account_id 		INT AUTO_INCREMENT PRIMARY KEY,
	email 			VARCHAR(50),
	user_name 		VARCHAR(50),
	full_name 		VARCHAR(50),
	department_id 	INT,
	position_id 	INT,
	create_date 	DATE
);
CREATE TABLE group_1(
	group_id 	INT AUTO_INCREMENT PRIMARY KEY,
	group_name 	VARCHAR(50),
	creator_id 	INT,
	create_date DATE
);

CREATE TABLE group_account(
	group_id 	INT AUTO_INCREMENT PRIMARY KEY,
	account_id 	INT,
	join_date 	DATE
);

CREATE TABLE type_question(
	type_id 	INT AUTO_INCREMENT PRIMARY KEY,
	type_name 	VARCHAR(50)
);

CREATE TABLE category_question(
	category_id 	INT AUTO_INCREMENT PRIMARY KEY,
	category_name 	VARCHAR(50)
);

CREATE TABLE question(
	question_id INT AUTO_INCREMENT PRIMARY KEY,
	content 	VARCHAR(50),
	category_id INT,
	type_id 	INT,
	creator_id 	INT,
	create_date DATE
);

CREATE TABLE answer(
	answer_id 	INT AUTO_INCREMENT PRIMARY KEY,
	content 	VARCHAR(50),
	question_id INT,
	is_correct 	ENUM('correct', 'incorrect')
);

CREATE TABLE exam(
	exam_id 	INT AUTO_INCREMENT PRIMARY KEY,
	code_1 		INT,
	title 		VARCHAR(50),
	category_id INT,
	duration 	INT,
	creator_id 	INT,
	create_date DATE
);

CREATE TABLE exam_question(
	exam_id 	INT AUTO_INCREMENT PRIMARY KEY,
	question_id INT
);
