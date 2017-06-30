CREATE OR REPLACE FUNCTION opened_book_count()
  RETURNS BIGINT
  AS $$
  SELECT count(*) FROM book_reader WHERE opened IS TRUE;
  $$
LANGUAGE sql;