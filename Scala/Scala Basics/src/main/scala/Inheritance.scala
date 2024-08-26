class Animal (val name: String) {
  def makeSound(): Unit = {
    println(s"$name makes sound.......")
  }
}

class Dog(name: String) extends Animal(name) {
  override def makeSound(): Unit = {
    println(s"$name barks!!")
  }
}

object Inheritance extends App{


  val animal = new Animal("Gorilla")
  animal.makeSound()

  val dog = new Dog("Tommy")
  dog.makeSound()
}

