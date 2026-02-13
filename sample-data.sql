USE UniRegistration;

DELETE FROM Cart;
DELETE FROM Enrollment;
DELETE FROM CourseSchedule;
DELETE FROM CourseSection;
DELETE FROM Prerequisite;
DELETE FROM Course;
DELETE FROM Student;
DELETE FROM Instructor;
DELETE FROM Department;
DELETE FROM College;
DELETE FROM Classroom;

-- Reset identity seeds
DBCC CHECKIDENT ('Cart', RESEED, 0);
DBCC CHECKIDENT ('Enrollment', RESEED, 0);
DBCC CHECKIDENT ('CourseSchedule', RESEED, 0);
DBCC CHECKIDENT ('CourseSection', RESEED, 0);
DBCC CHECKIDENT ('Prerequisite', RESEED, 0);
DBCC CHECKIDENT ('Course', RESEED, 0);
DBCC CHECKIDENT ('Classroom', RESEED, 0);
DBCC CHECKIDENT ('Student', RESEED, 999);


-- College
INSERT INTO College (college_id, name)
VALUES (1, 'MacEwan University');

-- Departments
INSERT INTO Department (department_id, name, college_id) VALUES
(1, 'Computer Science', 1),
(2, 'Mathematics', 1);

-- Instructors
INSERT INTO Instructor (instructor_id, name, department_id) VALUES
(101, 'Dr. Alice Johnson', 1),
(102, 'Prof. Bob Smith', 2);

-- Classrooms
INSERT INTO Classroom (building, room_number, capacity, room_type) VALUES
('5', '110', 30, 'Lab'),
('5', '210', 25, 'Lecture'),
('6', '110', 40, 'Lecture');


-- STUDENTS 
INSERT INTO Student (name, year, major_department_id) VALUES
('Alice Chen', 2, 1),      -- student_id: 1000 (has completed courses)
('Bob Martin', 1, 1),      -- student_id: 1001 (new student, no courses)
('Carol Davis', 2, 1),     -- student_id: 1002 (has some courses)
('David Wilson', 3, 1);    -- student_id: 1003 (senior, testing withdrawals)

-- COURSES 
INSERT INTO Course (course_code, title, department_id) VALUES
('CMPT101', 'Intro to Computing I', 1),      -- course_id: 1
('CMPT103', 'Intro to Computing II', 1),     -- course_id: 2
('CMPT200', 'Data Structures', 1),           -- course_id: 3
('CMPT391', 'Database Management', 1),       -- course_id: 4
('MATH114', 'Calculus I', 2);                -- course_id: 5

-- PREREQUISITES
INSERT INTO Prerequisite (course_id, prerequisite_course_id, minimum_grade) VALUES
(2, 1, 'C-'),  -- CMPT103 requires CMPT101
(3, 2, 'C-'),  -- CMPT200 requires CMPT103
(4, 3, 'C-'),  -- CMPT391 requires CMPT200
(4, 5, 'C-');	-- CMPT391 requires MATH114


-- COURSE SECTIONS (Winter 2026 - Current term for demo)
INSERT INTO CourseSection (course_id, instructor_id, term, year, section_number, max_capacity) VALUES
-- Fall 2025 sections (Previous term - for prerequisite testing)
(1, 101, 'Fall', 2025, 'F01', 35),  -- section_id: 7 (CMPT101 - Fall 2025)
(1, 101, 'Fall', 2025, 'F02', 35),  -- section_id: 8 (CMPT101 - Fall 2025)
(2, 101, 'Fall', 2025, 'F01', 30),  -- section_id: 9 (CMPT103 - Fall 2025)
(2, 101, 'Fall', 2025, 'F02', 30),  -- section_id: 10 (CMPT103 - Fall 2025)
(5, 102, 'Fall', 2025, 'F01', 35),  -- section_id: 11 (MATH114 - Fall 2025)

-- Winter 2026 sections
(1, 101, 'Winter', 2026, 'W01', 30),  -- section_id: 1  (CMPT101 - Morning)
(1, 101, 'Winter', 2026, 'W02', 1),   -- section_id: 2  (CMPT101 - Afternoon, ALMOST FULL)
(2, 101, 'Winter', 2026, 'W01', 25),  -- section_id: 3  (CMPT103)
(3, 101, 'Winter', 2026, 'W01', 20),  -- section_id: 4  (CMPT200)
(4, 101, 'Winter', 2026, 'W01', 15),  -- section_id: 5  (CMPT391)
(5, 102, 'Winter', 2026, 'W01', 30);  -- section_id: 6  (MATH114)


/***** COURSE SCHEDULES **********/
INSERT INTO CourseSchedule (section_id, day_of_week, start_time, end_time, classroom_id) VALUES
-- Fall 2025 Schedules
-- Section 7 (CMPT101 F01): MWF 9:00-10:20
(7, 'Monday', '09:00', '10:20', 1),
(7, 'Wednesday', '09:00', '10:20', 1),
(7, 'Friday', '09:00', '10:20', 1),

