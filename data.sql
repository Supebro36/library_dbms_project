-- ==== 2 & 3 =====

-- Inserting authors name in authors tables
INSERT INTO authors (first_name, last_name, country, birth_year) VALUES
('Chinua',    'Achebe',     'Nigeria',     1930),
('Jane',      'Austen',     'UK',          1775), 
('George',    'Orwell',     'UK',          1903),  
('Gabriel',   'García Márquez', 'Colombia', 1927), 
('Haruki',    'Murakami',   'Japan',       1949),  
('Agatha',    'Christie',   'UK',          1890),  
('J.K.',      'Rowling',    'UK',          1965),  
('Toni',      'Morrison',   'USA',         1931),  
('Isaac',     'Asimov',     'USA',         1920),  
('Arundhati', 'Roy',        'India',       1961),  
('Rabindranath','Tagore',   'India',       1861),  
('Chimamanda','Adichie',    'Nigeria',     1977),  
('Stephen',   'King',       'USA',         1947),  
('Paulo',     'Coelho',     'Brazil',      1947),  
('Leo',       'Tolstoy',    'Russia',      1828),  
('Fyodor',    'Dostoevsky', 'Russia',      1821),  
('Margaret',  'Atwood',     'Canada',      1939),  
('Ernest',    'Hemingway',  'USA',         1899),  
('Khaled',    'Hosseini',   'Afghanistan', 1965), 
('Neil',      'Gaiman',     'UK',          1960), 
('Terry',     'Pratchett',  'UK',          1948);  

-- Inserting Members data in members table.

INSERT INTO members (full_name, email, join_date, membership_status) VALUES
('Aarav Sharma',     'aarav.sharma@example.com',     '2024-01-15', 'Active'),     
('Priya Das',        'priya.das@example.com',        '2024-02-10', 'Active'),     
('Rohan Banerjee',   'rohan.banerjee@example.com',   '2024-03-05', 'Active'),     
('Ananya Ghosh',     'ananya.ghosh@example.com',     '2024-04-18', 'Active'),     
('Vikram Singh',     'vikram.singh@example.com',     '2024-05-22', 'Active'),     
('Sneha Mukherjee',  'sneha.mukherjee@example.com',  '2024-06-30', 'Active'),     
('Arjun Reddy',      'arjun.reddy@example.com',      '2024-08-12', 'Active'),    
('Kavya Nair',       'kavya.nair@example.com',        '2024-09-25', 'Active'),    
('Rahul Chatterjee', 'rahul.chatterjee@example.com', '2024-11-03', 'Active'),     
('Meera Iyer',       'meera.iyer@example.com',       '2025-01-08', 'Active'),     
('Sourav Dutta',     'sourav.dutta@example.com',     '2025-02-14', 'Active'),    
('Ishita Roy',       'ishita.roy@example.com',       '2025-04-01', 'Active'),     
('Aditya Verma',     'aditya.verma@example.com',     '2025-06-19', 'Active'),     
('Pooja Sen',        'pooja.sen@example.com',         '2025-09-07', 'Active'),     
('Karan Mehta',      'karan.mehta@example.com',      '2025-10-21', 'Suspend'),  
('Debjani Bose',     'debjani.bose@example.com',     '2026-01-12', 'Active'),     
('Nikhil Kapoor',    'nikhil.kapoor@example.com',    '2026-03-28', 'Active'),    
('Tanvi Joshi',      'tanvi.joshi@example.com',      '2024-07-09', 'Expired');

-- Trunacating cause when ever try to put data in table it id start from 16 not 1.

TRUNCATE borrowings, book_authors, books, authors, members RESTART IDENTITY CASCADE;

SELECT MIN(member_id), MAX(member_id) FROM members; 

ALTER SEQUENCE members_member_id_seq RESTART WITH 1;

-- ---------------- BOOK_AUTHORS (many-to-many links) ----------------
-- Each row below = (first book_id, last book_id, author_id)
INSERT INTO book_authors (book_id, author_id)
SELECT g, r.author_id
FROM (VALUES
    (1,  3,  1),   (4,  7,  2),   (8,  10, 3),   (11, 13, 4),
    (14, 16, 5),   (17, 19, 6),   (20, 22, 7),   (23, 25, 8),
    (26, 28, 9),   (29, 30, 10),  (31, 32, 11),  (33, 35, 12),
    (36, 38, 13),  (39, 40, 14),  (41, 43, 15),  (44, 46, 16),
    (47, 49, 17),  (50, 52, 18),  (53, 55, 19),  (56, 59, 20),
    (60, 62, 21)
) AS r(first_book, last_book, author_id)
CROSS JOIN LATERAL generate_series(r.first_book, r.last_book) AS g;

