/*LectureInEvent returns all lecture within the given event location*/
GO
CREATE PROCEDURE dbo.LectureInEvent(@Location nvarchar(50))
AS 
	Declare @SQLID int
	Set @SQLID = (SELECT SQLID FROM SQLSaturday WHERE AddressID = (SELECT AddressID FROM Address WHERE City=@Location))
	SELECT * FROM Lecture WHERE SQLID=@SQLID
GO

/*Uses LectureInEvent procedure with event location value set to Budapest*/
GO
CREATE PROCEDURE dbo.LectureInBudapest
AS 
	EXEC LectureInEvent 'Budapest'
GO

/*Inserts a new presentation or lecture with the speaker and title. Speaker name must be formatted 'firstname lastname' and seperated by a space*/
/*Usage of setLectureToEvent recommended after creating lecture*/
GO
CREATE PROCEDURE dbo.insertPresentation( 
	@Name nvarchar(50),
	@Title nvarchar(50))
AS BEGIN 
	Declare @UserID int
	Set @UserID = (SELECT UserID FROM Person WHERE FirstName=left(@Name, CHARINDEX(' ', @Name)) AND LastName=substring(@Name, CHARINDEX(' ', @Name)+1, len(@Name)-(CHARINDEX(' ', @Name)-1)))
	IF EXISTS(SELECT * FROM LinkerUserToRole WHERE UserID=@UserID AND RoleID=4)
	BEGIN
		IF NOT EXISTS(SELECT * FROM Lecture WHERE Title=@Title AND SQLID=null)
		BEGIN
			INSERT INTO Lecture (Title) VALUES (@Title)
			DECLARE @LID int
			Set @LID = (SELECT TOP 1 LectureID FROM Lecture ORDER BY LectureID DESC)
			INSERT INTO LinkerLectureToPresenter (LectureID,UserID) VALUES (@LID,@UserID)
		END
	END
END