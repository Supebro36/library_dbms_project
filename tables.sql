CREATE TABLE authors (
author_id SERIAL PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
country VARCHAR(50),
birth_year INT CHECK (birth_year BETWEEN 1000 AND 2100),
CONSTRAINT uq_author_name UNIQUE(first_name,last_name)
);

 CREATE TABLE books(
books_id SERIAL PRIMARY KEY,
title VARCHAR(200) NOT NULL,
genre VARCHAR(50) ,
publication_year INT CHECK (publication_year BETWEEN 100 AND 2100),
total_copies INT NOT NULL DEFAULT 1 CHECK (total_copies>=0),
available_copies INT  NOT NULL DEFAULT 1 CHECK(available_copies >=0),
CONSTRAINT chk_available_le_total CHECK (available_copies <= total_copies)
);


CREATE TABLE members(
member_id SERIAL PRIMARY KEY,
full_name VARCHAR(100) NOT NULL,
email VARCHAR(100) NOT NULL UNIQUE,
join_date DATE NOT NULL DEFAULT CURRENT_DATE,
membership_status VARCHAR(10) NOT NULL DEFAULT 'Active' 
CHECK (	membership_status IN ('Active','Suspend','Expired'))
);

CREATE TABLE book_authors(
book_id  INT NOT NULL REFERENCES books(books_id) ON DELETE RESTRICT,
author_id INT NOT NULL REFERENCES members(member_id) ON DELETE RESTRICT,
PRIMARY KEY (book_id,author_id)
);


CREATE TABLE borrowings (
borrowing_id SERIAL PRIMARY KEY,
books_id INT NOT NULL REFERENCES books(books_id) ON DELETE RESTRICT,
member_id INT NOT NULL REFERENCES members(member_id) ON DELETE RESTRICT,
borrow_date   DATE    NOT NULL DEFAULT CURRENT_DATE,
due_date      DATE    NOT NULL,
return_date   DATE,
CONSTRAINT chk_due_after_borrow    CHECK (due_date >= borrow_date),
CONSTRAINT chk_return_after_borrow CHECK (return_date IS NULL OR return_date >= borrow_date)
);
