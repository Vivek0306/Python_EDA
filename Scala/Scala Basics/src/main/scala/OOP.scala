class Car(val make: String, val model: String, var year: Int){
  def displayInfo(): Unit = {
    println(s"Car Info: $year $make $model")
  }
}

object c extends App { // if no main function is written or used, 
  // extending App can be used to directly run the app without the main function
  val car = new Car("Hyundai", "Creta", 2024)
  car.displayInfo()
}