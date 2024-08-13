str1 = "Hello World"
# Reverse a String, using slicing
print(str1[::-1]) 

print(str1.find('World'))
print(str1.lower())

# String formatting
print("The start index of World in str1 is: {}".format(str1.find("World")))
print(f"The start index of World in str1 is: {str1.find("World")}")

# Join collections of strings or lists to create combined sentences
list1 = ["Hello", "world"]
print("".join(list1))

# Eliminate whitespaces from inputs suchs as emails and passwords the methods that it supports are strip, lstrip and rstrip
print("    HELLO WORLD      ".strip())

# Partition the string based on the delimeter passed to it
print(str1.rpartition(" "))


# LISTS AND ITS METHODS
list1 = ["Hello", "Python"]

# Shallow Copy - Copies only the values
list2 = list1.copy()

# Deep Copy - Copies by reference
list3 = list1

list1.append("!!")

print(list1)
print(list2)
print(list3)


list3.extend(['Python', 'Is', 'Great'])
print(list3)

'''
Tuples :
Tuples iterate faster than lists because tuple manages only single memory whereas list manages two memories
Static values wont change it would remain the same, ie they are immutable

Sets:
Sets are unordered collections of data. As its unordered it cannot be accessed using indexes.
'''

set1 = set()
set1 = {'a','b','c','d','c','c','b'}
set2 = {'a', 'b', 'c'}
set1.add('e')
print(set1.difference(set2))
print(set1.pop())

# Updates the set specified by the new set items
set1.update({'x','y','z'})
print(set1)

# Union of two sets containing elements in either of two set but not present in both.
print(set1.symmetric_difference(set2))


'''
DICTIONARY
'''
# Method - 1
dict1 = {}
dict1 = {
    'name': 'John',
    'age': 13,
    'gender': 'M'
}
dict2 = {}
cities = ['TVM', 'COK', 'BOM']
val = [1,2,3]

# Method - 2
dict2 = dict2.fromkeys(cities, 0)
dict2 = dict(zip(cities, val))
print(dict2)

# Method - 3
dict3 = dict([('TVM', 213), ('BOM', 689), ('COK', 431)])
print(dict3)

for index, item in enumerate(dict3.items()):
    print(index, item[0], item[1])