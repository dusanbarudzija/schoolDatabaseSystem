USE UniRegistration;

DROP TABLE IF EXISTS Enrollment;
DROP TABLE IF EXISTS CourseSchedule;
DROP TABLE IF EXISTS CourseSection;
DROP TABLE IF EXISTS Prerequisite;
DROP TABLE IF EXISTS Course;
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
    student_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    year INT
);

CREATE TABLE Course (
    course_id INT PRIMARY KEY,
    course_code VARCHAR(10) NOT NULL,
    title VARCHAR(100) NOT NULL,
    department_id INT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES Department(department_id)
);


CREATE TABLE CourseSection (
    section_id INT PRIMARY KEY,
    course_id INT NOT NULL,
    instructor_id INT NOT NULL,
    term VARCHAR(10) NOT NULL,
    year INT NOT NULL,
    section_number VARCHAR(5) NOT NULL,
    max_capacity INT NOT NULL,
    FOREIGN KEY (course_id) REFERENCES Course(course_id),
    FOREIGN KEY (instructor_id) REFERENCES Instructor(instructor_id),
    UNIQUE (course_id, term, year, section_number)
);


CREATE TABLE CourseSchedule (
    schedule_id INT PRIMARY KEY,
    section_id INT NOT NULL,
    day_of_week VARCHAR(10) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    FOREIGN KEY (section_id) REFERENCES CourseSection(section_id)
);


CREATE TABLE Prerequisite (
    course_id INT NOT NULL,
    prerequisite_course_id INT NOT NULL,
    PRIMARY KEY (course_id, prerequisite_course_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id),
    FOREIGN KEY (prerequisite_course_id) REFERENCES Course(course_id)
);


CREATE TABLE Enrollment (
    enrollment_id INT PRIMARY KEY,
    student_id INT NOT NULL,
    section_id INT NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (section_id) REFERENCES CourseSection(section_id),
    UNIQUE (student_id, section_id)
);

-- Materialized view for Sections
CREATE VIEW vw_CourseAvailability
WITH SCHEMABINDING  -- Required for indexed views
AS
SELECT 
    cs.section_id,
    cs.course_id,
    cs.instructor_id,
    cs.term,
    cs.year,
    cs.section_number,
    cs.max_capacity,
    COUNT_BIG(e.enrollment_id) AS enrolled_count, 
    cs.max_capacity - COUNT_BIG(e.enrollment_id) AS seats_remaining
FROM dbo.CourseSection cs 
LEFT JOIN dbo.Enrollment e ON cs.section_id = e.section_id
GROUP BY 
    cs.section_id,
    cs.course_id,
    cs.instructor_id,
    cs.term,
    cs.year,
    cs.section_number,
    cs.max_capacity;
GO