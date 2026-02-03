USE UniRegistration;
GO

-- 1. Create tables (your schema)
-- ... your CREATE TABLE statements here ...
GO

-- 2. Insert sample data
INSERT INTO Department (dept_id, name) VALUES (1, 'Computer Science');
INSERT INTO Department (dept_id, name) VALUES (2, 'Mathematics');
INSERT INTO Department (dept_id, name) VALUES (3, 'Physics');

INSERT INTO Instructor (instructor_id, name, dept_id) VALUES (101, 'Alice Smith', 1);
INSERT INTO Instructor (instructor_id, name, dept_id) VALUES (102, 'Bob Johnson', 1);
INSERT INTO Instructor (instructor_id, name, dept_id) VALUES (103, 'Carol Lee', 2);
INSERT INTO Instructor (instructor_id, name, dept_id) VALUES (104, 'David Kim', 3);

INSERT INTO Course (course_id, name, dept_id, instructor_id) VALUES (201, 'Intro to Programming', 1, 101);
USE UniRegistration 
-- Insert Departments
INSERT INTO Department (dept_id, name) VALUES (1, 'Computer Science');
INSERT INTO Department (dept_id, name) VALUES (2, 'Mathematics');
INSERT INTO Department (dept_id, name) VALUES (3, 'Physics');

-- Insert Instructors
INSERT INTO Instructor (instructor_id, name, dept_id) VALUES (101, 'Alice Smith', 1);
INSERT INTO Instructor (instructor_id, name, dept_id) VALUES (102, 'Bob Johnson', 1);
INSERT INTO Instructor (instructor_id, name, dept_id) VALUES (103, 'Carol Lee', 2);
INSERT INTO Instructor (instructor_id, name, dept_id) VALUES (104, 'David Kim', 3);


-- Insert Courses
INSERT INTO Course (course_id, name, dept_id, instructor_id) VALUES (201, 'Intro to Programming', 1, 101);
INSERT INTO Course (course_id, name, dept_id, instructor_id) VALUES (202, 'Data Structures', 1, 102);
INSERT INTO Course (course_id, name, dept_id, instructor_id) VALUES (203, 'Calculus I', 2, 103);
INSERT INTO Course (course_id, name, dept_id, instructor_id) VALUES (204, 'Physics I', 3, 104);

-- Insert Students
INSERT INTO Student (student_id, name, email) VALUES (301, 'Eve Turner', 'eve@example.com');
INSERT INTO Student (student_id, name, email) VALUES (302, 'Frank Wright', 'frank@example.com');
INSERT INTO Student (student_id, name, email) VALUES (303, 'Grace Hall', 'grace@example.com');

-- Enroll Students in Courses
INSERT INTO Enrollment (enrollment_id, student_id, course_id) VALUES (401, 301, 201);
INSERT INTO Enrollment (enrollment_id, student_id, course_id) VALUES (402, 301, 203);
INSERT INTO Enrollment (enrollment_id, student_id, course_id) VALUES (403, 302, 202);
INSERT INTO Enrollment (enrollment_id, student_id, course_id) VALUES (404, 303, 201);
INSERT INTO Enrollment (enrollment_id, student_id, course_id) VALUES (405, 303, 204);

-- ===============================================
-- Sample Deletions
-- ===============================================

-- Delete a student (will automatically remove enrollments if CASCADE is set)
DELETE FROM Student WHERE student_id = 301;

-- Delete a course (should remove corresponding enrollments)
DELETE FROM Course WHERE course_id = 202;

DELETE FROM Instructor WHERE instructor_id = 101;

-- Delete a department (ensure courses and instructors are handled first)
-- Optionally use CASCADE if database supports it
DELETE FROM Department WHERE dept_id = 3;

-- Delete all enrollments for a student
DELETE FROM Enrollment WHERE student_id = 303;

