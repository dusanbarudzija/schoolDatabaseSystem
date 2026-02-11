USE UniRegistration;

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

-- Reset identity seeds
DBCC CHECKIDENT ('Cart', RESEED, 0);
DBCC CHECKIDENT ('Enrollment', RESEED, 0);
DBCC CHECKIDENT ('CourseSchedule', RESEED, 0);
DBCC CHECKIDENT ('CourseSection', RESEED, 0);
DBCC CHECKIDENT ('Prerequisite', RESEED, 0);
DBCC CHECKIDENT ('Course', RESEED, 0);
DBCC CHECKIDENT ('Classroom', RESEED, 0);
DBCC CHECKIDENT ('Student', RESEED, 1000);


-- College
INSERT INTO College (college_id, name)
VALUES (1, 'MacEwan University');

-- Departments
INSERT INTO Department (department_id, name, college_id) VALUES
(1, 'Computer Science', 1),
(2, 'Mathematics and Statistics', 1),
(3, 'Biological Sciences', 1),
(4, 'English', 1),
(5, 'Psychology', 1),
(6, 'Accounting and Finance', 1);

-- Instructors
INSERT INTO Instructor (instructor_id, name, department_id) VALUES
(101, 'Dr. Alice Johnson', 1),
(102, 'Prof. Bob Smith', 1),
(103, 'Dr. Carol Davis', 2),
(104, 'Prof. David Wilson', 3),
(105, 'Dr. Eva Brown', 4),
(106, 'Prof. Frank Miller', 5),
(107, 'Dr. Grace Lee', 6);

-- Students
INSERT INTO Student (name, year, major_department_id) VALUES
('Alice Chen', 2, 1),
('Bob Martin', 3, 2),
('Sarah Khan', 1, 3),
('John Doe', 3, 1),
('Jane Smith', 2, 1);

INSERT INTO Classroom (building, room_number, capacity, room_type) VALUES
-- Building 5 (Computer Science) - rooms 110-240
('5', '110', 40, 'Lab'),
('5', '111', 35, 'Lab'),
('5', '210', 30, 'Lecture'),
('5', '211', 25, 'Lecture'),
('5', '240', 45, 'Lab'),

-- Building 6 (Mathematics) - rooms 110-211
('6', '110', 50, 'Lecture'),
('6', '111', 40, 'Lecture'),
('6', '210', 35, 'Lecture'),
('6', '211', 30, 'Lecture'),

-- Building 7 (Biological Sciences) - rooms 110-240
('7', '110', 60, 'Lab'),
('7', '111', 55, 'Lab'),
('7', '210', 45, 'Lecture'),
('7', '211', 40, 'Lecture'),
('7', '240', 50, 'Lab'),

-- Building 8 (Psychology) - rooms 110-210
('8', '110', 60, 'Lecture'),
('8', '111', 55, 'Lecture'),
('8', '210', 50, 'Lecture'),

-- Building 9 (Accounting/Finance) - rooms 110-210
('9', '110', 40, 'Lecture'),
('9', '111', 35, 'Lab'),
('9', '210', 30, 'Lecture');



INSERT INTO Course (course_code, title, department_id) VALUES
-- Computer Science courses
('CMPT101', 'Introduction to Computing I', 1),
('CMPT103', 'Introduction to Computing II', 1),
('CMPT200', 'Data Structures and Algorithms', 1),
('CMPT201', 'Practical Programming Methodology', 1),
('CMPT291', 'Introduction to File and Database Management', 1),
('CMPT391', 'Database Management Systems', 1),
('CMPT395', 'Introduction to Software Engineering', 1),
('CMPT491', 'Datamining and Advanced Database Topics', 1),

-- Mathematics courses
('MATH114', 'Calculus I', 2),
('MATH115', 'Calculus II', 2),
('MATH125', 'Linear Algebra I', 2),
('MATH214', 'Intermediate Calculus I', 2),

-- Biology courses
('BIOL107', 'Introduction to Cell Biology', 3),
('BIOL201', 'Eukaryotic Cellular Biology I', 3),

