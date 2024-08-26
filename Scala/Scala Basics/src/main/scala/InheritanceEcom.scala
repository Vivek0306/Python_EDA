class Ecommerce (val name: String, val quantity: Int, val price:Float){
  def displayDetails(): Unit = {
    println(s"PRODUCT:\nName: $name\nPrice: $price\nQuantity: $quantity")
  }
  def totalPrice(): Unit = {
    println(s"Total Price: ${quantity * price}")
  }
}

// Inheritance - Electronics
class Electronics (name: String, quantity: Int, price:Float)
  extends Ecommerce (name, quantity, price){
  override def displayDetails(): Unit = {
    println(s"\nELECTRONICS:\nName: $name\nPrice: $price\nQuantity: $quantity")
  }
}

// Inheritance - Books
class Books (name: String, quantity: Int, price:Float)
  extends Ecommerce (name, quantity, price){
  override def displayDetails(): Unit = {
    println(s"\nBOOKS:\nName: $name\nPrice: $price\nQuantity: $quantity")
  }
}
// Inheritance - Footwear
class Footwear (name: String, quantity: Int, price:Float)
  extends Ecommerce (name, quantity, price){
  override def displayDetails(): Unit = {
    println(s"\nFOOTWEAR:\nName: $name\nPrice: $price\nQuantity: $quantity")
  }
}

object InheritanceEcom extends App{
  val ecom = new Ecommerce("Brush", 2, 18.99)
  val electronic = new Electronics("iPhone",1, 599.99)
  val foot = new Footwear("Nike", 5, 599.99)
  val book = new Books("Wings of FIre", 2, 39.99)

  ecom.displayDetails()
  ecom.totalPrice()
  electronic.displayDetails()
  electronic.totalPrice()
  foot.displayDetails()
  foot.totalPrice()
  book.displayDetails()
  book.totalPrice()
}