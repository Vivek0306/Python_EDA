from Database import users
        
class Storage:
    expenses = []
    
    def add_expense(self, expense):
        for exp in self.expenses:
            if expense.expense_id == exp.expense_id:
                raise ValueError("\nExpense with similar ID exists already!")
        if expense not in self.expenses:            
            self.expenses.append(expense)
        
    def update_expense(self, expense_id, new_expense):
        for expense in self.expenses:
            if expense.expense_id == expense_id:
                expense.amount = new_expense.amount
                expense.date = new_expense.date
                expense.category = new_expense.category
                expense.description = new_expense.description
                print("\nExpense Updated Successfully!\n")
                return
        print("\nExpense entry not found!\n")
        
    def delete_expense(self, expense_id):
        for expense in self.expenses:
            if expense.expense_id == expense_id:
                self.expenses.remove(expense)
                print("\nExpense deleted successfully!\n")
                return
        print("\nNo expense record found!\n")          
                
    def display_expenses(self):
        if len(self.expenses) <= 0:
            print("\nNo expense entry found!\n") 
            return
        else:
            print(f"{'ID':<10}       {'Date':<10}       {'Category':<14}       {'Description':<24}       {'Amount':<10}")
            print(f"{'-----------------------------------------------------------------------------------------------'}")
            for expense in self.expenses:
                print(f'''{expense.expense_id:<10}       {expense.date}       {expense.category:<14}       {expense.description:<24}       {expense.amount:<10}''')
            print(f"{'-----------------------------------------------------------------------------------------------'}")

    def categorize_expenses(self):
        categorized_expense = {}
        for expense in self.expenses:
            if expense.category not in categorized_expense:
                categorized_expense[expense.category] = expense.amount
            else:
                categorized_expense[expense.category] += expense.amount
        return categorized_expense      
    
    def summarize_expenses(self):
        total = 0
        for expense in self.expenses:
            total += expense.amount
        return total  
    
    def generate_summary_report(self):
        print(f'''
        YOUR EXPENSE SUMMARY 
-----------------------------------
        ''')
        print('''Money Spent for different categories\n''')
        category_summary = self.categorize_expenses()
        print(f'''{'Category Name':<20}         {'Amount Spent':<20}''')
        print(f'''--------------------------------------------''')
        for category, amount in category_summary.items():
            print(f'''{category:<20}        {amount:<20}''')
        print(f'''--------------------------------------------\n''')
        print(f'''Total Money Spent => $ {self.summarize_expenses()}''')
        
            
            
    def user_login(self):
        username = input('Enter your username: ')
        password = input('Enter your password: ')
        for user in users:
            if user['username'] == username and user['password'] == password:
                print(f"Login successful as user.")
                return True
            else:
                print("\nLogin Failed! Try Again!")
                return False
                    