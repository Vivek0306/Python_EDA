import scala.util.boundary.break

object Loops {
  def main(args: Array[String]): Unit = {
    var vari = 1
    while (vari < 10){
      println(s"Variable -> $vari")
      vari+=1
    }

    // For Loop
    var fruits = List("Apple", "Banana", "Cherry", "Dragonfruit", "Eggplant")
    for (fruit <- fruits){
      print(s"$fruit ")
    }
    println("")
    for (i <- 1 to 10 by 2){
      print(s"$i ")
    }
    println("")

    import scala.collection.mutable
    val evenArray = mutable.ArrayBuffer[Int]()
    for (i <- 1 to 21 if i % 2 == 0) {
      evenArray += i
    }
    println(evenArray.mkString((", ")))

    // 2. Write s scala program to show collection of prime numbers between 1 and 100
    val primeList = mutable.ArrayBuffer[Int]()
    for (n <- 1 to 100){
      var isPrime = true
      for (i <- 2 to n/2){
        if (n % i == 0){
          isPrime = false
        }
      }
      if (isPrime  && n > 1){
        primeList += n
      }
    }
    println("Prime Numbers: " + primeList.mkString(", "))

    // 3. Fibonacci Series Using While Loop
    val fibSeries = mutable.ArrayBuffer[Int](0, 1)
    var n = 2
    while (n < 11){
      fibSeries += (fibSeries(n-2) + fibSeries(n-1))
      n += 1
    }
    println("Fibonacci: "+ fibSeries.mkString(", "))

    // 4. Find the first prime number greater than given user input
    import scala.io.StdIn._
    print("Enter user input: ")
    val userN = readInt()
    var k = 2
    var flag = 0
    while (k < 100 && flag != 1) {
      var isPrime = true
      var l = 2
      while (l < k / 2){
        if (k % l == 0) {
          isPrime = false
        }
        l += 1
      }
      if (isPrime && k > userN  ) {
        println(s"Prime number greater than $userN is $k")
        flag = 1
      }
      k += 1
    }

  }
}
