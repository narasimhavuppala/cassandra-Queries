
COPY videos_by_title_year (title, added_year, added_date,
description, user_id, video_id) FROM 'C:\workspace\killrvideo-cdm\data\videos_by_title_year.csv'
WITH HEADER=true;



COPY users FROM 'C:\workspace\killrvideo-cdm\data\users.csv'
WITH HEADER=true;


COPY user_videos FROM 'C:\workspace\killrvideo-cdm\data\user_videos.csv'
WITH HEADER=true;
