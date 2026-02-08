-- ============================================
-- INSERT SAMPLE DATA
-- ============================================

-- College
INSERT INTO College (college_id, name)
VALUES (1, 'MacEwan University');

-- Departments
INSERT INTO Department (department_id, name, college_id)
VALUES
(10, 'Computer Science', 1),
(20, 'Psychology', 1);

-- Instructors
INSERT INTO Instructor (instructor_id, name, department_id)
VALUES
(100, 'Dr. Smith', 10),
(101, 'Dr. Johnson', 10),
(200, 'Dr. Brown', 20);

-- Students
INSERT INTO Student (student_id, name, year)
VALUES
(1000, 'Alice Chen', 2),
(1001, 'Bob Martin', 3),
(1002, 'Sarah Khan', 1);

-- Courses
INSERT INTO Course (course_id, course_code, title, department_id)
VALUES
(10000, 'COMP101', 'Introduction to Programming', 10),
(10001, 'COMP202', 'Data Structures', 10),
(20000, 'PSYC101', 'Introduction to Psychology', 20);

-- Course Sections
INSERT INTO CourseSection
(section_id, course_id, instructor_id, term, year, section_number, max_capacity)
VALUES
(500, 10000, 100, 'Fall', 2025, 'A', 30),
(501, 10000, 101, 'Fall', 2025, 'B', 25),
(502, 10001, 101, 'Fall', 2025, 'A', 25),
(503, 20000, 200, 'Fall', 2025, 'A', 40);

-- Course Schedules
INSERT INTO CourseSchedule
(schedule_id, section_id, day_of_week, start_time, end_time)
VALUES
-- COMP 101 A
(1, 500, 'Monday',    '10:00', '11:20'),
(2, 500, 'Wednesday', '10:00', '11:20'),
-- COMP 101 B
(3, 501, 'Tuesday',   '13:00', '14:20'),
(4, 501, 'Thursday',  '13:00', '14:20'),
-- COMP 202 A
(5, 502, 'Monday',    '11:30', '12:50'),
(6, 502, 'Wednesday', '11:30', '12:50'),
-- PSYC 101 A
(7, 503, 'Tuesday',   '09:00', '10:20'),
(8, 503, 'Thursday',  '09:00', '10:20');

-- Prerequisites
INSERT INTO Prerequisite (course_id, prerequisite_course_id)
VALUES
(10001, 10000); -- COMP 202 requires COMP 101

-- Enrollments
INSERT INTO Enrollment (enrollment_id, student_id, section_id)
VALUES
(1, 1000, 500), -- Alice → COMP 101 A
(2, 1001, 502), -- Bob → COMP 202 A
(3, 1002, 503); -- Sarah → PSYC 101 A

-- ============================================
-- CREATE MATERIALIZED VIEWS (INDEXED VIEWS)
-- ============================================

-- Materialized View 1: Student Cart Details
CREATE VIEW vw_StudentCartDetails
WITH SCHEMABINDING
AS
SELECT 
    ct.student_id,
    ct.section_id,
    cs.section_number,
    cs.term,
    cs.year,
    cs.course_id,
    cs.instructor_id,
    cs.max_capacity,
    COUNT_BIG(*) as item_count
FROM dbo.Cart ct
INNER JOIN dbo.CourseSection cs ON ct.section_id = cs.section_id
GROUP BY 
    ct.student_id,
    ct.section_id,
    cs.section_number,
    cs.term,
    cs.year,
    cs.course_id,
    cs.instructor_id,
    cs.max_capacity;
GO

-- Create clustered index to materialize the view
CREATE UNIQUE CLUSTERED INDEX IX_StudentCartDetails 
ON vw_StudentCartDetails(student_id, section_id);
GO

-- Materialized View 2: Section Enrollment Counts
CREATE VIEW vw_SectionEnrollmentCount
WITH SCHEMABINDING
AS
SELECT 
    section_id,
    COUNT_BIG(*) as enrolled_count
FROM dbo.Enrollment
GROUP BY section_id;
GO

-- Create clustered index to materialize the view
CREATE UNIQUE CLUSTERED INDEX IX_SectionEnrollmentCount 
ON vw_SectionEnrollmentCount(section_id);
GO

-- ============================================
-- VERIFY DATA
-- ============================================
SELECT * FROM College;
SELECT * FROM Department;
SELECT * FROM Instructor;
SELECT * FROM Student;
SELECT * FROM Course;
SELECT * FROM CourseSection;
SELECT * FROM CourseSchedule;
SELECT * FROM Prerequisite;
SELECT * FROM Enrollment;

-- Test the materialized views
SELECT * FROM vw_SectionEnrollmentCount;
-- This should show:
-- section_id | enrolled_count
-- 500        | 1  (Alice in COMP 101 A)
-- 502        | 1  (Bob in COMP 202 A)
-- 503        | 1  (Sarah in PSYC 101 A)
