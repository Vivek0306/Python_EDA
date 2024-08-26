// Define case class
// Case classes in scala are special kind of class that is used for
// modelling immutable data structures

/* case classes will automatically provide useful methods such as:
  toString, equals, hashCode, built-in support for pattern matching
*/
object CaseClass{
  def main(args: Array[String]): Unit = {
    case class Person(name: String, age: Int)
    val obj = Person("Vinay", 40)
    obj match {
      case Person(name, age) => println(s"Name: $name, Age: $age")
    }

    val olderObj = obj.copy(name = "Vivek")
    println(olderObj)
  }
}
