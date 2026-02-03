USE UniRegistration;
GO

-- Drop view first if exists
IF OBJECT_ID('dbo.vw_StudentCourseSummary', 'V') IS NOT NULL
    DROP VIEW dbo.vw_StudentCourseSummary;
GO

-- Drop tables
DROP TABLE IF EXISTS Enrollment;
DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS Instructor;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS Department;
GO

-- Create tables
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
-- Drop stored procedure
IF OBJECT_ID('RegisterStudent', 'P') IS NOT NULL
    DROP PROCEDURE RegisterStudent;
CREATE TABLE Enrollment (

-- Drop tables (order matters)
DROP TABLE IF EXISTS Department;
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

-- ===============================================
-- MATERIALIZED VIEW (Indexed View)
-- Student Course Summary

WITH SCHEMABINDING
AS
SELECT
    s.student_id,
    s.name AS student_name,
    s.email,
    c.course_id,
    c.name AS course_name,

    d.name AS department_name
FROM dbo.Student AS s
INNER JOIN dbo.Enrollment AS e
    ON s.student_id = e.student_id
INNER JOIN dbo.Course AS c
    ON e.course_id = c.course_id
INNER JOIN dbo.Instructor AS i
    ON c.instructor_id = i.instructor_id
INNER JOIN dbo.Department AS d
    ON c.dept_id = d.dept_id;
GO

-- Materialize it
CREATE UNIQUE CLUSTERED INDEX IX_vw_StudentCourseSummary

 