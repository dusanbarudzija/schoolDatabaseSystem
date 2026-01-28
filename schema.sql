USE UniRegistration;

DROP TABLE IF EXISTS Enrollment;
DROP TABLE IF EXISTS Prerequisite;
DROP TABLE IF EXISTS CourseSchedule;
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
    head_instructor_id INT NULL,
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
    year INT CHECK (year BETWEEN 1 AND 4)
);

CREATE TABLE Course (
    course_id INT PRIMARY KEY,
    course_code VARCHAR(10) NOT NULL,
    title VARCHAR(100) NOT NULL,
    department_id INT NOT NULL,
    instructor_id INT NOT NULL,
    max_capacity INT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES Department(department_id),
    FOREIGN KEY (instructor_id) REFERENCES Instructor(instructor_id)
);

CREATE TABLE CourseSchedule (
    schedule_id INT PRIMARY KEY,
    course_id INT NOT NULL,
    day_of_week VARCHAR(10) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    term VARCHAR(10) NOT NULL,
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

CREATE TABLE Prerequisite (
    course_id INT,
    prerequisite_course_id INT,
    PRIMARY KEY (course_id, prerequisite_course_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id),
    FOREIGN KEY (prerequisite_course_id) REFERENCES Course(course_id)
);

CREATE TABLE Enrollment (
    enrollment_id INT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    term VARCHAR(10) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id),
    UNIQUE (student_id, course_id, term)
);
