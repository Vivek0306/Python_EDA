class Shape{
  def area(): Double = 0.0
}

class Rectangle(val height:Double,val width: Double) extends Shape {
  override def area(): Double = height * width
}

class Triangle(val base:Double,val height: Double) extends Shape {
  override def area(): Double = 0.5 * base * height
}

object Polymorphism extends App{
  val shapes: List[Shape] = List(new Rectangle(10, 10), new Triangle(10, 2))
  shapes.foreach(
    shape => println(shape.area())
  )
}