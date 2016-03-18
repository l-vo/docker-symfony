-- SQL statements required for runnning the application (database(s), user(s), table(s) creations...) 
-- Statements executed only on the first run of the mysql container 
SET PASSWORD FOR root@'%' = PASSWORD('');
