USE ROLE avalanche_admin;
USE WAREHOUSE compute_wh;

-- Create catalog-linked database
CREATE DATABASE IF NOT EXISTS blizzard_data
  LINKED_CATALOG = (
    CATALOG = 'blizzard_glue_catalog'
  );

-- Verify auto-discovery
USE DATABASE blizzard_data;

SHOW SCHEMAS;

USE SCHEMA "blizzard_marketing";

SHOW TABLES;

-- View a sample of the source data
SELECT * FROM "campaign_events" LIMIT 10;

-- Define governance policies before building the pipeline
-- Create masking policy for customer names (full mask)
CREATE OR REPLACE MASKING POLICY avalanche_db.marketing.name_mask
  AS (val STRING) RETURNS STRING ->
  CASE
    WHEN CURRENT_ROLE() IN ('ANALYST') THEN val
    ELSE '********'
  END;

-- Create masking policy for customer emails (partial mask - preserves domain)
CREATE OR REPLACE MASKING POLICY avalanche_db.marketing.email_mask
  AS (val STRING) RETURNS STRING ->
  CASE
    WHEN CURRENT_ROLE() IN ('ANALYST') THEN val
    ELSE REGEXP_REPLACE(val, '.+\\@', '*****@')
  END;

-- Create dynamic Iceberg table with Cortex Code. Redact notes with AI_REDACT:
/*
Create or replace a dynamic Iceberg table avalanche_db.marketing.sanitized_campaign_events from blizzard_data.blizzard_marketing.campaign_events with all columns. 
Apply AI_REDACT to the notes column and name the column "redacted_notes". Set target lag to 8 hours.
*/


-- Apply masking policies to PII columns
ALTER TABLE avalanche_db.marketing.sanitized_campaign_events
  MODIFY COLUMN customer_name SET MASKING POLICY avalanche_db.marketing.name_mask;

ALTER TABLE avalanche_db.marketing.sanitized_campaign_events
  MODIFY COLUMN customer_email SET MASKING POLICY avalanche_db.marketing.email_mask;

-- View governed data (AI_REDACT + masking policies applied)
SELECT
    campaign_name,
    campaign_type,
    event_type,
    customer_name,
    customer_email,
    product_category,
    redacted_notes
FROM
    avalanche_db.marketing.sanitized_campaign_events
WHERE
    redacted_notes IS NOT NULL
    AND redacted_notes != ''
LIMIT
    15;

-- Update the target lag to 3 hours
ALTER DYNAMIC TABLE avalanche_db.marketing.sanitized_campaign_events SET
  TARGET_LAG = '3 hours';
