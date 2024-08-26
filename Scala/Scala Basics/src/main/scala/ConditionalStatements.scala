object ConditionalStatements {
  def main(args: Array[String]): Unit = {
    // If Condition
    val x= 110
    if(x < 10){
      println(s"$x is lesser than 10")
    } else{
      println(s"$x is greater than 10")
    }

    val result = if (x % 2 == 0) "Even" else "Odd"
    println(result)

    // Ask user to input the data
    import scala.io.StdIn._
    print("Enter a value: ")
    val input = readLine()
    if (input == "y"){
      println("Yes")
    }
    else{
      println("No")
    }

    print("Enter your marks: ")
    val marks = readInt()
    if (marks > 90){
      println("Grade A")
    }else if(marks >= 80 && marks < 90){
      println("Grade B")
    }else if(marks >= 70 && marks< 80){
      println("Grade C")
    }else if(marks >= 60 && marks< 70){
      println("Grade D")
    }
    else{
      println("Grade F")
    }

    var grade_mark = if(marks > 90) "Grade A" else if (marks >= 80 && marks < 90) "Grade B" else "Grade C"
    println(grade_mark)

  }
}
