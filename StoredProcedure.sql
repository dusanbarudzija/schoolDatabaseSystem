USE UniRegistration;

IF OBJECT_ID('sp_GetAllStudents', 'P') IS NOT NULL DROP PROCEDURE sp_GetAllStudents;
IF OBJECT_ID('sp_GetAvailableSections', 'P') IS NOT NULL DROP PROCEDURE sp_GetAvailableSections;
IF OBJECT_ID('sp_GetCourseSchedule', 'P') IS NOT NULL DROP PROCEDURE sp_GetCourseSchedule;
IF OBJECT_ID('sp_GetStudentEnrollments', 'P') IS NOT NULL DROP PROCEDURE sp_GetStudentEnrollments;
IF OBJECT_ID('sp_GetStudentCart', 'P') IS NOT NULL DROP PROCEDURE sp_GetStudentCart;
IF OBJECT_ID('sp_RemoveFromCart', 'P') IS NOT NULL DROP PROCEDURE sp_RemoveFromCart;
IF OBJECT_ID('sp_AddToCart', 'P') IS NOT NULL DROP PROCEDURE sp_AddToCart;
IF OBJECT_ID('sp_RegisterStudent', 'P') IS NOT NULL DROP PROCEDURE sp_RegisterStudent;
IF OBJECT_ID('sp_RemoveEnrolledCourse', 'P') IS NOT NULL DROP PROCEDURE sp_RemoveEnrolledCourse;

-- Get all students
GO
CREATE PROCEDURE sp_GetAllStudents
AS
BEGIN
    SET NOCOUNT ON;

    SELECT student_id, name
    FROM Student 
    ORDER BY name;
END;
GO


CREATE OR ALTER PROCEDURE sp_GetAvailableSections
    @Term VARCHAR(10),
    @Year INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        SELECT
            cs.section_id,
            c.course_code,
            c.title,
            cs.section_number,
            i.name AS instructor,
            cs.max_capacity -
            (SELECT COUNT(*) FROM Enrollment e WHERE e.section_id = cs.section_id)
            AS seats_remaining
        FROM CourseSection cs
        JOIN Course c ON cs.course_id = c.course_id
        JOIN Instructor i ON cs.instructor_id = i.instructor_id
        WHERE cs.term = @Term
          AND cs.year = @Year;

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        THROW;
    END CATCH
END;
GO

CREATE PROCEDURE sp_GetCourseSchedule
    @SectionId INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        SELECT day_of_week, start_time, end_time
        FROM CourseSchedule
        WHERE section_id = @SectionId;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        THROW;
    END CATCH
END;


GO
CREATE PROCEDURE sp_GetStudentEnrollments
    @StudentId INT
AS
BEGIN 
    SET NOCOUNT ON;

	BEGIN TRY
        BEGIN TRANSACTION;

		SELECT 
			e.enrollment_id,
			cs.section_id,
			c.course_code,
			c.title,
			cs.term,
			cs.year,
			cs.section_number,
			i.name AS instructor_name,
			e.status,
			e.grade
		FROM Enrollment e
		INNER JOIN CourseSection cs ON e.section_id = cs.section_id
		INNER JOIN Course c ON e.course_id = c.course_id
		INNER JOIN Instructor i ON cs.instructor_id = i.instructor_id
		WHERE e.student_id = @StudentId
		ORDER BY c.course_code;

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH 
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END;



GO
CREATE PROCEDURE sp_GetStudentCart
    @StudentId INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        SELECT
            c.cart_id,
            c.section_id,
            co.course_code,
            co.title,
			cs.term,
			cs.year,
            cs.section_number,
            i.name AS instructor
        FROM Cart c
        JOIN Course co ON c.course_id = co.course_id
        JOIN CourseSection cs ON c.section_id = cs.section_id
        JOIN Instructor i ON cs.instructor_id = i.instructor_id
        WHERE c.student_id = @StudentId
        ORDER BY co.course_code;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
    END CATCH
END;
GO


