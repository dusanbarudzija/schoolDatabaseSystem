USE UniRegistration;

/* ================================
   CLEAR DATA
   ================================ */
DELETE FROM Enrollment;
DELETE FROM Prerequisite;
DELETE FROM CourseSchedule;
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

-- Department Heads
UPDATE Department SET head_instructor_id = 100 WHERE department_id = 10;
UPDATE Department SET head_instructor_id = 200 WHERE department_id = 20;

-- Students
INSERT INTO Student (student_id, name, year)
VALUES
(1000, 'Alice Chen', 2),
(1001, 'Bob Martin', 3),
(1002, 'Sarah Khan', 1);

-- Courses
INSERT INTO Course (course_id, course_code, title, department_id, instructor_id, max_capacity)
VALUES
(10000, 'COMP101', 'Introduction to Programming', 10, 100, 30),
(10001, 'COMP202', 'Data Structures', 10, 101, 25),
(20000, 'PSYC101', 'Introduction to Psychology', 20, 200, 40);

-- Course Schedules
INSERT INTO CourseSchedule (schedule_id, course_id, day_of_week, start_time, end_time, term)
VALUES
(1, 10000, 'Monday', '10:00', '11:20', 'Fall'),
(2, 10000, 'Wednesday', '10:00', '11:20', 'Fall'),
(3, 10001, 'Monday', '11:30', '12:50', 'Fall'),
(4, 10001, 'Wednesday', '11:30', '12:50', 'Fall'),
(5, 20000, 'Tuesday', '09:00', '10:20', 'Fall'),
(6, 20000, 'Thursday', '09:00', '10:20', 'Fall');

-- Prerequisites
INSERT INTO Prerequisite (course_id, prerequisite_course_id)
VALUES (10001, 10000);

-- Enrollments
INSERT INTO Enrollment (enrollment_id, student_id, course_id, term)
VALUES
(1, 1000, 10000, 'Fall'),
(2, 1001, 10001, 'Fall'),
(3, 1002, 20000, 'Fall');

SELECT * FROM College;
SELECT * FROM Department;
SELECT * FROM Instructor;
SELECT * FROM Student;
SELECT * FROM Course;
SELECT * FROM CourseSchedule;
SELECT * FROM Prerequisite;
SELECT * FROM Enrollment;
