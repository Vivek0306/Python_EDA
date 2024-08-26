object DataStructures_2 {
  def main(args: Array[String]): Unit = {
    /*
    Map:
      Collection of key-value pairs. Map can be either mutable or immutable
      By default, it is immutable
    * */
    val fruitBasket: Map[String, Double] = Map("Apple" -> 1.20, "Banana" -> 0.50, "Cherry" -> 3.00, "Date" -> 2.50, "Elderberry" -> 4.00)

    // Mutable Maps
    import scala.collection.mutable
    val mutableMap = mutable.Map("Apple" -> 1.20, "Banana" -> 0.50, "Cherry" -> 3.00, "Date" -> 2.50, "Elderberry" -> 4.00)

    // Basic Operations
    println(mutableMap("Apple"))
    println(mutableMap.contains("Cherry"))
    println(mutableMap.size)

    // Keys and Values
    println(mutableMap.keys)
    println(mutableMap.values)

    // Adding and Removing
    mutableMap += ("Fig" -> 9.9)
    mutableMap -= ("Elderberry")
    mutableMap("Fig") = 10
    println(mutableMap.mkString(", "))

    /* Sets:
       No duplicate values.
       Sets can be mutable immutable
       By default they are immutable
    */
    val set1 = Set(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
    val set2 = Set("Cherry", "Oranges")

    // Basic Operations
    println(set1.contains(5))
    println(set2.contains("Apple"))

    println(set1.size)
    println(set1.isEmpty)
    println(set1 + 11)

    // Union of Sets
    val set3 = Set("Grapes", "Papaya", "Tomato", "Cherry", "Oranges")
    val fruitbasket = set2 union set3
    println(fruitbasket)

    // Intersect
    println(set2 intersect set3)

    // Difference
    println(set2 diff set3)

    // Subset check
    println(set2.subsetOf(set3))

    // Set Transformation - Map, Filter, Reduce
    println(set1.map(_ * 10).mkString(", "))
    println(set1.filter(_ * 10 < 50).mkString(", "))
    println(set1.reduce(_ + _))
    println(set3.map(_.toUpperCase))


    // Mutable Sets
    import scala.collection.mutable
    val set4 = mutable.Set(4, 5, 6, 7, 8, 9)
    set4 += 10
    set4 ++= Set(11, 12, 13)
    println(set4)

    // Clear a set
    set4.clear()


    // Create a New collection
    val fruitList = List("apple", "banana", "chocolate", "coconut", "apricot")
    val mapFruits = fruitList.groupBy(_.head)

     val newMapFruits : mutable.Map[Char, List[String]]  = mutable.Map(mapFruits.toSeq: _*)
     newMapFruits ++= Map('d' -> List("dragonfruit", "donuts"), 'e' -> List("eclairs"))
     println(newMapFruits)

    /*
      Tuple
      Fixed size, heterogenous, fixed size
    */
    var tuple1 = (1, "Hello World", 3.14, "Scala", 678909870L)
    println(tuple1._1)

    // Pattern matching in Tuple
    val (var1, var2, var3) = (1, "Scala", 3.14)

    // productArity: returns number of elements present in tuple
    println(tuple1.productArity)
    println(tuple1.size)

    // getClass is similar to type() that returns the datatype
    println(tuple1.getClass)

    // copy: allows us to copy tuple with some elements replaced
    val tuple2 = tuple1.copy(_1 = "Vivek")
    println(tuple2)

    tuple1.productIterator.foreach(
      element => println("Element: " + element)
    )
  }
}
