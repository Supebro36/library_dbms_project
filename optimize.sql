-- ====== 6 ======
DROP TABLE IF EXISTS borrowings_perf;

CREATE TABLE borrowings_perf AS
SELECT g AS borrowing_id,
(random() * 19999)::int + 1 AS member_id
FROM generate_series(1, 500000) AS g;

EXPLAIN ANALYZE
SELECT * FROM borrowings_perf WHERE member_id = 4242;

CREATE INDEX idx_perf_member_id ON borrowings_perf (member_id);

EXPLAIN ANALYZE
SELECT * FROM borrowings_perf WHERE member_id = 4242;

DROP TABLE borrowings_perf;

CREATE INDEX IF NOT EXISTS idx_borrowings_member_id ON borrowings (member_id);
CREATE INDEX IF NOT EXISTS idx_borrowings_books_id   ON borrowings (books_id);
CREATE INDEX IF NOT EXISTS idx_book_authors_author  ON book_authors (author_id);