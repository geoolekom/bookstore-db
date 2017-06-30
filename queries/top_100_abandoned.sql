SELECT book.title, count(*) as abandoned_count
FROM
  book
  JOIN book_reader ON book.book_id = book_reader.book_id
                      AND opened IS FALSE
                      AND ended_at IS NULL
GROUP BY book.book_id
ORDER BY abandoned_count DESC
LIMIT 100;