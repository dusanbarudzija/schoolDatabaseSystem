USE UniRegistration

-- Drop stored procedure
IF OBJECT_ID('RegisterStudent', 'P') IS NOT NULL
    DROP PROCEDURE RegisterStudent;


-- Drop tables (order matters)
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS Instructor;
DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Enrollment;

CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE Instructor (
    instructor_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dept_id INT NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

CREATE TABLE Course (
    course_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dept_id INT NOT NULL,
    instructor_id INT NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id),
    FOREIGN KEY (instructor_id) REFERENCES Instructor(instructor_id)
);

CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Enrollment (
    enrollment_id INT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id),
    UNIQUE(student_id, course_id)
);

 