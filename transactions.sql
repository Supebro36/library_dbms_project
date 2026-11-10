-- ====== 5 ========
-- write a 'borrow a book' transaction that reduces available copies.

select books_id,title,total_copies, available_copies 
FROM books
WHERE books_id=2;

BEGIN;

SELECT available_copies FROM books WHERE books_id=2 FOR UPDATE ;

UPDATE books
SET available_copies=available_copies-1
WHERE books_id=2
AND available_copies>0;

INSERT INTO borrowings(books_id,member_id,borrow_date,due_date)
VALUES(2,1, CURRENT_DATE,CURRENT_DATE + 14);

COMMIT;

SELECT books_id, title, total_copies, available_copies FROM books WHERE books_id = 2;
SELECT * FROM borrowings ORDER BY borrowing_id DESC LIMIT 1;
