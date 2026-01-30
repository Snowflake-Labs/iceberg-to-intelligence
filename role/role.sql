-- Create a dedicated role for the demo

USE ROLE ACCOUNTADMIN;

-- Create the demo role
CREATE ROLE IF NOT EXISTS AVALANCHE_ADMIN;

-- Grant warehouse usage
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE AVALANCHE_ADMIN;

-- Grant ability to create catalog integrations
GRANT CREATE INTEGRATION ON ACCOUNT TO ROLE AVALANCHE_ADMIN;

-- Grant ability to create external volumes
GRANT CREATE EXTERNAL VOLUME ON ACCOUNT TO ROLE AVALANCHE_ADMIN;

-- Grant ability to create databases (for blizzard_data and avalanche_db)
GRANT CREATE DATABASE ON ACCOUNT TO ROLE AVALANCHE_ADMIN;

SET current_user_name = (SELECT CURRENT_USER());

-- Grant the role to the current user
GRANT ROLE AVALANCHE_ADMIN TO USER IDENTIFIER($current_user_name);

-- Verify grants
SHOW GRANTS TO ROLE AVALANCHE_ADMIN;
