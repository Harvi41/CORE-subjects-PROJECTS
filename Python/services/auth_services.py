from database.db_connect import connect_db

def signup(username, password):
    conn = connect_db()
    cursor = conn.cursor()

    try:
        cursor.execute(
            "INSERT INTO users (username, password) VALUES (?, ?)",
            (username, password)
        )
        conn.commit()
        return True
    except Exception as e:
        print("Signup Error:", e)
        return False
    finally:
        conn.close()


def login(username, password):
    conn = connect_db()
    cursor = conn.cursor()

    cursor.execute(
        "SELECT user_id FROM users WHERE username=? AND password=?",
        (username, password)
    )

    user = cursor.fetchone()
    conn.close()

    if user:
        return user[0]   # return user_id
    else:
        return None