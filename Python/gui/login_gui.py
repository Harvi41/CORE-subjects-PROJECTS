import tkinter as tk
from tkinter import messagebox
from services.auth_services import login
from gui.dashboard import Dashboard
from gui.signup_gui import SignupWindow


class LoginWindow:
    def __init__(self, root):
        self.root = root
        self.root.title("Login")
        self.root.geometry("300x230")

        tk.Label(root, text="Login", font=('Arial', 16)).pack(pady=10)

        tk.Label(root, text="Username").pack()
        self.ent_user = tk.Entry(root)
        self.ent_user.pack()

        tk.Label(root, text="Password").pack()
        self.ent_pass = tk.Entry(root, show="*")
        self.ent_pass.pack()

        tk.Button(root, text="Login", command=self.login_user).pack(pady=10)

        tk.Label(root, text="Don't have an account?").pack()
        tk.Button(root, text="Create Account", command=self.open_signup).pack()

    def login_user(self):
        username = self.ent_user.get()
        password = self.ent_pass.get()

        user_id = login(username, password)

        if user_id:
            messagebox.showinfo("Success", "Login Successful")
            self.root.destroy()

            new_root = tk.Tk()
            Dashboard(new_root, user_id)
            new_root.mainloop()
        else:
            messagebox.showerror("Error", "Invalid Credentials")

    def open_signup(self):
        signup_window = tk.Toplevel(self.root)
        SignupWindow(signup_window)