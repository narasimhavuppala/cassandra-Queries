CREATE TABLE IF NOT EXISTS cycling.course_page_views (
course_id text,
view_id timeuuid,
PRIMARY KEY (course_id, view_id)
) WITH CLUSTERING ORDER BY (view_id DESC);



INSERT INTO cycling.course_page_views (course_id, view_id)
VALUES ('node-intro', now());

SELECT course_id, dateOf(view_id)
FROM cycling.course_page_views WHERE course_id = 'node-intro';


SELECT course_id,dateOf(view_id)
FROM cycling.course_page_views
WHERE course_id = 'node-intro'
AND view_id >= maxTimeuuid('2018-01-01 00:00+0000')
AND view_id < minTimeuuid('2018-12-01 00:00+0000');