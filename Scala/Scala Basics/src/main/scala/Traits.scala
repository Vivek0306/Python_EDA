/*
  Traits:
  A trait is a special type of class used to define collection of methods and field names that
  can be reused across different classes

https://assessments.yaksha.com/ust/account/test-taker/pre-assessment/NWJkY2UxODktMjE5MC00MWE5LWJiNTAtN2JiY2YzMzFmZDMyLzQzMg===
  Traits Usage:
  Code reusability in scala instead of duplicating code in

  Scala doesn't support multiple inheritance to fix this issue we use traits. A class can extend one class
  and mix it in multiple traits
*/

trait Drivable{
  def drive(): Unit
}
trait Flyable{
  def fly(): Unit = {
    println("Flying in the skies!")
  }
}
class Car1(val make: String, val model: String) extends Drivable{
  override def drive(): Unit = {
    println(s"The $make of model $model is driving along the road!")
  }
}


class Airplane(val make: String, val model: String) extends Drivable with Flyable {
  override def drive(): Unit = {
    println(s"The $make of model $model is taxing along the runway!")
  }

  override def fly(): Unit = {
    println(s"The $make of model $model is flying in the sky!")
  }
}

object Traits extends App{
  val cars = new Car1("Ferrari", "Spyder")
  val plane = new Airplane("Airbus", "A380")

  cars.drive()
  plane.drive()
  plane.fly()
}