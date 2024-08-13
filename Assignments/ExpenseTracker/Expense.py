from datetime import datetime

class Expense:
    def __init__(self, expense_id, date, category, description, amount):
        self.expense_id = expense_id
        self.date = datetime.strptime(date, '%d-%m-%Y').date()
        self.category = category
        self.description = description
        self.amount = amount
        
    def __str__(self):
        return f'''
        Your Expense Added:
        ID: {self.expense_id}
        Date: {self.date}
        Category: {self.category}
        Description: {self.description}
        Amount: ₹ {self.amount}
        '''