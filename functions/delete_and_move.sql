CREATE OR REPLACE FUNCTION delete_and_move(delete_id INTEGER, move_to_id INTEGER)
  RETURNS VOID
  AS $$
    BEGIN
      IF (SELECT count(*) FROM genre WHERE genre_id = delete_id) = 0
      THEN RAISE EXCEPTION 'Genre to delete does not exist.';
      ELSIF (SELECT count(*) FROM genre WHERE genre_id = move_to_id) = 0
      THEN RAISE EXCEPTION 'Genre to move data from deleted does not exist.';
      ELSIF (SELECT count(*) FROM genre WHERE parent_genre = delete_id) > 0
      THEN RAISE EXCEPTION 'Genre to delete has child genres.';
      END IF;

      UPDATE book_genre
      SET genre_id = move_to_id
      WHERE genre_id = delete_id;

      DELETE FROM genre WHERE genre_id = delete_id;
    END;
  $$
LANGUAGE plpgsql;