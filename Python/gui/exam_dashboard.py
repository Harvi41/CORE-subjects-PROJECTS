import tkinter as tk
from tkinter import messagebox
from datetime import datetime
import random


class ExamDashboard:
    def __init__(self, root, user_id):
        self.root = root
        self.user_id = user_id
        self.root.title("Exam Countdown & Readiness")
        self.root.geometry("500x500")

        tk.Label(root, text="Exam Countdown & Readiness",
                 font=('Arial', 16, 'bold')).pack(pady=10)

        frame = tk.Frame(root)
        frame.pack(pady=10)

        # Exam date
        tk.Label(frame, text="Exam Date (YYYY-MM-DD)").grid(row=0, column=0)
        self.ent_exam = tk.Entry(frame)
        self.ent_exam.grid(row=0, column=1)

        # Estimated hours
        tk.Label(frame, text="Estimated Study Hours").grid(row=1, column=0)
        self.ent_estimated = tk.Entry(frame)
        self.ent_estimated.grid(row=1, column=1)

        # Completed hours
        tk.Label(frame, text="Completed Study Hours").grid(row=2, column=0)
        self.ent_completed = tk.Entry(frame)
        self.ent_completed.grid(row=2, column=1)

        # Button
        tk.Button(frame, text="Calculate",
                  command=self.calculate,
                  bg="#4CAF50", fg="white").grid(row=3, column=0, columnspan=2, pady=10)

        # Result Labels
        self.lbl_days = tk.Label(root, text="Days Left: ")
        self.lbl_days.pack()

        self.lbl_remaining = tk.Label(root, text="Remaining Hours: ")
        self.lbl_remaining.pack()

        self.lbl_readiness = tk.Label(root, text="Readiness %: ")
        self.lbl_readiness.pack()

        self.lbl_required = tk.Label(root, text="Required Hours/Day: ")
        self.lbl_required.pack()

        self.lbl_status = tk.Label(root, text="Status: ")
        self.lbl_status.pack()

        self.lbl_motivation = tk.Label(root, text="", wraplength=400, fg="blue")
        self.lbl_motivation.pack(pady=10)

    def calculate(self):
        try:
            exam_date = self.ent_exam.get()
            estimated = float(self.ent_estimated.get())
            completed = float(self.ent_completed.get())

            # Days left
            exam = datetime.strptime(exam_date, "%Y-%m-%d")
            today = datetime.now()
            days_left = (exam - today).days

            # Remaining hours
            remaining = estimated - completed

            # Readiness %
            if estimated == 0:
                readiness = 0
            else:
                readiness = (completed / estimated) * 100

            # Required hours per day
            if days_left > 0:
                req_per_day = remaining / days_left
            else:
                req_per_day = remaining

            # Status
            if readiness < 40:
                status = "Not Ready"
            elif readiness < 70:
                status = "Average"
            elif readiness < 90:
                status = "Good"
            else:
                status = "Exam Ready"

            # Motivational messages
            messages = [
                "Start now. Small progress is still progress.",
                "Consistency beats motivation.",
                "You still have time. Use it wisely.",
                "Focus. Study. Repeat.",
                "Your future self will thank you.",
                "Do it now, not later.",
                "Success comes from discipline."
            ]

            msg = random.choice(messages)

            # Show results
            self.lbl_days.config(text=f"Days Left: {days_left}")
            self.lbl_remaining.config(text=f"Remaining Hours: {remaining}")
            self.lbl_readiness.config(text=f"Readiness %: {readiness:.2f}%")
            self.lbl_required.config(text=f"Required Hours/Day: {req_per_day:.2f}")
            self.lbl_status.config(text=f"Status: {status}")
            self.lbl_motivation.config(text=f"Motivation: {msg}")

        except:
            messagebox.showerror("Error", "Please enter valid values")