USE UniRegistration;

-- Disable constraints
EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL';

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


-- Re-enable constraints
EXEC sp_MSforeachtable 'ALTER TABLE ? CHECK CONSTRAINT ALL';


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
('Carol Davis', 2, 1);     -- student_id: 1002 (has some courses)

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
-- Winter 2026 sections
(1, 101, 'Winter', 2026, 'W01', 30),  -- section_id: 1  (CMPT101)
(1, 101, 'Winter', 2026, 'W02', 5),   -- section_id: 2  (CMPT101 - SMALL for testing full)
(2, 101, 'Winter', 2026, 'W01', 25),  -- section_id: 3  (CMPT103)
(3, 101, 'Winter', 2026, 'W01', 20),  -- section_id: 4  (CMPT200)
(4, 101, 'Winter', 2026, 'W01', 15),  -- section_id: 5  (CMPT391)
(5, 102, 'Winter', 2026, 'W01', 30);  -- section_id: 6  (MATH114)


/***** COURSE SCHEDULES **********/
INSERT INTO CourseSchedule (section_id, day_of_week, start_time, end_time, classroom_id) VALUES
-- Section 1 (CMPT101 W01): MWF 9:00-10:20
(1, 'Monday', '09:00', '10:20', 1),
(1, 'Wednesday', '09:00', '10:20', 1),
(1, 'Friday', '09:00', '10:20', 1),

-- Section 2 (CMPT101 W02): TTh 10:00-11:20
(2, 'Tuesday', '10:00', '11:20', 2),
(2, 'Thursday', '10:00', '11:20', 2),

-- Section 3 (CMPT103 W01): MWF 13:00-14:20
(3, 'Monday', '13:00', '14:20', 1),
(3, 'Wednesday', '13:00', '14:20', 1),
(3, 'Friday', '13:00', '14:20', 1),

-- Section 4 (CMPT200 W01): TTh 14:00-15:20
(4, 'Tuesday', '14:00', '15:20', 2),
(4, 'Thursday', '14:00', '15:20', 2),

-- Section 5 (CMPT391 W01): MWF 10:00-11:20
(5, 'Monday', '10:00', '11:20', 3),
(5, 'Wednesday', '10:00', '11:20', 3),
(5, 'Friday', '10:00', '11:20', 3),

-- Section 6 (MATH114 W01): MWF 9:00-10:20 (CONFLICTS with Section 1!)
(6, 'Monday', '09:00', '10:20', 3),
(6, 'Wednesday', '09:00', '10:20', 3),
(6, 'Friday', '09:00', '10:20', 3);



/***** ENROLLMENTS (Setup student history) *****/

-- Student 1000 (Alice): Has completed CMPT101 and CMPT103
INSERT INTO Enrollment (student_id, course_id, section_id, status, grade) VALUES
(1000, 1, 1, 'Completed', 'A'),   -- CMPT101 (can take CMPT103)
(1000, 2, 3, 'Completed', 'B+');  -- CMPT103 (can take CMPT200)

-- Student 1001 (Bob): Currently enrolled in CMPT101
INSERT INTO Enrollment (student_id, course_id, section_id, status, grade) VALUES
(1001, 1, 1, 'Enrolled', 'I');    -- CMPT101 W01 (currently taking)

-- Student 1002 (Carol): Completed CMPT101, enrolled in CMPT103
INSERT INTO Enrollment (student_id, course_id, section_id, status, grade) VALUES
(1002, 1, 1, 'Completed', 'B'),   -- CMPT101 (completed)
(1002, 2, 3, 'Enrolled', 'I');    -- CMPT103 W01 (currently taking)


/***** CART (Some courses already in cart) *****/
-- Student 1000 (Alice): Has CMPT200 in cart (has prerequisites)
INSERT INTO Cart (student_id, course_id, section_id) VALUES
(1000, 3, 4);  -- CMPT200 in cart (can register)

-- Student 1002 (Carol): Has CMPT101 W02 in cart (but already enrolled in another section!)
INSERT INTO Cart (student_id, course_id, section_id) VALUES
(1002, 1, 2);  -- CMPT101 W02 in cart (will fail to register - already enrolled)