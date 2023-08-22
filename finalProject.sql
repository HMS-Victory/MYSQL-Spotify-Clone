-- I think we will count the number of people in a specefied program
-- using a query

CREATE DATABASE school_db;
USE school_db;

-- create table programs
CREATE TABLE programs(
	id INT AUTO_INCREMENT PRIMARY KEY,
    _name VARCHAR(150)
);
-- assign values to table programs
INSERT INTO programs(_name)
	VALUES('Software Development'),
    ('Computer basics');
   
   
-- create table courses
CREATE TABLE courses(
	id INT AUTO_INCREMENT PRIMARY KEY,
    _name VARCHAR(150),
    course_description VARCHAR(255),
    number_in_program INT,
    program_id INT NOT NULL,
    FOREIGN KEY(program_id) REFERENCES programs(id)
);
-- assign values to courses
INSERT INTO courses(_name, course_description, program_id)
	VALUES('Robotics', 'Lorem Ipsum',1 ),
		('Using Excell', 'Lorem Ipsum', 2);
 UPDATE courses SET number_in_program=2;


-- create table staff
CREATE TABLE staff(
	id INT PRIMARY KEY AUTO_INCREMENT,
    _name VARCHAR(50) NOT NULL,
    age INT,
    program_id INT NOT NULL, 
    course_id INT NOT NULL,
    FOREIGN KEY(program_id) REFERENCES programs(id),
    FOREIGN KEY(course_id) REFERENCES courses(id)
);
-- assign values to staff
INSERT INTO staff(_name, age, program_id, course_id) 
	VALUES('bob', '15', '1', '1'), 
    ('jill', '19', '1', '2'), 
    ('John', '27', '2', '1'), 
    ('Jacob', '31', '2', '2');


-- create table student
CREATE TABLE student(
	id INT AUTO_INCREMENT PRIMARY KEY,
    _name VARCHAR(50) NOT NULL,
    age INT NOT NULL,
    course_current INT,
    program_major INT NOT NULL,
    FOREIGN KEY(course_current) REFERENCES courses(id),
    FOREIGN KEY(program_major) REFERENCES programs(id)
);
-- assign values to student
INSERT INTO student(_name, age, course_current, program_major)
	VALUES('Harvey', 16, 1,1), 
    ('John', 15, 2,1), 
    ('George', 17, 1,2), 
    ('Jacob', 19, 2,2);


-- create table certificate
CREATE TABLE certificate(
	id INT AUTO_INCREMENT PRIMARY KEY,
    major_name INT,
    program_courses VARCHAR(1000),
    -- SELECT COUNT(*) FROM students
    students_enrolled INT DEFAULT 0,
    -- SELECT COUNT(*) WHERE ISNULL(course_current) FROM students
    students_graduated INT DEFAULT 0,
    FOREIGN KEY(major_name) REFERENCES programs(id)
);
-- assign values to certificate
INSERT INTO certificate(major_name)
	VALUES(2),(1);
-- display major
SELECT _name FROM certificate LEFT JOIN programs ON certificate.major_name=programs.id GROUP BY _name;
-- display all available courses in the program
SELECT major_name AS program_name, _name AS course_name FROM certificate LEFT JOIN courses ON certificate.major_name=courses.program_id;
-- display the number of students enrolled in a program
SELECT COUNT(*) AS enrolled FROM student WHERE course_enrolled!=0;
-- select the graduates
SELECT COUNT(*) AS graduates FROM student WHERE course_enrolled=0;

-- program_courses
-- updates based off of the courses table
UPDATE certificate SET program_courses=CONCAT(program_courses, (SELECT _name FROM courses WHERE certificate.major_name=courses.program_id));
-- students enrolled
UPDATE certificate SET students_enrolled=(SELECT COUNT(*) AS enrolled FROM student WHERE course_enrolled!=0);
-- students graduated
UPDATE certificate SET students_graduated=(SELECT COUNT(*) AS graduates FROM student WHERE course_enrolled=0);


-- CRUD operations--------------------------------------------

-- Create 
-- adding a new program and new courses for it
-- we could also add teachers.
INSERT INTO programs(_name) VALUES('welding');
INSERT INTO courses(_name, course_description, program_id)
	VALUES('cleaning the seams', 'lorem ipsum', 3), ('More heat', 'lorem ipsum', 3);
INSERT INTO certificate(major_name) VALUES(3);
-- maybe add some students who enrolled in the new program
INSERT INTO student(_name, age, course_current, program_major)
	VALUES('Franky', 21, 3, 3), ('Dallas', 18, 4,3);
-- and a teacher for the new program
INSERT INTO staff(_name, age, program_id, course_id)
	VALUES('Leopold', 35, 3, 3), ('Cold Turkey', 37, 3,4);
    
-- Read
	-- these are the most useful tables to read
    -- since there were no specific scenarios specefied
    -- I am going the simple route with the CRUD operations
    -- and just finding ways to show off the functionality
    -- of the DB.
	SELECT * FROM staff;
    SELECT * FROM student;
    SELECT * FROM certificate;
-- Update

-- the certificate is the most important to update because it 100%
-- runs on information from the other tables
-- and would be the most likely to be consistently updated
    UPDATE 
		certificate,
		(SELECT program_id, GROUP_CONCAT(_name ORDER BY _name SEPARATOR ',') AS 'names'
			 FROM courses GROUP BY program_id) AS course_lookup
		SET certificate.program_courses = course_lookup.names
		WHERE course_lookup.program_id = certificate.major_name;
    
    UPDATE student SET _name='Johan' WHERE _name='John';
    UPDATE staff SET _name='Rough and ready' WHERE _name='John';
-- Delete

-- just deleteing everything.
	DELETE FROM student WHERE id>4;
	DELETE FROM certificate;
    DELETE FROM student;
    DELETE FROM staff;
    DELETE FROM programs;
    DELETE FROM courses;
    DROP TABLE certificate;
    DROP TABLE student;
    DROP TABLE staff;
    DROP TABLE programs;
    DROP TABLE courses;





































