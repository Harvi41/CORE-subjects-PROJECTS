import sqlite3
import os

def connect_db():
    base_dir = os.path.dirname(os.path.dirname(__file__))  # Project root
    db_path = os.path.join(base_dir, "data", "study_assistant.db")
    
    conn = sqlite3.connect(db_path)
    return conn