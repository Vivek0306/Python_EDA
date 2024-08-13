'''

Access Modifiers:

Public, Protected and Private access modifiers

- Protected data members are declared using SINGLE underscores for variables and methods
- Private data members are declared using DOUBLE underscores for variables and methods

'''


class Employee:
    # Protected Variables
    _name = None
    _department = None
    # Private variables
    __id = None    
    def __init__(self, name, department, id):
        self._name = name
        self._department = department
        self.__id = id
        
    # Protected Methods
    def _display(self):
        print(f"Employee Name: {self._name}\nEmployeee Department: {self._department}")
        self.__displayID() # Can be accessed only from the same class
    
    # Private Methods
    def __displayID(self):
        print("Employee ID:", self.__id)
        
class EmployeeDetails(Employee):
    def __init__(self, name, department, id):
        super().__init__(name, department, id)
        
    def displayDetails(self):
        Employee._display(self)

    # Cannot access the private method of the parent class directly from the base class
    # ie __diplayIDs
        
emp = EmployeeDetails('Vivek', 'HR', 69)
emp.displayDetails()