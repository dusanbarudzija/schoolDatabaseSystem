USE UniRegistration;

-- ============================================
-- DROP EXISTING OBJECTS (correct order)
-- ============================================
DROP VIEW IF EXISTS vw_CourseSectionAvailability;
DROP VIEW IF EXISTS vw_SectionEnrollmentCount;
DROP VIEW IF EXISTS vw_StudentCartDetails;
DROP TABLE IF EXISTS Cart;
DROP TABLE IF EXISTS Enrollment;
DROP TABLE IF EXISTS CourseSchedule;
DROP TABLE IF EXISTS CourseSection;
DROP TABLE IF EXISTS Prerequisite;
DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Instructor;
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS College;

-- ============================================
-- CREATE TABLES
-- ============================================

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

CREATE TABLE Cart (
    cart_id INT IDENTITY PRIMARY KEY,
    student_id INT NOT NULL,
    section_id INT NOT NULL,
    UNIQUE(student_id, section_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (section_id) REFERENCES CourseSection(section_id)
);

-- ============================================
-- INDEXES FOR PERFORMANCE
-- ============================================

-- Foreign key indexes
CREATE INDEX IX_Department_College ON Department(college_id);
CREATE INDEX IX_Instructor_Department ON Instructor(department_id);
CREATE INDEX IX_Course_Department ON Course(department_id);
CREATE INDEX IX_CourseSection_Course ON CourseSection(course_id);
CREATE INDEX IX_CourseSection_Instructor ON CourseSection(instructor_id);
CREATE INDEX IX_CourseSchedule_Section ON CourseSchedule(section_id);
CREATE INDEX IX_Enrollment_Student ON Enrollment(student_id);
CREATE INDEX IX_Enrollment_Section ON Enrollment(section_id);
CREATE INDEX IX_Cart_Student ON Cart(student_id);
CREATE INDEX IX_Cart_Section ON Cart(section_id);

-- Composite indexes for common queries
CREATE INDEX IX_CourseSection_TermYear ON CourseSection(term, year);
CREATE INDEX IX_CourseSchedule_DayTime ON CourseSchedule(day_of_week, start_time, end_time);
GO

-- ============================================
-- INDEXED VIEWS (SQL Server Materialized Views)
-- ============================================

-- Indexed View 1: Section Enrollment Count
CREATE VIEW vw_SectionEnrollmentCount
WITH SCHEMABINDING
AS
SELECT 
    section_id,
    COUNT_BIG(*) as enrolled_count
FROM dbo.Enrollment
GROUP BY section_id;
GO

CREATE UNIQUE CLUSTERED INDEX IX_SectionEnrollmentCount 
ON vw_SectionEnrollmentCount(section_id);
GO

CREATE NONCLUSTERED INDEX IX_SectionEnrollmentCount_Count 
ON vw_SectionEnrollmentCount(enrolled_count);
GO

-- Indexed View 2: Student Cart Details
CREATE VIEW vw_StudentCartDetails
WITH SCHEMABINDING
AS
SELECT 
    ct.cart_id,
    ct.student_id,
    ct.section_id,
    cs.course_id,
    cs.instructor_id,
    cs.section_number,
    cs.term,
    cs.year,
    cs.max_capacity,
    COUNT_BIG(*) as row_count
FROM dbo.Cart ct
INNER JOIN dbo.CourseSection cs ON ct.section_id = cs.section_id
GROUP BY 
    ct.cart_id,
    ct.student_id,
    ct.section_id,
    cs.course_id,
    cs.instructor_id,
    cs.section_number,
    cs.term,
    cs.year,
    cs.max_capacity;
GO

CREATE UNIQUE CLUSTERED INDEX IX_StudentCartDetails_Clustered 
ON vw_StudentCartDetails(cart_id);
GO

CREATE NONCLUSTERED INDEX IX_StudentCartDetails_Student 
ON vw_StudentCartDetails(student_id, section_id);
GO

-- Indexed View 3: Course Section Availability
CREATE VIEW vw_CourseSectionAvailability
WITH SCHEMABINDING
AS
SELECT 
    cs.section_id,
    cs.course_id,
    cs.instructor_id,
    cs.term,
    cs.year,
    cs.section_number,
    cs.max_capacity,
    ISNULL(e.enrolled_count, 0) as enrolled_count,
    cs.max_capacity - ISNULL(e.enrolled_count, 0) as available_seats
FROM dbo.CourseSection cs
LEFT JOIN (
    SELECT section_id, COUNT_BIG(*) as enrolled_count
    FROM dbo.Enrollment
    GROUP BY section_id
) e ON cs.section_id = e.section_id;
GO

CREATE UNIQUE CLUSTERED INDEX IX_CourseSectionAvailability 
ON vw_CourseSectionAvailability(section_id);
GO

CREATE NONCLUSTERED INDEX IX_CourseSectionAvailability_Available 
ON vw_CourseSectionAvailability(available_seats) 
WHERE available_seats > 0;
GO

CREATE NONCLUSTERED INDEX IX_CourseSectionAvailability_TermYear 
ON vw_CourseSectionAvailability(term, year);
GO