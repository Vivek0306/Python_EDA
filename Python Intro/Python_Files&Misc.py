from datetime import datetime, date

print("Todays date: ", date.today())
print("Timestamp: ", datetime.now())


# Usage of datetime using an example

class Person:
    
    def __init__(self, name, contact, email, birthdate):
        self.name = name
        self.birthdate = birthdate
        self.email = email
        self.contact = contact
    
    def age(self):
        today = datetime.today()
        dob = datetime.strptime(self.birthdate, '%Y-%m-%d')
        if today.year - dob.year < 0:
            return "Invalid Birthdate Given"
        else:
            if dob.month < today.month:
                return f"Age is: {today.year - dob.year}" 
            else:
                return f"Age is: {today.year - dob.year - 1}" 

p = Person("Vivek", "2313123213", 'vivek@gmail.com', '2003-06-03')
print(p.age())


'''
File Handling

- If file already present use "r+" or "a" mode to open the file
- If not present and want to create a new file use "w" mode to open the file

'''

with open('newfile.txt', 'r+') as fw:
    print(fw.read())
    # text = input("Enter your text to add the file: ")
    # fw.writelines(text)
    ''' In order to read again you need to position the file cursor to the start of the file, hence we use seek to move the cursor to the start'''
    fw.seek(0)
    print(fw.read())
    
    data = fw.readlines()
    for line in data:
        print(line)
        
        
'''
List Comprehension
'''
marks = [90, 40, 56, 82, 30]

grades =  list(map(lambda mark: 'A' if mark >= 85 else 'B' if mark >= 70 else 'C' if mark >= 50 else 'D' if mark >= 35 else 'F', marks))
print(grades)
