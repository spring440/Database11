GO
CREATE PROCEDURE dbo.newAddress( @Street nvarchar(50), @City nvarchar(50), @ZipCode nvarchar(50), @State nvarchar(50) )
AS BEGIN
	IF NOT EXISTS(SELECT * FROM Address WHERE State=@state AND City=@city AND Street=@Street AND ZipCode=@ZipCode)
	BEGIN
		INSERT INTO Address (State,City,Street,ZipCode) VALUES (@State,@City,@Street,@ZipCode)
	END
END

GO
CREATE PROCEDURE dbo.addRoom( @Street nvarchar(50), @City nvarchar(50), @ZipCode nvarchar(50), @State nvarchar(50), @Capacity int)
AS BEGIN
	INSERT INTO Room (AddressID, Capacity) 
		VALUES ((SELECT AddressID FROM Address WHERE State=@state AND City=@city AND Street=@Street AND ZipCode=@ZipCode), @Capacity)
END

GO
CREATE PROCEDURE dbo.addVendorTable( @Room# int, @UserID int)
AS BEGIN
	IF EXISTS(SELECT * FROM LinkerUserToRole WHERE UserID=@UserID AND RoleID=3)
	BEGIN
		INSERT INTO VendorTable (UserID,Room#) VALUES (@UserID,@Room#)
	END
END

GO
CREATE PROCEDURE dbo.addTrack (@Category nvarchar(50))
AS BEGIN
	INSERT INTO Track (Category) VALUES (@Category)
END

GO
CREATE PROCEDURE dbo.newSQLSaturday( @DateTime DATE, @Street nvarchar(50), @City nvarchar(50), @ZipCode nvarchar(50), @State nvarchar(50), @SQLSaturdayTitle nvarchar(50))
AS BEGIN
	Declare @AddressID int
	IF NOT EXISTS (SELECT AddressID FROM Address WHERE State=@state AND City=@city AND Street=@Street AND ZipCode=@ZipCode)
	BEGIN
		EXEC newAddress @Street, @City, @ZipCode, @State
	END
	Set @AddressID = (SELECT AddressID FROM Address WHERE State=@state AND City=@city AND Street=@Street AND ZipCode=@ZipCode)
	IF NOT EXISTS(SELECT * FROM SQLSaturday WHERE DateTime=@DateTime)
	BEGIN
		INSERT INTO SQLSaturday (DateTime,AddressID,SQLSaturdayTitle) VALUES (@DateTime, @AddressID, @SQLSaturdayTitle)
	END
END

GO
CREATE PROCEDURE dbo.newPerson(@FirstName nvarchar(50), @LastName nvarchar(50), @Street nvarchar(50), @City nvarchar(50), @ZipCode nvarchar(50), @State nvarchar(50), @Email nvarchar(50) )
AS BEGIN
	Declare @AddressID int
	IF NOT EXISTS (SELECT AddressID FROM Address WHERE State=@state AND City=@city AND Street=@Street AND ZipCode=@ZipCode)
	BEGIN
		EXEC newAddress @Street, @City, @ZipCode, @State
	END
	Set @AddressID = (SELECT AddressID FROM Address WHERE State=@state AND City=@city AND Street=@Street AND ZipCode=@ZipCode)
	IF NOT EXISTS(SELECT * FROM Person WHERE FirstName=@FirstName AND LastName=@LastName)
	BEGIN
		INSERT INTO Person (AddressID,FirstName,LastName,Email) VALUES (@AddressID,@FirstName,@LastName,@Email)
	END
END

GO
CREATE PROCEDURE dbo.newOrganizer( @FirstName nvarchar(50), @LastName nvarchar(50), @Title nvarchar(50))
AS BEGIN
	Declare @UserID int
	Set @UserID = (SELECT UserID FROM Person WHERE FirstName=@FirstName AND LastName=@LastName)
	Declare @SQLID int
	Set @SQLID = (SELECT SQLID FROM SQLSaturday WHERE SQLSaturdayTitle=@Title)
	IF NOT EXISTS(SELECT * FROM LinkerUserToRole WHERE UserID=@UserID AND SQLID=@SQLID AND RoleID=2)
	BEGIN
		INSERT INTO LinkerUserToRole (RoleID,UserID,SQLID) VALUES (2,@UserID, @SQLID)
	END
END

GO
CREATE PROCEDURE dbo.newStudent( @FirstName nvarchar(50), @LastName nvarchar(50), @Title nvarchar(50))
AS BEGIN
	Declare @UserID int
	Set @UserID = (SELECT UserID FROM Person WHERE FirstName=@FirstName AND LastName=@LastName)
	Declare @SQLID int
	Set @SQLID = (SELECT SQLID FROM SQLSaturday WHERE SQLSaturdayTitle=@Title)
	IF NOT EXISTS(SELECT * FROM LinkerUserToRole WHERE UserID=@UserID AND SQLID=@SQLID AND RoleID=1)
	BEGIN
		INSERT INTO LinkerUserToRole (RoleID,UserID,SQLID) VALUES (1,@UserID, @SQLID)
	END
END

GO
CREATE PROCEDURE dbo.newVendor( @FirstName nvarchar(50), @LastName nvarchar(50), @Title nvarchar(50))
AS BEGIN
	Declare @UserID int
	Set @UserID = (SELECT UserID FROM Person WHERE FirstName=@FirstName AND LastName=@LastName)
	Declare @SQLID int
	Set @SQLID = (SELECT SQLID FROM SQLSaturday WHERE SQLSaturdayTitle=@Title)
	IF NOT EXISTS(SELECT * FROM LinkerUserToRole WHERE UserID=@UserID AND SQLID=@SQLID AND RoleID=3)
	BEGIN
		INSERT INTO LinkerUserToRole (RoleID,UserID,SQLID) VALUES (3,@UserID, @SQLID)
	END
END

GO
CREATE PROCEDURE dbo.newPresenter( @FirstName nvarchar(50), @LastName nvarchar(50), @Title nvarchar(50))
AS BEGIN
	Declare @UserID int
	Set @UserID = (SELECT UserID FROM Person WHERE FirstName=@FirstName AND LastName=@LastName)
	Declare @SQLID int
	Set @SQLID = (SELECT SQLID FROM SQLSaturday WHERE SQLSaturdayTitle=@Title)
	IF NOT EXISTS(SELECT * FROM LinkerUserToRole WHERE UserID=@UserID AND SQLID=@SQLID AND RoleID=4)
	BEGIN
		INSERT INTO LinkerUserToRole (RoleID,UserID,SQLID) VALUES (4,@UserID, @SQLID)
	END
END

GO
CREATE PROCEDURE dbo.newVolunteer( @FirstName nvarchar(50), @LastName nvarchar(50), @Title nvarchar(50))
AS BEGIN
	Declare @UserID int
	Set @UserID = (SELECT UserID FROM Person WHERE FirstName=@FirstName AND LastName=@LastName)
	Declare @SQLID int
	Set @SQLID = (SELECT SQLID FROM SQLSaturday WHERE SQLSaturdayTitle=@Title)
	IF NOT EXISTS(SELECT * FROM LinkerUserToRole WHERE UserID=@UserID AND SQLID=@SQLID AND RoleID=5)
	BEGIN
		INSERT INTO LinkerUserToRole (RoleID,UserID,SQLID) VALUES (5,@UserID, @SQLID)
	END
END



GO
CREATE PROCEDURE dbo.approveLecture( @LectureTitle nvarchar(50), @SQLTitle nvarchar(50))
AS BEGIN
	Declare @SQLID int
	Set @SQLID = (SELECT SQLID FROM SQLSaturday WHERE SQLSaturdayTitle=@SQLTitle)
	Declare @LectureID int
	Set @LectureID = (SELECT LectureID FROM Lecture WHERE Title=@LectureTitle)
	Update Lecture SET Approval = 1 WHERE LectureID = @LectureID AND SQLID=@SQLID
END

GO
CREATE PROCEDURE dbo.SetTrackLecture( @LectureTitle nvarchar(50), @SQLTitle nvarchar(50), @TrackTopic nvarchar(50))
AS BEGIN
	Declare @SQLID int
	Set @SQLID = (SELECT SQLID FROM SQLSaturday WHERE SQLSaturdayTitle=@SQLTitle)
	Declare @LectureID int
	Set @LectureID = (SELECT LectureID FROM Lecture WHERE Title=@LectureTitle)
	Declare @TrackID int
	Set @TrackID = (SELECT TrackID FROM Track WHERE Category=@TrackTopic)
	Update Lecture SET TrackID = @TrackID WHERE LectureID = @LectureID AND SQLID=@SQLID
END

GO
CREATE PROCEDURE dbo.SetLectureToEvent( @LectureTitle nvarchar(50), @SQLTitle nvarchar(50))
AS BEGIN
	Declare @SQLID int
	Set @SQLID = (SELECT SQLID FROM SQLSaturday WHERE SQLSaturdayTitle=@SQLTitle)
	Declare @LectureID int
	Set @LectureID = (SELECT LectureID FROM Lecture WHERE Title=@LectureTitle)
	Update Lecture SET SQLID = @SQLID WHERE LectureID = @LectureID AND SQLID IS NULL
END

GO
CREATE PROCEDURE dbo.addLectureTime( @LectureTitle nvarchar(50), @SQLTitle nvarchar(50), @StartTime time, @EndTime time)
AS BEGIN
	Declare @SQLID int
	Set @SQLID = (SELECT SQLID FROM SQLSaturday WHERE SQLSaturdayTitle=@SQLTitle)
	Declare @LectureID int
	Set @LectureID = (SELECT LectureID FROM Lecture WHERE Title=@LectureTitle)
	Update Lecture SET StartTime=@StartTime,EndTime=@EndTime WHERE LectureID = @LectureID AND SQLID=@SQLID
END

GO
CREATE PROCEDURE dbo.addLectureRoom( @LectureTitle nvarchar(50), @SQLTitle nvarchar(50), @Room# int)
AS BEGIN
	Declare @SQLID int
	Set @SQLID = (SELECT SQLID FROM SQLSaturday WHERE SQLSaturdayTitle=@SQLTitle)
	Declare @LectureID int
	Set @LectureID = (SELECT LectureID FROM Lecture WHERE Title=@LectureTitle)
	Update Lecture SET Room#=@Room# WHERE LectureID = @LectureID AND SQLID=@SQLID
END

GO
CREATE PROCEDURE dbo.addLectureDescription( @LectureTitle nvarchar(50), @SQLTitle nvarchar(50), @Description nvarchar(50))
AS BEGIN
	Declare @SQLID int
	Set @SQLID = (SELECT SQLID FROM SQLSaturday WHERE SQLSaturdayTitle=@SQLTitle)
	Declare @LectureID int
	Set @LectureID = (SELECT LectureID FROM Lecture WHERE Title=@LectureTitle)
	Update Lecture SET Description=@Description WHERE LectureID = @LectureID AND SQLID=@SQLID
END

GO
CREATE PROCEDURE dbo.addSchedule(@LectureTitle nvarchar(50), @Name nvarchar(50))
AS BEGIN
	Declare @LectureID int
	Set @LectureID = (SELECT LectureID FROM Lecture WHERE Title=@LectureTitle)
	Declare @UserID int
	Set @UserID = (SELECT UserID FROM Person WHERE FirstName=left(@Name, CHARINDEX(' ', @Name)) AND LastName=substring(@Name, CHARINDEX(' ', @Name)+1, len(@Name)-(CHARINDEX(' ', @Name)-1)))
	IF EXISTS(SELECT * FROM LinkerUserToRole WHERE UserID=@UserID AND RoleID=1)
	BEGIN
		DECLARE @ST time
		DECLARE @ET time
		Set @ST =(SELECT StartTime FROM Lecture WHERE LectureID=@LectureID)
		Set @ET =(SELECT EndTime FROM Lecture WHERE LectureID=@LectureID)
		IF NOT EXISTS(SELECT * FROM Lecture WHERE StartTime NOT BETWEEN @ST AND @ET AND EndTime NOT BETWEEN @ST AND @ET)
		BEGIN
			INSERT INTO StudentSchedule (LectureID,UserID) VALUES (@LectureID, @UserID)
		END
	END
END

GO
CREATE PROCEDURE dbo.addGrade(@LectureTitle nvarchar(50), @GradeID int)
AS BEGIN
	Declare @LectureID int
	Set @LectureID = (SELECT LectureID FROM Lecture WHERE Title=@LectureTitle)
	INSERT INTO LectureGrade (LectureID,GradeID) VALUES (@LectureID, @GradeID)	
END

GO
CREATE PROCEDURE dbo.LectureInTrack(@TrackTopic nvarchar(50))
AS 
	Declare @TrackID int
	Set @TrackID = (SELECT TrackID FROM Track WHERE Category=@TrackTopic)
	SELECT * FROM Lecture WHERE TrackID=@TrackID
GO


GO
CREATE PROCEDURE dbo.getStudentEmail(@Location nvarchar(50))
AS 
	SELECT FirstName, LastName, Email FROM Person WHERE UserID IN (SELECT UserID FROM LinkerUserToRole WHERE RoleID=1)
GO

GO
CREATE PROCEDURE dbo.getAllStudent(@Location nvarchar(50))
AS 
	SELECT FirstName, LastName, Email FROM Person WHERE UserID IN (SELECT UserID FROM LinkerUserToRole WHERE RoleID=1)
GO

GO
CREATE PROCEDURE dbo.getAllOrganizer(@Location nvarchar(50))
AS 
	SELECT FirstName, LastName, Email FROM Person WHERE UserID IN (SELECT UserID FROM LinkerUserToRole WHERE RoleID=2)
GO

GO
CREATE PROCEDURE dbo.getAllVendor(@Location nvarchar(50))
AS 
	SELECT FirstName, LastName, Email FROM Person WHERE UserID IN (SELECT UserID FROM LinkerUserToRole WHERE RoleID=3)
GO

GO
CREATE PROCEDURE dbo.getAllPresenter(@Location nvarchar(50))
AS 
	SELECT FirstName, LastName, Email FROM Person WHERE UserID IN (SELECT UserID FROM LinkerUserToRole WHERE RoleID=4)
GO

GO
CREATE PROCEDURE dbo.getAllVolunteer(@Location nvarchar(50))
AS 
	SELECT FirstName, LastName, Email FROM Person WHERE UserID IN (SELECT UserID FROM LinkerUserToRole WHERE RoleID=5)
GO






