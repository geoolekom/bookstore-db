CREATE TABLE book (
  book_id SERIAL PRIMARY KEY,
  title VARCHAR(100) NOT NULL,
  pub_year DATE,
  page_count INTEGER NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX ON book USING BTREE (created_at);

CREATE TABLE genre (
  genre_id SERIAL PRIMARY KEY,
  parent_genre INTEGER REFERENCES genre (genre_id),
  name VARCHAR(100) NOT NULL
);

CREATE TABLE book_genre (
  book_genre_id SERIAL PRIMARY KEY,
  book_id INTEGER REFERENCES book (book_id),
  genre_id INTEGER REFERENCES genre (genre_id)
);

CREATE INDEX ON book_genre USING BTREE (genre_id);

CREATE TABLE author (
  author_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE book_author (
  book_author_id SERIAL PRIMARY KEY,
  book_id INTEGER REFERENCES book (book_id),
  author_id INTEGER REFERENCES author (author_id)
);

CREATE TABLE reader (
  reader_id SERIAL PRIMARY KEY,
  username VARCHAR(50) NOT NULL,
  password CHAR(128) NOT NULL
);

CREATE TABLE book_reader (
  book_reader_id SERIAL PRIMARY KEY,
  book_id INTEGER REFERENCES book (book_id),
  reader_id INTEGER REFERENCES reader (reader_id),
  current_page INTEGER DEFAULT 1,
  started_at DATE DEFAULT now(),
  ended_at DATE,
  opened BOOLEAN DEFAULT TRUE
);

CREATE INDEX ON book_reader USING BTREE (book_id);

CREATE OR REPLACE FUNCTION set_end_date()
  RETURNS TRIGGER
  AS $$
  BEGIN
    IF EXISTS (SELECT page_count FROM book WHERE book_id = OLD.book_id AND page_count = OLD.current_page)
      THEN
        RAISE NOTICE 'Triggered';
        NEW.ended_at := now()::DATE;
    END IF;
    RETURN NEW;
  END;
  $$
LANGUAGE plpgsql;

CREATE TRIGGER read_count_update
  BEFORE UPDATE OF current_page
  ON book_reader
  FOR EACH ROW
  EXECUTE PROCEDURE set_end_date();
