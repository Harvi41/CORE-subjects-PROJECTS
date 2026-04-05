import tkinter as tk
from gui.topic_manager import TopicManagerApp
from gui.study_tracker import StudyTrackerApp
from gui.exam_dashboard import ExamDashboard


class Dashboard:
    def __init__(self, root, user_id):
        self.root = root
        self.user_id = user_id
        self.root.title("Dashboard")
        self.root.geometry("400x350")

        tk.Label(root, text="Personal Study Assistant",
                 font=('Arial', 16, 'bold')).pack(pady=20)

        tk.Button(root, text="Subject & Topic Manager",
                  width=25,
                  command=self.open_topic_manager).pack(pady=10)

        tk.Button(root, text="Study Hours Tracker",
                  width=25,
                  command=self.open_study_tracker).pack(pady=10)

        tk.Button(root, text="Exam Countdown & Readiness",
                  width=25,
                  command=self.open_exam_dashboard).pack(pady=10)

        tk.Button(root, text="Logout",
                  width=25,
                  command=root.destroy).pack(pady=20)

    def open_topic_manager(self):
        new_window = tk.Toplevel(self.root)
        TopicManagerApp(new_window, self.user_id)

    def open_study_tracker(self):
        new_window = tk.Toplevel(self.root)
        StudyTrackerApp(new_window, self.user_id)

    def open_exam_dashboard(self):
        new_window = tk.Toplevel(self.root)
        ExamDashboard(new_window, self.user_id)