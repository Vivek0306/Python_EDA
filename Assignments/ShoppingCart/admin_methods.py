from Database import admin_db, user_db, session_db, catalog, cart

def add_product():
    product_id = int(input("Enter product id: "))
    name = input("Enter product name: ")
    category = input("Enter the category of the product: ")
    price = input("Enter price of the product: ")
    
    if product_id not in catalog:
        catalog[product_id] = {'id':product_id, 'name': name, 'category': category, 'price': price}
        print("\nProduct added successfully!\n")
        
    else:
        print("\nTry different product id\n")
    

def update_product():
    product_id = int(input("Enter product id to update: "))
    if product_id in catalog:
        product = catalog[product_id]
        name = input("Enter product name: ")
        if name:
            product['name'] = name

        category = input("Enter the category of the product: ")
        if category:
            product['category'] = category
            
        price = input("Enter price of the product: ")
        if price:
            product['price'] = price        
       
        print("\nProduct updated successfully!\n")
    else:
        print("\nProduct not found!\n")       
    
def delete_product():
    product_id = int(input("Enter product id to delete: "))
    if product_id in catalog:
        del catalog[product_id]
        print("\nProduct deleted successfully!\n")

    else:
        print("\nProduct not found!\n")     
     