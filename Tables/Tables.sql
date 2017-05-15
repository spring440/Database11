create table dbo.Address (
	AddressID int NOT NULL Identity(1,1) UNIQUE,
	State nvarchar(50) NOT NULL,
	City nvarchar(50) NOT NULL,
	Street nvarchar(150) NOT NULL,
	ZipCode nvarchar(50) NOT NULL,
	PRIMARY KEY(AddressID)
)

create table dbo.SQLSaturday (
	SQLID int NOT NULL Identity UNIQUE,
	DateTime DATE DEFAULT CONVERT (date, SYSDATETIME()),
	AddressID int NOT NULL,
	SQLSaturdayTitle nvarchar(50) DEFAULT 'SQL Saturday',
	PRIMARY KEY(SQLID),
	CONSTRAINT fk_SQLSaturday_AddressID FOREIGN KEY(AddressID) REFERENCES Address (AddressID),
);

create table dbo.Room (
	Room# int NOT NULL Identity UNIQUE,
	Capacity int Default 30,
	AddressID int NOT NULL,
	PRIMARY KEY(Room#),
	CONSTRAINT fk_Room_AddressID FOREIGN KEY(AddressID) REFERENCES Address (AddressID),
);

create table dbo.Person (
	UserID int NOT NULL Identity(1,1) UNIQUE,	
	FirstName nvarchar(50) NOT NULL,
	LastName nvarchar(50) NOT NULL,
	AddressID int NOT NULL,
	Email varchar(320),
	PRIMARY KEY(UserID),
	CONSTRAINT fk_Person_AddressID FOREIGN KEY(AddressID) REFERENCES Address (AddressID)
)

create table dbo.VendorTable (
	TableID int NOT NULL Identity UNIQUE,
	UserID int NOT NULL,
	Room# int NOT NULL,
	PRIMARY KEY(TableID),
	CONSTRAINT fk_VendorTable_AddressID FOREIGN KEY(Room#) REFERENCES Room (Room#),
	CONSTRAINT fk_VendorTable_UserID FOREIGN KEY(UserID) REFERENCES Person (UserID)
);

create table Role (
	RoleID int Identity UNIQUE NOT NULL,
	RoleTitle nvarchar(50) NOT NULL,
	PRIMARY KEY(RoleID)
)

create table dbo.Track(
	TrackID int NOT NULL Identity UNIQUE,
	Category nvarchar(50),
	PRIMARY KEY (TrackID)
);

create table dbo.Difficulty(
	DifficultyID int NOT NULL Identity UNIQUE,
	DifficultyLevel nvarchar(50),
	PRIMARY KEY (DifficultyID)
);

create table dbo.Lecture (
	LectureID int NOT NULL Identity UNIQUE,
	SQLID int,
	Title nvarchar(50) NOT NULL,
	StartTime time,
	EndTime time,
	Description nvarchar(50),
	DifficultyID int DEFAULT 2,
	TrackID int,	
	Approval bit DEFAULT 0,
	Room# int,
	PRIMARY KEY (LectureID),
	CONSTRAINT fk_Lecture_Room# FOREIGN KEY(Room#) REFERENCES Room (Room#),
	CONSTRAINT fk_Lecture_DifficultyID FOREIGN KEY(DifficultyID) REFERENCES Difficulty (DifficultyID),
	CONSTRAINT fk_Lecture_TrackID FOREIGN KEY(TrackID) REFERENCES Track (TrackID),
	CONSTRAINT fk_Lecture_SQLID FOREIGN KEY(SQLID) REFERENCES SQLSaturday (SQLID)
);

create table dbo.StudentSchedule (
	ScheduleID int identity UNIQUE NOT NULL,
	LectureID int NOT NULL,
	UserID int NOT NULL,
	CONSTRAINT fk_StudentSchedule_LectureID FOREIGN KEY(LectureID) REFERENCES Lecture (LectureID),
	CONSTRAINT fk_StudentSchedule_UserID FOREIGN KEY(UserID) REFERENCES Person (UserID)
)

create table dbo.Grade (
	GradeID int identity UNIQUE NOT NULL,
	Grade nvarchar(50) NOT NULL,
	PRIMARY KEY(GradeID)
)

create table dbo.LectureGrade (
	GradeID int NOT NULL,
	LectureID int NOT NULL,
	CONSTRAINT fk_LectureGrade_LectureID FOREIGN KEY(LectureID) REFERENCES Lecture (LectureID),
	CONSTRAINT fk_LectureGrade_GradeID FOREIGN KEY(GradeID) REFERENCES Grade (GradeID)
)

create table dbo.LinkerUserToRole (
	UserID int NOT NULL,
	RoleID int NOT NULL,
	SQLID int NOT NULL,
	CONSTRAINT fk_LinkerUserToRole_UserID FOREIGN KEY(UserID) REFERENCES Person (UserID),
	CONSTRAINT fk_LinkerUserToRole_RoleID FOREIGN KEY(RoleID) REFERENCES Role (RoleID),
	CONSTRAINT fk_LinkerUserToRole_SQLID FOREIGN KEY(SQLID) REFERENCES SQLSaturday (SQLID)
);

create table dbo.LinkerLectureToPresenter (
	LectureID int NOT NULL,
	UserID int NOT NULL,
	CONSTRAINT fk_LinkerLectureToPresenter_LectureID FOREIGN KEY(LectureID) REFERENCES Lecture (LectureID),
	CONSTRAINT fk_LinkerLectureToPresenter_UserID FOREIGN KEY(UserID) REFERENCES Person (UserID)
);