CREATE PROCEDURE sp_AddToCart
    @StudentId INT,
    @SectionId INT,
    @ResultMessage VARCHAR(500) OUTPUT,
    @IsSuccess BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @IsSuccess = 0;

    BEGIN TRY
		BEGIN TRAN

        DECLARE @CourseId INT;

        SELECT @CourseId = course_id 
        FROM CourseSection 
        WHERE section_id = @SectionId;

		IF @CourseId IS NULL
        BEGIN
            SET @ResultMessage = 'Invalid section.';
            ROLLBACK;
            RETURN;
        END

		-- Check if already in cart (for THIS course, any section)
        IF EXISTS (
            SELECT 1
            FROM Cart 
            WHERE student_id=@StudentId 
				AND course_id=@CourseId	
        )
        BEGIN 
            SET @ResultMessage = 'Course already in cart';
			ROLLBACK;
            RETURN;
        END

		-- Check if already enrolled or completed (THIS course, any section)
        IF EXISTS (
            SELECT 1
            FROM Enrollment 
            WHERE student_id = @StudentId 
				AND course_id = @CourseId
				AND status IN ('Enrolled', 'Completed')
        )
        BEGIN
            SET @ResultMessage = 'Already enrolled in or completed this course';
            ROLLBACK;
			RETURN;
        END

		-- Check if prereqs met (using materialized  view)
		IF EXISTS (
            SELECT 1
            FROM Prerequisite p
            WHERE p.course_id = @CourseId
              AND p.prerequisite_course_id NOT IN (
                  SELECT mv.course_id
                  FROM mv_StudentCompletedCourses mv
                  WHERE mv.student_id = @StudentId
                    AND mv.grade >= p.minimum_grade
              )
        )

		-- Get list of missing prerequisites
		BEGIN
			DECLARE @MissingCourses VARCHAR(1000);
            
			SELECT @MissingCourses = STRING_AGG(c.course_code + ' (' + c.title + ')', ', ')
			FROM Prerequisite p
			JOIN Course c ON p.prerequisite_course_id = c.course_id
			WHERE p.course_id = @CourseId
			AND p.prerequisite_course_id NOT IN (
				SELECT mv.course_id
				FROM mv_StudentCompletedCourses mv
				WHERE mv.student_id = @StudentId
				AND mv.grade >= p.minimum_grade
			);
			SET @ResultMessage = 'Prerequisites not met: ' + ISNULL(@MissingCourses, 'Unknown prerequisites');
			ROLLBACK;
            RETURN;
        END

		-- Check for schedule conflict with ONLY Enrolled courses
		IF EXISTS (
            SELECT 1
            FROM CourseSchedule n
            JOIN CourseSchedule e
                ON n.day_of_week=e.day_of_week
               AND n.start_time < e.end_time
               AND n.end_time > e.start_time
            WHERE n.section_id=@SectionId
              AND e.section_id
			   IN (
                    SELECT section_id
					FROM Enrollment 
					WHERE student_id=@StudentId
						AND status = 'Enrolled'
                    UNION
                    SELECT section_id 
					FROM Cart 
					WHERE student_id=@StudentId
              )
        )
        BEGIN
            SET @ResultMessage='Schedule conflict with existing course.';
            ROLLBACK;
            RETURN;
        END

		-- Add to cart
		INSERT INTO Cart(student_id, course_id, section_id)
		VALUES(@StudentId, @CourseId, @SectionId);

		COMMIT TRANSACTION;

        SET @IsSuccess = 1;
        SET @ResultMessage = 'Added to cart successfully';

	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0 ROLLBACK;
		SET @IsSuccess = 0;
        SET @ResultMessage = 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


GO
CREATE PROCEDURE sp_RemoveFromCart
    @StudentId INT,
    @SectionId INT,
    @ResultMessage VARCHAR(500) OUTPUT,
    @IsSuccess BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @IsSuccess = 0;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
            -- Simple DELETE
            DELETE FROM Cart 
            WHERE student_id = @StudentId AND section_id = @SectionId;
            
            -- Check if anything was deleted
            IF @@ROWCOUNT > 0
            BEGIN
                SET @IsSuccess = 1;
                SET @ResultMessage = 'Removed from cart successfully';
            END
            ELSE
            BEGIN
                SET @IsSuccess = 0;
                SET @ResultMessage = 'Item not found in cart';
            END
        
        COMMIT TRANSACTION;
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        SET @IsSuccess = 0;
        SET @ResultMessage = 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- sp_RegisterStudent