-- Section 8 (CMPT101 F02): TTh 13:00-14:20
(8, 'Tuesday', '13:00', '14:20', 2),
(8, 'Thursday', '13:00', '14:20', 2),

-- Section 9 (CMPT103 F01): MWF 10:30-11:50
(9, 'Monday', '10:30', '11:50', 1),
(9, 'Wednesday', '10:30', '11:50', 1),
(9, 'Friday', '10:30', '11:50', 1),

-- Section 10 (CMPT103 F02): TTh 14:30-15:50
(10, 'Tuesday', '14:30', '15:50', 2),
(10, 'Thursday', '14:30', '15:50', 2),

-- Section 11 (MATH114 - Fall 2025)
(11, 'Tuesday', '10:00', '11:20', 3),
(11, 'Thursday', '10:00', '11:20', 3),

-- Section 1 (CMPT101 W01): MWF 9:00-10:20
(1, 'Monday', '09:00', '10:20', 1),
(1, 'Wednesday', '09:00', '10:20', 1),
(1, 'Friday', '09:00', '10:20', 1),

-- Section 2 (CMPT101 W02): TTh 13:00-14:20
(2, 'Tuesday', '13:00', '14:20', 2),
(2, 'Thursday', '13:00', '14:20', 2),

-- Section 3 (CMPT103 W01): MWF 10:30-11:50
(3, 'Monday', '10:30', '11:50', 1),
(3, 'Wednesday', '10:30', '11:50', 1),
(3, 'Friday', '10:30', '11:50', 1),

-- Section 4 (CMPT200 W01): TTh 14:30-15:50
(4, 'Tuesday', '14:30', '15:50', 2),
(4, 'Thursday', '14:30', '15:50', 2),

-- Section 5 (CMPT391 W01): MWF 9:00-10:20 (CONFLICTS with Section 1!)
(5, 'Monday', '09:00', '10:20', 3),
(5, 'Wednesday', '09:00', '10:20', 3),
(5, 'Friday', '09:00', '10:20', 3),

-- Section 6 (MATH114 W01): TTh 10:00-11:20
(6, 'Tuesday', '10:00', '11:20', 3),
(6, 'Thursday', '10:00', '11:20', 3);



/***** ENROLLMENTS (Setup student history) *****/
INSERT INTO Enrollment (student_id, course_id, section_id, status, grade, enrollment_date) VALUES
(1000, 1, 1, 'Completed', 'A-', '2025-09-01'),  -- CMPT101 F01 - enrolled Sept 1
(1000, 2, 3, 'Completed', 'B+', '2025-09-01'),  -- CMPT103 F01 - enrolled Sept 1
(1000, 5, 5, 'Completed', 'B', '2025-09-02');   -- MATH114 F01 - enrolled Sept 2

-- Student 1001 (Bob): Currently enrolled in Winter 2026
INSERT INTO Enrollment (student_id, course_id, section_id, status, grade, enrollment_date) VALUES
(1001, 1, 6, 'Enrolled', 'I', '2026-01-05');    -- CMPT101 W01 - enrolled Jan 5

-- Student 1002 (Carol): Failed attempts + current enrollment
INSERT INTO Enrollment (student_id, course_id, section_id, status, grade, enrollment_date) VALUES
(1002, 1, 2, 'Completed', 'D', '2025-09-03'),  -- CMPT101 F02 - barely passed
(1002, 1, 1, 'Withdrawn', 'W', '2025-10-15');	-- Withdrew from another section (past deadline)

-- Student 1003 (David): Testing 2-week withdrawal rule
INSERT INTO Enrollment (student_id, course_id, section_id, status, grade, enrollment_date) VALUES
(1003, 1, 6, 'Enrolled', 'I', '2026-01-05'),    -- CMPT101 W01 - within 2 weeks
(1003, 5, 11, 'Enrolled', 'I', '2025-12-20');   -- MATH114 W01 - enrolled before semester starts


/***** CART (Some courses already in cart) ****
-- Student 1000 (Alice): Has prerequisites - can register
INSERT INTO Cart (student_id, course_id, section_id) VALUES
(1000, 3, 4);  -- CMPT200 in cart (has CMPT103 completed)

-- Student 1001 (Bob): Test schedule conflict
INSERT INTO Cart (student_id, course_id, section_id) VALUES
(1001, 5, 5);  -- CMPT391 in cart (CONFLICT with CMPT101 - same time MWF 9:00!)

-- Student 1002 (Carol): Test prerequisite failure
INSERT INTO Cart (student_id, course_id, section_id) VALUES
(1002, 3, 4);  -- CMPT200 in cart (FAIL - needs CMPT103 with C- or better, only has C+ in CMPT101)

-- Student 1003 (David): Test successful registration
INSERT INTO Cart (student_id, course_id, section_id) VALUES
(1003, 2, 3);  -- CMPT103 in cart (has CMPT101 enrolled)
*/