-- English courses
('ENGL101', 'Analysis and Argument', 4),
('ENGL102', 'Approaches to Literature: Trends and Traditions', 4),

-- Psych courses
('PSYCH104', 'Introductory Psychology I', 5),
('PSYCH105', 'Introductory Psychology II', 5),

-- Accounting courses
('ACCT101', 'Introductory Accounting', 6),
('FNCE 201', 'Introductory Finance', 6);


/* Prerequisites */
INSERT INTO Prerequisite (course_id, prerequisite_course_id, minimum_grade) VALUES
-- CMPT103 requires CMPT101 with grade C- or better
(2, 1, 'C-'),

-- CMPT200 requires CMPT103 with grade C- or better
(3, 2, 'C-'),

-- CMPT201 requires CMPT103 with grade C- or better
(4, 2, 'C-'),

-- CMPT291 requires CMPT103 with grade C- or better
(5, 2, 'C-'),

-- CMPT391 requires CMPT291 with grade C- or better
(6, 5, 'C-'),

-- CMPT395 requires CMPT201
(7, 4, 'C-'),

-- CMPT491 requires CMPT391 with grade C- or better
(8, 6, 'C-'),

-- MATH115 requires MATH114
(10, 9, 'C-'),

-- MATH214 requires MATH115
(12, 10, 'D'),

-- BIOL201 requires BIOL107
(14, 13, 'C-'),

-- ENGL102 requires ENGL101
(16, 15, 'C-'),

-- PSYCH105 requires PSYCH104
(18, 17, 'C-');



INSERT INTO CourseSection (course_id, instructor_id, term, year, section_number, max_capacity) VALUES
-- Fall 2024 sections
(1, 101, 'Fall', 2024, 'F01', 35),
(1, 102, 'Fall', 2024, 'F02', 30),
(2, 101, 'Fall', 2024, 'F01', 30),
(9, 103, 'Fall', 2024, 'F01', 40),
(15, 105, 'Fall', 2024, 'F01', 40),
(17, 106, 'Fall', 2024, 'F01', 45),
(19, 107, 'Fall', 2024, 'F01', 35),

-- Winter 2024 sections
(1, 101, 'Winter', 2024, 'W01', 40),
(1, 102, 'Winter', 2024, 'W02', 35),
(2, 101, 'Winter', 2024, 'W01', 30),
(3, 102, 'Winter', 2024, 'W01', 25),
(4, 101, 'Winter', 2024, 'W01', 30),
(9, 103, 'Winter', 2024, 'W01', 50),
(9, 103, 'Winter', 2024, 'W02', 45),
(10, 103, 'Winter', 2024, 'W01', 40),
(13, 104, 'Winter', 2024, 'W01', 60),
(15, 105, 'Winter', 2024, 'W01', 45),
(15, 105, 'Winter', 2024, 'W02', 40),
(16, 105, 'Winter', 2024, 'W01', 35),
(17, 106, 'Winter', 2024, 'W01', 55),
(18, 106, 'Winter', 2024, 'W01', 50),
(19, 107, 'Winter', 2024, 'W01', 40),
(20, 107, 'Winter', 2024, 'W01', 30),

-- Spring 2024 sections
(1, 101, 'Spring', 2024, 'S01', 25),
(9, 103, 'Spring', 2024, 'S01', 30),
(15, 105, 'Spring', 2024, 'S01', 30),

-- Fall 2025 sections
(1, 101, 'Fall', 2025, 'F01', 35),
(1, 102, 'Fall', 2025, 'F02', 30),
(2, 101, 'Fall', 2025, 'F01', 30),
(3, 102, 'Fall', 2025, 'F01', 25),
(5, 101, 'Fall', 2025, 'F01', 30),
(9, 103, 'Fall', 2025, 'F01', 40),
(10, 103, 'Fall', 2025, 'F01', 35),
(11, 103, 'Fall', 2025, 'F01', 30),
(13, 104, 'Fall', 2025, 'F01', 55),
(15, 105, 'Fall', 2025, 'F01', 40),
(16, 105, 'Fall', 2025, 'F01', 35),
(19, 107, 'Fall', 2025, 'F01', 35),
(20, 107, 'Fall', 2025, 'F01', 25),

