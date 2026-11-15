# Restaurant Reservations

![Banner](banner.png)

A small app that looks up restaurant bookings, tables, staff, and orders from a SQLite database. Built for COMP3278 (Introduction to Database Management Systems), University of Hong Kong.

This is Option B from the project guidelines: our own Python app, built from scratch. The app reads its data only from `database/app.db`. Each feature runs one `SELECT` query, and user input is passed as parameters (`:name`). The app never inserts, updates, or deletes data.

## Project structure

```
Restaurant-Reservation-/
├── README.md
├── requirements.txt
├── banner.png
├── er_attrs.png        # ER diagram
├── app/
│   ├── app.py          # Flask routes
│   └── queries.py      # one SQL query per feature
├── database/
│   ├── schema.sql      # CREATE TABLE statements
│   ├── seed.sql        # sample data
│   ├── build.sql       # builds app.db
│   └── app.db          # generated database
├── report.pdf
└── video.mp4           
```

## Requirements

- Python 3.10 or newer
- The `sqlite3` command line tool
  - macOS: already installed.
  - Windows: download `sqlite3.exe` from sqlite.org and place it in the project folder.

## Setup and run

**1. Build the database** (run again after any change to schema.sql or seed.sql):

```bash
sqlite3 -bail :memory: ".read database/build.sql"
```

It should end with `Done: database/app.db was built from schema.sql and seed.sql.`

**2. Install packages and start the app:**

```bash
pip install -r requirements.txt
python app/app.py
```

## ER diagram

![ER diagram](er_diagram.png)