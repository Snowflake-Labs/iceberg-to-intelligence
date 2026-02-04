-- Create a dedicated role for the demo

USE ROLE accountadmin;

-- Create the demo role
CREATE ROLE IF NOT EXISTS avalanche_admin; 

-- Grant warehouse usage
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE avalanche_admin;

-- Grant ability to create catalog integrations
GRANT CREATE INTEGRATION ON ACCOUNT TO ROLE avalanche_admin;

-- Grant ability to create external volumes
GRANT CREATE EXTERNAL VOLUME ON ACCOUNT TO ROLE avalanche_admin;

-- Grant ability to create databases (for blizzard_data and avalanche_db)
GRANT CREATE DATABASE ON ACCOUNT TO ROLE avalanche_admin;

SET current_user_name = (SELECT CURRENT_USER());

-- Grant the role to the current user
GRANT ROLE avalanche_admin TO USER IDENTIFIER($current_user_name);

-- Grant access to Marketplace dataset
GRANT IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE_PUBLIC_DATA_CORTEX_KNOWLEDGE_EXTENSIONS TO ROLE avalanche_admin;

-- Verify grants
SHOW GRANTS TO ROLE avalanche_admin;

-- Create database and schema objects ahead of time
USE ROLE avalanche_admin;
CREATE DATABASE IF NOT EXISTS avalanche_db;
CREATE SCHEMA IF NOT EXISTS avalanche_db.marketing;
