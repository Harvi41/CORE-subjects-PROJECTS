import tkinter as tk
from tkinter import messagebox
from services.auth_services import signup


class SignupWindow:
    def __init__(self, root):
        self.root = root
        self.root.title("Signup")
        self.root.geometry("300x220")

        tk.Label(root, text="Create Account", font=('Arial', 16)).pack(pady=10)

        tk.Label(root, text="Username").pack()
        self.ent_user = tk.Entry(root)
        self.ent_user.pack()

        tk.Label(root, text="Password").pack()
        self.ent_pass = tk.Entry(root, show="*")
        self.ent_pass.pack()

        tk.Button(root, text="Signup", command=self.signup_user).pack(pady=10)

    def signup_user(self):
        username = self.ent_user.get()
        password = self.ent_pass.get()

        if username == "" or password == "":
            messagebox.showwarning("Error", "Fields cannot be empty")
            return

        success = signup(username, password)

        if success:
            messagebox.showinfo("Success", "Account Created! You can login now.")
            self.root.destroy()
        else:
            messagebox.showerror("Error", "Username already exists")