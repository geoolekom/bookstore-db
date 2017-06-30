WITH RECURSIVE full_genre AS (
  SELECT genre_id as original_id, genre_id, parent_genre, genre.name AS name
  FROM genre
    ---
  UNION
    ---
  SELECT original_id, genre.genre_id as genre_id, genre.parent_genre, concat(genre.name, '/', full_genre.name)::VARCHAR(100) AS name
  FROM full_genre INNER JOIN genre ON full_genre.parent_genre = genre.genre_id
  WHERE full_genre.parent_genre IS NOT NULL
) SELECT full_genre.name, count(*) as opened_book_count
FROM
  full_genre JOIN book_genre ON full_genre.original_id = book_genre.genre_id
  JOIN book_reader
      ON book_genre.book_id = book_reader.book_id
         AND opened IS TRUE
         AND age(started_at) < '1 month'::INTERVAL
WHERE opened IS TRUE AND age(started_at) < '1 month'::INTERVAL AND parent_genre IS NULL
GROUP BY full_genre.name
ORDER BY opened_book_count DESC
LIMIT 5;
