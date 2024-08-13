# Condition controlled loop
condition = 2
while condition <= 12:
    print(condition, end=" ")
    condition *= 2
print()


# Count controlled loops
for i in range(1, 11):
    print(i* 2, end=" ")
print()

# Collection controlled loop
for val in [1,2,3,4,5]:
    print(val, end=" ")    
print()
    
    
# Conditional Statements
a = 18
b = 20

if a > b:
    print('a is bigger')
elif a < b:
    print('b is bigger')
else:
    print('a and b are equal')
    
    
# While Loops
while True:
    print("1. Login \n2. Logout")
    choice = input("Enter your choice: ")
    
    if choice == '1':
        user = input("Enter the username: ")
        password = input("Enter the password: ")
        if user == 'admin' and password == 'admin123':
            print("Login Successfull! Welcome admin!")
            break
        else:
            print("Incorrect username or password. Try Again")
    if choice == '2':
        print("Logging out!")
        break
    else:
        print("Invalid choice! Try again")
        continue
    
mylist1 = ['tvm','cok',None,'bom','ktym', None,None, 'alpzha']
for i in mylist1:
    if i is None:
        continue
    print(i)
    