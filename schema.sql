USE UniRegistration;

-- Disable all constraints
EXEC sp_MSforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all";

-- Drop views
DROP VIEW IF EXISTS mv_StudentCompletedCourses;


-- Drop tables
DROP TABLE IF EXISTS Cart
DROP TABLE IF EXISTS Enrollment;
DROP TABLE IF EXISTS CourseSchedule;
DROP TABLE IF EXISTS CourseSection;
DROP TABLE IF EXISTS Prerequisite;
DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS Classroom;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Instructor;
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS College;

CREATE TABLE College (
    college_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE Department (
    department_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    college_id INT NOT NULL,
    FOREIGN KEY (college_id) REFERENCES College(college_id)
);

CREATE TABLE Instructor (
    instructor_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department_id INT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES Department(department_id)
);

CREATE TABLE Student (
    student_id INT PRIMARY KEY IDENTITY(1000, 1),
    name VARCHAR(100) NOT NULL,
    year INT,
	major_department_id INT NULL,
	FOREIGN KEY (major_department_id) REFERENCES Department(department_id)

);

CREATE TABLE Classroom (
    classroom_id INT PRIMARY KEY IDENTITY(1,1),
    building VARCHAR(1) NOT NULL,
    room_number VARCHAR(3) NOT NULL,
    capacity INT NOT NULL CHECK (capacity > 0),
    room_type VARCHAR(20) NULL CHECK (room_type IN ('Lecture', 'Lab')),
    CONSTRAINT UQ_Classroom UNIQUE (building, room_number)
);

CREATE TABLE Course (
    course_id INT PRIMARY KEY IDENTITY(1,1),
    course_code VARCHAR(10) NOT NULL,
    title VARCHAR(100) NOT NULL,
    department_id INT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES Department(department_id)
);


CREATE TABLE CourseSection (
    section_id INT PRIMARY KEY IDENTITY(1,1),
    course_id INT NOT NULL,
    instructor_id INT NOT NULL,
    term VARCHAR(10) NOT NULL CHECK (term IN ('Fall', 'Winter', 'Spring', 'Summer')),
    year INT NOT NULL CHECK (year >= 2024 AND year <= 2027),
    section_number VARCHAR(5) NOT NULL,
    max_capacity INT NOT NULL CHECK (max_capacity > 0),
    FOREIGN KEY (course_id) REFERENCES Course(course_id),
    FOREIGN KEY (instructor_id) REFERENCES Instructor(instructor_id),
    UNIQUE (course_id, term, year, section_number)
);


CREATE TABLE CourseSchedule (
    schedule_id INT PRIMARY KEY IDENTITY(1,1),
    section_id INT NOT NULL,
    day_of_week VARCHAR(10) NOT NULL CHECK (day_of_week IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday')),
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
	classroom_id INT NULL,
    FOREIGN KEY (section_id) REFERENCES CourseSection(section_id),
	FOREIGN KEY (classroom_id) REFERENCES Classroom(classroom_id),
	CONSTRAINT CHK_ValidTime CHECK (start_time < end_time),
    CONSTRAINT CHK_Duration CHECK (DATEDIFF(MINUTE, start_time, end_time) <= 180) -- Max 3 hours
);


CREATE TABLE Prerequisite (
	prerequisite_id INT PRIMARY KEY IDENTITY(1,1),
    course_id INT NOT NULL,
    prerequisite_course_id INT NOT NULL,
	minimum_grade VARCHAR(2) NULL CHECK (minimum_grade IN ('A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C+', 'D', 'F', NULL)),
	FOREIGN KEY (course_id) REFERENCES Course(course_id),
    FOREIGN KEY (prerequisite_course_id) REFERENCES Course(course_id),
    CONSTRAINT CHK_NoSelfPrerequisite CHECK (course_id <> prerequisite_course_id), --course_id is NOT EQUAL to prerequisite_course_id
    CONSTRAINT UQ_Prerequisite UNIQUE (course_id, prerequisite_course_id) -- Prevents duplicate prerequisite relationships between the same two courses.
);


CREATE TABLE Enrollment (
    enrollment_id INT PRIMARY KEY IDENTITY(1,1),
    student_id INT NOT NULL,
	course_id INT NOT NULL,
    section_id INT NOT NULL,
	status VARCHAR(20) DEFAULT 'Enrolled' CHECK (status IN ('Enrolled', 'Completed', 'Dropped', 'Withdrawn')),
    grade VARCHAR(2) NULL CHECK (grade IN ('A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C+', 'D', 'F', 'I', 'W')), -- I=Incomplete, W=Withdrawn
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id),
    FOREIGN KEY (section_id) REFERENCES CourseSection(section_id),
    CONSTRAINT UQ_Enrollment UNIQUE (student_id, section_id)
);

CREATE TABLE Cart (
    cart_id INT PRIMARY KEY IDENTITY(1,1),
    student_id INT NOT NULL,
	course_id INT NOT NULL,
    section_id INT NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id),
    FOREIGN KEY (section_id) REFERENCES CourseSection(section_id),
    CONSTRAINT UQ_CartItem UNIQUE (student_id, section_id)
);


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

/******** MATERIALIZED VIEWS ***********/
/* 
MV 3: Completed courses with grades (for prerequisites)
*/
CREATE VIEW mv_StudentCompletedCourses
WITH SCHEMABINDING
AS
SELECT 
    e.enrollment_id, -- Include primary key for uniqueness
    e.student_id,
    e.course_id,
    c.course_code,
    c.title,
    e.grade,
    e.section_id,
    -- Must include all GROUP BY columns in SELECT
    cs.term,
    cs.year
FROM dbo.Enrollment e
INNER JOIN dbo.Course c ON e.course_id = c.course_id
INNER JOIN dbo.CourseSection cs ON e.section_id = cs.section_id
WHERE e.status = 'Completed'
    AND e.grade IS NOT NULL
    AND e.grade NOT IN ('I', 'W');
GO

-- Create unique clustered index to materialize it
CREATE UNIQUE CLUSTERED INDEX IX_mv_StudentCompletedCourses 
ON mv_StudentCompletedCourses (enrollment_id);
GO

-- Add non-clustered indexes for common queries
CREATE NONCLUSTERED INDEX IX_mv_StudentCompletedCourses_Student 
ON mv_StudentCompletedCourses (student_id, course_id);
GO

CREATE NONCLUSTERED INDEX IX_mv_StudentCompletedCourses_Grade 
ON mv_StudentCompletedCourses (grade, student_id);
GO