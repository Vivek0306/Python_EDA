import random
import time
from Database import admin_db, user_db, session_db, catalog, cart
from admin_methods import add_product, update_product, delete_product
from user_methods import generate_session_id, add_to_cart, delete_from_cart, display_cart, checkout

role = None
def user_login():
    username = input('Enter your username: ')
    password = input('Enter your password: ')
    for user in user_db:
        if user['username'] == username and user['password'] == password:
            session_id = generate_session_id()
            session_db[username] = session_id
            print(f"Login successful as user. Session ID: {session_id}")
            return True
        else:
            print("Login Failed")
            return False

def admin_login():
    username = input('Enter your username: ')
    password = input('Enter your password: ')
    for admin in admin_db:
        if admin['username'] == username and admin['password'] == password:
            print("Login successful as admin.")
            role = 'admin'
            return True
            
        else:
            print("Login Failed")
            return False
            

def display_catalog():
    print(f"{'ID':<19}       {'Name':<19}       {'Category':<19}       {'Price':<19}")
    print(f"{'----------------------------------------------------------------------------------------'}")
    for product in catalog.keys():
        product_details = catalog.get(product)
        print(f'''{product_details['id']:<19}       {product_details['name']:<19}       {product_details['category']:<19}       ₹ {product_details['price']:<19}''')
    print(f"{'----------------------------------------------------------------------------------------'}")

   
while True:
    print("\n\nWelcome to UST Marketplace")

    role_choice = input("Login as (a) User, (b) Admin or (q) Quit, Enter a/b/q: ")
    if role_choice.lower() == 'a':
        if user_login():
            role = 'user'
    elif role_choice.lower() == 'b':
        if admin_login():
            role = 'admin'
    elif role_choice.lower() == 'q':
        print("Bye bye!!\n")
        role = None
        break
    else:
        role = None
        print("Invalid choice, try again!")
        continue 
    
    while role == 'user' or role == 'admin':
        if role == 'user':
            print("\nUST MARKETPLACE")
            print("-------------------------------------------------")
            print('''
        1. Logout
        2. Display Products
        3. Add to Cart
        4. Display Cart
        5. Delete from Cart
        6. Checkout
        7. Quit
            ''')
            choice = input("Enter your choice: ")
            

            if choice == '1':
                print("Loggin user out....\n")
                role = None
                
            if choice == '2':
                display_catalog()
                
            if choice == '3':
                display_catalog()
                product_id = int(input("Enter the product id: "))
                quantity = int(input("Enter the product quantity: "))
                if quantity and product_id:
                    add_to_cart(product_id, quantity)
                else:
                    print("\nEnter product id and quantity!\n")
                
            if choice == '4':
                display_cart()
                
            if choice == '5':
                product_id = int(input("Enter the product id: "))
                delete_from_cart(product_id)
                
            if choice == '6':
                checkout()
            
            if choice == '7':
                break
            
            
        elif role == 'admin':
            print("\nUST MARKETPLACE")
            print("-------------------------------------------------")
            
            print('''
        1. Logout
        2. Display Products
        3. Add Products
        4. Update Products
        5. Delete Product
        6. Quit
                ''')
            print("-------------------------------------------------")
            
            choice = input("Enter your choice: ")
            
            if choice == '1':
                print("Loggin admin out....\n")
                role = None
                
            if choice == '2':
                display_catalog()
                
            if choice == '3':
                add_product()
                
            if choice == '4':
                update_product()
            if choice == '5':
                delete_product()
            if choice == '6':
                break