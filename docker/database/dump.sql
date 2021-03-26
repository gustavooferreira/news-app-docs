--
-- Create user 'app_client' and grant full access
--
CREATE USER 'app_client'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'app_client'@'%';
