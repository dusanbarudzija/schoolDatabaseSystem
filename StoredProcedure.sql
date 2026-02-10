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

-- Get all students
CREATE PROCEDURE sp_GetAllStudents
AS
BEGIN
	SET NOCOUNT ON;

	SELECT student_id, name
	FROM Student 
	ORDER BY name;
END;

-- Get available sections
CREATE PROCEDURE sp_GetAvailableSections
	@Term VARCHAR(20),
	@Year INT
AS 
BEGIN
	SET NOCOUNT ON;

	SELECT cs.section_id,

-- Add course to cart
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

		-- Get course info
		DECLARE @CourseId INT;
        SELECT @CourseId = course_id 
        FROM CourseSection 
        WHERE section_id = @SectionId;
		
		-- 1. Check if already in cart
		IF EXISTS (
			SELECT 1
			FROM Cart 
			WHERE student_id=@StudentId AND section_id=@SectionId	
		)
		BEGIN 
			SET @ResultMessage = 'Course already in cart';
			RETURN;
		END
		
		-- 2. Check if student is already enrolled
		IF EXISTS (
            SELECT 1
            FROM Enrollment 
            WHERE student_id = @StudentId AND section_id = @SectionId
        )
		BEGIN
			SET @ResultMessage = 'Already enrolled in this course';
			RETURN;
		END

		-- 3. Check if prereqs met
		

		-- Add to cart
		INSERT INTO Cart(student_id, section_id)
		VALUES(@StudentId, @SectionId)

		SET @IsSuccess = 1;
        SET @ResultMessage = 'Added to cart successfully';

	END TRY
	BEGIN CATCH
		SET @IsSuccess = 0;
        SET @ResultMessage = 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;