-- Winter 2025 sections
(1, 101, 'Winter', 2025, 'W01', 40),
(1, 102, 'Winter', 2025, 'W02', 35),
(3, 102, 'Winter', 2025, 'W01', 25),
(4, 101, 'Winter', 2025, 'W01', 30),
(5, 102, 'Winter', 2025, 'W01', 30),
(6, 101, 'Winter', 2025, 'W01', 25),
(9, 103, 'Winter', 2025, 'W01', 45),
(10, 103, 'Winter', 2025, 'W01', 40),
(12, 103, 'Winter', 2025, 'W01', 30),
(14, 104, 'Winter', 2025, 'W01', 40),
(15, 105, 'Winter', 2025, 'W01', 45),
(16, 105, 'Winter', 2025, 'W01', 35),
(17, 106, 'Winter', 2025, 'W01', 50),
(18, 106, 'Winter', 2025, 'W01', 45),

-- Fall 2026 sections
(1, 101, 'Fall', 2026, 'F01', 35),
(2, 101, 'Fall', 2026, 'F01', 30),
(3, 102, 'Fall', 2026, 'F01', 25),
(6, 101, 'Fall', 2026, 'F01', 25),
(7, 102, 'Fall', 2026, 'F01', 20),
(9, 103, 'Fall', 2026, 'F01', 40),
(11, 103, 'Fall', 2026, 'F01', 30),
(13, 104, 'Fall', 2026, 'F01', 50),
(15, 105, 'Fall', 2026, 'F01', 40),
(16, 105, 'Fall', 2026, 'F01', 35),
(19, 107, 'Fall', 2026, 'F01', 35),
(20, 107, 'Fall', 2026, 'F01', 25),

-- Winter 2026 sections
(1, 101, 'Winter', 2026, 'W01', 40),
(1, 102, 'Winter', 2026, 'W02', 35),
(2, 101, 'Winter', 2026, 'W01', 30),
(3, 102, 'Winter', 2026, 'W01', 25),
(4, 101, 'Winter', 2026, 'W01', 30),
(5, 102, 'Winter', 2026, 'W01', 30),
(6, 101, 'Winter', 2026, 'W01', 25),
(7, 102, 'Winter', 2026, 'W01', 20),
(8, 101, 'Winter', 2026, 'W01', 15),
(9, 103, 'Winter', 2026, 'W01', 45),
(10, 103, 'Winter', 2026, 'W01', 40),
(11, 103, 'Winter', 2026, 'W01', 35),
(12, 103, 'Winter', 2026, 'W01', 30),
(13, 104, 'Winter', 2026, 'W01', 55),
(14, 104, 'Winter', 2026, 'W01', 40),
(15, 105, 'Winter', 2026, 'W01', 45),
(16, 105, 'Winter', 2026, 'W01', 35),
(17, 106, 'Winter', 2026, 'W01', 50),
(18, 106, 'Winter', 2026, 'W01', 45),
(19, 107, 'Winter', 2026, 'W01', 40),
(20, 107, 'Winter', 2026, 'W01', 30),

-- Spring 2026 sections
(1, 101, 'Spring', 2026, 'S01', 25),
(9, 103, 'Spring', 2026, 'S01', 30),
(15, 105, 'Spring', 2026, 'S01', 30),
(19, 107, 'Spring', 2026, 'S01', 25);


INSERT INTO CourseSchedule (section_id, day_of_week, start_time, end_time, classroom_id) VALUES
-- Winter 2025 schedules
-- Section 8 (CMPT101 W01): MWF 9:00-10:20 in Building 5, Room 110 (classroom_id=1)
(8, 'Monday', '09:00', '10:20', 1),
(8, 'Wednesday', '09:00', '10:20', 1),
(8, 'Friday', '09:00', '10:20', 1),

