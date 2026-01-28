USE UniRegistration;
GO

-- Drop stored procedure
IF OBJECT_ID('RegisterStudent', 'P') IS NOT NULL
    DROP PROCEDURE RegisterStudent;
GO

-- Drop tables (children first, parents last)
DROP TABLE IF EXISTS Enrollment;
DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS Instructor;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Department;
GO

-- Create tables (parents first, children last)

CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);
GO

CREATE TABLE Instructor (
    instructor_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dept_id INT NOT NULL,
    CONSTRAINT FK_Instructor_Department
        FOREIGN KEY (dept_id)
        REFERENCES Department(dept_id)
        ON DELETE CASCADE
);

GO

CREATE TABLE Course (
    course_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dept_id INT NOT NULL,
    instructor_id INT NOT NULL,
    CONSTRAINT FK_Course_Department
        FOREIGN KEY (dept_id)
        REFERENCES Department(dept_id)
        ON DELETE CASCADE,
    CONSTRAINT FK_Course_Instructor
        FOREIGN KEY (instructor_id)
        REFERENCES Instructor(instructor_id)
);

GO

CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);
GO

CREATE TABLE Enrollment (
    enrollment_id INT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    CONSTRAINT FK_Enrollment_Student
        FOREIGN KEY (student_id)
        REFERENCES Student(student_id)
        ON DELETE CASCADE,
    CONSTRAINT FK_Enrollment_Course
        FOREIGN KEY (course_id)
        REFERENCES Course(course_id)
        ON DELETE CASCADE,
    CONSTRAINT UQ_Student_Course
        UNIQUE (student_id, course_id)
);

GO
