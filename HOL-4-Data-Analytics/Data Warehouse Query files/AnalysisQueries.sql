--check the type of enrollments
select distinct(type) from [dbo].[EnrollmentMaster]

--Student count
select count(*) as StudentCount from [dbo].[EnrollmentMaster] where type = 'StudentEnrollment'

--Teacher count
select count(*) as TeacherCount from [dbo].[EnrollmentMaster] where type = 'TeacherEnrollment' 

--Count of Students with grades under 70
select count(*) as StudentGradesUnder70 from [dbo].[EnrollmentMaster] 
where type = 'StudentEnrollment' and Computed_Final_Score < 0.7 and Computed_Final_Score is not null

--Percentage of Students with grades under 70
select (100*count(*)/(select count(*) from [dbo].[EnrollmentMaster] where type = 'StudentEnrollment' and Computed_Final_Score is not null)) as Percentage 
from [dbo].[EnrollmentMaster] 
where type = 'StudentEnrollment' and Computed_Final_Score < 0.7 and Computed_Final_Score is not null

