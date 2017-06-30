--- Opened book count
SELECT opened_book_count();

--- Read book count
SELECT read_count(); --- No finished books

UPDATE book_reader
SET current_page = 771
WHERE book_reader_id = 3; --- Moving to last page

UPDATE book_reader
SET current_page = 772
WHERE book_reader_id = 3; --- Moving to the end of book

SELECT read_count(); --- One finished book

--- Moving books from genre and deleting
SELECT delete_and_move(100, 5); --- Exception
SELECT delete_and_move(5, 100); --- Exception
SELECT delete_and_move(1, 2); --- Exception
SELECT delete_and_move(2, 1); --- Successfully moved from 2 to 1
