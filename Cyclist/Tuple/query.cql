CREATE TABLE IF NOT EXISTS cycling.collect_things (
  k int PRIMARY KEY,
  v tuple<int, text, float>
);

INSERT INTO cycling.collect_things (k, v) VALUES(0, (3, 'bar', 2.1));

SELECT * FROM cycling.collect_things;