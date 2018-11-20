COPY videos FROM 'C:\workspace\killrvideo-cdm\data\videos.csv' WITH HEADER=true;

SELECT * FROM videos LIMIT 10;
SELECT COUNT(*) FROM videos;
SELECT * FROM videos WHERE video_id = 6c4cffb9-0dc4-1d59-af24-
c960b5fc3652;