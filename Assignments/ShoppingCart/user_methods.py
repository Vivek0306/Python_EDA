from Database import admin_db, user_db, session_db, catalog, cart
import random, time

def display_cart():
    total = 0
    if len(cart) == 0:
        print("\n\nNo items in cart! Shop to add items in the cart.")
    else:
        print(f"PRODUCTS IN CART: (SESSION ID: {cart[0]['session_id']})")
        print(f"\n{'ID':<6}       {'Name':<19}       {'Category':<19}       {'Price':<10}       {'Quantity':<10}")
        print(f"{'-----------------------------------------------------------------------------------------'}")
        for product in cart:
            product_details = catalog.get(product['product_id'])
            total += int(product_details['price']) * int(product['quantity'])
            print(f'''{product_details['id']:<6}       {product_details['name']:<19}       {product_details['category']:<19}       ₹ {product_details['price']:<10}       x{product['quantity']:<19}''')
        print(f"{'-----------------------------------------------------------------------------------------'}")
        print(f'''\n                                                              Cart Total => ₹ {total}\n''')    
        
def calculate_total():
    total = 0
    if len(cart) != 0:
        for product in cart:
            product_details = catalog.get(product['product_id'])
            total += int(product_details['price']) * int(product['quantity'])
    return total
        
def generate_session_id():
    return random.randint(10000, 99999)


def add_to_cart(product_id, quantity):
    if product_id > len(catalog):
        print("\nInvalid Product ID! Try Again!\n")
        return
    for product in cart:
        if product['product_id'] == product_id:
            product['quantity'] += 1
            print("\nProduct added successfully!\n")
            return
    cart.append({
        'session_id': generate_session_id(),
        'product_id': product_id,
        'quantity': quantity
    })
    print("\nProduct added successfully!\n")
    display_cart()
    
            
def delete_from_cart(product_id):
    for product in cart:
        if product['product_id'] == product_id:
            cart.remove(product)
            print("\nProduct removed from cart!\n")
            display_cart()
            return
    print("\nNo product found!\n")
    
def checkout():
    if len(cart) > 0:
        total = calculate_total()
        print(f'''
        CHECKOUT PAGE:
        
        TOTAL AMOUNT => ₹ {total}
        
        Select the payment method
    ------------------------------------
            1. UPI
            2. Debit/Credit Card
            3. Cash on Delivery
        ''')
        
        choice = input("Enter your choice: ")
        
        if choice == '1':
            upi_id = input("Enter your UPI ID: ")
            print(f'''
            Processing payment using UPI ID {upi_id}...........''')
        
            time.sleep(3)
            print(f"\nPayment Successful for  ₹ {total}! Thank you for shopping!\n")       
            
        elif choice == '2':
            card_no = int(input("Enter your Debit/Credit Card Number: "))
            print(f'''Redirecting to bank page for transaction...........''')

            time.sleep(3)
            print(f"\nPayment Successful for  ₹ {total}! Thank you for shopping!\n")  
        elif choice == '3':
            time.sleep(3)
            print(f"\nPayment Successful for  ₹ {total}! Thank you for shopping!\n")
            
        cart.clear()
            
        print("\nRedirecting to home page......")
        time.sleep(3)
    else:
        print("\nNo products added to cart!")