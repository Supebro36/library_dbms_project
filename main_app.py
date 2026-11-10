"""
Library Management - Python connection with a PARAMETERIZED query.

Setup (once):
    pip install psycopg2-binary

Run:
    python library_app.py                      # default author: Pratchett
    python library_app.py Orwell               # any author last name
    python library_app.py Orwell --overdue 5   # also show loans overdue >= 5 days

Connection settings come from environment variables, with defaults you can edit:
    PGHOST, PGPORT, PGDATABASE, PGUSER, PGPASSWORD
"""
import argparse
import os
import sys
import dotenv

import psycopg2
from psycopg2 import Error

dotenv.load_dotenv()

def get_connection():
    """Open a connection to PostgreSQL. Never hard-code a real password in code."""
    return psycopg2.connect(
        host=os.getenv("DB_HOST", "localhost"),
        port=os.getenv("DB_PORT", "5432"),
        dbname=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASS"),
    )


# %s are PLACEHOLDERS. The driver sends the values separately from the SQL,
# so a malicious value like  x'; DROP TABLE books; --  is treated as plain
# text and can never change the query.
BOOKS_BY_AUTHOR_SQL = """
    SELECT b.title, b.genre, b.publication_year, b.available_copies
    FROM books b
    JOIN book_authors ba ON ba.book_id  = b.books_id
    JOIN authors a       ON a.author_id = ba.author_id
    WHERE a.last_name ILIKE %s
    ORDER BY b.publication_year;
"""

OVERDUE_SQL = """
    SELECT m.full_name, b.title, CURRENT_DATE - br.due_date AS days_overdue
    FROM borrowings br
    JOIN members m ON m.member_id = br.member_id
    JOIN books   b ON b.book_id   = br.book_id
    WHERE br.return_date IS NULL
      AND CURRENT_DATE - br.due_date >= %s
    ORDER BY days_overdue DESC;
"""


def books_by_author(conn, last_name):
    with conn.cursor() as cur:
        # The values go in a tuple as the SECOND argument - never use f-strings
        # or % formatting to build the SQL text yourself.
        cur.execute(BOOKS_BY_AUTHOR_SQL, (last_name,))
        return cur.fetchall()


def overdue_loans(conn, min_days):
    with conn.cursor() as cur:
        cur.execute(OVERDUE_SQL, (min_days,))
        return cur.fetchall()


def main():
    parser = argparse.ArgumentParser(description="Library database demo")
    parser.add_argument("author", nargs="?", default="Pratchett",
                        help="author last name (case-insensitive)")
    parser.add_argument("--overdue", type=int, default=None, metavar="DAYS",
                        help="also list loans overdue by at least DAYS days")
    args = parser.parse_args()

    conn = None
    try:
        conn = get_connection()

        rows = books_by_author(conn, args.author)
        print(f"\nBooks by '{args.author}': {len(rows)} found")
        print("-" * 70)
        for title, genre, year, available in rows:
            print(f"{title:<45} {genre:<16} {year}  (available: {available})")

        if args.overdue is not None:
            loans = overdue_loans(conn, args.overdue)
            print(f"\nLoans overdue by {args.overdue}+ days: {len(loans)} found")
            print("-" * 70)
            for name, title, days in loans:
                print(f"{name:<20} {title:<35} {days} days")

    except Error as e:
        print(f"Database error: {e}", file=sys.stderr)
        sys.exit(1)
    finally:
        if conn is not None:
            conn.close()


# What NOT to do (SQL injection risk) - kept as a comment for your report:
#   cur.execute(f"SELECT * FROM authors WHERE last_name = '{user_input}'")   # UNSAFE
#   cur.execute("SELECT * FROM authors WHERE last_name = %s", (user_input,)) # SAFE

if __name__ == "__main__":
    main()
