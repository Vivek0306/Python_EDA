class Employee(private var empname: String, private var salary:Float){
  // Data
  def setName(newEmpName: String): Unit = {
    if (newEmpName.nonEmpty) empname = newEmpName
  }

  // Method
  def setSalary(newSal: Int): Unit = {
    if (newSal > 0) salary = newSal
  }

  // getters
  def getName: String = empname
  def getSalary: Float = salary
}

object Encapsulation extends App{
  val emp1 = new Employee("Vivek", 212)
  emp1.setName("Jugal")
  emp1.setSalary(7890)
  println(s"Name: ${emp1.getName}, Age; ${emp1.getSalary}")
}
