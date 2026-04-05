from database.db_setup import create_tables
import tkinter as tk
from gui.login_gui import LoginWindow

create_tables()

root = tk.Tk()
LoginWindow(root)
root.mainloop()