CREATE PROCEDURE sp_RegisterStudent
    @StudentId INT,
    @SectionId INT,
    @ResultMessage VARCHAR(500) OUTPUT,
    @IsSuccess BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @IsSuccess = 0;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
            -- Get course_id
            DECLARE @CourseId INT;
            SELECT @CourseId = course_id 
            FROM CourseSection 
            WHERE section_id = @SectionId;
            
            IF @CourseId IS NULL
            BEGIN
                SET @ResultMessage = 'Section does not exist';
                ROLLBACK TRANSACTION;
                RETURN;
            END
            
            -- Check if section full?
            DECLARE @MaxCapacity INT, @CurrentEnrollment INT;
            
            SELECT 
                @MaxCapacity = max_capacity,
                @CurrentEnrollment = (
                    SELECT COUNT(*) 
                    FROM Enrollment 
                    WHERE section_id = @SectionId 
                      AND status = 'Enrolled'
                )
            FROM CourseSection
            WHERE section_id = @SectionId;
            
            IF @CurrentEnrollment >= @MaxCapacity
            BEGIN
                SET @ResultMessage = 'Section is full - no seats available';
                ROLLBACK TRANSACTION;
                RETURN;
            END
            
            -- Register student (with course_id)
            INSERT INTO Enrollment (student_id, course_id, section_id, status, grade)
            VALUES (@StudentId, @CourseId, @SectionId, 'Enrolled', 'I');
            
            -- Remove from cart
            DELETE FROM Cart 
            WHERE student_id = @StudentId AND section_id = @SectionId;
            
        COMMIT TRANSACTION;
        
        SET @IsSuccess = 1;
        SET @ResultMessage = 'Registration successful';
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        SET @IsSuccess = 0;
        SET @ResultMessage = 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


CREATE PROCEDURE sp_RemoveEnrolledCourse
	@StudentId INT,
    @SectionId INT,
    @CurrentDate DATE = NULL,
    @ResultMessage VARCHAR(500) OUTPUT,
    @IsSuccess BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
	SET @IsSuccess = 0;
    
	IF @CurrentDate IS NULL
        SET @CurrentDate = GETDATE();
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
			DECLARE @StartDate DATE,
                @CurrentStatus VARCHAR(20),
                @DaysDiff INT,
                @CourseId INT;

			-- Get current enrollment status and course ID
			SELECT @CurrentStatus = e.status,
				   @CourseId = e.course_id
			FROM Enrollment e
			WHERE e.student_id = @StudentId AND e.section_id = @SectionId;

			-- Check if status is 'Enrolled'
			IF @CurrentStatus != 'Enrolled'
			BEGIN
				SET @ResultMessage = 'Cannot remove. Current status is ' + @CurrentStatus + ', not Enrolled.';
				ROLLBACK TRANSACTION;
				RETURN;
			END
            
			-- Derive semester start date from term/year
            SELECT @StartDate = 
                CASE cs.term
                    WHEN 'Fall' THEN DATEFROMPARTS(cs.year, 9, 1)  -- Sept 1
                    WHEN 'Winter' THEN DATEFROMPARTS(cs.year, 1, 5)  -- Jan 5
                    WHEN 'Spring' THEN DATEFROMPARTS(cs.year, 5, 1)  -- May 1
                    WHEN 'Summer' THEN DATEFROMPARTS(cs.year, 7, 1)  -- July 1
                END
            FROM CourseSection cs
            WHERE cs.section_id = @SectionId;

		-- Calculate days between start date and current date
        SET @DaysDiff = DATEDIFF(DAY, @StartDate, @CurrentDate);
      

		IF @DaysDiff <= 14
        BEGIN
            -- Within 2 weeks: Complete removal
            DELETE FROM Enrollment
            WHERE student_id = @StudentId AND section_id = @SectionId;

			SELECT 'Enrollment deleted successfully.' AS Message;

		END
		ELSE
		BEGIN
			
			-- After 2 weeks: Change status to 'Withdrawn' AND grade = 'W'
			UPDATE Enrollment
            SET status = 'Withdrawn',
                grade = 'W'
            WHERE student_id = @StudentId AND section_id = @SectionId;

			SET @ResultMessage = 'Past 2-week deadline. Status changed to Withdrawn with grade W.';
            SET @IsSuccess = 1;
        END

		COMMIT TRANSACTION;
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        SET @IsSuccess = 0;
        SET @ResultMessage = 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO