-- 6) Create internal SQL Server tables for Course and Enrollment to load data
-- Note the hash distribution
if (object_id('dbo.CourseMaster') is NOT NULL)
	begin
	drop table dbo.CourseMaster;
	end
go
CREATE TABLE dbo.CourseMaster 
  (
    Course_Id varchar(100) NOT NULL, 
    Name varchar(100) NULL,
    Type varchar(100) NULL,
	Created_At datetime NOT NULL,
	StartAt varchar(100) NULL,
	ConcludeAt varchar(100) NULL,
	Wiki_Id varchar(100) NULL
  )
WITH
  ( 
    DISTRIBUTION = HASH (Course_Id), 
    CLUSTERED COLUMNSTORE INDEX
  );
go

-- 7) Truncate the internal table and load all the records from external table
-- Since the table is already created, use “insert t-sql” to load the data
truncate table dbo.CourseMaster;
go
set nocount on;
insert into dbo.CourseMaster
SELECT distinct
Id, Name, Type,
convert(smalldatetime,
substring(CreatedAt, 1, 4) + '-' + substring(CreatedAt, 6, 2) + '-' + substring(CreatedAt, 9, 2)
) as Created_At, StartAt, ConcludeAt, Wiki_Id
FROM 
	dbo.CourseDimExternal
where Id != 'Id'
AND isDate(substring(CreatedAt, 1, 4) + '-' + substring(CreatedAt, 6, 2) + '-' + substring(CreatedAt, 9, 2)) = 1

SELECT * FROM dbo.CourseMaster

---- Follow the same procedure for Enrollments too 
if (object_id('dbo.EnrollmentMaster') is NOT NULL)
	begin
	drop table dbo.EnrollmentMaster;
	end
go
CREATE TABLE dbo.EnrollmentMaster 
  (
    Enrollment_Id varchar(100) NOT NULL,
	Type varchar(50) NULL,
    User_Id varchar(50) NULL,
	Course_Id varchar(50) NULL,
	Created_At datetime NULL,
	Computed_Final_Score decimal(12,4) NULL
  )
WITH
  ( 
    DISTRIBUTION = HASH (Enrollment_Id), 
    CLUSTERED COLUMNSTORE INDEX
  );
go

truncate table dbo.EnrollmentMaster;
go
set nocount on;
insert into dbo.EnrollmentMaster
SELECT distinct
Id, ed.Type, ed.User_Id, --ef.User_id,
ed.Course_Id, --ef.Course_id,
convert(smalldatetime,
substring(CreatedAt, 1, 4) + '-' + substring(CreatedAt, 6, 2) + '-' + substring(CreatedAt, 9, 2)
) as Created_At,
case when (ef.Computed_Final_Score = '\N') then NULL else ef.Computed_Final_Score end
FROM 
	dbo.EnrollmentDimExternal ed inner join dbo.EnrollmentFactExternal ef on (ed.Id = ef.Enrollment_Id)
where Id != 'Id'
AND isDate(substring(CreatedAt, 1, 4) + '-' + substring(CreatedAt, 6, 2) + '-' + substring(CreatedAt, 9, 2)) = 1

SELECT * FROM dbo.EnrollmentMaster;


