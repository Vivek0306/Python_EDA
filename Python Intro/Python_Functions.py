# User defined functions (UDF)

def greet():
    return "Hello my guy!"
print(greet())

# Lambda Functions
multiplier = lambda x : x * 2
print(multiplier(4))

# Map Function
mylist1 = [1,2 ,3, 4, 5, 6]
val = list(map(lambda x: x**2, mylist1))
print(val)

# Filter Function
val1 = list(filter(lambda x: x%2 == 0, mylist1))
print(val1)

import functools

# Reduce function
val2 = functools.reduce(lambda x, y:x-y, mylist1)
print(val2)


# Create a function and apply it on reduce() method to return the aggregate sales data

sales = [
            { 
            'product':'Laptop', 
            'amount': 50000
            }, 
            { 
            'product':'iPhone', 
            'amount': 150000
            },
            { 
            'product':'Smart TV', 
            'amount': 75000
            },
            { 
            'product':'Gaming Console', 
            'amount': 35000
            },
            { 
            'product':'Laptop', 
            'amount': 90000
            },
            { 
            'product':'iPhone', 
            'amount': 70000
            },
            { 
            'product':'Mouse', 
            'amount': 500
            }
        ]

print(f"Total Products Sold: {len(sales)}")


# Accumulate total sales revenue for each product
product = {}
def total_sales(prod):
    if prod['product'] not in product:
        product[prod['product']] = prod['amount']
    else:
        product[prod['product']] = product[prod['product']] + prod['amount']
        

      
# revenue = functools.reduce(aggregate_sales(prod1), sales)
for item in sales:
    total_sales(item)
print(product)
 

# Find top selling product and top-selling revenue
top = {"product": None, 'amount': 0}
max = None
for key, val in product.items():
    if max is None or val > max:
        max = val
        top['product'] = key
        top['amount'] = val
        
print(f"Product with most sales {top['product']} with revenue {top['amount']}")



# Using the reduce method
def accumulate(accumulator, transaction):
    product = transaction['product']
    amount = transaction['amount']
    accumulator[product] += amount
    return accumulator

from collections import defaultdict

'''
    reduce(function, iterable, initializer); Initializer - A Starting value used to initialize
    defaultdict() - subset of dictionary - to avoid KeyError
'''
# aggregate_sales = functools.reduce(accumulate, sales, defaultdict(int))
# top = max(aggregate_sales, key = aggregate_sales.get)
# print(aggregate_sales)




'''
*args and **kwargs
'''


def myfunc(*args):
    for arg in args:
        return f"Hello {arg[0]}, you are {arg[1]} years old"
    
print(myfunc(["Vivek", 22]))  

def myfunc2(**kwargs):
    for k, v in kwargs.items():
        print(f"Name: {k}, Age: {v}")
        
myfunc2(**{"Vivek": 18, "John": 19, "Ron": 20})