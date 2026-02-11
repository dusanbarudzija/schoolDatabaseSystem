USE UniRegistration;

IF OBJECT_ID('sp_GetAllStudents', 'P') IS NOT NULL DROP PROCEDURE sp_GetAllStudents;
IF OBJECT_ID('sp_GetAvailableSections', 'P') IS NOT NULL DROP PROCEDURE sp_GetAvailableSections;
IF OBJECT_ID('sp_GetCourseSchedule', 'P') IS NOT NULL DROP PROCEDURE sp_GetCourseSchedule;
IF OBJECT_ID('sp_GetStudentEnrollments', 'P') IS NOT NULL DROP PROCEDURE sp_GetStudentEnrollments;
IF OBJECT_ID('sp_GetStudentCart', 'P') IS NOT NULL DROP PROCEDURE sp_GetStudentCart;
IF OBJECT_ID('sp_IsAlreadyEnrolled', 'P') IS NOT NULL DROP PROCEDURE sp_IsAlreadyEnrolled;
IF OBJECT_ID('sp_IsSectionFull', 'P') IS NOT NULL DROP PROCEDURE sp_IsSectionFull;
IF OBJECT_ID('sp_RemoveFromCart', 'P') IS NOT NULL DROP PROCEDURE sp_RemoveFromCart;
IF OBJECT_ID('sp_AddToCart', 'P') IS NOT NULL DROP PROCEDURE sp_AddToCart;
IF OBJECT_ID('sp_RegisterStudent', 'P') IS NOT NULL DROP PROCEDURE sp_RegisterStudent;


IF OBJECT_ID('sp_GetAllStudents', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetAllStudents;
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


IF OBJECT_ID('sp_AddToCart', 'P') IS NOT NULL
    DROP PROCEDURE sp_AddToCart;
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

        DECLARE @CourseId INT;
        SELECT @CourseId = course_id 
        FROM CourseSection 
        WHERE section_id = @SectionId;

        IF EXISTS (
            SELECT 1
            FROM Cart 
            WHERE student_id=@StudentId AND section_id=@SectionId	
        )
        BEGIN 
            SET @ResultMessage = 'Course already in cart';
            RETURN;
        END

        IF EXISTS (
            SELECT 1
            FROM Enrollment 
            WHERE student_id = @StudentId AND section_id = @SectionId
        )
        BEGIN
            SET @ResultMessage = 'Already enrolled in this course';
            RETURN;
        END

        INSERT INTO Cart(student_id, course_id, section_id)
        VALUES (@StudentId, @CourseId, @SectionId);


        SET @IsSuccess = 1;
        SET @ResultMessage = 'Added to cart successfully';

    END TRY
    BEGIN CATCH
        SET @IsSuccess = 0;
        SET @ResultMessage = 'Error: ' + ERROR_MESSAGE();
    END CATCH
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

CREATE OR ALTER PROCEDURE sp_GetCourseSchedule
    @SectionId INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        SELECT day_of_week, start_time, end_time
        FROM CourseSchedule
        WHERE section_id = @SectionId;

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        THROW;
    END CATCH
END;
GO