-- Section 9 (CMPT101 W02): TTh 10:30-12:20 in Building 5, Room 111 (classroom_id=2)
(9, 'Tuesday', '10:30', '12:20', 2),
(9, 'Thursday', '10:30', '12:20', 2),

-- Section 10 (CMPT103 W01): MWF 13:00-14:20 in Building 5, Room 210 (classroom_id=3)
(10, 'Monday', '13:00', '14:20', 3),
(10, 'Wednesday', '13:00', '14:20', 3),
(10, 'Friday', '13:00', '14:20', 3),

-- Section 11 (CMPT200 W01): TTh 11:00-12:15 in Building 5, Room 211 (classroom_id=4)
(11, 'Tuesday', '11:00', '12:15', 4),
(11, 'Thursday', '11:00', '12:15', 4),

-- Section 15 (MATH114 W01): MWF 8:30-9:50 in Building 6, Room 110 (classroom_id=6)
(15, 'Monday', '08:30', '09:50', 6),
(15, 'Wednesday', '08:30', '09:50', 6),
(15, 'Friday', '08:30', '09:50', 6),

-- Section 16 (MATH115 W01): TTh 10:00-11:50 in Building 6, Room 111 (classroom_id=7)
(16, 'Tuesday', '10:00', '11:50', 7),
(16, 'Thursday', '10:00', '11:50', 7),

-- Section 18 (BIOL107 W01): TTh 13:00-14:50 in Building 7, Room 110 (classroom_id=10)
(18, 'Tuesday', '13:00', '14:50', 10),
(18, 'Thursday', '13:00', '14:50', 10),

-- Section 20 (ENGL101 W01): MW 11:00-12:20 in Building 7, Room 210 (classroom_id=12)
(20, 'Monday', '11:00', '12:20', 12),
(20, 'Wednesday', '11:00', '12:20', 12),

-- Section 21 (ENGL102 W01): TTh 14:00-15:20 in Building 7, Room 211 (classroom_id=13)
(21, 'Tuesday', '14:00', '15:20', 13),
(21, 'Thursday', '14:00', '15:20', 13),

-- Section 22 (PSYCH104 W01): MW 14:00-15:50 in Building 8, Room 110 (classroom_id=15)
(22, 'Monday', '14:00', '15:50', 15),
(22, 'Wednesday', '14:00', '15:50', 15),

-- Section 23 (PSYCH105 W01): TTh 9:00-10:50 in Building 8, Room 111 (classroom_id=16)
(23, 'Tuesday', '09:00', '10:50', 16),
(23, 'Thursday', '09:00', '10:50', 16),

-- Classroom reuse examples - same room, different term/year (no conflict)
-- Fall 2025 sections using same classrooms as Winter 2025

-- Section 27 (CMPT101 F01 Fall 2025): MWF 10:00-11:20 in Building 5, Room 110 (classroom_id=1)
(27, 'Monday', '10:00', '11:20', 1),
(27, 'Wednesday', '10:00', '11:20', 1),
(27, 'Friday', '10:00', '11:20', 1),

-- Section 28 (CMPT101 F02 Fall 2025): TTh 10:00-11:20 in Building 5, Room 111 (classroom_id=2)
(28, 'Tuesday', '10:00', '11:20', 2),
(28, 'Thursday', '10:00', '11:20', 2),

-- Section 29 (CMPT103 F01 Fall 2025): MWF 14:00-15:20 in Building 5, Room 210 (classroom_id=3)
(29, 'Monday', '14:00', '15:20', 3),
(29, 'Wednesday', '14:00', '15:20', 3),
(29, 'Friday', '14:00', '15:20', 3),

-- Same room, same term/year, different days (no conflict)
-- Building 7, Room 210 used by Section 20 (MW) and by another section (TTh)
(12, 'Tuesday', '11:00', '12:20', 12),  -- CMPT201 W01
(12, 'Thursday', '11:00', '12:20', 12),

-- Same room, same term/year, same days, different times (no conflict)
-- Building 5, Room 211 used by Section 11 (TTh 11:00-12:15) and another (TTh 13:00-14:15)
(13, 'Tuesday', '13:00', '14:15', 4),  -- CMPT291 W01
(13, 'Thursday', '13:00', '14:15', 4),

-- Winter 2026 schedules showing more classroom reuse
-- Section 38 (CMPT101 W01 Winter 2026): MWF 08:00-09:20 in Building 5, Room 110 (classroom_id=1)
(38, 'Monday', '08:00', '09:20', 1),
(38, 'Wednesday', '08:00', '09:20', 1),
(38, 'Friday', '08:00', '09:20', 1),

-- Section 39 (CMPT101 W02 Winter 2026): TTh 08:00-09:20 in Building 5, Room 111 (classroom_id=2)
(39, 'Tuesday', '08:00', '09:20', 2),
(39, 'Thursday', '08:00', '09:20', 2),

-- Same room, different sections in Winter 2026, no time overlap
-- Building 7, Room 240 used by two sections at different times (classroom_id=14)
(47, 'Monday', '09:00', '10:20', 14),   -- MATH114 W01
(47, 'Wednesday', '09:00', '10:20', 14),
(48, 'Monday', '13:00', '14:20', 14),   -- MATH115 W01 - Same room, same day, different time
(48, 'Wednesday', '13:00', '14:20', 14),

-- Spring 2026 - Building 9, Room 110 (classroom_id=18)
(58, 'Monday', '10:00', '11:20', 18),   -- CMPT101 S01
(58, 'Wednesday', '10:00', '11:20', 18),
(58, 'Friday', '10:00', '11:20', 18);



INSERT INTO Enrollment (student_id, course_id, section_id, status, grade) VALUES
-- Student 1000 (Alice Chen) - Completed courses
(1000, 1, 8, 'Completed', 'A'),   -- CMPT101 W01 Winter 2024
(1000, 2, 10, 'Completed', 'B+'), -- CMPT103 W01 Winter 2024
(1000, 9, 15, 'Completed', 'A-'), -- MATH114 W01 Winter 2024

-- Student 1001 (Bob Martin) - Enrolled in Fall 2025
(1001, 1, 27, 'Enrolled', 'I'),  -- CMPT101 F01 Fall 2025
(1001, 9, 32, 'Enrolled', 'I'),  -- MATH114 F01 Fall 2025

-- Student 1002 (Sarah Khan) - Enrolled in Winter 2026
(1002, 1, 38, 'Enrolled', 'I'),  -- CMPT101 W01 Winter 2026
(1002, 9, 47, 'Enrolled', 'I');  -- MATH114 W01 Winter 2026

INSERT INTO Cart (student_id, course_id, section_id) VALUES
-- Student 1000 (Alice Chen) - Considering Winter 2026 courses (already completed prerequisites)
(1000, 2, 40),  -- CMPT103 W01 Winter 2026 (has prereq CMPT101)
(1000, 3, 41),  -- CMPT200 W01 Winter 2026 (has prereq CMPT103)
(1000, 10, 48),  -- MATH115 W01 Winter 2026 (has prereq MATH114)

-- Student 1001 (Bob Martin) - Considering Winter 2026 courses after Fall 2025
(1001, 2, 40),  -- CMPT103 W01 Winter 2026 (will have prereq after Fall)
(1001, 10, 48),  -- MATH115 W01 Winter 2026 (will have prereq after Fall)

-- Student 1002 (Sarah Khan) - Considering Spring 2026 courses
(1002, 1, 58),  -- CMPT101 S01 Spring 2026 (backup option)
(1002, 9, 59);  -- MATH114 S01 Spring 2026


SELECT * FROM College;
SELECT * FROM Department;
SELECT * FROM Instructor;
SELECT * FROM Student;
SELECT * FROM Course;
SELECT * FROM Classroom;
SELECT * FROM CourseSection;
SELECT * FROM CourseSchedule;
SELECT * FROM Prerequisite;
SELECT * FROM Enrollment;
