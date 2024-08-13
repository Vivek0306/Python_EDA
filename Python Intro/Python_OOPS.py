import datetime
class Person:
    def __init__(self, *args):
        if len(args) >= 4:
            self.name = args[0]
            self.age= args[1]
            self.dob = args[2]
            self.email = args[3]
        else:
            raise ValueError("Not enough arguments passed")
    
    def __str__(self) -> str:
        return f"PERSON DETAILS\nName: {self.name}\nAge: {self.age}\nDOB: {self.dob}\nEmail ID: {self.email}"
        

p = Person('vivek', 18, '03-06-2003', 'vivek@gmail.com')
print(p)

# Inheritance

# Single Level Inheritance

class Vehicle:
    def __init__(self, brand, model, mileage):
        self.brand = brand
        self.model = model
        self.mileage = mileage

class Car(Vehicle):
    def __init__(self, brand, model, mileage, speed, color):
        super().__init__(brand, model, mileage)
        self.speed = speed
        self.color = color

    def __str__(self):
        return f'''
        VEHICLE INFO:
            BRAND: {self.brand}
            MODEL: {self.model}
            MILEAGE: {self.mileage}
            SPEED: {self.speed}
            COLOR: {self.color}
        '''
        
c = Car("BMW", "M5", "13km/l", "230km/h", "Black")
print(c)

'''
Multi-level Inheritance
'''
class GrandParents:
    def __init__(self, family_name):
        self.family_name = family_name
        
class Parents(GrandParents):
    def __init__(self, name, family_name):
        super().__init__(family_name)
        self.name = name 

class Child(Parents):
    def __init__(self, fname, mname, lname):
        super().__init__(mname, lname)
        self.fname = fname
        
    def __str__(self):
        return f"Hello, {self.fname} {self.name} {self.family_name}"
    
    
child = Child("Vivek", "Manojkumar", "Nair")
print(child)     
        
        
'''
Hierarchial Inheritance
'''

class Phone:
    def __init__(self, brand, model, color):
        self.brand = brand
        self.model = model
        self.color = color
        
class Android(Phone):
    def __init__(self, brand, model, color, os, version, cpu):
        super().__init__(brand, model, color)
        self.os = os
        self.version = version
        self.cpu = cpu
        
    def __str__(self):
        return f'''
            ANDROID PHONE:
            Brand: {self.brand}
            Model: {self.model}
            Color: {self.color}
            OS: {self.os}
            Version: {self.version}
            CPU: {self.cpu}            
        '''

class Apple(Phone):
    def __init__(self, brand, model, color, os, version, cpu):
        super().__init__(brand, model, color)
        self.os = os
        self.version = version
        self.cpu = cpu
        
    def __str__(self):
        return f'''
            APPLE PHONE:
            Brand: {self.brand}
            Model: {self.model}
            Color: {self.color}
            OS: {self.os}
            Version: {self.version}
            CPU: {self.cpu}            
        '''
        
android = Android('Samsung', 'S23', 'Black', 'Linux', 'v13.1', 'Snapdragon 765g')
apple = Apple('Apple', '15Pro', 'Blue', 'IOS', 'v17.6.1', 'A17')

print(android)
print(apple)



'''
Multiple Inheritance
'''

class Weapon:
    def __init__(self, weapon_name, weapon_damage):
        self.weapon_name = weapon_name
        self.weapon_damage = weapon_damage
        
class Spell:
    def __init__(self, spell_name, spell_damage):
        self.spell_name = spell_name
        self.spell_damage = spell_damage
        

class Character(Weapon, Spell):
    def __init__(self, character_name, character_type, weapon_name, weapon_damage, spell_name, spell_damage):
        Weapon.__init__(self,weapon_name, weapon_damage)
        Spell.__init__(self,spell_name, spell_damage)
        self.character_name = character_name
        self.character_type = character_type
        
    def __str__(self):
        return f'''
        CHARACTER INFO:
        Name: {self.character_name}
        Type: {self.character_type}
        Weapon: {self.weapon_name}
        Weapon Damage: {self.weapon_damage}
        Spell: {self.spell_name}
        Spell Damage: {self.spell_damage}
    '''
    
    
character = Character('John Snow', 'Warrior', 'Reaper', '130hp', 'Wingardium', '200hp')
print(character)

'''
Abstraction
'''

from abc import ABC, abstractmethod

class Operation(ABC):
    @abstractmethod
    def add(self, num1, num2):
        pass
    
class Add(Operation):
    def add(self, num1, num2):
        return num1+num2
    
add = Add()
print(add.add(8, 4))
    