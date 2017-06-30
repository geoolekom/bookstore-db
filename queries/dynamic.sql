CREATE OR REPLACE TEMPORARY VIEW dynamic (day, added_count)
AS SELECT
     dates::DATE as day,
     sum(CASE WHEN book.book_id IS NULL THEN 0 ELSE 1 END) as added_count
FROM
  generate_series(now() - '1 month'::INTERVAL, now(), '1 day'::INTERVAL) as dates
  LEFT JOIN book ON created_at::DATE = dates::DATE
GROUP BY dates;

SELECT a.day, a.added_count, a.added_count - b.added_count AS diff
FROM dynamic AS a JOIN dynamic AS b ON a.day = b.day + 1
ORDER BY a.day DESC;
