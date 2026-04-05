import tkinter as tk
from tkinter import ttk, messagebox
from database.db_connect import connect_db


def init_db():
    conn = connect_db()
    cursor = conn.cursor()

    cursor.execute('''
        CREATE TABLE IF NOT EXISTS subjects (
            subject_id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            subject_name TEXT
        )
    ''')

    cursor.execute('''
        CREATE TABLE IF NOT EXISTS topics (
            topic_id INTEGER PRIMARY KEY AUTOINCREMENT,
            subject_id INTEGER,
            topic_name TEXT,
            deadline TEXT,
            priority TEXT,
            status TEXT DEFAULT 'Pending'
        )
    ''')

    conn.commit()
    conn.close()


class TopicManagerApp:
    def __init__(self, root, user_id):
        self.root = root
        self.user_id = user_id
        self.root.title("Subject & Topic Manager")
        self.root.geometry("650x500")

        init_db()

        tk.Label(root, text="Subject & Topic Manager",
                 font=('Arial', 16, 'bold')).pack(pady=10)

        frame = tk.Frame(root)
        frame.pack(pady=10)

        tk.Label(root,
         text="Double-click a row to mark completed. Select a row and click Delete to remove.",
         fg="gray").pack()
        
        tk.Label(frame, text="Subject:").grid(row=0, column=0, sticky="w", padx=5)
        self.ent_subject = tk.Entry(frame, width=20)
        self.ent_subject.grid(row=0, column=1, pady=5)

        tk.Label(frame, text="Topic:").grid(row=1, column=0, sticky="w", padx=5)
        self.ent_topic = tk.Entry(frame, width=20)
        self.ent_topic.grid(row=1, column=1, pady=5)

        tk.Label(frame, text="Deadline:").grid(row=2, column=0, sticky="w", padx=5)
        self.ent_deadline = tk.Entry(frame, width=20)
        self.ent_deadline.insert(0, "DD-MM-YYYY")
        self.ent_deadline.grid(row=2, column=1, pady=5)

        tk.Label(frame, text="Priority:").grid(row=3, column=0, sticky="w", padx=5)
        self.combo_priority = ttk.Combobox(
            frame, values=["High", "Medium", "Low"], width=18)
        self.combo_priority.set("Medium")
        self.combo_priority.grid(row=3, column=1, pady=5)

        tk.Button(frame, text="Submit",
                  command=self.submit_data,
                  bg="#4CAF50", fg="white", width=15).grid(row=4, column=0, columnspan=2, pady=10)

        # Table
        self.tree = ttk.Treeview(root,
                                 columns=("ID", "Subj", "Top", "Dead", "Prio", "Stat"),
                                 show='headings')

        self.tree.heading("ID", text="ID")
        self.tree.heading("Subj", text="Subject")
        self.tree.heading("Top", text="Topic")
        self.tree.heading("Dead", text="Deadline")
        self.tree.heading("Prio", text="Priority")
        self.tree.heading("Stat", text="Status")

        self.tree.column("ID", width=30)
        self.tree.column("Subj", width=100)
        self.tree.column("Top", width=100)
        self.tree.column("Dead", width=100)
        self.tree.column("Prio", width=100)
        self.tree.column("Stat", width=100)

        self.tree.pack(pady=20, padx=10, fill="x")
        self.tree.bind("<Double-1>", self.mark_completed)

        # Buttons
        tk.Button(root, text="Mark Completed",
                  command=self.mark_completed,
                  bg="#2196F3", fg="white").pack(pady=5)

        tk.Button(root, text="Delete Topic",
                  command=self.delete_topic,
                  bg="#f44336", fg="white").pack(pady=5)

        self.load_data()

    # Submit
    def submit_data(self):
        subject = self.ent_subject.get()
        topic = self.ent_topic.get()
        deadline = self.ent_deadline.get()
        priority = self.combo_priority.get()

        if subject == "" or topic == "":
            messagebox.showwarning("Input Error", "Subject and Topic required")
            return

        conn = connect_db()
        cursor = conn.cursor()

        cursor.execute(
            "SELECT subject_id FROM subjects WHERE subject_name=? AND user_id=?",
            (subject, self.user_id)
        )
        result = cursor.fetchone()

        if result is None:
            cursor.execute(
                "INSERT INTO subjects (user_id, subject_name) VALUES (?, ?)",
                (self.user_id, subject)
            )
            conn.commit()

            cursor.execute(
                "SELECT subject_id FROM subjects WHERE subject_name=? AND user_id=?",
                (subject, self.user_id)
            )
            result = cursor.fetchone()

        subject_id = result[0]

        cursor.execute("""
            INSERT INTO topics (subject_id, topic_name, deadline, priority, status)
            VALUES (?, ?, ?, ?, 'Pending')
        """, (subject_id, topic, deadline, priority))

        conn.commit()
        conn.close()

        messagebox.showinfo("Success", "Topic Added")
        self.ent_topic.delete(0, tk.END)
        self.load_data()

    # Load table
    def load_data(self):
        for i in self.tree.get_children():
            self.tree.delete(i)

        conn = connect_db()
        cursor = conn.cursor()

        cursor.execute("""
            SELECT topics.topic_id, subjects.subject_name, topics.topic_name,
                   topics.deadline, topics.priority, topics.status
            FROM topics
            JOIN subjects ON topics.subject_id = subjects.subject_id
            WHERE subjects.user_id = ?
        """, (self.user_id,))

        rows = cursor.fetchall()

        for row in rows:
            self.tree.insert("", "end", values=row)

        conn.close()

    # Mark completed
    def mark_completed(self, event=None):
      selected = self.tree.focus()

      if not selected:
          messagebox.showwarning("Select", "Select a topic first")
          return

      values = self.tree.item(selected, 'values')
      topic_id = values[0]

      confirm = messagebox.askyesno("Confirm", "Mark this topic as Completed?")
      if not confirm:
          return

      conn = connect_db()
      cursor = conn.cursor()

      cursor.execute(
          "UPDATE topics SET status='Completed' WHERE topic_id=?",
          (topic_id,)
      )

      conn.commit()
      conn.close()

      self.load_data()
    # Delete topic
    def delete_topic(self):
        selected = self.tree.focus()

        if not selected:
            messagebox.showwarning("Select", "Select a topic first")
            return

        values = self.tree.item(selected, 'values')
        topic_id = values[0]

        conn = connect_db()
        cursor = conn.cursor()

        cursor.execute("DELETE FROM topics WHERE topic_id=?", (topic_id,))
        conn.commit()
        conn.close()

        messagebox.showinfo("Deleted", "Topic Deleted")
        self.load_data()