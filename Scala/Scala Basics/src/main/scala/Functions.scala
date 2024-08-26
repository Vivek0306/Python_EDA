object Functions {
  def main(args: Array[String]): Unit = {
    def greetings(name: String): Unit = {
      println(s"Hello $name!")
    }
    import scala.io.StdIn._
    print("Enter your name: ")
    greetings("vivek")

    def add(a: Int, b: Int): Int = {
      return a+b
    }
    println(add(5, 5))

    def addString(a: Int, b: Int): Int = {
      return a + b
    }
    println(addString("5".toInt, "5".toInt))

    // Scala Function Calculator
    def calculator(a: Float, b: Float, op: String): Any = {
      if (op == "+"){
        return a + b
      } else if (op == "-"){
        return a -b
      } else if (op == "*"){
        return a * b
      } else if (op == "/"){
        if (b == 0){
          return "Cannot divide by zero"
        }
      }else{
        return "Invalid Operation"
      }
    }
    println(calculator(4, 4, "+"))
    println(calculator(14, 4, "-"))
    println(calculator(10, 4, "*"))
    println(calculator(10, 2, "/"))
    println(calculator(10, 0, "/"))
    println(calculator(10, 0, "?"))

    // Default Value
    def multiply(a: Int, b: Int = 1): Int = {
      return a * b
    }
    println(multiply(5))

    // Lambda / Anonymous Function
    val add1 = (a: Int, b: Int) => a+b
    println(add1(5, 10))

    // Hihger Order Functions: Functions that are passed as parameters to other functions
    def applyFunction(f: (Int, Int) => Int, value1: Int, value2: Int): Int = {
      f(value1, value2)
    }
    println(applyFunction(add, 5, 5))

    // Create a function that takes in a list and returns a list by eliminating the duplicate values
    import scala.collection.mutable
    def eliminateDuplicates(a: List[String]): List[String] = {
      return a.distinct
    }
    println(eliminateDuplicates(List("dog", "dog", "cat", "boar", "elephant", "elephant" )))

    // Palindrome
    def checkPalindrome(a: String): Boolean = {
      if (a.reverse == a){
        return true
      }else{
        return false
      }
    }
    println(if (checkPalindrome("DADDY")) "Palindrome" else "Not an Palindrome")


    // Create a recursive function to find factorial of a number
    def factorial(n: Int): Int = {
      if (n == 0) 1
      else n * factorial(n-1)
    }
    println(s"Factorial of 5: " + factorial(5))
  }
}
