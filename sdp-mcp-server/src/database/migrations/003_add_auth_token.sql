-- Add auth_token_encrypted to oauth_configs table
ALTER TABLE oauth_configs ADD COLUMN auth_token_encrypted TEXT NULL;
