object MatchCalculator{
  def main(args: Array[String]): Unit = {
    def calculator(a: Float, b: Float, op: String): Any = op match {
      case "+" => return a + b
      case "-" => return a - b
      case "*" => return a * b
      case "/" => if (b > 0) a / b else "Cannot divide by zero"
      case "^" => return Math.pow(a.toDouble, b.toDouble)
    }

    println(calculator(4, 4, "+"))
    println(calculator(14, 4, "-"))
    println(calculator(4, 4, "*"))
    println(calculator(24, 0, "/"))
    println(calculator(2, 2, "^"))

  }
}