-- Good Omens (59) also belongs to Terry Pratchett (21)
INSERT INTO book_authors (book_id, author_id) VALUES (59, 21);

-- ---------------- BOOKS (ids 1..62) ----------------
-- available_copies starts equal to total_copies; it is corrected
-- from the borrowings data further below.
INSERT INTO books (title, genre, publication_year, total_copies, available_copies) VALUES
( 'Things Fall Apart',                         'Fiction',          1958, 4, 4),  
( 'No Longer at Ease',                         'Fiction',          1960, 3, 3),  
( 'Arrow of God',                              'Fiction',          1964, 2, 2),  
( 'Pride and Prejudice',                       'Romance',          1813, 5, 5),  
( 'Emma',                                      'Romance',          1815, 3, 3),  
( 'Sense and Sensibility',                     'Romance',          1811, 3, 3),  
( 'Persuasion',                                'Romance',          1817, 2, 2),  
( 'Nineteen Eighty-Four',                      'Dystopian',        1949, 6, 6),  
( 'Animal Farm',                               'Satire',           1945, 5, 5),  
( 'Homage to Catalonia',                       'Memoir',           1938, 2, 2),  
('One Hundred Years of Solitude',             'Magical Realism',  1967, 4, 4),  
('Love in the Time of Cholera',               'Romance',          1985, 3, 3),  
( 'Chronicle of a Death Foretold',             'Fiction',          1981, 2, 2),  
('Norwegian Wood',                            'Fiction',          1987, 4, 4),  
('Kafka on the Shore',                        'Fantasy',          2002, 3, 3),  
( '1Q84',                                      'Fantasy',          2009, 2, 2),  
( 'Murder on the Orient Express',              'Mystery',          1934, 5, 5),  
( 'And Then There Were None',                  'Mystery',          1939, 4, 4),  
( 'The ABC Murders',                           'Mystery',          1936, 3, 3),  
( 'Harry Potter and the Philosopher''s Stone', 'Fantasy',          1997, 8, 8),  
( 'Harry Potter and the Chamber of Secrets',   'Fantasy',          1998, 6, 6),  
( 'Harry Potter and the Prisoner of Azkaban',  'Fantasy',          1999, 6, 6),  
( 'Beloved',                                   'Fiction',          1987, 3, 3),  
( 'Song of Solomon',                           'Fiction',          1977, 2, 2),  
( 'The Bluest Eye',                            'Fiction',          1970, 2, 2),  
( 'Foundation',                                'Science Fiction',  1951, 5, 5),  
( 'I, Robot',                                  'Science Fiction',  1950, 4, 4),  
( 'The Caves of Steel',                        'Science Fiction',  1954, 2, 2),  
( 'The God of Small Things',                   'Fiction',          1997, 4, 4),  
('The Ministry of Utmost Happiness',          'Fiction',          2017, 3, 3), 
( 'Gitanjali',                                 'Poetry',           1910, 3, 3),  
( 'The Home and the World',                    'Fiction',          1916, 2, 2),  
( 'Half of a Yellow Sun',                      'Historical Fiction', 2006, 3, 3),
('Americanah',                                'Fiction',          2013, 4, 4),  
( 'Purple Hibiscus',                           'Fiction',          2003, 2, 2),  
('The Shining',                               'Horror',           1977, 4, 4),  
('It',                                        'Horror',           1986, 3, 3),  
( 'Misery',                                    'Horror',           1987, 2, 2),  
( 'The Alchemist',                             'Fiction',          1988, 6, 6),  
('Eleven Minutes',                            'Fiction',          2003, 2, 2),  
( 'War and Peace',                             'Historical Fiction', 1869, 3, 3),
( 'Anna Karenina',                             'Fiction',          1878, 3, 3),  
( 'The Death of Ivan Ilyich',                  'Fiction',          1886, 2, 2),  
( 'Crime and Punishment',                      'Fiction',          1866, 4, 4), 
( 'The Brothers Karamazov',                    'Fiction',          1880, 3, 3),  
( 'Notes from Underground',                    'Fiction',          1864, 2, 2),  
( 'The Handmaid''s Tale',                      'Dystopian',        1985, 5, 5),  
( 'Oryx and Crake',                            'Science Fiction',  2003, 2, 2),  
( 'Alias Grace',                               'Historical Fiction', 1996, 2, 2),
( 'The Old Man and the Sea',                   'Fiction',          1952, 4, 4),  
( 'A Farewell to Arms',                        'Fiction',          1929, 3, 3),  
('For Whom the Bell Tolls',                   'Fiction',          1940, 2, 2),  
( 'The Kite Runner',                           'Fiction',          2003, 5, 5),  
('A Thousand Splendid Suns',                  'Fiction',          2007, 4, 4),  
('And the Mountains Echoed',                  'Fiction',          2013, 2, 2),  
('American Gods',                             'Fantasy',          2001, 3, 3),  
( 'Coraline',                                  'Fantasy',          2002, 3, 3), 
('Neverwhere',                                'Fantasy',          1996, 2, 2),  
('Good Omens',                                'Fantasy',          1990, 4, 4),  
( 'Small Gods',                                'Fantasy',          1992, 2, 2),  
( 'Mort',                                      'Fantasy',          1987, 2, 2),  
( 'Guards! Guards!',                           'Fantasy',          1989, 3, 3);  

