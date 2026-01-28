USE UniRegistration;

DELETE FROM Enrollment;
DELETE FROM CourseSchedule;
DELETE FROM CourseSection;
DELETE FROM Prerequisite;
DELETE FROM Course;
DELETE FROM Student;
DELETE FROM Instructor;
DELETE FROM Department;
DELETE FROM College;


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



INSERT INTO Course (course_id, course_code, title, department_id)
VALUES
(10000, 'COMP101', 'Introduction to Programming', 10),
(10001, 'COMP202', 'Data Structures', 10),
(20000, 'PSYC101', 'Introduction to Psychology', 20);



INSERT INTO CourseSection
(section_id, course_id, instructor_id, term, year, section_number, max_capacity)
VALUES
(500, 10000, 100, 'Fall', 2025, 'A', 30),
(501, 10000, 101, 'Fall', 2025, 'B', 25),
(502, 10001, 101, 'Fall', 2025, 'A', 25),
(503, 20000, 200, 'Fall', 2025, 'A', 40);



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


INSERT INTO Prerequisite (course_id, prerequisite_course_id)
VALUES
(10001, 10000); -- COMP 101 → COMP 202


INSERT INTO Enrollment (enrollment_id, student_id, section_id)
VALUES
(1, 1000, 500), -- Alice → COMP 101 A
(2, 1001, 502), -- Bob → COMP 202 A
(3, 1002, 503); -- Sarah → PSYC 101 A



SELECT * FROM College;
SELECT * FROM Department;
SELECT * FROM Instructor;
SELECT * FROM Student;
SELECT * FROM Course;
SELECT * FROM CourseSection;
SELECT * FROM CourseSchedule;
SELECT * FROM Prerequisite;
SELECT * FROM Enrollment;
