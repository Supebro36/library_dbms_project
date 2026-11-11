# Library Management Database

A PostgreSQL database for a library: books, authors, members and borrowings, with SQL queries, a transaction, an index optimization and a Python script.

## What it needs

- PostgreSQL + pgAdmin
- Python 3 with `pip install psycopg2-binary python-dotenv`

## How it is solved

Task | File | Approach |

1. Design +  Create | `tables.sql` | (5) tables: `authors`, `books`, `members`, `borrowings`, and `book_authors` (junction table for the many-to-many between books and authors). Primary/foreign keys, `CHECK`, `UNIQUE` and `NOT NULL` constraints. |
2. Load | `data.sql` | 21 authors, 62 books, 18 members, 45 borrowings. |
3. Query | `quries.sql` | Books by author, overdue members, top 3 most-borrowed books, members who never borrowed. |
4. Transaction | `transactions.sql` | `BEGIN` ... `COMMIT`: lock the book row, reduce `available_copies`, insert the loan. |
5. Optimize | `optimize.sql` | Index on `member_id` for a 500,000-row test table. `EXPLAIN ANALYZE`: Seq Scan 80 ms to Bitmap Index Scan 1.6 ms. |
6. Python | `main_app.py` | Connects with `psycopg2` and runs parameterized queries (`%s`), which prevents SQL injection. |

## How to run

1. In pgAdmin, create a database and open the Query Tool on it.
2. Run the SQL files in this order: `tables.sql`, `data.sql`, `quries.sql`, `transactions.sql`, `optimize.sql`.
3. Create a `.env` file next to `main_app.py` (never commit it):
   ```
   DB_HOST=localhost
   DB_PORT=5432
   DB_NAME=your_database_name
   DB_USER=your_user
   DB_PASS=your_password
   ```
4. Run the script:
   ```
   python main_app.py
   ```