-- CLEANUP: Run this to reset the demo environment

USE ROLE avalanche_admin;
USE WAREHOUSE compute_wh;

-- Drop the database with the dynamic Iceberg table and semantic view
DROP DATABASE IF EXISTS avalanche_db;

-- Drops the catalog-linked database
DROP DATABASE IF EXISTS blizzard_data;
