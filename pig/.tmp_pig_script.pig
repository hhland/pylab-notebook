
-- Use the PigStorage function to load the excite log file into the raw bag as an array of records.
-- Input: (user,time,query) 
raw = LOAD 'tmp/excite-small.log' USING PigStorage('\t') AS (user, time, query);
