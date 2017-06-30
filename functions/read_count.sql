CREATE OR REPLACE FUNCTION read_count()
  RETURNS BIGINT
  AS $$
    SELECT count(*)
    FROM book_reader
    WHERE opened IS FALSE AND ended_at IS NOT NULL;
  $$
LANGUAGE sql;