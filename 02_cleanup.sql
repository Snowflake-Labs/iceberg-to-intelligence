-- CLEANUP: Run this to reset the demo environment to starting point
-- Does NOT reset the setup from role_db.sql

USE ROLE avalanche_admin;
USE WAREHOUSE compute_wh;

-- Drop the dynamic Iceberg table and semantic view
DROP DYNAMIC TABLE IF EXISTS avalanche_db.marketing.sanitized_campaign_events;

DROP SEMANTIC VIEW IF EXISTS avalanche_db.marketing.campaign_analytics;
