
-- 5) Create external tables for courses and enrollments
if (object_id('dbo.CourseDimExternal') is NOT NULL)
	begin
	drop external table dbo.CourseDimExternal;
	end
go
CREATE EXTERNAL TABLE dbo.CourseDimExternal (
    Id varchar(100) NOT NULL, 
    Name varchar(100) NULL,
    Type varchar(100) NULL,
	CreatedAt varchar(100) NULL,
	StartAt varchar(100) NULL,
	ConcludeAt varchar(100) NULL,
	Wiki_Id varchar(100) NULL
)
WITH (
    LOCATION='coursedim/', 
    DATA_SOURCE=AzureStorageInstructurePoc, 
    FILE_FORMAT=TextFileTab,
	REJECT_TYPE = Value,
	REJECT_VALUE = 100000
);
Go

SELECT * FROM dbo.CourseDimExternal;
Go



if (object_id('dbo.EnrollmentDimExternal') is NOT NULL)
	begin
	drop external table dbo.EnrollmentDimExternal;
	end
go
CREATE EXTERNAL TABLE dbo.EnrollmentDimExternal (
    Id varchar(100) NOT NULL, 
    Type varchar(100) NULL,
	Workflow_State varchar(100) NULL,
	CreatedAt varchar(100) NULL,
	UpdatedAt varchar(100) NULL,
	StartAt varchar(100) NULL,
	EndAt varchar(100) NULL,
	ConcludeAt varchar(100) NULL,
	Course_Id varchar(100) NULL,
	User_Id varchar(100) NULL
)
WITH (
    LOCATION='enrollmentdim/', 
    DATA_SOURCE=AzureStorageInstructurePoc, 
    FILE_FORMAT=TextFileTab
);
go

SELECT * FROM dbo.EnrollmentDimExternal;
go



if (object_id('dbo.EnrollmentFactExternal') is NOT NULL)
	begin
	drop external table dbo.EnrollmentFactExternal;
	end
go
CREATE EXTERNAL TABLE dbo.EnrollmentFactExternal (
    Enrollment_Id varchar(100) NOT NULL,
	User_Id varchar(100) NULL,
	Course_Id varchar(100) NULL,
	Computed_Final_Score varchar(100) NULL
)
WITH (
    LOCATION='enrollmentfact/', 
    DATA_SOURCE=AzureStorageInstructurePoc, 
    FILE_FORMAT=TextFileTab
);
Go

SELECT count(*) FROM dbo.EnrollmentFactExternal;
go

