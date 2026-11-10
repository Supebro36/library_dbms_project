-- ===== 4 ======

-- Books by given auhtor 

SELECT b.books_id,
b.title,
b.genre,
b.publication_year
FROM books b
JOIN book_authors ba ON ba.book_id   = b.books_id
JOIN authors a       ON a.author_id  = ba.author_id
WHERE a.first_name = 'Terry'
AND a.last_name  = 'Pratchett'
ORDER BY b.publication_year;

-- Members with overdue books

SELECT m.member_id,
m.full_name,
m.email,
b.title,
br.due_date,
CURRENT_DATE - br.due_date AS days_overdue
FROM borrowings br
JOIN members m ON m.member_id = br.member_id
JOIN books   b ON b.books_id   = br.books_id
WHERE br.return_date IS NULL
AND br.due_date < CURRENT_DATE
ORDER BY days_overdue DESC;

-- Top 3 most-borrowed books

SELECT b.books_id,
b.title,
COUNT(*) AS times_borrowed
FROM books b
JOIN borrowings br ON br.books_id = b.books_id
GROUP BY b.books_id, b.title
ORDER BY times_borrowed DESC, b.title
LIMIT 3;

-- Members who have never borrowed anything
SELECT m.member_id, m.full_name, m.email, m.membership_status
FROM members m
LEFT JOIN borrowings br ON br.member_id = m.member_id
WHERE br.borrowing_id IS NULL
ORDER BY m.member_id;