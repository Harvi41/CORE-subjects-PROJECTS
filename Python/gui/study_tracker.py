import tkinter as tk
from tkinter import ttk, messagebox
import sqlite3
from datetime import datetime

# --- Database Setup ---
def init_db():
    conn = sqlite3.connect('study_assistant.db')
    cursor = conn.cursor()
    # Table for Feature 3: Subject, Hours Spent, and Date
    cursor.execute('''CREATE TABLE IF NOT EXISTS study_logs 
        (id INTEGER PRIMARY KEY, 
         subject TEXT, 
         hours_spent REAL, 
         date TEXT)''')
    conn.commit()
    conn.close()

class StudyTrackerApp:
    def __init__(self, root, user_id):
        self.root = root
        self.user_id = user_id
        self.root.title("Study Hours Tracker")
        self.root.geometry("500x500")
        init_db()

        # --- UI Layout ---
        tk.Label(root, text="Study Hours Tracker", font=('Arial', 16, 'bold')).pack(pady=10)

        # Input Frame
        frame = tk.Frame(root)
        frame.pack(pady=10)

        # Subject Selection (From Database)
        tk.Label(frame, text="Select Subject:").grid(row=0, column=0, sticky="w", padx=5)
        self.combo_subject = ttk.Combobox(frame, width=18)
        self.combo_subject.grid(row=0, column=1, pady=5)
        self.refresh_subjects() # Load subjects from Feature 2 table

        # Hours Input
        tk.Label(frame, text="Hours Studied:").grid(row=1, column=0, sticky="w", padx=5)
        self.ent_hours = tk.Entry(frame, width=20)
        self.ent_hours.grid(row=1, column=1, pady=5)

        # Buttons
        btn_log = tk.Button(frame, text="Log Hours", command=self.log_hours, bg="#2196F3", fg="white", width=15)
        btn_log.grid(row=2, column=0, columnspan=2, pady=10)

        # Statistics Display
        self.stats_frame = tk.LabelFrame(root, text="Study Statistics", padx=10, pady=10)
        self.stats_frame.pack(pady=20, fill="x", padx=20)

        self.lbl_total = tk.Label(self.stats_frame, text="Total Hours Studied: 0", font=('Arial', 11))
        self.lbl_total.pack(anchor="w")

        self.lbl_today = tk.Label(self.stats_frame, text="Studied Today: 0", font=('Arial', 11))
        self.lbl_today.pack(anchor="w")

        self.update_stats()

    def refresh_subjects(self):
        """Fetches unique subjects from the 'topics' table (Feature 2)"""
        try:
            conn = sqlite3.connect('study_assistant.db')
            c = conn.cursor()
            c.execute("SELECT DISTINCT subject FROM topics")
            subjects = [row[0] for row in c.fetchall()]
            self.combo_subject['values'] = subjects
            conn.close()
        except sqlite3.OperationalError:
            # If the topics table doesn't exist yet
            self.combo_subject['values'] = ["Add Subjects in Feature 2"]

    def log_hours(self):
        subject = self.combo_subject.get()
        try:
            hours = float(self.ent_hours.get())
            date_today = datetime.now().strftime("%Y-%m-%d")

            if subject:
                conn = sqlite3.connect('study_assistant.db')
                c = conn.cursor()
                c.execute("INSERT INTO study_logs (subject, hours_spent, date) VALUES (?, ?, ?)",
                          (subject, hours, date_today))
                conn.commit()
                conn.close()
                
                self.ent_hours.delete(0, tk.END)
                self.update_stats()
                messagebox.showinfo("Success", f"Logged {hours} hours for {subject}!")
            else:
                messagebox.showwarning("Input Error", "Please select a subject.")
        except ValueError:
            messagebox.showerror("Error", "Please enter a valid number for hours.")

    def update_stats(self):
        conn = sqlite3.connect('study_assistant.db')
        c = conn.cursor()
        
        # Calculate Total Hours
        c.execute("SELECT SUM(hours_spent) FROM study_logs")
        total = c.fetchone()[0] or 0
        self.lbl_total.config(text=f"Total Hours Studied: {total} hrs")

        # Calculate Today's Hours
        today = datetime.now().strftime("%Y-%m-%d")
        c.execute("SELECT SUM(hours_spent) FROM study_logs WHERE date = ?", (today,))
        daily = c.fetchone()[0] or 0
        self.lbl_today.config(text=f"Studied Today: {daily} hrs")
        
        conn.close()

