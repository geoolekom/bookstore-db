SELECT book.title, count(*) OVER (PARTITION BY book.book_id) as read_count
FROM
  book
  JOIN book_reader ON book.book_id = book_reader.book_id AND opened IS FALSE
GROUP BY book.book_id
ORDER BY read_count DESC
LIMIT 100;
