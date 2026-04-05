from services.auth_services import signup

result = signup("parth", "1234")

if result:
    print("User Created")
else:
    print("Username already exists")