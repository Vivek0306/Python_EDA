object DataStructures {
  def main(args: Array[String]): Unit = {
    val vals:List[String] = List("Apple", "Banana", "Mango")
    print(vals)

    vals.foreach(println)

    val emptyList: List[Nothing] = List()
  }
}
