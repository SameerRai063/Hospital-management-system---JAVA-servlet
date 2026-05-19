-- Migration: Add full_name column to users and backfill from name
-- File: database/V1__add_full_name.sql
-- Recommended: BACK UP your database before running this migration.

-- 1) Check if the column already exists (optional to run manually):
-- SHOW COLUMNS FROM users LIKE 'full_name';

-- 2) Add the full_name column if it does not exist, and ensure it has a safe default.
-- This handles three cases:
--  - column missing -> it will be created with a default value
--  - column exists but has no default (STRICT mode error) -> MODIFY will set a default
--  - column exists and already has a default -> MODIFY is safe and idempotent

ALTER TABLE users
  ADD COLUMN IF NOT EXISTS full_name VARCHAR(255) DEFAULT '';

-- Ensure column has a non-NULL default to avoid "Field 'full_name' doesn't have a default value" errors
ALTER TABLE users
  MODIFY COLUMN full_name VARCHAR(255) NOT NULL DEFAULT '';

-- 3) Backfill full_name from name for existing rows (only update empty/null full_name)
UPDATE users
SET full_name = name
WHERE full_name IS NULL OR full_name = '';

-- 4) (Optional) Create triggers to keep full_name in sync with name on INSERT/UPDATE.
--    Use the delimiters if running in a mysql client or Workbench SQL tab.

-- DELIMITER //
-- CREATE TRIGGER trg_users_before_insert
-- BEFORE INSERT ON users
-- FOR EACH ROW
-- BEGIN
--   IF NEW.full_name IS NULL OR NEW.full_name = '' THEN
--     SET NEW.full_name = NEW.name;
--   END IF;
-- END;
-- //
-- DELIMITER ;

-- DELIMITER //
-- CREATE TRIGGER trg_users_before_update
-- BEFORE UPDATE ON users
-- FOR EACH ROW
-- BEGIN
--   IF NEW.name <> OLD.name THEN
--     SET NEW.full_name = NEW.name;
--   END IF;
-- END;
-- //
-- DELIMITER ;

-- 5) (Optional) Make full_name NOT NULL only after verifying the backfill succeeded
-- ALTER TABLE users MODIFY COLUMN full_name VARCHAR(255) NOT NULL;

-- 6) Verification query (run after migration):
-- SELECT id, name, full_name, email FROM users LIMIT 50;

