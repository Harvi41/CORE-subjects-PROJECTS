from database.db_connect import connect_db

def create_tables():
  conn = connect_db()
  cursor = conn.cursor()

  cursor.execute("""
    CREATE TABLE IF NOT EXISTS users (
        user_id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
    )
    """)
  cursor.execute("""
CREATE TABLE IF NOT EXISTS study_hours (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    subject_id INTEGER,
    hours REAL,
    date TEXT
)
""") 
  conn.commit()
  conn.close()

create_tables()
  
