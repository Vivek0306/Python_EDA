from Expense import Expense
from ExpenseManager import Storage

while True:
    print("\nWELCOME TO UST EXPENSE TRACKER\n")
    storage = Storage()
    
    role_choice = print("Login to continue: \n")
    
    if storage.user_login():
        role = 'user'
    else:
        role = None
        continue
       
    while role == 'user':
        print(f"\n{'EXPENSE TRACKER':>10}")
        print("---------------------------------")
        
        print('''
            1. Add New Expense
            2. Update Expense
            3. Delete expense
            4. Display expenses
            5. Generate Report
            6. Quit   
        ''')
        choice = input("Enter your choice: ")
        
        if choice == '1':
            try:
                id = int(input("Enter expense id: "))
                date = input("Enter date of expense (DD-MM-YYYY): ")
                category = input("Enter the category of expense: ")
                description = input("Enter expense description: ")
                amount = float(input("Enter expense amount: "))
                expense = Expense(id, date, category, description, amount)
                storage.add_expense(expense)
                print(expense)

            except ValueError as e:
                print(f"\n{e}\n")
        
        elif choice == '2':        
            try:
                id = int(input("Enter expense id to update: "))
                date = input("Enter date of expense (YYYY-MM-DD): ")
                category = input("Enter the category of expense: ")
                description = input("Enter expense description: ")
                amount = float(input("Enter expense amount: "))
                expense = Expense(id, date, category, description, amount)
                print(expense)
                storage.update_expense(id, expense)
            except ValueError as e:
                print(f"\n{e}\n")
        
        elif choice == '3':
            id = int(input("Enter expense id to delete: "))
            storage.delete_expense(id)       
                
        elif choice == '4':
            storage.display_expenses()
        
        elif choice == '5':
            storage.generate_summary_report()
        
        elif choice == '6':
            print("\nLeaving expense tracker, bye bye!")
            break

        else:
            print("\nInvalid Choice Entered\n")
            continue