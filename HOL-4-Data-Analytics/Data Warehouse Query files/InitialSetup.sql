-- 1) Create a master key.
-- Only necessary if one does not already exist.
-- Required to encrypt the credential secret in the next step.
CREATE MASTER KEY;


-- 2) Create a database scoped credential
-- IDENTITY: Provide any string, it is not used for authentication to Azure storage.
-- SECRET: Storage API Key to the Centralized Storage Account
CREATE DATABASE SCOPED CREDENTIAL AzureStorageCredentialsInstructurePoc
WITH 
    IDENTITY = 'user', 
    SECRET = '2NX7xVaHL2ZQTPc0tBdIOxpz18zyMudmAlLNxECjFSE01M5551XcWgRIPzpiTHhEvHeTUEj8Z72Oh4XpqAdoYA==';
GO
SELECT * FROM SYS.DATABASE_CREDENTIALS;
GO


-- 3) Create an External Data Source
-- LOCATION: WASB (Blob) location
-- CREDENTIAL: Auth created above
CREATE EXTERNAL DATA SOURCE AzureStorageInstructurePoc
WITH (  
    TYPE = Hadoop, 
    LOCATION = 'wasbs://load@p20xdatastorage.blob.core.windows.net',
    CREDENTIAL = AzureStorageCredentialsInstructurePoc
);
GO
SELECT *FROM SYS.EXTERNAL_DATA_SOURCES;
GO


-- 4) Create a comma delimted file format
-- FORMAT_OPTIONS: comma delimated with string delimiters
CREATE EXTERNAL FILE FORMAT TextFileTab
WITH (
    FORMAT_TYPE = DelimitedText, 
    FORMAT_OPTIONS (FIELD_TERMINATOR = '\t')
);
GO
SELECT * FROM SYS.EXTERNAL_FILE_FORMATS;
GO