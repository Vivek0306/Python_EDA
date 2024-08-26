object NestedCaseClass{
  def main(args: Array[String]): Unit = {
    case class Employee(name: String, age: Int)
    case class Department(name: String, employee: List[Employee])

    val emp1 = Employee("Vivek", 89)
    val emp2 = Employee("Vinay", 18)
    val emp3 = Employee("Manju", 22)

    val dept1 = Department("HR", List(emp1, emp2))
    val dept2 = Department("IT", List(emp3))

    println(dept1)
    println(dept2)

    // Pattern matching with another case class
    dept1 match {
      case Department(name, employees) =>
        println(s"Department: $name")
        for(e <- employees){
          println(s"Emp Name: ${e.name}, Emp Age: ${e.age}")
        }
    }
    dept2 match {
      case Department(name, employees) =>
        println(s"Department: $name")
        employees.foreach{
          case Employee(name, age) => {
            println(s"Name: $name, Age: $age")
          }
        }
    }

  }
}