-- ---------------- BORROWINGS (45 loans) ----------------
-- Columns: book_id, member_id, days_ago_borrowed, days_until_returned (NULL = still out)
-- Loan period = 14 days. Late returns and overdue loans are included on purpose.
INSERT INTO borrowings (book_id, member_id, borrow_date, due_date, return_date)
SELECT v.book_id,
       v.member_id,
       CURRENT_DATE - v.days_ago,
       CURRENT_DATE - v.days_ago + 14,
       CASE WHEN v.returned_after IS NULL THEN NULL
            ELSE CURRENT_DATE - v.days_ago + v.returned_after END
FROM (VALUES
    -- Harry Potter 1 (5 loans)
    (20,  1, 120, 10), (20,  2,  90, 13), (20,  5,  60, 14), (20,  7,  30,  9), (20,  9,  10, NULL),
    -- Nineteen Eighty-Four (4 loans)
    ( 8,  1, 100, 12), ( 8,  3,  75, 20), ( 8,  6,  45, 11), ( 8, 10,  20, NULL),
    -- The Alchemist (4 loans)
    (39,  2, 110,  7), (39,  4,  80, 15), (39,  8,  50, 12), (39, 12,  25, NULL),
    -- Pride and Prejudice (3 loans)
    ( 4,  3,  95, 13), ( 4,  5,  65, 16), ( 4, 13,  35, NULL),
    -- Murder on the Orient Express (3 loans)
    (17,  6,  85, 14), (17, 11,  55, 10), (17, 12,   1, NULL),
    -- Everything else
    (18,  7,  40, 12),
    (36,  9,  70,  9), (36, 13,  15, NULL),
    (47,  4, 100, 13), (47, 10,  30, 14),
    (11,  8,  60, 11), (11, 12,  12, NULL),
    (53,  1,  88, 13), (53, 13,  22, NULL),
    (26,  5,  72, 14), (26,  9,  18, NULL),
    (44,  3,  66, 17),
    (50,  7,  48, 10),
    (29,  2,  52, 13), (29,  6,   5, NULL),
    (14, 11,  42,  9),
    (33,  1,  38, 14),
    (41,  8,  28, 13),
    (56, 13,   8, NULL),
    (59,  4,  33, 12),
    (21,  2,  77, 14), (21, 13,   3, NULL),
    (22,  5,  26, 10),
    (54, 10,  16, NULL),
    (34,  9,  44, 13),
    ( 2,  6,  58, 12)
) AS v(book_id, member_id, days_ago, returned_after);
-- Make available_copies consistent with the loans that are still out
UPDATE books b
SET available_copies = b.total_copies - (
        SELECT COUNT(*)
        FROM borrowings br
        WHERE br.book_id = b.book_id
          AND br.return_date IS NULL
);

-- ---------------- Sanity check (checking all value in all tables ) ----------------
SELECT (SELECT COUNT(*) FROM authors)      AS authors,
       (SELECT COUNT(*) FROM books)        AS books,
       (SELECT COUNT(*) FROM book_authors) AS book_author_links,
       (SELECT COUNT(*) FROM members)      AS members,
       (SELECT COUNT(*) FROM borrowings)   AS borrowings;
